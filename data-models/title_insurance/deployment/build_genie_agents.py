import hashlib
import json
from pathlib import Path


CATALOG = "serverless_stable_dvmvgw_catalog"
WAREHOUSE_ID = "e97542bc3b72cb1b"
PARENT_PATH = "/Workspace/Users/anhhoang.chu@databricks.com/title_insurance/genie"
OUTPUT_DIR = Path(__file__).resolve().parents[1] / "genie"

BENCHMARK_DIMENSIONS = {
    "operations_title_order": "County Name",
    "operations_title_search": "Is Sla Breached",
    "operations_operations_title_examination": "Examination Status",
    "property_title_evidence": "Evidence Type",
    "recording_recording_submission": "Last Rejection Reason Code",
    "recording_rejection_event": "County Name",
    "settlement_closing_order": "Closing Status",
    "settlement_settlement_statement": "Closing Method",
    "settlement_escrow_ledger": "Ledger Status",
    "settlement_escrow_receipt": "Funds Type",
    "settlement_disbursement": "Disbursement Status",
    "settlement_escrow_reconciliation": "Is Balanced",
    "underwriting_title_finding": "Finding Type",
    "underwriting_title_requirement": "Is Closing Condition",
    "underwriting_policy_exception": "Exception Status",
    "underwriting_title_commitment": "Commitment Status",
    "underwriting_uw_referral": "Liability Threshold Exceeded",
    "underwriting_title_policy": "Insured Type",
    "agency_agent_remittance": "Is Late",
    "agency_remittance_line": "Line Status",
    "claim_title_claim": "Claim Status",
    "claim_coverage_decision": "Decision Status",
    "claim_investigation": "Coverage Determination",
    "claim_reserve": "Reserve Status",
    "claim_loss_payment": "Payee Type",
    "claim_recovery_receipt": "Policy Type",
}


AGENTS = {
    "title_operations": {
        "title": "Title Insurance Operations",
        "description": "Title-order, search, evidence, recording, rejection, and operational-cycle analytics for title-insurance operations managers and analysts.",
        "metric_views": [
            "operations_title_order",
            "operations_title_search",
            "operations_operations_title_examination",
            "property_title_evidence",
            "recording_recording_submission",
            "recording_rejection_event",
        ],
        "questions": [
            "What is title-order volume by county, channel, and transaction type?",
            "Where are recording rejections concentrated and what reasons drive them?",
            "Which operating segments have the longest order-to-closing cycle?",
        ],
        "benchmarks": [
            (
                "Investigate the recording rejection spike and explain which counties, reasons, and order cohorts are most affected.",
                "Use multiple governed metric views, quantify the largest drivers, distinguish correlation from causation, and cite supporting query results.",
            ),
            (
                "Which title-order cohorts are experiencing closing delays, and what operational events are associated with those delays?",
                "Compare cohorts across county, channel, transaction type, and recording outcomes; provide quantified evidence and actionable follow-up.",
            ),
        ],
    },
    "settlement_escrow": {
        "title": "Title Insurance Settlement & Escrow",
        "description": "Closing readiness, settlement statements, escrow receipts, disbursements, reconciliation, and exception analytics for settlement teams.",
        "metric_views": [
            "settlement_closing_order",
            "settlement_settlement_statement",
            "settlement_escrow_ledger",
            "settlement_escrow_receipt",
            "settlement_disbursement",
            "settlement_escrow_reconciliation",
        ],
        "questions": [
            "How many closings are open, complete, or delayed?",
            "Which escrow files have the largest reconciliation differences?",
            "How do receipts and disbursements vary by closing cohort?",
        ],
        "benchmarks": [
            (
                "Identify the settlement and escrow cohorts with the greatest operational risk and explain why.",
                "Investigate closing status, ledger activity, receipts, disbursements, and reconciliation; rank risks with quantified evidence.",
            ),
            (
                "Which settlement files need immediate review for delayed closing or escrow exceptions?",
                "Use multiple governed sources, state selection criteria, quantify affected files and amounts, and provide prioritized follow-up actions.",
            ),
        ],
    },
    "underwriting_policy": {
        "title": "Title Insurance Underwriting & Policy",
        "description": "Title findings, requirements, exceptions, commitments, underwriting referrals, policy issuance, and agency-remittance analytics.",
        "metric_views": [
            "underwriting_title_finding",
            "underwriting_title_requirement",
            "underwriting_policy_exception",
            "underwriting_title_commitment",
            "underwriting_uw_referral",
            "underwriting_title_policy",
            "agency_agent_remittance",
            "agency_remittance_line",
        ],
        "questions": [
            "Which requirements and exceptions are most common?",
            "How long does policy issuance take by county and policy type?",
            "Which agents have late or mismatched remittances?",
        ],
        "benchmarks": [
            (
                "Explain what is driving policy-issuance delays and identify the most affected cohorts.",
                "Investigate findings, requirements, exceptions, referrals, commitments, and policy issuance; quantify primary drivers and affected cohorts.",
            ),
            (
                "Which underwriting and agency-remittance issues should management prioritize?",
                "Rank issues using governed measures, distinguish underwriting from remittance drivers, and support recommendations with multiple queries.",
            ),
        ],
    },
    "claims": {
        "title": "Title Insurance Claims",
        "description": "Claim frequency, severity, coverage, investigation, reserves, payments, recoveries, and closure analytics for claims leaders and analysts.",
        "metric_views": [
            "claim_title_claim",
            "claim_coverage_decision",
            "claim_investigation",
            "claim_reserve",
            "claim_loss_payment",
            "claim_recovery_receipt",
        ],
        "questions": [
            "What are claim frequency and severity by status, policy type, and cause?",
            "How do reserves, payments, and recoveries compare?",
            "Which open claims have the greatest financial exposure?",
        ],
        "benchmarks": [
            (
                "Investigate the largest drivers of title-claim exposure and recommend where claims leadership should focus.",
                "Use claim, coverage, investigation, reserve, payment, and recovery evidence; quantify exposure and rank drivers without exposing restricted details.",
            ),
            (
                "Which claim cohorts show unfavorable severity or recovery patterns, and what explains them?",
                "Compare policy type, cause, jurisdiction, status, and investigation outcomes; cite multiple supporting queries and explain limitations.",
            ),
        ],
    },
}


