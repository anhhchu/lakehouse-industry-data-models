# Title_Insurance Lakehouse Data Model

**v1_mvm** generated using Vibe Modelling Agent on October 31, 2026 at 06:37 AM

This document outlines a vibed Lakehouse data model for the Title_Insurance business that can be deployed to Databricks Platform. The model is structured into business-aligned domains and denormalized data products, optimized for analytical workloads.

## Table of Contents

- [Output Folder Structure](#output-folder-structure)
- [Model Metrics](#model-metrics)
- [Business Summary](#business-summary)
- [Business Domains & Subdomains](#business-domains--subdomains)
  - [Operations](#domain-operations)
  - [Property](#domain-property)
  - [Recording](#domain-recording)
  - [Underwriting](#domain-underwriting)
  - [Agency](#domain-agency)
  - [Claim](#domain-claim)
  - [Settlement](#domain-settlement)
- [Metric Views](#metric-views)

## Output Folder Structure

All artifacts for version **v1_mvm** are organized as follows:

```
v1/mvm/
  schemas/          DDL SQL files (one per domain)
  metrics/          Metric view SQL files (one per domain)
  samples/          Sample data CSV files (one per data product)
  docs/             Excel workbook, model CSV, release notes
  diagram/          DBML schema
  vibes/            Current & next vibes context
  ontology/         RDF/Turtle ontology schema
  model.json        Full model with requirements, metadata, and model data
  readme.md         This file
```

| Folder | Contents |
|---|---|
| `schemas/` | `title_insurance_<domain>_schema_v1_mvm.sql` (combined per-domain SQL: schemas/databases + tables with inline PKs + FKs + tags) |
| `schemas/` | `title_insurance_catalogs_v1_mvm.sql` (catalog-level DDL) |
| `metrics/` | `title_insurance_<domain>_metrics_v1_mvm.sql` (one file per domain) |
| `docs/` | `title_insurance_model_v1_mvm.xlsx`, `title_insurance_model_v1_mvm.csv`, `releasenotes.txt` |
| `diagram/` | `title_insurance_dbml_v1_mvm.dbml` |
| `vibes/` | `current_vibes.txt`, `next_vibes.txt` |
| `/` | `model.json` (full model with requirements, metadata, and model data) |
| `ontology/` | `title_insurance_rdf_v1_mvm.rdf` |
| `samples/` | One CSV file per data product (e.g., `customer.csv`, `order.csv`) |

## Model Metrics
| Metric | Value |
|---|---|
| Model Scope | MVM (Minimum Viable Model) |
| Total Domains | 7 |
| Total Subdomains | 16 |
| Total Products | 67 |
| Total Attributes | 3533 |
| Primary Keys | 67 |
| Foreign Keys | 384 |
| Avg Attributes/Product | 52.7 |
| Metric Views | 67 |

## Business Summary
| Business | Industry Alignment | Model Scope | Description | References | Version |
|---|---|---|---|---|---|
| Title_Insurance | Title-Insurance | MVM (Minimum Viable Model) | A United States title-insurance and settlement-services business serving residential purchase, refinance, home-equity, construction, and selected commercial real-estate transactions. Services include title-order intake, title search and examination, curative processing, underwriting, commitments, owner and lender policies, endorsements, closing, settlement, escrow, recording, property information, independent-agent oversight, premium remittance, and claims administration. Business is produced through direct branches, centralized lender channels, and independent title agents. The model must preserve evidence, provenance, effective-dated ownership interests, lifecycle history, and the legal and operational distinctions among searches, examinations, findings, requirements, exceptions, commitments, policies, settlement statements, and escrow ledgers. | ALTA (American Land Title Association), State Departments of Insurance, NAIC (National Association of Insurance Commissioners), CFPB (Consumer Financial Protection Bureau), HUD (Department of Housing and Urban Development), County Recorder / Register of Deeds offices, FinCEN, IRS, GLBA, CCPA/CPRA, PCI DSS, SOX, SOC 2, MISMO | 1 |

## Business Domains & Subdomains

<a id="domain-operations"></a>

### Domain: Operations

| Domain | Division | Total Subdomains | Description | Total Products |
|---|---|---|---|---|
| operations | operations | 2 | Core operational backbone owning the title-production transaction spine: title-order intake and channel routing (direct branch, centralized lender, independent agent), order lifecycle and status tracking, transaction-type classification (purchase | 9 |

**Subdomains:** order_management, title_processing


**List of Data Products**

| Subdomain | Product | Data Type | Description | Total Attributes |
|---|---|---|---|---|
| order_management | order_channel | reference_data | Reference master classifying the origination and routing channels through which title orders are received and processed (direct branch, centralized lender, independent agent, consumer direct, wholesale). | 53 |
| order_management | order_status_history | transactional_data | Lifecycle history entity that preserves every status transition of a title order from intake through closing and post-closing. Captures prior status, new status, transition timestamp, triggering user or system, transition reason code, and any SLA | 48 |
| order_management | party | master_data | Master entity for every natural person or legal entity participating in a title transaction. Stores identity attributes (name, entity type, tax-ID reference, contact information, address) without embedding a role. | 50 |
| order_management | party_role | association_data | Association entity assigning a party (party_id) to a specific contextual role on a specific title_order, enabling one party to hold multiple simultaneous roles (e.g., buyer and borrower, or seller and trustee) per VREQ-006. | 46 |
| order_management | service_level | master_data | Reference/master entity defining service-level agreements and turn-time commitments applied to title orders by channel, transaction type, and product tier. | 55 |
| order_management | title_order | transactional_data | Core transaction spine for the operations domain. Represents a single title-insurance order from intake through closing, capturing transaction type (purchase, refinance, HELOC, construction, commercial), channel routing (direct branch, centralized lender | 51 |
| title_processing | operations_curative_action | transactional_data | Operational entity tracking each curative step taken to clear a title requirement or defect identified during examination. Captures the linked title requirement (owned by underwriting domain), curative action type (obtain release, record reconveyance | 57 |
| title_processing | operations_title_examination | transactional_data | Legally and operationally distinct entity representing the examiner's review and analysis of search results for a specific title order. Captures examiner identity, examination date, examination status (in-progress, complete, referred), overall title | 52 |
| title_processing | title_search | transactional_data | Legally and operationally distinct entity representing the execution of a title search against public records and the title plant for a specific order. Captures search type (full, update, O&E, two-owner, 30-year), search vendor or plant source (DataTrace | 57 |

<a id="domain-property"></a>

### Domain: Property

| Domain | Division | Total Subdomains | Description | Total Products |
|---|---|---|---|---|
| property | operations | 3 | Authoritative SSOT for real-property identity and reference data, modeled as three legally distinct entities: property, parcel, and legal_description. Owns APN/PIN identifiers, FIPS county codes, legal descriptions (metes-and-bounds, PLSS | 10 |

**Subdomains:** asset_registry, ownership_evidence, title_encumbrances


**List of Data Products**

| Subdomain | Product | Data Type | Description | Total Attributes |
|---|---|---|---|---|
| asset_registry | legal_description | master_data | Legally distinct entity capturing the full text and structured components of the property's legal description as it appears in recorded instruments and title commitments (Schedule A). | 52 |
| asset_registry | lifecycle_event | transactional_data | Transactional record capturing material lifecycle transitions and reclassifications for a property, parcel, or ownership interest per VREQ-007. Event types include: property type reclassification, parcel split/merge, legal description amendment, vesting | 58 |
| asset_registry | parcel | master_data | Legally distinct entity representing the assessor parcel as defined by the county recorder or assessor office. Owns the APN (Assessor's Parcel Number), PIN (Parcel Identification Number), FIPS county code, tax account number, acreage, lot dimensions, and | 54 |
| asset_registry | property | master_data | Authoritative SSOT master record for a real-property asset as a legally distinct entity separate from parcel and legal_description. Captures the property type (residential, commercial, condo, co-op, vacant land, construction), transaction type (purchase | 53 |
| asset_registry | tax_assessment | transactional_data | Annual or supplemental tax and assessment record for a parcel, sourced from the county assessor and tax collector. This product is the AUTHORITATIVE SSOT for year-by-year valuation and payment history; parcel carries only current/point-in-time summary | 51 |
| ownership_evidence | grantor_grantee_index | master_data | Index record linking a grantor party and a grantee party to a recorded instrument affecting a parcel or property, supporting grantor/grantee name-index searches as performed against the title plant and county recorder indices. | 53 |
| ownership_evidence | ownership_interest | master_data | Effective-dated ownership interest record representing a vested ownership stake in a property held by a party (individual, trust, entity, or co-owner). Implements VREQ-005: ownership is modeled as a set of time-bounded interest records supported by | 51 |
| ownership_evidence | title_evidence | transactional_data | Provenance and evidence record capturing each source document or data artifact used to establish or support an ownership interest, encumbrance, easement, survey/plat, or chain-of-title link. | 52 |
| title_encumbrances | easement_restriction | master_data | Master record for easements, rights-of-way (ROW), covenants, conditions and restrictions (CC&Rs), encroachments, and other use restrictions affecting a parcel. | 52 |
| title_encumbrances | encumbrance | master_data | Master record for each encumbrance, lien, or cloud on title affecting a parcel or property. Covers tax liens (federal, state, county), mechanics liens, judgment liens, HOA assessment liens, lis pendens (LP), deeds of trust (DOT), mortgages (PMM, HELOC | 57 |

<a id="domain-recording"></a>

### Domain: Recording

| Domain | Division | Total Subdomains | Description | Total Products |
|---|---|---|---|---|
| recording | operations | 3 | Manages post-closing document recording as legally distinct recording_submission and recorded_instrument entities. Owns submission to county recorders / registers of deeds via eRecording gateways, acceptance/rejection/resubmission workflows, recording | 9 |

**Subdomains:** instrument_registry, jurisdiction_reference, submission_management


**List of Data Products**

| Subdomain | Product | Data Type | Description | Total Attributes |
|---|---|---|---|---|
| instrument_registry | gap_coverage_period | transactional_data | Tracks the GAP coverage window for each title order — the legally significant interval between the closing date (or last search date) and the confirmed recording date of the insured instruments. | 52 |
| instrument_registry | recorded_instrument | master_data | Authoritative SSOT for each individual legal instrument (deed, deed of trust, mortgage, release, reconveyance, assignment, UCC, lis pendens, easement) accepted and stamped by the county recorder or register of deeds. | 55 |
| jurisdiction_reference | fee | reference_data | Reference master for county-level and instrument-type-level recording fee schedules maintained per jurisdiction (FIPS county code). Captures fee type (base recording fee, per-page fee, transfer tax, documentary stamp tax, mortgage tax, indexing fee), fee | 42 |
| jurisdiction_reference | jurisdiction | master_data | Master reference for every county recorder or register of deeds office that the business submits documents to. Captures FIPS county code, state, office name, recording office address, accepted submission channels (eRecording, mail, in-person), eRecording | 57 |
| submission_management | gateway_transaction | master_data | Transactional SSOT for each eRecording gateway exchange (Simplifile, CSC eRecording, ePN) associated with a recording_submission. Captures the gateway package identifier, gateway vendor, outbound submission acknowledgment (ACK/NACK), gateway pre-screen | 55 |
| submission_management | recording_submission | transactional_data | Authoritative SSOT for each document recording submission sent to a county recorder or register of deeds via an eRecording gateway (Simplifile, CSC eRecording) or physical delivery. | 51 |
| submission_management | rejection_event | transactional_data | Transactional SSOT for each discrete rejection notice returned for a recording submission or an individual submission_document, carrying an explicit grain flag (submission-level vs document-level). | 51 |
| submission_management | submission_document | transactional_data | Line-item entity representing each individual document within a recording_submission (e.g., a deed, deed of trust, release, and subordination agreement as separate documents), each with its own document type, page count, recording fee, execution date | 51 |
| submission_management | submission_status_history | transactional_data | Immutable lifecycle history table preserving every status transition for a recording_submission — from initial submission through any rejections, curative corrections, resubmissions, and final acceptance or recording confirmation. | 51 |

<a id="domain-underwriting"></a>

### Domain: Underwriting

| Domain | Division | Total Subdomains | Description | Total Products |
|---|---|---|---|---|
| underwriting | operations | 2 | Owns the title underwriting risk and policy lifecycle as legally distinct entities: title_finding, title_requirement (Schedule B-I), policy_exception (Schedule B-II), curative actions (CPM/GAPcure), underwriting referrals (UWR) and underwriting decisions | 10 |

**Subdomains:** policy_issuance, risk_assessment


**List of Data Products**

| Subdomain | Product | Data Type | Description | Total Attributes |
|---|---|---|---|---|
| policy_issuance | endorsement | transactional_data | Records each ALTA endorsement attached to an owner or lender title policy. Each record captures the endorsement form number (ALTA 9, ALTA 8.1, ALTA 22, ALTA 28, etc.), endorsement description, additional premium, effective date, and the parent | 49 |
| policy_issuance | title_commitment | transactional_data | SSOT for the title commitment instrument — the conditional promise to issue a title policy. Each record represents a distinct commitment version (initial issuance plus each revision/amendment), capturing Schedule A data (proposed insured, estate/interest | 53 |
| policy_issuance | title_policy | master_data | SSOT for issued title insurance policies. Owner (OTP) and lender (LTP) policies are stored as separate records with separate policy_type values, satisfying VREQ-010. | 58 |
| risk_assessment | curative_action | transactional_data | Tracks each discrete curative step taken to satisfy an open title_requirement or resolve a title_finding. Each record captures the action type (payoff request, lien release, affidavit of heirship, probate filing, survey correction, GAPcure, CPM memo | 47 |
| risk_assessment | decision | master_data | SSOT for discrete underwriting decisions and the AUTHORITATIVE insurable/marketable-title determination — the formal risk-acceptance determinations made by an underwriter, kept distinct from the uw_referral event that may trigger them and from the | 56 |
| risk_assessment | policy_exception | transactional_data | SSOT for Schedule B-II exceptions — matters that are excluded from coverage in the issued title policy. Each record identifies the exception type (easement, CC&R, ROW, HOA, survey matter, mineral rights, etc.), its source instrument, whether it is a | 49 |
| risk_assessment | title_finding | transactional_data | Authoritative SSOT for every defect, encumbrance, lien, cloud, or anomaly discovered during title examination. Each record captures the finding type (tax lien, judgment lien, mechanics lien, LP, UCC, easement, encroachment, chain-of-title break, vesting | 47 |
| risk_assessment | title_requirement | transactional_data | SSOT for Schedule B-I requirements — the curative actions that must be satisfied before a title commitment can be issued or a policy can be written. Each record links to the originating title_finding, specifies the required action (payoff, release | 52 |
| risk_assessment | underwriting_title_examination | transactional_data | SSOT for the title examination record — the formal examiner review of assembled search results that produces title_findings and drives title_requirements. Each record captures examiner identity, examination date, examination type (full, limited | 51 |
| risk_assessment | uw_referral | transactional_data | Tracks underwriting referral (UWR) events — the escalation of a title order or commitment to an underwriter for risk review. Each record captures the referral trigger (high-liability amount, complex defect, gap coverage, prior claim, commercial | 52 |

<a id="domain-agency"></a>

### Domain: Agency

| Domain | Division | Total Subdomains | Description | Total Products |
|---|---|---|---|---|
| agency | business | 2 | Owns the independent title-agent channel and distribution relationships: agent onboarding, licensing and E&O verification, agency-agreement and authority-level management, CPL issuance, ongoing oversight and compliance monitoring, premium remittance | 10 |

**Subdomains:** oversight_remittance, partner_management


**List of Data Products**

| Subdomain | Product | Data Type | Description | Total Attributes |
|---|---|---|---|---|
| oversight_remittance | agent_remittance | master_data | Transactional header record for a periodic premium remittance submitted by (or billed to) an independent title agent to the underwriter, representing the agency-settlement cycle. | 54 |
| oversight_remittance | cpl_issuance | transactional_data | Closing Protection Letter (CPL) issuance record representing a specific CPL issued by the underwriter on behalf of an independent title agent for a given transaction or lender. | 51 |
| oversight_remittance | oversight_review | transactional_data | Periodic compliance and performance oversight review record for an independent title agent, capturing review type (annual audit, random file review, E&O verification, licensing check, remittance audit), review date, reviewer identity, findings summary | 53 |
| oversight_remittance | remittance_line | master_data | Line-level detail of an agent_remittance, one row per policy/transaction premium being remitted. Captures source policy or order reference, policy type (owner/lender), gross premium, applied premium_split_schedule rate, computed underwriter share | 58 |
| partner_management | agent_authority | master_data | Effective-dated authority record defining the specific underwriting authority level granted to an independent title agent under an agency agreement, including authority tier (standard, limited, expanded, commercial), maximum insured amount, transaction | 50 |
| partner_management | agent_license | master_data | Effective-dated record of each state-issued title insurance producer or agent license held by an agent entity, including license number, state FIPS code, license class, issue date, expiration date, renewal date, and current status (active, suspended | 51 |
| partner_management | agent_profile | master_data | Master record and SSOT for every independent title agent (ITA), direct branch, and lender-channel partner in the distribution network. Captures agent identity, legal entity name, DBA, NAIC code, state license numbers, E&O carrier/policy references | 56 |
| partner_management | agreement | master_data | Formal agency agreement between the title underwriter and an independent title agent or direct branch, governing the scope of authority, geographic territory, transaction types, premium split schedule, remittance terms, and compliance obligations. | 54 |
| partner_management | eo_coverage | master_data | Errors and Omissions (E&O) insurance coverage record for an independent title agent, capturing carrier name, policy number, coverage effective date, expiration date, per-occurrence limit, aggregate limit, deductible, and verification status. | 50 |
| partner_management | premium_split_schedule | reference_data | Reference (non-transactional) schedule defining contractual agent/underwriter premium split rates for an agency agreement, segmented by transaction type (residential purchase, refinance, HELOC, commercial), policy type (owner OTP vs lender LTP), state | 48 |

<a id="domain-claim"></a>

### Domain: Claim

| Domain | Division | Total Subdomains | Description | Total Products |
|---|---|---|---|---|
| claim | business | 2 | Administers the full title-insurance claims lifecycle: FNOL intake, investigation, coverage analysis, reserving (case and IBNR), loss payment, recovery/subrogation, and claim closure. | 10 |

**Subdomains:** claim_administration, financial_settlement


**List of Data Products**

| Subdomain | Product | Data Type | Description | Total Attributes |
|---|---|---|---|---|
| claim_administration | claim_curative_action | transactional_data | Tracks each curative action taken to resolve a title defect or requirement identified during a claim investigation or pre-policy examination, including action type (lien release, deed correction, quiet title, probate, affidavit of heirship, reconveyance | 56 |
| claim_administration | claim_party | association_data | Association entity linking a party to a title claim in a specific contextual role (claimant, insured_owner, insured_lender, adverse_party, defense_counsel, plaintiff_counsel, expert_witness, adjuster, examiner, subrogation_target), with role effective | 49 |
| claim_administration | event | transactional_data | Immutable lifecycle-event log for a title claim, preserving every material status transition, coverage decision, assignment change, and reserve movement as a timestamped event record. | 48 |
| claim_administration | investigation | master_data | Master record for the investigation phase of a title claim, capturing investigation status (open, pending_docs, pending_legal, complete), assigned investigator, investigation start and completion dates, investigation findings narrative, documents | 60 |
| claim_administration | title_claim | master_data | Master record for every title-insurance claim filed against an issued OTP or LTP. Captures FNOL intake details, claim type (title defect, lien, encumbrance, encroachment, forgery, fraud, survey, access, etc.), coverage analysis outcome, policy linkage | 58 |
| financial_settlement | coverage_decision | master_data | First-class coverage determination record for a title claim, capturing the formal coverage position (covered, denied, partial, reservation_of_rights, excess_only), the policy provision or exclusion relied upon (Schedule A/B reference, exclusion number | 60 |
| financial_settlement | loss_payment | transactional_data | Transactional record of each indemnity disbursement made on a title claim, including payment type (indemnity, curative cost, defense cost, settlement, court-ordered), payee party, payment method (wire, check, ACH), payment amount, currency, payment date | 54 |
| financial_settlement | recovery_receipt | transactional_data | Transactional record of each recovery or subrogation receipt collected on a title claim, capturing recovery type (subrogation, contribution, salvage, reinsurance recovery), recovery source party, recovery amount, currency, receipt date, recovery method | 50 |
| financial_settlement | regulatory_loss_report | transactional_data | Periodic regulatory loss-reporting record submitted to NAIC and state Departments of Insurance, capturing reporting period, jurisdiction (state FIPS), report type (NAIC Annual Statement Schedule T, state DOI loss run, IBNR actuarial filing), total claims | 53 |
| financial_settlement | reserve | transactional_data | Effective-dated reserve record for a title claim, capturing case reserve and IBNR reserve amounts, reserve type (case, IBNR, bulk), currency, reserve basis (initial, revised, final), set-by underwriter or actuary, effective date, expiration date, and | 51 |

<a id="domain-settlement"></a>

### Domain: Settlement

| Domain | Division | Total Subdomains | Description | Total Products |
|---|---|---|---|---|
| settlement | business | 2 | Revenue-adjacent, customer-facing domain owning the closing and settlement lifecycle with settlement_statement and escrow_ledger kept as distinct, separate entities. | 9 |

**Subdomains:** closing_coordination, funds_management


**List of Data Products**

| Subdomain | Product | Data Type | Description | Total Attributes |
|---|---|---|---|---|
| closing_coordination | closing_document | master_data | Master record for each document executed or collected during the closing event (loan documents, deeds, affidavits, title affidavits, ALTA statements, 1099-S forms, transfer tax declarations, power of attorney, identity documents). | 56 |
| closing_coordination | closing_order | master_data | Master record for a closing/settlement engagement, representing the scheduling and coordination of a closing event tied to a title order. Tracks closing type (purchase, refinance, HELOC, construction), closing method (wet-sign, RON, IPEN, hybrid) | 61 |
| closing_coordination | premium_charge | transactional_data | Transactional record capturing the title insurance premium and related fee charges calculated and assessed at closing for a specific transaction. Tracks charge type (OTP owner title premium, LTP lender title premium, endorsement fee, search fee, exam fee | 53 |
| closing_coordination | settlement_statement | transactional_data | Legally and operationally distinct settlement statement record capturing the final financial accounting of a real estate closing. Stores statement form type (CD/Closing Disclosure, HUD-1, ALTA Settlement Statement), statement version and revision number | 58 |
| funds_management | disbursement | transactional_data | Individual disbursement record representing a single outgoing payment from the escrow trust account at or after closing. Captures disbursement type (payoff/reconveyance, seller proceeds, commission, recording fee, title premium, HOA assessment, tax | 53 |
| funds_management | escrow_ledger | transactional_data | Legally and operationally distinct escrow trust account ledger tracking every receipt and disbursement within the IOLTA/trust account for a specific closing. | 53 |
| funds_management | escrow_receipt | master_data | Individual incoming funds-received record representing a single deposit into the escrow/IOLTA trust account for a specific closing (EMD/earnest money receipt, loan proceeds wire-in, buyer cash-to-close, seller contribution, HOA/payoff overfund return). | 55 |
| funds_management | escrow_reconciliation | transactional_data | Periodic three-way reconciliation record for the escrow trust account, comparing the escrow ledger balance against the bank statement balance and the aggregate of open file balances. | 50 |
| funds_management | wire_instruction | master_data | Master record for wire transfer instructions associated with a closing party (seller, borrower, lender, payoff lender, HOA, commission recipient). Captures beneficiary name, bank name, ABA routing number, account number (encrypted/tokenized per NPPI | 49 |

## Metric Views

Total metric views generated: **67**. Showing top 20.

| # | View Name | Domain | Source Table | Description |
|---|---|---|---|---|
| 1 | agency_agent_authority | ti_agency | agent_authority | Agent Authority business metrics |
| 2 | agency_agent_license | ti_agency | agent_license | Agent License business metrics |
| 3 | agency_agent_profile | ti_agency | agent_profile | Agent Profile business metrics |
| 4 | agency_agent_remittance | ti_agency | agent_remittance | Agent Remittance business metrics |
| 5 | agency_agreement | ti_agency | agreement | Agreement business metrics |
| 6 | agency_cpl_issuance | ti_agency | cpl_issuance | Cpl Issuance business metrics |
| 7 | agency_eo_coverage | ti_agency | eo_coverage | Eo Coverage business metrics |
| 8 | agency_oversight_review | ti_agency | oversight_review | Oversight Review business metrics |
| 9 | agency_premium_split_schedule | ti_agency | premium_split_schedule | Premium Split Schedule business metrics |
| 10 | agency_remittance_line | ti_agency | remittance_line | Remittance Line business metrics |
| 11 | claim_claim_curative_action | ti_claim | claim_curative_action | Claim Curative Action business metrics |
| 12 | claim_claim_party | ti_claim | claim_party | Claim Party business metrics |
| 13 | claim_coverage_decision | ti_claim | coverage_decision | Coverage Decision business metrics |
| 14 | claim_event | ti_claim | event | Event business metrics |
| 15 | claim_investigation | ti_claim | investigation | Investigation business metrics |
| 16 | claim_loss_payment | ti_claim | loss_payment | Loss Payment business metrics |
| 17 | claim_recovery_receipt | ti_claim | recovery_receipt | Recovery Receipt business metrics |
| 18 | claim_regulatory_loss_report | ti_claim | regulatory_loss_report | Regulatory Loss Report business metrics |
| 19 | claim_reserve | ti_claim | reserve | Reserve business metrics |
| 20 | claim_title_claim | ti_claim | title_claim | Title Claim business metrics |

*... and 47 more metric views. See the `metrics/` folder for full details.*