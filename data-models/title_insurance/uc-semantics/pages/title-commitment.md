---
title: Title Commitment
domain: insurance
subdomain: title_insurance
topic: underwriting_and_policy
owner: ${underwriting_owner}
synonyms:
  - commitment
  - preliminary report
source_ids:
  - GDRIVE-002
  - GDRIVE-006
related_assets:
  - ${catalog}.ti_underwriting.title_commitment
  - ${catalog}.ti_underwriting.title_requirement
  - ${catalog}.ti_underwriting.policy_exception
---

# Title Commitment

A title commitment is a conditional offer to issue title insurance after stated requirements are satisfied and subject to stated exceptions. It identifies proposed insured parties, the proposed insured estate or interest, proposed policy amounts, requirements, and exceptions.

A commitment is an underwriting output, not an ownership-history record. It can describe the estate or interest derived from examination of the chain of title, but it does not represent the chronological succession of owners or instruments.

## Business Rules

- A commitment is distinct from a title search and an issued title policy.
- Preserve the first commitment and every revision.
- Requirements and exceptions are separate related records.
- A revision must record its effective timestamp and reason.
- A final policy can differ from the latest commitment, but differences must be explainable.

## Common Uses

- Measure order-to-first-commitment cycle time.
- Compare revisions and identify newly introduced findings.
- Trace final policy coverage back to proposed coverage.
