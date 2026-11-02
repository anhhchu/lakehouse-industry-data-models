---
title: Title Requirement
domain: insurance
subdomain: title_insurance
topic: title_operations
owner: ${title_operations_owner}
synonyms:
  - requirement
  - condition
source_ids:
  - GDRIVE-003
  - GDRIVE-006
related_assets:
  - ${catalog}.ti_underwriting.title_requirement
  - ${catalog}.ti_underwriting.title_finding
---

# Title Requirement

A title requirement is a condition that must be satisfied, waived, withdrawn, superseded, or otherwise dispositioned before closing or policy issuance.

A requirement is a remediable underwriting or closing condition, not an ownership-history record. It can arise from a gap or defect found in the chain of title, but it tracks the condition, responsible party, disposition, and satisfaction evidence.

## Business Rules

- A requirement is distinct from a policy exception.
- A requirement must trace to its finding, evidence, or underwriting condition.
- Preserve every status, responsible party, due date, disposition, and supporting satisfaction evidence.
- Resolution does not delete the requirement or its history.
- Waiver requires the responsible authority and decision evidence.

## Common Uses

- Identify requirements delaying closing.
- Measure requirement aging and curative workload.
- Verify that commitment and policy prerequisites were addressed.
