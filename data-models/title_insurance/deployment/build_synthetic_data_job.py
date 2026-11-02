import argparse
import json
import re
import sys


NOTEBOOK_PATH = "/Workspace/Users/anhhoang.chu@databricks.com/title_insurance/synthetic/generate_synthetic_data_job"
CATALOG = "serverless_stable_dvmvgw_catalog"
MODEL_PATH = "/Volumes/serverless_stable_dvmvgw_catalog/_metamodel/vol_root/business/title_insurance/v1/mvm/model.json"


def task_key(domain_name, table_name):
    value = re.sub(r"[^a-zA-Z0-9_]", "_", "%s__%s" % (domain_name, table_name))
    return value[:100]


def strongly_connected_components(nodes, parents):
    index = 0
    indices = {}
    lowlinks = {}
    stack = []
    on_stack = set()
    components = []

    def visit(node):
        nonlocal index
        indices[node] = index
        lowlinks[node] = index
        index += 1
        stack.append(node)
        on_stack.add(node)
        for parent in parents[node]:
            if parent not in indices:
                visit(parent)
                lowlinks[node] = min(lowlinks[node], lowlinks[parent])
            elif parent in on_stack:
                lowlinks[node] = min(lowlinks[node], indices[parent])
        if lowlinks[node] == indices[node]:
            component = set()
            while True:
                member = stack.pop()
                on_stack.remove(member)
                component.add(member)
                if member == node:
                    break
            components.append(component)

    for node in sorted(nodes):
        if node not in indices:
            visit(node)
    return components


def build_job(model, selected_tables=None):
    products = [
        (domain, product)
        for domain in model["model"]["domains"]
        for product in domain["products"]
    ]
    available = {
        (domain["name"], product["table_name"])
        for domain, product in products
    }
    parents_by_table = {table: set() for table in available}
    for domain, product in products:
        current = (domain["name"], product["table_name"])
        for attribute in product["attributes"]:
            foreign_key = attribute.get("foreign_key_to")
            if foreign_key:
                parent_domain, parent_table, _ = foreign_key.split(".")
                parent = (parent_domain, parent_table)
                if parent in available and parent != current:
                    parents_by_table[current].add(parent)
    components = strongly_connected_components(available, parents_by_table)
    component_by_table = {
        table: component_index
        for component_index, component in enumerate(components)
        for table in component
    }
    selected_tables = set(selected_tables or available)
    unknown = selected_tables - available
    if unknown:
        raise ValueError("Unknown tables: %s" % sorted(unknown))
    tasks = []
    for domain, product in products:
        current = (domain["name"], product["table_name"])
        if current not in selected_tables:
            continue
        parents = {
            parent
            for parent in parents_by_table[current]
            if parent in selected_tables and component_by_table[parent] != component_by_table[current]
        }
        task = {
            "task_key": task_key(domain["name"], product["table_name"]),
            "notebook_task": {
                "notebook_path": NOTEBOOK_PATH,
                "source": "WORKSPACE",
                "base_parameters": {
                    "catalog": CATALOG,
                    "model_path": MODEL_PATH,
                    "order_count": "10000",
                    "months": "24",
                    "seed": "20261102",
                    "table_key": "%s.%s" % (domain["name"], product["table_name"]),
                },
            },
            "environment_key": "default",
        }
        if parents:
            task["depends_on"] = [
                {"task_key": task_key(parent_domain, parent_table)}
                for parent_domain, parent_table in sorted(parents)
            ]
            task["run_if"] = "ALL_SUCCESS"
        tasks.append(task)
    return {
        "run_name": "title_insurance_native_spark_%s" % ("layered" if selected_tables == available else "repair"),
        "timeout_seconds": 7200,
        "performance_target": "STANDARD",
        "tasks": tasks,
        "environments": [
            {
                "environment_key": "default",
                "spec": {"environment_version": "4", "dependencies": []},
            }
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("model")
    parser.add_argument("--tables", help="Comma-separated domain.table keys")
    args = parser.parse_args()
    with open(args.model) as handle:
        model = json.load(handle)
    selected = None
    if args.tables:
        selected = {tuple(value.strip().split(".", 1)) for value in args.tables.split(",")}
    json.dump(build_job(model, selected), sys.stdout, indent=2)
    print()


if __name__ == "__main__":
    main()
