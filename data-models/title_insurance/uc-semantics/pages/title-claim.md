---
title: Title Claim
domain: insurance
subdomain: title_insurance
topic: claims
owner: ${claims_owner}
synonyms:
  - claim
  - notice of claim
source_ids:
  - GDRIVE-005
  - GDRIVE-006
related_assets:
  - ${catalog}.claim.claim
  - ${catalog}.claim.claim_coverage_decision
---

# Title Claim

A title claim is a demand for coverage or performance under a title policy. It can concern an alleged defect, adverse interest, lien, fraud, boundary issue, access issue, instrument, or other covered matter.

## Business Rules

- A claim references at least one policy and claimant.
- Alleged loss, covered loss, and excluded loss remain distinct.
- Defense expense, indemnity, reserve, recovery, and subrogation are separate financial concepts.
- Preserve reopening and prior closure history.
- Link claims to relevant findings, evidence, instruments, underwriting decisions, and curative work when known.
