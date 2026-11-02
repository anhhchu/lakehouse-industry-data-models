-- Schema for Domain: claim | Business: Title_Insurance | Version: v1_mvm
-- Generated on: 2026-10-31 06:39:29

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `serverless_stable_dvmvgw_catalog`.`ti_claim` COMMENT 'Administers the full title-insurance claims lifecycle: FNOL intake, investigation, coverage analysis, reserving (case and IBNR), loss payment, recovery/subrogation, and claim closure.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` (
    `title_claim_id` BIGINT COMMENT 'Unique surrogate identifier for each title insurance claim record. Primary key for the title_claim entity in the Claims Administration System.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent entity if the underlying policy was issued through an independent agent channel. Null for direct-branch or lender-channel policies.',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: Claims often hinge on legal description gaps, metes-and-bounds errors, or Schedule A variances.',
    `property_id` BIGINT COMMENT 'Reference to the property entity representing the real property subject to the insured title. Links the claim to the property information domain for location and parcel context.',
    `title_assigned_counsel_party_id` BIGINT COMMENT 'Reference to the party record for outside or in-house legal counsel assigned to defend or prosecute matters related to this claim.',
    `title_claimant_party_id` BIGINT COMMENT 'Reference to the party entity representing the insured claimant (owner or lender) who filed the claim. Supports party-role contextual modeling.',
    `title_commitment_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_commitment. Business justification: Claims investigation and coverage analysis routinely retrieve the commitment to compare Schedule B exceptions, requirements, and insurable title determination against the',
    `title_order_id` BIGINT COMMENT 'Reference to the originating title order associated with the insured transaction. Enables traceability from claim back to the original title production workflow.',
    `title_party_id` BIGINT COMMENT 'Reference to the internal party or employee record for the claims examiner assigned to investigate and manage this claim through resolution.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued Owners Title Policy (OTP) or Lenders Title Policy (LTP) against which this claim is filed. Links claim to the insuring policy.',
    `underwriting_title_examination_id` BIGINT COMMENT 'Foreign key linking to underwriting.underwriting_title_examination. Business justification: Claims investigation reviews the original examination to determine if the defect was missed, improperly cleared, or outside the examination scope.',
    `case_reserve_amount` DECIMAL(18,2) COMMENT 'Current actuarially-set case reserve representing the estimated ultimate indemnity liability for this specific open claim. Updated as investigation progresses.',
    `chain_of_title_break_flag` BOOLEAN COMMENT 'Indicates whether the claim involves a break or gap in the chain of title (COT) as identified during examination or investigation. Key metric for title clearance quality analysis.',
    `claim_number` STRING COMMENT 'Externally-known alphanumeric identifier assigned to the claim at FNOL intake. Used in all correspondence, regulatory reporting, and system-of-record references.. Valid values are `^CLM-[0-9]{4}-[0-9]{6}$`',
    `claim_status` STRING COMMENT 'Current lifecycle state of the claim. Drives workflow routing, reserve management, and regulatory reporting. [ENUM-REF-CANDIDATE: open|under_investigation|reserved|settled|closed|denied|reopened — promote to reference product]',
    `claim_type` STRING COMMENT 'Classification of the title risk cause giving rise to the claim (e.g., title defect, lien, encumbrance, encroachment, forgery, fraud, survey, access, CC&R).',
    `claimed_loss_amount` DECIMAL(18,2) COMMENT 'Gross dollar amount of loss asserted by the claimant at FNOL intake. May differ from the ultimately reserved or paid amount after investigation.',
    `closure_date` DATE COMMENT 'Date the claim was formally closed in the Claims Administration System. Reserves are released upon closure. Used for claim lifecycle duration and aging analysis.',
    `closure_reason` STRING COMMENT 'Reason the claim was closed, distinguishing between indemnity payment, curative resolution, coverage denial, claimant withdrawal, or no-coverage determination.. Valid values are `paid|curative|denied|withdrawn|no_coverage`',
    `county_fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county where the insured property is located. Used for geographic loss analysis and county recorder jurisdiction identification.. Valid values are `^[0-9]{5}$`',
    `coverage_analysis_outcome` STRING COMMENT 'Result of the underwriters coverage analysis determining whether the claimed loss falls within the policys insuring provisions. Drives reserve setting and payment authorization.. Valid values are `covered|partially_covered|denied|pending`',
    `coverage_denial_reason` STRING COMMENT 'Explanation of why coverage was denied or limited, referencing the specific policy exclusion, Schedule B exception, or condition. Populated when coverage_analysis_outcome is denied or partially_covered.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the claim record was first created in the Claims Administration System. Audit field for record provenance and data lineage tracking.',
    `curative_action_description` STRING COMMENT 'Narrative describing the curative steps taken to resolve the title defect or adverse matter underlying the claim (e.g., lien release, quiet title action, corrective deed).',
    `curative_resolution_flag` BOOLEAN COMMENT 'Indicates whether the claim was resolved through curative action (e.g., obtaining a release, reconveyance, or corrective deed) rather than monetary indemnity payment.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this claim record. Defaults to USD for domestic US title insurance transactions.. Valid values are `^[A-Z]{3}$`',
    `expense_reserve_amount` DECIMAL(18,2) COMMENT 'Reserve set aside for allocated loss adjustment expenses (ALAE) including legal fees, curative costs, and investigation expenses associated with this claim.',
    `fnol_date` DATE COMMENT 'Date the insured first notified the company of the claim event. The principal business event date for claim intake; distinct from investigation and payment dates.',
    `fnol_received_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the FNOL was received and logged in the Claims Administration System. Used for SLA measurement and regulatory timeliness reporting.',
    `gap_coverage_flag` BOOLEAN COMMENT 'Indicates whether the claim involves a loss arising during the gap period between the effective date of the commitment and the recording of the insured instrument.',
    `insured_amount` DECIMAL(18,2) COMMENT 'The face amount of insurance coverage under the policy at the time of the claim, representing the maximum indemnity exposure. Sourced from the policys Schedule A.',
    `investigation_close_date` DATE COMMENT 'Date the claim investigation was formally concluded and findings documented. Marks transition to coverage determination and reserve finalization.',
    `investigation_start_date` DATE COMMENT 'Date the formal claim investigation was initiated by the assigned examiner. Used to measure investigation cycle time and regulatory timeliness compliance.',
    `investigation_status` STRING COMMENT 'Current state of the claim investigation workflow. Tracks whether the examiner has begun, completed, or paused the factual and legal review of the claimed loss.. Valid values are `not_started|in_progress|completed|on_hold`',
    `litigation_flag` BOOLEAN COMMENT 'Indicates whether the claim has resulted in or is subject to active litigation. Triggers legal hold requirements and escalated reserve review.',
    `loss_date` DATE COMMENT 'Date the insured title loss or adverse claim event actually occurred or was discovered. May differ from FNOL date; used for IBNR analysis and loss cause dating.',
    `loss_description` STRING COMMENT 'Narrative description of the title defect, lien, encumbrance, or other adverse matter giving rise to the claim. Captures the factual basis of the insureds loss.',
    `policy_type` STRING COMMENT 'Indicates whether the claim is filed against an Owners Title Policy (OTP) or a Lenders/Loan Title Policy (LTP). Required for owner-versus-lender coverage analysis per VREQ-010.. Valid values are `owner|lender`',
    `producing_channel` STRING COMMENT 'The business channel through which the underlying title order and policy were produced. Supports loss ratio and frequency analysis by channel (direct, lender, independent agent).. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `recovery_amount` DECIMAL(18,2) COMMENT 'Total amounts recovered through subrogation, salvage, or other recovery actions against responsible third parties. Reduces net loss for loss ratio calculation.',
    `regulatory_report_flag` BOOLEAN COMMENT 'Indicates whether this claim has been included in a regulatory loss report submitted to the NAIC or a state Department of Insurance. Supports compliance audit trail.',
    `reopen_count` BIGINT COMMENT 'Number of times this claim has been reopened after a prior closure. Supports lifecycle history preservation per VREQ-007 and identifies complex or recurring loss events.',
    `reserve_last_updated_date` DATE COMMENT 'Date the case reserve or expense reserve was most recently reviewed and updated by the examiner or actuary. Supports reserve aging and adequacy monitoring.',
    `settlement_date` DATE COMMENT 'Date on which the claim was formally settled and the settlement agreement executed between the insurer and the claimant. Distinct from payment disbursement date.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the jurisdiction where the insured property is located. Drives state-specific regulatory reporting to Departments of Insurance.. Valid values are `^[A-Z]{2}$`',
    `subrogation_flag` BOOLEAN COMMENT 'Indicates whether subrogation rights have been asserted against a responsible third party following indemnity payment. Triggers recovery tracking workflow.',
    `subrogation_status` STRING COMMENT 'Current state of subrogation or recovery action against a responsible third party. Supports recovery tracking and net loss reporting per NAIC requirements.. Valid values are `not_applicable|identified|in_pursuit|recovered|closed_no_recovery`',
    `title_risk_cause_code` STRING COMMENT 'Standardized code classifying the root cause of the title risk (e.g., forgery, undisclosed heir, survey error, lien not released). Used for NAIC loss cause reporting and frequency/severity by cause.',
    `total_paid_expense_amount` DECIMAL(18,2) COMMENT 'Cumulative allocated loss adjustment expense (ALAE) payments made to date for this claim, including legal, curative, and investigation costs.',
    `total_paid_indemnity_amount` DECIMAL(18,2) COMMENT 'Cumulative indemnity loss payments made to the claimant to date. Represents the sum of all indemnity disbursements; used for loss ratio and severity analysis.',
    `transaction_type` STRING COMMENT 'Type of real estate transaction underlying the insured policy (purchase, refinance, HELOC, construction, commercial). Supports frequency and severity segmentation by transaction type.. Valid values are `purchase|refinance|heloc|construction|commercial|home_equity`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the claim record was most recently modified in the Claims Administration System. Supports change detection, audit, and incremental data loading.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_title_claim PRIMARY KEY(`title_claim_id`)
) COMMENT 'Master record for every title-insurance claim filed against an issued OTP or LTP. Captures FNOL intake details, claim type (title defect, lien, encumbrance, encroachment, forgery, fraud, survey, access, etc.), coverage analysis outcome, policy linkage';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` (
    `event_id` BIGINT COMMENT 'Unique surrogate identifier for each immutable lifecycle event record in the claim event log. Primary key of the claim_event product.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent party record if the policy was issued through an independent agent channel. Null for direct-branch or centralized-lender production.',
    `event_claimant_party_id` BIGINT COMMENT 'Reference to the party record for the claimant (insured owner or lender) asserting the title insurance claim at this event. Supports contextual party role modeling per VREQ-006.',
    `event_party_id` BIGINT COMMENT 'Reference to the internal staff party record for the claims examiner or adjuster assigned to handle this claim at the time of the event. Tracks assignment changes.',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Claim events track title defects and reserve changes at parcel granularity for regulatory loss reporting by jurisdiction (county FIPS) and for reserve adequacy analysis by property',
    `title_claim_id` BIGINT COMMENT 'Foreign key reference to the parent title insurance claim record. Links every event to its governing claim in the Claims Administration System.',
    `title_order_id` BIGINT COMMENT 'Reference to the originating title order associated with the claim. Enables end-to-end traceability from order intake through claim resolution.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued Owners Title Policy (OTP) or Lenders Title Policy (LTP) under which the claim is made. Supports owner-versus-lender policy coverage analysis.',
    `claim_number` STRING COMMENT 'Externally visible, human-readable claim identifier assigned by the Claims Administration System at First Notice of Loss (FNOL). Used in all regulatory and correspondence references.. Valid values are `^CLM-[0-9]{4}-[0-9]{6}$`',
    `claimed_loss_amount` DECIMAL(18,2) COMMENT 'Amount of loss asserted by the claimant at the time of FNOL or as updated at this event. May differ from the ultimate reserve or paid loss amount.',
    `coverage_decision` STRING COMMENT 'Underwriting coverage determination recorded at this event: whether the claimed loss is covered, denied, partially covered, or pending analysis under the OTP or LTP.. Valid values are `covered|denied|partial|pending|reserved`',
    `coverage_denial_reason` STRING COMMENT 'Reason code or narrative explaining why coverage was denied or limited at this event. Required for regulatory reporting and claimant adverse-action notices.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this event record was first written to the Silver layer lakehouse. Distinct from event_timestamp (business event time). Supports audit and data lineage.',
    `curative_action_required` BOOLEAN COMMENT 'Indicates whether this claim event triggered a curative processing action (e.g., lien release, deed correction, quiet title) rather than a direct indemnity payment.',
    `curative_action_type` STRING COMMENT 'Type of curative action initiated at this event (e.g., lien_release, deed_correction, quiet_title, reconveyance, satisfaction). [ENUM-REF-CANDIDATE: lien_release|deed_correction|quiet_title|reconveyance|satisfaction|gap_cure|subordination — promote to',
    `curative_resolution_date` DATE COMMENT 'Date the curative action associated with this claim event was completed and the title defect resolved. Null if curative action is still open. Supports curative aging analysis.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this event record. Defaults to USD for domestic US title insurance transactions.. Valid values are `^[A-Z]{3}$`',
    `event_description` STRING COMMENT 'Free-text narrative describing the specific action, decision, or observation recorded in this event. Supports investigator notes, coverage rationale, and curative resolution details.',
    `event_timestamp` TIMESTAMP COMMENT 'Precise date and time (ISO 8601 with timezone offset) at which the claim lifecycle event occurred in the Claims Administration System. Immutable once written.',
    `event_type` STRING COMMENT 'Discriminator classifying the kind of lifecycle event recorded. [ENUM-REF-CANDIDATE: fnol_intake|status_change|coverage_decision|reserve_movement|loss_payment|recovery_receipt|assignment_change|investigation_update|curative_action|closure — promote to',
    `expense_amount` DECIMAL(18,2) COMMENT 'Defense, investigation, or allocated loss adjustment expense (ALAE) amount in USD incurred at this event. Tracked separately from indemnity for loss ratio analysis.',
    `fnol_date` DATE COMMENT 'Date the claimant first reported the title loss or defect to the insurer. Anchors claim frequency and aging calculations. Distinct from event_timestamp.',
    `ibnr_flag` BOOLEAN COMMENT 'Indicates whether this event is associated with an IBNR reserve estimate rather than a reported claim. Supports actuarial IBNR development and NAIC Schedule P reporting.',
    `insured_amount` DECIMAL(18,2) COMMENT 'Face amount of the title insurance policy (purchase price for OTP or loan amount for LTP) at the time of policy issuance. Provides exposure context for severity analysis.',
    `investigation_start_date` DATE COMMENT 'Date the formal claim investigation was initiated. Used to measure investigation cycle time and compliance with state prompt-payment statutes.',
    `loss_date` DATE COMMENT 'Date the underlying title defect, encumbrance, or adverse claim event occurred or was discovered. Used for policy-year loss development and IBNR estimation.',
    `loss_payment_amount` DECIMAL(18,2) COMMENT 'Indemnity payment amount in USD disbursed to the claimant at this event. Zero for non-payment events. Feeds claim severity and loss ratio calculations.',
    `new_claim_status` STRING COMMENT 'Claim lifecycle status resulting from this event. Together with prior_claim_status, captures every material status transition for regulatory and operational reporting.',
    `policy_effective_date` DATE COMMENT 'Effective date of the title insurance policy under which the claim is made. Denormalized here to support policy-year loss ratio analysis without joining to title_policy.',
    `policy_type` STRING COMMENT 'Indicates whether the claim is against an Owners Title Policy (OTP) or a Lenders Title Policy (LTP). Supports owner-versus-lender policy coverage analysis per VREQ-010.. Valid values are `owner|lender`',
    `prior_claim_status` STRING COMMENT 'Claim lifecycle status immediately before this event was applied. Preserved for lifecycle history and transition auditing per VREQ-007. [ENUM-REF-CANDIDATE: open|under_investigation|reserved|pending_payment|subrogation|closed|reopened — 7 candidates',
    `prior_reserve_amount` DECIMAL(18,2) COMMENT 'Case reserve amount in USD immediately before this reserve movement event. Enables calculation of reserve development and supports IBNR analysis.',
    `production_channel` STRING COMMENT 'Channel through which the original title order and policy were produced (direct branch, centralized lender, or independent agent). Enables loss ratio analysis by distribution channel.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `recovery_amount` DECIMAL(18,2) COMMENT 'Amount in USD recovered through subrogation, salvage, or other recovery actions recorded at this event. Reduces net loss and feeds recovery ratio reporting.',
    `regulatory_report_period` STRING COMMENT 'Reporting period (e.g., 2024-Q3, 2024-FY) to which this claim event is attributed for NAIC Annual Statement and state Department of Insurance loss reporting.. Valid values are `^[0-9]{4}-(Q[1-4]|H[12]|FY)$`',
    `reserve_amount` DECIMAL(18,2) COMMENT 'Case reserve amount in USD established or adjusted at this event. Represents the estimated ultimate loss for the claim at this point in time. Supports reserve movement tracking.',
    `reserve_change_amount` DECIMAL(18,2) COMMENT 'Net change in case reserve at this event (new minus prior). Positive indicates reserve strengthening; negative indicates reserve reduction. Used in loss development reporting.',
    `sequence` BIGINT COMMENT 'Monotonically increasing integer ordering events within a single claim. Enables reconstruction of the full claim lifecycle in chronological order.',
    `source_reference_code` STRING COMMENT 'Native identifier of this event in the originating source system (e.g., Claims Administration System transaction ID). Enables reconciliation and lineage tracing back to the SoR.',
    `subrogation_initiated` BOOLEAN COMMENT 'Indicates whether a subrogation or recovery action was initiated at or before this event. Supports recovery tracking and net loss reporting.',
    `subrogation_status` STRING COMMENT 'Current status of the subrogation or recovery action as of this event. Tracks progression from initiation through recovery or closure without recovery.. Valid values are `not_applicable|initiated|in_progress|recovered|closed_no_recovery`',
    `title_risk_cause_code` STRING COMMENT 'Standardized code identifying the root cause of the title defect or loss (e.g., forged deed, undisclosed lien, chain-of-title break, encroachment). Drives loss ratio by title-risk cause analytics.',
    `title_risk_cause_description` STRING COMMENT 'Human-readable description of the title risk cause associated with this claim event. Complements the structured cause code with examiner narrative.',
    `transaction_type` STRING COMMENT 'Type of real estate transaction underlying the insured policy (e.g., purchase, refinance, HELOC, construction). Supports loss frequency and severity segmentation by transaction type.. Valid values are `purchase|refinance|heloc|construction|commercial|home_equity`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'Identity of the user, service account, or automated process that wrote this event record to the lakehouse. Supports SOC 2 audit trail and data governance requirements.',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_event PRIMARY KEY(`event_id`)
) COMMENT 'Immutable lifecycle-event log for a title claim, preserving every material status transition, coverage decision, assignment change, and reserve movement as a timestamped event record.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` (
    `reserve_id` BIGINT COMMENT 'Unique surrogate identifier for this effective-dated claim reserve record within the Claims Administration System.',
    `approved_by_user_party_id` BIGINT COMMENT 'Internal user identifier of the supervisor or underwriting authority who approved this reserve, required when reserve exceeds authority threshold.',
    `party_id` BIGINT COMMENT 'Internal user identifier of the claims examiner, underwriter, or actuary who established or last revised this reserve record.',
    `prior_reserve_id` BIGINT COMMENT 'Reference to the immediately preceding reserve record that this record revises or supersedes, enabling a full audit chain of reserve movements.',
    `title_claim_id` BIGINT COMMENT 'Reference to the parent title-insurance claim to which this reserve record belongs. Links reserve to FNOL and claim lifecycle.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued title-insurance policy (OTP or LTP) under which this claim and reserve are established.',
    `accident_year` BIGINT COMMENT 'Year in which the title defect or loss event is deemed to have occurred for actuarial loss development triangle and IBNR estimation purposes.',
    `actuarial_method_code` STRING COMMENT 'Actuarial development method used to estimate IBNR or bulk reserve amounts: chain ladder, Bornhuetter-Ferguson, expected loss, frequency-severity, or judgment.. Valid values are `chain_ladder|bornhuetter_ferguson|expected_loss|frequency_severity|judgment`',
    `adequacy_review_date` DATE COMMENT 'Date of the most recent periodic reserve adequacy review performed by the actuary or claims supervisor for this claim reserve record.',
    `alae_reserve_amount` DECIMAL(18,2) COMMENT 'Reserve for allocated loss adjustment expenses directly attributable to this claim, such as attorney fees, curative costs, and investigation expenses.',
    `approval_date` DATE COMMENT 'Date on which the required supervisory or underwriting approval for this reserve was granted. Null if approval was not required or is pending.',
    `approval_required` BOOLEAN COMMENT 'Indicates whether this reserve amount exceeded the claims examiner authority threshold and required supervisory or underwriting approval before activation.',
    `basis` STRING COMMENT 'Indicates whether this reserve record represents the initial establishment, a subsequent revision, or the final reserve set at claim closure.. Valid values are `initial|revised|final`',
    `case_reserve_amount` DECIMAL(18,2) COMMENT 'Estimated total indemnity and expense amount reserved for this specific claim based on current investigation findings. Denominated in currency_code.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this reserve record was first created in the Claims Administration System. Immutable audit field.',
    `curative_action_pending` BOOLEAN COMMENT 'Indicates whether an active curative action (e.g., quiet title, lien release, deed correction) is in progress that may reduce or eliminate the reserve.',
    `curative_resolution_date` DATE COMMENT 'Date on which the curative action was completed and the title defect resolved, triggering a reserve reduction or closure review.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary reserve amounts on this record (e.g., USD). Title operations are predominantly USD.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date on which this reserve record becomes operative for financial reporting and loss triangle purposes. Supports effective-dated reserve history.',
    `expiration_date` DATE COMMENT 'Date on which this reserve record is superseded by a revision or closed. Null if this is the current active reserve. Enables bi-temporal reserve history.',
    `ibnr_reserve_amount` DECIMAL(18,2) COMMENT 'Actuarially estimated reserve for losses incurred but not yet reported or fully developed on this claim or cohort. Zero for case reserves.',
    `large_loss_flag` BOOLEAN COMMENT 'Indicates whether this reserve meets or exceeds the underwriter-defined large-loss threshold, triggering enhanced oversight and executive reporting.',
    `large_loss_threshold_amount` DECIMAL(18,2) COMMENT 'Dollar threshold in effect at the time this reserve was set that determines large-loss classification. Preserved for audit and threshold-change analysis.',
    `litigation_flag` BOOLEAN COMMENT 'Indicates whether this claim has entered active litigation (e.g., quiet title action, foreclosure defense), which typically elevates ALAE reserve requirements.',
    `loss_reserve_amount` DECIMAL(18,2) COMMENT 'Indemnity-only component of the case reserve, representing estimated title-loss payment to the insured, excluding allocated loss adjustment expenses.',
    `net_reserve_amount` DECIMAL(18,2) COMMENT 'Gross case reserve less reinsurance recoverable and subrogation reserve, representing the net retained reserve exposure for statutory reporting.',
    `policy_liability_amount` DECIMAL(18,2) COMMENT 'Face amount of the title-insurance policy (Schedule A liability) against which this claim is made. Used to compute reserve-to-liability ratio.',
    `policy_type` STRING COMMENT 'Indicates whether the underlying policy is an Owners Title Policy (OTP) or a Lenders/Loan Title Policy (LTP), driving coverage analysis and loss reporting.. Valid values are `owner|lender`',
    `policy_year` BIGINT COMMENT 'Year in which the underlying title-insurance policy was issued. Used for cohort-based loss ratio and frequency/severity analysis by policy vintage.',
    `reinsurance_recoverable_amount` DECIMAL(18,2) COMMENT 'Estimated amount recoverable from reinsurance treaties or facultative placements applicable to this claim, reducing net reserve exposure.',
    `reporting_period_quarter` BIGINT COMMENT 'Fiscal quarter (1–4) within the reporting year to which this reserve record is assigned for quarterly statutory and management reporting.',
    `reporting_period_year` BIGINT COMMENT 'Calendar or accident year to which this reserve is assigned for NAIC statutory loss triangle and state Department of Insurance reporting purposes.',
    `reserve_number` STRING COMMENT 'Externally visible, human-readable identifier for this reserve record as assigned by the Claims Administration System (e.g., RES-2024-000123).. Valid values are `^RES-[0-9]{4}-[0-9]{6}$`',
    `reserve_status` STRING COMMENT 'Current lifecycle state of this reserve record: open (active), revised (superseded by a newer record), closed, reinstated, or voided.. Valid values are `open|revised|closed|reinstated|voided`',
    `reserve_type` STRING COMMENT 'Classification of the reserve: case (specific claim), IBNR (Incurred But Not Reported), bulk, salvage, subrogation recovery, or unallocated loss reserve.. Valid values are `case|ibnr|bulk|salvage|subrogation|unallocated`',
    `revision_notes` STRING COMMENT 'Free-text examiner notes documenting the rationale for establishing or revising this reserve, including key facts from investigation or curative status.',
    `revision_reason_code` STRING COMMENT 'Coded reason for this reserve revision: new information, settlement update, curative resolution, court order, actuarial review, periodic review, or closure.',
    `revision_sequence` BIGINT COMMENT 'Monotonically increasing integer indicating the revision number of this reserve for the parent claim (1 = initial, 2 = first revision, etc.).',
    `set_by_role` STRING COMMENT 'Role of the individual who established or last revised this reserve: claims examiner, underwriter, actuary, supervisor, or automated system rule.. Valid values are `claims_examiner|underwriter|actuary|supervisor|system`',
    `set_date` DATE COMMENT 'Calendar date on which the reserve was formally established or revised by the authorized examiner, underwriter, or actuary in the Claims Administration System.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation of the insured property jurisdiction, used for state Department of Insurance loss reporting and regulatory segmentation.. Valid values are `^[A-Z]{2}$`',
    `subrogation_reserve_amount` DECIMAL(18,2) COMMENT 'Estimated recoverable amount through subrogation or salvage rights against responsible third parties, netted against gross reserve for loss ratio reporting.',
    `title_risk_cause_code` STRING COMMENT 'Standardized code classifying the root cause of the title defect driving this claim (e.g., forgery, undisclosed heir, survey error, lien, encroachment). [ENUM-REF-CANDIDATE',
    `title_risk_cause_description` STRING COMMENT 'Free-text narrative describing the specific title defect, encumbrance, or chain-of-title break that is the basis for the claim and reserve.',
    `to_liability_pct` DECIMAL(7,4) COMMENT 'Ratio of total case reserve to policy face liability, expressed as a decimal (e.g., 0.4500 = 45%). Supports severity and adequacy monitoring.',
    `transaction_type` STRING COMMENT 'Type of real-estate transaction underlying the insured policy: purchase, refinance (REFI), HELOC, construction, commercial, or home equity.. Valid values are `purchase|refinance|heloc|construction|commercial|home_equity`',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent modification to this reserve record in the Claims Administration System. Supports audit trail and change detection.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_reserve PRIMARY KEY(`reserve_id`)
) COMMENT 'Effective-dated reserve record for a title claim, capturing case reserve and IBNR reserve amounts, reserve type (case, IBNR, bulk), currency, reserve basis (initial, revised, final), set-by underwriter or actuary, effective date, expiration date, and';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` (
    `loss_payment_id` BIGINT COMMENT 'Unique surrogate identifier for each indemnity disbursement record in the claims administration system. Primary key for the loss_payment entity.',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: When agent error or negligence contributes to a title loss, underwriters track the producing agent for E&O subrogation analysis, agency oversight review escalation, and loss-by-agent',
    `curative_action_id` BIGINT COMMENT 'Reference to the curative processing action (e.g., lien release, deed correction, quiet title) funded by this payment when payment_type is curative_cost. Null for indemnity payments.',
    `disbursement_id` BIGINT COMMENT 'Foreign key linking to settlement.disbursement. Business justification: When claims result in corrective disbursements or when original settlement disbursements are disputed, linking loss payments to the original disbursement tracks remediation, enables',
    `loss_party_id` BIGINT COMMENT 'Reference to the claims examiner, underwriter, or officer who authorized this loss payment. Supports segregation-of-duties audit and authority-level compliance.',
    `loss_payee_party_id` BIGINT COMMENT 'Reference to the party entity receiving this loss payment (claimant, lender, attorney, curative vendor, or court). Supports party-role contextual modeling.',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Loss payments are allocated to specific parcels for loss-ratio analysis by jurisdiction (county FIPS), property type (land use code), and assessed value band.',
    `prior_payment_loss_payment_id` BIGINT COMMENT 'Self-referencing link to the original payment record if this record represents a replacement, reissuance, or correction of a prior payment. Null for original disbursements.',
    `recovery_receipt_id` BIGINT COMMENT 'Reference to the associated subrogation or recovery record if a recovery action has been initiated against a third party for this loss payment. Null if no recovery pursued.',
    `title_claim_id` BIGINT COMMENT 'Foreign key reference to the parent title insurance claim against which this loss payment is disbursed. Links payment to the claim lifecycle.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued title insurance policy (OTP or LTP) under which this loss payment is made. Supports owner-versus-lender policy coverage analysis.',
    `approval_authority_level` STRING COMMENT 'Organizational authority tier required and used to approve this payment (examiner, supervisor, manager, VP, executive). Driven by payment amount thresholds per claims authority matrix.. Valid values are `examiner|supervisor|manager|vp|executive`',
    `approval_date` DATE COMMENT 'Date on which the loss payment was formally approved by the authorized claims examiner or underwriting officer prior to disbursement.',
    `approved_amount` DECIMAL(18,2) COMMENT 'Amount formally authorized by the claims examiner or underwriter for disbursement. May differ from payment_amount if partial payment or adjustment was applied post-approval.',
    `bank_account_ref` STRING COMMENT 'Tokenized or masked reference to the destination bank account used for wire or ACH disbursement. Full account details stored in the NPPI Vault per VREQ-012 and GLBA.',
    `channel_type` STRING COMMENT 'Business production channel through which the underlying title order was originated: direct branch, centralized lender, or independent agent. Supports loss frequency and severity by channel.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `claim_number` STRING COMMENT 'Human-readable claim identifier from the claims administration system, denormalized onto the payment record for operational reporting without requiring a join to the claim entity.',
    `cleared_date` DATE COMMENT 'Date on which the disbursed payment was confirmed cleared by the financial institution (check cleared, wire settled, ACH confirmed). Used for bank reconciliation.',
    `cost_center_code` STRING COMMENT 'Finance cost center to which this loss payment expense is allocated. Supports branch-level, channel-level, and underwriter-level loss ratio reporting.',
    `county_fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county of the insured property. Supports geographic loss concentration analysis and county-level regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this loss payment record was first created in the claims administration system. Audit trail anchor for record provenance.',
    `cumulative_paid_amount` DECIMAL(18,2) COMMENT 'Running total of all loss payments disbursed on the parent claim as of this payment record. Supports policy limit exhaustion monitoring and severity tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the payment amount (e.g., USD). Title insurance in the US is predominantly USD; retained for multi-currency commercial transactions.. Valid values are `^[A-Z]{3}$`',
    `gl_account_code` STRING COMMENT 'General ledger account code to which this loss payment is posted in the ERP/finance system. Supports premium revenue recognition, loss expense allocation, and SOX financial controls.',
    `irs_1099_required` BOOLEAN COMMENT 'Indicates whether this loss payment requires IRS Form 1099 reporting to the payee and the IRS. Driven by payment type, payee tax status, and IRS threshold rules.',
    `is_final_payment` BOOLEAN COMMENT 'Indicates whether this disbursement is the final loss payment on the claim, signaling that the claim is ready for closure after this payment clears. True = final payment.',
    `naic_loss_cause_code` STRING COMMENT 'NAIC-standardized loss cause code used in Annual Statement Schedule T and state DOI regulatory filings. Maps internal title risk cause to the NAIC reporting taxonomy.',
    `payee_name` STRING COMMENT 'Full legal name of the individual or entity receiving the loss payment as it appears on the disbursement instrument (check payee line or wire beneficiary name).',
    `payee_type` STRING COMMENT 'Classification of the payee role for this disbursement: claimant, lender (mortgagee), attorney, curative vendor, court, or insured. Supports loss-cause and payee-mix analytics.. Valid values are `claimant|lender|attorney|curative_vendor|court|insured`',
    `payment_amount` DECIMAL(18,2) COMMENT 'Gross amount disbursed in this loss payment transaction, expressed in the payment currency. Core monetary fact for claim severity and loss ratio analysis.',
    `payment_date` DATE COMMENT 'Calendar date on which the loss payment was actually disbursed to the payee. Principal business event date for claim payment lag and loss ratio period assignment.',
    `payment_method` STRING COMMENT 'Instrument used to disburse the loss payment: wire transfer, paper check, ACH electronic transfer, or escrow disbursement. Drives reconciliation and positive-pay controls.. Valid values are `wire|check|ach|escrow_disbursement`',
    `payment_notes` STRING COMMENT 'Free-text examiner notes documenting the basis for this payment, any conditions, partial payment rationale, or special handling instructions. Supports claims audit trail.',
    `payment_number` STRING COMMENT 'Externally visible, human-readable identifier for this loss payment disbursement, assigned by the claims administration system (e.g., LP-2024-000123).. Valid values are `^LP-[0-9]{4}-[0-9]{6}$`',
    `payment_reference_number` STRING COMMENT 'External reference number assigned by the bank, wire network, or check processor for this disbursement (e.g., wire confirmation number, check number, ACH trace ID).',
    `payment_status` STRING COMMENT 'Current lifecycle state of the loss payment: pending (awaiting approval), approved, issued (disbursed), cleared (bank confirmed), voided, or returned (funds recovered).. Valid values are `pending|approved|issued|cleared|voided|returned`',
    `payment_type` STRING COMMENT 'Classification of the disbursement purpose: indemnity (direct loss), curative_cost (title defect cure), defense_cost (legal defense), settlement (negotiated resolution), or court_ordered.. Valid values are `indemnity|curative_cost|defense_cost|settlement|court_ordered`',
    `policy_liability_limit` DECIMAL(18,2) COMMENT 'Maximum insured amount under the linked title policy at the time of payment. Provides context for whether payment approaches or exhausts policy limits.',
    `policy_number` STRING COMMENT 'Human-readable title policy number denormalized onto the payment record for regulatory loss reporting and policy-level loss ratio analysis without requiring a join.',
    `policy_type` STRING COMMENT 'Indicates whether the loss payment is made under an Owners Title Policy (OTP) or a Loan/Lenders Title Policy (LTP). Supports owner-versus-lender coverage analysis per VREQ-010.. Valid values are `OTP|LTP`',
    `reserve_release_amount` DECIMAL(18,2) COMMENT 'Portion of the case reserve released upon issuance of this payment. Used to reconcile reserve movements against actual loss payments for IBNR and loss ratio reporting.',
    `state_code` STRING COMMENT 'Two-letter USPS state code for the property jurisdiction where the insured title risk is located. Required for state Department of Insurance regulatory loss reporting.. Valid values are `^[A-Z]{2}$`',
    `subrogation_flag` BOOLEAN COMMENT 'Indicates whether this loss payment has an associated subrogation or recovery right that the insurer may pursue against a responsible third party after indemnifying the insured.',
    `tax_withholding_amount` DECIMAL(18,2) COMMENT 'Amount withheld from the gross payment for IRS backup withholding or other tax obligations. Relevant for payments to non-exempt payees. Supports 1099 reporting.',
    `title_risk_cause_code` STRING COMMENT 'Standardized code identifying the title defect or risk cause driving this loss payment (e.g., forged deed, undisclosed lien, survey error, chain-of-title break).',
    `title_risk_cause_description` STRING COMMENT 'Free-text narrative describing the specific title defect, encumbrance, or chain-of-title issue that gave rise to this loss payment. Complements the structured risk cause code.',
    `transaction_type` STRING COMMENT 'Real estate transaction type underlying the insured policy: purchase, refinance (REFI), home equity line of credit (HELOC), construction, or commercial. Supports loss frequency by transaction segment.. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this loss payment record. Supports change detection, audit, and incremental lakehouse ingestion.',
    `void_date` DATE COMMENT 'Date on which the payment was voided, if applicable. Null for non-voided payments. Supports lifecycle history preservation per VREQ-007.',
    `wire_instruction_ref` STRING COMMENT 'Tokenized reference to the wire instruction set used for this disbursement. Full wire details (routing, account, SWIFT) stored in the NPPI Vault per VREQ-012 and GLBA.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_loss_payment PRIMARY KEY(`loss_payment_id`)
) COMMENT 'Transactional record of each indemnity disbursement made on a title claim, including payment type (indemnity, curative cost, defense cost, settlement, court-ordered), payee party, payment method (wire, check, ACH), payment amount, currency, payment date';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` (
    `recovery_receipt_id` BIGINT COMMENT 'Unique surrogate identifier for each recovery or subrogation receipt record within the claims administration system.',
    `party_id` BIGINT COMMENT 'Reference to the claims examiner or adjuster responsible for managing the recovery action and recording this receipt in the claims administration system.',
    `recovery_counsel_party_id` BIGINT COMMENT 'Reference to the outside or staff counsel engaged to pursue subrogation litigation or negotiation on behalf of the title insurer for this recovery action.',
    `recovery_source_party_id` BIGINT COMMENT 'Reference to the party from whom the recovery proceeds were collected (e.g., prior owner, grantor, tortfeasor, reinsurer, co-insurer, or responsible third party).',
    `reversed_receipt_recovery_receipt_id` BIGINT COMMENT 'Reference to the original recovery receipt record that this record reverses. Populated only when reversal_indicator = True. Preserves audit trail of corrections.',
    `title_claim_id` BIGINT COMMENT 'Reference to the title insurance claim against which this recovery receipt is applied. Links recovery proceeds to the originating loss event.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued owner or lender title policy (OTP/LTP) under which the underlying claim was made and recovery is being tracked.',
    `agent_recovery_share_amount` DECIMAL(18,2) COMMENT 'Portion of the recovery proceeds allocated to the independent title agent under the agency agreement premium split, when the underlying policy was issued through an agent channel.',
    `applied_to_loss_amount` DECIMAL(18,2) COMMENT 'Portion of the recovery receipt amount that has been applied to reduce the recorded claim loss or indemnity payment balance. May differ from recovery_amount if partial application.',
    `bank_reference_number` STRING COMMENT 'Bank-assigned reference or wire confirmation number for the recovery funds receipt. Restricted due to financial transaction sensitivity. Used for bank reconciliation.',
    `check_number` STRING COMMENT 'Check number of the recovery payment instrument when recovery_method = check. Restricted financial data used for payment reconciliation and audit trail.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this recovery receipt record was first created in the claims administration system. Used for audit trail and record provenance per VREQ-007.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the recovery amount (e.g., USD). Title insurance is predominantly USD; retained for multi-currency commercial transactions.. Valid values are `^[A-Z]{3}$`',
    `expected_recovery_amount` DECIMAL(18,2) COMMENT 'Estimated total recovery amount anticipated from this recovery action at the time of demand or suit filing. Used to track recovery realization rate versus expectation.',
    `expense_recovery_amount` DECIMAL(18,2) COMMENT 'Portion of the recovery receipt allocated to recovery of claim-related loss adjustment expenses (LAE), such as legal fees and investigation costs, separate from indemnity loss recovery.',
    `gl_account_code` STRING COMMENT 'GL account code to which the recovery receipt is posted in the ERP/financial system, enabling reconciliation between claims administration and financial reporting.',
    `gl_posting_date` DATE COMMENT 'Date on which the recovery receipt was posted to the general ledger for financial reporting purposes. May differ from receipt_date due to accounting period cutoffs.',
    `is_final_receipt` BOOLEAN COMMENT 'Indicates whether this is the final recovery receipt for the claim (True), signaling that no further recovery proceeds are expected and the recovery action is closed.',
    `is_full_recovery` BOOLEAN COMMENT 'Indicates whether this receipt represents full recovery of the total claim indemnity paid (True) or a partial recovery (False). Drives claim closure eligibility assessment.',
    `naic_recovery_code` STRING COMMENT 'NAIC-defined code classifying the recovery type for statutory annual statement Schedule F and loss reporting purposes. Aligns with NAIC Title Insurance Annual Statement requirements.',
    `net_recovery_amount` DECIMAL(18,2) COMMENT 'Recovery amount net of recovery-related expenses (legal fees, collection costs) incurred to obtain the proceeds. Equals recovery_amount minus recovery expense deductions.',
    `payor_tax_identifier` STRING COMMENT 'Federal Tax Identification Number (TIN/EIN/SSN) of the party remitting the recovery payment. Required for IRS 1099 reporting on recoveries. Stored in NPPI Vault.',
    `policy_type` STRING COMMENT 'Indicates whether the underlying policy is an Owners Title Policy (OTP) or Lenders/Loan Title Policy (LTP), supporting owner-versus-lender recovery analysis per VREQ-016.. Valid values are `owner|lender`',
    `receipt_date` DATE COMMENT 'Calendar date on which the recovery funds were actually received by the title insurer or its claims administrator. Principal business event date for this transaction.',
    `receipt_number` STRING COMMENT 'Externally visible, human-readable reference number assigned to this recovery receipt by the claims administration system for tracking and correspondence.. Valid values are `^RR-[0-9]{4}-[0-9]{6}$`',
    `recovery_amount` DECIMAL(18,2) COMMENT 'Gross monetary amount of the recovery or subrogation proceeds received in this receipt, expressed in the transaction currency. Used in loss ratio and recovery rate calculations.',
    `recovery_expense_amount` DECIMAL(18,2) COMMENT 'Total costs incurred to pursue and collect this recovery (attorney fees, court costs, investigation expenses). Deducted from gross recovery to derive net recovery.',
    `recovery_method` STRING COMMENT 'Mechanism by which recovery funds were collected: wire transfer, check, ACH, offset against amounts owed, court judgment enforcement, or negotiated settlement agreement.. Valid values are `wire_transfer|check|ach|offset|court_judgment|settlement_agreement`',
    `recovery_notes` STRING COMMENT 'Free-text narrative describing the circumstances of the recovery, negotiation details, or special conditions associated with this receipt. Entered by the claims examiner.',
    `recovery_rate_pct` DECIMAL(7,4) COMMENT 'Percentage of the original claim indemnity payment recovered through this receipt (recovery_amount / total indemnity paid). Supports recovery effectiveness analytics.',
    `recovery_source_name` STRING COMMENT 'Name of the entity or individual from whom recovery proceeds were collected (e.g., prior grantor, judgment debtor, reinsurer name). Denormalized for reporting when party record is unavailable.',
    `recovery_source_type` STRING COMMENT 'Classification of the party from whom recovery was collected, supporting analysis of recovery patterns by source category (e.g., prior owner subrogation vs. reinsurer recovery).',
    `recovery_status` STRING COMMENT 'Current lifecycle status of the recovery receipt: pending (expected but not yet received), received (funds in hand), applied (posted to claim reserve/loss), reversed, or written off.. Valid values are `pending|received|applied|reversed|written_off`',
    `recovery_type` STRING COMMENT 'Classification of the recovery mechanism: subrogation (rights against third party), contribution (co-insurer share), salvage (asset recovery), reinsurance recovery, or indemnification from responsible party.. Valid values are `subrogation|contribution|salvage|reinsurance_recovery|indemnification|other`',
    `reinsurance_treaty_reference` STRING COMMENT 'Identifier of the reinsurance treaty or facultative certificate under which a reinsurance recovery receipt was collected. Populated only when recovery_type = reinsurance_recovery.',
    `reserve_reduction_amount` DECIMAL(18,2) COMMENT 'Amount by which the claim case reserve was reduced upon application of this recovery receipt. Supports reserve adequacy and IBNR analysis.',
    `reversal_indicator` BOOLEAN COMMENT 'Indicates whether this recovery receipt record represents a reversal of a previously posted receipt (True). Supports lifecycle history preservation per VREQ-007.',
    `settlement_agreement_date` DATE COMMENT 'Date on which a settlement agreement was executed between the title insurer and the recovery source party, formalizing the recovery amount and terms.',
    `source_system_code` STRING COMMENT 'Native record identifier from the originating claims administration system (e.g., SoftPro, RamQuest) for lineage tracing and reconciliation with the system of record.',
    `state_of_recovery` STRING COMMENT 'Two-letter US state code for the jurisdiction in which the recovery action was pursued. Supports state-level regulatory loss reporting to Departments of Insurance.. Valid values are `^[A-Z]{2}$`',
    `subrogation_demand_date` DATE COMMENT 'Date on which the formal subrogation demand letter was issued to the responsible third party, initiating the recovery action. Used to measure recovery cycle time.',
    `subrogation_suit_filed_date` DATE COMMENT 'Date on which a subrogation lawsuit was filed in court against the responsible party, if litigation was required to enforce recovery rights.',
    `title_risk_cause_code` STRING COMMENT 'Standardized code identifying the title defect or risk category that gave rise to the underlying claim (e.g., forged deed, undisclosed lien, survey defect). Supports loss ratio by title-risk cause.',
    `transaction_type` STRING COMMENT 'Type of real estate transaction underlying the insured policy (purchase, refinance, HELOC, construction, commercial). Supports segmentation of recovery metrics by transaction type.. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `underwriter_recovery_share_amount` DECIMAL(18,2) COMMENT 'Portion of the recovery proceeds retained by the title underwriter after deducting the agent share and recovery expenses. Used in underwriter loss ratio reporting.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this recovery receipt record. Supports change tracking and lifecycle history preservation per VREQ-007.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_recovery_receipt PRIMARY KEY(`recovery_receipt_id`)
) COMMENT 'Transactional record of each recovery or subrogation receipt collected on a title claim, capturing recovery type (subrogation, contribution, salvage, reinsurance recovery), recovery source party, recovery amount, currency, receipt date, recovery method';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` (
    `investigation_id` BIGINT COMMENT 'Unique surrogate identifier for the title claim investigation record. Primary key for the investigation entity within the Claims Administration System.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent involved in the originating transaction, if applicable. Used for agency oversight, E&O review, and remittance impact analysis.',
    `investigation_assigned_counsel_party_id` BIGINT COMMENT 'Reference to the outside legal counsel or panel attorney assigned to support the investigation when litigation or curative legal action is required.',
    `investigation_party_id` BIGINT COMMENT 'Reference to the internal staff member or external counsel assigned as lead investigator for this claim investigation. Supports workload management and investigator performance reporting.',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: Investigations validate legal descriptions against recorded instruments, prior commitments, and surveys.',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Investigations require parcel-level legal description, recording jurisdiction, and APN for evidence retrieval, chain-of-title reconstruction, and curative action planning.',
    `recorded_instrument_id` BIGINT COMMENT 'Foreign key linking to recording.recorded_instrument. Business justification: Claim investigations examine the recorded instrument evidencing the defect (deed, mortgage, lien). Investigators pull instrument to analyze chain of title breaks and forgery.',
    `title_claim_id` BIGINT COMMENT 'Foreign key reference to the parent title insurance claim record. Links the investigation to its originating First Notice of Loss (FNOL) claim intake record.',
    `title_commitment_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_commitment. Business justification: Investigators retrieve the commitment to compare Schedule B exceptions and requirements against the claimed defect, verify insurable title determination, and assess whether the',
    `title_order_id` BIGINT COMMENT 'Reference to the originating title order associated with the insured transaction. Enables traceability from claim investigation back to the original title production workflow.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued Owners Title Policy (OTP) or Lenders Title Policy (LTP) under which the claim is being investigated. Supports coverage analysis and policy-to-claim linkage.',
    `underwriting_title_examination_id` BIGINT COMMENT 'Foreign key linking to underwriting.underwriting_title_examination. Business justification: Investigators review examination workpapers to assess whether the examiner identified the defect, whether the examination scope was adequate, and whether the',
    `agency_involved_flag` BOOLEAN COMMENT 'Indicates whether an independent title agent was involved in the originating transaction. Triggers agency oversight review and potential E&O coverage analysis.',
    `apn` STRING COMMENT 'Assessors Parcel Number (APN) or Parcel Identification Number (PIN) assigned by the county assessor for the subject property. Supports property data linkage and county record research.',
    `chain_of_title_break_flag` BOOLEAN COMMENT 'Indicates whether the investigation identified a break or gap in the chain of title (COT) as a contributing factor to the claim. Supports chain-of-title break metrics.',
    `claimant_name` STRING COMMENT 'Full legal name of the party asserting the claim, which may differ from the named insured (e.g., successor, lender assignee). NPPI — handle per GLBA and CCPA/CPRA.',
    `completion_date` DATE COMMENT 'Calendar date on which the investigation was formally concluded and findings were documented. Null if investigation is still open. Used to compute investigation duration.',
    `county_fips_code` STRING COMMENT 'Five-digit Federal Information Processing Standards (FIPS) code identifying the county in which the subject property is located. Used for jurisdictional routing and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `coverage_analysis_narrative` STRING COMMENT 'Free-text narrative documenting the underwriter or claims examiners analysis of policy coverage applicability, including Schedule B exceptions and endorsement review.',
    `coverage_determination` STRING COMMENT 'Outcome of the coverage analysis phase of the investigation. Indicates whether the claimed loss is within the scope of the issued title policy. Drives reserving and payment decisions.. Valid values are `covered|not_covered|partial|pending|reserved`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the investigation record was first created in the Claims Administration System. Audit field supporting record provenance and lifecycle tracking.',
    `curative_action_required_flag` BOOLEAN COMMENT 'Indicates whether the investigation determined that curative processing (e.g., lien release, deed correction, quiet title action) is required to resolve the title defect underlying the claim.',
    `curative_action_status` STRING COMMENT 'Current status of curative processing activities initiated as a result of the investigation findings. Supports curative action aging and effectiveness metrics.. Valid values are `not_required|pending|in_progress|complete|failed`',
    `curative_completion_date` DATE COMMENT 'Date on which all curative actions required to resolve the title defect were completed. Null if curative action is not required or still in progress.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this investigation record. Defaults to USD for domestic US title insurance transactions.. Valid values are `^[A-Z]{3}$`',
    `document_receipt_date` DATE COMMENT 'Date on which all requested documents and evidence were received from the claimant or third parties, enabling the investigation to proceed from pending_docs status.',
    `document_request_date` DATE COMMENT 'Date on which the investigator issued a formal request for additional documents or evidence from the claimant or third parties. Supports pending_docs status tracking.',
    `eo_coverage_flag` BOOLEAN COMMENT 'Indicates whether the claim may be covered under an Errors and Omissions (E&O) policy held by the agent or closing attorney, potentially reducing net loss to the underwriter.',
    `estimated_loss_amount` DECIMAL(18,2) COMMENT 'Investigators estimate of the total monetary loss exposure identified during the investigation, in USD. Used to inform initial reserve setting and severity analysis.',
    `evidence_complete_flag` BOOLEAN COMMENT 'Indicates whether all required evidentiary documents (deeds, instruments, search results, affidavits) have been received and reviewed. Supports evidence completeness and provenance metrics.',
    `findings_narrative` STRING COMMENT 'Detailed free-text narrative summarizing the investigation findings, including chain-of-title defects identified, evidence reviewed, and conclusions reached by the investigator.',
    `forgery_fraud_flag` BOOLEAN COMMENT 'Indicates whether the investigation identified forgery, fraud, or misrepresentation as a contributing cause of the title defect or loss. Triggers FinCEN SAR filing review.',
    `insured_name` STRING COMMENT 'Full legal name of the insured party (owner or lender) under the title policy as of the investigation. Captured for claim correspondence and regulatory reporting. NPPI — handle per GLBA.',
    `investigation_status` STRING COMMENT 'Current lifecycle state of the investigation. Drives workflow routing and SLA tracking. Values: open, pending_docs, pending_legal, complete, closed.. Valid values are `open|pending_docs|pending_legal|complete|closed`',
    `investigation_type` STRING COMMENT 'Classification of the investigation by title-risk cause category. Supports claim frequency and severity analysis by title-risk cause. [ENUM-REF-CANDIDATE: title_defect|lien|encumbrance|forgery|fraud|boundary|access|other — promote to reference product]',
    `last_activity_date` DATE COMMENT 'Date of the most recent documented activity or update on the investigation. Used to identify stale or aging investigations requiring follow-up.',
    `litigation_flag` BOOLEAN COMMENT 'Indicates whether the claim investigation has escalated to active litigation or legal proceedings. Triggers assignment of outside counsel and legal hold procedures.',
    `number` STRING COMMENT 'Externally visible, human-readable identifier assigned to the investigation by the Claims Administration System. Used in correspondence, regulatory filings, and audit trails.. Valid values are `^INV-[0-9]{4}-[0-9]{6}$`',
    `policy_amount` DECIMAL(18,2) COMMENT 'The face amount of insurance stated in the title policy under which the claim is filed, in USD. Establishes the maximum indemnity exposure for coverage analysis.',
    `policy_type` STRING COMMENT 'Indicates whether the claim is filed under an Owners Title Policy (OTP) or a Lenders/Loan Title Policy (LTP). Supports owner-versus-lender policy coverage analytics.. Valid values are `OTP|LTP`',
    `priority` STRING COMMENT 'Priority level assigned to the investigation based on exposure amount, litigation risk, and regulatory deadlines. Drives workload prioritization and escalation workflows.. Valid values are `low|medium|high|critical`',
    `property_address` STRING COMMENT 'Full street address of the insured property subject to the claim investigation. Denormalized for investigation reporting; authoritative address is on the property/parcel record.',
    `recommended_reserve_amount` DECIMAL(18,2) COMMENT 'Reserve amount recommended by the investigator based on investigation findings, in USD. Feeds into the reserving workflow for case reserve establishment or adjustment.',
    `regulatory_reporting_required_flag` BOOLEAN COMMENT 'Indicates whether this investigation triggers mandatory regulatory reporting to NAIC, state Department of Insurance, or other regulatory bodies based on loss amount or claim type thresholds.',
    `start_date` DATE COMMENT 'Calendar date on which the formal investigation was opened and assigned. Used to measure investigation cycle time and SLA compliance from FNOL intake.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the state in which the subject property is located. Used for state Department of Insurance regulatory reporting and jurisdiction routing.. Valid values are `^[A-Z]{2}$`',
    `subrogation_potential_flag` BOOLEAN COMMENT 'Indicates whether the investigation identified potential subrogation or recovery rights against a third party (e.g., prior owner, agent, attorney, surveyor) responsible for the title defect.',
    `subrogation_target_party` STRING COMMENT 'Name or description of the third party against whom subrogation or recovery rights may be pursued based on investigation findings. Populated when subrogation_potential_flag is true.',
    `target_completion_date` DATE COMMENT 'Internally assigned target date by which the investigation should be completed per SLA or claim handling guidelines. Supports aging and SLA breach reporting.',
    `title_risk_cause_code` STRING COMMENT 'Standardized code identifying the root cause of the title defect or loss (e.g., forgery, undisclosed heir, survey error, lien not released). Used for NAIC loss cause reporting and frequency/severity analytics.',
    `underwriter_opinion` STRING COMMENT 'Formal coverage opinion issued by the underwriting department following referral. Informs the final coverage determination and claim resolution strategy.. Valid values are `approve|deny|partial|pending|refer_to_counsel`',
    `underwriter_referral_date` DATE COMMENT 'Date on which the investigation was referred to the underwriting department for coverage opinion or risk assessment. Null if no underwriter referral was made.',
    `underwriter_referral_flag` BOOLEAN COMMENT 'Indicates whether the investigation was escalated to the underwriting department for coverage opinion or risk referral due to complexity or exposure threshold breach.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the investigation record in the Claims Administration System. Supports change detection, audit trails, and incremental data loading.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_investigation PRIMARY KEY(`investigation_id`)
) COMMENT 'Master record for the investigation phase of a title claim, capturing investigation status (open, pending_docs, pending_legal, complete), assigned investigator, investigation start and completion dates, investigation findings narrative, documents';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` (
    `claim_curative_action_id` BIGINT COMMENT 'Unique surrogate identifier for each curative action record within the claims administration system. Primary key for the claim_curative_action entity.',
    `closing_document_id` BIGINT COMMENT 'Foreign key linking to settlement.closing_document. Business justification: Curative actions in claims often require re-recording, correcting, or obtaining missing closing documents (deeds, mortgages, affidavits).',
    `curative_action_id` BIGINT COMMENT 'FK to underwriting.curative_action.curative_action_id — Links claim-phase curative to the underwriting curative SSOT with a claim-context discriminator so claim curative aging ties to the single curative source.',
    `easement_restriction_id` BIGINT COMMENT 'Foreign key linking to property.easement_restriction. Business justification: Curative actions for easement disputes, encroachments, or CC&R violations reference specific easement/restriction records.',
    `encumbrance_id` BIGINT COMMENT 'Foreign key linking to property.encumbrance. Business justification: Many curative actions resolve specific encumbrances (mortgage payoffs, lien releases, judgment satisfactions).',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Curative actions (lien releases, corrective deeds, boundary agreements) must reference the specific parcel for recording submission, legal description matching, and APN validation.',
    `party_id` BIGINT COMMENT 'Reference to the internal staff member (claim handler, title examiner, or curative specialist) responsible for executing and tracking this curative action.',
    `prior_version_action_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding version of this curative action record, supporting lifecycle revision history and audit trail per VREQ-007.',
    `recording_submission_id` BIGINT COMMENT 'Reference to the eRecording gateway submission record (Simplifile/CSC) tracking the submission, acceptance, or rejection of the curative instrument at the county recorder.',
    `title_claim_id` BIGINT COMMENT 'Reference to the parent title insurance claim under which this curative action was initiated. Links the action to the FNOL and investigation record.',
    `title_finding_id` BIGINT COMMENT 'Reference to the specific title defect, encumbrance, or cloud on title identified during examination or claim investigation that this curative action is intended to resolve.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued owner or lender title policy (OTP/LTP) under which coverage is being asserted and curative action is being pursued.',
    `title_requirement_id` BIGINT COMMENT 'Reference to the Schedule B-I requirement, if any, that corresponds to this curative action. Null when the action arises solely from a post-policy claim investigation.',
    `underwriting_title_examination_id` BIGINT COMMENT 'Foreign key linking to underwriting.underwriting_title_examination. Business justification: Claim curative teams review the original examination to understand the defects history, prior curative attempts, and whether the defect was identified but not',
    `uw_referral_id` BIGINT COMMENT 'Reference to the underwriting referral or policy exception record created when this curative action requires underwriter approval. Null when uw_referral_required is false.',
    `action_description` STRING COMMENT 'Free-text narrative describing the specific curative steps being taken, the parties involved, and the legal instruments or proceedings required to clear the identified defect.',
    `action_number` STRING COMMENT 'Externally visible, human-readable identifier for this curative action, used in correspondence with courts, county recorders, and opposing counsel. Format: CA-YYYY-NNNNNN.. Valid values are `^CA-[0-9]{4}-[0-9]{6}$`',
    `action_status` STRING COMMENT 'Current lifecycle state of the curative action: open (initiated), in_progress (work underway), pending_recording (instrument prepared, awaiting county acceptance), resolved (defect cleared), withdrawn, or escalated.. Valid values are `open|in_progress|pending_recording|resolved|withdrawn|escalated`',
    `action_type` STRING COMMENT 'Classification of the curative remedy being pursued. Examples: lien release, deed correction, quiet title suit, probate proceeding, affidavit of heirship, reconveyance.. Valid values are `lien_release|deed_correction|quiet_title|probate|affidavit_of_heirship|reconveyance`',
    `actual_cost_amount` DECIMAL(15,2) COMMENT 'Total actual expenditure incurred to complete this curative action. Compared against estimated cost for reserve accuracy and loss ratio reporting.',
    `actual_resolution_date` DATE COMMENT 'Calendar date on which the curative action was confirmed resolved and the underlying defect or requirement was cleared. Null if still open.',
    `chain_of_title_break` BOOLEAN COMMENT 'Indicates whether the underlying defect involves a break in the chain of title (COT), such as a missing grantor-grantee link, unrecorded conveyance, or vesting discrepancy.',
    `cost_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated and actual cost amounts. Typically USD for domestic US title insurance transactions.. Valid values are `^[A-Z]{3}$`',
    `court_jurisdiction` STRING COMMENT 'Name of the court or judicial jurisdiction (county, state, federal district) in which litigation for this curative action has been filed.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this curative action record was first created in the claims administration system. Supports audit trail and provenance requirements.',
    `curative_instrument_type` STRING COMMENT 'Type of legal instrument produced or obtained to effect the cure (e.g., release of lien, corrective deed, satisfaction of judgment, reconveyance deed, court order).',
    `days_open` BIGINT COMMENT 'Number of calendar days this curative action has been in an open or in-progress state, calculated from initiated_date. Supports curative action aging and effectiveness metrics per VREQ-016.',
    `defect_type` STRING COMMENT 'Classification of the underlying title defect or encumbrance being cured (e.g., mechanics lien, judgment lien, tax lien, HOA lien, chain-of-title break, missing heir, forged deed, encroachment).',
    `escalation_date` DATE COMMENT 'Date on which this curative action was escalated to senior underwriting counsel, litigation, or management due to complexity, aging, or reserve impact. Null if not escalated.',
    `estimated_cost_amount` DECIMAL(15,2) COMMENT 'Estimated total cost to complete this curative action, including legal fees, court costs, recording fees, and vendor charges. Used for reserve adequacy and loss exposure analysis.',
    `evidence_document_ref` STRING COMMENT 'Reference identifier or URI to the document management system record containing supporting evidence for this curative action (e.g., signed release, court order, recorded instrument image).',
    `gap_cure_required` BOOLEAN COMMENT 'Indicates whether this curative action specifically addresses a gap period risk — the interval between the last search date and the recording of the insured instrument.',
    `initiated_date` DATE COMMENT 'Calendar date on which this curative action was formally initiated by the claim handler or title examiner. Used to measure curative aging and cycle time.',
    `instrument_document_number` STRING COMMENT 'Official document number, book/page reference, or instrument number assigned by the county recorder upon acceptance of the curative instrument.',
    `instrument_recording_date` DATE COMMENT 'Date the curative instrument was officially recorded by the county recorder or register of deeds, establishing constructive notice and clearing the defect of record.',
    `is_current_version` BOOLEAN COMMENT 'Boolean flag indicating whether this record represents the current active version of the curative action. False for superseded historical revisions. Supports lifecycle history per VREQ-007.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent modification to this curative action record. Used for change detection in ETL pipelines and audit compliance.',
    `lien_amount` DECIMAL(15,2) COMMENT 'Face amount of the lien, judgment, or encumbrance being cured. Used to assess claim severity and negotiate payoff or release amounts with lienholders.',
    `litigation_case_number` STRING COMMENT 'Court-assigned case number for quiet title actions, probate proceedings, or other litigation initiated as part of this curative action. Null for non-litigated cures.',
    `outside_counsel_engaged` BOOLEAN COMMENT 'Indicates whether outside legal counsel has been retained to pursue this curative action (e.g., quiet title litigation, probate proceedings, or contested lien releases).',
    `outside_counsel_firm_name` STRING COMMENT 'Name of the external law firm or attorney retained to handle this curative action. Populated only when outside_counsel_engaged is true.',
    `payoff_amount` DECIMAL(15,2) COMMENT 'Negotiated or agreed payoff amount required to obtain a release or satisfaction of the lien or encumbrance. May differ from the original lien amount due to negotiation or accrued interest.',
    `priority` STRING COMMENT 'Business priority assigned to this curative action, reflecting urgency relative to closing readiness, policy issuance lag, or claim reserve exposure.. Valid values are `critical|high|medium|low`',
    `recording_required` BOOLEAN COMMENT 'Indicates whether the curative instrument must be recorded with the county recorder or register of deeds to be effective against third parties and to clear the title defect.',
    `recovery_amount` DECIMAL(15,2) COMMENT 'Amount actually recovered through subrogation, indemnification, or third-party contribution related to this curative action. Reduces net loss on the parent claim.',
    `reserve_impact_amount` DECIMAL(15,2) COMMENT 'Dollar amount by which this curative action affects the case reserve on the parent claim. Positive values increase the reserve; negative values reflect reserve reductions upon resolution.',
    `resolution_notes` STRING COMMENT 'Free-text notes documenting the outcome of the curative action, including how the defect was cleared, instruments obtained, and any residual risk or exception taken at closing.',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this curative action record. Increments each time the action is materially updated (e.g., action type change, cost revision, status transition). Supports VREQ-007.',
    `subrogation_potential` BOOLEAN COMMENT 'Indicates whether the insurer has identified a potential right of subrogation or recovery against a third party (e.g., prior owner, agent, or closing attorney) arising from this curative action.',
    `target_resolution_date` DATE COMMENT 'Internally committed or SLA-driven date by which the curative action is expected to be resolved. Used for aging dashboards and closing readiness reporting.',
    `title_risk_cause_code` STRING COMMENT 'Standardized NAIC or underwriter-defined loss cause code categorizing the root title risk driving this curative action. Used for regulatory loss reporting and frequency/severity analytics.. Valid values are `^[A-Z0-9]{2,10}$`',
    `uw_referral_required` BOOLEAN COMMENT 'Indicates whether this curative action requires escalation to the underwriting department for a formal underwriting referral (UWR) or exception approval before the defect can be insured over.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_claim_curative_action PRIMARY KEY(`claim_curative_action_id`)
) COMMENT 'Tracks each curative action taken to resolve a title defect or requirement identified during a claim investigation or pre-policy examination, including action type (lien release, deed correction, quiet title, probate, affidavit of heirship, reconveyance';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` (
    `claim_party_id` BIGINT COMMENT 'Unique surrogate identifier for each claim-party association record in the Claims Administration System.',
    `party_id` BIGINT COMMENT 'Reference to the master party record (person or organization) participating in this claim in the specified role.',
    `title_claim_id` BIGINT COMMENT 'Reference to the title-insurance claim to which this party is associated. Links the party record to the parent claim lifecycle.',
    `title_policy_id` BIGINT COMMENT 'Reference to the title-insurance policy (OTP or LTP) under which this party holds insured status or against which the claim is asserted.',
    `approved_loss_amount` DECIMAL(18,2) COMMENT 'Dollar amount of loss approved for indemnity payment to this party following investigation and coverage analysis. May differ from claimed_loss_amount.',
    `claimed_loss_amount` DECIMAL(18,2) COMMENT 'Dollar amount of loss asserted by this party in their claim submission. Represents the partys stated damages before investigation and coverage determination.',
    `contact_email` STRING COMMENT 'Primary email address for claim correspondence with this party. NPPI — restricted per GLBA and CCPA/CPRA.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contact_phone` STRING COMMENT 'Primary telephone number for claim correspondence with this party. NPPI — restricted per GLBA and CCPA/CPRA.. Valid values are `^+?[0-9-s().]{7,20}$`',
    `counsel_bar_number` STRING COMMENT 'State bar license number of the attorney representing this party. Validates counsel eligibility and supports defense-cost audit.',
    `counsel_firm_name` STRING COMMENT 'Name of the law firm representing this party on the claim. Populated when representation_type is attorney_represented. Used for defense cost tracking.',
    `coverage_denial_reason` STRING COMMENT 'Narrative or coded reason for a coverage denial determination for this party. Required for regulatory reporting and adverse-action notice compliance.',
    `coverage_determination` STRING COMMENT 'Outcome of the coverage analysis for this partys claim. Indicates whether the loss is covered, partially covered, denied, or pending underwriting review.. Valid values are `covered|partially_covered|denied|pending|reserved`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this claim-party association record was first created in the Claims Administration System. Audit trail for record provenance.',
    `demand_letter_date` DATE COMMENT 'Date on which a formal demand letter was received from or sent to this party. Triggers response deadlines and escalation workflows in the claims system.',
    `identity_verification_method` STRING COMMENT 'Method used to verify the identity of this party. Supports fraud-control audit trails and regulatory compliance with FinCEN and GLBA requirements.. Valid values are `government_id|notarized_affidavit|knowledge_based_auth|biometric|none`',
    `identity_verified_indicator` BOOLEAN COMMENT 'Indicates whether the identity of this party has been verified through acceptable documentation (e.g., government-issued ID). Supports fraud controls and NPPI compliance.',
    `insured_amount` DECIMAL(18,2) COMMENT 'Dollar amount of coverage applicable to this party under the referenced policy at the time of claim. Drives indemnity exposure calculation for claimants and insured parties.',
    `is_adverse_party` BOOLEAN COMMENT 'Indicates whether this party is an adverse party asserting a competing interest or title defect against the insured. Drives litigation and curative strategy.',
    `is_insured_party` BOOLEAN COMMENT 'Indicates whether this party holds insured status under the referenced title policy (OTP or LTP). Distinguishes insured parties from adverse or third-party participants.',
    `is_primary_claimant` BOOLEAN COMMENT 'Indicates whether this party is the primary claimant on the claim. True for the lead insured asserting the loss; False for co-claimants or other roles.',
    `mailing_address_line1` STRING COMMENT 'First line of the mailing address for this party on the claim file. Used for legal notices and loss-payment correspondence. NPPI — restricted.',
    `mailing_address_line2` STRING COMMENT 'Second line of the mailing address (suite, unit, floor) for this party. Supplements address line 1 for legal notice delivery. NPPI — restricted.',
    `mailing_city` STRING COMMENT 'City of the mailing address for this party. Required for legal notice delivery and state regulatory loss reporting. NPPI — restricted.',
    `mailing_postal_code` STRING COMMENT 'ZIP or ZIP+4 postal code for the partys mailing address. Supports geographic loss analysis and regulatory reporting.. Valid values are `^[0-9]{5}(-[0-9]{4})?$`',
    `mailing_state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the partys mailing address. Used for state DOI regulatory reporting and jurisdictional routing.. Valid values are `^[A-Z]{2}$`',
    `name_alias` STRING COMMENT 'Alternate name, doing-business-as (DBA), or prior legal name for the party. Used in chain-of-title matching and adverse-party identification. NPPI — restricted.',
    `notes` STRING COMMENT 'Free-text adjuster or examiner notes specific to this partys involvement in the claim. Captures context not represented in structured fields.',
    `notice_of_claim_date` DATE COMMENT 'Date on which this party provided or received formal notice of the claim (FNOL). Anchors the claim reporting timeline and regulatory notice requirements.',
    `nppi_vault_reference` STRING COMMENT 'Tokenized reference key to the NPPI Vault record holding SSN/TIN, identity document, and signature data for this party. Actual NPPI is never stored in the lakehouse.',
    `party_role` STRING COMMENT 'Contextual role this party holds on the claim. One party may hold multiple simultaneous roles via separate records. [ENUM-REF-CANDIDATE',
    `party_type` STRING COMMENT 'Classification of the party as an individual person, legal organization, government entity, trust, or estate. Drives NPPI handling and legal notice requirements.. Valid values are `individual|organization|government_entity|trust|estate`',
    `power_of_attorney_indicator` BOOLEAN COMMENT 'Indicates whether this party is acting under a power of attorney on behalf of another principal. Triggers additional documentation and identity verification requirements.',
    `recovery_amount` DECIMAL(18,2) COMMENT 'Dollar amount recovered or expected to be recovered from this party via subrogation or contribution. Populated when party_role is subrogation_target.',
    `release_execution_date` DATE COMMENT 'Date on which this party executed a release of claims or satisfaction instrument. Required before final loss payment disbursement and claim closure.',
    `representation_type` STRING COMMENT 'Indicates how the party is represented on the claim: self-represented, through retained counsel, guardian, power of attorney, or trustee.. Valid values are `self_represented|attorney_represented|guardian|power_of_attorney|trustee`',
    `resolution_status` STRING COMMENT 'Current resolution status of this partys involvement in the claim. Tracks progression from open through settlement, release, litigation, or subrogation to closure.',
    `role_effective_date` DATE COMMENT 'Date on which this partys role became effective on the claim. Supports effective-dated role history per VREQ-005 and VREQ-007.',
    `role_end_date` DATE COMMENT 'Date on which this partys role on the claim ended or was superseded. Null if the role is currently active. Enables lifecycle history preservation.',
    `role_status` STRING COMMENT 'Current lifecycle status of this partys role on the claim. Tracks whether the party is actively participating, has withdrawn, or has been substituted.. Valid values are `active|inactive|withdrawn|substituted|deceased`',
    `settlement_agreement_date` DATE COMMENT 'Date on which a settlement agreement was executed with this party. Marks the resolution milestone for loss-payment and claim-closure processing.',
    `source_system_party_ref` STRING COMMENT 'Identifier assigned to this claim-party association in the originating Claims Administration System (e.g., SoftPro, RamQuest). Supports lineage and reconciliation.',
    `subrogation_potential` STRING COMMENT 'Assessment of subrogation or recovery potential against this party. Populated for adverse parties and subrogation targets to support recovery tracking.. Valid values are `none|potential|active|recovered|waived`',
    `tax_id_vault_reference` STRING COMMENT 'Tokenized reference key to the NPPI Vault for this partys TIN or SSN. Required for IRS 1099-S reporting on loss payments. Actual TIN/SSN never stored in the lakehouse.',
    `title_risk_cause_code` STRING COMMENT 'NAIC or internal code classifying the title-risk cause of loss for this party (e.g., forged deed, undisclosed lien, survey defect, chain-of-title break). Drives loss-ratio analytics by cause.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this claim-party association record was last modified. Supports change-data-capture and audit trail requirements.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_claim_party PRIMARY KEY(`claim_party_id`)
) COMMENT 'Association entity linking a party to a title claim in a specific contextual role (claimant, insured_owner, insured_lender, adverse_party, defense_counsel, plaintiff_counsel, expert_witness, adjuster, examiner, subrogation_target), with role effective';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` (
    `regulatory_loss_report_id` BIGINT COMMENT 'Unique surrogate identifier for each regulatory loss report record submitted to NAIC or state Department of Insurance.',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Regulatory reports aggregate losses by county FIPS and property characteristics for NAIC statutory reporting.',
    `superseded_report_id` BIGINT COMMENT 'Reference to the prior regulatory_loss_report record that this amended or corrected filing supersedes, preserving revision history per VREQ-007.',
    `title_claim_id` BIGINT COMMENT 'Reference to the title insurance claim record that is the subject of or contributor to this regulatory loss report entry.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued title insurance policy (OTP or LTP) associated with the reported loss, linking claim to coverage.',
    `acceptance_date` DATE COMMENT 'Calendar date on which the NAIC or state DOI formally accepted this regulatory loss report filing, per VREQ-008 date field separation.',
    `actuarial_opinion_date` DATE COMMENT 'Date on which the qualified actuary signed and certified the actuarial opinion accompanying this regulatory loss report, if applicable.',
    `actuary_certification_flag` BOOLEAN COMMENT 'Indicates whether this regulatory loss report includes a certified actuarial opinion, required for IBNR actuarial filings and certain state DOI submissions.',
    `amendment_number` BIGINT COMMENT 'Sequential amendment version number for this report filing. Zero (0) indicates the original submission; increments with each amendment or correction filed.',
    `average_claim_severity_amt` DECIMAL(18,2) COMMENT 'Average indemnity payment per closed claim with payment during the reporting period for this jurisdiction and policy type, in USD, used for actuarial severity analysis.',
    `case_reserve_amt` DECIMAL(18,2) COMMENT 'Total case reserves held for known open claims as of the reporting period end date for this jurisdiction and policy type, in USD.',
    `claim_count_closed` BIGINT COMMENT 'Number of claims closed during the reporting period for this jurisdiction and policy type, including closures with and without payment.',
    `claim_count_open_end` BIGINT COMMENT 'Number of claims remaining open as of the reporting period end date for this jurisdiction and policy type, used for reserve adequacy analysis.',
    `claim_count_reported` BIGINT COMMENT 'Number of new claims reported (FNOL) during the reporting period for this jurisdiction and policy type combination, per NAIC Schedule T requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this regulatory loss report record was first created in the claims administration system, in ISO 8601 format with timezone offset.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this report record. Typically USD for U.S. title insurance regulatory filings.. Valid values are `^[A-Z]{3}$`',
    `direct_losses_paid_amt` DECIMAL(18,2) COMMENT 'Total indemnity and loss payments made to claimants during the reporting period for this jurisdiction, in USD, net of recoveries.',
    `direct_premiums_written_amt` DECIMAL(18,2) COMMENT 'Total direct title insurance premiums written during the reporting period for this jurisdiction, in USD, as reported on NAIC Schedule T.',
    `effective_date` DATE COMMENT 'Date on which the data in this regulatory loss report is considered effective for regulatory purposes, per VREQ-008 date field separation.',
    `filing_confirmation_number` STRING COMMENT 'Confirmation or acknowledgment number assigned by the NAIC or state DOI system upon receipt of the electronic or portal submission.',
    `filing_method` STRING COMMENT 'Method used to submit this regulatory loss report to the regulator: ELECTRONIC (NAIC SERFF/iSite+), PAPER, or state-specific PORTAL.. Valid values are `ELECTRONIC|PAPER|PORTAL`',
    `ibnr_reserve_amt` DECIMAL(18,2) COMMENT 'Actuarially estimated reserve for claims incurred but not yet reported (IBNR) as of the reporting period end date, in USD, per actuarial filing requirements.',
    `jurisdiction_state_fips` STRING COMMENT 'Two-digit FIPS code identifying the U.S. state or territory to which this regulatory loss report is submitted, per NAIC Schedule T geographic breakdown.. Valid values are `^[0-9]{2}$`',
    `jurisdiction_state_name` STRING COMMENT 'Full name of the U.S. state or territory corresponding to the jurisdiction FIPS code, for display and reporting purposes.',
    `loss_adjustment_expense_amt` DECIMAL(18,2) COMMENT 'Total allocated and unallocated loss adjustment expenses incurred during the reporting period, including investigation, legal, and curative costs, in USD.',
    `loss_ratio` DECIMAL(10,6) COMMENT 'Ratio of net incurred losses to direct premiums written for the reporting period and jurisdiction, expressed as a decimal (e.g., 0.045 = 4.5%), a key regulatory metric.',
    `naic_company_code` STRING COMMENT 'Five-digit NAIC-assigned company code identifying the title insurance underwriter entity filing this regulatory loss report.. Valid values are `^[0-9]{5}$`',
    `net_losses_amt` DECIMAL(18,2) COMMENT 'Total incurred losses minus recovery and subrogation amounts for the reporting period, representing the net loss retained by the underwriter, in USD.',
    `policy_liability_amt` DECIMAL(18,2) COMMENT 'Total face amount of insurance liability (policy amount) across all policies contributing to this report row, representing aggregate exposure, in USD.',
    `policy_type` STRING COMMENT 'Type of title insurance policy associated with the reported loss: OWNER (OTP), LENDER/Loan (LTP), or Closing Protection Letter (CPL).. Valid values are `OWNER|LENDER|CPL`',
    `preparer_name` STRING COMMENT 'Full name of the individual responsible for preparing and certifying this regulatory loss report filing on behalf of the title insurance company.',
    `preparer_title` STRING COMMENT 'Job title or designation of the individual who prepared this regulatory loss report (e.g., Chief Actuary, VP Claims, Compliance Officer).',
    `production_channel` STRING COMMENT 'Channel through which the underlying title order was produced: DIRECT_BRANCH, CENTRALIZED_LENDER, or INDEPENDENT_AGENT, for loss attribution by channel.. Valid values are `DIRECT_BRANCH|CENTRALIZED_LENDER|INDEPENDENT_AGENT`',
    `recovery_subrogation_amt` DECIMAL(18,2) COMMENT 'Total amounts recovered through subrogation, salvage, or other recovery actions during the reporting period, reducing net loss exposure, in USD.',
    `regulatory_notes` STRING COMMENT 'Free-text notes or explanatory comments accompanying this regulatory loss report, including disclosures, methodology changes, or regulator correspondence summaries.',
    `rejection_reason` STRING COMMENT 'Narrative reason provided by the NAIC or state DOI for rejecting this regulatory loss report filing, populated when report_status is REJECTED.',
    `report_number` STRING COMMENT 'Externally assigned or internally generated unique report identifier used in regulatory submissions and correspondence with NAIC or state DOI.',
    `report_status` STRING COMMENT 'Current lifecycle state of the regulatory loss report: DRAFT (in preparation), SUBMITTED (filed), ACCEPTED, REJECTED, AMENDED, or SUPERSEDED by a later filing.. Valid values are `DRAFT|SUBMITTED|ACCEPTED|REJECTED|AMENDED|SUPERSEDED`',
    `report_type` STRING COMMENT 'Classification of the regulatory filing: NAIC Annual Statement Schedule T, state DOI loss run, IBNR actuarial filing, quarterly loss report, or supplemental. [ENUM-REF-CANDIDATE: promote if values expand]. Valid values are `NAIC_SCHEDULE_T|STATE_DOI_LOSS_RUN|IBNR_ACTUARIAL|QUARTERLY_LOSS|SUPPLEMENTAL`',
    `reporting_period_end_date` DATE COMMENT 'Last calendar date of the reporting period covered by this regulatory loss report (e.g., December 31 of the statement year).',
    `reporting_period_start_date` DATE COMMENT 'First calendar date of the reporting period covered by this regulatory loss report (e.g., January 1 of the statement year).',
    `resubmission_due_date` DATE COMMENT 'Deadline by which a corrected or amended regulatory loss report must be resubmitted following a rejection, as specified by the regulator.',
    `statement_year` BIGINT COMMENT 'Four-digit calendar year of the NAIC Annual Statement or state DOI filing to which this loss report belongs (e.g., 2024).',
    `submission_date` DATE COMMENT 'Calendar date on which this regulatory loss report was submitted to the NAIC or state Department of Insurance, per VREQ-008 date field separation.',
    `title_risk_cause_code` STRING COMMENT 'Standardized code classifying the root cause of the title loss (e.g., undisclosed lien, chain-of-title break, forgery, encroachment, tax lien, mechanics lien). [ENUM-REF-CANDIDATE: promote to reference product]',
    `title_risk_cause_description` STRING COMMENT 'Narrative description of the title defect or risk cause underlying the reported loss, supplementing the structured cause code for regulatory and actuarial review.',
    `total_incurred_losses_amt` DECIMAL(18,2) COMMENT 'Sum of losses paid plus change in case and IBNR reserves for the reporting period, representing total loss exposure incurred, in USD.',
    `transaction_type` STRING COMMENT 'Real estate transaction type underlying the insured policy: PURCHASE, REFINANCE (REFI), HOME_EQUITY (HELOC), CONSTRUCTION, or COMMERCIAL.. Valid values are `PURCHASE|REFINANCE|HOME_EQUITY|CONSTRUCTION|COMMERCIAL`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this regulatory loss report record in the claims administration system, in ISO 8601 format with timezone offset.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_regulatory_loss_report PRIMARY KEY(`regulatory_loss_report_id`)
) COMMENT 'Periodic regulatory loss-reporting record submitted to NAIC and state Departments of Insurance, capturing reporting period, jurisdiction (state FIPS), report type (NAIC Annual Statement Schedule T, state DOI loss run, IBNR actuarial filing), total claims';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` (
    `coverage_decision_id` BIGINT COMMENT 'Unique surrogate identifier for the coverage decision record. Primary key for the coverage_decision entity within the Claims Administration System.',
    `coverage_approving_authority_party_id` BIGINT COMMENT 'Reference to the supervisor, underwriting manager, or counsel who approved the coverage decision, required when the decision exceeds delegated authority thresholds.',
    `coverage_party_id` BIGINT COMMENT 'Reference to the claims examiner or underwriting counsel who authored and issued the coverage determination. Primary party responsible for the decision.',
    `curative_action_id` BIGINT COMMENT 'Reference to the claim curative action record initiated as part of or in lieu of indemnity payment for this coverage decision.',
    `investigation_id` BIGINT COMMENT 'Reference to the claim investigation that produced the factual and legal basis for this coverage determination.',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Coverage decisions cite Schedule A legal descriptions and exceptions tied to specific parcels.',
    `prior_decision_coverage_decision_id` BIGINT COMMENT 'Reference to the preceding coverage decision record that this record revises or supersedes. Supports lifecycle history and revision chain tracking per VREQ-007.',
    `recorded_instrument_id` BIGINT COMMENT 'Foreign key linking to recording.recorded_instrument. Business justification: Coverage decisions reference specific recorded instruments to determine whether defect falls within Schedule B exceptions or covered risks.',
    `title_claim_id` BIGINT COMMENT 'Reference to the parent title insurance claim for which this coverage determination was made. Links the decision to the full claim lifecycle record.',
    `title_commitment_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_commitment. Business justification: Coverage counsel analyzes the commitment to verify whether the loss cause was excepted in Schedule B, required to be satisfied, or covered.',
    `title_finding_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_finding. Business justification: Coverage analysis traces the claimed defect back to the original title finding to determine if it was disclosed, cured, or excepted.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued title insurance policy (OTP or LTP) under which coverage is being evaluated. Anchors the decision to the insuring instrument.',
    `underwriting_title_examination_id` BIGINT COMMENT 'Foreign key linking to underwriting.underwriting_title_examination. Business justification: Coverage counsel reviews the examination to assess whether the defect was discoverable, whether the examiner exercised due care, and whether the examination scope',
    `uw_referral_id` BIGINT COMMENT 'Reference to the underwriting referral record when uw_referral_required_flag is true. Links the coverage decision to the formal UW opinion.',
    `appeal_deadline_date` DATE COMMENT 'The date by which the claimant must file an appeal or request reconsideration of the coverage decision, per policy terms and state regulatory requirements.',
    `appeal_received_date` DATE COMMENT 'Date on which a formal appeal or reconsideration request was received from the claimant or their counsel following issuance of the coverage decision.',
    `chain_of_title_break_flag` BOOLEAN COMMENT 'Indicates whether a break in the chain of title (COT) is the root cause of the covered or denied loss, supporting title-specific defect analytics.',
    `coverage_analysis_narrative` STRING COMMENT 'Full text of the coverage analysis explaining the legal and factual basis for the coverage position, including policy provisions, exclusions, and exceptions applied.',
    `coverage_position` STRING COMMENT 'Formal coverage determination outcome: covered (full indemnity), denied (no coverage), partial (limited coverage), reservation_of_rights (coverage not yet confirmed), or excess_only.. Valid values are `covered|denied|partial|reservation_of_rights|excess_only`',
    `covered_loss_amount` DECIMAL(18,2) COMMENT 'The dollar amount of the claimed loss determined to be covered under the policy. May be less than the claimed loss amount for partial coverage decisions.',
    `covered_risk_number` STRING COMMENT 'ALTA policy covered risk number (e.g., Covered Risk 1, 8, 11) that affirmatively supports coverage for the claimed loss, cited in the coverage analysis.',
    `curative_resolution_required_flag` BOOLEAN COMMENT 'Indicates whether the coverage decision is conditioned on or accompanied by a curative action to resolve the underlying title defect before or after indemnity.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this coverage decision record. Defaults to USD for domestic U.S. title transactions.. Valid values are `^[A-Z]{3}$`',
    `decision_date` DATE COMMENT 'Calendar date on which the formal coverage position was determined and documented by the claims examiner or underwriting counsel.',
    `decision_number` STRING COMMENT 'Externally-visible alphanumeric identifier assigned to this coverage decision by the Claims Administration System. Used in correspondence and regulatory reporting.. Valid values are `^CD-[0-9]{4}-[0-9]{6}$`',
    `decision_status` STRING COMMENT 'Current lifecycle state of the coverage decision. Tracks progression from initial draft through issuance, any appeal or revision, and final disposition.. Valid values are `draft|issued|appealed|revised|withdrawn|final`',
    `decision_timestamp` TIMESTAMP COMMENT 'Precise date and time the coverage decision record was created in the Claims Administration System. Supports audit trail and SLA measurement.',
    `decision_type` STRING COMMENT 'Classifies the decision as initial (first determination), supplemental (additional coverage analysis), revised (updated position), or final (closing determination).. Valid values are `initial|supplemental|revised|final`',
    `denial_reason_code` STRING COMMENT 'Standardized code identifying the primary reason for a coverage denial or limitation (e.g., known_defect, policy_exclusion, schedule_b_exception, no_insured_loss).',
    `denial_reason_description` STRING COMMENT 'Free-text explanation of the denial reason, supplementing the denial_reason_code with specific facts and policy language supporting the denial.',
    `denied_loss_amount` DECIMAL(18,2) COMMENT 'The dollar amount of the claimed loss determined not to be covered under the policy. Supports partial coverage and denial analytics.',
    `endorsement_applicability_flag` BOOLEAN COMMENT 'Indicates whether one or more ALTA endorsements attached to the policy affect the scope of coverage for this claim (e.g., ALTA 9, ALTA 8.1, ALTA 22).',
    `endorsement_references` STRING COMMENT 'Comma-separated list of ALTA endorsement numbers (e.g., ALTA 9, ALTA 8.1) that expand or restrict coverage and are cited in this coverage determination.',
    `exception_item_reference` STRING COMMENT 'Specific Schedule B-II exception item number or description from the issued policy that limits or bars coverage for the claimed loss.',
    `excess_amount` DECIMAL(18,2) COMMENT 'For excess_only coverage positions, the dollar amount of loss that falls above the primary coverage layer and is subject to excess policy terms.',
    `exclusion_number` STRING COMMENT 'Specific exclusion number from the ALTA policy form (e.g., Exclusion 3(a), Exclusion 5) cited as the basis for a denial or limitation of coverage.',
    `gap_coverage_flag` BOOLEAN COMMENT 'Indicates whether the claim arises from a gap period between the effective date of the title search and the recording of the insured instrument.',
    `issued_timestamp` TIMESTAMP COMMENT 'Date and time the coverage decision was formally communicated to the claimant or their counsel. Distinct from the internal decision date.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time the coverage decision record was most recently modified. Supports change tracking and audit compliance.',
    `litigation_flag` BOOLEAN COMMENT 'Indicates whether the coverage decision is associated with active or anticipated litigation, triggering legal hold and outside counsel engagement protocols.',
    `outside_counsel_engaged_flag` BOOLEAN COMMENT 'Indicates whether outside legal counsel has been retained to support the coverage analysis, defense, or curative resolution associated with this decision.',
    `partial_coverage_description` STRING COMMENT 'Narrative describing the scope and limitations of partial coverage when coverage_position is partial, specifying what is and is not covered.',
    `policy_liability_amount` DECIMAL(18,2) COMMENT 'The face amount of insurance coverage under the policy at the time of the coverage decision. Establishes the maximum indemnity ceiling for this claim.',
    `policy_type` STRING COMMENT 'Indicates whether the policy under review is an Owners Title Policy (OTP) or a Loan/Lenders Title Policy (LTP), per ALTA policy form classification.. Valid values are `OTP|LTP`',
    `prompt_pay_compliant_flag` BOOLEAN COMMENT 'Indicates whether the coverage decision was issued within the state-mandated prompt-pay deadline. Supports regulatory compliance monitoring and DOI reporting.',
    `regulatory_prompt_pay_deadline` DATE COMMENT 'State-mandated deadline by which the insurer must issue a coverage decision or payment following receipt of a complete proof of loss, per state prompt-pay statutes.',
    `revision_reason` STRING COMMENT 'Explanation of why this coverage decision was revised from the prior version, such as new evidence, appeal outcome, or change in legal interpretation.',
    `revision_sequence` BIGINT COMMENT 'Sequential integer indicating the revision number of this coverage decision for the associated claim. Value 1 = initial decision; increments with each revision.',
    `ror_basis_description` STRING COMMENT 'Explanation of the legal and factual basis for issuing a reservation of rights letter when coverage_position is reservation_of_rights, pending further investigation.',
    `schedule_a_reference` STRING COMMENT 'Citation to the Schedule A provision of the title policy (insured estate, vesting, legal description) relied upon in the coverage analysis.',
    `schedule_b_section` STRING COMMENT 'Identifies which Schedule B section is implicated: B-I (Requirements), B-II (Exceptions), both, or none. Drives the legal basis for denial or limitation.. Valid values are `B-I|B-II|both|none`',
    `state_code` STRING COMMENT 'Two-letter USPS state code for the jurisdiction governing the policy and coverage decision. Determines applicable state DOI regulations and reporting requirements.. Valid values are `^[A-Z]{2}$`',
    `title_risk_cause_code` STRING COMMENT 'Standardized code classifying the root title defect or risk giving rise to the claim (e.g., forgery, undisclosed lien, chain-of-title break, encroachment). Used for loss ratio analytics.',
    `uw_referral_required_flag` BOOLEAN COMMENT 'Indicates whether this coverage decision required escalation to the underwriting department for a formal underwriting opinion before the position could be issued.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_coverage_decision PRIMARY KEY(`coverage_decision_id`)
) COMMENT 'First-class coverage determination record for a title claim, capturing the formal coverage position (covered, denied, partial, reservation_of_rights, excess_only), the policy provision or exclusion relied upon (Schedule A/B reference, exclusion number';

-- ========= FOREIGN KEYS =========
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ADD CONSTRAINT `fk_claim_event_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ADD CONSTRAINT `fk_claim_reserve_prior_reserve_id` FOREIGN KEY (`prior_reserve_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve`(`reserve_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ADD CONSTRAINT `fk_claim_reserve_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_prior_payment_loss_payment_id` FOREIGN KEY (`prior_payment_loss_payment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment`(`loss_payment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_recovery_receipt_id` FOREIGN KEY (`recovery_receipt_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt`(`recovery_receipt_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ADD CONSTRAINT `fk_claim_recovery_receipt_reversed_receipt_recovery_receipt_id` FOREIGN KEY (`reversed_receipt_recovery_receipt_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt`(`recovery_receipt_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ADD CONSTRAINT `fk_claim_recovery_receipt_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_prior_version_action_id` FOREIGN KEY (`prior_version_action_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action`(`claim_curative_action_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ADD CONSTRAINT `fk_claim_claim_party_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ADD CONSTRAINT `fk_claim_regulatory_loss_report_superseded_report_id` FOREIGN KEY (`superseded_report_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report`(`regulatory_loss_report_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ADD CONSTRAINT `fk_claim_regulatory_loss_report_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_investigation_id` FOREIGN KEY (`investigation_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation`(`investigation_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_prior_decision_coverage_decision_id` FOREIGN KEY (`prior_decision_coverage_decision_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision`(`coverage_decision_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);

-- ========= TAGS =========
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_claim` SET TAGS ('title_division' = 'business');
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_claim` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` SET TAGS ('title_subdomain' = 'claim_administration');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Title Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Independent Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `title_assigned_counsel_party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Counsel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `title_claimant_party_id` SET TAGS ('title_business_glossary_term' = 'Claimant Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `title_party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Examiner ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `underwriting_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `case_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Case Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `case_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `case_reserve_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `chain_of_title_break_flag` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `claim_number` SET TAGS ('title_business_glossary_term' = 'Claim Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `claim_number` SET TAGS ('title_value_regex' = '^CLM-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `claim_status` SET TAGS ('title_business_glossary_term' = 'Claim Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `claim_type` SET TAGS ('title_business_glossary_term' = 'Claim Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `claimed_loss_amount` SET TAGS ('title_business_glossary_term' = 'Claimed Loss Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `claimed_loss_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `claimed_loss_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `closure_date` SET TAGS ('title_business_glossary_term' = 'Claim Closure Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `closure_reason` SET TAGS ('title_business_glossary_term' = 'Claim Closure Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `closure_reason` SET TAGS ('title_value_regex' = 'paid|curative|denied|withdrawn|no_coverage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `coverage_analysis_outcome` SET TAGS ('title_business_glossary_term' = 'Coverage Analysis Outcome');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `coverage_analysis_outcome` SET TAGS ('title_value_regex' = 'covered|partially_covered|denied|pending');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `coverage_denial_reason` SET TAGS ('title_business_glossary_term' = 'Coverage Denial Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `curative_action_description` SET TAGS ('title_business_glossary_term' = 'Curative Action Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `curative_resolution_flag` SET TAGS ('title_business_glossary_term' = 'Curative Resolution Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `expense_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Expense Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `expense_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `expense_reserve_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `fnol_date` SET TAGS ('title_business_glossary_term' = 'First Notice of Loss (FNOL) Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `fnol_received_timestamp` SET TAGS ('title_business_glossary_term' = 'First Notice of Loss (FNOL) Received Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `gap_coverage_flag` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `insured_amount` SET TAGS ('title_business_glossary_term' = 'Insured Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `insured_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `insured_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `investigation_close_date` SET TAGS ('title_business_glossary_term' = 'Investigation Close Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `investigation_start_date` SET TAGS ('title_business_glossary_term' = 'Investigation Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `investigation_status` SET TAGS ('title_business_glossary_term' = 'Investigation Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `investigation_status` SET TAGS ('title_value_regex' = 'not_started|in_progress|completed|on_hold');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `litigation_flag` SET TAGS ('title_business_glossary_term' = 'Litigation Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `loss_date` SET TAGS ('title_business_glossary_term' = 'Loss Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `loss_description` SET TAGS ('title_business_glossary_term' = 'Loss Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'owner|lender');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `producing_channel` SET TAGS ('title_business_glossary_term' = 'Producing Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `producing_channel` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `recovery_amount` SET TAGS ('title_business_glossary_term' = 'Recovery Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `recovery_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `recovery_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `regulatory_report_flag` SET TAGS ('title_business_glossary_term' = 'Regulatory Report Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `reopen_count` SET TAGS ('title_business_glossary_term' = 'Claim Reopen Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `reserve_last_updated_date` SET TAGS ('title_business_glossary_term' = 'Reserve Last Updated Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `settlement_date` SET TAGS ('title_business_glossary_term' = 'Claim Settlement Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `subrogation_flag` SET TAGS ('title_business_glossary_term' = 'Subrogation Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `subrogation_status` SET TAGS ('title_business_glossary_term' = 'Subrogation Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `subrogation_status` SET TAGS ('title_value_regex' = 'not_applicable|identified|in_pursuit|recovered|closed_no_recovery');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `total_paid_expense_amount` SET TAGS ('title_business_glossary_term' = 'Total Paid Expense Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `total_paid_expense_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `total_paid_expense_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `total_paid_indemnity_amount` SET TAGS ('title_business_glossary_term' = 'Total Paid Indemnity Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `total_paid_indemnity_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `total_paid_indemnity_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|home_equity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` SET TAGS ('title_subdomain' = 'claim_administration');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `event_id` SET TAGS ('title_business_glossary_term' = 'Claim Event ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Independent Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `event_claimant_party_id` SET TAGS ('title_business_glossary_term' = 'Claimant Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `event_party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Claims Examiner ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `claim_number` SET TAGS ('title_business_glossary_term' = 'Claim Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `claim_number` SET TAGS ('title_value_regex' = '^CLM-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `claimed_loss_amount` SET TAGS ('title_business_glossary_term' = 'Claimed Loss Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `claimed_loss_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `coverage_decision` SET TAGS ('title_business_glossary_term' = 'Coverage Decision');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `coverage_decision` SET TAGS ('title_value_regex' = 'covered|denied|partial|pending|reserved');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `coverage_denial_reason` SET TAGS ('title_business_glossary_term' = 'Coverage Denial Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `curative_action_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `curative_action_type` SET TAGS ('title_business_glossary_term' = 'Curative Action Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `curative_resolution_date` SET TAGS ('title_business_glossary_term' = 'Curative Resolution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `event_description` SET TAGS ('title_business_glossary_term' = 'Event Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `event_timestamp` SET TAGS ('title_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `event_type` SET TAGS ('title_business_glossary_term' = 'Claim Event Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `expense_amount` SET TAGS ('title_business_glossary_term' = 'Claim Expense Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `expense_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `fnol_date` SET TAGS ('title_business_glossary_term' = 'First Notice of Loss (FNOL) Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `ibnr_flag` SET TAGS ('title_business_glossary_term' = 'Incurred But Not Reported (IBNR) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `insured_amount` SET TAGS ('title_business_glossary_term' = 'Insured Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `insured_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `investigation_start_date` SET TAGS ('title_business_glossary_term' = 'Investigation Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `loss_date` SET TAGS ('title_business_glossary_term' = 'Loss Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `loss_payment_amount` SET TAGS ('title_business_glossary_term' = 'Loss Payment Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `loss_payment_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `new_claim_status` SET TAGS ('title_business_glossary_term' = 'New Claim Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `policy_effective_date` SET TAGS ('title_business_glossary_term' = 'Policy Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'owner|lender');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `prior_claim_status` SET TAGS ('title_business_glossary_term' = 'Prior Claim Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `prior_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Prior Case Reserve Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `prior_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `production_channel` SET TAGS ('title_business_glossary_term' = 'Production Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `production_channel` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `recovery_amount` SET TAGS ('title_business_glossary_term' = 'Recovery / Subrogation Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `recovery_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `regulatory_report_period` SET TAGS ('title_business_glossary_term' = 'Regulatory Report Period');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `regulatory_report_period` SET TAGS ('title_value_regex' = '^[0-9]{4}-(Q[1-4]|H[12]|FY)$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `reserve_amount` SET TAGS ('title_business_glossary_term' = 'Case Reserve Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `reserve_change_amount` SET TAGS ('title_business_glossary_term' = 'Reserve Change Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `reserve_change_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `sequence` SET TAGS ('title_business_glossary_term' = 'Event Sequence Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `source_reference_code` SET TAGS ('title_business_glossary_term' = 'Event Source Reference ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `subrogation_initiated` SET TAGS ('title_business_glossary_term' = 'Subrogation Initiated Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `subrogation_status` SET TAGS ('title_business_glossary_term' = 'Subrogation Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `subrogation_status` SET TAGS ('title_value_regex' = 'not_applicable|initiated|in_progress|recovered|closed_no_recovery');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `title_risk_cause_description` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|home_equity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Record Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` SET TAGS ('title_subdomain' = 'financial_settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reserve_id` SET TAGS ('title_business_glossary_term' = 'Reserve ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `approved_by_user_party_id` SET TAGS ('title_business_glossary_term' = 'Reserve Approved By User ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `approved_by_user_party_id` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `approved_by_user_party_id` SET TAGS ('title_pii' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Reserve Set By User ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `party_id` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `party_id` SET TAGS ('title_pii' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `prior_reserve_id` SET TAGS ('title_business_glossary_term' = 'Prior Reserve ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `accident_year` SET TAGS ('title_business_glossary_term' = 'Accident Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `actuarial_method_code` SET TAGS ('title_business_glossary_term' = 'Actuarial Method Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `actuarial_method_code` SET TAGS ('title_value_regex' = 'chain_ladder|bornhuetter_ferguson|expected_loss|frequency_severity|judgment');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `adequacy_review_date` SET TAGS ('title_business_glossary_term' = 'Reserve Adequacy Review Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `alae_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Allocated Loss Adjustment Expense (ALAE) Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `alae_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `approval_date` SET TAGS ('title_business_glossary_term' = 'Reserve Approval Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `approval_required` SET TAGS ('title_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `basis` SET TAGS ('title_business_glossary_term' = 'Reserve Basis');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `basis` SET TAGS ('title_value_regex' = 'initial|revised|final');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `case_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Case Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `case_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `curative_action_pending` SET TAGS ('title_business_glossary_term' = 'Curative Action Pending Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `curative_resolution_date` SET TAGS ('title_business_glossary_term' = 'Curative Resolution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Reserve Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Reserve Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `ibnr_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Incurred But Not Reported (IBNR) Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `ibnr_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `large_loss_flag` SET TAGS ('title_business_glossary_term' = 'Large Loss Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `large_loss_threshold_amount` SET TAGS ('title_business_glossary_term' = 'Large Loss Threshold Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `large_loss_threshold_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `litigation_flag` SET TAGS ('title_business_glossary_term' = 'Litigation Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `loss_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Loss Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `loss_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `net_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Net Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `net_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `policy_liability_amount` SET TAGS ('title_business_glossary_term' = 'Policy Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `policy_liability_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'owner|lender');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `policy_year` SET TAGS ('title_business_glossary_term' = 'Policy Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reinsurance_recoverable_amount` SET TAGS ('title_business_glossary_term' = 'Reinsurance Recoverable Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reinsurance_recoverable_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reporting_period_quarter` SET TAGS ('title_business_glossary_term' = 'Reporting Period Quarter');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reporting_period_year` SET TAGS ('title_business_glossary_term' = 'Reporting Period Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reserve_number` SET TAGS ('title_business_glossary_term' = 'Reserve Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reserve_number` SET TAGS ('title_value_regex' = '^RES-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reserve_status` SET TAGS ('title_business_glossary_term' = 'Reserve Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reserve_status` SET TAGS ('title_value_regex' = 'open|revised|closed|reinstated|voided');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reserve_type` SET TAGS ('title_business_glossary_term' = 'Reserve Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `reserve_type` SET TAGS ('title_value_regex' = 'case|ibnr|bulk|salvage|subrogation|unallocated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `revision_notes` SET TAGS ('title_business_glossary_term' = 'Reserve Revision Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `revision_reason_code` SET TAGS ('title_business_glossary_term' = 'Reserve Revision Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `revision_sequence` SET TAGS ('title_business_glossary_term' = 'Reserve Revision Sequence Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `set_by_role` SET TAGS ('title_business_glossary_term' = 'Reserve Set By Role');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `set_by_role` SET TAGS ('title_value_regex' = 'claims_examiner|underwriter|actuary|supervisor|system');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `set_date` SET TAGS ('title_business_glossary_term' = 'Reserve Set Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `subrogation_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Subrogation Recovery Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `subrogation_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `title_risk_cause_description` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `to_liability_pct` SET TAGS ('title_business_glossary_term' = 'Reserve to Policy Liability Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|home_equity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` SET TAGS ('title_subdomain' = 'financial_settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `loss_payment_id` SET TAGS ('title_business_glossary_term' = 'Loss Payment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `curative_action_id` SET TAGS ('title_business_glossary_term' = 'Curative Action ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `disbursement_id` SET TAGS ('title_business_glossary_term' = 'Disbursement Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `loss_party_id` SET TAGS ('title_business_glossary_term' = 'Approver Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `loss_payee_party_id` SET TAGS ('title_business_glossary_term' = 'Payee Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `prior_payment_loss_payment_id` SET TAGS ('title_business_glossary_term' = 'Prior Loss Payment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `recovery_receipt_id` SET TAGS ('title_business_glossary_term' = 'Recovery ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `approval_authority_level` SET TAGS ('title_business_glossary_term' = 'Approval Authority Level');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `approval_authority_level` SET TAGS ('title_value_regex' = 'examiner|supervisor|manager|vp|executive');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `approval_date` SET TAGS ('title_business_glossary_term' = 'Payment Approval Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `approved_amount` SET TAGS ('title_business_glossary_term' = 'Approved Payment Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `approved_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `approved_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `bank_account_ref` SET TAGS ('title_business_glossary_term' = 'Bank Account Reference (Tokenized)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `bank_account_ref` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `bank_account_ref` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Production Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `claim_number` SET TAGS ('title_business_glossary_term' = 'Claim Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `cleared_date` SET TAGS ('title_business_glossary_term' = 'Payment Cleared Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `cost_center_code` SET TAGS ('title_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `cumulative_paid_amount` SET TAGS ('title_business_glossary_term' = 'Cumulative Paid Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `cumulative_paid_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `cumulative_paid_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `gl_account_code` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `irs_1099_required` SET TAGS ('title_business_glossary_term' = 'IRS Form 1099 Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `is_final_payment` SET TAGS ('title_business_glossary_term' = 'Final Payment Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `naic_loss_cause_code` SET TAGS ('title_business_glossary_term' = 'National Association of Insurance Commissioners (NAIC) Loss Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payee_name` SET TAGS ('title_business_glossary_term' = 'Payee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payee_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payee_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payee_type` SET TAGS ('title_business_glossary_term' = 'Payee Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payee_type` SET TAGS ('title_value_regex' = 'claimant|lender|attorney|curative_vendor|court|insured');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_amount` SET TAGS ('title_business_glossary_term' = 'Loss Payment Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_date` SET TAGS ('title_business_glossary_term' = 'Loss Payment Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_method` SET TAGS ('title_business_glossary_term' = 'Loss Payment Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_method` SET TAGS ('title_value_regex' = 'wire|check|ach|escrow_disbursement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_notes` SET TAGS ('title_business_glossary_term' = 'Loss Payment Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_number` SET TAGS ('title_business_glossary_term' = 'Loss Payment Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_number` SET TAGS ('title_value_regex' = '^LP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_reference_number` SET TAGS ('title_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_status` SET TAGS ('title_business_glossary_term' = 'Loss Payment Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_status` SET TAGS ('title_value_regex' = 'pending|approved|issued|cleared|voided|returned');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_type` SET TAGS ('title_business_glossary_term' = 'Loss Payment Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `payment_type` SET TAGS ('title_value_regex' = 'indemnity|curative_cost|defense_cost|settlement|court_ordered');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `policy_liability_limit` SET TAGS ('title_business_glossary_term' = 'Policy Liability Limit');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `policy_liability_limit` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `policy_liability_limit` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `policy_number` SET TAGS ('title_business_glossary_term' = 'Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type (Owners Title Policy / Loan Title Policy)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'OTP|LTP');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `reserve_release_amount` SET TAGS ('title_business_glossary_term' = 'Reserve Release Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `reserve_release_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `reserve_release_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code (USPS Two-Letter)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `subrogation_flag` SET TAGS ('title_business_glossary_term' = 'Subrogation Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `tax_withholding_amount` SET TAGS ('title_business_glossary_term' = 'Tax Withholding Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `tax_withholding_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `tax_withholding_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `title_risk_cause_description` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `void_date` SET TAGS ('title_business_glossary_term' = 'Payment Void Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `wire_instruction_ref` SET TAGS ('title_business_glossary_term' = 'Wire Instruction Reference (Tokenized)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `wire_instruction_ref` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `wire_instruction_ref` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` SET TAGS ('title_subdomain' = 'financial_settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_receipt_id` SET TAGS ('title_business_glossary_term' = 'Recovery Receipt ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Claims Examiner ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_counsel_party_id` SET TAGS ('title_business_glossary_term' = 'Recovery Counsel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_source_party_id` SET TAGS ('title_business_glossary_term' = 'Recovery Source Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `reversed_receipt_recovery_receipt_id` SET TAGS ('title_business_glossary_term' = 'Reversed Recovery Receipt ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `agent_recovery_share_amount` SET TAGS ('title_business_glossary_term' = 'Agent Recovery Share Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `agent_recovery_share_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `agent_recovery_share_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `applied_to_loss_amount` SET TAGS ('title_business_glossary_term' = 'Amount Applied to Loss');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `applied_to_loss_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `applied_to_loss_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `bank_reference_number` SET TAGS ('title_business_glossary_term' = 'Bank Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `bank_reference_number` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `bank_reference_number` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `check_number` SET TAGS ('title_business_glossary_term' = 'Recovery Check Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `check_number` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `check_number` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `expected_recovery_amount` SET TAGS ('title_business_glossary_term' = 'Expected Recovery Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `expected_recovery_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `expected_recovery_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `expense_recovery_amount` SET TAGS ('title_business_glossary_term' = 'Expense Recovery Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `expense_recovery_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `expense_recovery_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `gl_account_code` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `gl_posting_date` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Posting Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `is_final_receipt` SET TAGS ('title_business_glossary_term' = 'Final Recovery Receipt Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `is_full_recovery` SET TAGS ('title_business_glossary_term' = 'Full Recovery Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `naic_recovery_code` SET TAGS ('title_business_glossary_term' = 'NAIC Recovery Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `net_recovery_amount` SET TAGS ('title_business_glossary_term' = 'Net Recovery Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `net_recovery_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `net_recovery_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `payor_tax_identifier` SET TAGS ('title_business_glossary_term' = 'Payor Tax Identification Number (TIN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `payor_tax_identifier` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `payor_tax_identifier` SET TAGS ('title_pii_identifier' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Title Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'owner|lender');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `receipt_date` SET TAGS ('title_business_glossary_term' = 'Recovery Receipt Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `receipt_number` SET TAGS ('title_business_glossary_term' = 'Recovery Receipt Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `receipt_number` SET TAGS ('title_value_regex' = '^RR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_amount` SET TAGS ('title_business_glossary_term' = 'Recovery Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_expense_amount` SET TAGS ('title_business_glossary_term' = 'Recovery Expense Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_expense_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_expense_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_method` SET TAGS ('title_business_glossary_term' = 'Recovery Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_method` SET TAGS ('title_value_regex' = 'wire_transfer|check|ach|offset|court_judgment|settlement_agreement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_notes` SET TAGS ('title_business_glossary_term' = 'Recovery Receipt Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_rate_pct` SET TAGS ('title_business_glossary_term' = 'Recovery Rate Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_source_name` SET TAGS ('title_business_glossary_term' = 'Recovery Source Party Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_source_type` SET TAGS ('title_business_glossary_term' = 'Recovery Source Party Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_status` SET TAGS ('title_business_glossary_term' = 'Recovery Receipt Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_status` SET TAGS ('title_value_regex' = 'pending|received|applied|reversed|written_off');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_type` SET TAGS ('title_business_glossary_term' = 'Recovery Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `recovery_type` SET TAGS ('title_value_regex' = 'subrogation|contribution|salvage|reinsurance_recovery|indemnification|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `reinsurance_treaty_reference` SET TAGS ('title_business_glossary_term' = 'Reinsurance Treaty Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `reserve_reduction_amount` SET TAGS ('title_business_glossary_term' = 'Reserve Reduction Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `reserve_reduction_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `reserve_reduction_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `reversal_indicator` SET TAGS ('title_business_glossary_term' = 'Recovery Receipt Reversal Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `settlement_agreement_date` SET TAGS ('title_business_glossary_term' = 'Recovery Settlement Agreement Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `state_of_recovery` SET TAGS ('title_business_glossary_term' = 'State of Recovery Jurisdiction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `state_of_recovery` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `subrogation_demand_date` SET TAGS ('title_business_glossary_term' = 'Subrogation Demand Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `subrogation_suit_filed_date` SET TAGS ('title_business_glossary_term' = 'Subrogation Suit Filed Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Real Estate Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `underwriter_recovery_share_amount` SET TAGS ('title_business_glossary_term' = 'Underwriter Recovery Share Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `underwriter_recovery_share_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `underwriter_recovery_share_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` SET TAGS ('title_subdomain' = 'claim_administration');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `investigation_id` SET TAGS ('title_business_glossary_term' = 'Investigation ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Independent Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `investigation_assigned_counsel_party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Counsel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `investigation_party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Investigator ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `recorded_instrument_id` SET TAGS ('title_business_glossary_term' = 'Recorded Instrument Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `underwriting_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `agency_involved_flag` SET TAGS ('title_business_glossary_term' = 'Independent Agent Involved Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `chain_of_title_break_flag` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `claimant_name` SET TAGS ('title_business_glossary_term' = 'Claimant Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `claimant_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `claimant_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `completion_date` SET TAGS ('title_business_glossary_term' = 'Investigation Completion Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County FIPS Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `coverage_analysis_narrative` SET TAGS ('title_business_glossary_term' = 'Coverage Analysis Narrative');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `coverage_determination` SET TAGS ('title_business_glossary_term' = 'Coverage Determination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `coverage_determination` SET TAGS ('title_value_regex' = 'covered|not_covered|partial|pending|reserved');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `curative_action_required_flag` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `curative_action_status` SET TAGS ('title_business_glossary_term' = 'Curative Action Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `curative_action_status` SET TAGS ('title_value_regex' = 'not_required|pending|in_progress|complete|failed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `curative_completion_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Completion Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `document_receipt_date` SET TAGS ('title_business_glossary_term' = 'Document Receipt Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `document_request_date` SET TAGS ('title_business_glossary_term' = 'Document Request Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `eo_coverage_flag` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `estimated_loss_amount` SET TAGS ('title_business_glossary_term' = 'Estimated Loss Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `estimated_loss_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `evidence_complete_flag` SET TAGS ('title_business_glossary_term' = 'Evidence Completeness Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `findings_narrative` SET TAGS ('title_business_glossary_term' = 'Investigation Findings Narrative');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `forgery_fraud_flag` SET TAGS ('title_business_glossary_term' = 'Forgery or Fraud Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `insured_name` SET TAGS ('title_business_glossary_term' = 'Insured Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `insured_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `insured_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `investigation_status` SET TAGS ('title_business_glossary_term' = 'Investigation Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `investigation_status` SET TAGS ('title_value_regex' = 'open|pending_docs|pending_legal|complete|closed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `investigation_type` SET TAGS ('title_business_glossary_term' = 'Investigation Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `last_activity_date` SET TAGS ('title_business_glossary_term' = 'Last Activity Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `litigation_flag` SET TAGS ('title_business_glossary_term' = 'Litigation Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `number` SET TAGS ('title_business_glossary_term' = 'Investigation Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `number` SET TAGS ('title_value_regex' = '^INV-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `policy_amount` SET TAGS ('title_business_glossary_term' = 'Policy Amount of Insurance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `policy_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Title Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'OTP|LTP');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `priority` SET TAGS ('title_business_glossary_term' = 'Investigation Priority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `priority` SET TAGS ('title_value_regex' = 'low|medium|high|critical');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `property_address` SET TAGS ('title_business_glossary_term' = 'Property Address');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `property_address` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `property_address` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `recommended_reserve_amount` SET TAGS ('title_business_glossary_term' = 'Recommended Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `recommended_reserve_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `regulatory_reporting_required_flag` SET TAGS ('title_business_glossary_term' = 'Regulatory Reporting Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `start_date` SET TAGS ('title_business_glossary_term' = 'Investigation Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `subrogation_potential_flag` SET TAGS ('title_business_glossary_term' = 'Subrogation Potential Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `subrogation_target_party` SET TAGS ('title_business_glossary_term' = 'Subrogation Target Party');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `target_completion_date` SET TAGS ('title_business_glossary_term' = 'Target Completion Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `underwriter_opinion` SET TAGS ('title_business_glossary_term' = 'Underwriter Coverage Opinion');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `underwriter_opinion` SET TAGS ('title_value_regex' = 'approve|deny|partial|pending|refer_to_counsel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `underwriter_referral_date` SET TAGS ('title_business_glossary_term' = 'Underwriter Referral Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `underwriter_referral_flag` SET TAGS ('title_business_glossary_term' = 'Underwriter Referral Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` SET TAGS ('title_subdomain' = 'claim_administration');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `claim_curative_action_id` SET TAGS ('title_business_glossary_term' = 'Claim Curative Action ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `closing_document_id` SET TAGS ('title_business_glossary_term' = 'Closing Document Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `easement_restriction_id` SET TAGS ('title_business_glossary_term' = 'Easement Restriction Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `encumbrance_id` SET TAGS ('title_business_glossary_term' = 'Encumbrance Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Examiner/Claim Handler ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `prior_version_action_id` SET TAGS ('title_business_glossary_term' = 'Prior Version Curative Action ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `title_requirement_id` SET TAGS ('title_business_glossary_term' = 'Title Requirement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `underwriting_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral ID (UWR ID)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `action_description` SET TAGS ('title_business_glossary_term' = 'Curative Action Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `action_number` SET TAGS ('title_business_glossary_term' = 'Curative Action Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `action_number` SET TAGS ('title_value_regex' = '^CA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `action_status` SET TAGS ('title_business_glossary_term' = 'Curative Action Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `action_status` SET TAGS ('title_value_regex' = 'open|in_progress|pending_recording|resolved|withdrawn|escalated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `action_type` SET TAGS ('title_business_glossary_term' = 'Curative Action Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `action_type` SET TAGS ('title_value_regex' = 'lien_release|deed_correction|quiet_title|probate|affidavit_of_heirship|reconveyance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `actual_cost_amount` SET TAGS ('title_business_glossary_term' = 'Actual Curative Cost Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `actual_cost_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `actual_resolution_date` SET TAGS ('title_business_glossary_term' = 'Actual Resolution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `chain_of_title_break` SET TAGS ('title_business_glossary_term' = 'Chain of Title Break Flag (COT Break)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `cost_currency_code` SET TAGS ('title_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `cost_currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `court_jurisdiction` SET TAGS ('title_business_glossary_term' = 'Court Jurisdiction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `curative_instrument_type` SET TAGS ('title_business_glossary_term' = 'Curative Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `days_open` SET TAGS ('title_business_glossary_term' = 'Days Open');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `defect_type` SET TAGS ('title_business_glossary_term' = 'Title Defect Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `escalation_date` SET TAGS ('title_business_glossary_term' = 'Escalation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `estimated_cost_amount` SET TAGS ('title_business_glossary_term' = 'Estimated Curative Cost Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `estimated_cost_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `evidence_document_ref` SET TAGS ('title_business_glossary_term' = 'Evidence Document Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `gap_cure_required` SET TAGS ('title_business_glossary_term' = 'Gap Cure Required Flag (GAPcure)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `initiated_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Initiated Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `instrument_document_number` SET TAGS ('title_business_glossary_term' = 'Curative Instrument Document Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `instrument_recording_date` SET TAGS ('title_business_glossary_term' = 'Curative Instrument Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `is_current_version` SET TAGS ('title_business_glossary_term' = 'Current Version Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `last_updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `lien_amount` SET TAGS ('title_business_glossary_term' = 'Lien Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `lien_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `litigation_case_number` SET TAGS ('title_business_glossary_term' = 'Litigation Case Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `outside_counsel_engaged` SET TAGS ('title_business_glossary_term' = 'Outside Counsel Engaged Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `outside_counsel_firm_name` SET TAGS ('title_business_glossary_term' = 'Outside Counsel Firm Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `payoff_amount` SET TAGS ('title_business_glossary_term' = 'Lien Payoff Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `payoff_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `priority` SET TAGS ('title_business_glossary_term' = 'Curative Action Priority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `priority` SET TAGS ('title_value_regex' = 'critical|high|medium|low');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `recording_required` SET TAGS ('title_business_glossary_term' = 'Recording Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `recovery_amount` SET TAGS ('title_business_glossary_term' = 'Recovery Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `recovery_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `reserve_impact_amount` SET TAGS ('title_business_glossary_term' = 'Reserve Impact Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `reserve_impact_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `resolution_notes` SET TAGS ('title_business_glossary_term' = 'Resolution Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `subrogation_potential` SET TAGS ('title_business_glossary_term' = 'Subrogation Potential Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `target_resolution_date` SET TAGS ('title_business_glossary_term' = 'Target Resolution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `uw_referral_required` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral Required Flag (UWR)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` SET TAGS ('title_data_type' = 'association_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` SET TAGS ('title_subdomain' = 'claim_administration');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `claim_party_id` SET TAGS ('title_business_glossary_term' = 'Claim Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `approved_loss_amount` SET TAGS ('title_business_glossary_term' = 'Approved Loss Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `approved_loss_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `claimed_loss_amount` SET TAGS ('title_business_glossary_term' = 'Claimed Loss Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `claimed_loss_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `contact_email` SET TAGS ('title_business_glossary_term' = 'Claim Party Contact Email Address');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `contact_email` SET TAGS ('title_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `contact_email` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `contact_email` SET TAGS ('title_pii_email' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `contact_phone` SET TAGS ('title_business_glossary_term' = 'Claim Party Contact Phone Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `contact_phone` SET TAGS ('title_value_regex' = '^+?[0-9-s().]{7,20}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `contact_phone` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `contact_phone` SET TAGS ('title_pii_phone' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `counsel_bar_number` SET TAGS ('title_business_glossary_term' = 'Claim Party Counsel Bar Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `counsel_firm_name` SET TAGS ('title_business_glossary_term' = 'Claim Party Counsel Firm Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `coverage_denial_reason` SET TAGS ('title_business_glossary_term' = 'Coverage Denial Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `coverage_determination` SET TAGS ('title_business_glossary_term' = 'Coverage Determination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `coverage_determination` SET TAGS ('title_value_regex' = 'covered|partially_covered|denied|pending|reserved');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `demand_letter_date` SET TAGS ('title_business_glossary_term' = 'Demand Letter Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `identity_verification_method` SET TAGS ('title_business_glossary_term' = 'Identity Verification Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `identity_verification_method` SET TAGS ('title_value_regex' = 'government_id|notarized_affidavit|knowledge_based_auth|biometric|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `identity_verified_indicator` SET TAGS ('title_business_glossary_term' = 'Identity Verified Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `insured_amount` SET TAGS ('title_business_glossary_term' = 'Claim Party Insured Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `insured_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `is_adverse_party` SET TAGS ('title_business_glossary_term' = 'Adverse Party Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `is_insured_party` SET TAGS ('title_business_glossary_term' = 'Insured Party Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `is_primary_claimant` SET TAGS ('title_business_glossary_term' = 'Primary Claimant Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_address_line1` SET TAGS ('title_business_glossary_term' = 'Claim Party Mailing Address Line 1');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_address_line1` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_address_line1` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_address_line2` SET TAGS ('title_business_glossary_term' = 'Claim Party Mailing Address Line 2');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_address_line2` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_address_line2` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_city` SET TAGS ('title_business_glossary_term' = 'Claim Party Mailing City');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_city` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_city` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_postal_code` SET TAGS ('title_business_glossary_term' = 'Claim Party Mailing Postal Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_postal_code` SET TAGS ('title_value_regex' = '^[0-9]{5}(-[0-9]{4})?$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_postal_code` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_postal_code` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_state_code` SET TAGS ('title_business_glossary_term' = 'Claim Party Mailing State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `mailing_state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `name_alias` SET TAGS ('title_business_glossary_term' = 'Claim Party Alias or DBA Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `name_alias` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `name_alias` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Claim Party Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `notice_of_claim_date` SET TAGS ('title_business_glossary_term' = 'Notice of Claim Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `nppi_vault_reference` SET TAGS ('title_business_glossary_term' = 'Non-Public Personal Information (NPPI) Vault Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `nppi_vault_reference` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `nppi_vault_reference` SET TAGS ('title_pii_identifier' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `party_role` SET TAGS ('title_business_glossary_term' = 'Claim Party Role');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `party_type` SET TAGS ('title_business_glossary_term' = 'Claim Party Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `party_type` SET TAGS ('title_value_regex' = 'individual|organization|government_entity|trust|estate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `power_of_attorney_indicator` SET TAGS ('title_business_glossary_term' = 'Power of Attorney Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `recovery_amount` SET TAGS ('title_business_glossary_term' = 'Subrogation Recovery Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `recovery_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `release_execution_date` SET TAGS ('title_business_glossary_term' = 'Release Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `representation_type` SET TAGS ('title_business_glossary_term' = 'Claim Party Representation Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `representation_type` SET TAGS ('title_value_regex' = 'self_represented|attorney_represented|guardian|power_of_attorney|trustee');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `resolution_status` SET TAGS ('title_business_glossary_term' = 'Claim Party Resolution Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `role_effective_date` SET TAGS ('title_business_glossary_term' = 'Role Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `role_end_date` SET TAGS ('title_business_glossary_term' = 'Role End Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `role_status` SET TAGS ('title_business_glossary_term' = 'Claim Party Role Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `role_status` SET TAGS ('title_value_regex' = 'active|inactive|withdrawn|substituted|deceased');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `settlement_agreement_date` SET TAGS ('title_business_glossary_term' = 'Settlement Agreement Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `source_system_party_ref` SET TAGS ('title_business_glossary_term' = 'Source System Party Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `subrogation_potential` SET TAGS ('title_business_glossary_term' = 'Subrogation Potential Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `subrogation_potential` SET TAGS ('title_value_regex' = 'none|potential|active|recovered|waived');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `tax_id_vault_reference` SET TAGS ('title_business_glossary_term' = 'Tax Identifier (TIN/SSN) Vault Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `tax_id_vault_reference` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `tax_id_vault_reference` SET TAGS ('title_pii_identifier' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` SET TAGS ('title_subdomain' = 'financial_settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `regulatory_loss_report_id` SET TAGS ('title_business_glossary_term' = 'Regulatory Loss Report ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `superseded_report_id` SET TAGS ('title_business_glossary_term' = 'Superseded Regulatory Loss Report ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `actuarial_opinion_date` SET TAGS ('title_business_glossary_term' = 'Actuarial Opinion Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `actuary_certification_flag` SET TAGS ('title_business_glossary_term' = 'Actuary Certification Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `amendment_number` SET TAGS ('title_business_glossary_term' = 'Amendment Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `average_claim_severity_amt` SET TAGS ('title_business_glossary_term' = 'Average Claim Severity Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `case_reserve_amt` SET TAGS ('title_business_glossary_term' = 'Case Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `claim_count_closed` SET TAGS ('title_business_glossary_term' = 'Closed Claim Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `claim_count_open_end` SET TAGS ('title_business_glossary_term' = 'Open Claim Count at Period End');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `claim_count_reported` SET TAGS ('title_business_glossary_term' = 'Reported Claim Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `direct_losses_paid_amt` SET TAGS ('title_business_glossary_term' = 'Direct Losses Paid Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `direct_premiums_written_amt` SET TAGS ('title_business_glossary_term' = 'Direct Premiums Written Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `filing_confirmation_number` SET TAGS ('title_business_glossary_term' = 'Filing Confirmation Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `filing_method` SET TAGS ('title_business_glossary_term' = 'Filing Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `filing_method` SET TAGS ('title_value_regex' = 'ELECTRONIC|PAPER|PORTAL');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `ibnr_reserve_amt` SET TAGS ('title_business_glossary_term' = 'Incurred But Not Reported (IBNR) Reserve Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `jurisdiction_state_fips` SET TAGS ('title_business_glossary_term' = 'Jurisdiction State Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `jurisdiction_state_fips` SET TAGS ('title_value_regex' = '^[0-9]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `jurisdiction_state_name` SET TAGS ('title_business_glossary_term' = 'Jurisdiction State Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `loss_adjustment_expense_amt` SET TAGS ('title_business_glossary_term' = 'Loss Adjustment Expense (LAE) Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `loss_ratio` SET TAGS ('title_business_glossary_term' = 'Loss Ratio');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `naic_company_code` SET TAGS ('title_business_glossary_term' = 'National Association of Insurance Commissioners (NAIC) Company Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `naic_company_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `net_losses_amt` SET TAGS ('title_business_glossary_term' = 'Net Losses Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `policy_liability_amt` SET TAGS ('title_business_glossary_term' = 'Policy Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'OWNER|LENDER|CPL');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `preparer_name` SET TAGS ('title_business_glossary_term' = 'Preparer Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `preparer_title` SET TAGS ('title_business_glossary_term' = 'Preparer Title');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `production_channel` SET TAGS ('title_business_glossary_term' = 'Production Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `production_channel` SET TAGS ('title_value_regex' = 'DIRECT_BRANCH|CENTRALIZED_LENDER|INDEPENDENT_AGENT');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `recovery_subrogation_amt` SET TAGS ('title_business_glossary_term' = 'Recovery and Subrogation Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `regulatory_notes` SET TAGS ('title_business_glossary_term' = 'Regulatory Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `rejection_reason` SET TAGS ('title_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `report_number` SET TAGS ('title_business_glossary_term' = 'Regulatory Loss Report Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `report_status` SET TAGS ('title_business_glossary_term' = 'Regulatory Loss Report Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `report_status` SET TAGS ('title_value_regex' = 'DRAFT|SUBMITTED|ACCEPTED|REJECTED|AMENDED|SUPERSEDED');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `report_type` SET TAGS ('title_business_glossary_term' = 'Regulatory Report Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `report_type` SET TAGS ('title_value_regex' = 'NAIC_SCHEDULE_T|STATE_DOI_LOSS_RUN|IBNR_ACTUARIAL|QUARTERLY_LOSS|SUPPLEMENTAL');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `reporting_period_end_date` SET TAGS ('title_business_glossary_term' = 'Reporting Period End Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `reporting_period_start_date` SET TAGS ('title_business_glossary_term' = 'Reporting Period Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `resubmission_due_date` SET TAGS ('title_business_glossary_term' = 'Resubmission Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `statement_year` SET TAGS ('title_business_glossary_term' = 'Statement Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `title_risk_cause_description` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `total_incurred_losses_amt` SET TAGS ('title_business_glossary_term' = 'Total Incurred Losses Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'PURCHASE|REFINANCE|HOME_EQUITY|CONSTRUCTION|COMMERCIAL');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` SET TAGS ('title_domain' = 'claim');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` SET TAGS ('title_subdomain' = 'financial_settlement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `coverage_decision_id` SET TAGS ('title_business_glossary_term' = 'Coverage Decision ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `coverage_approving_authority_party_id` SET TAGS ('title_business_glossary_term' = 'Approving Authority ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `coverage_party_id` SET TAGS ('title_business_glossary_term' = 'Deciding Examiner ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `curative_action_id` SET TAGS ('title_business_glossary_term' = 'Curative Action ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `investigation_id` SET TAGS ('title_business_glossary_term' = 'Investigation ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `prior_decision_coverage_decision_id` SET TAGS ('title_business_glossary_term' = 'Prior Coverage Decision ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `recorded_instrument_id` SET TAGS ('title_business_glossary_term' = 'Recorded Instrument Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Claim ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `underwriting_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral ID (UWR ID)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `appeal_deadline_date` SET TAGS ('title_business_glossary_term' = 'Coverage Decision Appeal Deadline Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `appeal_received_date` SET TAGS ('title_business_glossary_term' = 'Coverage Decision Appeal Received Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `chain_of_title_break_flag` SET TAGS ('title_business_glossary_term' = 'Chain of Title Break Flag (COT Break)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `coverage_analysis_narrative` SET TAGS ('title_business_glossary_term' = 'Coverage Analysis Narrative');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `coverage_position` SET TAGS ('title_business_glossary_term' = 'Coverage Position');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `coverage_position` SET TAGS ('title_value_regex' = 'covered|denied|partial|reservation_of_rights|excess_only');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `covered_loss_amount` SET TAGS ('title_business_glossary_term' = 'Covered Loss Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `covered_loss_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `covered_risk_number` SET TAGS ('title_business_glossary_term' = 'Covered Risk Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `curative_resolution_required_flag` SET TAGS ('title_business_glossary_term' = 'Curative Resolution Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `decision_date` SET TAGS ('title_business_glossary_term' = 'Coverage Decision Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `decision_number` SET TAGS ('title_business_glossary_term' = 'Coverage Decision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `decision_number` SET TAGS ('title_value_regex' = '^CD-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `decision_status` SET TAGS ('title_business_glossary_term' = 'Coverage Decision Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `decision_status` SET TAGS ('title_value_regex' = 'draft|issued|appealed|revised|withdrawn|final');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `decision_timestamp` SET TAGS ('title_business_glossary_term' = 'Coverage Decision Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `decision_type` SET TAGS ('title_business_glossary_term' = 'Coverage Decision Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `decision_type` SET TAGS ('title_value_regex' = 'initial|supplemental|revised|final');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `denial_reason_code` SET TAGS ('title_business_glossary_term' = 'Coverage Denial Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `denial_reason_description` SET TAGS ('title_business_glossary_term' = 'Coverage Denial Reason Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `denied_loss_amount` SET TAGS ('title_business_glossary_term' = 'Denied Loss Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `denied_loss_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `endorsement_applicability_flag` SET TAGS ('title_business_glossary_term' = 'Endorsement Applicability Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `endorsement_references` SET TAGS ('title_business_glossary_term' = 'Applicable Endorsement References');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `exception_item_reference` SET TAGS ('title_business_glossary_term' = 'Schedule B-II Exception Item Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `excess_amount` SET TAGS ('title_business_glossary_term' = 'Excess Coverage Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `excess_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `exclusion_number` SET TAGS ('title_business_glossary_term' = 'Policy Exclusion Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `gap_coverage_flag` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `issued_timestamp` SET TAGS ('title_business_glossary_term' = 'Decision Issued Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `last_updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `litigation_flag` SET TAGS ('title_business_glossary_term' = 'Litigation Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `outside_counsel_engaged_flag` SET TAGS ('title_business_glossary_term' = 'Outside Counsel Engaged Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `partial_coverage_description` SET TAGS ('title_business_glossary_term' = 'Partial Coverage Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `policy_liability_amount` SET TAGS ('title_business_glossary_term' = 'Policy Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `policy_liability_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'OTP|LTP');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `prompt_pay_compliant_flag` SET TAGS ('title_business_glossary_term' = 'Prompt Pay Compliance Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `regulatory_prompt_pay_deadline` SET TAGS ('title_business_glossary_term' = 'Regulatory Prompt Pay Deadline Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `revision_sequence` SET TAGS ('title_business_glossary_term' = 'Revision Sequence Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `ror_basis_description` SET TAGS ('title_business_glossary_term' = 'Reservation of Rights (ROR) Basis Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `schedule_a_reference` SET TAGS ('title_business_glossary_term' = 'Schedule A Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `schedule_b_section` SET TAGS ('title_business_glossary_term' = 'Schedule B Section');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `schedule_b_section` SET TAGS ('title_value_regex' = 'B-I|B-II|both|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `title_risk_cause_code` SET TAGS ('title_business_glossary_term' = 'Title Risk Cause Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `uw_referral_required_flag` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral Required Flag (UWR)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
