-- Schema for Domain: underwriting | Business: Title_Insurance | Version: v1_mvm
-- Generated on: 2026-10-31 06:39:31

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `serverless_stable_dvmvgw_catalog`.`ti_underwriting` COMMENT 'Owns the title underwriting risk and policy lifecycle as legally distinct entities: title_finding, title_requirement (Schedule B-I), policy_exception (Schedule B-II), curative actions (CPM/GAPcure), underwriting referrals (UWR) and underwriting decisions';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` (
    `title_finding_id` BIGINT COMMENT 'Unique surrogate primary key for each title finding record. Globally unique identifier assigned by the Title Production System upon discovery of a defect, encumbrance, lien, or anomaly during title examination.',
    `operations_title_examination_id` BIGINT COMMENT 'Foreign key reference to the title examination session during which this finding was identified. Preserves provenance of the examiner review that produced the finding.',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel record affected by this finding. Links the finding to the specific parcel (APN/PIN) in the Property Information and County Data System. Supports property-level defect and lien analysis.',
    `party_id` BIGINT COMMENT 'Reference to the title examiner (party) who identified and documented this finding during the examination. Supports examiner productivity and quality metrics. Maps to the party entity per VREQ-006.',
    `title_evidence_id` BIGINT COMMENT 'Reference to the primary supporting document or recorded instrument in the Document Management and Imaging System that is the evidentiary basis for this finding. Supports evidence completeness and provenance per VREQ-007.',
    `title_order_id` BIGINT COMMENT 'Foreign key reference to the parent title order under which this finding was discovered. Links the finding to the originating order intake record for end-to-end lifecycle traceability.',
    `title_search_id` BIGINT COMMENT 'Foreign key reference to the title search that surfaced the underlying instrument or record giving rise to this finding. Maintains evidence provenance from search through examination.',
    `affects_full_parcel` BOOLEAN COMMENT 'Flag indicating whether this finding affects the entire parcel or only a portion of it. When false, the partial_area_description field provides the specific affected area. Relevant for easements, encroachments, and partial liens.',
    `book_volume` STRING COMMENT 'Book or volume number in the county recorder index where the instrument is recorded. Part of the official recording reference used to locate the instrument in the title plant or county records.',
    `cleared_date` DATE COMMENT 'Date the finding was resolved and cleared through curative action, payoff, release, or satisfaction. Null if finding remains open. Used to calculate curative cycle time and clearance effectiveness metrics.',
    `cot_break_indicator` BOOLEAN COMMENT 'Flag indicating whether this finding represents a break or gap in the chain of title (COT). A true value triggers mandatory underwriting review and curative action before commitment issuance. Key metric per VREQ-016.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this title finding record was first created in the lakehouse Silver layer. Represents the RECORD_AUDIT_CREATED category. Used for data lineage and ingestion audit purposes.',
    `curative_action_required` BOOLEAN COMMENT 'Flag indicating whether this finding requires a curative action (CPM/GAPcure) to clear the defect before the title commitment or policy can be issued. Drives curative aging and effectiveness metrics.',
    `curative_deadline_date` DATE COMMENT 'Target date by which curative action must be completed to meet the closing schedule. Used to identify aging and at-risk findings that may delay closing readiness. Supports closing readiness metrics per VREQ-016.',
    `curative_notes` STRING COMMENT 'Free-text notes documenting curative actions taken, outstanding items, and resolution steps for this finding. Maintained by the curative processor throughout the clearance lifecycle.',
    `discovery_date` DATE COMMENT 'Date the finding was identified during title examination. Represents the principal business event date (BUSINESS_EVENT_TIMESTAMP category). Used to calculate curative aging and open-requirement aging metrics per VREQ-016.',
    `document_number` STRING COMMENT 'County recorder-assigned document or instrument number for the recorded instrument. Primary reference used in eRecording and title plant lookups (DataTrace/TitlePoint). May substitute or supplement book/page.',
    `finding_description` STRING COMMENT 'Free-text narrative description of the title defect, encumbrance, lien, cloud, or anomaly as documented by the examiner. Captures the specific nature of the issue including parties, amounts, and legal basis.',
    `finding_number` STRING COMMENT 'Human-readable business identifier for the finding, typically assigned by the Title Production System (e.g., SoftPro/RamQuest). Used in examiner notes, curative memos, and commitment schedules for cross-reference.',
    `finding_status` STRING COMMENT 'Current lifecycle status of the title finding. Drives open/aging requirement metrics and curative action tracking. Transitions from open through curative processing to cleared, excepted on Schedule B-II, or waived.. Valid values are `open|in_cure|cleared|excepted|waived|escalated`',
    `finding_type` STRING COMMENT 'Categorical classification of the title defect or encumbrance discovered. [ENUM-REF-CANDIDATE: tax_lien|judgment_lien|mechanics_lien|lis_pendens|ucc_filing|easement|encroachment|cot_break|vesting_defect|hoa_lien|deed_of_trust|mortgage|cc_and_r|row|other —',
    `gap_period_indicator` BOOLEAN COMMENT 'Flag indicating whether this finding falls within the gap period between the effective date of the title search and the recording of the insured instrument. Triggers gap coverage (GAPcure) analysis.',
    `grantee_name` STRING COMMENT 'Name of the grantee, creditor, or beneficiary on the instrument giving rise to this finding. Used in chain-of-title assembly and lien holder identification.',
    `grantor_name` STRING COMMENT 'Name of the grantor, debtor, or obligor on the instrument giving rise to this finding. Used in chain-of-title analysis and vesting verification. Not a direct personal identifier in the context of recorded public instruments.',
    `instrument_date` DATE COMMENT 'Date the underlying instrument giving rise to this finding was executed or created. Distinct from recording date; used in chain-of-title analysis and lien priority determination.',
    `instrument_type` STRING COMMENT 'Type of recorded or filed instrument that is the source of the finding (e.g., Deed of Trust, Warranty Deed, Quit Claim Deed, Judgment, Tax Certificate, UCC-1, Lis Pendens, Mechanics Lien).',
    `is_active` BOOLEAN COMMENT 'Flag indicating whether this is the current active version of the finding record. Supports soft-delete and record versioning patterns in the Silver layer. False indicates the record has been superseded or logically deleted.',
    `lien_amount` DECIMAL(18,2) COMMENT 'Dollar amount of the lien, judgment, or monetary encumbrance associated with this finding. Applicable for tax liens, judgment liens, mechanics liens, HOA assessments, and mortgage/DOT balances. Null for non-monetary findings.',
    `lien_amount_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the lien_amount. Defaults to USD for domestic US title transactions. Included for completeness and potential commercial cross-border transactions.. Valid values are `USD`',
    `lien_priority` BIGINT COMMENT 'Numeric priority rank of the lien or encumbrance relative to other encumbrances on the property. Lower number indicates higher priority. Used in underwriting analysis and payoff sequencing at settlement.',
    `page_number` STRING COMMENT 'Page number in the county recorder index where the instrument is recorded. Combined with book_volume forms the complete recording reference for the source instrument.',
    `partial_area_description` STRING COMMENT 'Legal or narrative description of the portion of the parcel affected by this finding when affects_full_parcel is false. Used for easements, encroachments, rights-of-way, and partial lien coverage analysis.',
    `prior_classification` STRING COMMENT 'Previous finding_type or risk_classification value before the most recent reclassification. Preserves material prior classifications per VREQ-007 to support lifecycle history and audit trail without a separate history table.',
    `reclassification_date` DATE COMMENT 'Date on which the finding was reclassified from its prior_classification to the current finding_type or risk_classification. Null if no reclassification has occurred. Supports lifecycle revision history per VREQ-007.',
    `reclassification_reason` STRING COMMENT 'Business reason or justification for reclassifying this finding from its prior classification. Documents the examiner or underwriter rationale for the change to support audit and provenance requirements per VREQ-007.',
    `recording_date` DATE COMMENT 'Date the instrument was recorded or filed with the county recorder or register of deeds. Establishes constructive notice and lien priority in the chain of title. Distinct from instrument_date per VREQ-008.',
    `risk_classification` STRING COMMENT 'Underwriting determination of whether the finding renders title insurable, marketable, or requires curative action or referral. Supports insurable/marketable-title determination metrics per VREQ-016.. Valid values are `insurable|uninsurable|marketable|unmarketable|curative_required|referral_required`',
    `schedule_b_disposition` STRING COMMENT 'Disposition of this finding on the title commitment Schedule B. A value of requirement places it on Schedule B-I; exception places it on Schedule B-II. Legally distinct per VREQ-002 and VREQ-017.. Valid values are `requirement|exception|waived|informational`',
    `severity` STRING COMMENT 'Underwriter-assigned severity level indicating the risk impact of the finding on insurability or marketability of title. Critical findings typically require curative action or underwriting referral before commitment issuance.. Valid values are `critical|major|minor|informational`',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this finding originated (e.g., SoftPro Select, RamQuest Horizon, Qualia, DataTrace, TitlePoint). Supports data lineage and SoR traceability.. Valid values are `softpro|ramquest|qualia|titlepoint|datatrace|other`',
    `source_system_finding_ref` STRING COMMENT 'Native identifier or reference number assigned to this finding by the originating operational system of record (e.g., SoftPro finding ID, RamQuest defect code). Enables reconciliation back to the SoR.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this title finding record was last modified in the lakehouse Silver layer. Represents the RECORD_AUDIT_UPDATED category. Used to detect stale records and track curative progress over time.',
    `uw_referral_required` BOOLEAN COMMENT 'Flag indicating whether this finding requires escalation to an underwriting referral (UWR) for senior underwriter review and approval before the commitment can be issued. Supports UW referral rate metrics.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_title_finding PRIMARY KEY(`title_finding_id`)
) COMMENT 'Authoritative SSOT for every defect, encumbrance, lien, cloud, or anomaly discovered during title examination. Each record captures the finding type (tax lien, judgment lien, mechanics lien, LP, UCC, easement, encroachment, chain-of-title break, vesting';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` (
    `title_requirement_id` BIGINT COMMENT 'Unique surrogate primary key for the title requirement record (Schedule B-I item). Globally unique across all requirement records in the title production system.',
    `operations_title_examination_id` BIGINT COMMENT 'Reference to the title examination session during which this requirement was identified. Supports provenance tracing from examination to curative action.',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Requirements often apply to specific parcels (tax liens, easements, boundary issues). Parcel-level tracking enables curative action targeting, Schedule B exception mapping by parcel',
    `prior_requirement_title_requirement_id` BIGINT COMMENT 'Self-referencing link to the previous version of this requirement record when a material revision occurred. Preserves lifecycle history per VREQ-007.',
    `title_commitment_id` BIGINT COMMENT 'Reference to the title commitment on which this requirement appears as a Schedule B-I item. Null if requirement predates commitment issuance.',
    `title_finding_id` BIGINT COMMENT 'Reference to the specific title finding (defect, lien, encumbrance, or cloud on title) that necessitated this Schedule B-I requirement. Core provenance link.',
    `title_order_id` BIGINT COMMENT 'Foreign key reference to the originating title order that generated this Schedule B-I requirement. Links the requirement to its parent transaction context.',
    `title_search_id` BIGINT COMMENT 'Foreign key linking to operations.title_search. Business justification: Requirements often cite specific search findings (instrument references, recording dates).',
    `uw_referral_id` BIGINT COMMENT 'Reference to the underwriting referral record if this requirement triggered a formal UWR. Null when is_underwriter_referral is False.',
    `added_to_commitment_date` DATE COMMENT 'Date this requirement was formally added to the title commitment as a Schedule B-I item. May differ from identified_date if added during a commitment revision.',
    `applies_to_policy_type` STRING COMMENT 'Indicates whether this requirement applies to the owner policy (OTP), lender policy (LTP), or both. Supports owner-versus-lender coverage analysis per VREQ-010.. Valid values are `owner|lender|both`',
    `assigned_curative_processor` STRING COMMENT 'Name or identifier of the internal curative processor or title officer assigned to manage resolution of this requirement. Supports workload and aging analysis.',
    `commitment_schedule_section` STRING COMMENT 'Identifies the commitment schedule section where this item appears. Title requirements appear in Schedule B-I (requirements to be satisfied before policy issuance).. Valid values are `schedule_b_i|schedule_a`',
    `confirmed_payoff_amount` DECIMAL(18,2) COMMENT 'Confirmed dollar amount from the payoff demand letter or lien release documentation. Supersedes estimated_payoff_amount once verified. Used for final settlement reconciliation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this title requirement record was first created in the system. Used for audit trail and curative aging baseline calculations.',
    `curative_action_type` STRING COMMENT 'Specific curative action being taken to resolve this requirement (e.g., obtain payoff, order release, record document). Aligns with CPM/GAPcure workflow steps. [ENUM-REF-CANDIDATE: promote to reference product]',
    `curative_memo_reference` STRING COMMENT 'Reference number or identifier of the Curative Processing Memo (CPM) associated with the resolution effort for this requirement. Links to document management system.',
    `due_date` DATE COMMENT 'Target date by which this requirement must be satisfied to support the scheduled closing date. Used for curative aging and closing readiness dashboards.',
    `estimated_payoff_amount` DECIMAL(18,2) COMMENT 'Estimated dollar amount required to satisfy this requirement (e.g., mortgage payoff, tax lien amount, judgment amount). Used for settlement statement preparation and escrow funding.',
    `evidence_document_reference` STRING COMMENT 'Document management system reference (document ID or URL) for the evidence supporting satisfaction of this requirement (e.g., recorded release, payoff confirmation letter).',
    `gap_coverage_required` BOOLEAN COMMENT 'Indicates whether gap coverage is required for this requirement, meaning the curative action must address the gap period between search date and recording date (GAPcure).',
    `grantee_name` STRING COMMENT 'Name of the grantee on the instrument underlying this requirement. Used for chain-of-title verification and vesting confirmation.',
    `grantor_name` STRING COMMENT 'Name of the grantor on the instrument underlying this requirement (e.g., lender to be paid off, judgment creditor). Used for lien identification and payoff demand.',
    `identified_date` DATE COMMENT 'Calendar date on which this requirement was first identified during title examination. Start point for curative aging calculations and SLA tracking.',
    `instrument_reference` STRING COMMENT 'Recording reference (book/page, document number, or instrument number) of the recorded instrument underlying this requirement. Supports chain-of-title tracing.',
    `is_active_version` BOOLEAN COMMENT 'Indicates whether this record is the current active version of the requirement. False for superseded versions retained for lifecycle history. Supports bi-temporal querying.',
    `is_closing_condition` BOOLEAN COMMENT 'Indicates whether this requirement must be satisfied before closing can proceed. True = hard closing block; False = may be satisfied post-closing with escrow holdback.',
    `is_underwriter_referral` BOOLEAN COMMENT 'Indicates whether this requirement was escalated to the underwriter for a formal underwriting referral (UWR) decision. Supports UW referral rate metrics.',
    `lien_type` STRING COMMENT 'Type of lien or encumbrance underlying this requirement when the requirement involves lien clearance (e.g., DOT, tax lien, mechanics lien, HOA). [ENUM-REF-CANDIDATE: promote to reference product]',
    `notes` STRING COMMENT 'Free-text operational notes entered by the curative processor or examiner regarding the status, contacts, or special handling instructions for this requirement.',
    `payoff_good_through_date` DATE COMMENT 'Date through which the confirmed payoff amount is valid. Closing must occur on or before this date to honor the payoff figure. Critical for closing scheduling.',
    `priority_level` STRING COMMENT 'Operational priority assigned to this requirement for curative processing. Critical items block closing; high items require expedited action before commitment expiry.. Valid values are `critical|high|standard|low`',
    `recording_reference` STRING COMMENT 'County recorder book/page or instrument number for the document recorded to satisfy this requirement (e.g., recorded deed of reconveyance, release of lien). Supports chain-of-title.',
    `requirement_category` STRING COMMENT 'Broad grouping of the requirement for reporting and aging analysis (e.g., lien clearance, vesting, survey, tax). Supports open/aging requirement metrics. [ENUM-REF-CANDIDATE: promote to reference product]',
    `requirement_description` STRING COMMENT 'Full narrative text of the Schedule B-I requirement as it appears on the commitment. Describes the specific curative action required of the parties before policy issuance.',
    `requirement_number` STRING COMMENT 'Human-readable Schedule B-I item number as it appears on the commitment (e.g., B-I-1, B-I-2). Used for external communication with parties and lenders.',
    `requirement_source` STRING COMMENT 'Identifies who or what system originated this requirement (examiner, underwriter, lender instruction, automated search engine). Supports provenance and audit.. Valid values are `examiner|underwriter|lender|automated_search|curative_processor`',
    `requirement_status` STRING COMMENT 'Current lifecycle state of the Schedule B-I requirement. Drives closing readiness and open/aging requirement dashboards. Transitions: open → in_progress → satisfied or waived.. Valid values are `open|in_progress|satisfied|waived|deferred|cancelled`',
    `requirement_type` STRING COMMENT 'Categorical classification of the curative action required (e.g., payoff, release, satisfaction, subordination). Drives workflow routing and curative processing.',
    `responsible_party_role` STRING COMMENT 'Role of the party responsible for satisfying this requirement (e.g., seller must provide payoff, buyer must provide survey). Drives task assignment in curative workflow.',
    `revision_number` BIGINT COMMENT 'Sequential revision number tracking changes to this requirement across commitment revisions. Version 1 = original; increments with each material change. Supports commitment revision frequency metrics.',
    `satisfaction_date` DATE COMMENT 'Date on which this requirement was confirmed as satisfied (e.g., payoff received, release recorded). Null if not yet satisfied. Used for curative effectiveness metrics.',
    `satisfaction_method` STRING COMMENT 'Method by which this requirement was ultimately satisfied or resolved (e.g., payoff and release, recorded release, affidavit, court order, underwriter waiver, escrow holdback).',
    `source_system_requirement_code` STRING COMMENT 'Native identifier of this requirement in the originating title production system (e.g., SoftPro Select, RamQuest Horizon, Qualia). Used for system-of-record reconciliation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this title requirement record. Used for change detection, audit trail, and incremental data pipeline processing.',
    `waiver_authority` STRING COMMENT 'Name or identifier of the underwriter or authorized officer who approved the waiver of this requirement. Required when requirement_status is waived. Supports audit trail.',
    `waiver_date` DATE COMMENT 'Date on which this requirement was formally waived by the underwriter or authorized officer. Null if not waived. Requires waiver_authority and waiver_reason to be populated.',
    `waiver_reason` STRING COMMENT 'Narrative explanation for why this requirement was waived rather than satisfied. Required for audit and regulatory compliance when a Schedule B-I item is removed without curative action.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_title_requirement PRIMARY KEY(`title_requirement_id`)
) COMMENT 'SSOT for Schedule B-I requirements — the curative actions that must be satisfied before a title commitment can be issued or a policy can be written. Each record links to the originating title_finding, specifies the required action (payoff, release';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` (
    `policy_exception_id` BIGINT COMMENT 'Unique surrogate identifier for a Schedule B-II policy exception record. Primary key for the policy_exception entity in the underwriting domain.',
    `party_id` BIGINT COMMENT 'Reference to the party record for the title examiner who identified and entered this exception during the examination process. Supports examiner workload and quality metrics.',
    `prior_exception_policy_exception_id` BIGINT COMMENT 'Self-referencing identifier pointing to the prior version of this exception record when it was revised or superseded. Preserves revision history and prior classifications per VREQ-007.',
    `title_commitment_id` BIGINT COMMENT 'Reference to the title commitment under which this Schedule B-II exception was first issued. Links the exception to its originating commitment lifecycle.',
    `title_evidence_id` BIGINT COMMENT 'Reference to the document management system identifier for the source instrument image or evidence document supporting this exception. Preserves provenance per VREQ-007.',
    `title_finding_id` BIGINT COMMENT 'Reference to the title_finding record that gave rise to this Schedule B-II exception. Preserves evidence and provenance linkage from examination to exception.',
    `title_order_id` BIGINT COMMENT 'Reference to the originating title order. Enables end-to-end traceability from order intake through exception issuance and policy production.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued title policy (OTP or LTP) that carries this exception. Null if the exception exists only at commitment stage and has not yet been carried into a policy.',
    `added_date` DATE COMMENT 'Calendar date on which this exception was first added to the commitment or policy Schedule B-II. Used for aging analysis and open exception tracking.',
    `affects_description` STRING COMMENT 'Narrative description of the portion of the insured property affected by this exception (e.g., the northerly 10 feet, the entire parcel, as shown on survey). Supports partial-coverage analysis.',
    `carried_to_policy_date` DATE COMMENT 'Date on which this exception was formally carried from the commitment into the issued title policy. Supports policy issuance lag and closing readiness metrics.',
    `commitment_revision_number` BIGINT COMMENT 'The revision number of the title commitment on which this exception was active. Supports commitment revision frequency metrics and lifecycle history preservation per VREQ-007.',
    `commitment_schedule_section` STRING COMMENT 'Identifies the schedule section of the commitment where this item appears: Schedule B-II (exceptions from coverage) versus Schedule B-I (requirements). Enforces legal distinction per VREQ-002 and VREQ-017.. Valid values are `schedule_b_ii|schedule_b_i`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this policy_exception record was first created in the lakehouse Silver layer. Supports audit trail and record lineage.',
    `curative_action_required` BOOLEAN COMMENT 'Indicates whether a curative action (CPM/GAPcure) is required to address or remove this exception prior to policy issuance. Supports curative aging and effectiveness metrics.',
    `curative_action_status` STRING COMMENT 'Current status of the curative processing effort associated with this exception: not_required, pending, in_progress, completed, or failed. Supports curative aging and effectiveness metrics.. Valid values are `not_required|pending|in_progress|completed|failed`',
    `curative_completion_date` DATE COMMENT 'Date on which the curative action for this exception was completed (e.g., release recorded, satisfaction filed). Used to measure curative cycle time and effectiveness.',
    `deleted_date` DATE COMMENT 'Calendar date on which this exception was removed from the commitment or policy Schedule B-II (e.g., after curative action, endorsement, or underwriter waiver). Null if still open.',
    `endorsement_available` BOOLEAN COMMENT 'Indicates whether an ALTA endorsement (e.g., ALTA 9, ALTA 8.1, ALTA 22) is available to insure over or modify this exception, reducing its coverage impact.',
    `endorsement_type` STRING COMMENT 'Identifies the ALTA endorsement type (e.g., ALTA 9, ALTA 8.1, ALTA 22) that insures over or modifies this exception, if applicable. Null if no endorsement applies.',
    `exception_number` STRING COMMENT 'Sequential alphanumeric identifier assigned to this exception within the commitment or policy Schedule B-II (e.g., 1, 2a, 3). Used for referencing in closing and curative documents.',
    `exception_status` STRING COMMENT 'Current lifecycle status of the exception: open (active on commitment), deleted (removed prior to policy), carried_to_policy (included in issued policy), waived (underwriter waived), subordinated (subordination obtained).. Valid values are `open|deleted|carried_to_policy|waived|subordinated`',
    `exception_text` STRING COMMENT 'Full verbatim text of the Schedule B-II exception as it appears in the commitment or policy. This is the legally operative language that defines the scope of the exclusion from coverage.',
    `exception_type` STRING COMMENT 'Categorical classification of the exception matter (e.g., easement, CC&R, ROW, HOA, survey matter, mineral rights, tax lien, mechanics lien). [ENUM-REF-CANDIDATE',
    `gap_coverage_applicable` BOOLEAN COMMENT 'Indicates whether gap coverage (GAP) applies to this exception, covering the period between the effective date of the commitment and the recording of the insured instruments.',
    `grantee_name` STRING COMMENT 'Name of the grantee party on the source instrument underlying this exception (e.g., the beneficiary of the easement or the lender on the deed of trust).',
    `grantor_name` STRING COMMENT 'Name of the grantor party on the source instrument underlying this exception (e.g., the party who granted the easement or executed the deed of trust).',
    `is_deleted` BOOLEAN COMMENT 'Logical deletion flag indicating this exception record has been superseded or removed from the active Schedule B-II. Preserves lifecycle history per VREQ-007 without physical deletion.',
    `is_standard_exception` BOOLEAN COMMENT 'Indicates whether this exception is a standard pre-printed ALTA exception (true) or a special/typed exception specific to this property or transaction (false).',
    `is_survey_exception` BOOLEAN COMMENT 'Indicates whether this exception relates to survey matters (encroachments, overlaps, boundary disputes, or facts that an accurate survey would disclose). Relevant to ALTA 9 endorsement eligibility.',
    `lien_amount` DECIMAL(18,2) COMMENT 'Dollar amount of the lien or encumbrance underlying this exception (e.g., judgment amount, tax lien balance, mechanics lien claim). Null for non-monetary exceptions such as easements or CC&Rs.',
    `lien_amount_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the lien amount (e.g., USD). Defaults to USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `policy_type` STRING COMMENT 'Indicates whether this exception applies to the Owners Title Policy (OTP), Lenders Title Policy (LTP), or both. Supports owner-versus-lender coverage analysis per VREQ-010.. Valid values are `owner|lender|both`',
    `priority_position` BIGINT COMMENT 'Numeric lien priority position of the encumbrance underlying this exception (e.g., 1 = first lien, 2 = second lien). Relevant for subordination analysis and LTV/CLTV underwriting.',
    `recording_date` DATE COMMENT 'Date the source instrument was recorded or filed with the county recorder or register of deeds. Distinct from execution date per VREQ-008.',
    `revision_reason` STRING COMMENT 'Reason code explaining why this exception record was created or revised: initial entry, curative update, underwriter waiver, endorsement added, commitment revision, or error correction.. Valid values are `initial|curative_update|underwriter_waiver|endorsement_added|commitment_revision|error_correction`',
    `source_instrument_date` DATE COMMENT 'Execution or effective date of the source instrument underlying this exception. Used in chain-of-title analysis and exception provenance.',
    `source_instrument_reference` STRING COMMENT 'Recording reference (book/page, document number, or instrument number) of the instrument that is the basis for this exception, as recorded in the county recorder or register of deeds.',
    `source_instrument_type` STRING COMMENT 'Type of recorded or filed instrument that is the basis for this exception (e.g., deed, mortgage, DOT, easement agreement, plat, judgment, tax certificate, UCC filing, HOA document, survey).',
    `source_system_exception_code` STRING COMMENT 'Native identifier for this exception record in the originating title production system (e.g., SoftPro Select, RamQuest Horizon, Qualia). Supports system-of-record traceability and reconciliation.',
    `standard_exception_code` STRING COMMENT 'Underwriter-assigned code identifying whether this is a standard pre-printed exception (e.g., ALTA standard exceptions 1–5) or a special/typed exception unique to this transaction.',
    `underwriter_notes` STRING COMMENT 'Free-text notes entered by the underwriter documenting the rationale for the underwriting decision on this exception, including any conditions or limitations applied.',
    `underwriting_decision` STRING COMMENT 'Underwriting disposition for this exception: insure_over (coverage provided), take_exception (excluded from coverage), delete (removed), refer_to_underwriter (escalated for UWR review), waive (underwriter waived requirement).. Valid values are `insure_over|take_exception|delete|refer_to_underwriter|waive`',
    `underwriting_referral_id` BIGINT COMMENT 'Reference to the underwriting referral record if this exception required escalation to an underwriter for a risk decision. Supports UWR rate and exception rate metrics.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this policy_exception record was last modified in the lakehouse Silver layer. Supports change detection and incremental processing.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_policy_exception PRIMARY KEY(`policy_exception_id`)
) COMMENT 'SSOT for Schedule B-II exceptions — matters that are excluded from coverage in the issued title policy. Each record identifies the exception type (easement, CC&R, ROW, HOA, survey matter, mineral rights, etc.), its source instrument, whether it is a';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` (
    `title_commitment_id` BIGINT COMMENT 'Unique surrogate identifier for each title commitment version record. Primary key for the title_commitment entity in the underwriting domain.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent agent or branch entity that issued this commitment. Null for direct underwriter issuance. Supports agency oversight and remittance tracking.',
    `legal_description_id` BIGINT COMMENT 'Reference to the legal_description record used in Schedule A of this commitment. Captures the metes-and-bounds, PLSS, or plat/subdivision description of the insured estate.',
    `operations_title_examination_id` BIGINT COMMENT 'Reference to the title examination that produced the findings, requirements, and exceptions reflected in this commitments Schedule B-I and B-II.',
    `party_id` BIGINT COMMENT 'Reference to the title examiner or attorney who performed the examination underlying this commitment. Supports evidence and provenance tracking per VREQ-007.',
    `prior_commitment_title_commitment_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding commitment version. Null for initial issuance. Preserves full revision lineage per VREQ-007.',
    `property_id` BIGINT COMMENT 'Reference to the property entity representing the real property subject to this commitment. Supports the three-entity property/parcel/legal_description model per VREQ-004.',
    `title_order_id` BIGINT COMMENT 'Reference to the originating title order that triggered this commitment. Every title_commitment must trace back to a title_order per VREQ-002 and VREQ-013.',
    `underwriter_id` BIGINT COMMENT 'Reference to the title underwriter (e.g., FNF, FAF, STC, ORI) on whose paper this commitment is issued. Required for policy issuance and claims administration.',
    `channel_type` STRING COMMENT 'Business channel through which this commitment was produced: direct branch, centralized lender channel, or independent agent. Drives agency remittance and split calculations.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `closing_date_actual` DATE COMMENT 'Date on which the transaction actually closed and settlement occurred. Null until closing is completed. Used to measure title clearance cycle time per VREQ-016.',
    `closing_date_scheduled` DATE COMMENT 'Anticipated closing/settlement date for the transaction. Used for closing readiness tracking and commitment expiration management per VREQ-016.',
    `closing_protection_letter_flag` BOOLEAN COMMENT 'Indicates whether a Closing Protection Letter (CPL) / Insured Closing Letter has been issued in connection with this commitment, protecting the lender against settlement agent fraud or negligence.',
    `commitment_number` STRING COMMENT 'Externally-known alphanumeric identifier assigned to this commitment by the title production system (e.g., SoftPro/RamQuest/Qualia). Printed on the commitment document delivered to parties.',
    `commitment_status` STRING COMMENT 'Current lifecycle state of this commitment version. Tracks progression from draft through issuance, revision, expiration, and closure. [ENUM-REF-CANDIDATE: draft|issued|revised|extended|expired|cancelled|closed — promote to reference product]',
    `commitment_type` STRING COMMENT 'Classification of the underlying real estate transaction type for which the commitment is issued: purchase, refinance (REFI), home equity (HELOC), construction, or commercial.. Valid values are `purchase|refinance|home_equity|construction|commercial`',
    `county_fips_code` STRING COMMENT 'Five-digit Federal Information Processing Standards (FIPS) county code for the county in which the subject property is located. Used for recording jurisdiction routing and county plant lookups.. Valid values are `^[0-9]{5}$`',
    `cpl_issue_date` DATE COMMENT 'Date on which the Closing Protection Letter (CPL) was issued for this commitment. Null if no CPL was issued. Distinct from commitment issue_date per VREQ-008.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this commitment version record was first created in the title production system (SoftPro/RamQuest/Qualia). Audit trail for record provenance per VREQ-007.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this commitment. Defaults to USD for domestic US transactions.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date through which the title search underlying this commitment is current. Defines the gap period start for GAP coverage purposes. Distinct from issue_date per VREQ-008.',
    `estate_type` STRING COMMENT 'Type of estate or interest in the land to be insured as stated in Schedule A (e.g., fee simple, leasehold). Determines the scope of coverage under the owner and lender policies.. Valid values are `fee_simple|leasehold|easement|life_estate|other`',
    `expiration_date` DATE COMMENT 'Date on which this commitment expires if the transaction has not closed. After this date the commitment must be extended or reissued. Supports closing readiness metrics per VREQ-016.',
    `gap_coverage_flag` BOOLEAN COMMENT 'Indicates whether gap coverage (GAPcure) is provided under this commitment, protecting against instruments recorded between the effective date and the recording of the insured documents.',
    `insurable_title_determination` STRING COMMENT 'Underwriters determination of whether title is insurable, insurable with exceptions, or not insurable at the time of commitment issuance. Core underwriting output.. Valid values are `insurable|insurable_with_exceptions|not_insurable|pending`',
    `issue_date` DATE COMMENT 'Calendar date on which this commitment version was formally issued and delivered to the proposed insured and lender. The principal business event date for the commitment instrument.',
    `loan_amount` DECIMAL(18,2) COMMENT 'Principal loan amount secured by the mortgage or deed of trust (DOT) to be insured under the lender policy. Used for LTV and CLTV calculations and underwriting risk assessment.',
    `loan_policy_amount` DECIMAL(18,2) COMMENT 'Dollar amount of lenders title policy (LTP) coverage proposed in Schedule A. Typically equals the loan amount. Supports owner-versus-lender coverage metrics per VREQ-016.',
    `loan_premium_amount` DECIMAL(18,2) COMMENT 'Calculated title insurance premium for the lenders policy (LTP) based on the applicable state rate schedule and liability amount. Used for premium remittance and revenue recognition.',
    `marketable_title_flag` BOOLEAN COMMENT 'Indicates whether the examiner has determined that title is marketable (free from reasonable doubt as to validity) in addition to being insurable. Supports chain-of-title break metrics.',
    `open_exceptions_count` BIGINT COMMENT 'Count of Schedule B-II exceptions (policy_exception records) listed on this commitment version. Supports unresolved defects/liens and exception rate metrics per VREQ-016.',
    `open_requirements_count` BIGINT COMMENT 'Count of uncleared Schedule B-I requirements (title_requirement records) at the time this commitment version was issued. Supports open/aging requirements metrics per VREQ-016.',
    `owner_policy_amount` DECIMAL(18,2) COMMENT 'Dollar amount of owners title policy (OTP) coverage proposed in Schedule A. Typically equals the purchase price. Supports owner-versus-lender coverage metrics per VREQ-016.',
    `owner_premium_amount` DECIMAL(18,2) COMMENT 'Calculated title insurance premium for the owners policy (OTP) based on the applicable state rate schedule and liability amount. Used for premium remittance and revenue recognition.',
    `policy_form_code` STRING COMMENT 'Code identifying the ALTA policy form version to be issued (e.g., ALTA 2006, ALTA 2016, state-specific form). Determines coverage terms and endorsement eligibility.',
    `proposed_insured_lender` STRING COMMENT 'Name of the proposed insured lender/mortgagee as it appears in Schedule A of the commitment (LTP). Includes MERS nominee language where applicable.',
    `proposed_insured_owner` STRING COMMENT 'Name of the proposed insured owner as it appears in Schedule A of the commitment (OTP). Reflects vesting as it will appear on the deed. Distinct from lender insured.',
    `purchase_price` DECIMAL(18,2) COMMENT 'Agreed purchase price of the property as stated in the purchase contract. Used to set OTP liability amount and for underwriting risk assessment. Null for refinance transactions.',
    `rate_schedule_code` STRING COMMENT 'Code identifying the state-filed rate schedule applied to calculate premiums on this commitment. Varies by state, transaction type, and underwriter. Required for regulatory premium reporting.',
    `reissue_rate_flag` BOOLEAN COMMENT 'Indicates whether a reissue/refinance premium rate applies based on a prior policy within the qualifying period. Affects premium calculation and rate schedule selection.',
    `revision_date` DATE COMMENT 'Date on which this revision was prepared and issued. Null for the initial issuance version. Distinct from issue_date to preserve the amendment timeline per VREQ-007 and VREQ-008.',
    `revision_number` BIGINT COMMENT 'Sequential integer indicating which version of the commitment this record represents. Initial issuance = 1; each amendment increments by 1. Supports commitment revision frequency metrics per VREQ-016.',
    `revision_reason` STRING COMMENT 'Free-text or coded explanation for why this revision was issued (e.g., new lien found, requirement cleared, insured name correction, loan amount change). Supports revision frequency analysis per VREQ-016.',
    `schedule_a_notes` STRING COMMENT 'Free-text notes or special conditions appearing in Schedule A of the commitment beyond the standard fields (e.g., vesting instructions, special estate language, survey requirements).',
    `simultaneous_issue_flag` BOOLEAN COMMENT 'Indicates whether the owner and lender policies are being issued simultaneously, qualifying for a simultaneous issue premium discount under state rate schedules.',
    `source_system_commitment_ref` STRING COMMENT 'Native commitment identifier from the originating title production system (e.g., SoftPro order/commitment number, RamQuest file number). Enables cross-system reconciliation.',
    `state_code` STRING COMMENT 'Two-letter US state code (FIPS) for the jurisdiction in which the subject property is located. Determines applicable rate schedule, regulatory requirements, and underwriting guidelines.. Valid values are `^[A-Z]{2}$`',
    `underwriting_referral_id` BIGINT COMMENT 'Reference to the underwriting referral record if this commitment required escalation to the underwriter for risk review or exception approval. Null if no referral was required.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this commitment version record in the source system. Supports change detection and incremental lakehouse ingestion.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_title_commitment PRIMARY KEY(`title_commitment_id`)
) COMMENT 'SSOT for the title commitment instrument — the conditional promise to issue a title policy. Each record represents a distinct commitment version (initial issuance plus each revision/amendment), capturing Schedule A data (proposed insured, estate/interest';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` (
    `title_policy_id` BIGINT COMMENT 'Unique surrogate identifier for the title insurance policy record. Primary key for the title_policy entity.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent or direct branch that issued the policy. Used for agency remittance timeliness and oversight metrics.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Every title policy insures a specific property. Direct link is fundamental for policy-to-property traceability, claim analysis by property characteristics, loss ratio calculation by',
    `title_commitment_id` BIGINT COMMENT 'Reference to the title commitment (Schedule A/B-I/B-II) from which this policy was issued. Links policy to the approved commitment that preceded it.',
    `originating_title_order_id` BIGINT COMMENT 'Reference to the originating title order that initiated the search, examination, commitment, and policy production workflow. Every title_policy must trace to a title_order.',
    `agent_premium_split_amount` DECIMAL(18,2) COMMENT 'Dollar portion of the net premium retained by the independent title agent per the agency agreement split schedule. Used for remittance reconciliation.',
    `cancellation_date` DATE COMMENT 'Date the policy was cancelled, if applicable. Null for active policies. Supports lifecycle history preservation per VREQ-007.',
    `cancellation_reason` STRING COMMENT 'Reason code for policy cancellation. Supports lifecycle audit and underwriting exception analysis per VREQ-007.. Valid values are `transaction_cancelled|duplicate_policy|underwriting_declined|insured_request|other`',
    `companion_policy_number` STRING COMMENT 'Policy number of the simultaneously issued companion policy (OTP companion to LTP or vice versa). Supports simultaneous issue rate validation and owner-vs-lender coverage analysis.',
    `county_fips_code` STRING COMMENT 'Five-digit Federal Information Processing Standards (FIPS) county code for the county where the insured property is located. Used for recording jurisdiction and regulatory reporting.. Valid values are `^d{5}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this title_policy record was first created in the system of record (title production system). Audit trail for record provenance per VREQ-007.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this policy. Typically USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date and time as of which the policy insures title, typically the date and time of recording of the insured instrument. Distinct from issue_date per VREQ-008.',
    `effective_time` TIMESTAMP COMMENT 'Time component of the policy effective date (HH:mm:ss) as recorded on Schedule A. Title insurance coverage attaches at a specific time of day on the effective date.',
    `endorsement_count` BIGINT COMMENT 'Number of ALTA endorsements attached to this policy at issuance (e.g., ALTA 9, ALTA 8.1, ALTA 22). Supports owner-versus-lender coverage and endorsement analysis.',
    `estate_or_interest` STRING COMMENT 'Nature of the estate or interest in the land insured under Schedule A (e.g., fee simple, leasehold). Defines the scope of title coverage.. Valid values are `fee_simple|leasehold|easement|life_estate|other`',
    `execution_date` DATE COMMENT 'Date the policy document was executed (signed/authorized) by the issuing agent or underwriter. Distinct from effective_date and issue_date per VREQ-008.',
    `gap_coverage_flag` BOOLEAN COMMENT 'Indicates whether gap coverage (GAP) is provided under this policy, insuring against defects arising in the gap period between commitment and recording.',
    `insurable_title_flag` BOOLEAN COMMENT 'Indicates whether title was determined insurable (though not necessarily marketable) at policy issuance. Distinct from marketable_title_flag for underwriting risk classification.',
    `insured_name` STRING COMMENT 'Full legal name of the insured party as it appears on Schedule A of the policy. For OTP this is the buyer/owner; for LTP this is the lender/mortgagee.',
    `insured_type` STRING COMMENT 'Classification of the insured party: individual person, legal entity (LLC/Corp), trust, estate, or government body. Drives vesting and coverage analysis.. Valid values are `individual|entity|trust|estate|government`',
    `issue_date` DATE COMMENT 'Date the title policy was formally issued by the underwriter or issuing agent. Principal business event date for policy issuance lag metrics.',
    `lender_name` STRING COMMENT 'Name of the lender/mortgagee insured under an LTP policy as shown on Schedule A. Null for OTP policies.',
    `liability_amount` DECIMAL(18,2) COMMENT 'Maximum dollar amount of coverage (face amount) for which the underwriter is liable under this policy. For OTP equals purchase price; for LTP equals loan amount.',
    `loan_amount` DECIMAL(18,2) COMMENT 'Principal loan amount secured by the insured mortgage, applicable to LTP policies only. Equals the LTP liability amount and is used for LTV and coverage analysis.',
    `loan_number` STRING COMMENT 'Lender-assigned loan number for the mortgage insured under an LTP policy. Used to cross-reference with lender systems and MERS registration.',
    `marketable_title_flag` BOOLEAN COMMENT 'Indicates whether the underwriter determined title to be marketable at the time of policy issuance. Supports insurable vs. marketable title determination tracking.',
    `net_premium_amount` DECIMAL(18,2) COMMENT 'Premium amount after applying reissue credits and other adjustments. Represents the actual premium collected and subject to remittance split.',
    `policy_exception_count` BIGINT COMMENT 'Number of Schedule B-II exceptions (policy_exception records) carried on this policy at issuance. Supports unresolved defect and exception rate metrics per VREQ-016.',
    `policy_form_code` STRING COMMENT 'ALTA or state-specific policy form identifier (e.g., ALTA 2021 Owners Policy, ALTA 2021 Loan Policy, ALTA Homeowners Policy 2013). Governs coverage terms.',
    `policy_issuance_lag_days` BIGINT COMMENT 'Number of calendar days between the recording_date of the insured instrument and the policy issue_date. Key metric for policy issuance lag after recording per VREQ-016.',
    `policy_number` STRING COMMENT 'Externally-known unique policy number assigned by the underwriter or title production system (e.g., SoftPro/RamQuest). Used for claims, endorsements, and regulatory reporting.',
    `policy_status` STRING COMMENT 'Current lifecycle state of the title policy. Tracks progression from draft through issuance, and captures cancellations or reissuances for revision history per VREQ-007.. Valid values are `draft|issued|cancelled|suspended|reissued`',
    `policy_type` STRING COMMENT 'Discriminates between Owners Title Policy (OTP) and Lenders/Loan Title Policy (LTP). Owner and lender policies are stored as separate records with separate policy_type values per VREQ-010.. Valid values are `OTP|LTP`',
    `premium_amount` DECIMAL(18,2) COMMENT 'Gross title insurance premium charged for this policy before any splits or adjustments. Used for premium revenue recognition and remittance calculations.',
    `prior_policy_date` DATE COMMENT 'Issue date of the prior title policy referenced for reissue credit calculation. Required by state rate filings to validate reissue credit eligibility.',
    `prior_policy_number` STRING COMMENT 'Policy number of a previously issued title policy on the same property, used to establish reissue credit eligibility and chain-of-coverage continuity.',
    `production_channel` STRING COMMENT 'Channel through which the policy was produced: direct branch, centralized lender channel, or independent title agent. Drives remittance, oversight, and performance metrics.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `recording_date` DATE COMMENT 'Date the insured instrument (deed or mortgage) was recorded at the county recorder/register of deeds. Anchors the gap period and effective date. Distinct per VREQ-008.',
    `reissue_credit_amount` DECIMAL(18,2) COMMENT 'Dollar credit applied to the premium when a prior policy exists on the same property and a reissue rate is applicable. Reduces net premium charged.',
    `reissue_flag` BOOLEAN COMMENT 'Indicates whether this policy was issued at a reissue rate based on a prior policy. Triggers reissue credit calculation and prior policy validation.',
    `remittance_date` DATE COMMENT 'Actual date the underwriters premium share was remitted by the agent. Null if not yet remitted. Used to calculate remittance lag.',
    `remittance_due_date` DATE COMMENT 'Date by which the agent must remit the underwriters share of the premium per the agency agreement. Used for remittance timeliness tracking.',
    `remittance_status` STRING COMMENT 'Current status of the underwriter premium remittance for this policy. Supports agency remittance timeliness metrics per VREQ-016.. Valid values are `pending|remitted|overdue|waived`',
    `simultaneous_issue_flag` BOOLEAN COMMENT 'Indicates whether this policy was issued simultaneously with a companion OTP or LTP policy on the same transaction, qualifying for a simultaneous issue rate discount.',
    `source_system_policy_ref` STRING COMMENT 'Native policy identifier from the originating title production system (e.g., SoftPro Select, RamQuest Horizon, Qualia). Enables traceability back to the system of record.',
    `state_code` STRING COMMENT 'Two-letter US state code where the insured property is located. Governs applicable rate filings, policy forms, and regulatory reporting jurisdiction.. Valid values are `^[A-Z]{2}$`',
    `transaction_type` STRING COMMENT 'Type of real estate transaction underlying the policy (purchase, refinance, HELOC, construction, home equity, commercial). Drives rate, form, and coverage selection.. Valid values are `purchase|refinance|heloc|construction|home_equity|commercial`',
    `underwriter_code` STRING COMMENT 'Code identifying the title underwriter (e.g., FNF, FAF, STC, ORI) that backs this policy. Required for regulatory reporting and loss ratio analysis.',
    `underwriter_premium_split_amount` DECIMAL(18,2) COMMENT 'Dollar portion of the net premium remitted to the underwriter per the agency agreement split schedule. Drives remittance timeliness metrics.',
    `underwriting_referral_flag` BOOLEAN COMMENT 'Indicates whether this policy required an underwriting referral (UWR) to the underwriters home office or senior underwriter prior to issuance. Drives UWR rate metrics.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this title_policy record was last modified in the system of record. Supports change detection and lifecycle history per VREQ-007.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_title_policy PRIMARY KEY(`title_policy_id`)
) COMMENT 'SSOT for issued title insurance policies. Owner (OTP) and lender (LTP) policies are stored as separate records with separate policy_type values, satisfying VREQ-010.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` (
    `endorsement_id` BIGINT COMMENT 'Unique surrogate identifier for each ALTA endorsement record attached to an owner or lender title policy. Primary key for the endorsement entity.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent or direct branch that issued this endorsement on behalf of the underwriter. Supports agency remittance and authority oversight.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Endorsements modify coverage for specific properties (zoning, access, survey). Direct property link enables endorsement analysis by property type/transaction, premium analysis by property',
    `superseded_by_endorsement_id` BIGINT COMMENT 'Reference to the replacement endorsement record when this endorsement has been superseded by a revised version. Preserves revision lineage per VREQ-007. Null if not superseded.',
    `title_order_id` BIGINT COMMENT 'Reference to the originating title order that produced the parent policy. Supports end-to-end traceability from order intake through endorsement issuance.',
    `title_policy_id` BIGINT COMMENT 'Reference to the parent title policy (owner or lender) to which this endorsement is attached. Every endorsement must be associated with exactly one title policy.',
    `additional_premium_amount` DECIMAL(15,2) COMMENT 'Additional premium charged for this endorsement, expressed in USD. Added to the base policy premium. Used for premium revenue recognition and agency remittance calculations.',
    `agent_premium_split_pct` DECIMAL(5,4) COMMENT 'Contractual percentage of the endorsement premium retained by the issuing agent per the agency agreement (split). Expressed as a decimal (e.g., 0.7000 = 70%). Supports remittance reconciliation.',
    `alta_form_number` STRING COMMENT 'Standardized ALTA endorsement form number identifying the endorsement type (e.g., ALTA 9, ALTA 8.1, ALTA 22, ALTA 28, ALTA 3.1). Drives coverage scope and premium calculation.',
    `cancellation_date` DATE COMMENT 'Date the endorsement was cancelled, if applicable. Null for active endorsements. Supports lifecycle history preservation per VREQ-007.',
    `cancellation_reason` STRING COMMENT 'Reason code explaining why the endorsement was cancelled. Null for active endorsements. Supports lifecycle audit and revision frequency analysis per VREQ-007.. Valid values are `underwriter_withdrawal|insured_request|policy_cancelled|superseded_by_revision|error_correction|other`',
    `county_fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county in which the insured property is located. Used for county-level regulatory reporting and recording jurisdiction identification.. Valid values are `^[0-9]{5}$`',
    `coverage_category` STRING COMMENT 'Broad category of risk coverage provided by the endorsement. [ENUM-REF-CANDIDATE: access|environmental|survey|zoning|tax|mechanics_lien|usury|variable_rate|other — promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this endorsement record was first created in the lakehouse Silver layer. Audit field supporting data lineage and record provenance per VREQ-007.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this endorsement record. Defaults to USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `endorsement_description` STRING COMMENT 'Full narrative description of the coverage provided by this endorsement, including any specific conditions, limitations, or property-specific language added by the underwriter.',
    `document_image_ref` STRING COMMENT 'Reference key or URI to the scanned or electronic image of the executed endorsement document stored in the Document Management and Imaging System. Supports evidence and provenance.',
    `effective_date` DATE COMMENT 'Date on which the endorsement coverage becomes effective. Per VREQ-008, this is distinct from execution, submission, acceptance, and recording dates. Typically aligns with policy effective date.',
    `electronic_delivery` BOOLEAN COMMENT 'Indicates whether this endorsement was delivered electronically to the insured or lender rather than in paper form. Supports eRecording and digital closing workflow tracking.',
    `endorsement_status` STRING COMMENT 'Current lifecycle state of the endorsement. Tracks progression from draft through issuance or cancellation. Supports commitment revision frequency and policy issuance lag metrics.. Valid values are `draft|issued|cancelled|superseded|pending_approval`',
    `endorsement_type` STRING COMMENT 'Indicates whether this endorsement applies to an Owners Title Policy (OTP), a Lenders Title Policy (LTP), or both. Supports owner-versus-lender coverage analysis per VREQ-010.. Valid values are `owner|lender|both`',
    `execution_date` DATE COMMENT 'Date the endorsement was executed (signed/authorized) by the authorized underwriting officer. Per VREQ-008, distinct from effective, submission, acceptance, and recording dates.',
    `gl_account_code` STRING COMMENT 'General ledger account code to which the endorsement premium revenue is posted. Supports ERP/GL integration for premium revenue recognition and financial reporting.',
    `issuance_date` DATE COMMENT 'Date the endorsement was formally issued and delivered to the insured or lender. Used to measure policy issuance lag after recording and endorsement production cycle time.',
    `issuing_officer_name` STRING COMMENT 'Name of the authorized title officer or underwriting officer who executed and issued this endorsement. Supports audit trail and authority verification.',
    `issuing_underwriter_code` STRING COMMENT 'Code identifying the title underwriter (e.g., FNF, FAF, STC, ORI) that issued this endorsement. Supports underwriter-level premium and loss ratio reporting.',
    `liability_amount` DECIMAL(15,2) COMMENT 'Maximum insured liability amount covered by this endorsement in USD. May differ from the parent policy amount for endorsements with limited coverage scope.',
    `endorsement_name` STRING COMMENT 'Human-readable name or short title of the endorsement form (e.g., Restrictions, Encroachments, Minerals, Environmental Protection Lien, Location). Complements the ALTA form number.',
    `notes` STRING COMMENT 'Free-text field for underwriter or title officer notes regarding special circumstances, conditions, or property-specific language associated with this endorsement.',
    `number` STRING COMMENT 'Externally-known alphanumeric identifier assigned to this endorsement by the title production system (e.g., SoftPro, RamQuest). Used for referencing in policy documents and correspondence.. Valid values are `^END-[0-9]{4}-[0-9]{6}$`',
    `premium_basis` STRING COMMENT 'Method used to calculate the endorsement premium (e.g., flat fee, rate per thousand of liability, percentage of policy amount, or no additional charge). Drives premium calculation logic.. Valid values are `flat_fee|rate_per_thousand|percentage_of_liability|no_charge`',
    `prior_endorsement_id` BIGINT COMMENT 'Reference to the prior version of this endorsement that was superseded. Enables full revision chain traversal. Null for original issuances. Supports VREQ-007 lifecycle history.',
    `production_channel` STRING COMMENT 'Channel through which this endorsement was produced: direct branch, centralized lender channel, or independent title agent. Supports channel-level performance and remittance analysis.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `remittance_date` DATE COMMENT 'Date the endorsement premium was included in the agents remittance to the underwriter. Null until remitted. Supports agency remittance timeliness metrics per VREQ-016.',
    `remittance_included` BOOLEAN COMMENT 'Indicates whether the endorsement premium has been included in the agents premium remittance to the underwriter. Supports agency remittance timeliness and settlement reconciliation.',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this endorsement. Starts at 1 for original issuance; increments with each material revision. Supports commitment revision frequency metrics.',
    `source_system_code` STRING COMMENT 'Code identifying the title production system of record from which this endorsement record was sourced (e.g., SoftPro Select, RamQuest Horizon, Qualia). Supports data lineage.. Valid values are `softpro|ramquest|qualia|other`',
    `source_system_endorsement_ref` STRING COMMENT 'Native identifier for this endorsement record in the originating title production system (SoftPro, RamQuest, Qualia). Enables reconciliation and traceability back to the system of record.',
    `state_code` STRING COMMENT 'Two-letter US state code for the jurisdiction in which the insured property is located. Drives state-specific rate filings, form requirements, and regulatory reporting.. Valid values are `^[A-Z]{2}$`',
    `transaction_type` STRING COMMENT 'Type of real estate transaction to which the parent policy and this endorsement apply. [ENUM-REF-CANDIDATE: purchase|refinance|heloc|construction|commercial|home_equity — promote to reference product]. Valid values are `purchase|refinance|heloc|construction|commercial|home_equity`',
    `underwriter_premium_split_pct` DECIMAL(5,4) COMMENT 'Contractual percentage of the endorsement premium remitted to the underwriter per the agency agreement. Expressed as a decimal (e.g., 0.3000 = 30%). Complements agent split.',
    `underwriting_conditions` STRING COMMENT 'Narrative description of any conditions imposed by the underwriter as part of an approved-with-conditions decision for this endorsement. Null if no conditions apply.',
    `underwriting_decision` STRING COMMENT 'Underwriting decision outcome for this endorsement when a referral was required. Null if no referral was needed. Supports UW exception rate and referral analysis.. Valid values are `approved|approved_with_conditions|declined|pending`',
    `underwriting_referral_required` BOOLEAN COMMENT 'Indicates whether this endorsement required an underwriting referral (UWR) for approval before issuance. Supports UW referral and exception rate metrics per VREQ-016.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this endorsement record was last modified in the lakehouse Silver layer. Audit field supporting change tracking and lifecycle history per VREQ-007.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_endorsement PRIMARY KEY(`endorsement_id`)
) COMMENT 'Records each ALTA endorsement attached to an owner or lender title policy. Each record captures the endorsement form number (ALTA 9, ALTA 8.1, ALTA 22, ALTA 28, etc.), endorsement description, additional premium, effective date, and the parent';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` (
    `uw_referral_id` BIGINT COMMENT 'Unique surrogate identifier for the underwriting referral record. Primary key for the uw_referral entity.',
    `agent_profile_id` BIGINT COMMENT 'Identifier of the independent title agent, if the referral originates from an independent agency channel. Null for direct branch or centralized lender orders.',
    `policy_exception_id` BIGINT COMMENT 'Reference to the policy_exception record created as a result of this underwriting referral decision. Populated when exception_scheduled is True.',
    `prior_referral_id` BIGINT COMMENT 'Self-referential link to the previous version of this referral when revision_number > 1. Preserves material lifecycle history and revision chain per VREQ-007.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Referrals are triggered by property-specific risks (title defects, chain breaks, high liability).',
    `title_commitment_id` BIGINT COMMENT 'Reference to the title commitment associated with this referral, if the referral arises at or after commitment stage. Nullable when referral precedes commitment issuance.',
    `title_finding_id` BIGINT COMMENT 'Reference to the specific title finding (defect, lien, encumbrance, or cloud on title) that is the primary subject of this underwriting referral.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order that triggered this underwriting referral. Every UWR must trace back to an originating title order.',
    `underwriting_title_examination_id` BIGINT COMMENT 'Reference to the title examination that surfaced the defect or risk condition prompting this underwriting referral.',
    `uw_assigned_underwriter_party_id` BIGINT COMMENT 'Identifier of the underwriter assigned to review and decide on this referral. Supports underwriter workload, cycle time, and decision-rate analytics.',
    `uw_party_id` BIGINT COMMENT 'Identifier of the title examiner or branch staff member who initiated the underwriting referral. Supports examiner-level UWR rate and workload analytics.',
    `channel` STRING COMMENT 'Business channel through which the originating title order was produced: direct branch, centralized lender, or independent agent. Supports channel-level UWR rate reporting.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `closing_date_impact` BOOLEAN COMMENT 'Indicates whether this underwriting referral caused or is at risk of causing a delay to the scheduled closing date. Supports closing readiness metrics per VREQ-016.',
    `conditions_imposed` STRING COMMENT 'Free-text description of conditions, requirements, or curative actions imposed by the underwriter as part of an approved-with-conditions decision. Maps to Schedule B-I requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this underwriting referral record was first created in the lakehouse Silver layer. Audit trail for data lineage and provenance per VREQ-007.',
    `curative_action_description` STRING COMMENT 'Narrative description of the curative processing steps required to clear the title defect or satisfy underwriting conditions. Supports curative aging and effectiveness metrics.',
    `curative_action_required` BOOLEAN COMMENT 'Indicates whether the underwriting decision requires curative processing (CPM/GAPcure) before the commitment or policy can be issued. True = curative action required.',
    `curative_completed_date` DATE COMMENT 'Date on which all required curative actions were confirmed as completed and accepted by the underwriter. Used to measure curative effectiveness and cycle time.',
    `curative_deadline_date` DATE COMMENT 'Target date by which curative actions must be completed to maintain the scheduled closing date. Drives curative aging and closing readiness metrics.',
    `defect_description` STRING COMMENT 'Detailed narrative of the title defect, cloud on title, lien, or encumbrance under underwriting review. Provides examiner context for the underwriters risk assessment.',
    `endorsement_required` BOOLEAN COMMENT 'Indicates whether the underwriting decision requires one or more ALTA endorsements (e.g., ALTA 9, ALTA 8.1, ALTA 22) to be attached to the policy.',
    `endorsement_types` STRING COMMENT 'Comma-separated list of ALTA endorsement form numbers required as a result of this referral decision (e.g., ALTA 9, ALTA 8.1, ALTA 22). Populated when endorsement_required is True.',
    `escalation_count` BIGINT COMMENT 'Number of times this referral has been escalated to a higher underwriting authority level. Supports complexity and exception rate analytics.',
    `exception_scheduled` BOOLEAN COMMENT 'Indicates whether the underwriting decision resulted in a Schedule B-II policy exception being added to the commitment or policy. True = exception scheduled.',
    `gap_period_end_date` DATE COMMENT 'End date of the gap coverage period under review, typically the anticipated recording date. Defines the gap window for which underwriting approval is sought.',
    `gap_period_start_date` DATE COMMENT 'Start date of the gap coverage period under review, applicable when referral_type is gap_coverage. Represents the date through which the title search was completed.',
    `insurable_title_determination` STRING COMMENT 'Underwriters determination of the titles insurability or marketability following review. Core output of the UWR process; drives policy issuance eligibility.. Valid values are `insurable|marketable|insurable_with_exceptions|not_insurable|pending`',
    `liability_amount` DECIMAL(18,2) COMMENT 'Total insured liability amount (policy face value) associated with the transaction at the time of referral. High-liability thresholds are a primary UWR trigger. USD.',
    `liability_threshold_exceeded` BOOLEAN COMMENT 'Indicates whether the transaction liability amount exceeded the underwriters authority threshold, triggering mandatory referral. True = threshold exceeded.',
    `policy_type_requested` STRING COMMENT 'Indicates whether the referral pertains to an owner title policy (OTP), lender title policy (LTP), or both. Supports owner-versus-lender coverage metrics per VREQ-010.. Valid values are `owner|lender|both`',
    `prior_claim_reference` STRING COMMENT 'Reference number of a prior title insurance claim on the same property or related parties that contributed to this referral trigger. Links to claims administration history.',
    `referral_date` DATE COMMENT 'Calendar date on which the underwriting referral was formally submitted for review. Principal business event date; used as the start point for UWR cycle time measurement.',
    `referral_number` STRING COMMENT 'Human-readable, externally referenceable identifier for this underwriting referral, formatted as UWR-YYYY-NNNNNN. Used in correspondence with underwriters and in audit trails.. Valid values are `^UWR-[0-9]{4}-[0-9]{6}$`',
    `referral_status` STRING COMMENT 'Current lifecycle state of the underwriting referral. Drives open/aging UWR metrics and commitment readiness. [ENUM-REF-CANDIDATE: open|pending_uw_review|approved|approved_with_conditions|declined|withdrawn — promote to reference product]. Valid values are `open|pending_uw_review|approved|approved_with_conditions|declined|withdrawn`',
    `referral_timestamp` TIMESTAMP COMMENT 'Precise date-time when the underwriting referral was submitted. Provides intraday precision for SLA measurement and audit trail beyond the referral_date.',
    `referral_trigger_reason` STRING COMMENT 'Free-text narrative describing the specific condition, defect, or risk factor that triggered escalation to underwriting review. Complements referral_type with examiner detail.',
    `referral_type` STRING COMMENT 'Classification of the primary reason for escalation to underwriting review. Supports UWR rate analytics by trigger category. [ENUM-REF-CANDIDATE: promote to reference product]',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this underwriting referral, incremented when material changes are submitted for re-review. Supports commitment revision frequency metrics per VREQ-016.',
    `risk_category` STRING COMMENT 'Categorical classification of the title risk type under review. Aligns with title-risk cause taxonomy used in claim frequency and severity reporting. [ENUM-REF-CANDIDATE: promote to reference product]',
    `sla_breach` BOOLEAN COMMENT 'Indicates whether the underwriting decision was rendered after the sla_target_days threshold. True = SLA breached. Supports aging and cycle time reporting.',
    `sla_target_days` BIGINT COMMENT 'Number of business days within which the underwriting decision is contractually or operationally required. Baseline for UWR cycle time SLA compliance measurement.',
    `source_system_ref` STRING COMMENT 'Identifier of this referral record in the originating Underwriting Risk and Policy Management System (e.g., SoftPro, RamQuest, or proprietary UW system). Supports SoR reconciliation.',
    `transaction_type` STRING COMMENT 'Type of real estate transaction associated with the referral (e.g., purchase, REFI, HELOC, construction, commercial). Supports segmentation of UWR rates by transaction type.. Valid values are `purchase|refinance|heloc|construction|commercial|home_equity`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this underwriting referral record was last modified in the lakehouse Silver layer. Supports change detection and audit trail for lifecycle transitions.',
    `uw_authority_level` STRING COMMENT 'Level of underwriting authority required to approve this referral (branch, regional, national, or reinsurance). Reflects the risk complexity and liability amount thresholds.. Valid values are `branch|regional|national|reinsurance`',
    `uw_decision` STRING COMMENT 'Final underwriting decision rendered on this referral. Drives commitment issuance, exception scheduling, and curative action requirements.. Valid values are `approved|approved_with_conditions|declined|deferred`',
    `uw_decision_date` DATE COMMENT 'Date on which the underwriter rendered a decision (approved, approved with conditions, or declined) on this referral. Used to compute UWR cycle time.',
    `uw_decision_rationale` STRING COMMENT 'Narrative explanation provided by the underwriter supporting the decision. Required for declined and approved-with-conditions outcomes for audit and regulatory review.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_uw_referral PRIMARY KEY(`uw_referral_id`)
) COMMENT 'Tracks underwriting referral (UWR) events — the escalation of a title order or commitment to an underwriter for risk review. Each record captures the referral trigger (high-liability amount, complex defect, gap coverage, prior claim, commercial';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` (
    `curative_action_id` BIGINT COMMENT 'Unique surrogate identifier for each discrete curative action record within the title underwriting workflow.',
    `assigned_party_id` BIGINT COMMENT 'Reference to the party (examiner, curative specialist, attorney, or vendor) responsible for executing this curative action.',
    `decision_id` BIGINT COMMENT 'Foreign key linking to underwriting.underwriting_decision. Business justification: Curative actions may be triggered by or result from formal underwriting decisions.',
    `operations_title_examination_id` BIGINT COMMENT 'Reference to the title examination that identified the defect or issue requiring this curative action.',
    `prior_action_id` BIGINT COMMENT 'Self-referencing identifier pointing to the previous curative action attempt for the same requirement or finding. Preserves lifecycle history and re-attempt lineage per VREQ-007.',
    `recording_submission_id` BIGINT COMMENT 'Reference to the eRecording submission record if this curative action required recording a document with the county recorder or register of deeds.',
    `title_evidence_id` BIGINT COMMENT 'Reference to the document management record containing the evidence (release, satisfaction, affidavit, recorded instrument) that proves this curative action was completed.',
    `title_finding_id` BIGINT COMMENT 'Reference to the title examination finding (defect, lien, encumbrance) that this curative action is resolving. Null if action is linked only to a requirement.',
    `title_order_id` BIGINT COMMENT 'Reference to the parent title order under which this curative action is being performed. Links the action to the originating transaction.',
    `title_requirement_id` BIGINT COMMENT 'Reference to the Schedule B-I title requirement this curative action is intended to satisfy. Null if action is linked only to a finding.',
    `uw_referral_id` BIGINT COMMENT 'Reference to the underwriting referral record created when this curative action required underwriter review or exception approval.',
    `action_number` STRING COMMENT 'Externally visible business identifier for this curative action, used in correspondence, CPM memos, and production system tracking (e.g., CA-2024-000123).. Valid values are `^CA-[0-9]{4}-[0-9]{6}$`',
    `action_status` STRING COMMENT 'Current lifecycle state of the curative action. Drives open/aging requirement metrics and curative effectiveness reporting. [ENUM-REF-CANDIDATE: open|in_progress|pending_response|completed|waived|escalated|cancelled — 7 candidates stripped; promote to',
    `action_subtype` STRING COMMENT 'Further classification within the action type (e.g., within lien_release: tax_lien_release, mechanics_lien_release, judgment_lien_release, HOA_lien_release). Supports granular curative aging analysis.',
    `action_type` STRING COMMENT 'Classification of the curative step being taken (e.g., payoff request, lien release, affidavit of heirship, probate filing, survey correction, GAPcure, CPM memo).',
    `attempt_number` BIGINT COMMENT 'Sequential count of attempts made to complete this curative action. Values greater than 1 indicate re-attempts after prior failure or rejection. Supports curative effectiveness metrics.',
    `completed_date` DATE COMMENT 'Calendar date on which this curative action was fully resolved and the requirement or finding was satisfied. Null if still open.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this curative action record was first created in the lakehouse Silver layer. Audit trail for record provenance.',
    `curative_cost` DECIMAL(18,2) COMMENT 'Actual cost incurred to complete this curative action (e.g., recording fees, attorney fees, court filing fees, survey costs). USD. Used for curative cost analysis.',
    `days_open` BIGINT COMMENT 'Number of calendar days this curative action has been open as of the last refresh date. Supports curative aging and SLA reporting. Sourced from production system; not a real-time calculation.',
    `defect_category` STRING COMMENT 'Category of the underlying title defect or cloud being cured (e.g., lien, chain-of-title break, vesting defect, gap). Supports unresolved defect and lien metrics.',
    `due_date` DATE COMMENT 'Target date by which this curative action must be completed to maintain closing readiness and commitment validity.',
    `escalated_date` DATE COMMENT 'Date on which this curative action was escalated to underwriting review or senior curative staff due to complexity or aging. Null if not escalated.',
    `failure_reason` STRING COMMENT 'Reason this curative action attempt failed or was rejected, triggering a re-attempt. Null if action was completed successfully. [ENUM-REF-CANDIDATE',
    `initiated_date` DATE COMMENT 'Calendar date on which this curative action was formally initiated or assigned. Used as the start point for curative aging calculations.',
    `instrument_type` STRING COMMENT 'Type of legal instrument or document expected to be obtained or recorded to complete this curative action (e.g., release, satisfaction, reconveyance, affidavit, deed).',
    `is_chain_of_title_break` BOOLEAN COMMENT 'Indicates whether this curative action is addressing a break in the chain of title (COT). Supports chain-of-title break metrics and evidence completeness reporting.',
    `is_gap_cure` BOOLEAN COMMENT 'Indicates whether this curative action specifically addresses a gap period coverage issue between the effective date of the commitment and the recording of the insured instrument.',
    `is_marketable_title_impairment` BOOLEAN COMMENT 'Indicates whether the underlying defect being cured rises to the level of a marketable title impairment, requiring resolution before the transaction can close.',
    `is_sla_breached` BOOLEAN COMMENT 'Indicates whether this curative action has exceeded its SLA target days without completion. True = SLA breached; False = within SLA.',
    `notes` STRING COMMENT 'Free-text operational notes entered by the curative specialist or examiner documenting correspondence, follow-up activity, or special circumstances for this action.',
    `payoff_amount` DECIMAL(18,2) COMMENT 'Dollar amount required to satisfy a lien, mortgage, or judgment as part of this curative action. Applicable for payoff_request and lien_release action types. USD.',
    `payoff_good_through_date` DATE COMMENT 'Expiration date of the payoff quote obtained from the lienholder. After this date, a new payoff demand must be requested. Critical for closing readiness.',
    `priority` STRING COMMENT 'Operational priority assigned to this curative action, used to triage workload and ensure closing-readiness timelines are met.. Valid values are `critical|high|normal|low`',
    `requires_uw_approval` BOOLEAN COMMENT 'Indicates whether this curative action requires formal underwriter approval before the requirement can be marked satisfied. Drives UWR referral rate metrics.',
    `resolution_method` STRING COMMENT 'Method by which this curative action was ultimately resolved (e.g., document obtained and recorded, payoff confirmed, waived by underwriter, insured over).',
    `responsible_party_type` STRING COMMENT 'Classification of the party responsible for fulfilling this curative action (e.g., seller must provide release, buyer must provide affidavit, title company handles recording).. Valid values are `seller|buyer|lender|title_company|attorney|third_party_vendor`',
    `sla_target_days` BIGINT COMMENT 'Contractual or operational SLA target in calendar days for completing this type of curative action. Used to measure curative effectiveness against benchmarks.',
    `source_system_action_code` STRING COMMENT 'Native identifier for this curative action record in the originating title production system (SoftPro, RamQuest, Qualia). Enables reconciliation with the system of record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this curative action record was last modified in the lakehouse Silver layer. Supports change detection and incremental processing.',
    `vendor_name` STRING COMMENT 'Name of the external vendor, attorney, or service provider engaged to perform or facilitate this curative action (e.g., lien release service, probate attorney).',
    `vendor_reference_number` STRING COMMENT 'External reference or tracking number assigned by the vendor or third-party service provider for this curative action. Used for follow-up and reconciliation.',
    `waived_date` DATE COMMENT 'Date on which the underwriter formally waived this curative requirement, allowing the transaction to proceed without full cure. Null if not waived.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_curative_action PRIMARY KEY(`curative_action_id`)
) COMMENT 'Tracks each discrete curative step taken to satisfy an open title_requirement or resolve a title_finding. Each record captures the action type (payoff request, lien release, affidavit of heirship, probate filing, survey correction, GAPcure, CPM memo';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` (
    `underwriting_title_examination_id` BIGINT COMMENT 'Unique surrogate identifier for the title examination record. Primary key for the underwriting_title_examination entity in the Silver layer.',
    `examiner_party_id` BIGINT COMMENT 'Reference to the party record for the licensed title examiner or attorney who performed the examination. Supports examiner identity and workload analytics.',
    `prior_examination_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding examination record for this order. Preserves revision lineage and material lifecycle transitions (VREQ-007).',
    `title_order_id` BIGINT COMMENT 'Reference to the originating title order that triggered this examination. Every examination must trace back to a title order per ALTA workflow standards.',
    `title_search_id` BIGINT COMMENT 'Reference to the title search record whose assembled chain-of-title results are being examined. Examination is legally distinct from search per VREQ-017.',
    `apn` STRING COMMENT 'Assessors Parcel Number (APN) or Parcel Identification Number (PIN) assigned by the county assessor for the subject property. Key cross-reference to property and parcel records.',
    `chain_of_title_break_flag` BOOLEAN COMMENT 'Indicates whether the examiner identified a break or gap in the chain of title (COT) during examination. Key metric for unresolved defect and lien reporting (VREQ-016).',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this examination record was first created in the system. Audit field supporting record provenance and SLA measurement from order intake.',
    `curative_action_required` BOOLEAN COMMENT 'Indicates whether one or more curative processing actions (CPM/GAPcure) are required to clear title defects identified in this examination before commitment issuance.',
    `curative_action_type` STRING COMMENT 'Classification of the primary curative action required (e.g., lien release, reconveyance, satisfaction, gap cure, quiet title). [ENUM-REF-CANDIDATE: lien_release|reconveyance|satisfaction|gap_cure|quiet_title|subordination — promote to reference product]',
    `curative_deadline_date` DATE COMMENT 'Target date by which all curative actions must be completed to meet the scheduled closing date. Supports curative action aging and effectiveness metrics (VREQ-016).',
    `estate_type` STRING COMMENT 'Type of estate or interest in the property being insured as identified during examination: fee simple, leasehold, life estate, or easement. Populates Schedule A of the commitment.. Valid values are `fee_simple|leasehold|life_estate|easement`',
    `examination_completion_timestamp` TIMESTAMP COMMENT 'Precise date and time the examiner finalized the examination and released findings. Used to compute title clearance cycle time and examiner throughput metrics.',
    `examination_date` DATE COMMENT 'Calendar date on which the title examiner completed the formal review of the assembled search results. Principal business event date for cycle-time measurement.',
    `examination_number` STRING COMMENT 'Externally visible alphanumeric identifier assigned to this examination by the title production system (e.g., SoftPro/RamQuest). Used for cross-system traceability.. Valid values are `^EX-[0-9]{4}-[0-9]{6}$`',
    `examination_scope_notes` STRING COMMENT 'Free-text notes describing the scope, limitations, or special conditions of the examination (e.g., limited search period, missing instruments, county plant gaps). Supports evidence provenance.',
    `examination_start_timestamp` TIMESTAMP COMMENT 'Precise date and time the examiner began reviewing the search package. Used with completion timestamp to compute title clearance cycle time (VREQ-016).',
    `examination_status` STRING COMMENT 'Current lifecycle state of the title examination record. Drives workflow routing and closing-readiness metrics. [ENUM-REF-CANDIDATE: pending|in_review|completed|revised|cancelled — promote to reference product if states expand]. Valid values are `pending|in_review|completed|revised|cancelled`',
    `examination_type` STRING COMMENT 'Classification of the scope of examination: full chain-of-title review, limited/O&E, update/bring-down, or gap-period examination. Drives examiner effort and risk assessment.. Valid values are `full|limited|update|bring_down|gap`',
    `examiner_license_number` STRING COMMENT 'State-issued license or bar number of the title examiner or attorney who performed the examination. Required for regulatory compliance and examiner credential verification.',
    `examiner_opinion` STRING COMMENT 'Formal written opinion or summary conclusion of the title examiner regarding the state of title, including any qualifications or conditions. Core evidence and provenance field (VREQ-007).',
    `examiner_state_code` STRING COMMENT 'Two-letter US state code where the examiner is licensed to perform title examinations. Ensures jurisdiction-appropriate examination standards are applied.. Valid values are `^[A-Z]{2}$`',
    `exception_count` BIGINT COMMENT 'Number of Schedule B-II policy exceptions (policy_exception records) identified during examination. Supports owner-versus-lender coverage and exception rate metrics.',
    `finding_count` BIGINT COMMENT 'Total number of title_finding records generated from this examination. Supports open/aging defect metrics and examiner productivity reporting (VREQ-016).',
    `gap_coverage_required` BOOLEAN COMMENT 'Indicates whether gap coverage is required between the search-through date and the anticipated recording date. Triggers gap curative (GAPcure) workflow.',
    `judgment_lien_identified` BOOLEAN COMMENT 'Indicates whether a judgment lien against the vested owner or property was identified during examination. Requires curative clearance before policy issuance.',
    `lien_search_included` BOOLEAN COMMENT 'Indicates whether a lien search (judgment liens, tax liens, mechanics liens, HOA assessments) was included in the examination scope. Affects unresolved lien metrics.',
    `lis_pendens_identified` BOOLEAN COMMENT 'Indicates whether a lis pendens (LP) — notice of pending litigation — was identified against the subject property during examination. Significant underwriting risk factor.',
    `marketable_title_determination` STRING COMMENT 'Examiners determination of title quality: marketable, insurable (with exceptions), uninsurable, or conditional pending curative action. Drives underwriting referral and commitment issuance.. Valid values are `marketable|insurable|uninsurable|conditional`',
    `mechanics_lien_identified` BOOLEAN COMMENT 'Indicates whether a mechanics lien or materialmans lien was identified against the subject property during examination. Common in construction transactions.',
    `open_requirement_count` BIGINT COMMENT 'Number of Schedule B-I title requirements (title_requirement records) that remain open/uncleared at the time of last update. Drives open and aging requirements metric (VREQ-016).',
    `prior_policy_date` DATE COMMENT 'Effective date of the prior owners title policy identified during examination. Used to determine prior policy rate eligibility and search period requirements.',
    `prior_policy_number` STRING COMMENT 'Policy number of any prior owners title policy (OTP) identified during examination. Used for prior policy rate eligibility and evidence of prior insured title.',
    `property_county_fips` STRING COMMENT 'Five-digit FIPS county code for the county in which the subject property is located. Used for county recorder routing, plant access, and jurisdiction-level reporting.. Valid values are `^[0-9]{5}$`',
    `property_state_code` STRING COMMENT 'Two-letter US state code of the subject property being examined. Determines applicable state title law, recording requirements, and underwriting guidelines.. Valid values are `^[A-Z]{2}$`',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this examination record. Increments when the examination is updated due to new search results, curative completions, or examiner corrections. Supports lifecycle history (VREQ-007).',
    `revision_reason` STRING COMMENT 'Reason for revising a prior examination (e.g., updated search results, curative completion, examiner correction, new lien discovered). Supports commitment revision frequency metric (VREQ-016).',
    `search_from_date` DATE COMMENT 'The earliest date from which the chain-of-title search was assembled. Together with search_through_date defines the full search period examined.',
    `search_through_date` DATE COMMENT 'The effective date through which the title search was run and the examiner reviewed. Defines the gap period boundary for gap coverage (GAP) analysis.',
    `source_system_code` STRING COMMENT 'Code identifying the title production system of record from which this examination record originated (e.g., SoftPro Select, RamQuest Horizon, Qualia). Supports data lineage.. Valid values are `softpro|ramquest|qualia|other`',
    `source_system_exam_ref` STRING COMMENT 'Native identifier for this examination record in the originating title production system (SoftPro/RamQuest/Qualia). Enables cross-system reconciliation and audit traceability.',
    `tax_lien_identified` BOOLEAN COMMENT 'Indicates whether a federal or state tax lien was identified against the subject property or vested owner during examination. Triggers curative requirement.',
    `transaction_type` STRING COMMENT 'Type of real-estate transaction driving the examination: purchase, refinance (REFI), home-equity line of credit (HELOC), construction, or commercial. Affects examination scope and underwriting risk.. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `underwriting_referral_reason` STRING COMMENT 'Free-text or coded reason explaining why the examination was escalated for underwriting review (e.g., chain-of-title break, unresolved lien, high-risk vesting). Supports UWR rate analysis.',
    `underwriting_referral_required` BOOLEAN COMMENT 'Indicates whether this examination requires escalation to an underwriter for risk review (UWR). Drives underwriting referral rate metric (VREQ-016).',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this examination record was last modified. Audit field supporting change detection, incremental ETL, and lifecycle history tracking (VREQ-007).',
    `vesting_type` STRING COMMENT 'Form of title vesting identified during examination (e.g., joint tenancy, tenancy in common, community property, sole ownership, trust). Drives Schedule A vesting language.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_underwriting_title_examination PRIMARY KEY(`underwriting_title_examination_id`)
) COMMENT 'SSOT for the title examination record — the formal examiner review of assembled search results that produces title_findings and drives title_requirements. Each record captures examiner identity, examination date, examination type (full, limited';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` (
    `decision_id` BIGINT COMMENT 'Unique surrogate identifier for each discrete underwriting decision record. Primary key for the underwriting_decision entity.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent profile associated with this underwriting decision, when the order was produced through the independent agent channel.',
    `operations_title_examination_id` BIGINT COMMENT 'Foreign key linking to operations.title_examination. Business justification: Underwriting decisions require evidence provenance per VREQ-009. Direct link to operations examination establishes chain-of-custody for title findings and supports underwriting',
    `party_id` BIGINT COMMENT 'Reference to the party record of the underwriter who rendered this decision. Supports UW authority tracking and workload analytics.',
    `prior_decision_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding version of this underwriting decision. Preserves full revision history per VREQ-007.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Underwriting decisions assess insurability of specific properties. Direct property link enables risk analysis by property characteristics, transaction type correlation, and claim frequency',
    `title_commitment_id` BIGINT COMMENT 'Reference to the title commitment associated with this underwriting decision, if the decision was rendered in the context of a commitment issuance or revision.',
    `title_evidence_id` BIGINT COMMENT 'Reference to the primary supporting evidence document in the document management system that substantiates this underwriting decision. Supports evidence provenance per VREQ-007.',
    `title_finding_id` BIGINT COMMENT 'Reference to the specific title finding that is the subject of this underwriting decision, when the decision is finding-specific rather than order-level.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order for which this underwriting decision was rendered. Every underwriting decision must trace back to an originating title order.',
    `uw_referral_id` BIGINT COMMENT 'Reference to the uw_referral event that triggered this underwriting decision. A decision may exist without a referral for routine authority-level approvals.',
    `conditions_imposed` STRING COMMENT 'Free-text description of conditions, requirements, or curative actions imposed by the underwriter as part of a conditional approval. Drives Schedule B-I requirement generation.',
    `cot_break_indicator` BOOLEAN COMMENT 'Indicates whether a chain-of-title break was identified as part of the risk subject to this underwriting decision. Supports chain-of-title break metrics per VREQ-016.',
    `county_fips_code` STRING COMMENT 'Five-digit Federal Information Processing Standards (FIPS) code identifying the county in which the subject property is located. Used for jurisdiction-level risk and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `curative_action_required` BOOLEAN COMMENT 'Indicates whether the underwriting decision mandates one or more curative actions (CPM/GAPcure) before title can be insured or the commitment can be issued.',
    `curative_deadline_date` DATE COMMENT 'Date by which all curative actions mandated by this underwriting decision must be completed. Drives curative aging and SLA breach metrics per VREQ-016.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this decision record. Defaults to USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `decision_date` DATE COMMENT 'Calendar date on which the underwriter rendered the formal decision. Principal business event date for this entity; distinct from the decision timestamp.',
    `decision_number` STRING COMMENT 'Externally visible alphanumeric identifier for this underwriting decision, used in correspondence, commitment schedules, and audit trails. Business-facing reference number.',
    `decision_status` STRING COMMENT 'Current workflow state of the underwriting decision record. Drives commitment issuance eligibility and curative action requirements.. Valid values are `pending|approved|approved_with_conditions|declined|escalated|withdrawn`',
    `decision_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone offset) at which the underwriting decision was recorded in the system. Supports SLA measurement and audit trail requirements.',
    `decision_type` STRING COMMENT 'Classification of the decision rendered. Distinguishes insurable/marketable title determinations from risk acceptances, declinations, and conditional approvals.. Valid values are `insurable_title|marketable_title|risk_acceptance|risk_declination|conditional_approval|exception_approval`',
    `defect_category` STRING COMMENT 'Primary category of title defect or risk that is the subject of this underwriting decision. [ENUM-REF-CANDIDATE: lien|encumbrance|cot_break|gap_period|vesting_defect|easement|encroachment|judgment|tax_lien|mechanics_lien — promote to reference product]',
    `effective_date` DATE COMMENT 'Date from which this underwriting decision is legally effective. Per VREQ-008, kept distinct from decision_date, expiration_date, and revision dates.',
    `endorsement_required` BOOLEAN COMMENT 'Indicates whether the underwriting decision requires issuance of one or more ALTA endorsements as a condition of insuring title.',
    `endorsement_types` STRING COMMENT 'Comma-separated list of ALTA endorsement form numbers required by this decision (e.g., ALTA 9, ALTA 8.1, ALTA 22). Populated when endorsement_required is true.',
    `escalation_count` BIGINT COMMENT 'Number of times this underwriting decision was escalated to a higher authority level. Supports UW referral and exception rate metrics per VREQ-016.',
    `exception_scheduled` BOOLEAN COMMENT 'Indicates whether the underwriting decision resulted in a Schedule B-II exception being carried to the commitment or policy rather than cured.',
    `expiration_date` DATE COMMENT 'Date after which this underwriting decision is no longer valid and must be re-evaluated. Supports commitment expiration and closing readiness tracking.',
    `gap_period_indicator` BOOLEAN COMMENT 'Indicates whether a gap period risk was identified and is subject to this underwriting decision. Supports gap coverage tracking and curative action requirements.',
    `insurable_title_determination` STRING COMMENT 'Formal determination of whether title is insurable as of the decision date. SSOT for insurable title status; distinct from marketable title determination.. Valid values are `insurable|not_insurable|insurable_with_exceptions|pending_curative`',
    `is_exception_approval` BOOLEAN COMMENT 'Indicates whether this decision constitutes a policy exception approval (PE) — an approval granted outside standard underwriting guidelines. Supports UW exception rate metrics.',
    `liability_amount` DECIMAL(18,2) COMMENT 'Total dollar amount of title insurance liability subject to this underwriting decision. Used for authority-level thresholds and risk exposure reporting.',
    `marketable_title_determination` STRING COMMENT 'Formal determination of whether title meets the marketable title standard. Legally distinct from insurable title; both must be tracked per VREQ-007.. Valid values are `marketable|not_marketable|marketable_with_exceptions|pending_curative`',
    `outcome` STRING COMMENT 'The formal outcome of the underwriting review. Distinct from decision_status (workflow state) — this is the substantive risk determination result.. Valid values are `approved|approved_with_conditions|declined|referred_up|deferred`',
    `policy_type_requested` STRING COMMENT 'Indicates whether the underwriting decision covers an Owners Title Policy (OTP), Lenders Title Policy (LTP), or both. Supports owner-versus-lender coverage metrics per VREQ-016.. Valid values are `owner|lender|both`',
    `prior_claim_reference` STRING COMMENT 'Reference number or identifier of any prior title claim on the subject property that influenced this underwriting decision. Supports claim frequency and risk history analysis.',
    `production_channel` STRING COMMENT 'Channel through which the title order was originated, indicating whether the underwriting decision was rendered for a direct branch, centralized lender, or independent agent transaction.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `rationale` STRING COMMENT 'Detailed narrative explanation of the underwriters reasoning, risk analysis, and basis for the decision outcome. Preserved for audit, legal, and regulatory review.',
    `referral_date` DATE COMMENT 'Date on which the underwriting referral or risk matter was submitted to the underwriter for decision. Used to calculate UW turnaround time and referral aging metrics.',
    `referral_trigger_reason` STRING COMMENT 'Narrative or coded reason that caused this matter to require an underwriting decision, e.g., liability threshold exceeded, chain-of-title break, prior claim, gap period.',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this underwriting decision. Increments each time the decision is modified. Supports commitment revision frequency metrics per VREQ-016.',
    `revision_reason` STRING COMMENT 'Narrative explanation for why this underwriting decision was revised from the prior version. Required when revision_number > 1 to preserve material lifecycle transitions per VREQ-007.',
    `risk_category` STRING COMMENT 'Risk tier assigned by the underwriter based on defect severity, lien exposure, chain-of-title integrity, and other risk factors identified during examination.. Valid values are `standard|elevated|high|uninsurable`',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this underwriting decision record originated (e.g., SoftPro, RamQuest, Qualia). Supports data lineage and SoR traceability.',
    `source_system_decision_ref` STRING COMMENT 'Native identifier of this underwriting decision in the originating source system. Enables cross-system reconciliation between the lakehouse and the title production or UW risk system.',
    `state_code` STRING COMMENT 'Two-letter USPS state code for the state in which the subject property is located. Determines applicable state insurance regulations and underwriting guidelines.. Valid values are `^[A-Z]{2}$`',
    `transaction_type` STRING COMMENT 'Type of real estate transaction for which the underwriting decision was rendered. Drives applicable risk standards and policy form selection.. Valid values are `purchase|refinance|heloc|construction|commercial|home_equity`',
    `underwriter_notes` STRING COMMENT 'Supplemental free-text notes entered by the underwriter, distinct from the formal decision rationale. May include internal guidance, caveats, or follow-up instructions.',
    `uw_authority_level` STRING COMMENT 'Authority tier at which this decision was rendered. Tracks escalation path and ensures decisions are within the underwriters delegated authority limits.. Valid values are `examiner|branch_underwriter|regional_underwriter|chief_underwriter|underwriter_counsel`',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_decision PRIMARY KEY(`decision_id`)
) COMMENT 'SSOT for discrete underwriting decisions and the AUTHORITATIVE insurable/marketable-title determination — the formal risk-acceptance determinations made by an underwriter, kept distinct from the uw_referral event that may trigger them and from the';

-- ========= FOREIGN KEYS =========
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ADD CONSTRAINT `fk_underwriting_title_requirement_prior_requirement_title_requirement_id` FOREIGN KEY (`prior_requirement_title_requirement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement`(`title_requirement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ADD CONSTRAINT `fk_underwriting_title_requirement_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ADD CONSTRAINT `fk_underwriting_title_requirement_title_finding_id` FOREIGN KEY (`title_finding_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`(`title_finding_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ADD CONSTRAINT `fk_underwriting_title_requirement_uw_referral_id` FOREIGN KEY (`uw_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ADD CONSTRAINT `fk_underwriting_policy_exception_prior_exception_policy_exception_id` FOREIGN KEY (`prior_exception_policy_exception_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception`(`policy_exception_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ADD CONSTRAINT `fk_underwriting_policy_exception_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ADD CONSTRAINT `fk_underwriting_policy_exception_title_finding_id` FOREIGN KEY (`title_finding_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`(`title_finding_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ADD CONSTRAINT `fk_underwriting_policy_exception_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ADD CONSTRAINT `fk_underwriting_title_commitment_prior_commitment_title_commitment_id` FOREIGN KEY (`prior_commitment_title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ADD CONSTRAINT `fk_underwriting_title_policy_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ADD CONSTRAINT `fk_underwriting_endorsement_superseded_by_endorsement_id` FOREIGN KEY (`superseded_by_endorsement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement`(`endorsement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ADD CONSTRAINT `fk_underwriting_endorsement_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_policy_exception_id` FOREIGN KEY (`policy_exception_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception`(`policy_exception_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_prior_referral_id` FOREIGN KEY (`prior_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_title_finding_id` FOREIGN KEY (`title_finding_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`(`title_finding_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_underwriting_title_examination_id` FOREIGN KEY (`underwriting_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination`(`underwriting_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_decision_id` FOREIGN KEY (`decision_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision`(`decision_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_prior_action_id` FOREIGN KEY (`prior_action_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action`(`curative_action_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_title_finding_id` FOREIGN KEY (`title_finding_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`(`title_finding_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_title_requirement_id` FOREIGN KEY (`title_requirement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement`(`title_requirement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_uw_referral_id` FOREIGN KEY (`uw_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ADD CONSTRAINT `fk_underwriting_underwriting_title_examination_prior_examination_id` FOREIGN KEY (`prior_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination`(`underwriting_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_prior_decision_id` FOREIGN KEY (`prior_decision_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision`(`decision_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_title_finding_id` FOREIGN KEY (`title_finding_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`(`title_finding_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_uw_referral_id` FOREIGN KEY (`uw_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);

-- ========= TAGS =========
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_underwriting` SET TAGS ('title_division' = 'operations');
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_underwriting` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` SET TAGS ('title_subdomain' = 'risk_assessment');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `operations_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Examiner ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `title_evidence_id` SET TAGS ('title_business_glossary_term' = 'Evidence Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `title_search_id` SET TAGS ('title_business_glossary_term' = 'Title Search ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `affects_full_parcel` SET TAGS ('title_business_glossary_term' = 'Affects Full Parcel Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `book_volume` SET TAGS ('title_business_glossary_term' = 'Book/Volume');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `cleared_date` SET TAGS ('title_business_glossary_term' = 'Cleared Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `cot_break_indicator` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `curative_action_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `curative_deadline_date` SET TAGS ('title_business_glossary_term' = 'Curative Deadline Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `curative_notes` SET TAGS ('title_business_glossary_term' = 'Curative Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `discovery_date` SET TAGS ('title_business_glossary_term' = 'Discovery Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `document_number` SET TAGS ('title_business_glossary_term' = 'Document Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `finding_description` SET TAGS ('title_business_glossary_term' = 'Finding Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `finding_number` SET TAGS ('title_business_glossary_term' = 'Finding Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `finding_status` SET TAGS ('title_business_glossary_term' = 'Finding Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `finding_status` SET TAGS ('title_value_regex' = 'open|in_cure|cleared|excepted|waived|escalated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `finding_type` SET TAGS ('title_business_glossary_term' = 'Finding Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `gap_period_indicator` SET TAGS ('title_business_glossary_term' = 'Gap Period Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `instrument_date` SET TAGS ('title_business_glossary_term' = 'Instrument Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `instrument_type` SET TAGS ('title_business_glossary_term' = 'Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `is_active` SET TAGS ('title_business_glossary_term' = 'Active Record Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `lien_amount` SET TAGS ('title_business_glossary_term' = 'Lien Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `lien_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `lien_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `lien_amount_currency` SET TAGS ('title_business_glossary_term' = 'Lien Amount Currency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `lien_amount_currency` SET TAGS ('title_value_regex' = 'USD');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `lien_priority` SET TAGS ('title_business_glossary_term' = 'Lien Priority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `partial_area_description` SET TAGS ('title_business_glossary_term' = 'Partial Area Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `prior_classification` SET TAGS ('title_business_glossary_term' = 'Prior Classification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `reclassification_date` SET TAGS ('title_business_glossary_term' = 'Reclassification Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `reclassification_reason` SET TAGS ('title_business_glossary_term' = 'Reclassification Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `risk_classification` SET TAGS ('title_business_glossary_term' = 'Risk Classification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `risk_classification` SET TAGS ('title_value_regex' = 'insurable|uninsurable|marketable|unmarketable|curative_required|referral_required');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `schedule_b_disposition` SET TAGS ('title_business_glossary_term' = 'Schedule B Disposition');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `schedule_b_disposition` SET TAGS ('title_value_regex' = 'requirement|exception|waived|informational');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `severity` SET TAGS ('title_business_glossary_term' = 'Finding Severity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `severity` SET TAGS ('title_value_regex' = 'critical|major|minor|informational');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `source_system_code` SET TAGS ('title_value_regex' = 'softpro|ramquest|qualia|titlepoint|datatrace|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `source_system_finding_ref` SET TAGS ('title_business_glossary_term' = 'Source System Finding Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `uw_referral_required` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` SET TAGS ('title_subdomain' = 'risk_assessment');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `title_requirement_id` SET TAGS ('title_business_glossary_term' = 'Title Requirement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `operations_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `prior_requirement_title_requirement_id` SET TAGS ('title_business_glossary_term' = 'Prior Requirement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `title_search_id` SET TAGS ('title_business_glossary_term' = 'Title Search Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `added_to_commitment_date` SET TAGS ('title_business_glossary_term' = 'Added to Commitment Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `applies_to_policy_type` SET TAGS ('title_business_glossary_term' = 'Applies to Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `applies_to_policy_type` SET TAGS ('title_value_regex' = 'owner|lender|both');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `assigned_curative_processor` SET TAGS ('title_business_glossary_term' = 'Assigned Curative Processor');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `commitment_schedule_section` SET TAGS ('title_business_glossary_term' = 'Commitment Schedule Section');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `commitment_schedule_section` SET TAGS ('title_value_regex' = 'schedule_b_i|schedule_a');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `confirmed_payoff_amount` SET TAGS ('title_business_glossary_term' = 'Confirmed Payoff Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `confirmed_payoff_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `confirmed_payoff_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `curative_action_type` SET TAGS ('title_business_glossary_term' = 'Curative Processing Memo (CPM) Action Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `curative_memo_reference` SET TAGS ('title_business_glossary_term' = 'Curative Processing Memo (CPM) Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `due_date` SET TAGS ('title_business_glossary_term' = 'Requirement Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `estimated_payoff_amount` SET TAGS ('title_business_glossary_term' = 'Estimated Payoff Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `estimated_payoff_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `estimated_payoff_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `evidence_document_reference` SET TAGS ('title_business_glossary_term' = 'Evidence Document Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `gap_coverage_required` SET TAGS ('title_business_glossary_term' = 'Gap Coverage (GAP) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `identified_date` SET TAGS ('title_business_glossary_term' = 'Requirement Identified Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `instrument_reference` SET TAGS ('title_business_glossary_term' = 'Instrument Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `is_active_version` SET TAGS ('title_business_glossary_term' = 'Is Active Version Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `is_closing_condition` SET TAGS ('title_business_glossary_term' = 'Is Closing Condition Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `is_underwriter_referral` SET TAGS ('title_business_glossary_term' = 'Is Underwriter Referral (UWR) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `lien_type` SET TAGS ('title_business_glossary_term' = 'Lien Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Requirement Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `payoff_good_through_date` SET TAGS ('title_business_glossary_term' = 'Payoff Good-Through Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `priority_level` SET TAGS ('title_business_glossary_term' = 'Priority Level');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `priority_level` SET TAGS ('title_value_regex' = 'critical|high|standard|low');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `recording_reference` SET TAGS ('title_business_glossary_term' = 'Recording Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `requirement_category` SET TAGS ('title_business_glossary_term' = 'Requirement Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `requirement_description` SET TAGS ('title_business_glossary_term' = 'Requirement Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `requirement_number` SET TAGS ('title_business_glossary_term' = 'Requirement Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `requirement_source` SET TAGS ('title_business_glossary_term' = 'Requirement Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `requirement_source` SET TAGS ('title_value_regex' = 'examiner|underwriter|lender|automated_search|curative_processor');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `requirement_status` SET TAGS ('title_business_glossary_term' = 'Requirement Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `requirement_status` SET TAGS ('title_value_regex' = 'open|in_progress|satisfied|waived|deferred|cancelled');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `requirement_type` SET TAGS ('title_business_glossary_term' = 'Requirement Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `responsible_party_role` SET TAGS ('title_business_glossary_term' = 'Responsible Party Role');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `satisfaction_date` SET TAGS ('title_business_glossary_term' = 'Requirement Satisfaction Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `satisfaction_method` SET TAGS ('title_business_glossary_term' = 'Satisfaction Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `source_system_requirement_code` SET TAGS ('title_business_glossary_term' = 'Source System Requirement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `waiver_authority` SET TAGS ('title_business_glossary_term' = 'Waiver Authority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `waiver_date` SET TAGS ('title_business_glossary_term' = 'Requirement Waiver Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `waiver_reason` SET TAGS ('title_business_glossary_term' = 'Waiver Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` SET TAGS ('title_subdomain' = 'risk_assessment');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `policy_exception_id` SET TAGS ('title_business_glossary_term' = 'Policy Exception (PE) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Title Examiner ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `prior_exception_policy_exception_id` SET TAGS ('title_business_glossary_term' = 'Prior Exception ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `title_evidence_id` SET TAGS ('title_business_glossary_term' = 'Evidence Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `added_date` SET TAGS ('title_business_glossary_term' = 'Exception Added Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `affects_description` SET TAGS ('title_business_glossary_term' = 'Affects Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `carried_to_policy_date` SET TAGS ('title_business_glossary_term' = 'Carried to Policy Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `commitment_revision_number` SET TAGS ('title_business_glossary_term' = 'Commitment Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `commitment_schedule_section` SET TAGS ('title_business_glossary_term' = 'Commitment Schedule Section');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `commitment_schedule_section` SET TAGS ('title_value_regex' = 'schedule_b_ii|schedule_b_i');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `curative_action_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `curative_action_status` SET TAGS ('title_business_glossary_term' = 'Curative Action Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `curative_action_status` SET TAGS ('title_value_regex' = 'not_required|pending|in_progress|completed|failed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `curative_completion_date` SET TAGS ('title_business_glossary_term' = 'Curative Completion Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `deleted_date` SET TAGS ('title_business_glossary_term' = 'Exception Deleted Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `endorsement_available` SET TAGS ('title_business_glossary_term' = 'Endorsement Available Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `endorsement_type` SET TAGS ('title_business_glossary_term' = 'ALTA Endorsement Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `exception_number` SET TAGS ('title_business_glossary_term' = 'Schedule B-II Exception Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `exception_status` SET TAGS ('title_business_glossary_term' = 'Policy Exception Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `exception_status` SET TAGS ('title_value_regex' = 'open|deleted|carried_to_policy|waived|subordinated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `exception_text` SET TAGS ('title_business_glossary_term' = 'Schedule B-II Exception Text');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `exception_type` SET TAGS ('title_business_glossary_term' = 'Policy Exception Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `gap_coverage_applicable` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `is_deleted` SET TAGS ('title_business_glossary_term' = 'Is Deleted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `is_standard_exception` SET TAGS ('title_business_glossary_term' = 'Is Standard Exception Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `is_survey_exception` SET TAGS ('title_business_glossary_term' = 'Is Survey Exception Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `lien_amount` SET TAGS ('title_business_glossary_term' = 'Lien Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `lien_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `lien_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `lien_amount_currency` SET TAGS ('title_business_glossary_term' = 'Lien Amount Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `lien_amount_currency` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'owner|lender|both');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `priority_position` SET TAGS ('title_business_glossary_term' = 'Lien Priority Position');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Source Instrument Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Exception Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `revision_reason` SET TAGS ('title_value_regex' = 'initial|curative_update|underwriter_waiver|endorsement_added|commitment_revision|error_correction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `source_instrument_date` SET TAGS ('title_business_glossary_term' = 'Source Instrument Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `source_instrument_reference` SET TAGS ('title_business_glossary_term' = 'Source Instrument Recording Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `source_instrument_type` SET TAGS ('title_business_glossary_term' = 'Source Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `source_system_exception_code` SET TAGS ('title_business_glossary_term' = 'Source System Exception ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `standard_exception_code` SET TAGS ('title_business_glossary_term' = 'Standard Exception Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `underwriter_notes` SET TAGS ('title_business_glossary_term' = 'Underwriter Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `underwriting_decision` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `underwriting_decision` SET TAGS ('title_value_regex' = 'insure_over|take_exception|delete|refer_to_underwriter|waive');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `underwriting_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` SET TAGS ('title_subdomain' = 'policy_issuance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Issuing Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `operations_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Examining Attorney or Examiner ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `prior_commitment_title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Prior Commitment Version ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `underwriter_id` SET TAGS ('title_business_glossary_term' = 'Underwriter Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Production Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `closing_date_actual` SET TAGS ('title_business_glossary_term' = 'Actual Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `closing_date_scheduled` SET TAGS ('title_business_glossary_term' = 'Scheduled Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `closing_protection_letter_flag` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `commitment_number` SET TAGS ('title_business_glossary_term' = 'Commitment Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `commitment_status` SET TAGS ('title_business_glossary_term' = 'Commitment Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `commitment_type` SET TAGS ('title_business_glossary_term' = 'Commitment Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `commitment_type` SET TAGS ('title_value_regex' = 'purchase|refinance|home_equity|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County FIPS Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `cpl_issue_date` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issue Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Commitment Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `estate_type` SET TAGS ('title_business_glossary_term' = 'Estate or Interest Type (Schedule A)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `estate_type` SET TAGS ('title_value_regex' = 'fee_simple|leasehold|easement|life_estate|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Commitment Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `gap_coverage_flag` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `insurable_title_determination` SET TAGS ('title_business_glossary_term' = 'Insurable Title Determination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `insurable_title_determination` SET TAGS ('title_value_regex' = 'insurable|insurable_with_exceptions|not_insurable|pending');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `issue_date` SET TAGS ('title_business_glossary_term' = 'Commitment Issue Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `loan_policy_amount` SET TAGS ('title_business_glossary_term' = 'Loan Policy Liability Amount (LTP)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `loan_premium_amount` SET TAGS ('title_business_glossary_term' = 'Loan Policy Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `marketable_title_flag` SET TAGS ('title_business_glossary_term' = 'Marketable Title Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `open_exceptions_count` SET TAGS ('title_business_glossary_term' = 'Open Exceptions Count (Schedule B-II)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `open_requirements_count` SET TAGS ('title_business_glossary_term' = 'Open Requirements Count (Schedule B-I)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `owner_policy_amount` SET TAGS ('title_business_glossary_term' = 'Owner Policy Liability Amount (OTP)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `owner_premium_amount` SET TAGS ('title_business_glossary_term' = 'Owner Policy Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `policy_form_code` SET TAGS ('title_business_glossary_term' = 'Policy Form Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `proposed_insured_lender` SET TAGS ('title_business_glossary_term' = 'Proposed Insured Lender (Schedule A)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `proposed_insured_lender` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `proposed_insured_owner` SET TAGS ('title_business_glossary_term' = 'Proposed Insured Owner (Schedule A)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `proposed_insured_owner` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `purchase_price` SET TAGS ('title_business_glossary_term' = 'Purchase Price');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `rate_schedule_code` SET TAGS ('title_business_glossary_term' = 'Rate Schedule Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `reissue_rate_flag` SET TAGS ('title_business_glossary_term' = 'Reissue Rate Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `revision_date` SET TAGS ('title_business_glossary_term' = 'Commitment Revision Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Commitment Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Commitment Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `schedule_a_notes` SET TAGS ('title_business_glossary_term' = 'Schedule A Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `simultaneous_issue_flag` SET TAGS ('title_business_glossary_term' = 'Simultaneous Issue Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `source_system_commitment_ref` SET TAGS ('title_business_glossary_term' = 'Source System Commitment Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code (FIPS)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `underwriting_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` SET TAGS ('title_subdomain' = 'policy_issuance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Issuing Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `originating_title_order_id` SET TAGS ('title_business_glossary_term' = 'Originating Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `agent_premium_split_amount` SET TAGS ('title_business_glossary_term' = 'Agent Premium Split Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `cancellation_date` SET TAGS ('title_business_glossary_term' = 'Policy Cancellation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `cancellation_reason` SET TAGS ('title_business_glossary_term' = 'Policy Cancellation Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `cancellation_reason` SET TAGS ('title_value_regex' = 'transaction_cancelled|duplicate_policy|underwriting_declined|insured_request|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `companion_policy_number` SET TAGS ('title_business_glossary_term' = 'Companion Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County FIPS Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^d{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Policy Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `effective_time` SET TAGS ('title_business_glossary_term' = 'Policy Effective Time');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `endorsement_count` SET TAGS ('title_business_glossary_term' = 'Endorsement Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `estate_or_interest` SET TAGS ('title_business_glossary_term' = 'Estate or Interest Insured');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `estate_or_interest` SET TAGS ('title_value_regex' = 'fee_simple|leasehold|easement|life_estate|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Policy Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `gap_coverage_flag` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `insurable_title_flag` SET TAGS ('title_business_glossary_term' = 'Insurable Title Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `insured_name` SET TAGS ('title_business_glossary_term' = 'Insured Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `insured_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `insured_type` SET TAGS ('title_business_glossary_term' = 'Insured Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `insured_type` SET TAGS ('title_value_regex' = 'individual|entity|trust|estate|government');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `issue_date` SET TAGS ('title_business_glossary_term' = 'Policy Issue Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `lender_name` SET TAGS ('title_business_glossary_term' = 'Lender Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `liability_amount` SET TAGS ('title_business_glossary_term' = 'Policy Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `loan_number` SET TAGS ('title_business_glossary_term' = 'Loan Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `marketable_title_flag` SET TAGS ('title_business_glossary_term' = 'Marketable Title Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `net_premium_amount` SET TAGS ('title_business_glossary_term' = 'Net Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `policy_exception_count` SET TAGS ('title_business_glossary_term' = 'Policy Exception Count (Schedule B-II)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `policy_form_code` SET TAGS ('title_business_glossary_term' = 'Policy Form Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `policy_issuance_lag_days` SET TAGS ('title_business_glossary_term' = 'Policy Issuance Lag Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `policy_number` SET TAGS ('title_business_glossary_term' = 'Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `policy_status` SET TAGS ('title_business_glossary_term' = 'Policy Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `policy_status` SET TAGS ('title_value_regex' = 'draft|issued|cancelled|suspended|reissued');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type (OTP/LTP)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'OTP|LTP');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `premium_amount` SET TAGS ('title_business_glossary_term' = 'Title Insurance Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `prior_policy_date` SET TAGS ('title_business_glossary_term' = 'Prior Policy Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `prior_policy_number` SET TAGS ('title_business_glossary_term' = 'Prior Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `production_channel` SET TAGS ('title_business_glossary_term' = 'Production Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `production_channel` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Insured Instrument Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `reissue_credit_amount` SET TAGS ('title_business_glossary_term' = 'Reissue Credit Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `reissue_flag` SET TAGS ('title_business_glossary_term' = 'Reissue Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `remittance_date` SET TAGS ('title_business_glossary_term' = 'Remittance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `remittance_due_date` SET TAGS ('title_business_glossary_term' = 'Remittance Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `remittance_status` SET TAGS ('title_business_glossary_term' = 'Premium Remittance Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `remittance_status` SET TAGS ('title_value_regex' = 'pending|remitted|overdue|waived');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `simultaneous_issue_flag` SET TAGS ('title_business_glossary_term' = 'Simultaneous Issue Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `source_system_policy_ref` SET TAGS ('title_business_glossary_term' = 'Source System Policy Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|home_equity|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `underwriter_code` SET TAGS ('title_business_glossary_term' = 'Underwriter Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `underwriter_premium_split_amount` SET TAGS ('title_business_glossary_term' = 'Underwriter Premium Split Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `underwriting_referral_flag` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral Flag (UWR)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` SET TAGS ('title_subdomain' = 'policy_issuance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `endorsement_id` SET TAGS ('title_business_glossary_term' = 'Endorsement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Issuing Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `superseded_by_endorsement_id` SET TAGS ('title_business_glossary_term' = 'Superseded By Endorsement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `additional_premium_amount` SET TAGS ('title_business_glossary_term' = 'Endorsement Additional Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `additional_premium_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `additional_premium_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `agent_premium_split_pct` SET TAGS ('title_business_glossary_term' = 'Agent Premium Split Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `agent_premium_split_pct` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `alta_form_number` SET TAGS ('title_business_glossary_term' = 'American Land Title Association (ALTA) Endorsement Form Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `cancellation_date` SET TAGS ('title_business_glossary_term' = 'Endorsement Cancellation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `cancellation_reason` SET TAGS ('title_business_glossary_term' = 'Endorsement Cancellation Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `cancellation_reason` SET TAGS ('title_value_regex' = 'underwriter_withdrawal|insured_request|policy_cancelled|superseded_by_revision|error_correction|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `coverage_category` SET TAGS ('title_business_glossary_term' = 'Endorsement Coverage Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `endorsement_description` SET TAGS ('title_business_glossary_term' = 'Endorsement Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `document_image_ref` SET TAGS ('title_business_glossary_term' = 'Endorsement Document Image Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Endorsement Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `electronic_delivery` SET TAGS ('title_business_glossary_term' = 'Electronic Delivery Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `endorsement_status` SET TAGS ('title_business_glossary_term' = 'Endorsement Lifecycle Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `endorsement_status` SET TAGS ('title_value_regex' = 'draft|issued|cancelled|superseded|pending_approval');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `endorsement_type` SET TAGS ('title_business_glossary_term' = 'Endorsement Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `endorsement_type` SET TAGS ('title_value_regex' = 'owner|lender|both');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Endorsement Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `gl_account_code` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `issuance_date` SET TAGS ('title_business_glossary_term' = 'Endorsement Issuance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `issuing_officer_name` SET TAGS ('title_business_glossary_term' = 'Issuing Officer Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `issuing_underwriter_code` SET TAGS ('title_business_glossary_term' = 'Issuing Underwriter Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `liability_amount` SET TAGS ('title_business_glossary_term' = 'Endorsement Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `liability_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `liability_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `endorsement_name` SET TAGS ('title_business_glossary_term' = 'Endorsement Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Endorsement Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `number` SET TAGS ('title_business_glossary_term' = 'Endorsement Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `number` SET TAGS ('title_value_regex' = '^END-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `premium_basis` SET TAGS ('title_business_glossary_term' = 'Endorsement Premium Basis');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `premium_basis` SET TAGS ('title_value_regex' = 'flat_fee|rate_per_thousand|percentage_of_liability|no_charge');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `prior_endorsement_id` SET TAGS ('title_business_glossary_term' = 'Prior Endorsement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `production_channel` SET TAGS ('title_business_glossary_term' = 'Production Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `production_channel` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `remittance_date` SET TAGS ('title_business_glossary_term' = 'Endorsement Remittance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `remittance_included` SET TAGS ('title_business_glossary_term' = 'Remittance Included Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Endorsement Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `source_system_code` SET TAGS ('title_value_regex' = 'softpro|ramquest|qualia|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `source_system_endorsement_ref` SET TAGS ('title_business_glossary_term' = 'Source System Endorsement Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|home_equity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `underwriter_premium_split_pct` SET TAGS ('title_business_glossary_term' = 'Underwriter Premium Split Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `underwriter_premium_split_pct` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `underwriting_conditions` SET TAGS ('title_business_glossary_term' = 'Underwriting Conditions');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `underwriting_decision` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `underwriting_decision` SET TAGS ('title_value_regex' = 'approved|approved_with_conditions|declined|pending');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `underwriting_referral_required` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` SET TAGS ('title_subdomain' = 'risk_assessment');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Independent Agent (Agency) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `policy_exception_id` SET TAGS ('title_business_glossary_term' = 'Policy Exception (Schedule B-II) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `prior_referral_id` SET TAGS ('title_business_glossary_term' = 'Prior Underwriting Referral ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `underwriting_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `uw_assigned_underwriter_party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Underwriter ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `uw_party_id` SET TAGS ('title_business_glossary_term' = 'Referring Title Examiner ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `channel` SET TAGS ('title_business_glossary_term' = 'Production Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `channel` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `closing_date_impact` SET TAGS ('title_business_glossary_term' = 'Closing Date Impact Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `conditions_imposed` SET TAGS ('title_business_glossary_term' = 'Underwriting Conditions Imposed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `curative_action_description` SET TAGS ('title_business_glossary_term' = 'Curative Action Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `curative_action_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `curative_completed_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Completed Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `curative_deadline_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Deadline Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `defect_description` SET TAGS ('title_business_glossary_term' = 'Title Defect Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `endorsement_required` SET TAGS ('title_business_glossary_term' = 'ALTA Endorsement Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `endorsement_types` SET TAGS ('title_business_glossary_term' = 'ALTA Endorsement Types Required');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `escalation_count` SET TAGS ('title_business_glossary_term' = 'Escalation Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `exception_scheduled` SET TAGS ('title_business_glossary_term' = 'Policy Exception Scheduled Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `gap_period_end_date` SET TAGS ('title_business_glossary_term' = 'Gap Period End Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `gap_period_start_date` SET TAGS ('title_business_glossary_term' = 'Gap Period Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `insurable_title_determination` SET TAGS ('title_business_glossary_term' = 'Insurable/Marketable Title Determination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `insurable_title_determination` SET TAGS ('title_value_regex' = 'insurable|marketable|insurable_with_exceptions|not_insurable|pending');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `liability_amount` SET TAGS ('title_business_glossary_term' = 'Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `liability_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `liability_threshold_exceeded` SET TAGS ('title_business_glossary_term' = 'Liability Threshold Exceeded Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `policy_type_requested` SET TAGS ('title_business_glossary_term' = 'Policy Type Requested');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `policy_type_requested` SET TAGS ('title_value_regex' = 'owner|lender|both');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `prior_claim_reference` SET TAGS ('title_business_glossary_term' = 'Prior Claim Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `referral_date` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `referral_number` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `referral_number` SET TAGS ('title_value_regex' = '^UWR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `referral_status` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `referral_status` SET TAGS ('title_value_regex' = 'open|pending_uw_review|approved|approved_with_conditions|declined|withdrawn');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `referral_timestamp` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `referral_trigger_reason` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral Trigger Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `referral_type` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Referral Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `risk_category` SET TAGS ('title_business_glossary_term' = 'Title Risk Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `sla_breach` SET TAGS ('title_business_glossary_term' = 'Underwriting SLA Breach Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `sla_target_days` SET TAGS ('title_business_glossary_term' = 'Underwriting Review Service Level Agreement (SLA) Target Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `source_system_ref` SET TAGS ('title_business_glossary_term' = 'Source System Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|home_equity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `uw_authority_level` SET TAGS ('title_business_glossary_term' = 'Underwriting Authority Level');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `uw_authority_level` SET TAGS ('title_value_regex' = 'branch|regional|national|reinsurance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `uw_decision` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `uw_decision` SET TAGS ('title_value_regex' = 'approved|approved_with_conditions|declined|deferred');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `uw_decision_date` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `uw_decision_rationale` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Rationale');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` SET TAGS ('title_subdomain' = 'risk_assessment');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `curative_action_id` SET TAGS ('title_business_glossary_term' = 'Curative Action ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `assigned_party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `decision_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `operations_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `prior_action_id` SET TAGS ('title_business_glossary_term' = 'Prior Curative Action ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `title_evidence_id` SET TAGS ('title_business_glossary_term' = 'Curative Evidence Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `title_requirement_id` SET TAGS ('title_business_glossary_term' = 'Title Requirement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `action_number` SET TAGS ('title_business_glossary_term' = 'Curative Action Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `action_number` SET TAGS ('title_value_regex' = '^CA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `action_status` SET TAGS ('title_business_glossary_term' = 'Curative Action Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `action_subtype` SET TAGS ('title_business_glossary_term' = 'Curative Action Subtype');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `action_type` SET TAGS ('title_business_glossary_term' = 'Curative Action Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `attempt_number` SET TAGS ('title_business_glossary_term' = 'Curative Attempt Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `completed_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Completed Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `curative_cost` SET TAGS ('title_business_glossary_term' = 'Curative Action Cost');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `curative_cost` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `days_open` SET TAGS ('title_business_glossary_term' = 'Curative Action Days Open');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `defect_category` SET TAGS ('title_business_glossary_term' = 'Title Defect Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `due_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `escalated_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Escalated Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `failure_reason` SET TAGS ('title_business_glossary_term' = 'Curative Action Failure Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `initiated_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Initiated Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `instrument_type` SET TAGS ('title_business_glossary_term' = 'Curative Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `is_chain_of_title_break` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `is_gap_cure` SET TAGS ('title_business_glossary_term' = 'Gap Cure (GAPcure) Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `is_marketable_title_impairment` SET TAGS ('title_business_glossary_term' = 'Marketable Title Impairment Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `is_sla_breached` SET TAGS ('title_business_glossary_term' = 'Curative Action Service Level Agreement (SLA) Breach Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Curative Action Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `payoff_amount` SET TAGS ('title_business_glossary_term' = 'Curative Payoff Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `payoff_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `payoff_good_through_date` SET TAGS ('title_business_glossary_term' = 'Payoff Good-Through Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `priority` SET TAGS ('title_business_glossary_term' = 'Curative Action Priority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `priority` SET TAGS ('title_value_regex' = 'critical|high|normal|low');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `requires_uw_approval` SET TAGS ('title_business_glossary_term' = 'Requires Underwriting (UW) Approval Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `resolution_method` SET TAGS ('title_business_glossary_term' = 'Curative Resolution Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `responsible_party_type` SET TAGS ('title_business_glossary_term' = 'Curative Responsible Party Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `responsible_party_type` SET TAGS ('title_value_regex' = 'seller|buyer|lender|title_company|attorney|third_party_vendor');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `sla_target_days` SET TAGS ('title_business_glossary_term' = 'Curative Action Service Level Agreement (SLA) Target Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `source_system_action_code` SET TAGS ('title_business_glossary_term' = 'Source System Curative Action ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `vendor_name` SET TAGS ('title_business_glossary_term' = 'Curative Vendor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `vendor_reference_number` SET TAGS ('title_business_glossary_term' = 'Curative Vendor Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `waived_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Waived Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` SET TAGS ('title_subdomain' = 'risk_assessment');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `underwriting_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Title Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examiner_party_id` SET TAGS ('title_business_glossary_term' = 'Examiner Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `prior_examination_id` SET TAGS ('title_business_glossary_term' = 'Prior Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `title_search_id` SET TAGS ('title_business_glossary_term' = 'Title Search ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `chain_of_title_break_flag` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `curative_action_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `curative_action_type` SET TAGS ('title_business_glossary_term' = 'Curative Action Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `curative_deadline_date` SET TAGS ('title_business_glossary_term' = 'Curative Deadline Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `estate_type` SET TAGS ('title_business_glossary_term' = 'Estate Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `estate_type` SET TAGS ('title_value_regex' = 'fee_simple|leasehold|life_estate|easement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_completion_timestamp` SET TAGS ('title_business_glossary_term' = 'Examination Completion Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_date` SET TAGS ('title_business_glossary_term' = 'Examination Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_number` SET TAGS ('title_business_glossary_term' = 'Examination Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_number` SET TAGS ('title_value_regex' = '^EX-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_scope_notes` SET TAGS ('title_business_glossary_term' = 'Examination Scope Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_start_timestamp` SET TAGS ('title_business_glossary_term' = 'Examination Start Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_status` SET TAGS ('title_business_glossary_term' = 'Examination Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_status` SET TAGS ('title_value_regex' = 'pending|in_review|completed|revised|cancelled');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_type` SET TAGS ('title_business_glossary_term' = 'Examination Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examination_type` SET TAGS ('title_value_regex' = 'full|limited|update|bring_down|gap');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examiner_license_number` SET TAGS ('title_business_glossary_term' = 'Examiner License Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examiner_license_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examiner_opinion` SET TAGS ('title_business_glossary_term' = 'Examiner Opinion');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examiner_state_code` SET TAGS ('title_business_glossary_term' = 'Examiner State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `examiner_state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `exception_count` SET TAGS ('title_business_glossary_term' = 'Policy Exception Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `finding_count` SET TAGS ('title_business_glossary_term' = 'Title Finding Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `gap_coverage_required` SET TAGS ('title_business_glossary_term' = 'Gap Coverage (GAP) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `judgment_lien_identified` SET TAGS ('title_business_glossary_term' = 'Judgment Lien Identified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `lien_search_included` SET TAGS ('title_business_glossary_term' = 'Lien Search Included Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `lis_pendens_identified` SET TAGS ('title_business_glossary_term' = 'Lis Pendens (LP) Identified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `marketable_title_determination` SET TAGS ('title_business_glossary_term' = 'Marketable Title Determination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `marketable_title_determination` SET TAGS ('title_value_regex' = 'marketable|insurable|uninsurable|conditional');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `mechanics_lien_identified` SET TAGS ('title_business_glossary_term' = 'Mechanics Lien Identified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `open_requirement_count` SET TAGS ('title_business_glossary_term' = 'Open Requirement Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `prior_policy_date` SET TAGS ('title_business_glossary_term' = 'Prior Policy Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `prior_policy_number` SET TAGS ('title_business_glossary_term' = 'Prior Owner Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `property_county_fips` SET TAGS ('title_business_glossary_term' = 'Property County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `property_county_fips` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `property_state_code` SET TAGS ('title_business_glossary_term' = 'Property State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `property_state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Examination Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Examination Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `search_from_date` SET TAGS ('title_business_glossary_term' = 'Search From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `search_through_date` SET TAGS ('title_business_glossary_term' = 'Search Through Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `source_system_code` SET TAGS ('title_value_regex' = 'softpro|ramquest|qualia|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `source_system_exam_ref` SET TAGS ('title_business_glossary_term' = 'Source System Examination Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `tax_lien_identified` SET TAGS ('title_business_glossary_term' = 'Tax Lien Identified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `underwriting_referral_reason` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `underwriting_referral_required` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `vesting_type` SET TAGS ('title_business_glossary_term' = 'Vesting Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` SET TAGS ('title_domain' = 'underwriting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` SET TAGS ('title_subdomain' = 'risk_assessment');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `decision_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agency ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `operations_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Operations Title Examination Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Underwriter Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `prior_decision_id` SET TAGS ('title_business_glossary_term' = 'Prior Underwriting Decision ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `title_evidence_id` SET TAGS ('title_business_glossary_term' = 'Evidence Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `conditions_imposed` SET TAGS ('title_business_glossary_term' = 'Underwriting Conditions Imposed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `cot_break_indicator` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County FIPS Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `curative_action_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `curative_deadline_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Deadline Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `decision_date` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `decision_number` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `decision_status` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `decision_status` SET TAGS ('title_value_regex' = 'pending|approved|approved_with_conditions|declined|escalated|withdrawn');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `decision_timestamp` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `decision_type` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `decision_type` SET TAGS ('title_value_regex' = 'insurable_title|marketable_title|risk_acceptance|risk_declination|conditional_approval|exception_approval');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `defect_category` SET TAGS ('title_business_glossary_term' = 'Title Defect Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Decision Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `endorsement_required` SET TAGS ('title_business_glossary_term' = 'Endorsement Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `endorsement_types` SET TAGS ('title_business_glossary_term' = 'Required ALTA Endorsement Types');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `escalation_count` SET TAGS ('title_business_glossary_term' = 'Escalation Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `exception_scheduled` SET TAGS ('title_business_glossary_term' = 'Exception Scheduled to Policy Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Decision Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `gap_period_indicator` SET TAGS ('title_business_glossary_term' = 'Gap Period (GAP) Coverage Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `insurable_title_determination` SET TAGS ('title_business_glossary_term' = 'Insurable Title Determination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `insurable_title_determination` SET TAGS ('title_value_regex' = 'insurable|not_insurable|insurable_with_exceptions|pending_curative');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `is_exception_approval` SET TAGS ('title_business_glossary_term' = 'Exception Approval Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `liability_amount` SET TAGS ('title_business_glossary_term' = 'Underwriting Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `liability_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `marketable_title_determination` SET TAGS ('title_business_glossary_term' = 'Marketable Title Determination');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `marketable_title_determination` SET TAGS ('title_value_regex' = 'marketable|not_marketable|marketable_with_exceptions|pending_curative');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `outcome` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Outcome');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `outcome` SET TAGS ('title_value_regex' = 'approved|approved_with_conditions|declined|referred_up|deferred');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `policy_type_requested` SET TAGS ('title_business_glossary_term' = 'Policy Type Requested (OTP/LTP)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `policy_type_requested` SET TAGS ('title_value_regex' = 'owner|lender|both');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `prior_claim_reference` SET TAGS ('title_business_glossary_term' = 'Prior Claim Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `production_channel` SET TAGS ('title_business_glossary_term' = 'Production Channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `production_channel` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `rationale` SET TAGS ('title_business_glossary_term' = 'Underwriting Decision Rationale');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `referral_date` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `referral_trigger_reason` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral Trigger Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Decision Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Decision Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `risk_category` SET TAGS ('title_business_glossary_term' = 'Underwriting Risk Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `risk_category` SET TAGS ('title_value_regex' = 'standard|elevated|high|uninsurable');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `source_system_decision_ref` SET TAGS ('title_business_glossary_term' = 'Source System Decision Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'Property State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|home_equity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `underwriter_notes` SET TAGS ('title_business_glossary_term' = 'Underwriter Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `uw_authority_level` SET TAGS ('title_business_glossary_term' = 'Underwriting Authority Level');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `uw_authority_level` SET TAGS ('title_value_regex' = 'examiner|branch_underwriter|regional_underwriter|chief_underwriter|underwriter_counsel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
