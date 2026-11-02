-- Schema for Domain: settlement | Business: Title_Insurance | Version: v1_mvm
-- Generated on: 2026-10-31 06:39:31

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `serverless_stable_dvmvgw_catalog`.`ti_settlement` COMMENT 'Revenue-adjacent, customer-facing domain owning the closing and settlement lifecycle with settlement_statement and escrow_ledger kept as distinct, separate entities.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` (
    `closing_order_id` BIGINT COMMENT 'Unique surrogate identifier for the closing order record. Primary key for the settlement domain closing engagement entity.',
    `agency_agreement_id` BIGINT COMMENT 'Foreign key linking to agency.agreement. Business justification: Closing orders produced under agency agreements require agreement reference for authority limit validation, geographic scope enforcement, transaction type authorization verification, and',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: Closing orders produced by agents require agent identification for authority verification, CPL issuance validation, escrow authority enforcement, oversight review sampling, and',
    `closing_escrow_officer_party_id` BIGINT COMMENT 'Reference to the party record for the escrow officer (EOT) responsible for managing trust funds and coordinating the closing. Supports IOLTA accountability.',
    `closing_lender_party_id` BIGINT COMMENT 'Reference to the party record for the lending institution funding this transaction. Drives lender-specific closing instructions, wire instructions, and CPL requirements.',
    `cpl_issuance_id` BIGINT COMMENT 'Reference to the CPL issuance record in the agency management system. Links closing order to the specific CPL issued for lender protection.',
    `escrow_ledger_id` BIGINT COMMENT 'Reference to the escrow trust ledger associated with this closing order. Supports receipt-to-disbursement reconciliation and three-way trust accounting.',
    `primary_closing_agent_party_id` BIGINT COMMENT 'Reference to the party record for the closing agent or settlement agent conducting the closing. May differ from escrow officer in some jurisdictions.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Closing order is executed for a specific property. Currently closing_order links to title_order which links to parcel, but adding direct property_id FK strengthens the model by providing',
    `settlement_statement_id` BIGINT COMMENT 'Reference to the settlement statement (CD/HUD-1/ALTA) prepared for this closing. Kept as a distinct entity per VREQ-003.',
    `title_commitment_id` BIGINT COMMENT 'Reference to the title commitment issued for this transaction. Drives closing-readiness validation against Schedule B-I requirements.',
    `title_order_id` BIGINT COMMENT 'Reference to the parent title order that initiated this closing engagement. Links the closing event to the upstream title production workflow.',
    `title_policy_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_policy. Business justification: Closing orders track which policies were issued at closing for CPL coverage determination, gap coverage validation, post-closing audit trails, and agency remittance reporting.',
    `actual_closing_timestamp` TIMESTAMP COMMENT 'Date and time the closing was actually executed (all documents signed). Distinct from scheduled time; used to measure closing cycle time and SLA adherence.',
    `all_requirements_cleared` BOOLEAN COMMENT 'Indicates whether all Schedule B-I title requirements have been satisfied and cleared prior to closing. Key closing-readiness gate control.',
    `cancellation_date` DATE COMMENT 'Date on which the closing order was cancelled. Used for pipeline fallout reporting and earnest money deposit disposition tracking.',
    `cancellation_reason` STRING COMMENT 'Free-text or coded reason for cancellation of the closing order. Populated only when closing_status is cancelled. Supports fallout analysis and pipeline reporting.',
    `cash_to_close_amount` DECIMAL(15,2) COMMENT 'Net amount of funds the buyer must bring to closing after credits, deposits, and loan proceeds. Key figure on the Closing Disclosure under TRID.',
    `cd_acknowledged_date` DATE COMMENT 'Date the borrower acknowledged receipt of the Closing Disclosure. Starts the mandatory 3-business-day waiting period under TRID.',
    `cd_delivery_date` DATE COMMENT 'Date the Closing Disclosure (CD) was delivered to the borrower. TRID requires delivery at least 3 business days before consummation.',
    `channel_type` STRING COMMENT 'Production channel through which this closing order was originated. Determines agency remittance rules, CPL issuance authority, and premium split schedules.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `closing_location_type` STRING COMMENT 'Type of physical or virtual location where the closing is conducted. Supports operational capacity planning and RON/IPEN compliance tracking.. Valid values are `branch_office|title_plant|attorney_office|remote|lender_office`',
    `closing_method` STRING COMMENT 'Execution method for document signing at closing. Wet-sign is traditional in-person; RON (Remote Online Notarization) and IPEN (In-Person Electronic Notarization) are electronic alternatives.. Valid values are `wet_sign|ron|ipen|hybrid`',
    `closing_readiness_status` STRING COMMENT 'Operational readiness state indicating whether all title requirements, funding conditions, and document preparation steps are satisfied for closing to proceed.. Valid values are `not_ready|conditionally_ready|ready_to_close|closed`',
    `closing_status` STRING COMMENT 'Current lifecycle state of the closing order. Drives closing-readiness dashboards and workflow routing. [ENUM-REF-CANDIDATE: scheduled|in_progress|closed|cancelled|on_hold|pending_funding — promote to reference product]. Valid values are `scheduled|in_progress|closed|cancelled|on_hold|pending_funding`',
    `cpl_issued` BOOLEAN COMMENT 'Indicates whether a Closing Protection Letter (CPL) was issued for this closing engagement. CPL protects the lender against escrow officer fraud or failure.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the closing order record was first created in the title production system. Audit trail anchor for lifecycle tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this closing order. Defaults to USD for domestic US transactions.. Valid values are `^[A-Z]{3}$`',
    `disbursement_date` DATE COMMENT 'Date on which escrow funds were disbursed to payees (seller, lienholders, service providers). Must follow funding and recording per state good-funds laws.',
    `earnest_money_deposit_amount` DECIMAL(15,2) COMMENT 'Amount of the earnest money deposit (EMD) held in escrow trust. Applied as a credit to the buyer at closing on the settlement statement.',
    `effective_date` DATE COMMENT 'The contractual effective date of the transaction (e.g., purchase agreement effective date). Distinct from execution, recording, and disbursement dates per VREQ-008.',
    `execution_date` DATE COMMENT 'Date on which closing documents were executed (signed) by all parties. Distinct from effective, recording, and disbursement dates per VREQ-008.',
    `funding_date` DATE COMMENT 'Date on which loan proceeds were disbursed by the lender into the escrow trust account. Critical for disbursement authorization and gap coverage period calculation.',
    `gap_coverage_end_date` DATE COMMENT 'End date of the gap coverage period, typically the date of recording. Marks the close of the insured gap window.',
    `gap_coverage_required` BOOLEAN COMMENT 'Indicates whether gap coverage is required for the period between closing and recording. Relevant in states where simultaneous recording is not guaranteed.',
    `gap_coverage_start_date` DATE COMMENT 'Start date of the gap coverage period, typically the date of closing/execution. Marks the beginning of the insured gap between closing and recording.',
    `iolta_account_flag` BOOLEAN COMMENT 'Indicates whether the escrow trust account for this closing is an IOLTA account. Relevant for attorney-agent states with IOLTA compliance requirements.',
    `lender_closing_instructions_date` DATE COMMENT 'Date on which lender closing instructions were received by the settlement agent. Used to measure lead time and closing preparation cycle.',
    `lender_closing_instructions_received` BOOLEAN COMMENT 'Indicates whether lender closing instructions have been received and acknowledged by the settlement agent. A prerequisite for closing readiness.',
    `loan_amount` DECIMAL(15,2) COMMENT 'Principal loan amount being funded at closing. Used for LTV calculation, lender policy premium computation, and settlement statement line items.',
    `ltv_ratio` DECIMAL(6,4) COMMENT 'Loan-to-Value ratio computed as loan amount divided by purchase price or appraised value. Used for underwriting risk assessment and lender policy coverage determination.',
    `number` STRING COMMENT 'Externally visible alphanumeric identifier for the closing engagement, used in lender, agent, and consumer communications. Sourced from the title production system (SoftPro/Qualia).. Valid values are `^[A-Z0-9-]{6,30}$`',
    `positive_pay_submitted` BOOLEAN COMMENT 'Indicates whether positive pay files were submitted to the escrow trust bank for check disbursements at closing. Supports ALTA Best Practices Pillar 5 reconciliation controls.',
    `purchase_price_amount` DECIMAL(15,2) COMMENT 'Gross purchase price of the real property as stated in the purchase agreement. Base amount for premium calculation, transfer tax, and settlement statement preparation.',
    `recording_date` DATE COMMENT 'Date the deed and/or deed of trust were recorded with the county recorder/register of deeds. Distinct from execution, funding, and disbursement dates per VREQ-008.',
    `scheduled_closing_date` DATE COMMENT 'The calendar date on which the closing event is scheduled to occur. Used for closing-readiness tracking and SLA measurement.',
    `scheduled_closing_time` TIMESTAMP COMMENT 'Precise date and time the closing appointment is scheduled, including timezone offset. Supports RON/IPEN session coordination and notary scheduling.',
    `settlement_form_type` STRING COMMENT 'Type of settlement statement form required for this closing. CD (Closing Disclosure) applies under TRID; HUD-1 applies to pre-TRID or exempt transactions; ALTA Settlement Statement for cash/commercial.. Valid values are `cd|hud1|alta_settlement`',
    `three_way_reconciliation_status` STRING COMMENT 'Status of the three-way escrow trust account reconciliation (bank balance vs. book balance vs. trial balance). Required under ALTA Best Practices Pillar 5.. Valid values are `pending|in_progress|reconciled|exception`',
    `title_premium_lender_amount` DECIMAL(15,2) COMMENT 'Premium charged for the lenders title insurance policy (LTP). Separately tracked from owner premium per VREQ-010 and TRID disclosure requirements.',
    `title_premium_owner_amount` DECIMAL(15,2) COMMENT 'Premium charged for the owners title insurance policy (OTP). Feeds premium remittance calculation and agency split schedule.',
    `total_settlement_charges_amount` DECIMAL(15,2) COMMENT 'Total closing costs and settlement charges as reflected on the settlement statement. Supports TRID tolerance monitoring and consumer disclosure compliance.',
    `transaction_type` STRING COMMENT 'Classification of the real-estate transaction driving this closing. Determines applicable regulatory disclosures (TRID/RESPA) and settlement statement form (CD vs HUD-1 vs ALTA).. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the closing order record. Supports change detection, incremental ETL, and audit compliance.',
    `wire_instructions_verified` BOOLEAN COMMENT 'Indicates whether wire instructions for disbursement have been independently verified per ALTA Best Practices fraud prevention controls. Actual wire details stored in NPPI Vault.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_closing_order PRIMARY KEY(`closing_order_id`)
) COMMENT 'Master record for a closing/settlement engagement, representing the scheduling and coordination of a closing event tied to a title order. Tracks closing type (purchase, refinance, HELOC, construction), closing method (wet-sign, RON, IPEN, hybrid)';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` (
    `settlement_statement_id` BIGINT COMMENT 'Unique surrogate identifier for the settlement statement record. Primary key for the settlement_statement entity in the Silver layer lakehouse.',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: Settlement statements reference the legal description for property identification on HUD-1/CD forms and Schedule A consistency verification before closing; ensures settlement agent',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Settlement statements require specific parcel APN for property tax proration calculations, legal description Schedule A accuracy verification, recording jurisdiction determination, and',
    `prior_statement_settlement_statement_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding version of this settlement statement. Enables full revision chain traversal and prior classification preservation per VREQ-007.',
    `title_commitment_id` BIGINT COMMENT 'Reference to the title commitment that underpins the closing. Ties the settlement statement to the underwriting commitment in force at closing.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order that initiated this closing transaction. Links the settlement statement to the originating order intake record.',
    `title_policy_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_policy. Business justification: Settlement statements must reference the issued owner and/or lender policy for premium reconciliation, IRS 1099-S reporting, regulatory compliance, and post-closing audit trails.',
    `acceptance_date` DATE COMMENT 'Date on which the settlement statement was accepted or approved by the lender or counterparty. Distinct field per VREQ-008.',
    `cash_to_close` DECIMAL(15,2) COMMENT 'Net cash amount the borrower must bring to closing (or receive back) after all credits and debits are applied. Key closing-readiness metric. Positive = cash due from borrower; negative = cash back to borrower.',
    `closing_date` DATE COMMENT 'The scheduled or actual date on which the real estate closing and settlement occurred. Principal business event date for the settlement transaction. Distinct from execution, effective, and recording dates per VREQ-008.',
    `closing_location` STRING COMMENT 'Physical address or description of the location where the closing was conducted (e.g., branch office address, attorney office, remote/RON). Supports audit and notarization compliance.',
    `closing_method` STRING COMMENT 'Method by which the closing documents were executed. wet_sign = traditional in-person wet signature; ron = Remote Online Notarization; ipen = In-Person Electronic Notarization; mail_away = documents mailed for signature.. Valid values are `wet_sign|ron|ipen|mail_away`',
    `cpl_issued` BOOLEAN COMMENT 'Indicates whether a Closing Protection Letter (CPL) was issued for this closing. CPL protects the lender against settlement agent fraud or failure to follow closing instructions.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this settlement statement record was first created in the system. Audit trail field supporting SOX and SOC 2 compliance.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this settlement statement. Defaults to USD for domestic U.S. real estate transactions.. Valid values are `USD`',
    `disbursement_date` DATE COMMENT 'Date on which escrow funds were disbursed to all payees following closing. May differ from closing date in refinance transactions due to rescission period. Distinct from closing_date per VREQ-008.',
    `earnest_money_deposit` DECIMAL(15,2) COMMENT 'Earnest money deposit amount credited to the borrower/buyer on the settlement statement. Reflects funds held in escrow prior to closing and applied at settlement.',
    `effective_date` DATE COMMENT 'Date on which the settlement statement terms become legally effective. May differ from execution date in certain transaction types. Distinct field per VREQ-008.',
    `execution_date` DATE COMMENT 'Date on which the settlement statement was signed/executed by the parties. Distinct from effective, submission, acceptance, and recording dates per VREQ-008.',
    `gross_amount_due_borrower` DECIMAL(15,2) COMMENT 'Total gross amount due from the borrower at closing before credits and adjustments. Corresponds to Section 100 of HUD-1 or borrower-side summary on CD/ALTA statement.',
    `hoa_dues_prorated` DECIMAL(15,2) COMMENT 'Prorated HOA dues credited or debited between buyer and seller at closing. Reflects the HOA assessment allocation through the closing date.',
    `irs_1099s_required` BOOLEAN COMMENT 'Indicates whether IRS Form 1099-S reporting is required for this real estate transaction. Driven by sales price threshold and seller exemption status.',
    `lender_title_premium` DECIMAL(15,2) COMMENT 'Premium charged for the lenders title insurance policy (LTP) as shown on the settlement statement. Supports premium revenue recognition and owner-vs-lender policy coverage metrics per VREQ-016.',
    `loan_amount` DECIMAL(15,2) COMMENT 'Principal loan amount being funded at closing as stated on the settlement statement. Used for LTV calculation, premium computation, and lender policy coverage amount.',
    `owner_title_premium` DECIMAL(15,2) COMMENT 'Premium charged for the owners title insurance policy (OTP) as shown on the settlement statement. Supports premium revenue recognition and owner-vs-lender policy coverage metrics per VREQ-016.',
    `payoff_first_mortgage` DECIMAL(15,2) COMMENT 'Payoff amount for the existing first mortgage or deed of trust (DOT) being satisfied at closing. Includes principal, accrued interest, and per diem through disbursement date.',
    `payoff_second_mortgage` DECIMAL(15,2) COMMENT 'Payoff amount for any existing second mortgage or home equity line of credit (HELOC) being satisfied at closing. Null if no second lien exists.',
    `production_channel` STRING COMMENT 'Channel through which the title order and closing were produced. Drives agency remittance, premium split, and CPL applicability. direct_branch, centralized_lender, or independent_agent.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `prorated_taxes` DECIMAL(15,2) COMMENT 'Property tax proration amount credited or debited between buyer and seller based on the closing date within the tax year. Disclosed on the settlement statement.',
    `real_estate_commission` DECIMAL(15,2) COMMENT 'Total real estate brokerage commission paid at closing, typically from seller proceeds. Disclosed on the settlement statement. Null for refinance transactions.',
    `recording_date` DATE COMMENT 'Date on which the associated deed and/or mortgage instruments were recorded with the county recorder. Distinct field per VREQ-008. Supports policy issuance lag metric.',
    `recording_fees` DECIMAL(15,2) COMMENT 'Total fees paid to the county recorder for recording the deed, mortgage/deed of trust, and any other instruments at closing. Disclosed as a zero-tolerance item under TRID.',
    `rescission_expiry_date` DATE COMMENT 'Date on which the borrowers right of rescission expires for refinance transactions under TILA. Disbursement is held until this date. Null for purchase transactions.',
    `revision_number` BIGINT COMMENT 'Sequential integer revision counter for this settlement statement. Increments with each material change. Supports lifecycle history per VREQ-007 and TRID tolerance cure tracking.',
    `revision_reason` STRING COMMENT 'Free-text or coded reason for the most recent revision to this settlement statement (e.g., changed loan terms, corrected fee, tolerance cure). Preserves material lifecycle transitions per VREQ-007.',
    `sales_price` DECIMAL(15,2) COMMENT 'Contract purchase price of the real property as stated on the settlement statement. Applicable to purchase transactions. Null for refinance. Reported on Schedule A and IRS Form 1099-S.',
    `seller_net_proceeds` DECIMAL(15,2) COMMENT 'Net amount disbursed to the seller after payoff of existing liens, commissions, and closing costs. Applicable to purchase transactions. Null for refinance.',
    `settlement_agent_name` STRING COMMENT 'Name of the settlement agent or escrow officer responsible for conducting the closing and preparing the settlement statement. Disclosed on the CD/HUD-1/ALTA statement.',
    `settlement_fee` DECIMAL(15,2) COMMENT 'Fee charged by the settlement agent or escrow officer for conducting the closing. Disclosed on the settlement statement as a title service fee under TRID Section B or C.',
    `statement_form_type` STRING COMMENT 'Regulatory form type used for this settlement statement. CD = Closing Disclosure (TRID/TILA-RESPA), HUD-1 = legacy RESPA settlement statement, ALTA = ALTA Settlement Statement for non-TRID transactions.. Valid values are `CD|HUD-1|ALTA`',
    `statement_number` STRING COMMENT 'Externally visible alphanumeric identifier assigned to this settlement statement by the title production or escrow system (e.g., SoftPro file number suffix). Used for audit and regulatory reference.',
    `statement_status` STRING COMMENT 'Current lifecycle status of the settlement statement. Tracks progression from draft preparation through final execution and any post-closing void or correction.. Valid values are `draft|issued|revised|final|voided`',
    `submission_date` DATE COMMENT 'Date on which the settlement statement was submitted to the lender or relevant party for review or approval. Distinct field per VREQ-008.',
    `three_day_waiting_period_met` BOOLEAN COMMENT 'Indicates whether the mandatory three-business-day waiting period between CD delivery and consummation was satisfied under TRID. Critical compliance flag for CFPB examination.',
    `tolerance_cure_amount` DECIMAL(15,2) COMMENT 'Dollar amount of any tolerance cure credit applied to the borrower due to TRID fee tolerance violations. Disclosed on the final CD. Zero if no cure was required.',
    `total_closing_costs_borrower` DECIMAL(15,2) COMMENT 'Total closing costs charged to the borrower as summarized on the settlement statement. Includes origination charges, title fees, recording fees, prepaid items, and escrow reserves.',
    `total_closing_costs_seller` DECIMAL(15,2) COMMENT 'Total closing costs charged to the seller as summarized on the settlement statement. Includes real estate commissions, seller-paid title fees, and payoff amounts. Null for refinance.',
    `total_credits_borrower` DECIMAL(15,2) COMMENT 'Total credits applied to the borrowers side of the settlement statement including earnest money deposit (EMD), seller credits, and loan proceeds. Corresponds to Section 200 of HUD-1.',
    `transaction_type` STRING COMMENT 'Classification of the real estate transaction type. Drives applicable regulatory form requirements and settlement line-item structure. [ENUM-REF-CANDIDATE: purchase|refinance|home_equity|construction|commercial — promote to reference product]. Valid values are `purchase|refinance|home_equity|construction|commercial`',
    `transfer_tax_amount` DECIMAL(15,2) COMMENT 'State and/or county real estate transfer tax or documentary stamp tax charged at closing. Allocated between buyer and seller per local custom and disclosed on the settlement statement.',
    `trid_applicable` BOOLEAN COMMENT 'Indicates whether TRID disclosure rules apply to this transaction. True for most consumer mortgage transactions; False for cash, commercial, or exempt transactions requiring HUD-1 or ALTA form.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this settlement statement record was most recently modified. Supports change detection, audit trail, and revision history per VREQ-007.',
    `wire_amount_borrower` DECIMAL(15,2) COMMENT 'Dollar amount of the wire transfer received from or sent to the borrower at closing. Sensitive financial data per VREQ-012. Reconciled against escrow ledger receipts.',
    `wire_amount_lender` DECIMAL(15,2) COMMENT 'Dollar amount of the loan proceeds wire received from the lender at closing. Sensitive financial data per VREQ-012. Reconciled against escrow ledger receipts.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_settlement_statement PRIMARY KEY(`settlement_statement_id`)
) COMMENT 'Legally and operationally distinct settlement statement record capturing the final financial accounting of a real estate closing. Stores statement form type (CD/Closing Disclosure, HUD-1, ALTA Settlement Statement), statement version and revision number';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` (
    `escrow_ledger_id` BIGINT COMMENT 'Unique surrogate identifier for the escrow trust account ledger record. Primary key for this entity.',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: Escrow ledgers managed by agents require agent identification for escrow authority verification, IOLTA compliance validation, three-way reconciliation oversight, trust account audit, and',
    `cpl_issuance_id` BIGINT COMMENT 'Reference to the CPL issuance record in the agency domain. Links the escrow ledger to the specific CPL protecting this closing.',
    `party_id` BIGINT COMMENT 'Reference to the escrow officer or trust officer responsible for managing this ledger and authorizing disbursements.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Escrow ledgers track funds for specific property transactions; essential for three-way reconciliation, trust accounting regulatory audits, and property-level escrow balance reporting',
    `settlement_statement_id` BIGINT COMMENT 'Reference to the associated settlement statement (CD/HUD-1/ALTA). Distinct from the escrow ledger per VREQ-003; linked for reconciliation purposes.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order that initiated this escrow ledger. Links the escrow trust account to the originating transaction.',
    `title_policy_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_policy. Business justification: Escrow ledgers track premium collection and disbursement tied to specific policies for three-way reconciliation, agency remittance reporting, and regulatory compliance.',
    `actual_closing_date` DATE COMMENT 'Date on which the closing actually occurred and disbursements were authorized. May differ from scheduled_closing_date.',
    `branch_code` BIGINT COMMENT 'Reference to the direct branch, centralized lender channel, or independent agent office responsible for this escrow ledger.',
    `buyer_funds_amount` DECIMAL(18,2) COMMENT 'Total cash-to-close funds received from the buyer/borrower into escrow, net of any earnest money deposit already credited.',
    `cpl_issued` BOOLEAN COMMENT 'Indicates whether a Closing Protection Letter (CPL/Insured Closing Letter) was issued for this closing, protecting the lender against escrow officer fraud or misapplication of funds.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this escrow ledger record was first created in the system of record. Audit trail for record provenance.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this ledger. Typically USD for US title transactions.. Valid values are `^[A-Z]{3}$`',
    `current_balance` DECIMAL(18,2) COMMENT 'Current book balance of the escrow trust account ledger (total receipts minus total disbursements). Should equal zero at ledger close.',
    `disbursement_authorization_method` STRING COMMENT 'Method required to authorize disbursements from this escrow ledger (e.g., dual signature, single signature, electronic approval). Controls disbursement risk.. Valid values are `dual_signature|single_signature|electronic_approval|not_set`',
    `emd_amount` DECIMAL(18,2) COMMENT 'Dollar amount of the earnest money deposit received into escrow. Key component of the receipt-to-disbursement reconciliation for purchase transactions.',
    `emd_received_date` DATE COMMENT 'Date the earnest money deposit was received into the escrow trust account. Key milestone for purchase transactions.',
    `escrow_fee_amount` DECIMAL(18,2) COMMENT 'Fee charged by the settlement/escrow agent for closing services, collected through escrow and disbursed to the title company.',
    `gl_account_code` STRING COMMENT 'General ledger account code to which this escrow ledger maps in the ERP/GL system for premium revenue recognition and financial reporting.',
    `holdback_amount` DECIMAL(18,2) COMMENT 'Amount withheld in escrow post-closing for a specific purpose (e.g., repair holdback, construction draw, or curative holdback). Released upon condition satisfaction.',
    `holdback_release_date` DATE COMMENT 'Date on which the escrow holdback amount was or is scheduled to be released upon satisfaction of the holdback condition.',
    `iolta_account_flag` BOOLEAN COMMENT 'Indicates whether the trust account holding these escrow funds is an IOLTA account. Relevant for interest remittance to state bar foundation.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this escrow ledger record was most recently modified. Supports change detection and audit trail.',
    `ledger_close_date` DATE COMMENT 'Date the escrow ledger was formally closed after all disbursements, reconciliation, and any holdback releases were completed.',
    `ledger_number` STRING COMMENT 'Externally-known alphanumeric identifier for this escrow trust account ledger, assigned by the escrow/trust accounting system (e.g., SoftPro Trust Accounting).',
    `ledger_status` STRING COMMENT 'Current lifecycle state of the escrow ledger. Tracks progression from open through reconciliation and closure. [ENUM-REF-CANDIDATE: open|pending_close|closed|reconciled|voided|suspended — promote to reference product]. Valid values are `open|pending_close|closed|reconciled|voided|suspended`',
    `ledger_type` STRING COMMENT 'Classification of the escrow ledger by transaction type: purchase, refinance, HELOC, construction, commercial, or home equity. Drives workflow and disbursement rules.. Valid values are `purchase|refinance|heloc|construction|commercial|home_equity`',
    `loan_proceeds_amount` DECIMAL(18,2) COMMENT 'Amount of lender loan proceeds wired into the escrow trust account for disbursement at closing.',
    `opening_date` DATE COMMENT 'Date the escrow trust account ledger was opened and funds were first authorized to be received for this closing.',
    `out_of_balance_amount` DECIMAL(18,2) COMMENT 'Dollar variance identified during three-way reconciliation between the bank statement balance, book balance, and individual ledger balances. Zero when balanced.',
    `out_of_balance_reason` STRING COMMENT 'Narrative explanation for any out-of-balance condition identified during three-way reconciliation. Required for audit and remediation tracking.',
    `payoff_amount` DECIMAL(18,2) COMMENT 'Total amount disbursed from escrow to satisfy existing mortgage(s), deed(s) of trust, or other liens on the property at closing.',
    `positive_pay_enrolled` BOOLEAN COMMENT 'Indicates whether this escrow trust account is enrolled in the banks positive pay fraud prevention program for check disbursements.',
    `recording_fee_amount` DECIMAL(18,2) COMMENT 'Total recording fees collected through escrow for submission of deed, deed of trust, and other instruments to the county recorder.',
    `scheduled_closing_date` DATE COMMENT 'Anticipated date on which the closing and final disbursement of escrow funds is expected to occur.',
    `seller_proceeds_amount` DECIMAL(18,2) COMMENT 'Net proceeds disbursed to the seller from escrow after payoff of existing liens, prorations, and closing costs.',
    `source_system_ledger_ref` STRING COMMENT 'Native ledger or file number assigned by the escrow/trust accounting system of record (e.g., SoftPro Trust Accounting, RamQuest). Supports SoR traceability.',
    `three_way_reconciliation_date` DATE COMMENT 'Date the most recent three-way reconciliation was performed: bank statement balance vs. book balance vs. individual ledger balances.',
    `three_way_reconciliation_status` STRING COMMENT 'Result of the most recent three-way reconciliation. Indicates whether the bank statement, book balance, and individual ledger balances are in agreement.. Valid values are `balanced|out_of_balance|pending|not_performed`',
    `title_premium_amount` DECIMAL(18,2) COMMENT 'Total title insurance premium collected through escrow for owner and/or lender policies, to be remitted to the underwriter per the premium split schedule.',
    `total_disbursements_amount` DECIMAL(18,2) COMMENT 'Cumulative gross amount of all funds disbursed from the escrow trust account for this ledger, including payoffs, proceeds, and fees.',
    `total_receipts_amount` DECIMAL(18,2) COMMENT 'Cumulative gross amount of all funds received into the escrow trust account for this ledger, including EMD, loan proceeds, and buyer funds.',
    `transfer_tax_amount` DECIMAL(18,2) COMMENT 'State and/or county transfer tax or documentary stamp tax collected through escrow and disbursed to the taxing authority at closing.',
    `trust_account_bank_name` STRING COMMENT 'Name of the financial institution holding the IOLTA/escrow trust account for this closing.',
    `trust_account_number` STRING COMMENT 'Bank account number of the IOLTA/escrow trust account holding funds for this closing. Restricted per VREQ-012 and GLBA as sensitive financial account data.',
    `trust_account_routing_number` STRING COMMENT 'ABA routing/transit number for the IOLTA/escrow trust account bank. Restricted per VREQ-012 as sensitive wire/bank instruction data.. Valid values are `^[0-9]{9}$`',
    `wire_instruction_verified` BOOLEAN COMMENT 'Indicates whether outgoing wire instructions for this escrow ledger have been independently verified per ALTA Best Practices wire fraud prevention procedures.',
    `wire_verification_method` STRING COMMENT 'Method used to verify outgoing wire instructions (e.g., phone callback to known number, secure portal confirmation, in-person). Supports wire fraud prevention audit.. Valid values are `phone_callback|secure_portal|in_person|not_verified`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_escrow_ledger PRIMARY KEY(`escrow_ledger_id`)
) COMMENT 'Legally and operationally distinct escrow trust account ledger tracking every receipt and disbursement within the IOLTA/trust account for a specific closing.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` (
    `disbursement_id` BIGINT COMMENT 'Unique system-generated identifier for a single outgoing payment from the escrow trust account. Primary key for the disbursement record.',
    `escrow_ledger_id` BIGINT COMMENT 'Reference to the escrow trust account ledger from which this disbursement is drawn. Links the disbursement to its parent escrow ledger for three-way reconciliation.',
    `payee_party_id` BIGINT COMMENT 'Reference to the party record for the disbursement recipient. Links to the party master for role-based access and NPPI protection of payee details.',
    `payee_party_role_id` BIGINT COMMENT 'Foreign key linking to operations.party_role. Business justification: Disbursements require role context (seller proceeds, lender payoff, vendor payment) for settlement statement line-item mapping, 1099-S reporting, and role-specific disbursement rules.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Disbursements are property-specific for 1099-S reporting, transfer tax jurisdiction determination, recording fee calculation by county, and settlement statement line-item validation against',
    `settlement_statement_id` BIGINT COMMENT 'Reference to the settlement statement (CD/HUD-1/ALTA) that authorizes and documents this disbursement. Links disbursement to the closing disclosure line item.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order associated with this disbursement, enabling traceability from disbursement back to the originating transaction order.',
    `title_policy_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_policy. Business justification: Disbursements for policy-related costs (endorsement fees, curative actions paid by underwriter, premium refunds) must link to the policy for cost allocation, loss ratio analysis',
    `aba_routing_number` STRING COMMENT 'Nine-digit American Bankers Association (ABA) routing transit number for the receiving bank. Required for wire and ACH disbursements. Classified confidential as a partial banking identifier.. Valid values are `^[0-9]{9}$`',
    `adjustment_amount` DECIMAL(15,2) COMMENT 'Any post-issuance adjustment applied to the disbursement (e.g., correction, proration true-up, fee revision). Negative values indicate reductions. Zero if no adjustment.',
    `amount` DECIMAL(15,2) COMMENT 'Gross amount of the outgoing payment in the transaction currency. Represents the face value of the check or wire before any adjustments. Core monetary field for escrow reconciliation.',
    `authorization_timestamp` TIMESTAMP COMMENT 'Date and time the disbursement was formally authorized by the escrow officer or closing manager. Distinct from the issued date; captures the approval event for audit trail.',
    `authorized_by` STRING COMMENT 'Name or identifier of the escrow officer or authorized signatory who approved this disbursement. Required for dual-control and audit compliance under ALTA Best Practices.',
    `bank_account_ref` STRING COMMENT 'Vault reference token for the destination bank account used for ACH or wire disbursements, stored in the NPPI Vault. Actual account number is never stored in this table per VREQ-012.',
    `bank_name` STRING COMMENT 'Name of the receiving financial institution for wire or ACH disbursements. Non-sensitive identifier used for routing verification and audit trail without exposing account details.',
    `cleared_date` DATE COMMENT 'Date the disbursement was confirmed as cleared by the bank (check presented and paid, or wire confirmed received). Used for three-way reconciliation and positive-pay matching.',
    `cost_center_code` STRING COMMENT 'Internal cost center or branch code responsible for this disbursement. Used for branch-level P&L reporting and operational cost allocation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time the disbursement record was first created in the escrow trust accounting system. Audit field for record provenance and lifecycle tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the disbursement amount (e.g., USD). Supports multi-currency escrow accounts in commercial transactions.. Valid values are `^[A-Z]{3}$`',
    `disbursement_status` STRING COMMENT 'Current lifecycle state of the disbursement: pending (authorized but not yet issued), issued (sent), cleared (confirmed by bank), voided, returned, or stopped. Drives reconciliation and exception workflows.. Valid values are `pending|issued|cleared|voided|returned|stopped`',
    `disbursement_type` STRING COMMENT 'Categorical classification of the disbursement purpose (e.g., payoff/reconveyance, seller proceeds, commission, recording fee, title premium, HOA assessment).',
    `escrow_trust_account_number` STRING COMMENT 'Identifier of the specific IOLTA or escrow trust bank account from which the disbursement is drawn. Supports multi-account escrow operations and three-way reconciliation.',
    `gl_account_code` STRING COMMENT 'General Ledger account code to which this disbursement is posted in the ERP/finance system. Supports premium revenue recognition, agent settlement, and AP/AR reconciliation.',
    `is_gap_period_disbursement` BOOLEAN COMMENT 'Indicates whether this disbursement was issued during the gap period between closing and recording. True flags disbursements subject to gap coverage risk per title commitment terms.',
    `issued_date` DATE COMMENT 'Actual date the check was printed or the wire/ACH was initiated from the escrow trust account. May differ from scheduled date due to funding delays or corrections.',
    `loan_payoff_amount` DECIMAL(15,2) COMMENT 'For payoff disbursements, the per-diem-adjusted loan payoff amount as confirmed by the lenders payoff statement. Null for non-payoff disbursements. Supports lien clearance verification.',
    `memo` STRING COMMENT 'Free-text memo or description printed on the check or included in the wire/ACH addenda record. Describes the purpose of the disbursement for payee and audit reference.',
    `net_disbursement_amount` DECIMAL(15,2) COMMENT 'Final net amount disbursed after applying any adjustments to the gross disbursement amount. Used for final reconciliation against the escrow ledger balance.',
    `number` STRING COMMENT 'Externally visible, human-readable check or wire reference number assigned by the escrow trust accounting system (e.g., check number, wire sequence number). Used for positive-pay and bank reconciliation.',
    `payee_name` STRING COMMENT 'Full legal name of the individual or entity receiving the disbursement as it appears on the check or wire instruction. Required for positive-pay and 1099 reporting.',
    `payee_tax_id_ref` STRING COMMENT 'Vault reference token for the payees Tax Identification Number (TIN/SSN/EIN) stored in the NPPI Vault. Used for IRS 1099-S reporting. Actual TIN is never stored in this table.',
    `payee_type` STRING COMMENT 'Classification of the payee role in the transaction (e.g., seller, lender payoff, borrower, real estate agent/broker, HOA, taxing authority). [ENUM-REF-CANDIDATE: seller|lender|borrower|agent|broker|attorney|hoa|taxing_authority|title_company|other —',
    `payment_method` STRING COMMENT 'Instrument used to execute the disbursement: check, wire transfer, ACH, internal ledger transfer, or cashiers check. Drives positive-pay and bank reconciliation workflows.. Valid values are `check|wire|ach|internal_transfer|cashiers_check`',
    `payoff_good_through_date` DATE COMMENT 'Expiration date of the lenders payoff statement through which the loan_payoff_amount is valid. Disbursement must be received by lender on or before this date to satisfy the lien.',
    `positive_pay_exception` BOOLEAN COMMENT 'Indicates whether the bank flagged this disbursement as a positive-pay exception (mismatch between issued check details and presented check). True triggers manual review.',
    `positive_pay_submitted` BOOLEAN COMMENT 'Indicates whether this disbursement has been submitted to the banks positive-pay fraud prevention system. True if submitted; False if not yet submitted or not applicable (e.g., wire).',
    `recording_fee_jurisdiction` STRING COMMENT 'County or jurisdiction name to which a recording fee disbursement is directed. Null for non-recording-fee disbursements. Supports recording submission reconciliation.',
    `remittance_type` STRING COMMENT 'For premium-related disbursements, classifies the remittance category (e.g., title premium, agent split, underwriter split, CPL fee). Null for non-premium disbursements. Supports agency remittance reporting.. Valid values are `title_premium|agent_split|underwriter_split|cpl_fee|endorsement_fee|other`',
    `return_date` DATE COMMENT 'Date a returned check or ACH return was received by the escrow trust account. Null if not returned. Triggers re-issuance workflow and ledger reversal.',
    `return_reason_code` STRING COMMENT 'NACHA ACH return reason code or bank-issued check return reason (e.g., R01 insufficient funds, R02 account closed). Null for non-returned disbursements.',
    `scheduled_disbursement_date` DATE COMMENT 'Date on which the disbursement is authorized and scheduled to be issued from the escrow trust account, typically the closing date or a specified post-closing date.',
    `settlement_statement_line_ref` STRING COMMENT 'Line item reference number or code on the settlement statement (CD/HUD-1/ALTA) that authorizes this disbursement (e.g., line 103, line 504). Enables traceability from disbursement to closing disclosure.',
    `source_system_code` STRING COMMENT 'Unique identifier of this disbursement record in the originating escrow trust accounting system (e.g., SoftPro Trust Accounting, RamQuest). Enables lineage tracing and SoR reconciliation.',
    `source_system_name` STRING COMMENT 'Name of the operational system of record from which this disbursement record was ingested (e.g., SoftPro, RamQuest, Qualia). Supports multi-system lakehouse lineage.. Valid values are `softpro|ramquest|qualia|other`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time the disbursement record was last modified in the source system or lakehouse silver layer. Supports change detection and incremental ETL processing.',
    `void_date` DATE COMMENT 'Date the disbursement was voided, if applicable. Null if not voided. A voided disbursement requires a corresponding reversal entry in the escrow ledger.',
    `void_reason` STRING COMMENT 'Reason code explaining why the disbursement was voided (e.g., stale check, incorrect amount, wire rejected). Required when disbursement_status is voided for audit and reconciliation.',
    `wire_confirmation_number` STRING COMMENT 'Bank-issued IMAD/OMAD or confirmation reference number for wire transfer disbursements. Null for check or ACH disbursements. Used to confirm wire receipt with receiving bank.',
    `wire_instruction_ref` STRING COMMENT 'Vault reference token pointing to the encrypted wire instruction record (bank name, ABA routing, account number) in the NPPI Vault. Actual banking details are never stored in this table per VREQ-012.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_disbursement PRIMARY KEY(`disbursement_id`)
) COMMENT 'Individual disbursement record representing a single outgoing payment from the escrow trust account at or after closing. Captures disbursement type (payoff/reconveyance, seller proceeds, commission, recording fee, title premium, HOA assessment, tax';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` (
    `wire_instruction_id` BIGINT COMMENT 'Unique surrogate identifier for a wire transfer instruction record within the escrow and settlement system.',
    `closing_order_id` BIGINT COMMENT 'Reference to the title order or closing file to which this wire instruction is associated, linking disbursement instructions to the settlement transaction.',
    `disbursement_id` BIGINT COMMENT 'Reference to the escrow ledger disbursement record that consumed this wire instruction when the wire was actually sent. Links instruction to execution.',
    `party_id` BIGINT COMMENT 'Reference to the party (seller, borrower, lender, payoff lender, HOA, commission recipient) for whom this wire instruction is on file.',
    `prior_instruction_wire_instruction_id` BIGINT COMMENT 'Self-referencing identifier of the previous wire instruction record that this record supersedes. Preserves the revision history and chain of custody for audit purposes.',
    `aba_routing_number_token` STRING COMMENT 'Tokenized or encrypted ABA/routing transit number (9-digit) of the receiving bank. Stored as a token referencing the NPPI Vault; never stored in plaintext per GLBA and ALTA Best Practices Pillar 3.',
    `account_number_token` STRING COMMENT 'Tokenized or encrypted beneficiary bank account number. Stored as a reference token to the NPPI Vault; never stored in plaintext per GLBA and ALTA Best Practices Pillar 3.',
    `account_type` STRING COMMENT 'Type of bank account to which the wire is directed (e.g., checking, savings). Required by some receiving banks for proper routing.. Valid values are `checking|savings|money_market|loan`',
    `approved_by` STRING COMMENT 'Name or identifier of the escrow officer or supervisor who approved the wire instruction for disbursement.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the wire instruction was formally approved for disbursement by an authorized escrow officer or supervisor.',
    `bank_address_line1` STRING COMMENT 'Primary street address of the receiving bank branch. Required for domestic wire instructions and correspondent bank identification.',
    `bank_city` STRING COMMENT 'City of the receiving bank branch used for wire routing verification and correspondent bank identification.',
    `bank_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the receiving bank. Distinguishes domestic (USA) from international wire instructions.. Valid values are `^[A-Z]{3}$`',
    `bank_name` STRING COMMENT 'Full legal name of the receiving financial institution where the beneficiary account is held. Used for wire routing verification.',
    `bank_state` STRING COMMENT 'Two-letter US state code of the receiving bank branch per USPS/FIPS standards.. Valid values are `^[A-Z]{2}$`',
    `beneficiary_name` STRING COMMENT 'Full legal name of the wire beneficiary as it must appear on the outgoing wire transfer. Required for bank matching and fraud prevention.',
    `change_reason` STRING COMMENT 'Business reason documented for changing or replacing a previously verified wire instruction (e.g., bank account change, payoff amount update). Required when is_change_request is true.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this wire instruction record was first created in the escrow and trust accounting system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the wire amount. Defaults to USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `delivery_channel` STRING COMMENT 'Channel through which the wire instruction was received from the party. Secure portal and encrypted email are preferred per ALTA Best Practices Pillar 2.. Valid values are `secure_portal|encrypted_email|fax|in_person|mail`',
    `expected_wire_amount` DECIMAL(18,2) COMMENT 'Expected gross USD amount to be wired per the settlement statement or payoff demand. Used for pre-wire verification and positive-pay controls.',
    `expiration_date` DATE COMMENT 'Date after which the wire instruction is no longer valid and must be re-verified before use. Supports fraud prevention and stale-instruction controls.',
    `fraud_alert_flag` BOOLEAN COMMENT 'Indicates whether a fraud alert or suspicious activity flag has been raised against this wire instruction (e.g., BEC/business email compromise indicators). Triggers enhanced review.',
    `fraud_alert_notes` STRING COMMENT 'Free-text notes describing the nature of the fraud alert or suspicious activity associated with this wire instruction. Populated when fraud_alert_flag is true.',
    `further_credit_account_token` STRING COMMENT 'Tokenized further-credit (FFC) sub-account number at the receiving bank. Stored as a token referencing the NPPI Vault.',
    `further_credit_name` STRING COMMENT 'Name on the further-credit (FFC) sub-account when the wire must be credited to a sub-account at the receiving bank (common for lender payoffs and HOA accounts).',
    `instruction_number` STRING COMMENT 'Externally visible reference number assigned to this wire instruction record by the escrow or trust accounting system (e.g., SoftPro Trust Accounting).',
    `instruction_status` STRING COMMENT 'Current lifecycle state of the wire instruction. [ENUM-REF-CANDIDATE: draft|pending_verification|verified|approved|used|cancelled|expired — promote to reference product]',
    `intermediary_aba_token` STRING COMMENT 'Tokenized ABA routing number of the intermediary (correspondent) bank. Stored as a token referencing the NPPI Vault.',
    `intermediary_bank_name` STRING COMMENT 'Name of the intermediary (correspondent) bank required when the receiving bank cannot accept wires directly. Used for complex domestic or international routing.',
    `is_change_request` BOOLEAN COMMENT 'Indicates whether this wire instruction record represents a change or update to a previously verified instruction. Change requests require re-verification per ALTA Best Practices Pillar 2 fraud controls.',
    `nppi_vault_ref` STRING COMMENT 'Token or reference key pointing to the encrypted NPPI Vault record that holds the plaintext ABA routing number and account number for this wire instruction per GLBA and ALTA Best Practices Pillar 3.',
    `party_role` STRING COMMENT 'Role of the party in the closing transaction for whom this wire instruction applies (e.g., seller proceeds, borrower refund, payoff lender). [ENUM-REF-CANDIDATE: seller|borrower|lender|payoff_lender|hoa|commission_recipient|other — promote to reference',
    `positive_pay_submitted` BOOLEAN COMMENT 'Indicates whether this wire instruction has been submitted to the bank positive-pay or wire-confirmation system prior to disbursement. Supports escrow trust account controls.',
    `received_timestamp` TIMESTAMP COMMENT 'Date and time when the wire instruction was first received from the party (via secure email, portal, or in-person). Establishes the start of the verification workflow.',
    `source_document_ref` STRING COMMENT 'Reference identifier or document management system link to the original wire instruction document (e.g., signed wire authorization form, secure portal submission record) stored in the Document Management and Imaging System.',
    `swift_bic_code` STRING COMMENT 'Society for Worldwide Interbank Financial Telecommunication (SWIFT) Bank Identifier Code (BIC) for international wire transfers. Required when bank_country_code is not USA.. Valid values are `^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this wire instruction record was last modified. Supports audit trail and lifecycle tracking.',
    `verification_method` STRING COMMENT 'Method used to independently verify the wire instructions prior to disbursement (e.g., callback to known number, secure portal submission). Supports ALTA Best Practices Pillar 2 fraud controls.. Valid values are `callback|secure_email|in_person|portal|not_verified`',
    `verification_timestamp` TIMESTAMP COMMENT 'Date and time when the wire instruction was independently verified by the escrow officer per ALTA Best Practices Pillar 2 callback or secure-channel protocol.',
    `verified_by` STRING COMMENT 'Name or identifier of the escrow officer or staff member who completed the independent verification of the wire instructions.',
    `wire_purpose` STRING COMMENT 'Business purpose of the wire disbursement as it relates to the closing (e.g., seller proceeds, mortgage payoff, EMD). [ENUM-REF-CANDIDATE: seller_proceeds|payoff|earnest_money|commission|tax_proration|hoa_dues|other — promote to reference product]',
    `wire_reference_memo` STRING COMMENT 'Free-text reference or memo line to be included on the outgoing wire (e.g., loan number, file number, property address). Assists receiving bank in applying the funds.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_wire_instruction PRIMARY KEY(`wire_instruction_id`)
) COMMENT 'Master record for wire transfer instructions associated with a closing party (seller, borrower, lender, payoff lender, HOA, commission recipient). Captures beneficiary name, bank name, ABA routing number, account number (encrypted/tokenized per NPPI';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` (
    `premium_charge_id` BIGINT COMMENT 'Unique surrogate identifier for a premium charge record within the title insurance settlement system.',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: Premium charges require agent identification for premium split calculation, agent remittance reconciliation, and revenue allocation.',
    `endorsement_id` BIGINT COMMENT 'Reference to the ALTA endorsement for which this charge is assessed. Populated only when charge_type is endorsement fee.',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Premium rate schedules vary by county FIPS code and tax district; parcel_id provides jurisdiction for accurate rate application, simultaneous issue determination, and county-specific',
    `premium_split_schedule_id` BIGINT COMMENT 'Foreign key linking to agency.premium_split_schedule. Business justification: Premium charges must reference the applicable split schedule to determine agent versus underwriter premium shares.',
    `prior_version_charge_premium_charge_id` BIGINT COMMENT 'Reference to the previous version of this charge record when a revision or adjustment has been made, preserving the full revision history per VREQ-007.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Premium rate schedules vary by property transaction type, jurisdiction, and assessed value; required for accurate rate application, reissue credit calculation, and revenue recognition by',
    `settlement_statement_id` BIGINT COMMENT 'Reference to the settlement statement (CD/HUD-1/ALTA) on which this charge appears, linking the charge to the closing disclosure.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order for which this premium or fee charge is assessed, linking the charge to the originating transaction.',
    `title_policy_id` BIGINT COMMENT 'Reference to the title policy (owner or lender) for which this premium charge is assessed. Null for non-policy charges such as search or exam fees.',
    `adjustment_amount` DECIMAL(18,2) COMMENT 'Net adjustment applied to the base premium, including simultaneous issue discounts, reissue credits, or regulatory adjustments. Negative values represent credits.',
    `agent_premium_split_amount` DECIMAL(18,2) COMMENT 'Dollar amount of the net charge allocated to the independent title agent per the applicable agency agreement premium split schedule.',
    `authorized_by` STRING COMMENT 'Name or identifier of the underwriter or branch authority who approved a waiver, adjustment, or exception to the standard filed rate for this charge.',
    `base_premium_amount` DECIMAL(18,2) COMMENT 'Gross base premium amount calculated from the applicable rate schedule before any adjustments, discounts, or simultaneous issue credits.',
    `cd_line_item_code` STRING COMMENT 'TRID Closing Disclosure (CD) line item code identifying where this charge appears on the CD form (e.g., Section B, C, or H line reference).',
    `charge_date` DATE COMMENT 'The business event date on which the premium charge was assessed or calculated, typically the closing date or commitment date.',
    `charge_number` STRING COMMENT 'Externally visible business identifier for this premium charge record, assigned by the title production system (e.g., SoftPro/RamQuest charge line reference).',
    `charge_status` STRING COMMENT 'Current lifecycle status of the premium charge: calculated (computed but not yet assessed), assessed, invoiced, collected, waived, adjusted, or voided. [ENUM-REF-CANDIDATE: calculated|assessed|invoiced|collected|waived|adjusted|voided — 7 candidates',
    `charge_type` STRING COMMENT 'Classification of the charge: OTP (Owners Title Policy) premium, LTP (Lenders Title Policy) premium, endorsement fee, search fee, exam fee, or settlement fee.. Valid values are `otp_premium|ltp_premium|endorsement_fee|search_fee|exam_fee|settlement_fee`',
    `collected_date` DATE COMMENT 'Date on which the premium charge was collected from the responsible party at or after closing. Null if not yet collected.',
    `county_fips_code` STRING COMMENT 'Five-digit Federal Information Processing Standards (FIPS) county code for the property location, used for rate jurisdiction and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this premium charge record was first created in the system, used for audit trail and lifecycle tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this charge record. Typically USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `endorsement_type_code` STRING COMMENT 'ALTA endorsement form number or code (e.g., ALTA 9, ALTA 8.1, ALTA 22) when charge_type is endorsement_fee. Null for non-endorsement charges.',
    `gl_account_code` STRING COMMENT 'General Ledger (GL) account code to which this premium charge is posted for revenue recognition and financial reporting purposes.',
    `hud1_line_number` STRING COMMENT 'HUD-1 Settlement Statement line number where this charge appears, applicable for transactions governed by legacy RESPA HUD-1 disclosure requirements.',
    `liability_amount` DECIMAL(18,2) COMMENT 'The insured amount or coverage liability used as the basis for premium calculation (e.g., purchase price for OTP, loan amount for LTP).',
    `net_charge_amount` DECIMAL(18,2) COMMENT 'Final assessed charge amount after all adjustments (base_premium_amount + adjustment_amount). This is the amount appearing on the settlement statement.',
    `notes` STRING COMMENT 'Free-text notes or comments entered by the settlement officer regarding special circumstances, rate justifications, or instructions for this charge.',
    `paid_by_party` STRING COMMENT 'Identifies which transaction party is responsible for paying this charge: buyer, seller, lender, or split between parties.. Valid values are `buyer|seller|lender|split`',
    `policy_type` STRING COMMENT 'Indicates whether the charge relates to an Owners Title Policy (OTP), Lenders Title Policy (LTP), both (simultaneous issue), or is not applicable for non-policy charges.. Valid values are `owner|lender|both|na`',
    `prior_policy_amount` DECIMAL(18,2) COMMENT 'Liability amount of the prior existing title policy used as the basis for calculating a reissue credit. Populated only when reissue_credit_flag is true.',
    `prior_policy_date` DATE COMMENT 'Effective date of the prior title policy used for reissue credit eligibility determination. Must fall within the state-mandated lookback period.',
    `production_channel` STRING COMMENT 'Channel through which the title order was produced: direct branch, centralized lender, or independent agent. Drives premium split and remittance calculations.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `rate_per_thousand` DECIMAL(10,6) COMMENT 'The filed premium rate expressed as a dollar amount per $1,000 of liability amount, sourced from the applicable state-filed rate schedule.',
    `rate_schedule_code` STRING COMMENT 'Code identifying the filed rate schedule or rate table used to calculate the base premium, as maintained in the underwriting rate management system.',
    `reissue_credit_flag` BOOLEAN COMMENT 'Indicates whether a reissue credit was applied to this charge based on a prior existing title policy covering the same property.',
    `remittance_due_date` DATE COMMENT 'Date by which the agents underwriter premium split must be remitted to the underwriter per the agency agreement remittance schedule.',
    `remittance_status` STRING COMMENT 'Current status of the underwriter premium remittance for this charge: pending, remitted, overdue, or waived.. Valid values are `pending|remitted|overdue|waived`',
    `revenue_recognition_date` DATE COMMENT 'Date on which the premium charge is recognized as earned revenue in the general ledger, per applicable accounting standards.',
    `simultaneous_issue_flag` BOOLEAN COMMENT 'Indicates whether this charge benefits from a simultaneous issue discount, applicable when both an OTP and LTP are issued for the same transaction at the same time.',
    `source_system_charge_ref` STRING COMMENT 'Native charge or fee line identifier from the originating title production system (SoftPro Select, RamQuest Horizon, or Qualia) for traceability.',
    `split_percentage` DECIMAL(5,2) COMMENT 'Agents percentage share of the net premium charge as defined in the premium split schedule. Expressed as a percentage (e.g., 70.00 for 70%).',
    `state_code` STRING COMMENT 'Two-letter US state code where the insured property is located, determining the applicable filed rate schedule and regulatory requirements.. Valid values are `^[A-Z]{2}$`',
    `transaction_type` STRING COMMENT 'Type of real estate transaction for which the charge is assessed: purchase, refinance (REFI), home equity line of credit (HELOC), construction, or commercial.. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `underwriter_premium_split_amount` DECIMAL(18,2) COMMENT 'Dollar amount of the net charge retained by or remitted to the underwriter per the applicable agency agreement premium split schedule.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this premium charge record, supporting audit trail and change detection.',
    `version_number` BIGINT COMMENT 'Incremental version counter for this charge record, supporting lifecycle revision tracking per VREQ-007 when charges are recalculated or adjusted.',
    `waiver_reason` STRING COMMENT 'Business justification for waiving or reducing this charge. Populated only when charge_status is waived or adjustment_amount is negative.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_premium_charge PRIMARY KEY(`premium_charge_id`)
) COMMENT 'Transactional record capturing the title insurance premium and related fee charges calculated and assessed at closing for a specific transaction. Tracks charge type (OTP owner title premium, LTP lender title premium, endorsement fee, search fee, exam fee';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` (
    `closing_document_id` BIGINT COMMENT 'Unique surrogate identifier for each closing document record in the settlement domain. Primary key for the closing_document entity.',
    `closing_order_id` BIGINT COMMENT 'Reference to the closing event or closing session during which this document was executed or collected. Supports grouping all documents from a single closing table.',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: Recorded instruments must incorporate the approved Schedule A legal description; critical for deed preparation, mortgage legal sufficiency, title policy accuracy, and ensuring',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Recording documents require exact parcel identification (APN/PIN) for county recorder indexing, grantor-grantee index accuracy, and automated recording system validation; critical for',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Closing documents convey or encumber specific properties; fundamental for recording package assembly, legal description consistency checks, deed preparation, and mortgage legal sufficiency',
    `recording_submission_id` BIGINT COMMENT 'Unique identifier assigned by the eRecording gateway (e.g., Simplifile, CSC eRecording) for the electronic submission of this document. Supports rejection and resubmission tracking.',
    `settlement_statement_id` BIGINT COMMENT 'Reference to the settlement statement (CD/HUD-1/ALTA) associated with this closing document, where applicable. Maintains the distinct settlement_statement entity per VREQ-003.',
    `superseded_by_closing_document_id` BIGINT COMMENT 'Reference to the closing_document record that supersedes this version, if applicable. Preserves prior document versions in the lifecycle history per VREQ-007.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order under which this closing document was collected or executed. Links the document to the originating order lifecycle.',
    `title_policy_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_policy. Business justification: Recorded deeds and mortgages must link to the policy that insured them for claims investigation, coverage determination, and chain-of-title validation.',
    `acceptance_date` DATE COMMENT 'Date the county recorder or filing authority formally accepted the document for recording. Distinct per VREQ-008 from submission and recording dates.',
    `consideration_amount` DECIMAL(18,2) COMMENT 'Dollar amount of consideration stated in the deed or transfer instrument. Used for transfer tax calculation, 1099-S reporting, and transaction value analytics.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this closing document record was first created in the title production system. Supports audit trail and closing-readiness cycle time metrics per VREQ-016.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this document (e.g., USD). Supports multi-currency reporting for commercial transactions.. Valid values are `^[A-Z]{3}$`',
    `document_number` STRING COMMENT 'Externally visible business identifier assigned to this closing document by the title production system (e.g., SoftPro Select / Qualia). Used for tracking and reference in correspondence.',
    `document_page_count` BIGINT COMMENT 'Total number of pages in the closing document. Used for recording fee calculation (many jurisdictions charge per page) and document completeness verification.',
    `document_source` STRING COMMENT 'Originating party or system that provided or prepared this closing document (e.g., lender loan package, title company, borrower-provided identity document).. Valid values are `lender|title_company|attorney|borrower|seller|third_party`',
    `document_status` STRING COMMENT 'Current lifecycle state of the closing document within the settlement workflow. Drives closing-readiness assessment and document completeness tracking.. Valid values are `pending|collected|executed|rejected|voided|superseded`',
    `document_subtype` STRING COMMENT 'Secondary classification providing finer granularity within a document type (e.g., within affidavit: title affidavit, gap affidavit, name affidavit, marital status affidavit). Supports detailed reporting.',
    `document_title` STRING COMMENT 'Human-readable name or title of the document as it appears on the face of the instrument (e.g., Warranty Deed, Closing Disclosure, Affidavit of Title).',
    `document_type` STRING COMMENT 'Classification of the closing document by legal or operational category. Drives routing, execution requirements, and retention rules. [ENUM-REF-CANDIDATE',
    `document_version` BIGINT COMMENT 'Version number of this document, incremented when a document is revised or superseded during the closing lifecycle. Supports lifecycle revision tracking per VREQ-007.',
    `effective_date` DATE COMMENT 'Date on which the document becomes legally operative or binding, which may differ from execution date. Distinct per VREQ-008 (e.g., deed effective date vs. signing date).',
    `erecording_status` STRING COMMENT 'Current status of the document within the eRecording gateway workflow. Drives recording rejection and resubmission rate metrics per VREQ-016.. Valid values are `not_submitted|submitted|accepted|rejected|recorded|resubmitted`',
    `execution_date` DATE COMMENT 'Date the document was signed or executed by the required parties at closing. Distinct from effective, submission, acceptance, and recording dates per VREQ-008.',
    `execution_method` STRING COMMENT 'Method by which the document was executed: wet signature, Remote Online Notarization (RON), In-Person Electronic Notarization (IPEN), or full eClose. Supports RON/IPEN compliance tracking.. Valid values are `wet_sign|ron|ipen|eclose`',
    `fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county of recording jurisdiction. Used for geographic routing, regulatory reporting, and county-level analytics.. Valid values are `^[0-9]{5}$`',
    `grantee_name` STRING COMMENT 'Name of the grantee (buyer/transferee) as it appears on the face of the instrument. Required for vesting, chain-of-title (COT) integrity, and policy issuance.',
    `grantor_name` STRING COMMENT 'Name of the grantor (seller/transferor) as it appears on the face of the instrument. Required for chain-of-title (COT) integrity and recording index matching.',
    `imaging_document_ref` STRING COMMENT 'Identifier or URI referencing the scanned or electronic image of this document in the Document Management and Imaging System. Supports evidence and provenance capture per VREQ-007.',
    `irs_1099s_filed` BOOLEAN COMMENT 'Indicates whether the 1099-S form has been filed with the IRS for this closing document. Supports tax compliance audit and regulatory reporting.',
    `loan_amount` DECIMAL(18,2) COMMENT 'Principal loan amount associated with loan documents executed at closing. Used for lender policy coverage verification and TRID/RESPA compliance.',
    `notarization_date` DATE COMMENT 'Date the document was notarized. Relevant for deeds, affidavits, and other instruments requiring notarial acknowledgment. Supports gap period and recording readiness analysis.',
    `notarization_required` BOOLEAN COMMENT 'Indicates whether this document requires notarization as a condition of validity or recordability. Drives closing coordination and notary scheduling.',
    `notary_commission_expiry_date` DATE COMMENT 'Expiration date of the notarys state commission. Used to validate that the notary was active at the time of notarization, preventing recording rejections.',
    `notary_commission_number` STRING COMMENT 'State-issued commission number of the notary public. Required for recording compliance verification and notary credential audit.',
    `notary_name` STRING COMMENT 'Full name of the notary public who acknowledged or witnessed execution of this document. Required for recording compliance and audit trail.',
    `poa_document_ref` STRING COMMENT 'Reference number or identifier for the power of attorney document used in execution, if applicable. Links to the POA instrument in the document management system.',
    `power_of_attorney_used` BOOLEAN COMMENT 'Indicates whether a power of attorney was used in the execution of this document. Triggers additional underwriting review and POA document collection requirements.',
    `recording_date` DATE COMMENT 'Date the document was officially recorded in the public record by the county recorder. Distinct per VREQ-008 from execution, effective, submission, and acceptance dates.',
    `recording_fee_amount` DECIMAL(10,2) COMMENT 'Fee charged by the county recorder for recording this document. Included in the settlement statement and escrow disbursement. Supports escrow reconciliation.',
    `recording_jurisdiction` STRING COMMENT 'Name of the county or jurisdiction where the document is to be or was recorded (e.g., Cook County, IL). Drives eRecording gateway routing and FIPS code assignment.',
    `recording_rejection_reason` STRING COMMENT 'Reason code or description provided by the county recorder when a document submission is rejected. Supports root-cause analysis of recording rejection rates per VREQ-016.',
    `requires_1099s` BOOLEAN COMMENT 'Indicates whether this document triggers a 1099-S real estate proceeds reporting obligation to the IRS. Drives tax reporting workflow and compliance tracking.',
    `requires_recording` BOOLEAN COMMENT 'Indicates whether this document must be submitted to the county recorder as part of the closing process (e.g., deeds, deeds of trust). Drives recording workflow initiation.',
    `resubmission_count` BIGINT COMMENT 'Number of times this document has been resubmitted to the county recorder after an initial rejection. Supports recording rejection and resubmission rate metrics per VREQ-016.',
    `submission_date` DATE COMMENT 'Date the document was submitted to the county recorder or relevant authority for recording or filing. Distinct per VREQ-008 from execution, effective, acceptance, and recording dates.',
    `transfer_tax_amount` DECIMAL(18,2) COMMENT 'State or county transfer tax assessed on the conveyance as reflected in the transfer tax declaration. Supports settlement statement reconciliation and regulatory reporting.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this closing document record was last modified in the title production system. Supports change tracking and lifecycle history per VREQ-007.',
    `vesting_type` STRING COMMENT 'Form of title vesting for the grantee as stated in the deed or closing document (e.g., joint tenancy, tenancy in common, community property). Drives ownership interest modeling per VREQ-005.. Valid values are `sole_ownership|joint_tenancy|tenancy_in_common|community_property|trust|entity`',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_closing_document PRIMARY KEY(`closing_document_id`)
) COMMENT 'Master record for each document executed or collected during the closing event (loan documents, deeds, affidavits, title affidavits, ALTA statements, 1099-S forms, transfer tax declarations, power of attorney, identity documents).';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` (
    `escrow_reconciliation_id` BIGINT COMMENT 'Unique surrogate identifier for the escrow trust account three-way reconciliation record. Primary key for this entity.',
    `approved_by_supervisor_party_id` BIGINT COMMENT 'Reference to the supervising manager or compliance officer who reviewed and approved this reconciliation record per ALTA dual-control requirements.',
    `escrow_ledger_id` BIGINT COMMENT 'Reference to the escrow trust account (IOLTA or dedicated trust account) being reconciled in this record.',
    `party_id` BIGINT COMMENT 'Reference to the escrow officer or trust accounting staff member who performed and submitted this reconciliation for supervisory review.',
    `account_type` STRING COMMENT 'Classification of the escrow trust account being reconciled. IOLTA accounts hold client funds earning interest for legal aid; dedicated trust accounts are file-specific.. Valid values are `iolta|dedicated_trust|operating|pooled_trust`',
    `adjusted_bank_balance` DECIMAL(18,2) COMMENT 'Bank statement balance plus outstanding deposits minus outstanding checks. Represents the reconciled bank-side balance for comparison to the escrow ledger balance.',
    `approval_date` DATE COMMENT 'Date on which the supervising manager or compliance officer formally approved this reconciliation record as complete and accurate.',
    `approval_notes` STRING COMMENT 'Free-text notes entered by the approving supervisor at the time of reconciliation approval, documenting any conditions, exceptions, or follow-up actions required.',
    `bank_account_number_masked` STRING COMMENT 'Masked bank account number showing only the last four digits, used for display and audit purposes. Full account number stored in the Identity and NPPI Vault per GLBA.. Valid values are `^[X*]{4,12}[0-9]{4}$`',
    `bank_name` STRING COMMENT 'Name of the financial institution holding the escrow trust account being reconciled (e.g., Wells Fargo, JPMorgan Chase).',
    `bank_routing_number` STRING COMMENT 'ABA routing transit number of the financial institution holding the escrow trust account. Used to identify the bank for reconciliation and wire verification purposes.. Valid values are `^[0-9]{9}$`',
    `bank_statement_balance` DECIMAL(18,2) COMMENT 'Ending balance per the bank statement for the reconciliation period. First leg of the three-way reconciliation. Denominated in USD.',
    `bank_statement_date` DATE COMMENT 'The statement date of the bank statement used as the primary source for the bank-side leg of the three-way reconciliation.',
    `bank_to_ledger_variance` DECIMAL(18,2) COMMENT 'Difference between the adjusted bank balance and the escrow ledger balance. A non-zero value indicates a discrepancy requiring investigation and resolution.',
    `branch_code` BIGINT COMMENT 'Reference to the direct branch or closing office responsible for the escrow trust account being reconciled.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this escrow reconciliation record was first created in the system. Supports audit trail and lifecycle tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this reconciliation record. Typically USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `days_to_reconcile` BIGINT COMMENT 'Number of calendar days elapsed between the reconciliation period end date and the date the reconciliation was completed. Supports cycle-time analytics per VREQ-016.',
    `escrow_ledger_balance` DECIMAL(18,2) COMMENT 'Total balance per the escrow trust accounting ledger as of the reconciliation period end date. Second leg of the three-way reconciliation.',
    `is_balanced` BOOLEAN COMMENT 'Indicates whether all three legs of the reconciliation (bank, ledger, open files) agree within the defined tolerance threshold. True when fully balanced.',
    `is_regulatory_reportable` BOOLEAN COMMENT 'Indicates whether this reconciliation record or its variance must be reported to a state Department of Insurance or other regulatory body per applicable state requirements.',
    `ledger_to_file_variance` DECIMAL(18,2) COMMENT 'Difference between the escrow ledger balance and the aggregate of open file balances. A non-zero value indicates unallocated funds or file balance errors.',
    `open_file_balance_aggregate` DECIMAL(18,2) COMMENT 'Sum of all individual open escrow file (order) balances as of the reconciliation period end date. Third leg of the three-way reconciliation per ALTA Best Practices.',
    `open_file_count` BIGINT COMMENT 'Number of individual escrow files (title orders) with open balances included in the open file balance aggregate for this reconciliation period.',
    `outstanding_check_count` BIGINT COMMENT 'Number of individual checks or disbursement items issued but not yet cleared the bank as of the reconciliation date.',
    `outstanding_checks_amount` DECIMAL(18,2) COMMENT 'Total of checks or wire disbursements issued but not yet cleared the bank as of the reconciliation date. Adjusts bank balance downward.',
    `outstanding_deposits_amount` DECIMAL(18,2) COMMENT 'Total of deposits recorded in the escrow ledger but not yet reflected on the bank statement as of the reconciliation date. Adjusts bank balance upward.',
    `positive_pay_submission_date` DATE COMMENT 'Date on which the positive pay file was submitted to the bank for the reconciliation period. Null if positive pay was not submitted.',
    `positive_pay_submitted` BOOLEAN COMMENT 'Indicates whether a positive pay file was submitted to the bank for this reconciliation period to prevent check fraud on the escrow trust account.',
    `prior_period_variance_amount` DECIMAL(18,2) COMMENT 'Unresolved variance amount carried forward from the immediately preceding reconciliation period. Non-zero values indicate aging discrepancies requiring escalation.',
    `reconciliation_date` DATE COMMENT 'The business date on which the three-way reconciliation was performed by the escrow officer or trust accounting staff.',
    `reconciliation_number` STRING COMMENT 'Externally-known business identifier for this reconciliation run, typically formatted as RECON-YYYY-MM-NNNNNN. Used for audit trail and operational reference.. Valid values are `^RECON-[0-9]{4}-[0-9]{2}-[0-9]{6}$`',
    `reconciliation_period_end_date` DATE COMMENT 'Last calendar date of the reconciliation period covered by this record, typically the last day of the statement month.',
    `reconciliation_period_start_date` DATE COMMENT 'First calendar date of the reconciliation period covered by this record, typically the first day of the statement month.',
    `reconciliation_status` STRING COMMENT 'Current lifecycle state of the reconciliation record. Balanced indicates all three legs agree within tolerance; out_of_balance triggers investigation workflow.. Valid values are `in_progress|balanced|out_of_balance|under_review|approved|voided`',
    `reconciliation_type` STRING COMMENT 'Classification of the reconciliation procedure performed. Three-way compares bank statement, escrow ledger, and open file balances simultaneously per ALTA Best Practices.. Valid values are `three_way|bank_to_ledger|ledger_to_file|positive_pay`',
    `regulatory_report_date` DATE COMMENT 'Date on which this reconciliation or its associated variance was reported to the applicable state regulatory authority. Null if not yet reported or not required.',
    `source_system_code` STRING COMMENT 'Code identifying the escrow and trust accounting system of record from which this reconciliation data was extracted (e.g., SoftPro Trust Accounting, RamQuest).. Valid values are `softpro|ramquest|qualia|other`',
    `source_system_recon_ref` STRING COMMENT 'Native reconciliation record identifier from the originating escrow trust accounting system (SoftPro, RamQuest, etc.) for lineage and cross-system traceability.',
    `stale_check_amount` DECIMAL(18,2) COMMENT 'Total dollar value of outstanding checks that have exceeded the stale-date threshold and are subject to escheatment or reissuance review.',
    `stale_check_count` BIGINT COMMENT 'Number of outstanding checks that have exceeded the stale-date threshold (typically 90–180 days) and require escheatment review or reissuance action.',
    `tolerance_amount` DECIMAL(18,2) COMMENT 'Maximum allowable variance in USD between reconciliation legs before the record is flagged as out-of-balance. Typically set to $0.00 for trust accounts per ALTA.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this escrow reconciliation record. Supports change detection and audit trail requirements.',
    `variance_explanation` STRING COMMENT 'Free-text explanation provided by the escrow officer or supervisor describing the cause of any out-of-balance condition and the planned resolution steps.',
    `variance_resolution_status` STRING COMMENT 'Current status of the investigation and resolution effort for any out-of-balance variance identified in this reconciliation record.. Valid values are `not_applicable|open|in_investigation|resolved|escalated`',
    `variance_resolved_date` DATE COMMENT 'Date on which the out-of-balance variance was fully resolved and the reconciliation was confirmed as balanced. Null if variance remains open.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_escrow_reconciliation PRIMARY KEY(`escrow_reconciliation_id`)
) COMMENT 'Periodic three-way reconciliation record for the escrow trust account, comparing the escrow ledger balance against the bank statement balance and the aggregate of open file balances.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` (
    `escrow_receipt_id` BIGINT COMMENT 'Unique surrogate identifier for each escrow trust account receipt record. Primary key for the escrow_receipt entity.',
    `escrow_ledger_id` BIGINT COMMENT 'Reference to the escrow/IOLTA trust ledger into which this receipt is posted. Links the receipt to the closing-level ledger balance.',
    `escrow_officer_party_id` BIGINT COMMENT 'Reference to the escrow officer (EOT) responsible for receiving and posting this receipt. Supports accountability, audit, and closing-readiness tracking.',
    `party_id` BIGINT COMMENT 'Reference to the party (buyer, seller, lender, agent, HOA) who remitted the funds. Supports multi-role party model.',
    `prior_receipt_escrow_receipt_id` BIGINT COMMENT 'Self-referencing link to the original receipt record when this record represents a correction, repost, or replacement. Preserves lifecycle history per VREQ-007.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Receipts (earnest money deposits, buyer funds, loan proceeds) are collected for specific property transactions; needed for escrow accounting reconciliation, funds-to-property traceability',
    `remitter_party_role_id` BIGINT COMMENT 'Foreign key linking to operations.party_role. Business justification: Receipts from parties in specific roles (buyer earnest money, borrower down payment, lender loan proceeds) require role context for proper settlement statement allocation, TRID',
    `settlement_statement_id` BIGINT COMMENT 'Reference to the settlement statement (CD/HUD-1/ALTA) to which this receipt is applied, supporting TRID/RESPA reconciliation.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order associated with this escrow receipt, enabling traceability from receipt to the originating transaction.',
    `wire_instruction_id` BIGINT COMMENT 'Reference to the verified wire instruction record that authorized this incoming wire receipt. Supports fraud prevention and wire verification audit trail.',
    `ach_trace_number` STRING COMMENT 'NACHA-assigned trace number for ACH credit entries received into the trust account. Populated only when funds_type is ach; supports return and NOC processing.',
    `adjustment_amount` DECIMAL(18,2) COMMENT 'Adjustment applied to the gross receipt amount (e.g., bank return fee, wire shortfall correction). Negative value indicates a deduction; zero if no adjustment.',
    `branch_code` BIGINT COMMENT 'Reference to the direct branch or centralized lender channel office where this receipt was processed. Supports channel-level reconciliation and reporting.',
    `check_number` STRING COMMENT 'Check number from the remitters instrument when funds_type is check, cashiers_check, or certified_check. Used for positive-pay matching and bank reconciliation.',
    `created_timestamp` TIMESTAMP COMMENT 'Audit timestamp when this escrow receipt record was first created in the system of record (SoftPro Trust Accounting / RamQuest).',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the receipt amount (e.g., USD). Required for multi-currency trust account compliance.. Valid values are `^[A-Z]{3}$`',
    `emd_contract_date` DATE COMMENT 'Date of the purchase contract requiring the EMD. Populated only when emd_flag is true; used to verify timely EMD receipt per contract terms.',
    `emd_flag` BOOLEAN COMMENT 'Indicates whether this receipt represents an Earnest Money Deposit (EMD). True when receipt_type is emd; drives EMD tracking and forfeiture/return workflows.',
    `expected_receipt_amount` DECIMAL(18,2) COMMENT 'Amount expected to be received per the settlement statement or wire instruction. Compared against receipt_amount to detect shortfalls or overages at closing.',
    `fraud_alert_flag` BOOLEAN COMMENT 'Indicates whether a fraud alert has been raised on this receipt (e.g., suspicious wire origin, mismatched remitter, business email compromise indicator).',
    `fraud_alert_notes` STRING COMMENT 'Free-text description of the fraud alert reason or investigation notes when fraud_alert_flag is true. Supports escrow officer review and SAR filing if required.',
    `funds_type` STRING COMMENT 'Method by which the funds were remitted: wire transfer, personal check, ACH, cashiers check, certified check, cash, or electronic transfer. Governs availability and positive-pay rules.',
    `gl_account_code` STRING COMMENT 'General ledger account code to which this receipt is mapped in the ERP/GL system for premium revenue recognition and trust account accounting.',
    `iolta_account_flag` BOOLEAN COMMENT 'Indicates whether the receiving trust account is an Interest on Lawyers Trust Account (IOLTA). True when IOLTA rules apply to interest disposition.',
    `memo` STRING COMMENT 'Free-text memo or description entered by the escrow officer at the time of receipt posting, capturing remitter instructions or special handling notes.',
    `net_receipt_amount` DECIMAL(18,2) COMMENT 'Net funds credited to the escrow ledger after adjustments (receipt_amount + adjustment_amount). Used in three-way reconciliation and ledger balance calculations.',
    `positive_pay_submitted_flag` BOOLEAN COMMENT 'Indicates whether this receipt was submitted to the banks positive-pay system for check verification. Applicable when funds_type is check or cashiers_check.',
    `posted_timestamp` TIMESTAMP COMMENT 'Date and time the receipt was posted to the escrow ledger in the trust accounting system, which may differ from received_timestamp due to processing lag.',
    `receipt_amount` DECIMAL(18,2) COMMENT 'Gross amount of funds received into the escrow trust account for this receipt record. Base monetary fact before any adjustments or reversals.',
    `receipt_date` DATE COMMENT 'Calendar date on which the funds were physically or electronically received into the escrow/IOLTA trust account. Principal business event date for this receipt.',
    `receipt_number` STRING COMMENT 'Externally visible, human-readable receipt number assigned by the escrow/trust accounting system (e.g., SoftPro Trust Accounting) for audit and reconciliation.',
    `receipt_status` STRING COMMENT 'Current lifecycle status of the receipt within the trust accounting workflow. Drives reconciliation and positive-pay processing.. Valid values are `pending|posted|reversed|returned|void`',
    `receipt_type` STRING COMMENT 'Classification of the incoming funds: EMD (Earnest Money Deposit), loan proceeds wire-in, buyer cash-to-close, seller contribution, HOA/payoff overfund return, or other.. Valid values are `emd|loan_proceeds|buyer_cash_to_close|seller_contribution|payoff_overfund_return|other`',
    `received_timestamp` TIMESTAMP COMMENT 'Precise date and time the funds were confirmed received into the trust account, including timezone offset. Used for same-day wire cutoff and positive-pay validation.',
    `remitter_account_token` STRING COMMENT 'Tokenized reference to the remitters bank account number stored in the NPPI/Identity Vault. Never stores raw account number; token resolves to vault record per GLBA.',
    `remitter_bank_name` STRING COMMENT 'Name of the financial institution from which the funds originated. Used for fraud screening and wire verification per ALTA Best Practices Pillar 3.',
    `remitter_name` STRING COMMENT 'Full legal name of the individual or entity remitting the funds. NPPI/PII — stored with restricted classification per GLBA and CFPB requirements.',
    `remitter_party_role` STRING COMMENT 'Role of the party remitting the funds at the time of this receipt (buyer, seller, lender, independent agent, HOA, third party). Contextual role per VREQ-006.',
    `reversal_date` DATE COMMENT 'Date on which the receipt reversal was processed. Populated only when reversal_flag is true; used to calculate net trust account balance impact.',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this receipt has been reversed (e.g., returned check, wire recall, ACH return). True triggers a corresponding reversal entry in the escrow ledger.',
    `reversal_reason` STRING COMMENT 'Reason code for the reversal when reversal_flag is true: NSF, stop payment, wire recall, ACH return, duplicate posting, data entry error, or other. [ENUM-REF-CANDIDATE: nsf|stop_payment|wire_recall|ach_return|duplicate|error|other — 7 candidates stripped',
    `source_system_receipt_ref` STRING COMMENT 'Native receipt identifier from the originating escrow/trust accounting system (SoftPro Trust Accounting, RamQuest) for lineage and reconciliation back to the system of record.',
    `trust_account_bank_name` STRING COMMENT 'Name of the financial institution holding the escrow/IOLTA trust account. Required for three-way reconciliation and state insurance department reporting.',
    `trust_account_number` STRING COMMENT 'Escrow/IOLTA trust bank account number into which the receipt was deposited. Restricted per GLBA and ALTA Best Practices Pillar 2 trust account segregation requirements.',
    `updated_timestamp` TIMESTAMP COMMENT 'Audit timestamp of the most recent modification to this escrow receipt record, supporting change tracking and three-way reconciliation audit trails.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Difference between receipt_amount and expected_receipt_amount (receipt_amount minus expected_receipt_amount). Non-zero values trigger escrow officer review and reconciliation action.',
    `wire_reference_number` STRING COMMENT 'Fedwire or CHIPS reference number assigned to the incoming wire transfer. Populated only when funds_type is wire; used for bank reconciliation and fraud verification.',
    `wire_verification_method` STRING COMMENT 'Method used to verify the incoming wire against the authorized instruction: callback, secure portal, verbal, written confirmation, or not applicable for non-wire receipts.. Valid values are `callback|secure_portal|verbal|written|not_applicable`',
    `wire_verified_flag` BOOLEAN COMMENT 'Indicates whether the incoming wire was verified against the authorized wire instruction prior to posting. Required by ALTA Best Practices Pillar 3 fraud controls.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_escrow_receipt PRIMARY KEY(`escrow_receipt_id`)
) COMMENT 'Individual incoming funds-received record representing a single deposit into the escrow/IOLTA trust account for a specific closing (EMD/earnest money receipt, loan proceeds wire-in, buyer cash-to-close, seller contribution, HOA/payoff overfund return).';

