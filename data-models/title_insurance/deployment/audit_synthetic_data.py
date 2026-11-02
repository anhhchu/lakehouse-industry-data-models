import argparse
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "model-installer" / "tools"))
from audit_installed_samples import run_sql  # noqa: E402


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--catalog", required=True)
    parser.add_argument("--profile", required=True)
    parser.add_argument("--warehouse", required=True)
    parser.add_argument("--model", required=True)
    args = parser.parse_args()

    with open(args.model) as handle:
        metric_views = json.load(handle)["model"]["metric_views"]

    metric_results = []
    for start in range(0, len(metric_views), 15):
        chunk = metric_views[start:start + 15]
        sql = " UNION ALL ".join(
            "SELECT '%s' metric_view, MEASURE(`Row Count`) row_count FROM `%s`.`_metrics`.`%s`"
            % (view["view_name"], args.catalog, view["view_name"])
            for view in chunk
        )
        metric_results.extend(run_sql(sql, args.profile, args.warehouse))
    metric_failures = [(name, count) for name, count in metric_results if int(count) <= 0]

    distribution_sql = """
    SELECT 'order_status' check_name, order_status category, COUNT(*) row_count
      FROM `{catalog}`.`ti_operations`.`title_order` GROUP BY order_status
    UNION ALL
    SELECT 'order_county', county_name, COUNT(*)
      FROM `{catalog}`.`ti_operations`.`title_order` GROUP BY county_name
    UNION ALL
    SELECT 'rejection_status', rejection_status, COUNT(*)
      FROM `{catalog}`.`ti_recording`.`rejection_event` GROUP BY rejection_status
    UNION ALL
    SELECT 'claim_status', claim_status, COUNT(*)
      FROM `{catalog}`.`ti_claim`.`title_claim` GROUP BY claim_status
    UNION ALL
    SELECT 'policy_status', policy_status, COUNT(*)
      FROM `{catalog}`.`ti_underwriting`.`title_policy` GROUP BY policy_status
    """.format(catalog=args.catalog)
    distributions = run_sql(distribution_sql, args.profile, args.warehouse)

    lifecycle_sql = """
    SELECT 'title_order_actual_before_order' check_name, COUNT(*) failures
      FROM `{catalog}`.`ti_operations`.`title_order`
     WHERE actual_closing_date < order_date
    UNION ALL
    SELECT 'recording_before_submission', COUNT(*)
      FROM `{catalog}`.`ti_recording`.`recording_submission`
     WHERE recording_date < submission_date
    UNION ALL
    SELECT 'rejection_resolution_before_received', COUNT(*)
      FROM `{catalog}`.`ti_recording`.`rejection_event`
     WHERE resolution_timestamp < received_timestamp
    UNION ALL
    SELECT 'policy_issue_before_effective', COUNT(*)
      FROM `{catalog}`.`ti_underwriting`.`title_policy`
     WHERE issue_date < effective_date
    UNION ALL
    SELECT 'claim_closure_before_fnol', COUNT(*)
      FROM `{catalog}`.`ti_claim`.`title_claim`
     WHERE closure_date < fnol_date
    UNION ALL
    SELECT 'claim_investigation_close_before_start', COUNT(*)
      FROM `{catalog}`.`ti_claim`.`title_claim`
     WHERE investigation_close_date < investigation_start_date
    """.format(catalog=args.catalog)
    lifecycle = [(name, int(count)) for name, count in run_sql(
        lifecycle_sql, args.profile, args.warehouse
    )]

    print("metric views: %d executed, %d failed" % (len(metric_results), len(metric_failures)))
    print("distributions:")
    for check_name, category, row_count in distributions:
        print("  %s | %s | %s" % (check_name, category, row_count))
    print("lifecycle failures:")
    for check_name, failures in lifecycle:
        print("  %s=%d" % (check_name, failures))

    failed_lifecycle = [(name, count) for name, count in lifecycle if count]
    passed = not metric_failures and not failed_lifecycle
    print("VERDICT: %s" % ("PASS" if passed else "FAIL"))
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
