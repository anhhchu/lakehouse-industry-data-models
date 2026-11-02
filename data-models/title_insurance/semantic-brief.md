# Title Insurance Semantic Brief

## Company Overview and Segments

The business provides title insurance, title search and examination, closing and settlement, escrow, recording, and property-information services in the United States. It serves residential purchase, refinance, home-equity, construction, and commercial real-estate transactions. The operating model includes direct operations and independent title agents working under delegated authority. The model must distinguish direct and agency business without fragmenting shared definitions of property, parcel, party, title evidence, commitment, policy, premium, and claim.

## Distribution and Service Channels

Orders originate from lenders, real-estate professionals, buyers, sellers, attorneys, builders, centralized lender channels, direct branches, and independent agents. A channel affects intake, service-level commitments, pricing, examination responsibility, closing responsibility, policy issuance authority, premium remittance, and quality controls. The model must preserve the originating channel, servicing branch or agent, responsible underwriter, and any handoff between centralized and local operations.

## Core Business Processes

### Title Order Intake

A title order is opened for a transaction and can concern one or more properties and parcels. Intake captures the transaction purpose, requested products, parties, lender, loan, property, jurisdiction, due dates, service channel, and originating source. An order can be amended, cancelled, reopened, transferred, or split. All material state transitions must be retained with effective timestamps and reasons.

### Search and Examination

A title search collects deeds, mortgages, liens, judgments, easements, restrictions, taxes, court records, probate records, and other evidence from recording jurisdictions and approved data providers. A search package can combine multiple searches, updates, and bring-downs. A title examiner reviews the evidence, establishes the apparent chain of title, and creates findings. Each finding must retain its evidence, affected property or parcel, affected parties, priority, disposition, and examiner rationale.

### Requirements, Exceptions, and Curative Work

A finding can produce a requirement, exception, informational item, or escalation. Requirements describe conditions that must be satisfied, waived, or otherwise dispositioned before closing or policy issuance. Exceptions describe matters excluded from coverage and must not be conflated with requirements. Curative work records actions taken to resolve defects, obtain releases, correct instruments, address vesting issues, or satisfy underwriting conditions. The complete history must remain available after resolution.

### Commitment and Underwriting

A title commitment is a conditional offer to issue coverage after stated requirements are satisfied and subject to stated exceptions. A commitment can have multiple revisions. Underwriting decisions record the issue reviewed, authority level, decision, conditions, approver, and supporting evidence. Commitment, preliminary report, pro forma, and policy are distinct concepts even when local terminology overlaps.

### Closing, Settlement, and Escrow

A closing coordinates documents, approvals, funds, signatures, notarization, payoff, disbursement, and recording. A settlement statement presents transaction charges and credits, while the escrow ledger records actual receipts, disbursements, adjustments, and balances. These must remain separate. Escrow funds must reconcile to bank activity and the general ledger. Wire instructions and bank-account information are restricted data and require change verification and fraud controls.

### Recording and Post-Closing

Documents are submitted to the appropriate recording jurisdiction electronically, physically, or through a recording service. Submission, rejection, correction, resubmission, acceptance, instrument numbering, and recording confirmation are events. Document effective date, execution date, submission date, and recording date are separate. Post-closing work tracks trailing documents, recording confirmation, final package completion, and unresolved exceptions.

### Policy Issuance and Premium

An order can result in an owner policy, lender policy, or both, with endorsements. Owner and lender coverage must remain separate. A policy records insured parties, insured estate or interest, covered property, policy amount, effective date, exceptions, endorsements, issuing agent, underwriter, premium, and status. Independent agents report issued policies and remit premium according to agency agreements. Adjustments, cancellations, voids, refunds, and remittance differences must be traceable.

### Claims

A claim is made against a policy and can concern a title defect, adverse interest, lien, document, fraud, boundary issue, access issue, or other covered matter. Claims track notice, coverage evaluation, investigation, litigation, reserves, expenses, payments, recoveries, subrogation, disposition, and closure. The model must distinguish alleged loss, covered loss, excluded loss, defense expense, indemnity, and recovery.