-- ========= FOREIGN KEYS =========
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_escrow_ledger_id` FOREIGN KEY (`escrow_ledger_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger`(`escrow_ledger_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_settlement_statement_id` FOREIGN KEY (`settlement_statement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement`(`settlement_statement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ADD CONSTRAINT `fk_settlement_settlement_statement_prior_statement_settlement_statement_id` FOREIGN KEY (`prior_statement_settlement_statement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement`(`settlement_statement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ADD CONSTRAINT `fk_settlement_escrow_ledger_settlement_statement_id` FOREIGN KEY (`settlement_statement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement`(`settlement_statement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ADD CONSTRAINT `fk_settlement_disbursement_escrow_ledger_id` FOREIGN KEY (`escrow_ledger_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger`(`escrow_ledger_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ADD CONSTRAINT `fk_settlement_disbursement_settlement_statement_id` FOREIGN KEY (`settlement_statement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement`(`settlement_statement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ADD CONSTRAINT `fk_settlement_wire_instruction_closing_order_id` FOREIGN KEY (`closing_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order`(`closing_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ADD CONSTRAINT `fk_settlement_wire_instruction_disbursement_id` FOREIGN KEY (`disbursement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement`(`disbursement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ADD CONSTRAINT `fk_settlement_wire_instruction_prior_instruction_wire_instruction_id` FOREIGN KEY (`prior_instruction_wire_instruction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction`(`wire_instruction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ADD CONSTRAINT `fk_settlement_premium_charge_prior_version_charge_premium_charge_id` FOREIGN KEY (`prior_version_charge_premium_charge_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge`(`premium_charge_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ADD CONSTRAINT `fk_settlement_premium_charge_settlement_statement_id` FOREIGN KEY (`settlement_statement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement`(`settlement_statement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ADD CONSTRAINT `fk_settlement_closing_document_closing_order_id` FOREIGN KEY (`closing_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order`(`closing_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ADD CONSTRAINT `fk_settlement_closing_document_settlement_statement_id` FOREIGN KEY (`settlement_statement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement`(`settlement_statement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ADD CONSTRAINT `fk_settlement_closing_document_superseded_by_closing_document_id` FOREIGN KEY (`superseded_by_closing_document_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document`(`closing_document_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ADD CONSTRAINT `fk_settlement_escrow_reconciliation_escrow_ledger_id` FOREIGN KEY (`escrow_ledger_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger`(`escrow_ledger_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ADD CONSTRAINT `fk_settlement_escrow_receipt_escrow_ledger_id` FOREIGN KEY (`escrow_ledger_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger`(`escrow_ledger_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ADD CONSTRAINT `fk_settlement_escrow_receipt_prior_receipt_escrow_receipt_id` FOREIGN KEY (`prior_receipt_escrow_receipt_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt`(`escrow_receipt_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ADD CONSTRAINT `fk_settlement_escrow_receipt_settlement_statement_id` FOREIGN KEY (`settlement_statement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement`(`settlement_statement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ADD CONSTRAINT `fk_settlement_escrow_receipt_wire_instruction_id` FOREIGN KEY (`wire_instruction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction`(`wire_instruction_id`);

-- ========= TAGS =========
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_settlement` SET TAGS ('title_division' = 'business');
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_settlement` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` SET TAGS ('title_subdomain' = 'closing_coordination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_order_id` SET TAGS ('title_business_glossary_term' = 'Closing Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `agency_agreement_id` SET TAGS ('title_business_glossary_term' = 'Agency Agreement Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_escrow_officer_party_id` SET TAGS ('title_business_glossary_term' = 'Escrow Officer Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_lender_party_id` SET TAGS ('title_business_glossary_term' = 'Lender Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `cpl_issuance_id` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issuance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `escrow_ledger_id` SET TAGS ('title_business_glossary_term' = 'Escrow Ledger ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `primary_closing_agent_party_id` SET TAGS ('title_business_glossary_term' = 'Closing Agent Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `settlement_statement_id` SET TAGS ('title_business_glossary_term' = 'Settlement Statement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `actual_closing_timestamp` SET TAGS ('title_business_glossary_term' = 'Actual Closing Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `all_requirements_cleared` SET TAGS ('title_business_glossary_term' = 'All Title Requirements Cleared Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `cancellation_date` SET TAGS ('title_business_glossary_term' = 'Cancellation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `cancellation_reason` SET TAGS ('title_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `cash_to_close_amount` SET TAGS ('title_business_glossary_term' = 'Cash to Close Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `cash_to_close_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `cash_to_close_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `cd_acknowledged_date` SET TAGS ('title_business_glossary_term' = 'Closing Disclosure (CD) Acknowledgment Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `cd_delivery_date` SET TAGS ('title_business_glossary_term' = 'Closing Disclosure (CD) Delivery Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_location_type` SET TAGS ('title_business_glossary_term' = 'Closing Location Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_location_type` SET TAGS ('title_value_regex' = 'branch_office|title_plant|attorney_office|remote|lender_office');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_method` SET TAGS ('title_business_glossary_term' = 'Closing Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_method` SET TAGS ('title_value_regex' = 'wet_sign|ron|ipen|hybrid');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_readiness_status` SET TAGS ('title_business_glossary_term' = 'Closing Readiness Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_readiness_status` SET TAGS ('title_value_regex' = 'not_ready|conditionally_ready|ready_to_close|closed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_status` SET TAGS ('title_business_glossary_term' = 'Closing Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `closing_status` SET TAGS ('title_value_regex' = 'scheduled|in_progress|closed|cancelled|on_hold|pending_funding');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `cpl_issued` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issued Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `disbursement_date` SET TAGS ('title_business_glossary_term' = 'Disbursement Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `earnest_money_deposit_amount` SET TAGS ('title_business_glossary_term' = 'Earnest Money Deposit (EMD) Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `earnest_money_deposit_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `earnest_money_deposit_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `funding_date` SET TAGS ('title_business_glossary_term' = 'Funding Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `gap_coverage_end_date` SET TAGS ('title_business_glossary_term' = 'Gap Coverage End Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `gap_coverage_required` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `gap_coverage_start_date` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `iolta_account_flag` SET TAGS ('title_business_glossary_term' = 'Interest on Lawyers Trust Account (IOLTA) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `lender_closing_instructions_date` SET TAGS ('title_business_glossary_term' = 'Lender Closing Instructions Receipt Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `lender_closing_instructions_received` SET TAGS ('title_business_glossary_term' = 'Lender Closing Instructions Received Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `loan_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `loan_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `ltv_ratio` SET TAGS ('title_business_glossary_term' = 'Loan-to-Value (LTV) Ratio');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `number` SET TAGS ('title_business_glossary_term' = 'Closing Order Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `number` SET TAGS ('title_value_regex' = '^[A-Z0-9-]{6,30}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `positive_pay_submitted` SET TAGS ('title_business_glossary_term' = 'Positive Pay Submitted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `purchase_price_amount` SET TAGS ('title_business_glossary_term' = 'Purchase Price Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `purchase_price_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `purchase_price_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `scheduled_closing_date` SET TAGS ('title_business_glossary_term' = 'Scheduled Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `scheduled_closing_time` SET TAGS ('title_business_glossary_term' = 'Scheduled Closing Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `settlement_form_type` SET TAGS ('title_business_glossary_term' = 'Settlement Form Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `settlement_form_type` SET TAGS ('title_value_regex' = 'cd|hud1|alta_settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `three_way_reconciliation_status` SET TAGS ('title_business_glossary_term' = 'Three-Way Reconciliation Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `three_way_reconciliation_status` SET TAGS ('title_value_regex' = 'pending|in_progress|reconciled|exception');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `title_premium_lender_amount` SET TAGS ('title_business_glossary_term' = 'Lender Title Policy (LTP) Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `title_premium_lender_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `title_premium_lender_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `title_premium_owner_amount` SET TAGS ('title_business_glossary_term' = 'Owner Title Policy (OTP) Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `title_premium_owner_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `title_premium_owner_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `total_settlement_charges_amount` SET TAGS ('title_business_glossary_term' = 'Total Settlement Charges Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `total_settlement_charges_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `total_settlement_charges_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `wire_instructions_verified` SET TAGS ('title_business_glossary_term' = 'Wire Instructions Verified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` SET TAGS ('title_subdomain' = 'closing_coordination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `settlement_statement_id` SET TAGS ('title_business_glossary_term' = 'Settlement Statement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `prior_statement_settlement_statement_id` SET TAGS ('title_business_glossary_term' = 'Prior Settlement Statement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `cash_to_close` SET TAGS ('title_business_glossary_term' = 'Cash to Close');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `cash_to_close` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `cash_to_close` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `closing_date` SET TAGS ('title_business_glossary_term' = 'Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `closing_location` SET TAGS ('title_business_glossary_term' = 'Closing Location');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `closing_method` SET TAGS ('title_business_glossary_term' = 'Closing Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `closing_method` SET TAGS ('title_value_regex' = 'wet_sign|ron|ipen|mail_away');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `cpl_issued` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issued');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = 'USD');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `disbursement_date` SET TAGS ('title_business_glossary_term' = 'Disbursement Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `earnest_money_deposit` SET TAGS ('title_business_glossary_term' = 'Earnest Money Deposit (EMD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `earnest_money_deposit` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `earnest_money_deposit` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `gross_amount_due_borrower` SET TAGS ('title_business_glossary_term' = 'Gross Amount Due from Borrower');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `gross_amount_due_borrower` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `gross_amount_due_borrower` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `hoa_dues_prorated` SET TAGS ('title_business_glossary_term' = 'Prorated Homeowners Association (HOA) Dues');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `hoa_dues_prorated` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `hoa_dues_prorated` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `irs_1099s_required` SET TAGS ('title_business_glossary_term' = 'IRS Form 1099-S Required');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `lender_title_premium` SET TAGS ('title_business_glossary_term' = 'Lenders Title Insurance Premium (LTP)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `lender_title_premium` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `lender_title_premium` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `loan_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `loan_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `owner_title_premium` SET TAGS ('title_business_glossary_term' = 'Owners Title Insurance Premium (OTP)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `owner_title_premium` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `owner_title_premium` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `payoff_first_mortgage` SET TAGS ('title_business_glossary_term' = 'Payoff — First Mortgage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `payoff_first_mortgage` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `payoff_first_mortgage` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `payoff_second_mortgage` SET TAGS ('title_business_glossary_term' = 'Payoff — Second Mortgage / HELOC');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `payoff_second_mortgage` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `payoff_second_mortgage` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `production_channel` SET TAGS ('title_business_glossary_term' = 'Production Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `production_channel` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `prorated_taxes` SET TAGS ('title_business_glossary_term' = 'Prorated Property Taxes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `prorated_taxes` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `prorated_taxes` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `real_estate_commission` SET TAGS ('title_business_glossary_term' = 'Real Estate Commission');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `real_estate_commission` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `real_estate_commission` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `recording_fees` SET TAGS ('title_business_glossary_term' = 'Recording Fees');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `rescission_expiry_date` SET TAGS ('title_business_glossary_term' = 'Rescission Expiry Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `sales_price` SET TAGS ('title_business_glossary_term' = 'Sales Price');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `sales_price` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `sales_price` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `seller_net_proceeds` SET TAGS ('title_business_glossary_term' = 'Seller Net Proceeds');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `seller_net_proceeds` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `seller_net_proceeds` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `settlement_agent_name` SET TAGS ('title_business_glossary_term' = 'Settlement Agent Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `settlement_fee` SET TAGS ('title_business_glossary_term' = 'Settlement / Closing Fee');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `settlement_fee` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `settlement_fee` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `statement_form_type` SET TAGS ('title_business_glossary_term' = 'Settlement Statement Form Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `statement_form_type` SET TAGS ('title_value_regex' = 'CD|HUD-1|ALTA');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `statement_number` SET TAGS ('title_business_glossary_term' = 'Settlement Statement Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `statement_status` SET TAGS ('title_business_glossary_term' = 'Settlement Statement Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `statement_status` SET TAGS ('title_value_regex' = 'draft|issued|revised|final|voided');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `three_day_waiting_period_met` SET TAGS ('title_business_glossary_term' = 'Three-Day Waiting Period Met (TRID)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `tolerance_cure_amount` SET TAGS ('title_business_glossary_term' = 'TRID Tolerance Cure Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `tolerance_cure_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `tolerance_cure_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `total_closing_costs_borrower` SET TAGS ('title_business_glossary_term' = 'Total Closing Costs — Borrower');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `total_closing_costs_borrower` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `total_closing_costs_borrower` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `total_closing_costs_seller` SET TAGS ('title_business_glossary_term' = 'Total Closing Costs — Seller');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `total_closing_costs_seller` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `total_closing_costs_seller` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `total_credits_borrower` SET TAGS ('title_business_glossary_term' = 'Total Credits to Borrower');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `total_credits_borrower` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `total_credits_borrower` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|home_equity|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `trid_applicable` SET TAGS ('title_business_glossary_term' = 'TRID (TILA-RESPA Integrated Disclosure) Applicable');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `wire_amount_borrower` SET TAGS ('title_business_glossary_term' = 'Wire Amount — Borrower');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `wire_amount_borrower` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `wire_amount_borrower` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `wire_amount_lender` SET TAGS ('title_business_glossary_term' = 'Wire Amount — Lender');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `wire_amount_lender` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `wire_amount_lender` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` SET TAGS ('title_subdomain' = 'funds_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `escrow_ledger_id` SET TAGS ('title_business_glossary_term' = 'Escrow Ledger ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `cpl_issuance_id` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issuance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Escrow Officer (EOT) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `settlement_statement_id` SET TAGS ('title_business_glossary_term' = 'Settlement Statement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `actual_closing_date` SET TAGS ('title_business_glossary_term' = 'Actual Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `branch_code` SET TAGS ('title_business_glossary_term' = 'Branch ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `buyer_funds_amount` SET TAGS ('title_business_glossary_term' = 'Buyer Funds Amount (Cash to Close)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `buyer_funds_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `buyer_funds_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `cpl_issued` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issued Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `current_balance` SET TAGS ('title_business_glossary_term' = 'Current Escrow Balance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `current_balance` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `current_balance` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `disbursement_authorization_method` SET TAGS ('title_business_glossary_term' = 'Disbursement Authorization Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `disbursement_authorization_method` SET TAGS ('title_value_regex' = 'dual_signature|single_signature|electronic_approval|not_set');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `emd_amount` SET TAGS ('title_business_glossary_term' = 'Earnest Money Deposit (EMD) Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `emd_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `emd_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `emd_received_date` SET TAGS ('title_business_glossary_term' = 'Earnest Money Deposit (EMD) Received Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `escrow_fee_amount` SET TAGS ('title_business_glossary_term' = 'Escrow/Settlement Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `escrow_fee_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `escrow_fee_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `gl_account_code` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `holdback_amount` SET TAGS ('title_business_glossary_term' = 'Escrow Holdback Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `holdback_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `holdback_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `holdback_release_date` SET TAGS ('title_business_glossary_term' = 'Holdback Release Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `iolta_account_flag` SET TAGS ('title_business_glossary_term' = 'Interest on Lawyers Trust Account (IOLTA) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `last_updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `ledger_close_date` SET TAGS ('title_business_glossary_term' = 'Escrow Ledger Close Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `ledger_number` SET TAGS ('title_business_glossary_term' = 'Escrow Ledger Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `ledger_status` SET TAGS ('title_business_glossary_term' = 'Escrow Ledger Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `ledger_status` SET TAGS ('title_value_regex' = 'open|pending_close|closed|reconciled|voided|suspended');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `ledger_type` SET TAGS ('title_business_glossary_term' = 'Escrow Ledger Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `ledger_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|home_equity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `loan_proceeds_amount` SET TAGS ('title_business_glossary_term' = 'Loan Proceeds Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `loan_proceeds_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `loan_proceeds_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `opening_date` SET TAGS ('title_business_glossary_term' = 'Escrow Opening Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `out_of_balance_amount` SET TAGS ('title_business_glossary_term' = 'Out-of-Balance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `out_of_balance_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `out_of_balance_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `out_of_balance_reason` SET TAGS ('title_business_glossary_term' = 'Out-of-Balance Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `payoff_amount` SET TAGS ('title_business_glossary_term' = 'Existing Lien Payoff Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `payoff_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `payoff_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `positive_pay_enrolled` SET TAGS ('title_business_glossary_term' = 'Positive Pay Enrolled Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `recording_fee_amount` SET TAGS ('title_business_glossary_term' = 'Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `recording_fee_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `recording_fee_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `scheduled_closing_date` SET TAGS ('title_business_glossary_term' = 'Scheduled Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `seller_proceeds_amount` SET TAGS ('title_business_glossary_term' = 'Seller Net Proceeds Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `seller_proceeds_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `seller_proceeds_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `source_system_ledger_ref` SET TAGS ('title_business_glossary_term' = 'Source System Ledger Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `three_way_reconciliation_date` SET TAGS ('title_business_glossary_term' = 'Three-Way Reconciliation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `three_way_reconciliation_status` SET TAGS ('title_business_glossary_term' = 'Three-Way Reconciliation Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `three_way_reconciliation_status` SET TAGS ('title_value_regex' = 'balanced|out_of_balance|pending|not_performed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `title_premium_amount` SET TAGS ('title_business_glossary_term' = 'Title Insurance Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `title_premium_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `title_premium_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `total_disbursements_amount` SET TAGS ('title_business_glossary_term' = 'Total Disbursements Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `total_disbursements_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `total_disbursements_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `total_receipts_amount` SET TAGS ('title_business_glossary_term' = 'Total Receipts Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `total_receipts_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `total_receipts_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `trust_account_bank_name` SET TAGS ('title_business_glossary_term' = 'Trust Account Bank Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `trust_account_number` SET TAGS ('title_business_glossary_term' = 'Trust Account Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `trust_account_number` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `trust_account_number` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `trust_account_routing_number` SET TAGS ('title_business_glossary_term' = 'Trust Account ABA Routing Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `trust_account_routing_number` SET TAGS ('title_value_regex' = '^[0-9]{9}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `trust_account_routing_number` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `trust_account_routing_number` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `wire_instruction_verified` SET TAGS ('title_business_glossary_term' = 'Wire Instruction Verified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `wire_verification_method` SET TAGS ('title_business_glossary_term' = 'Wire Verification Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `wire_verification_method` SET TAGS ('title_value_regex' = 'phone_callback|secure_portal|in_person|not_verified');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` SET TAGS ('title_subdomain' = 'funds_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `disbursement_id` SET TAGS ('title_business_glossary_term' = 'Disbursement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `escrow_ledger_id` SET TAGS ('title_business_glossary_term' = 'Escrow Ledger ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payee_party_id` SET TAGS ('title_business_glossary_term' = 'Payee Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payee_party_role_id` SET TAGS ('title_business_glossary_term' = 'Payee Party Role Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `settlement_statement_id` SET TAGS ('title_business_glossary_term' = 'Settlement Statement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `aba_routing_number` SET TAGS ('title_business_glossary_term' = 'ABA Routing Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `aba_routing_number` SET TAGS ('title_value_regex' = '^[0-9]{9}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `aba_routing_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `adjustment_amount` SET TAGS ('title_business_glossary_term' = 'Disbursement Adjustment Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `adjustment_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `adjustment_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `amount` SET TAGS ('title_business_glossary_term' = 'Disbursement Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `authorization_timestamp` SET TAGS ('title_business_glossary_term' = 'Authorization Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `authorized_by` SET TAGS ('title_business_glossary_term' = 'Authorized By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `bank_account_ref` SET TAGS ('title_business_glossary_term' = 'Bank Account Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `bank_account_ref` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `bank_account_ref` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `bank_name` SET TAGS ('title_business_glossary_term' = 'Payee Bank Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `cleared_date` SET TAGS ('title_business_glossary_term' = 'Disbursement Cleared Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `cost_center_code` SET TAGS ('title_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `disbursement_status` SET TAGS ('title_business_glossary_term' = 'Disbursement Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `disbursement_status` SET TAGS ('title_value_regex' = 'pending|issued|cleared|voided|returned|stopped');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `disbursement_type` SET TAGS ('title_business_glossary_term' = 'Disbursement Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `escrow_trust_account_number` SET TAGS ('title_business_glossary_term' = 'Escrow Trust Account Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `escrow_trust_account_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `gl_account_code` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `is_gap_period_disbursement` SET TAGS ('title_business_glossary_term' = 'Gap Period Disbursement Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `issued_date` SET TAGS ('title_business_glossary_term' = 'Disbursement Issued Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `loan_payoff_amount` SET TAGS ('title_business_glossary_term' = 'Loan Payoff Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `loan_payoff_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `loan_payoff_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `memo` SET TAGS ('title_business_glossary_term' = 'Disbursement Memo');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `net_disbursement_amount` SET TAGS ('title_business_glossary_term' = 'Net Disbursement Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `net_disbursement_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `net_disbursement_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `number` SET TAGS ('title_business_glossary_term' = 'Disbursement Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payee_name` SET TAGS ('title_business_glossary_term' = 'Payee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payee_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payee_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payee_tax_id_ref` SET TAGS ('title_business_glossary_term' = 'Payee Tax Identification Number (TIN) Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payee_tax_id_ref` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payee_tax_id_ref` SET TAGS ('title_pii_identifier' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payee_type` SET TAGS ('title_business_glossary_term' = 'Payee Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payment_method` SET TAGS ('title_business_glossary_term' = 'Payment Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payment_method` SET TAGS ('title_value_regex' = 'check|wire|ach|internal_transfer|cashiers_check');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `payoff_good_through_date` SET TAGS ('title_business_glossary_term' = 'Payoff Good-Through Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `positive_pay_exception` SET TAGS ('title_business_glossary_term' = 'Positive Pay Exception Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `positive_pay_submitted` SET TAGS ('title_business_glossary_term' = 'Positive Pay Submitted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `recording_fee_jurisdiction` SET TAGS ('title_business_glossary_term' = 'Recording Fee Jurisdiction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `remittance_type` SET TAGS ('title_business_glossary_term' = 'Remittance Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `remittance_type` SET TAGS ('title_value_regex' = 'title_premium|agent_split|underwriter_split|cpl_fee|endorsement_fee|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `return_date` SET TAGS ('title_business_glossary_term' = 'Disbursement Return Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `return_reason_code` SET TAGS ('title_business_glossary_term' = 'Return Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `scheduled_disbursement_date` SET TAGS ('title_business_glossary_term' = 'Scheduled Disbursement Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `settlement_statement_line_ref` SET TAGS ('title_business_glossary_term' = 'Settlement Statement Line Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Identifier');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `source_system_name` SET TAGS ('title_business_glossary_term' = 'Source System Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `source_system_name` SET TAGS ('title_value_regex' = 'softpro|ramquest|qualia|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `void_date` SET TAGS ('title_business_glossary_term' = 'Disbursement Void Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `void_reason` SET TAGS ('title_business_glossary_term' = 'Void Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `wire_confirmation_number` SET TAGS ('title_business_glossary_term' = 'Wire Confirmation Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `wire_instruction_ref` SET TAGS ('title_business_glossary_term' = 'Wire Instruction Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `wire_instruction_ref` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `wire_instruction_ref` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` SET TAGS ('title_subdomain' = 'funds_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `wire_instruction_id` SET TAGS ('title_business_glossary_term' = 'Wire Instruction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `closing_order_id` SET TAGS ('title_business_glossary_term' = 'Closing Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `disbursement_id` SET TAGS ('title_business_glossary_term' = 'Escrow Disbursement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `prior_instruction_wire_instruction_id` SET TAGS ('title_business_glossary_term' = 'Prior Wire Instruction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `aba_routing_number_token` SET TAGS ('title_business_glossary_term' = 'ABA Routing Number Token');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `aba_routing_number_token` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `aba_routing_number_token` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `account_number_token` SET TAGS ('title_business_glossary_term' = 'Account Number Token');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `account_number_token` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `account_number_token` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `account_type` SET TAGS ('title_business_glossary_term' = 'Bank Account Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `account_type` SET TAGS ('title_value_regex' = 'checking|savings|money_market|loan');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `approved_by` SET TAGS ('title_business_glossary_term' = 'Approved By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `approved_timestamp` SET TAGS ('title_business_glossary_term' = 'Wire Instruction Approved Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_address_line1` SET TAGS ('title_business_glossary_term' = 'Bank Address Line 1');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_address_line1` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_address_line1` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_city` SET TAGS ('title_business_glossary_term' = 'Bank City');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_city` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_city` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_country_code` SET TAGS ('title_business_glossary_term' = 'Bank Country Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_country_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_name` SET TAGS ('title_business_glossary_term' = 'Beneficiary Bank Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_name` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_state` SET TAGS ('title_business_glossary_term' = 'Bank State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `bank_state` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `beneficiary_name` SET TAGS ('title_business_glossary_term' = 'Beneficiary Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `beneficiary_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `beneficiary_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `change_reason` SET TAGS ('title_business_glossary_term' = 'Wire Change Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `delivery_channel` SET TAGS ('title_business_glossary_term' = 'Wire Instruction Delivery Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `delivery_channel` SET TAGS ('title_value_regex' = 'secure_portal|encrypted_email|fax|in_person|mail');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `expected_wire_amount` SET TAGS ('title_business_glossary_term' = 'Expected Wire Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `expected_wire_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `expected_wire_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Wire Instruction Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `fraud_alert_flag` SET TAGS ('title_business_glossary_term' = 'Wire Fraud Alert Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `fraud_alert_notes` SET TAGS ('title_business_glossary_term' = 'Wire Fraud Alert Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `further_credit_account_token` SET TAGS ('title_business_glossary_term' = 'Further Credit Account Number Token');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `further_credit_account_token` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `further_credit_account_token` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `further_credit_name` SET TAGS ('title_business_glossary_term' = 'Further Credit Account Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `further_credit_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `further_credit_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `instruction_number` SET TAGS ('title_business_glossary_term' = 'Wire Instruction Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `instruction_status` SET TAGS ('title_business_glossary_term' = 'Wire Instruction Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `intermediary_aba_token` SET TAGS ('title_business_glossary_term' = 'Intermediary ABA Routing Token');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `intermediary_aba_token` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `intermediary_aba_token` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `intermediary_bank_name` SET TAGS ('title_business_glossary_term' = 'Intermediary Bank Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `intermediary_bank_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `intermediary_bank_name` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `is_change_request` SET TAGS ('title_business_glossary_term' = 'Wire Change Request Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `nppi_vault_ref` SET TAGS ('title_business_glossary_term' = 'Non-Public Personal Information (NPPI) Vault Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `nppi_vault_ref` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `nppi_vault_ref` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `party_role` SET TAGS ('title_business_glossary_term' = 'Wire Party Role');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `positive_pay_submitted` SET TAGS ('title_business_glossary_term' = 'Positive Pay Submitted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `received_timestamp` SET TAGS ('title_business_glossary_term' = 'Wire Instruction Received Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `source_document_ref` SET TAGS ('title_business_glossary_term' = 'Source Document Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `swift_bic_code` SET TAGS ('title_business_glossary_term' = 'SWIFT/BIC Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `swift_bic_code` SET TAGS ('title_value_regex' = '^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `swift_bic_code` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `swift_bic_code` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `verification_method` SET TAGS ('title_business_glossary_term' = 'Wire Verification Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `verification_method` SET TAGS ('title_value_regex' = 'callback|secure_email|in_person|portal|not_verified');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `verification_timestamp` SET TAGS ('title_business_glossary_term' = 'Wire Verification Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `verified_by` SET TAGS ('title_business_glossary_term' = 'Verified By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `wire_purpose` SET TAGS ('title_business_glossary_term' = 'Wire Purpose');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `wire_reference_memo` SET TAGS ('title_business_glossary_term' = 'Wire Reference Memo');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` SET TAGS ('title_subdomain' = 'closing_coordination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `premium_charge_id` SET TAGS ('title_business_glossary_term' = 'Premium Charge ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `endorsement_id` SET TAGS ('title_business_glossary_term' = 'Endorsement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `premium_split_schedule_id` SET TAGS ('title_business_glossary_term' = 'Premium Split Schedule Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `prior_version_charge_premium_charge_id` SET TAGS ('title_business_glossary_term' = 'Prior Version Charge ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `settlement_statement_id` SET TAGS ('title_business_glossary_term' = 'Settlement Statement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `adjustment_amount` SET TAGS ('title_business_glossary_term' = 'Adjustment Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `agent_premium_split_amount` SET TAGS ('title_business_glossary_term' = 'Agent Premium Split Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `authorized_by` SET TAGS ('title_business_glossary_term' = 'Authorized By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `base_premium_amount` SET TAGS ('title_business_glossary_term' = 'Base Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `cd_line_item_code` SET TAGS ('title_business_glossary_term' = 'Closing Disclosure (CD) Line Item Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `charge_date` SET TAGS ('title_business_glossary_term' = 'Charge Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `charge_number` SET TAGS ('title_business_glossary_term' = 'Charge Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `charge_status` SET TAGS ('title_business_glossary_term' = 'Charge Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `charge_type` SET TAGS ('title_business_glossary_term' = 'Charge Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `charge_type` SET TAGS ('title_value_regex' = 'otp_premium|ltp_premium|endorsement_fee|search_fee|exam_fee|settlement_fee');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `collected_date` SET TAGS ('title_business_glossary_term' = 'Collected Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County FIPS Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `endorsement_type_code` SET TAGS ('title_business_glossary_term' = 'ALTA Endorsement Type Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `gl_account_code` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `hud1_line_number` SET TAGS ('title_business_glossary_term' = 'HUD-1 Line Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `liability_amount` SET TAGS ('title_business_glossary_term' = 'Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `net_charge_amount` SET TAGS ('title_business_glossary_term' = 'Net Charge Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Charge Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `paid_by_party` SET TAGS ('title_business_glossary_term' = 'Paid By Party');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `paid_by_party` SET TAGS ('title_value_regex' = 'buyer|seller|lender|split');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'owner|lender|both|na');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `prior_policy_amount` SET TAGS ('title_business_glossary_term' = 'Prior Policy Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `prior_policy_date` SET TAGS ('title_business_glossary_term' = 'Prior Policy Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `production_channel` SET TAGS ('title_business_glossary_term' = 'Production Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `production_channel` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `rate_per_thousand` SET TAGS ('title_business_glossary_term' = 'Rate Per Thousand');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `rate_schedule_code` SET TAGS ('title_business_glossary_term' = 'Rate Schedule Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `reissue_credit_flag` SET TAGS ('title_business_glossary_term' = 'Reissue Credit Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `remittance_due_date` SET TAGS ('title_business_glossary_term' = 'Remittance Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `remittance_status` SET TAGS ('title_business_glossary_term' = 'Remittance Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `remittance_status` SET TAGS ('title_value_regex' = 'pending|remitted|overdue|waived');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `revenue_recognition_date` SET TAGS ('title_business_glossary_term' = 'Revenue Recognition Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `simultaneous_issue_flag` SET TAGS ('title_business_glossary_term' = 'Simultaneous Issue Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `source_system_charge_ref` SET TAGS ('title_business_glossary_term' = 'Source System Charge Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `split_percentage` SET TAGS ('title_business_glossary_term' = 'Agent Split Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `underwriter_premium_split_amount` SET TAGS ('title_business_glossary_term' = 'Underwriter Premium Split Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `version_number` SET TAGS ('title_business_glossary_term' = 'Version Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `waiver_reason` SET TAGS ('title_business_glossary_term' = 'Waiver Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` SET TAGS ('title_subdomain' = 'closing_coordination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `closing_document_id` SET TAGS ('title_business_glossary_term' = 'Closing Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `closing_order_id` SET TAGS ('title_business_glossary_term' = 'Closing Event ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `settlement_statement_id` SET TAGS ('title_business_glossary_term' = 'Settlement Statement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `superseded_by_closing_document_id` SET TAGS ('title_business_glossary_term' = 'Superseded By Closing Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Document Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `consideration_amount` SET TAGS ('title_business_glossary_term' = 'Consideration Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `consideration_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `consideration_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_number` SET TAGS ('title_business_glossary_term' = 'Closing Document Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_page_count` SET TAGS ('title_business_glossary_term' = 'Document Page Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_source` SET TAGS ('title_business_glossary_term' = 'Closing Document Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_source` SET TAGS ('title_value_regex' = 'lender|title_company|attorney|borrower|seller|third_party');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_status` SET TAGS ('title_business_glossary_term' = 'Closing Document Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_status` SET TAGS ('title_value_regex' = 'pending|collected|executed|rejected|voided|superseded');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_subtype` SET TAGS ('title_business_glossary_term' = 'Closing Document Subtype');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_title` SET TAGS ('title_business_glossary_term' = 'Closing Document Title');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_type` SET TAGS ('title_business_glossary_term' = 'Closing Document Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `document_version` SET TAGS ('title_business_glossary_term' = 'Closing Document Version');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Document Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `erecording_status` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `erecording_status` SET TAGS ('title_value_regex' = 'not_submitted|submitted|accepted|rejected|recorded|resubmitted');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Document Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `execution_method` SET TAGS ('title_business_glossary_term' = 'Document Execution Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `execution_method` SET TAGS ('title_value_regex' = 'wet_sign|ron|ipen|eclose');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `grantee_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `grantor_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `imaging_document_ref` SET TAGS ('title_business_glossary_term' = 'Imaging Document Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `irs_1099s_filed` SET TAGS ('title_business_glossary_term' = 'IRS 1099-S Filed Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `loan_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `loan_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `notarization_date` SET TAGS ('title_business_glossary_term' = 'Notarization Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `notarization_required` SET TAGS ('title_business_glossary_term' = 'Notarization Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `notary_commission_expiry_date` SET TAGS ('title_business_glossary_term' = 'Notary Commission Expiry Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `notary_commission_number` SET TAGS ('title_business_glossary_term' = 'Notary Commission Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `notary_name` SET TAGS ('title_business_glossary_term' = 'Notary Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `poa_document_ref` SET TAGS ('title_business_glossary_term' = 'Power of Attorney (POA) Document Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `power_of_attorney_used` SET TAGS ('title_business_glossary_term' = 'Power of Attorney (POA) Used Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Document Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `recording_fee_amount` SET TAGS ('title_business_glossary_term' = 'Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `recording_jurisdiction` SET TAGS ('title_business_glossary_term' = 'Recording Jurisdiction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `recording_rejection_reason` SET TAGS ('title_business_glossary_term' = 'Recording Rejection Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `requires_1099s` SET TAGS ('title_business_glossary_term' = 'Requires 1099-S Reporting Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `requires_recording` SET TAGS ('title_business_glossary_term' = 'Requires Recording Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `resubmission_count` SET TAGS ('title_business_glossary_term' = 'Recording Resubmission Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Document Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `vesting_type` SET TAGS ('title_business_glossary_term' = 'Vesting Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `vesting_type` SET TAGS ('title_value_regex' = 'sole_ownership|joint_tenancy|tenancy_in_common|community_property|trust|entity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` SET TAGS ('title_subdomain' = 'funds_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `escrow_reconciliation_id` SET TAGS ('title_business_glossary_term' = 'Escrow Reconciliation ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `approved_by_supervisor_party_id` SET TAGS ('title_business_glossary_term' = 'Approved By Supervisor ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `escrow_ledger_id` SET TAGS ('title_business_glossary_term' = 'Escrow Trust Account ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Reviewed By Officer ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `account_type` SET TAGS ('title_business_glossary_term' = 'Escrow Account Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `account_type` SET TAGS ('title_value_regex' = 'iolta|dedicated_trust|operating|pooled_trust');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `adjusted_bank_balance` SET TAGS ('title_business_glossary_term' = 'Adjusted Bank Balance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `adjusted_bank_balance` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `adjusted_bank_balance` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `approval_date` SET TAGS ('title_business_glossary_term' = 'Approval Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `approval_notes` SET TAGS ('title_business_glossary_term' = 'Approval Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_account_number_masked` SET TAGS ('title_business_glossary_term' = 'Bank Account Number (Masked)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_account_number_masked` SET TAGS ('title_value_regex' = '^[X*]{4,12}[0-9]{4}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_account_number_masked` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_account_number_masked` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_name` SET TAGS ('title_business_glossary_term' = 'Bank Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_routing_number` SET TAGS ('title_business_glossary_term' = 'Bank Routing Number (ABA)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_routing_number` SET TAGS ('title_value_regex' = '^[0-9]{9}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_routing_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_statement_balance` SET TAGS ('title_business_glossary_term' = 'Bank Statement Balance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_statement_balance` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_statement_balance` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_statement_date` SET TAGS ('title_business_glossary_term' = 'Bank Statement Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_to_ledger_variance` SET TAGS ('title_business_glossary_term' = 'Bank-to-Ledger Variance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_to_ledger_variance` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `bank_to_ledger_variance` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `branch_code` SET TAGS ('title_business_glossary_term' = 'Branch ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `days_to_reconcile` SET TAGS ('title_business_glossary_term' = 'Days to Reconcile');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `escrow_ledger_balance` SET TAGS ('title_business_glossary_term' = 'Escrow Ledger Balance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `escrow_ledger_balance` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `escrow_ledger_balance` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `is_balanced` SET TAGS ('title_business_glossary_term' = 'Is Balanced Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `is_regulatory_reportable` SET TAGS ('title_business_glossary_term' = 'Is Regulatory Reportable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `ledger_to_file_variance` SET TAGS ('title_business_glossary_term' = 'Ledger-to-File Variance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `ledger_to_file_variance` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `ledger_to_file_variance` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `open_file_balance_aggregate` SET TAGS ('title_business_glossary_term' = 'Open File Balance Aggregate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `open_file_balance_aggregate` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `open_file_balance_aggregate` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `open_file_count` SET TAGS ('title_business_glossary_term' = 'Open File Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `outstanding_check_count` SET TAGS ('title_business_glossary_term' = 'Outstanding Check Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `outstanding_checks_amount` SET TAGS ('title_business_glossary_term' = 'Outstanding Checks Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `outstanding_checks_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `outstanding_checks_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `outstanding_deposits_amount` SET TAGS ('title_business_glossary_term' = 'Outstanding Deposits Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `outstanding_deposits_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `outstanding_deposits_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `positive_pay_submission_date` SET TAGS ('title_business_glossary_term' = 'Positive Pay Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `positive_pay_submitted` SET TAGS ('title_business_glossary_term' = 'Positive Pay Submitted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `prior_period_variance_amount` SET TAGS ('title_business_glossary_term' = 'Prior Period Variance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `prior_period_variance_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `prior_period_variance_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `reconciliation_date` SET TAGS ('title_business_glossary_term' = 'Reconciliation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `reconciliation_number` SET TAGS ('title_business_glossary_term' = 'Reconciliation Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `reconciliation_number` SET TAGS ('title_value_regex' = '^RECON-[0-9]{4}-[0-9]{2}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `reconciliation_period_end_date` SET TAGS ('title_business_glossary_term' = 'Reconciliation Period End Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `reconciliation_period_start_date` SET TAGS ('title_business_glossary_term' = 'Reconciliation Period Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `reconciliation_status` SET TAGS ('title_business_glossary_term' = 'Reconciliation Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `reconciliation_status` SET TAGS ('title_value_regex' = 'in_progress|balanced|out_of_balance|under_review|approved|voided');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `reconciliation_type` SET TAGS ('title_business_glossary_term' = 'Reconciliation Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `reconciliation_type` SET TAGS ('title_value_regex' = 'three_way|bank_to_ledger|ledger_to_file|positive_pay');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `regulatory_report_date` SET TAGS ('title_business_glossary_term' = 'Regulatory Report Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `source_system_code` SET TAGS ('title_value_regex' = 'softpro|ramquest|qualia|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `source_system_recon_ref` SET TAGS ('title_business_glossary_term' = 'Source System Reconciliation Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `stale_check_amount` SET TAGS ('title_business_glossary_term' = 'Stale Check Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `stale_check_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `stale_check_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `stale_check_count` SET TAGS ('title_business_glossary_term' = 'Stale Check Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `tolerance_amount` SET TAGS ('title_business_glossary_term' = 'Reconciliation Tolerance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `variance_explanation` SET TAGS ('title_business_glossary_term' = 'Variance Explanation');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `variance_resolution_status` SET TAGS ('title_business_glossary_term' = 'Variance Resolution Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `variance_resolution_status` SET TAGS ('title_value_regex' = 'not_applicable|open|in_investigation|resolved|escalated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `variance_resolved_date` SET TAGS ('title_business_glossary_term' = 'Variance Resolved Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` SET TAGS ('title_domain' = 'settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` SET TAGS ('title_subdomain' = 'funds_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `escrow_receipt_id` SET TAGS ('title_business_glossary_term' = 'Escrow Receipt ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `escrow_ledger_id` SET TAGS ('title_business_glossary_term' = 'Escrow Ledger ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `escrow_officer_party_id` SET TAGS ('title_business_glossary_term' = 'Escrow Officer ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `prior_receipt_escrow_receipt_id` SET TAGS ('title_business_glossary_term' = 'Prior Receipt ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `remitter_party_role_id` SET TAGS ('title_business_glossary_term' = 'Remitter Party Role Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `settlement_statement_id` SET TAGS ('title_business_glossary_term' = 'Settlement Statement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `wire_instruction_id` SET TAGS ('title_business_glossary_term' = 'Wire Instruction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `ach_trace_number` SET TAGS ('title_business_glossary_term' = 'ACH Trace Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `adjustment_amount` SET TAGS ('title_business_glossary_term' = 'Receipt Adjustment Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `adjustment_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `adjustment_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `branch_code` SET TAGS ('title_business_glossary_term' = 'Branch ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `check_number` SET TAGS ('title_business_glossary_term' = 'Check Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `emd_contract_date` SET TAGS ('title_business_glossary_term' = 'Earnest Money Deposit (EMD) Contract Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `emd_flag` SET TAGS ('title_business_glossary_term' = 'Earnest Money Deposit (EMD) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `expected_receipt_amount` SET TAGS ('title_business_glossary_term' = 'Expected Receipt Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `expected_receipt_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `expected_receipt_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `fraud_alert_flag` SET TAGS ('title_business_glossary_term' = 'Fraud Alert Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `fraud_alert_notes` SET TAGS ('title_business_glossary_term' = 'Fraud Alert Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `funds_type` SET TAGS ('title_business_glossary_term' = 'Funds Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `gl_account_code` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `iolta_account_flag` SET TAGS ('title_business_glossary_term' = 'IOLTA Account Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `memo` SET TAGS ('title_business_glossary_term' = 'Receipt Memo');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `net_receipt_amount` SET TAGS ('title_business_glossary_term' = 'Net Escrow Receipt Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `net_receipt_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `net_receipt_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `positive_pay_submitted_flag` SET TAGS ('title_business_glossary_term' = 'Positive Pay Submitted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `posted_timestamp` SET TAGS ('title_business_glossary_term' = 'Posted Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `receipt_amount` SET TAGS ('title_business_glossary_term' = 'Escrow Receipt Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `receipt_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `receipt_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `receipt_date` SET TAGS ('title_business_glossary_term' = 'Receipt Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `receipt_number` SET TAGS ('title_business_glossary_term' = 'Escrow Receipt Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `receipt_status` SET TAGS ('title_business_glossary_term' = 'Escrow Receipt Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `receipt_status` SET TAGS ('title_value_regex' = 'pending|posted|reversed|returned|void');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `receipt_type` SET TAGS ('title_business_glossary_term' = 'Escrow Receipt Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `receipt_type` SET TAGS ('title_value_regex' = 'emd|loan_proceeds|buyer_cash_to_close|seller_contribution|payoff_overfund_return|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `received_timestamp` SET TAGS ('title_business_glossary_term' = 'Received Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `remitter_account_token` SET TAGS ('title_business_glossary_term' = 'Remitter Account Token');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `remitter_account_token` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `remitter_account_token` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `remitter_bank_name` SET TAGS ('title_business_glossary_term' = 'Remitter Bank Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `remitter_name` SET TAGS ('title_business_glossary_term' = 'Remitter Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `remitter_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `remitter_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `remitter_party_role` SET TAGS ('title_business_glossary_term' = 'Remitter Party Role');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `reversal_date` SET TAGS ('title_business_glossary_term' = 'Receipt Reversal Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `reversal_flag` SET TAGS ('title_business_glossary_term' = 'Receipt Reversal Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `reversal_reason` SET TAGS ('title_business_glossary_term' = 'Receipt Reversal Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `source_system_receipt_ref` SET TAGS ('title_business_glossary_term' = 'Source System Receipt Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `trust_account_bank_name` SET TAGS ('title_business_glossary_term' = 'Trust Account Bank Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `trust_account_number` SET TAGS ('title_business_glossary_term' = 'Trust Account Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `trust_account_number` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `trust_account_number` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `variance_amount` SET TAGS ('title_business_glossary_term' = 'Receipt Variance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `variance_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `variance_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `wire_reference_number` SET TAGS ('title_business_glossary_term' = 'Wire Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `wire_verification_method` SET TAGS ('title_business_glossary_term' = 'Wire Verification Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `wire_verification_method` SET TAGS ('title_value_regex' = 'callback|secure_portal|verbal|written|not_applicable');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `wire_verified_flag` SET TAGS ('title_business_glossary_term' = 'Wire Verified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
