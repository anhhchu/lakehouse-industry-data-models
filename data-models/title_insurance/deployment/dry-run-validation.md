# Title Insurance Dry-Run Validation

## Run

- Job run: `647245575063833`
- Task run: `1124137829030178`
- Result: `TERMINATED / SUCCESS`
- Duration: 5,336 seconds
- Agent: `5.3.3`
- AI calls already completed: 301
- Estimated dry-run AI cost recorded by the artifact: $74.12

## Final Artifact Checks

Validation is based on the final `v1/mvm/model.json`, not the earlier static-analysis snapshot written to `vibes/next_vibes.txt` and `docs/releasenotes.txt`.

| Check | Result |
|---|---:|
| Domains | 7 |
| Products | 67 |
| Attributes | 3,533 |
| Metric views | 67 |
| Primary keys missing | 0 |
| Unlinked non-PK `_id` columns | 0 |
| Foreign keys | 392 |
| Missing FK targets | 0 |
| FK/PK type mismatches | 0 |
| Products missing subdomains | 0 |

The dry-run notes reported seven unlinked IDs and six FK type mismatches from an intermediate snapshot. Those findings do not reproduce against the final artifact. The cited relationships are either absent after refinement or present with valid targets and matching types. Do not run another AI modeling pass solely to address those stale findings.

## Materialization Strategy

Use the standalone installer against:

`/Volumes/serverless_stable_dvmvgw_catalog/_metamodel/vol_root/business/title_insurance/v1/mvm`

This executes the saved schema and metric SQL, registers the saved `model.json`, and optionally generates samples after structural installation. It does not regenerate the logical model or repeat the 301 AI calls.

Recommended installer parameters:

```text
operation=Install
model=title_insurance
model_size=mvm
catalog_name=serverless_stable_dvmvgw_catalog
cataloging_style=One Catalog
local_install=/Volumes/serverless_stable_dvmvgw_catalog/_metamodel/vol_root/business/title_insurance/v1/mvm
generate_samples=Yes
sample_rows=10
```

Keep UC Semantics Pages and Genie deployment disabled until the physical install and post-install row/count audit pass.
