---
title: Closing
domain: insurance
subdomain: title_insurance
topic: settlement_and_escrow
owner: ${settlement_operations_owner}
synonyms:
  - settlement
source_ids:
  - GDRIVE-004
related_assets:
  - ${catalog}.ti_settlement.closing_order
  - ${catalog}.ti_settlement.settlement_statement
---

# Closing

Closing is the coordinated completion of documents, approvals, funding, signing, notarization, disbursement authorization, and recording readiness for a transaction.

## Business Rules

- Closing status is distinct from title-order status.
- Preserve scheduled, actual, cancelled, and rescheduled closing events.
- Retain every settlement-statement version.
- Funding, disbursement, signing, and recording readiness are separate milestones.
- A completed signing does not necessarily mean the transaction funded or recorded.