## Participants and Roles

The same party can hold multiple roles across transactions. Relevant roles include buyer, seller, borrower, lender, loan servicer, owner, grantor, grantee, beneficiary, trustee, attorney, real-estate professional, title agent, escrow officer, closer, examiner, underwriter, notary, search vendor, recording jurisdiction, taxing authority, claimant, payee, and service provider. Roles are contextual and effective-dated; they must not be encoded as mutually exclusive party types.

## Industry Vocabulary

title order, title search, search package, title plant, title examination, chain of title, vesting, ownership interest, recorded instrument, deed, mortgage, deed of trust, lien, judgment, easement, restriction, encumbrance, defect, requirement, exception, curative action, bring-down, date-down, commitment, preliminary report, pro forma, owner policy, lender policy, endorsement, insured estate, settlement statement, escrow ledger, payoff, disbursement, recording package, e-recording, instrument number, book and page, recording jurisdiction, agency remittance, underwriter, delegated authority, claim reserve, indemnity, recovery.

## Systems of Record

The demo assumes separate systems for title order and workflow, title plant and public-record evidence, document management, escrow and settlement, policy administration, agency reporting, claims administration, customer and party master data, banking, general ledger, and analytics. The model must retain source-system identifiers and record provenance without allowing source-specific structures to define the business ontology.

## Regulatory, Governance, and Privacy Context

The model must support applicable state departments of insurance, title-insurance rate and form requirements, state recording laws, escrow and trust-account controls, unclaimed-property requirements, consumer privacy obligations, GLBA safeguards, OFAC screening, anti-fraud controls, and financial reporting. Personally identifiable information, bank data, wire instructions, identity documents, signatures, tax identifiers, and non-public personal information require restricted classification. Retention and legal-hold requirements must be expressible by record category and jurisdiction.

## Proposed Data Domains

- party
- title_order
- property
- title_evidence
- underwriting
- settlement
- escrow
- recording
- policy
- agency
- billing_and_premium
- claim
- compliance
- shared_reference

## Required Business Questions

- What is title-order volume by transaction purpose, channel, branch, agent, lender, and jurisdiction?
- What are median and percentile order-to-search, order-to-commitment, commitment-to-close, and close-to-policy cycle times?
- Which open requirements are delaying scheduled closings?
- Which defect and encumbrance categories require the most curative work?
- What percentage of recording packages are rejected, and for what reasons?
- Which escrow files are out of balance or have aged outstanding checks?
- How long after recording are owner and lender policies issued?
- Which agents have late policy reporting or premium-remittance differences?
- What are claim frequency, severity, reserve development, expense, and recovery by policy type, defect category, jurisdiction, agent, and underwriting decision?
- Which source systems and documents support each title finding, requirement, exception, and underwriting decision?

## Required Modeling Rules

- Keep title order, title search, title examination, commitment, and policy separate.
- Keep requirement and exception separate.
- Keep settlement-statement presentation and escrow-ledger activity separate.
- Preserve all lifecycle transitions and revisions; do not overwrite material history.
- Model ownership as effective-dated interests supported by evidence, not as a single current-owner field.
- Separate document execution, effective, submission, acceptance, and recording dates.
- Model party roles contextually so one party can hold multiple roles.
- Require evidence and provenance for findings and material underwriting decisions.
- Classify bank, wire, identity, signature, tax, and non-public personal information as restricted.

## Open Questions for Subject-Matter Review

- Which jurisdictions and transaction types are in the initial demo scope?
- Should commercial transactions be included in the MVM or deferred to the ECM?
- Which party-resolution and property-resolution rules are considered authoritative?
- Which commitment and policy forms should the demo represent?
- Which agency reporting and remittance workflows are essential for the first release?
- Which KPIs have contractual service-level definitions rather than analytical approximations?

