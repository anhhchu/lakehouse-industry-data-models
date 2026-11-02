# Closing and Escrow Procedure

## Closing File

A closing file coordinates scheduled closing, participants, documents, approvals, settlement-statement versions, funding authorization, signing completion, notarization, disbursement authorization, and recording readiness. Closing status and title-order status are related but distinct.

## Settlement Statement

The settlement statement is a presentation of charges, credits, prorations, payoffs, deposits, loan proceeds, and cash due. Versions must be retained. A settlement line can be allocated among parties and linked to its business purpose.

## Escrow Ledger

The escrow ledger records actual receipts, disbursements, adjustments, reversals, returned items, stop payments, and balances. It must not be reconstructed solely from the settlement statement. Every ledger entry identifies the escrow file, transaction type, amount, effective timestamp, bank reference when applicable, payor or payee, and authorization.

## Reconciliation Rule

For a closed accounting period, receipts minus disbursements minus the remaining ledger balance must equal zero after approved adjustments. Differences are exceptions requiring ownership, aging, investigation, and resolution.

## Wire and Fraud Controls

Wire instructions, bank-account details, verification evidence, identity documents, and authentication events are restricted. Changes to wire instructions require independent verification. The model should record verification events and outcomes without exposing sensitive values to general analytical users.

## Recording Package

A recording package can contain multiple documents. Track preparation, quality review, submission, rejection, correction, resubmission, acceptance, and confirmation for each document and the package. A package is complete only when all required documents reach an approved terminal disposition.

## Demonstration Edge Cases

- A wire receipt is reversed and replaced.
- A payoff check remains outstanding beyond the control threshold.
- The settlement statement is revised after funding.
- One document in a multi-document package is rejected.
- A recording fee differs from the estimated settlement charge.