def stable_id(agent_key, category, index):
    value = "%s:%s:%s" % (agent_key, category, index)
    return hashlib.md5(value.encode("utf-8")).hexdigest()


def friendly_name(view_name):
    return view_name.replace("_", " ")


def benchmark_items(agent_key, metric_views):
    items = []
    for view_name in metric_views:
        identifier = "`%s`.`_metrics`.`%s`" % (CATALOG, view_name)
        dimension = BENCHMARK_DIMENSIONS[view_name]
        items.append(
            {
                "question": "How many %s records are in the governed metric view?" % friendly_name(view_name),
                "sql": "SELECT MEASURE(`Row Count`) AS row_count FROM %s" % identifier,
            }
        )
        items.append(
            {
                "question": "What is the %s record count by %s?" % (friendly_name(view_name), dimension.lower()),
                "sql": (
                    "SELECT `%s`, MEASURE(`Row Count`) AS row_count FROM %s "
                    "GROUP BY `%s` ORDER BY row_count DESC, `%s`"
                    % (dimension, identifier, dimension, dimension)
                ),
            }
        )
    return [
        {
            "id": stable_id(agent_key, "benchmark", index),
            "question": [item["question"]],
            "answer": [{"format": "SQL", "content": [item["sql"]]}],
            "evaluation_note": ["Result must match the governed metric-view query and retain the requested grouping."],
        }
        for index, item in enumerate(items[:10])
    ]


def example_items(agent_key, metric_views):
    examples = []
    for index, view_name in enumerate(metric_views[:3]):
        dimension = BENCHMARK_DIMENSIONS[view_name]
        identifier = "`%s`.`_metrics`.`%s`" % (CATALOG, view_name)
        examples.append(
            {
                "id": stable_id(agent_key, "example", index),
                "question": ["Show the top %s categories for %s." % (dimension.lower(), friendly_name(view_name))],
                "sql": [
                    "SELECT `%s`, MEASURE(`Row Count`) AS row_count FROM %s "
                    "GROUP BY `%s` ORDER BY row_count DESC LIMIT 10"
                    % (dimension, identifier, dimension)
                ],
                "usage_guidance": ["Use this shape for governed counts grouped by a business dimension."],
            }
        )
    return examples


def serialized_space(agent_key, spec):
    sample_questions = [
        {"id": stable_id(agent_key, "sample", index), "question": [question]}
        for index, question in enumerate(spec["questions"])
    ]
    benchmarks = benchmark_items(agent_key, spec["metric_views"])
    examples = example_items(agent_key, spec["metric_views"])
    text = (
        "## PURPOSE\n"
        "- Serve title-insurance operations managers and analysts using governed Unity Catalog metric views.\n\n"
        "## DISAMBIGUATION\n"
        "- Ask for clarification when a time period, jurisdiction, policy type, or operational cohort materially changes the answer.\n\n"
        "## CONSTRAINTS\n"
        "- Use governed measures from the attached metric views; do not invent KPI formulas.\n"
        "- Do not expose restricted bank, wire, identity, signature, tax, or non-public personal information.\n\n"
        "## Instructions you must follow when providing summaries\n"
        "- State the filters and date range used, quantify the result, and distinguish observed association from causal explanation."
    )
    return {
        "version": 2,
        "config": {"sample_questions": sorted(sample_questions, key=lambda item: item["id"])},
        "data_sources": {
            "metric_views": sorted(
                [
                    {"identifier": "%s._metrics.%s" % (CATALOG, view_name)}
                    for view_name in spec["metric_views"]
                ],
                key=lambda item: item["identifier"],
            )
        },
        "instructions": {
            "example_question_sqls": sorted(examples, key=lambda item: item["id"]),
            "text_instructions": [
                {"id": stable_id(agent_key, "instruction", 0), "content": [text]}
            ]
        },
        "benchmarks": {"questions": sorted(benchmarks, key=lambda item: item["id"])},
    }


def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    manifest = []
    for agent_key, spec in AGENTS.items():
        serialized = serialized_space(agent_key, spec)
        request = {
            "warehouse_id": WAREHOUSE_ID,
            "title": spec["title"],
            "description": spec["description"],
            "parent_path": PARENT_PATH,
            "serialized_space": json.dumps(serialized, separators=(",", ":")),
        }
        output_path = OUTPUT_DIR / (agent_key + ".create.json")
        output_path.write_text(json.dumps(request, indent=2) + "\n")
        update_path = OUTPUT_DIR / (agent_key + ".update.json")
        update_path.write_text(json.dumps({"serialized_space": request["serialized_space"]}, indent=2) + "\n")
        manifest.append(
            {
                "agent_key": agent_key,
                "title": spec["title"],
                "request_file": str(output_path.relative_to(ROOT)),
                "metric_view_count": len(spec["metric_views"]),
                "benchmark_mode": "agent",
            }
        )
    (OUTPUT_DIR / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")


ROOT = Path(__file__).resolve().parents[3]


if __name__ == "__main__":
    main()
