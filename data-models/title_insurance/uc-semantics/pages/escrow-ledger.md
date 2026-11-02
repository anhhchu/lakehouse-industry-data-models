---
title: Escrow Ledger
domain: insurance
subdomain: title_insurance
topic: settlement_and_escrow
owner: ${settlement_operations_owner}
synonyms:
  - trust ledger
  - escrow accounting ledger
source_ids:
  - GDRIVE-004
  - GDRIVE-006
  - GDRIVE-007
related_assets:
  - ${catalog}.ti_settlement.escrow_ledger
  - ${catalog}.ti_settlement.escrow_reconciliation
---

# Escrow Ledger

The escrow ledger is the accounting record of actual receipts, disbursements, adjustments, reversals, returned items, stop payments, and remaining balances for an escrow file.

## Business Rules

- The escrow ledger is distinct from the settlement statement.
- Every entry records amount, direction, effective timestamp, transaction type, authorization, and payor or payee.
- Reversals and corrections reference the original entry rather than replacing it.
- Bank references and sensitive payment details receive restricted treatment.
- For a closed accounting period, receipts minus disbursements minus remaining balance must equal zero after approved adjustments.

## Common Uses

- Identify out-of-balance files.
- Track outstanding checks and returned funds.
- Reconcile settlement activity to bank transactions and the general ledger.
