import argparse
import json
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "model-installer" / "tools"))
from audit_installed_samples import run_sql  # noqa: E402


def validate(path, profile, warehouse):
    request = json.loads(path.read_text())
    serialized = json.loads(request["serialized_space"])
    checks = []
    for benchmark in serialized["benchmarks"]["questions"]:
        checks.append((path.name, "benchmark", benchmark["id"], benchmark["answer"][0]["content"][0]))
    for example in serialized["instructions"]["example_question_sqls"]:
        checks.append((path.name, "example", example["id"], example["sql"][0]))

    failures = []
    with ThreadPoolExecutor(max_workers=8) as executor:
        futures = {
            executor.submit(run_sql, sql, profile, warehouse): (file_name, kind, item_id)
            for file_name, kind, item_id, sql in checks
        }
        for future in as_completed(futures):
            file_name, kind, item_id = futures[future]
            try:
                future.result()
            except BaseException as error:
                failures.append((file_name, kind, item_id, str(error)))
    return len(checks), failures


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--directory", required=True)
    parser.add_argument("--profile", required=True)
    parser.add_argument("--warehouse", required=True)
    args = parser.parse_args()
    total = 0
    failures = []
    for path in sorted(Path(args.directory).glob("*.create.json")):
        count, path_failures = validate(path, args.profile, args.warehouse)
        total += count
        failures.extend(path_failures)
    print("validated SQL: %d" % total)
    for failure in failures:
        print("FAILED %s %s %s: %s" % failure)
    print("VERDICT: %s" % ("PASS" if not failures else "FAIL"))
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
