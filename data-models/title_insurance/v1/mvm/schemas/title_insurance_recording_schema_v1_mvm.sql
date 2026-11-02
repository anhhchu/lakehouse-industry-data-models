-- Schema for Domain: recording | Business: Title_Insurance | Version: v1_mvm
-- Generated on: 2026-10-31 06:39:30

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `serverless_stable_dvmvgw_catalog`.`ti_recording` COMMENT 'Manages post-closing document recording as legally distinct recording_submission and recorded_instrument entities. Owns submission to county recorders / registers of deeds via eRecording gateways, acceptance/rejection/resubmission workflows, recording';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` (
    `recording_submission_id` BIGINT COMMENT 'Unique surrogate identifier for each recording submission record. Primary key for the recording_submission entity in the title insurance recording domain.',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: Recording submissions prepared by independent agents must track the agent for oversight metrics (rejection rates, turnaround time), remittance reconciliation, and quality control.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to recording.jurisdiction. Business justification: Recording submissions are sent to a specific county recorder/register of deeds office.',
    `prior_submission_recording_submission_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding submission record for this package, enabling full resubmission chain traceability per VREQ-007.',
    `settlement_statement_id` BIGINT COMMENT 'Reference to the settlement statement (CD/HUD-1/ALTA) associated with the closing that produced the documents in this submission.',
    `submitted_by_party_id` BIGINT COMMENT 'Reference to the party (closing agent, escrow officer, title agent, or attorney) who submitted the recording package to the county recorder or eRecording gateway.',
    `title_commitment_id` BIGINT COMMENT 'Reference to the title commitment under which the documents in this submission were required. Supports commitment-to-recording traceability.',
    `title_order_id` BIGINT COMMENT 'Reference to the parent title order that originated this recording submission. Links the recording event back to the full title production lifecycle.',
    `uw_referral_id` BIGINT COMMENT 'Reference to the underwriting referral record created when a recording issue required underwriter review. Null if no referral was required.',
    `acceptance_date` DATE COMMENT 'Date the county recorder or eRecording gateway formally accepted the submission package for recording review. Distinct from submission_date and recording_date per VREQ-008.',
    `book_number` STRING COMMENT 'Official book number assigned by the county recorder for the recorded instrument (used in book/page recording reference systems). Null for jurisdictions using instrument numbers.',
    `channel_type` STRING COMMENT 'Production channel through which the title order was originated: direct branch, centralized lender, or independent agent. Supports channel-level recording performance metrics.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `consideration_amount` DECIMAL(15,2) COMMENT 'Purchase price or loan amount stated on the primary instrument, used for transfer tax calculation and underwriting risk assessment. Confidential financial data.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time this recording_submission record was first created in the system of record. Audit field supporting data lineage and provenance per VREQ-007.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this submission record. Defaults to USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `document_count` BIGINT COMMENT 'Total number of individual instruments included in this recording submission package. Supports fee calculation and completeness validation.',
    `effective_date` DATE COMMENT 'Date the primary instrument in this submission takes legal effect, which may differ from execution or recording date. Distinct per VREQ-008.',
    `erecording_gateway` STRING COMMENT 'eRecording gateway vendor used to transmit documents electronically to the county recorder (e.g., Simplifile, CSC eRecording). Null or none for physical submissions.. Valid values are `simplifile|csc_erecording|indecomm|other|none`',
    `erecording_transaction_id` STRING COMMENT 'Unique transaction identifier assigned by the eRecording gateway (Simplifile, CSC) for this submission. Used for gateway-level status tracking and reconciliation.',
    `execution_date` DATE COMMENT 'Date the primary instrument in this submission was signed/executed by the parties. Distinct from effective_date, submission_date, acceptance_date, and recording_date per VREQ-008.',
    `gap_close_date` DATE COMMENT 'Date the gap coverage period closed, set to the confirmed recording_date. Null until recording is confirmed. Drives gap-period duration calculation.',
    `gap_coverage_flag` BOOLEAN COMMENT 'Indicates whether gap (GAP) coverage is in effect for this submission, protecting the insured during the period between closing and confirmed recording.',
    `gap_open_date` DATE COMMENT 'Date the gap coverage period opened, typically the closing/disbursement date. Marks the start of the unrecorded instrument risk window.',
    `instrument_number` STRING COMMENT 'Sequential instrument number assigned by the county recorder upon recording. Primary recording reference in jurisdictions that do not use book/page systems.',
    `last_rejection_date` DATE COMMENT 'Date of the most recent rejection of this submission by the county recorder or eRecording gateway. Used for resubmission SLA tracking.',
    `last_rejection_reason_code` STRING COMMENT 'Standardized code for the most recent rejection reason returned by the county recorder or eRecording gateway (e.g., MISSING_NOTARY, INCORRECT_FEE, ILLEGIBLE_DOCUMENT).',
    `last_rejection_reason_description` STRING COMMENT 'Free-text description of the most recent rejection reason as returned by the county recorder or eRecording gateway. Supports curative action and resubmission workflow.',
    `notes` STRING COMMENT 'Free-text operational notes entered by the closing agent or recording coordinator regarding special instructions, curative actions, or county-specific requirements for this submission.',
    `page_number` STRING COMMENT 'Official page number assigned by the county recorder for the recorded instrument (used in book/page recording reference systems). Null for jurisdictions using instrument numbers.',
    `policy_issuance_lag_days` BIGINT COMMENT 'Number of calendar days between the confirmed recording_date and the title policy issue date. Key metric for policy-issuance-lag-after-recording per VREQ-016.',
    `primary_document_type` STRING COMMENT 'Type of the lead instrument in the submission (e.g., Warranty Deed, Deed of Trust, Mortgage, Quit Claim Deed, Reconveyance, Satisfaction). [ENUM-REF-CANDIDATE',
    `recording_date` DATE COMMENT 'Official date on which the county recorder stamped and recorded the submitted instruments. Closes the GAP coverage period and triggers policy-issuance-lag measurement. Distinct per VREQ-008.',
    `recording_reference_number` STRING COMMENT 'Official reference number assigned by the county recorder upon successful recording (instrument number, document number, or reception number). Null until recorded.',
    `recording_timestamp` TIMESTAMP COMMENT 'Precise date and time the county recorder confirmed recording of all instruments in this submission. Used for gap-period close and policy issuance lag calculations.',
    `rejection_count` BIGINT COMMENT 'Cumulative number of times this submission has been rejected by the county recorder or eRecording gateway. Key numerator for recording rejection rate metric per VREQ-016.',
    `resubmission_date` DATE COMMENT 'Date on which a corrected package was resubmitted to the county recorder following a rejection. Null on first submission. Supports resubmission rate and cycle-time metrics.',
    `submission_date` DATE COMMENT 'Calendar date on which the recording submission package was transmitted to the county recorder or eRecording gateway. Distinct from execution_date, effective_date, acceptance_date, and recording_date per VREQ-008.',
    `submission_method` STRING COMMENT 'Method by which documents were submitted to the county recorder: eRecording via gateway (Simplifile, CSC), physical counter delivery, mail, or courier.. Valid values are `erecording|physical_delivery|mail|courier`',
    `submission_number` STRING COMMENT 'Externally-known business identifier assigned to this recording submission, used for tracking with the eRecording gateway and county recorder. Unique per submission attempt.',
    `submission_status` STRING COMMENT 'Current lifecycle state of the recording submission. Drives recording rejection/resubmission rate and policy-issuance-lag metrics. [ENUM-REF-CANDIDATE: draft|submitted|pending_review|accepted|rejected|resubmitted|recorded|cancelled — promote to reference',
    `submission_timestamp` TIMESTAMP COMMENT 'Precise date and time the recording submission was transmitted to the eRecording gateway or county recorder. Supports SLA measurement and gap-period calculation.',
    `submitter_role` STRING COMMENT 'Role of the party who submitted the recording package (e.g., closing agent, escrow officer, title agent, attorney). Supports agency oversight and audit.. Valid values are `closing_agent|escrow_officer|title_agent|attorney|lender|other`',
    `total_recording_fee_amount` DECIMAL(12,2) COMMENT 'Aggregate recording fees charged by the county recorder for all instruments in this submission, in USD. Feeds settlement statement disbursement and escrow reconciliation.',
    `total_transfer_tax_amount` DECIMAL(12,2) COMMENT 'Aggregate transfer tax (documentary stamp tax, deed tax) collected and remitted for all instruments in this submission, in USD.',
    `transaction_type` STRING COMMENT 'Real estate transaction type that generated this recording submission (e.g., purchase, refinance, HELOC, construction). Supports channel and product-mix analytics.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time this recording_submission record was last modified in the system of record. Supports change tracking and lifecycle history per VREQ-007.',
    `uw_referral_required` BOOLEAN COMMENT 'Indicates whether a recording-related issue (e.g., extended gap, rejection) triggered an underwriting referral. Supports UW referral rate metric per VREQ-016.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_recording_submission PRIMARY KEY(`recording_submission_id`)
) COMMENT 'Authoritative SSOT for each document recording submission sent to a county recorder or register of deeds via an eRecording gateway (Simplifile, CSC eRecording) or physical delivery.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` (
    `recorded_instrument_id` BIGINT COMMENT 'Unique surrogate primary key for each recorded instrument accepted and stamped by the county recorder or register of deeds. SSOT identifier for downstream policy, title lifecycle, and provenance linkage.',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: Recorded instruments originated by agents require agent tracking for premium split calculation, remittance line attribution, claim provenance, and oversight reporting.',
    `gateway_transaction_id` BIGINT COMMENT 'Unique transaction identifier assigned by the eRecording gateway (e.g., Simplifile transaction ID) for this instrument. Used for gateway reconciliation and rejection/resubmission tracking.',
    `operations_title_examination_id` BIGINT COMMENT 'Foreign key linking to operations.title_examination. Business justification: Recorded instruments result from title examinations that cleared defects. Provenance tracking required by VREQ-009 for material title findings.',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel record identifying the land affected by this instrument. Supports chain-of-title assembly and grantor/grantee index queries.',
    `recording_submission_id` BIGINT COMMENT 'Reference to the recording_submission record that originated this instrument. Links the accepted instrument back to the eRecording gateway submission event for gap-period and resubmission tracking.',
    `title_claim_id` BIGINT COMMENT 'Foreign key linking to claim.title_claim. Business justification: Recorded instruments trigger claims when post-recording defects surface (forgery, fraud, prior liens).',
    `title_finding_id` BIGINT COMMENT 'Foreign key linking to underwriting.title_finding. Business justification: Instruments recorded to cure specific title findings (liens, judgments, chain-of-title breaks) require direct traceability for curative-action effectiveness analysis',
    `title_order_id` BIGINT COMMENT 'Reference to the title order under which this instrument was prepared and submitted for recording. Supports closing-readiness and policy-issuance-lag metrics.',
    `acceptance_date` DATE COMMENT 'Date the county recorder formally accepted the instrument for recording (prior to official stamping). Distinct from execution_date, effective_date, submission_date, and recording_date per VREQ-008.',
    `apn` STRING COMMENT 'Assessors Parcel Number assigned by the county assessor to the property affected by this instrument. Also known as PIN in some jurisdictions. Used for property tax lien searches and parcel cross-reference.',
    `book_number` STRING COMMENT 'Official book (volume) number assigned by the county recorder where the instrument is indexed. Used with page_number to form the traditional book/page recording reference in non-instrument-number jurisdictions.',
    `chain_of_title_break_flag` BOOLEAN COMMENT 'Indicates whether this instrument introduces a break in the chain of title (e.g., missing link in grantor/grantee index, gap in vesting). Set by title examination logic. Drives curative action and underwriting referral workflows.',
    `consideration_amount` DECIMAL(18,2) COMMENT 'Stated monetary consideration for the conveyance as shown on the instrument (e.g., purchase price on a deed). Used for transfer tax calculation and LTV analysis. May be nominal for non-arms-length transfers.',
    `county_fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county where the instrument was recorded. Standard geographic identifier for jurisdiction routing, fee schedule lookup, and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this recorded instrument record was first created in the lakehouse Silver layer. Supports audit trail and data lineage per SOC 2 and ALTA Best Practices.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this instrument (consideration_amount, loan_amount, recording_fee_amount, transfer_tax_amount). Defaults to USD for domestic US transactions.. Valid values are `^[A-Z]{3}$`',
    `document_image_reference` STRING COMMENT 'URI or document management system reference to the scanned or electronic image of the recorded instrument as returned by the county recorder. Supports evidence and provenance requirements per VREQ-007.',
    `effective_date` DATE COMMENT 'Date the legal rights conveyed by the instrument take effect, which may differ from execution or recording date. Distinct from execution_date, submission_date, acceptance_date, and recording_date per VREQ-008.',
    `erecording_gateway` STRING COMMENT 'Electronic recording gateway or method used to submit and confirm this instrument (e.g., Simplifile, CSC eRecording). Null for paper-recorded instruments. Supports eRecording adoption and rejection-rate metrics.. Valid values are `simplifile|csc_erecording|indecomm|direct_paper|other`',
    `execution_date` DATE COMMENT 'Date the instrument was signed by the grantor(s) or obligor(s). Distinct from effective_date, submission_date, acceptance_date, and recording_date per VREQ-008. Required for chain-of-title validity analysis.',
    `gap_coverage_flag` BOOLEAN COMMENT 'Indicates whether this instrument falls within an active gap-coverage period (GAP) between the last title search and confirmed recording. True triggers gap-period monitoring and potential underwriting referral.',
    `grantee_name` STRING COMMENT 'Full legal name of the grantee (buyer, beneficiary, mortgagee, or receiving party) as it appears on the recorded instrument. Critical for grantor/grantee index and chain-of-title assembly.',
    `grantor_name` STRING COMMENT 'Full legal name of the grantor (seller, trustor, mortgagor, or conveying party) as it appears on the recorded instrument. Critical for grantor/grantee index and chain-of-title assembly.',
    `instrument_number` STRING COMMENT 'Official instrument number assigned by the county recorder or register of deeds upon acceptance. Primary externally-known identifier for the recorded instrument. Also called document number in some jurisdictions.',
    `instrument_status` STRING COMMENT 'Current lifecycle status of the recorded instrument as confirmed by the county recorder. Accepted = stamped and indexed; Released = lien released; Superseded = replaced by corrective instrument; Voided = expunged by court order.. Valid values are `accepted|indexed|released|superseded|voided`',
    `instrument_subtype` STRING COMMENT 'Further classification within the instrument type (e.g., Warranty Deed (WD), Quit Claim Deed (QCD), Special Warranty Deed (SWD), Purchase Money Mortgage (PMM), HELOC, Deed of Trust). Refines title examination and underwriting analysis.',
    `instrument_type` STRING COMMENT 'Legal classification of the recorded instrument (e.g., deed, deed of trust, mortgage, release, reconveyance, assignment, lis pendens, easement, UCC). Drives chain-of-title analysis and defect identification.',
    `legal_description` STRING COMMENT 'Full legal description of the property as it appears on the recorded instrument (metes and bounds, PLSS township/range/section, or plat/subdivision lot reference). Critical for chain-of-title and Schedule A verification.',
    `lien_priority` STRING COMMENT 'Priority position of the lien instrument relative to other encumbrances on the property (first, second, subordinate). Determined by recording date and any subordination agreements. Critical for lender policy coverage analysis.. Valid values are `first|second|third|subordinate|unknown`',
    `lien_type` STRING COMMENT 'Classification of the encumbrance type for lien instruments (e.g., mortgage, deed of trust, tax lien, mechanics lien, judgment lien, HOA lien, UCC). Null for conveyance instruments. Supports open-lien and aging-defect metrics.',
    `loan_amount` DECIMAL(18,2) COMMENT 'Original principal amount of the loan secured by a deed of trust or mortgage as stated on the instrument. Used for LTV/CLTV analysis and lender policy coverage verification.',
    `mers_min` STRING COMMENT '18-digit MERS Mortgage Identification Number assigned to a deed of trust or mortgage registered on the MERS system. Null for non-MERS instruments. Required for lender policy and assignment chain verification.. Valid values are `^[0-9]{18}$`',
    `notarization_type` STRING COMMENT 'Method of notarization used for this instrument: traditional in-person, Remote Online Notarization (RON), In-Person Electronic Notarization (IPEN), or Remote Ink Notarization (RIN). Affects recording acceptance in some jurisdictions.. Valid values are `traditional|ron|ipen|remote_ink_notarization`',
    `notary_commission_expiration_date` DATE COMMENT 'Expiration date of the notarys commission at the time of acknowledgment. Used to validate that the notarization was performed within an active commission period, preventing recording defects.',
    `notary_name` STRING COMMENT 'Full name of the notary public who acknowledged the instrument. Required for recording validity verification and E&O compliance review.',
    `page_count` BIGINT COMMENT 'Total number of pages in the recorded instrument as accepted by the county recorder. Used to calculate per-page recording fees and verify fee reconciliation.',
    `page_number` STRING COMMENT 'Official page number within the recording book where the instrument is indexed. Combined with book_number to form the complete book/page recording reference used in chain-of-title searches.',
    `prior_instrument_number` STRING COMMENT 'Recording reference number of the instrument being released, reconveyed, assigned, or superseded by this instrument. Establishes the chain-of-title link between successive instruments for lien release and satisfaction tracking.',
    `recording_date` DATE COMMENT 'Official date the instrument was accepted and stamped by the county recorder or register of deeds. Distinct from execution_date, effective_date, submission_date, and acceptance_date. Anchors gap-period close and policy-issuance-lag calculation.',
    `recording_fee_amount` DECIMAL(10,2) COMMENT 'Total fee paid to the county recorder for recording this instrument, including per-page fees and any indexing fees. Reconciled against the settlement statement disbursement.',
    `recording_jurisdiction_name` STRING COMMENT 'Human-readable name of the county recorder or register of deeds office where the instrument was recorded (e.g., Cook County Recorder of Deeds). Complements county_fips_code for display and reporting.',
    `recording_timestamp` TIMESTAMP COMMENT 'Precise date and time the instrument was stamped by the county recorder, including time zone offset. Used for priority determination in same-day recording conflicts and gap-period close precision.',
    `release_satisfaction_flag` BOOLEAN COMMENT 'Indicates whether this instrument is a release, satisfaction, or reconveyance that extinguishes a prior lien or encumbrance. Used to update open-lien status in the title examination and chain-of-title analysis.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the state in which the instrument was recorded. Used for state-level regulatory reporting, transfer tax rate lookup, and jurisdiction routing.. Valid values are `^[A-Z]{2}$`',
    `submission_date` DATE COMMENT 'Date the instrument package was submitted to the county recorder or eRecording gateway. Distinct from execution_date, effective_date, acceptance_date, and recording_date per VREQ-008. Used in recording cycle-time analysis.',
    `transfer_tax_amount` DECIMAL(10,2) COMMENT 'Documentary transfer tax or deed stamp tax collected at recording, calculated on the consideration amount per applicable state and county rates. Reconciled against settlement statement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this recorded instrument record was last modified in the lakehouse Silver layer. Supports change tracking, lifecycle history preservation per VREQ-007, and audit compliance.',
    `vesting_type` STRING COMMENT 'Form of title vesting under which the grantee takes ownership (e.g., joint tenancy, tenancy in common, community property, trust, entity). Drives ownership interest modeling and underwriting analysis.. Valid values are `sole_ownership|joint_tenancy|tenancy_in_common|community_property|trust|entity`',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_recorded_instrument PRIMARY KEY(`recorded_instrument_id`)
) COMMENT 'Authoritative SSOT for each individual legal instrument (deed, deed of trust, mortgage, release, reconveyance, assignment, UCC, lis pendens, easement) accepted and stamped by the county recorder or register of deeds.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` (
    `submission_document_id` BIGINT COMMENT 'Unique surrogate identifier for each individual document line item within a recording submission package. Primary key for the submission_document entity.',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: Individual documents within agent-originated submissions must track the preparing agent for document-level quality audits, notarization compliance reviews, and oversight sampling.',
    `gateway_transaction_id` BIGINT COMMENT 'Unique transaction identifier assigned by the eRecording gateway (e.g., Simplifile transaction ID) for this document submission. Used for gateway reconciliation and rejection tracking.',
    `recording_submission_id` BIGINT COMMENT 'Foreign key reference to the parent recording_submission package that contains this document. Establishes the header-detail relationship for multi-document submissions.',
    `title_order_id` BIGINT COMMENT 'Reference to the originating title order associated with this document, enabling traceability from recording back through the full title lifecycle.',
    `acceptance_date` DATE COMMENT 'Date the county recorder or eRecording gateway formally accepted this document for recording. Marks the start of the gap-period (GAP) closure window. Distinct per VREQ-008.',
    `book_number` STRING COMMENT 'Book number assigned by the county recorder as part of the book/page recording reference system. Used in jurisdictions that index by book and page rather than instrument number.',
    `consideration_amount` DECIMAL(15,2) COMMENT 'Dollar amount of consideration stated on the face of the conveyance instrument (e.g., purchase price on a deed). Used for transfer tax calculation and chain-of-title value analysis.',
    `county_fips_code` STRING COMMENT 'Five-digit Federal Information Processing Standards (FIPS) code identifying the county or county-equivalent jurisdiction where the document is recorded. Enables multi-jurisdiction reporting.. Valid values are `^[0-9]{5}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this submission_document record was first created in the system of record. Supports audit trail and lifecycle tracking per VREQ-007.',
    `document_image_reference` STRING COMMENT 'Reference identifier or URI pointing to the scanned or electronic image of this document in the Document Management and Imaging System. Supports evidence and provenance requirements.',
    `document_sequence_number` BIGINT COMMENT 'Ordinal position of this document within the parent recording submission package. Determines recording priority order (e.g., deed records before deed of trust).',
    `document_status` STRING COMMENT 'Current lifecycle status of this individual document within the recording workflow. Tracks progression from pending through recorded or rejected/resubmitted states.',
    `document_subtype` STRING COMMENT 'Further classification within the document type (e.g., Warranty Deed vs. Quit Claim Deed vs. Special Warranty Deed). Supports granular chain-of-title analysis. [ENUM-REF-CANDIDATE: promote to reference product]',
    `document_title` STRING COMMENT 'Human-readable title or caption of the legal instrument as it appears on the face of the document (e.g., Warranty Deed, Deed of Trust and Security Agreement).',
    `document_type` STRING COMMENT 'Classification of the legal instrument being submitted for recording (e.g., Warranty Deed, Deed of Trust, Release/Reconveyance, Subordination Agreement). [ENUM-REF-CANDIDATE',
    `effective_date` DATE COMMENT 'Date the legal instrument becomes operative and binding between the parties. May differ from execution date and recording date. Distinct per VREQ-008.',
    `erecording_gateway` STRING COMMENT 'Identifies the eRecording gateway or submission channel used to transmit this document to the county recorder (e.g., Simplifile, CSC eRecording, direct paper). Supports gateway performance metrics.. Valid values are `simplifile|csc_erecording|indecomm|direct_paper|other`',
    `execution_date` DATE COMMENT 'Date the document was signed/executed by the parties. Distinct from effective date, submission date, acceptance date, and recording date per VREQ-008.',
    `gap_close_date` DATE COMMENT 'Date the gap coverage period closed for this document, set equal to the confirmed recording_date. A null value indicates the gap period remains open and the document has not yet been confirmed recorded.',
    `gap_coverage_flag` BOOLEAN COMMENT 'Indicates whether gap coverage (GAP) is in effect for this document, covering the period between closing/execution and confirmed recording. True when gap period is open and insured.',
    `gap_open_date` DATE COMMENT 'Date the gap coverage period opened for this document, typically the closing/disbursement date. The gap period runs from this date until the recording_date is confirmed.',
    `grantee_name` STRING COMMENT 'Name of the grantee (transferee/beneficiary/mortgagee) as it appears on the face of the document. Used for chain-of-title indexing and grantor-grantee index matching at the county recorder.',
    `grantor_name` STRING COMMENT 'Name of the grantor (transferor/trustor/mortgagor) as it appears on the face of the document. Used for chain-of-title indexing and grantor-grantee index matching at the county recorder.',
    `instrument_number` STRING COMMENT 'Sequential instrument number assigned by the county recorder in jurisdictions that use instrument-number indexing rather than book/page. Unique within a county and recording year.',
    `is_erecording_eligible` BOOLEAN COMMENT 'Indicates whether this document type and jurisdiction combination supports electronic recording (eRecording). False indicates paper recording is required for this document.',
    `loan_amount` DECIMAL(15,2) COMMENT 'Principal loan amount secured by a deed of trust or mortgage instrument as stated on the face of the document. Used for lender policy coverage verification and lien priority analysis.',
    `notarization_type` STRING COMMENT 'Method by which the document was notarized: traditional in-person, Remote Online Notarization (RON), or In-Person Electronic Notarization (IPEN). Affects county recorder acceptance requirements.. Valid values are `traditional|ron|ipen|other`',
    `notary_commission_expiration_date` DATE COMMENT 'Expiration date of the notary publics commission at the time of notarization. Validates that the notary was duly commissioned when the document was executed, preventing recording rejection.',
    `notary_name` STRING COMMENT 'Full name of the notary public who acknowledged or witnessed the execution of this document. Required for recording acceptance in most jurisdictions.',
    `page_count` BIGINT COMMENT 'Total number of pages in this individual document as submitted for recording. Used to calculate per-page recording fees and verify completeness against the recorded instrument.',
    `page_number` STRING COMMENT 'Page number assigned by the county recorder as part of the book/page recording reference system. Used alongside book_number in jurisdictions that index by book and page.',
    `policy_issuance_lag_days` BIGINT COMMENT 'Number of calendar days elapsed between the confirmed recording_date and the issuance of the associated title policy. Supports the policy-issuance-lag-after-recording metric per VREQ-016.',
    `priority_recording_flag` BOOLEAN COMMENT 'Indicates this document requires expedited or priority recording to protect lien priority or close the gap period within a time-sensitive window (e.g., same-day recording required).',
    `recording_date` DATE COMMENT 'Official date the document was recorded in the public record by the county recorder or register of deeds. Closes the GAP coverage window. Distinct per VREQ-008.',
    `recording_fee_amount` DECIMAL(12,2) COMMENT 'Dollar amount of the recording fee assessed by the county recorder for this individual document, typically calculated based on page count and document type per the jurisdiction fee schedule.',
    `recording_jurisdiction_name` STRING COMMENT 'Name of the county recorder, register of deeds, or other recording jurisdiction office where this document is submitted (e.g., Cook County Recorder of Deeds).',
    `recording_reference_number` STRING COMMENT 'Official recording reference assigned by the county recorder upon recording (e.g., instrument number, document number). The primary public-record identifier for the recorded instrument.',
    `recording_timestamp` TIMESTAMP COMMENT 'Precise date and time the document was stamped as recorded by the county recorder, including time-of-day priority for same-day recordings. Critical for lien priority determination.',
    `rejection_count` BIGINT COMMENT 'Cumulative number of times this document has been rejected by the county recorder or eRecording gateway. Supports recording rejection and resubmission rate metrics per VREQ-016.',
    `rejection_reason_code` STRING COMMENT 'Standardized code returned by the county recorder or eRecording gateway explaining why this document was rejected (e.g., missing notary, incorrect fee, illegible). Drives resubmission workflow.',
    `rejection_reason_description` STRING COMMENT 'Free-text description of the rejection reason as provided by the county recorder or eRecording gateway. Supplements the rejection_reason_code with human-readable detail for curative action.',
    `resubmission_date` DATE COMMENT 'Date this document was most recently resubmitted to the county recorder following a prior rejection. Used to calculate resubmission turnaround time and recording rejection rate metrics.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the state in which the document is recorded. Supports state-level regulatory reporting and recording fee schedules.. Valid values are `^[A-Z]{2}$`',
    `submission_date` DATE COMMENT 'Date this document was submitted to the county recorder or eRecording gateway for recording. Distinct from execution, effective, acceptance, and recording dates per VREQ-008.',
    `transfer_tax_amount` DECIMAL(12,2) COMMENT 'Documentary transfer tax or deed tax assessed on this document at the time of recording, typically applicable to conveyance instruments. Reported on the Closing Disclosure (CD).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this submission_document record was most recently modified in the system of record. Supports change tracking and lifecycle history preservation per VREQ-007.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_submission_document PRIMARY KEY(`submission_document_id`)
) COMMENT 'Line-item entity representing each individual document within a recording_submission (e.g., a deed, deed of trust, release, and subordination agreement as separate documents), each with its own document type, page count, recording fee, execution date';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` (
    `rejection_event_id` BIGINT COMMENT 'Unique surrogate identifier for each discrete rejection notice event returned by a county recorder or eRecording gateway for a recording submission or individual submission document.',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: Recording rejections on agent files must route curative actions to the responsible agent and track rejection rates by agent for oversight reviews, authority adjustments, and training',
    `gateway_transaction_id` BIGINT COMMENT 'Transaction identifier assigned by the eRecording gateway (Simplifile or CSC) for the submission batch or document that was rejected, enabling reconciliation with gateway records.',
    `operations_curative_action_id` BIGINT COMMENT 'Foreign key linking to operations.operations_curative_action. Business justification: Recording rejections (missing notarization, signature defects, margin errors) trigger curative actions. Tracks curative action aging and effectiveness per VREQ-016.',
    `rejection_recording_submission_id` BIGINT COMMENT 'Reference to the parent recording_submission record against which this rejection was issued. Establishes the submission-level context for the rejection event.',
    `rejection_resubmission_submission_recording_submission_id` BIGINT COMMENT 'Reference to the new recording_submission record created as a result of resubmitting the corrected document after this rejection, enabling chain-of-resubmission tracking.',
    `submission_document_id` BIGINT COMMENT 'Reference to the specific submission_document within the parent submission that triggered this rejection, when the rejection is document-level rather than submission-level. Null for submission-level rejections.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order associated with this rejection event, enabling cross-domain traceability from recording back to the originating order and lifecycle.',
    `assigned_to_user` STRING COMMENT 'Username or employee identifier of the recording specialist or closer assigned to resolve this rejection event. Supports workload management and accountability tracking.',
    `corrected_fee_amount` DECIMAL(12,2) COMMENT 'Corrected recording fee amount (in USD) required by the county recorder to accept the resubmission, when the rejection was due to an incorrect fee. Supports settlement reconciliation.',
    `county_fips_code` STRING COMMENT 'Five-digit Federal Information Processing Standards (FIPS) code uniquely identifying the county or jurisdiction of the recording office that issued the rejection.. Valid values are `^[0-9]{5}$`',
    `county_name` STRING COMMENT 'Name of the county or jurisdiction whose recorder or register of deeds issued the rejection notice. Supports jurisdiction-level rejection rate analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this rejection_event record was first captured in the system of record (eRecording gateway or title production system). Audit trail field.',
    `curative_action_description` STRING COMMENT 'Description of the specific curative action required to resolve this rejection (e.g., re-execute deed, correct legal description, obtain notary re-acknowledgment, pay correct recording fee).',
    `curative_action_required` BOOLEAN COMMENT 'Indicates whether this rejection requires a curative action (document correction, re-execution, or additional evidence) before resubmission can occur. Drives curative workflow routing.',
    `days_open` BIGINT COMMENT 'Number of calendar days this rejection event has been in an open/unresolved state, calculated from received_timestamp to current date or resolution_timestamp. Supports aging and SLA reporting.',
    `document_reference_number` STRING COMMENT 'The document-level tracking number or identifier assigned by the eRecording gateway or county recorder to the specific document that was rejected, for traceability.',
    `document_type` STRING COMMENT 'Type of instrument or document that was rejected (e.g., Deed of Trust, Warranty Deed, Quit Claim Deed, Mortgage, Release, Assignment). Relevant for document-level rejections. [ENUM-REF-CANDIDATE: promote to reference product]',
    `erecording_gateway_name` STRING COMMENT 'Name of the eRecording gateway or submission channel through which the document was submitted and rejected (e.g., Simplifile, CSC eRecording, or direct county submission).. Valid values are `Simplifile|CSC_eRecording|direct_submission|other`',
    `escalated_to_underwriting` BOOLEAN COMMENT 'Indicates whether this rejection event was escalated to the underwriting team for risk assessment or exception handling, particularly when the rejection creates a title defect or cloud on title.',
    `escalation_timestamp` TIMESTAMP COMMENT 'Date and time when this rejection event was escalated to underwriting or management for review. Null if not escalated. Supports escalation rate and aging metrics.',
    `gap_period_days` BIGINT COMMENT 'Number of calendar days of gap coverage exposure attributable to this rejection event, measured from the original submission date to the resubmission or resolution date.',
    `gap_period_impacted` BOOLEAN COMMENT 'Indicates whether this rejection event extended or created a gap coverage period (GAP) between the closing date and confirmed recording date, triggering additional underwriting risk exposure.',
    `notes` STRING COMMENT 'Free-text operational notes entered by the recording specialist regarding the rejection event, curative steps taken, communications with the county recorder, or other relevant context.',
    `number` STRING COMMENT 'Externally assigned or internally generated business identifier for this rejection notice, as returned by the eRecording gateway (e.g., Simplifile or CSC) or county recorder office.',
    `original_submission_date` DATE COMMENT 'Date on which the original recording submission was first submitted to the county recorder or eRecording gateway, prior to this rejection. Used to calculate total recording cycle time.',
    `policy_issuance_impacted` BOOLEAN COMMENT 'Indicates whether this rejection event delayed or blocked the issuance of the owner or lender title policy, contributing to the policy-issuance-lag-after-recording metric.',
    `received_timestamp` TIMESTAMP COMMENT 'Date and time when the rejection notice was received from the county recorder or eRecording gateway. Principal business event timestamp for this rejection event; anchors aging and SLA calculations.',
    `recording_fee_amount` DECIMAL(12,2) COMMENT 'Recording fee amount (in USD) associated with the rejected submission or document, relevant when the rejection reason involves incorrect fee payment or fee recalculation.',
    `rejection_category` STRING COMMENT 'High-level classification of the rejection reason (e.g., legal_description_error, missing_signature, incorrect_fee, formatting_defect, vesting_mismatch, notarization_defect). [ENUM-REF-CANDIDATE: promote to reference product]',
    `rejection_grain` STRING COMMENT 'Explicit grain discriminator indicating whether this rejection applies to the entire recording submission (submission-level) or to a single document within the submission (document-level).. Valid values are `submission|document`',
    `rejection_notice_date` DATE COMMENT 'Calendar date stated on the official rejection notice issued by the county recorder or eRecording gateway. Distinct from received_timestamp; reflects the official notice date for legal purposes.',
    `rejection_notice_text` STRING COMMENT 'Full verbatim text of the rejection notice as received from the county recorder or eRecording gateway, preserved for evidence, provenance, and curative action guidance.',
    `rejection_reason_code` STRING COMMENT 'Standardized code assigned by the county recorder or eRecording gateway identifying the specific reason for rejection (e.g., county-specific error codes from Simplifile or CSC rejection notice).',
    `rejection_reason_description` STRING COMMENT 'Free-text narrative description of the rejection reason as returned by the county recorder or eRecording gateway, preserving the verbatim rejection notice language for curative reference.',
    `rejection_sequence_number` BIGINT COMMENT 'Ordinal sequence of this rejection event within the parent recording submission, enabling tracking of repeated rejections (1st rejection, 2nd rejection, etc.) for resubmission rate metrics.',
    `rejection_source` STRING COMMENT 'The authority or system that issued the rejection notice — county recorder, eRecording gateway (Simplifile/CSC), register of deeds, or state-level recording office.. Valid values are `county_recorder|erecording_gateway|register_of_deeds|state_office`',
    `rejection_status` STRING COMMENT 'Current workflow state of this rejection event. Drives recording rejection/resubmission rate metrics and aging analysis. [ENUM-REF-CANDIDATE: open|resolved|resubmitted|waived|escalated|closed — promote to reference product]. Valid values are `open|resolved|resubmitted|waived|escalated|closed`',
    `resolution_method` STRING COMMENT 'Method by which this rejection was resolved: resubmission of corrected document, waiver granted by county, withdrawal of submission, escalation to underwriter, or county-initiated override.. Valid values are `resubmission|waiver|withdrawal|escalation|county_override`',
    `resolution_timestamp` TIMESTAMP COMMENT 'Date and time when this rejection event was resolved (either by successful resubmission, waiver, or closure). Used to calculate rejection resolution cycle time.',
    `resubmission_date` DATE COMMENT 'Actual date on which the corrected document was resubmitted to the county recorder or eRecording gateway following resolution of this rejection event.',
    `resubmission_deadline_date` DATE COMMENT 'Date by which the corrected document must be resubmitted to the county recorder to preserve GAP coverage and avoid policy issuance delays. Critical for gap-period risk management.',
    `sla_breached` BOOLEAN COMMENT 'Indicates whether the resolution of this rejection event exceeded the SLA target days, signaling a recording delay that may impact closing readiness and policy issuance timelines.',
    `sla_target_days` BIGINT COMMENT 'Number of business or calendar days within which this rejection must be resolved per internal SLA or lender/client agreement. Baseline for SLA breach detection.',
    `source_system_rejection_code` STRING COMMENT 'Native identifier for this rejection event as assigned by the originating system of record (eRecording gateway such as Simplifile or CSC, or title production system). Supports reconciliation.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the state in which the recording office is located. Supports state-level regulatory reporting and rejection rate metrics.. Valid values are `^[A-Z]{2}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this rejection_event record was last modified, supporting audit trail and change tracking for the rejection lifecycle.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_rejection_event PRIMARY KEY(`rejection_event_id`)
) COMMENT 'Transactional SSOT for each discrete rejection notice returned for a recording submission or an individual submission_document, carrying an explicit grain flag (submission-level vs document-level).';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` (
    `gap_coverage_period_id` BIGINT COMMENT 'Unique surrogate identifier for the GAP coverage period record tracking the interval between closing/last search date and confirmed recording date for a title order.',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: Gap coverage authority is delegated to agents under specific limits. Tracking the agent managing each gap period is required for authority compliance monitoring, gap risk reporting, and',
    `recording_submission_id` BIGINT COMMENT 'Reference to the recording submission that, upon acceptance, closes the GAP coverage window. Links to the eRecording gateway submission record.',
    `title_claim_id` BIGINT COMMENT 'Foreign key linking to claim.title_claim. Business justification: Gap coverage periods generate claims when intervening liens or defects arise during the gap. Claims adjuster must reference the gap period to validate coverage and determine liability.',
    `title_commitment_id` BIGINT COMMENT 'Reference to the title commitment under which GAP coverage is extended. Identifies the commitment version in effect at closing.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order for which this GAP coverage period is being tracked. Links the GAP window to the originating order intake record.',
    `title_policy_id` BIGINT COMMENT 'Reference to the title policy (owner or lender) that incorporates or is affected by this GAP coverage period. Populated after policy issuance.',
    `uw_referral_id` BIGINT COMMENT 'Reference to the underwriting referral record created when the GAP window exceeded allowed thresholds or required non-standard resolution. Null if no referral was required.',
    `acceptance_date` DATE COMMENT 'The date on which the county recorder formally accepted the submitted instruments for recording. Distinct from submission_date and recording_date per VREQ-008.',
    `book_number` STRING COMMENT 'The official book number assigned by the county recorder upon acceptance of the recorded instrument. Part of the recording reference (book/page) that closes the GAP window.',
    `channel_type` STRING COMMENT 'Production channel through which the title order was originated. Distinguishes direct branch, centralized lender, and independent agent channels for GAP performance analysis.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `closing_date` DATE COMMENT 'The date on which the real estate transaction closed and insured instruments were executed. Serves as the primary anchor for the GAP coverage start when later than last search date.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this GAP coverage period record was first created in the system. Supports audit trail and lifecycle history preservation per VREQ-007.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the gap coverage amount. Defaults to USD for domestic US title insurance transactions.. Valid values are `USD`',
    `erecording_gateway` STRING COMMENT 'The eRecording gateway or submission method used to submit instruments to the county recorder. Identifies Simplifile, CSC eRecording, or direct county submission for operational tracking.. Valid values are `simplifile|csc_erecording|indecomm|direct_county|other`',
    `gap_close_date` DATE COMMENT 'The date on which the GAP coverage period was formally closed, either by confirmed recording, waiver, or expiration. Distinct from recording_date to accommodate non-recording closures.',
    `gap_coverage_amount` DECIMAL(18,2) COMMENT 'The dollar amount of title insurance coverage extended during the GAP period. Typically equals the policy amount for the insured instruments pending recording.',
    `gap_cure_method` STRING COMMENT 'The method by which the GAP coverage period was resolved or cured. Recording confirmation is standard; affidavit, indemnity, waiver, or endorsement may be used in exceptional cases.. Valid values are `recording_confirmed|affidavit|indemnity|waiver|endorsement`',
    `gap_cure_notes` STRING COMMENT 'Free-text notes documenting the circumstances of GAP cure, including any non-standard resolution methods, underwriting exceptions, or curative actions taken to close the window.',
    `gap_duration_days` BIGINT COMMENT 'Number of calendar days between gap_start_date and gap_close_date (or current date if still open). Drives the policy-issuance-lag-after-recording and GAP aging metrics.',
    `gap_escalation_date` DATE COMMENT 'The date on which the open GAP coverage period was escalated to underwriting or management review due to exceeding the maximum allowed duration or elevated risk classification.',
    `gap_reference_number` STRING COMMENT 'Externally assigned or internally generated reference number uniquely identifying this GAP coverage period for operational tracking and audit purposes.',
    `gap_risk_flag` BOOLEAN COMMENT 'Underwriting risk classification assigned to this GAP period based on duration, jurisdiction, instrument type, and rejection history. Drives escalation and monitoring workflows.',
    `gap_start_date` DATE COMMENT 'The date on which the GAP coverage window opens. Typically the closing date or the date of the last title search, whichever is later, per ALTA gap coverage standards.',
    `gap_status` STRING COMMENT 'Current lifecycle status of the GAP coverage window. Open indicates recording not yet confirmed; closed indicates recording confirmed; expired indicates coverage lapsed without recording.. Valid values are `open|closed|expired|waived|under_review`',
    `gap_type` STRING COMMENT 'Classification of the GAP coverage period by transaction type. Distinguishes standard purchase GAP from construction, HELOC, or refinance GAP windows with different risk profiles.. Valid values are `standard|extended|construction|heloc|refi`',
    `instrument_number` STRING COMMENT 'The unique instrument or document number assigned by the county recorder upon recording. Used as the primary recording reference in jurisdictions that do not use book/page.',
    `insured_instrument_type` STRING COMMENT 'Type of the primary instrument pending recording that is covered during the GAP period. Examples include Warranty Deed (WD), Deed of Trust (DOT), or mortgage.. Valid values are `deed|deed_of_trust|mortgage|assignment|release|other`',
    `is_gap_exceeded` BOOLEAN COMMENT 'Indicates whether the GAP coverage window has exceeded the maximum allowed duration. True triggers underwriting escalation and potential coverage review per policy guidelines.',
    `jurisdiction_fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county or jurisdiction where recording is required. Drives jurisdiction-specific GAP duration rules and recording turnaround benchmarks.. Valid values are `^[0-9]{5}$`',
    `last_rejection_reason` STRING COMMENT 'The most recent reason provided by the county recorder for rejecting the recording submission. Supports root-cause analysis of recording delays that extend the GAP window.',
    `last_search_date` DATE COMMENT 'The date through which the title search was last run prior to closing. Used to establish the beginning of the GAP period when it precedes the closing date.',
    `max_allowed_gap_days` BIGINT COMMENT 'The maximum number of calendar days the GAP coverage window is permitted to remain open per underwriting guidelines or state regulatory requirements before escalation is required.',
    `page_number` STRING COMMENT 'The official page number assigned by the county recorder upon acceptance of the recorded instrument. Combined with book_number forms the complete recording reference.',
    `policy_issuance_lag_days` BIGINT COMMENT 'Number of calendar days between the confirmed recording_date and the date the title policy was issued. Directly supports the policy-issuance-lag-after-recording metric per VREQ-016.',
    `policy_issue_date` DATE COMMENT 'The date on which the title policy was issued following confirmed recording. Used to compute policy_issuance_lag_days and to confirm the GAP window is fully resolved.',
    `policy_type` STRING COMMENT 'Indicates whether the GAP coverage applies to the Owner Title Policy (OTP), Lender Title Policy (LTP), or both. Drives separate owner-versus-lender coverage tracking per VREQ-010.. Valid values are `owner|lender|both`',
    `record_version` BIGINT COMMENT 'Monotonically incrementing version number for this GAP coverage period record. Supports optimistic concurrency control and revision history tracking per VREQ-007.',
    `recording_confirmed_timestamp` TIMESTAMP COMMENT 'Precise timestamp when recording confirmation was received from the eRecording gateway or county recorder, marking the official close of the GAP coverage window.',
    `recording_date` DATE COMMENT 'The date on which the insured instruments were officially recorded by the county recorder or register of deeds, closing the GAP coverage window. Null until recording is confirmed.',
    `rejection_count` BIGINT COMMENT 'Number of times the recording submission was rejected by the county recorder prior to acceptance. Feeds the recording rejection and resubmission rate metric per VREQ-016.',
    `resubmission_date` DATE COMMENT 'The date of the most recent resubmission of instruments to the county recorder following a rejection. Null if no rejection has occurred.',
    `source_system_code` STRING COMMENT 'Identifies the operational system of record from which this GAP coverage period record originated. Supports data lineage and provenance tracking across the title lifecycle.. Valid values are `title_production|erecording_gateway|uw_system|manual`',
    `state_code` STRING COMMENT 'Two-letter US state abbreviation for the jurisdiction where the property is located and recording is performed. Used for state-level regulatory and underwriting rule application.. Valid values are `^[A-Z]{2}$`',
    `submission_date` DATE COMMENT 'The date on which the insured instruments were submitted to the county recorder or eRecording gateway. Distinct from closing_date, recording_date, and gap_start_date per VREQ-008.',
    `transaction_type` STRING COMMENT 'Classification of the underlying real estate transaction. Distinguishes purchase, refinance (REFI), HELOC, construction, and commercial transactions for GAP risk segmentation.. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this GAP coverage period record was last modified. Supports change tracking, audit trail, and lifecycle history preservation per VREQ-007.',
    `uw_referral_required` BOOLEAN COMMENT 'Indicates whether the extended GAP duration or non-standard cure method triggered an underwriting referral (UWR). True when gap_duration_days exceeds max_allowed_gap_days.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_gap_coverage_period PRIMARY KEY(`gap_coverage_period_id`)
) COMMENT 'Tracks the GAP coverage window for each title order — the legally significant interval between the closing date (or last search date) and the confirmed recording date of the insured instruments.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` (
    `fee_id` BIGINT COMMENT 'Unique surrogate identifier for a recording fee schedule record. Primary key for the fee reference master.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to recording.jurisdiction. Business justification: Fee schedules are jurisdiction-specific. The fee table currently has denormalized jurisdiction attributes (county_fips_code, state_code, recording_jurisdiction_name) that should be',
    `prior_fee_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding fee schedule record that this version supersedes. Enables chain-of-version navigation for audit and historical fee reconstruction.',
    `base_fee_amount` DECIMAL(12,2) COMMENT 'Flat base fee charged per document submission regardless of page count, expressed in USD. Represents the minimum recording charge for the instrument type in this jurisdiction.',
    `fee_code` STRING COMMENT 'Alphanumeric code assigned by the jurisdiction or the title production system (e.g., SoftPro/RamQuest) to uniquely identify this fee line within the county fee schedule.. Valid values are `^[A-Z0-9_]{2,30}$`',
    `consideration_threshold_amount` DECIMAL(14,2) COMMENT 'Minimum consideration amount above which transfer tax or documentary stamp tax applies. Transactions at or below this threshold may be exempt from the tax component.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fee schedule record was first created in the system. Supports audit trail and data lineage per ALTA Best Practices and SOC 2 requirements.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary fee amounts in this record. Defaults to USD for domestic US recording jurisdictions.. Valid values are `^[A-Z]{3}$`',
    `fee_description` STRING COMMENT 'Detailed narrative description of the fee, including statutory basis, applicability conditions, and any special instructions from the county recorder.',
    `documentary_stamp_rate` DECIMAL(10,6) COMMENT 'Ad valorem rate applied to the consideration or loan amount to compute documentary stamp tax, expressed as a decimal. Common in Florida and other southeastern states.',
    `effective_date` DATE COMMENT 'Date on which this fee schedule version becomes effective and must be applied to recording submissions. Supports lifecycle management and historical fee lookups.',
    `enacted_date` DATE COMMENT 'Date the underlying statute, ordinance, or county resolution authorizing this fee schedule was enacted or signed into law. Supports regulatory audit and provenance.',
    `erecording_gateway` STRING COMMENT 'Name of the eRecording gateway or submission channel accepted by this jurisdiction for electronic document submission (e.g., Simplifile, CSC eRecording, direct county portal).. Valid values are `Simplifile|CSC|ePN|direct|none`',
    `erecording_supported` BOOLEAN COMMENT 'Indicates whether the recording jurisdiction accepts electronic recording (eRecording) submissions via gateways such as Simplifile or CSC eRecording for this instrument type.',
    `expiration_date` DATE COMMENT 'Date on which this fee schedule version expires and is superseded. Null indicates the record is open-ended and currently active. Supports bi-temporal fee lookups.',
    `fee_status` STRING COMMENT 'Lifecycle status of this fee schedule record: active (currently in effect), inactive (no longer applicable), pending (approved but not yet effective), superseded (replaced by a newer version).. Valid values are `active|inactive|pending|superseded`',
    `fee_type` STRING COMMENT 'Classification of the fee component: base_recording (flat per-document fee), per_page (per-page charge), transfer_tax (deed transfer tax), documentary_stamp (documentary stamp tax), mortgage_tax (mortgage recording tax), indexing (indexing/data-entry fee).. Valid values are `base_recording|per_page|transfer_tax|documentary_stamp|mortgage_tax|indexing`',
    `included_pages` BIGINT COMMENT 'Number of pages included in the base recording fee before per-page charges apply. A value of zero means per-page fees apply from the first page.',
    `indexing_fee_amount` DECIMAL(10,2) COMMENT 'Flat fee charged by the county recorder for indexing the document in the grantor-grantee index, expressed in USD. May be per-name or per-document depending on jurisdiction.',
    `indexing_fee_basis` STRING COMMENT 'Basis on which the indexing fee is assessed: per_document (flat per submission), per_name (per grantor or grantee name indexed), or per_parcel (per APN/PIN indexed).. Valid values are `per_document|per_name|per_parcel`',
    `instrument_type` STRING COMMENT 'Category of recorded instrument to which this fee applies (e.g., Deed of Trust, Warranty Deed, Mortgage, Release, Assignment, Lien). [ENUM-REF-CANDIDATE',
    `last_verified_date` DATE COMMENT 'Date on which the fee schedule was last confirmed accurate against the official county recorder or state revenue department source. Supports data quality monitoring.',
    `max_pages` BIGINT COMMENT 'Maximum number of pages accepted under this fee schedule tier. Null indicates no page cap. Used to determine if a document requires a higher fee tier or split submission.',
    `mortgage_tax_rate` DECIMAL(10,6) COMMENT 'Ad valorem rate applied to the loan amount to compute mortgage recording tax, expressed as a decimal. Applicable in states such as New York, Florida, and Alabama.',
    `fee_name` STRING COMMENT 'Human-readable name of the fee as published by the recording jurisdiction or as labeled in the title production system (e.g., Deed Recording Fee, Per-Page Surcharge).',
    `notes` STRING COMMENT 'Free-text field for operational notes, special instructions, or known exceptions related to this fee schedule entry (e.g., Surcharge applies only to commercial deeds over $1M).',
    `paper_recording_accepted` BOOLEAN COMMENT 'Indicates whether the jurisdiction still accepts paper (physical) document submissions in addition to or instead of eRecording for this instrument type.',
    `per_page_fee_amount` DECIMAL(10,2) COMMENT 'Additional fee charged per page of the recorded document beyond any included pages, expressed in USD. Used to calculate total recording fee based on page_count.',
    `source_reference_url` STRING COMMENT 'URL of the official county recorder or state revenue department web page where this fee schedule is published. Supports provenance and verification of fee amounts.',
    `statutory_authority` STRING COMMENT 'Citation of the statute, code section, or county ordinance that authorizes this fee (e.g., Cal. Gov. Code § 27361, Fla. Stat. § 28.24). Supports compliance and audit.',
    `transfer_tax_exemption_available` BOOLEAN COMMENT 'Indicates whether statutory exemptions from transfer tax are available in this jurisdiction for qualifying transactions (e.g., inter-spousal transfers, government conveyances).',
    `transfer_tax_exemption_codes` STRING COMMENT 'Comma-separated list of jurisdiction-defined exemption codes that may be cited on the deed to claim transfer tax exemption (e.g., R11,R12 for California). Null if no exemptions apply.',
    `transfer_tax_per_unit_amount` DECIMAL(10,4) COMMENT 'Fixed transfer tax amount per unit of consideration (e.g., per $500 or per $1,000 of consideration), used in jurisdictions with tiered or per-unit transfer tax structures.',
    `transfer_tax_rate` DECIMAL(10,6) COMMENT 'Ad valorem rate applied to the consideration amount to compute deed transfer tax, expressed as a decimal (e.g., 0.001100 = 0.11%). Null if transfer tax is not applicable for this fee type.',
    `transfer_tax_unit_basis` DECIMAL(10,2) COMMENT 'The consideration increment (e.g., 500.00 or 1000.00 USD) used as the denominator for per-unit transfer tax calculations. Null if rate-based rather than per-unit.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this fee schedule record was last modified. Used to detect stale fee data and trigger re-verification workflows.',
    `verified_by` STRING COMMENT 'Name or identifier of the staff member, vendor, or automated process that last verified this fee schedule against the official source.',
    `version_number` BIGINT COMMENT 'Sequential version number for this fee schedule record within the same jurisdiction and instrument type. Increments each time the county updates its fee schedule, supporting history retention per VREQ-007.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_fee PRIMARY KEY(`fee_id`)
) COMMENT 'Reference master for county-level and instrument-type-level recording fee schedules maintained per jurisdiction (FIPS county code). Captures fee type (base recording fee, per-page fee, transfer tax, documentary stamp tax, mortgage tax, indexing fee), fee';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` (
    `jurisdiction_id` BIGINT COMMENT 'Unique surrogate identifier for each county recorder or register of deeds jurisdiction record in the title insurance recording master reference.',
    `erecording_jurisdiction_id` BIGINT COMMENT 'The jurisdiction identifier assigned by the eRecording gateway (e.g., Simplifile county code) used to route electronic submissions. Distinct from the FIPS code; required for gateway API calls.',
    `accepted_document_types` STRING COMMENT 'Comma-delimited list of document types accepted for recording by this jurisdiction (e.g., deed, deed_of_trust, mortgage, release, assignment, lien). Used for submission validation and routing.',
    `avg_recording_turnaround_days` BIGINT COMMENT 'Typical number of business days from submission to acceptance/recording confirmation for this jurisdiction. Used to estimate gap-period duration and policy issuance lag after recording.',
    `base_recording_fee_amount` DECIMAL(10,2) COMMENT 'Standard base recording fee charged by this jurisdiction per document submission, in USD. Used for settlement statement (CD/HUD-1/ALTA) fee estimation and escrow disbursement calculation.',
    `common_rejection_reasons` STRING COMMENT 'Free-text or comma-delimited list of the most frequent rejection reasons observed for this jurisdiction (e.g., missing notary seal, incorrect fee, margin violation). Used for submission quality improvement.',
    `county_name` STRING COMMENT 'Official name of the county or county-equivalent (e.g., parish, borough, independent city) as designated by the state government. Used for display, reporting, and document preparation.',
    `cover_sheet_required` BOOLEAN COMMENT 'Indicates whether this jurisdiction requires a standardized cover sheet (e.g., ALTA or county-specific) to be attached to each document submission. Drives document preparation workflow.',
    `cover_sheet_template_code` STRING COMMENT 'Internal code identifying the cover sheet template required by this jurisdiction. Used by the document preparation system to auto-attach the correct cover sheet to recording submissions.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this jurisdiction record was first created in the system. Supports audit trail and record provenance tracking per ALTA Best Practices data governance requirements.',
    `data_source` STRING COMMENT 'Source from which this jurisdiction records details were obtained or last refreshed (e.g., Simplifile county list, CSC eRecording, county website, PRIA directory, manual entry). Supports data lineage.. Valid values are `simplifile|csc_erecording|county_website|manual|pria|other`',
    `erecording_accepted` BOOLEAN COMMENT 'Indicates whether this jurisdiction accepts electronic recording (eRecording) submissions via an approved gateway such as Simplifile or CSC eRecording. Drives submission channel routing logic.',
    `erecording_gateway` STRING COMMENT 'Name of the eRecording gateway platform used to submit documents to this jurisdiction (e.g., Simplifile, CSC eRecording). Drives API routing and submission tracking integration.. Valid values are `simplifile|csc_erecording|indecomm|other|none`',
    `fee_effective_date` DATE COMMENT 'Date on which the current recording fee schedule (base_recording_fee_amount, fee_per_page_amount, transfer_tax_rate) became effective for this jurisdiction. Supports fee schedule versioning.',
    `fee_expiration_date` DATE COMMENT 'Date on which the current recording fee schedule expires or is superseded. Null indicates the fee schedule is open-ended. Used for fee schedule lifecycle management.',
    `fee_per_page_amount` DECIMAL(10,2) COMMENT 'Additional recording fee charged per page beyond the base fee, in USD. Used to calculate total recording fees for multi-page instruments on the settlement statement.',
    `fips_county_code` STRING COMMENT 'Five-digit FIPS code uniquely identifying the county or county-equivalent jurisdiction per NIST FIPS 6-4. Used as the primary geographic key for recording office lookup and eRecording gateway routing.. Valid values are `^[0-9]{5}$`',
    `font_size_minimum_pt` DECIMAL(4,1) COMMENT 'Minimum font size in points required for text in documents submitted to this jurisdiction. Enforced during document preparation to prevent rejection due to illegibility.',
    `gap_coverage_applicable` BOOLEAN COMMENT 'Indicates whether gap coverage (GAP) is applicable in this jurisdiction, covering the period between closing and confirmed recording. Drives gap-period risk monitoring and policy issuance lag tracking.',
    `in_person_submission_accepted` BOOLEAN COMMENT 'Indicates whether this jurisdiction accepts in-person document submission at the recording office counter. Used for same-day recording needs and courier delivery.',
    `ipen_accepted` BOOLEAN COMMENT 'Indicates whether this jurisdiction accepts documents notarized via In-Person Electronic Notarization (IPEN). Used alongside ron_accepted to determine eligible closing modalities.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this jurisdiction record was most recently modified. Used to detect stale fee schedules, outdated submission channel flags, or changed office contact information.',
    `last_verified_date` DATE COMMENT 'Date on which the jurisdiction record details (fees, channels, contact info) were last verified against the official county recorder source. Supports data quality monitoring and stale-reference alerting.',
    `mail_submission_accepted` BOOLEAN COMMENT 'Indicates whether this jurisdiction accepts document submissions via postal mail. Used as a fallback channel when eRecording is unavailable or rejected.',
    `margin_requirement_inches` DECIMAL(4,2) COMMENT 'Minimum margin size in inches required on all pages of documents submitted to this jurisdiction. Non-compliant margins are a common rejection cause; used in document preparation validation.',
    `max_pages_base_fee` BIGINT COMMENT 'Number of pages included in the base recording fee before per-page charges apply. Used with fee_per_page_amount to compute total recording fees for documents exceeding the base page threshold.',
    `notarization_required` BOOLEAN COMMENT 'Indicates whether notarization is required for documents submitted to this jurisdiction. Drives closing workflow requirements for notary scheduling and RON/IPEN eligibility.',
    `office_address_line1` STRING COMMENT 'Primary street address line of the recording office, used for mail and in-person document submission. Required when eRecording is unavailable or rejected documents must be physically resubmitted.',
    `office_address_line2` STRING COMMENT 'Secondary address line (suite, floor, room number) for the recording office. Supplements office_address_line1 for precise physical delivery of documents.',
    `office_city` STRING COMMENT 'City in which the recording office is physically located. Used in conjunction with state_code and office_zip_code for mail submission addressing and courier routing.',
    `office_email` STRING COMMENT 'Official email address for the recording office, used for submission inquiries, rejection notices, and correspondence regarding recorded instruments.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `office_fax` STRING COMMENT 'Fax number for the recording office, used in jurisdictions that accept fax-based document submission or rejection notice delivery.. Valid values are `^[0-9]{10}$`',
    `office_hours` STRING COMMENT 'Standard business hours of the recording office (e.g., Mon-Fri 08:00-17:00 CT). Used to determine same-day recording eligibility and courier delivery scheduling.',
    `office_phone` STRING COMMENT 'Primary telephone number for the recording office, used to resolve rejection inquiries, confirm receipt of mailed documents, and coordinate resubmission.. Valid values are `^[0-9]{10}$`',
    `office_status` STRING COMMENT 'Current operational status of the recording jurisdiction. Inactive or merged jurisdictions are retained for historical recording reference but blocked from new submission routing.. Valid values are `active|inactive|suspended|merged`',
    `office_website_url` STRING COMMENT 'Public website URL for the recording office, providing access to fee schedules, accepted document formats, cover-sheet requirements, and online search portals.',
    `office_zip_code` STRING COMMENT 'USPS ZIP or ZIP+4 code for the recording office mailing address. Used for mail submission routing and courier delivery confirmation.. Valid values are `^[0-9]{5}(-[0-9]{4})?$`',
    `plant_coverage_available` BOOLEAN COMMENT 'Indicates whether a title plant (DataTrace, TitlePoint, or county plant index) provides automated search coverage for this jurisdiction. Drives search channel selection in the title production system.',
    `plant_provider_name` STRING COMMENT 'Name of the title plant or automated search provider covering this jurisdiction (e.g., DataTrace, TitlePoint). Used for search order routing and vendor management.',
    `recording_act_type` STRING COMMENT 'Type of recording act governing priority of recorded instruments in this jurisdiction: race (first to record wins), notice (subsequent BFP without notice wins), or race_notice (both conditions required). Critical for chain-of-title analysis.. Valid values are `race|notice|race_notice`',
    `recording_office_name` STRING COMMENT 'Official name of the county recorder, register of deeds, or equivalent recording authority (e.g., Travis County Clerk, Cook County Recorder of Deeds). Used on cover sheets and submission routing.',
    `recording_office_type` STRING COMMENT 'Classification of the recording authority type, which varies by state (e.g., county_recorder in CA, register_of_deeds in MI, county_clerk in TX). Drives cover-sheet template and fee schedule selection.. Valid values are `county_recorder|register_of_deeds|county_clerk|circuit_court_clerk|other`',
    `recording_reference_format` STRING COMMENT 'Format used by this jurisdiction to assign recording references to accepted instruments (e.g., book/page, instrument number, document number). Determines how recording_reference_number is parsed and stored.. Valid values are `book_page|instrument_number|document_number|reception_number|other`',
    `rejection_rate_pct` DECIMAL(5,2) COMMENT 'Observed percentage of document submissions rejected by this jurisdiction, based on historical submission data. Used for recording rejection/resubmission rate metrics and operational risk monitoring.',
    `ron_accepted` BOOLEAN COMMENT 'Indicates whether this jurisdiction accepts documents notarized via Remote Online Notarization (RON). Drives closing channel eligibility and notarization workflow routing.',
    `same_day_recording_cutoff_time` TIMESTAMP COMMENT 'Local time (HH:MM, 24-hour) by which a document must be submitted to qualify for same-day recording in this jurisdiction. Critical for gap-period management and closing scheduling.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the state in which this recording jurisdiction is located (e.g., TX, CA, FL). Used for state-level recording rule application and regulatory routing.. Valid values are `^[A-Z]{2}$`',
    `state_specific_notes` STRING COMMENT 'Free-text field capturing jurisdiction-specific recording requirements, exceptions, or procedural notes not captured in structured fields (e.g., special deed tax stamps, unique cover sheet rules, holiday closures).',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the recording office (e.g., America/Chicago). Used to calculate same-day recording cutoff times and gap-period timestamps accurately.',
    `transfer_tax_basis` STRING COMMENT 'Specifies the taxable basis for documentary transfer tax in this jurisdiction (e.g., full consideration, equity only, loan amount). Required for accurate transfer tax calculation on the settlement statement.. Valid values are `full_consideration|equity_only|loan_amount|none`',
    `transfer_tax_rate` DECIMAL(10,6) COMMENT 'Documentary transfer tax rate applied to the consideration amount for deed recordings in this jurisdiction, expressed as a decimal (e.g., 0.001100 for $1.10 per $1,000). Used for settlement fee calculation.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_jurisdiction PRIMARY KEY(`jurisdiction_id`)
) COMMENT 'Master reference for every county recorder or register of deeds office that the business submits documents to. Captures FIPS county code, state, office name, recording office address, accepted submission channels (eRecording, mail, in-person), eRecording';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` (
    `submission_status_history_id` BIGINT COMMENT 'Unique surrogate identifier for each immutable status transition record in the recording submission lifecycle history. Primary key of this append-only event log.',
    `gateway_transaction_id` BIGINT COMMENT 'External transaction identifier assigned by the eRecording gateway for this specific status event or acknowledgment message, enabling reconciliation with gateway logs.',
    `party_id` BIGINT COMMENT 'Foreign key linking to operations.party. Business justification: Tracks which party (closer, examiner, agent, underwriter) initiated each submission status transition. Operational accountability and audit trail for recording workflow.',
    `recording_submission_id` BIGINT COMMENT 'Foreign key reference to the parent recording_submission record whose lifecycle this history row documents. Every history row belongs to exactly one submission.',
    `submission_document_id` BIGINT COMMENT 'Reference to the specific submission_document record associated with this status transition, linking the history event to the individual instrument being tracked.',
    `title_order_id` BIGINT COMMENT 'Reference to the originating title order that initiated the recording workflow, enabling end-to-end traceability from order intake through recording confirmation.',
    `acceptance_date` DATE COMMENT 'Date on which the county recorder or eRecording gateway formally accepted the submission for processing, distinct from the recording_date and submission_date per VREQ-008.',
    `book_number` STRING COMMENT 'Official book number assigned by the county recorder at recording, part of the book/page reference used in traditional deed indexing systems. Populated only upon confirmed recording.',
    `county_acknowledgment_code` STRING COMMENT 'Acknowledgment or confirmation code returned by the county recorder or eRecording gateway for this status event, used for reconciliation and dispute resolution with the recording authority.',
    `county_fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county recorder or register of deeds jurisdiction where this recording submission status event applies. Supports jurisdiction-level reporting.. Valid values are `^[0-9]{5}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this status history record was first written to the data store. Immutable audit field supporting append-only event log integrity and RECORD_AUDIT_CREATED requirement.',
    `curative_action_description` STRING COMMENT 'Description of the specific corrective action taken or required to resolve the rejection and enable resubmission, supporting curative aging and effectiveness tracking.',
    `curative_action_required` BOOLEAN COMMENT 'Indicates whether this rejection or status transition requires a curative action (document correction, fee adjustment, re-notarization) before resubmission can proceed.',
    `curative_completed_date` DATE COMMENT 'Date on which the curative action addressing a rejection was completed, enabling measurement of curative cycle time between rejection and resubmission readiness.',
    `days_in_prior_status` BIGINT COMMENT 'Number of calendar days the submission spent in status_from before transitioning to status_to. Supports title clearance cycle time and recording aging metrics per VREQ-016.',
    `document_type` STRING COMMENT 'Type of instrument being tracked in this status history event (e.g., Deed of Trust, Warranty Deed, Release). Supports document-type-level rejection rate analysis.',
    `erecording_gateway` STRING COMMENT 'The electronic recording gateway or channel through which this submission status event was transmitted or received (e.g., Simplifile, CSC eRecording). Supports gateway-level rejection rate analysis.. Valid values are `SIMPLIFILE|CSC_ERECORDING|INDECOMM|DIRECT_COUNTY|OTHER`',
    `event_source` STRING COMMENT 'System or actor that triggered this status transition. Identifies whether the change originated from the eRecording gateway, county recorder response, internal workflow, or manual override. Core EVENT_SOURCE_REFERENCE.. Valid values are `ERECORDING_GATEWAY|COUNTY_RECORDER|INTERNAL_SYSTEM|MANUAL_ENTRY|BATCH_PROCESS`',
    `event_timestamp` TIMESTAMP COMMENT 'Exact date and time (with timezone offset) when this status transition occurred, as recorded by the eRecording gateway or internal processing system. Core EVENT_TIMESTAMP for this log.',
    `fee_correction_flag` BOOLEAN COMMENT 'Indicates whether a recording fee correction was applied at this status transition, distinguishing fee-related rejections and corrections from other rejection types in root-cause analysis.',
    `gap_close_date` DATE COMMENT 'Date on which the GAP coverage period closed, typically upon confirmed recording. A null value indicates the gap remains open and the instrument is not yet confirmed recorded.',
    `gap_coverage_active` BOOLEAN COMMENT 'Indicates whether the GAP coverage period (between closing and confirmed recording) is active at the time of this status event, supporting gap-period risk monitoring.',
    `gap_duration_days` BIGINT COMMENT 'Number of calendar days the GAP coverage period was open as of this status event, calculated from gap_open_date. Supports gap-period aging and policy-issuance-lag-after-recording metrics.',
    `gap_open_date` DATE COMMENT 'Date on which the GAP coverage period opened (typically the closing/disbursement date), marking the start of the unrecorded instrument risk window for this submission.',
    `initiated_by_role` STRING COMMENT 'Business role of the actor who triggered this status transition, distinguishing automated gateway events from manual escrow officer or recording specialist actions for workflow analysis.',
    `initiated_by_user` STRING COMMENT 'Username or system account identifier of the person or automated process that triggered this status transition, supporting audit trail and accountability for manual overrides.',
    `instrument_number` STRING COMMENT 'Sequential instrument number assigned by the county recorder upon recording, used as the primary public index reference in jurisdictions that use instrument-number indexing rather than book/page.',
    `is_resubmission` BOOLEAN COMMENT 'Indicates whether this status transition represents a resubmission following a prior rejection, distinguishing initial submissions from corrective resubmissions in workflow analytics.',
    `is_terminal_state` BOOLEAN COMMENT 'Indicates whether status_to represents a terminal (final) state in the submission lifecycle (RECORDED or CANCELLED), enabling efficient filtering for open versus closed submissions.',
    `notes` STRING COMMENT 'Free-text notes entered by the recording specialist or system at the time of this status transition, capturing context not covered by structured fields (e.g., verbal county instructions).',
    `page_number` STRING COMMENT 'Official page number assigned by the county recorder at recording, completing the book/page reference. Populated only upon confirmed recording.',
    `policy_issuance_lag_days` BIGINT COMMENT 'Number of calendar days elapsed between the confirmed recording_date and the date a title policy was issued, as captured at this status event. Supports the policy-issuance-lag-after-recording metric per VREQ-016.',
    `recording_date` DATE COMMENT 'Official date on which the instrument was recorded by the county recorder, as confirmed at this status transition. Populated only when status_to = RECORDED. Distinct from submission_date and acceptance_date per VREQ-008.',
    `recording_fee_amount` DECIMAL(12,2) COMMENT 'Recording fee amount (USD) applicable at this status transition, which may differ from the original submission if a fee correction was required to resolve a rejection.',
    `recording_jurisdiction_name` STRING COMMENT 'Human-readable name of the county recorder or register of deeds office (e.g., Cook County Recorder of Deeds) associated with this status event, complementing the FIPS code.',
    `recording_reference_number` STRING COMMENT 'Official reference number assigned by the county recorder upon confirmed recording (e.g., instrument number, document number). Populated when status_to = RECORDED; null for pre-recording events.',
    `rejection_category` STRING COMMENT 'Normalized classification of the rejection cause, grouping raw rejection codes into analytical categories for rejection root-cause analysis and resubmission rate metrics.',
    `rejection_reason_code` STRING COMMENT 'Standardized code assigned by the county recorder or eRecording gateway identifying the specific reason for rejection at this transition (e.g., missing notary, incorrect fee, illegible document).',
    `rejection_reason_description` STRING COMMENT 'Free-text description of the rejection reason as returned by the county recorder or eRecording gateway, providing human-readable context for curative action and resubmission.',
    `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether the time spent in the prior status exceeded the applicable SLA threshold for that status, supporting recording turnaround SLA compliance monitoring.',
    `sla_threshold_days` BIGINT COMMENT 'The SLA threshold in calendar days applicable to the prior status at the time of this transition, against which days_in_prior_status is evaluated for breach determination.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the recording jurisdiction, supporting state-level regulatory reporting and recording rejection rate metrics.. Valid values are `^[A-Z]{2}$`',
    `status_from` STRING COMMENT 'The submission lifecycle status immediately before this transition. Enables full before/after audit trail. [ENUM-REF-CANDIDATE: DRAFT|SUBMITTED|PENDING_REVIEW|REJECTED|CORRECTED|RESUBMITTED|ACCEPTED|RECORDED|CANCELLED — promote to reference product]',
    `status_to` STRING COMMENT 'The submission lifecycle status entered as a result of this transition. Together with status_from, defines the complete state machine arc. [ENUM-REF-CANDIDATE: DRAFT|SUBMITTED|PENDING_REVIEW|REJECTED|CORRECTED|RESUBMITTED|ACCEPTED|RECORDED|CANCELLED —',
    `submission_attempt_number` BIGINT COMMENT 'Sequential count of the submission attempt associated with this status event (1 = initial, 2 = first resubmission, etc.). Supports recording rejection and resubmission rate metrics.',
    `submission_date` DATE COMMENT 'Date on which the recording package was submitted to the county recorder or eRecording gateway for this attempt, distinct from acceptance_date and recording_date per VREQ-008.',
    `transition_type` STRING COMMENT 'Categorical classification of the nature of this status change, distinguishing initial submissions from rejections, corrections, resubmissions, and final recording confirmations for workflow analytics.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_submission_status_history PRIMARY KEY(`submission_status_history_id`)
) COMMENT 'Immutable lifecycle history table preserving every status transition for a recording_submission — from initial submission through any rejections, curative corrections, resubmissions, and final acceptance or recording confirmation.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` (
    `gateway_transaction_id` BIGINT COMMENT 'Unique surrogate identifier for each eRecording gateway transaction exchange record. Primary key for the gateway_transaction entity.',
    `party_id` BIGINT COMMENT 'Identifier of the title company user or system account that initiated the gateway submission. Supports audit trail and accountability for recording submissions.',
    `prior_gateway_transaction_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding gateway transaction for the same recording_submission. Enables chain-of-resubmission traceability and lifecycle history preservation.',
    `recording_submission_id` BIGINT COMMENT 'Reference to the parent recording_submission that initiated this gateway transaction. Links the gateway exchange back to the title lifecycle recording event.',
    `acknowledgment_code` STRING COMMENT 'Gateway-issued acknowledgment code: ACK indicates the package was received and queued for county review; NACK indicates the package failed gateway pre-screen and was not forwarded.. Valid values are `ACK|NACK`',
    `acknowledgment_timestamp` TIMESTAMP COMMENT 'Date and time the eRecording gateway issued an ACK (acknowledgment) or NACK (negative acknowledgment) confirming receipt of the submitted package.',
    `closing_date` DATE COMMENT 'Date the real estate transaction closed, establishing the start of the GAP coverage window. Distinct from submission_timestamp and recording_date per VREQ-008.',
    `county_response_code` STRING COMMENT 'Machine-readable response code returned by the county recorder system indicating acceptance, rejection, or return status. Format varies by jurisdiction.',
    `county_response_message` STRING COMMENT 'Free-text message returned by the county recorder describing the acceptance confirmation, rejection reason, or return instructions for this gateway transaction.',
    `county_response_timestamp` TIMESTAMP COMMENT 'Date and time the county recorder or register of deeds returned an acceptance, rejection, or return response to the gateway for this transaction.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time this gateway_transaction record was first created in the system of record. Audit timestamp distinct from the business event submission_timestamp.',
    `document_count` BIGINT COMMENT 'Number of individual documents included in the gateway submission package for this transaction. A single submission may contain a deed, deed of trust, and other instruments.',
    `document_type_codes` STRING COMMENT 'Comma-delimited list of document type codes included in the submission package (e.g., WD, DOT, RECONVEYANCE, RELEASE). Supports instrument-level recording analysis.',
    `erecording_method` STRING COMMENT 'Indicates whether the document was submitted electronically (eRecording), as a paper document, or via a hybrid method. Supports eRecording adoption tracking.. Valid values are `ERECORDING|PAPER|HYBRID`',
    `fee_payment_method` STRING COMMENT 'Method used to remit the recording fee to the county recorder via the gateway (e.g., ACH, credit card, pre-funded gateway account, escrow account draw).. Valid values are `ACH|CREDIT_CARD|ESCROW_ACCOUNT|CHECK|GATEWAY_ACCOUNT`',
    `fee_payment_reference` STRING COMMENT 'Transaction reference number or confirmation code for the recording fee payment submitted with this gateway transaction. Used for fee reconciliation and dispute resolution.',
    `gap_coverage_days` BIGINT COMMENT 'Number of calendar days elapsed between the closing date and the confirmed recording_date, representing the GAP coverage exposure window. Computed at recording confirmation; null while gap_period_open is true.',
    `gap_period_open` BOOLEAN COMMENT 'Indicates whether the GAP coverage period (between closing and confirmed recording) remains open for this transaction. True until recording_date is confirmed and provenance fed back to the policy.',
    `gateway_account_code` STRING COMMENT 'Account identifier assigned by the eRecording gateway vendor to the submitting organization. Used for gateway billing, fee reconciliation, and access control.',
    `gateway_api_version` STRING COMMENT 'Version of the eRecording gateway API used for this transaction. Tracks API compatibility and supports troubleshooting of format or protocol changes.',
    `gateway_package_code` STRING COMMENT 'Externally assigned package identifier issued by the eRecording gateway vendor (e.g., Simplifile package ID, CSC eRecording package number) for this submission bundle.',
    `gateway_session_code` STRING COMMENT 'Session or connection identifier assigned by the eRecording gateway for the API or portal session during which this transaction was submitted. Supports gateway audit and troubleshooting.',
    `gateway_vendor` STRING COMMENT 'Name of the eRecording gateway vendor used to transmit documents to the county recorder or register of deeds (e.g., Simplifile, CSC eRecording, ePN).. Valid values are `SIMPLIFILE|CSC_ERECORDING|EPN|INDECOMM|DIRECT`',
    `is_expedited` BOOLEAN COMMENT 'Indicates whether this gateway transaction was flagged for expedited or priority recording processing at the county recorder. Used to track SLA performance for rush recordings.',
    `jurisdiction_fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county or jurisdiction to which the document package was submitted for recording. Enables jurisdiction-level recording performance analysis.. Valid values are `^[0-9]{5}$`',
    `jurisdiction_name` STRING COMMENT 'Human-readable name of the county recorder or register of deeds office receiving the submission (e.g., Cook County Recorder of Deeds). Complements the FIPS code for display and reporting.',
    `order_number` STRING COMMENT 'Title production system order number associated with this gateway transaction. Provides cross-reference to the originating title order for end-to-end lifecycle traceability.',
    `package_page_count` BIGINT COMMENT 'Total number of pages across all documents in the gateway submission package. Used for recording fee calculation and county intake validation.',
    `policy_issuance_lag_days` BIGINT COMMENT 'Number of calendar days between the confirmed recording_date and the date the title policy was issued. Key metric per VREQ-016 for policy issuance lag after recording.',
    `prescreen_failure_reason` STRING COMMENT 'Textual description of the reason the gateway pre-screen failed, as returned by the gateway vendor. Null when prescreen_status is PASSED or BYPASSED.',
    `prescreen_status` STRING COMMENT 'Result of the gateway vendor pre-screen validation applied before forwarding to the county recorder. FAILED indicates a format, fee, or completeness error caught at the gateway level.. Valid values are `PASSED|FAILED|BYPASSED`',
    `provenance_fed_back` BOOLEAN COMMENT 'Indicates whether the confirmed recording reference number and recording_date have been fed back to the title policy and title lifecycle records. Supports evidence completeness and provenance tracking.',
    `provenance_feedback_timestamp` TIMESTAMP COMMENT 'Date and time the recording reference number and recording_date were successfully fed back to the title production system and policy records. Null until provenance_fed_back is true.',
    `recording_date` DATE COMMENT 'Official date the document was recorded by the county recorder, as stamped on the recorded instrument. Distinct from submission_timestamp. Drives GAP coverage window closure and policy issuance lag metrics.',
    `recording_fee_amount` DECIMAL(12,2) COMMENT 'Total recording fee amount submitted to the county recorder with this gateway transaction, in US dollars. Includes per-page and per-document fees as applicable by jurisdiction.',
    `recording_fee_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the recording fee amount. Typically USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `recording_reference_number` STRING COMMENT 'Official recording reference number assigned by the county recorder upon acceptance, including book and page or instrument number. Null until county acceptance is confirmed.',
    `recording_timestamp` TIMESTAMP COMMENT 'Precise date and time the document was officially recorded by the county recorder, including time-of-day where available. Supports GAP period calculation at minute-level precision.',
    `rejection_reason_code` STRING COMMENT 'Standardized code categorizing the reason for county rejection (e.g., insufficient fee, missing notary, incorrect legal description). Drives rejection root-cause analysis. [ENUM-REF-CANDIDATE: promote to reference product]',
    `rejection_reason_description` STRING COMMENT 'Human-readable description of the county rejection reason, supplementing the rejection_reason_code with narrative detail for curative action and resubmission planning.',
    `resubmission_attempt_number` BIGINT COMMENT 'Sequential count of resubmission attempts for the parent recording_submission. Value is 0 for the initial submission and increments by 1 for each subsequent resubmission. Supports resubmission rate metrics.',
    `sla_actual_hours` DECIMAL(6,2) COMMENT 'Actual elapsed hours from submission_timestamp to county_response_timestamp for this transaction. Compared against sla_target_hours to assess recording cycle time performance.',
    `sla_target_hours` DECIMAL(6,2) COMMENT 'Service level agreement target turnaround time in hours from submission to county acceptance for this transaction, based on jurisdiction and transaction type.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the jurisdiction where the document is being recorded. Used for state-level regulatory reporting and recording fee schedules.. Valid values are `^[A-Z]{2}$`',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time the document package was transmitted outbound to the eRecording gateway. Principal business event timestamp for this transaction. Used to measure recording cycle time.',
    `submitter_organization` STRING COMMENT 'Name of the title company, branch, or independent agent organization that submitted the gateway transaction. Relevant for agency channel recording oversight.',
    `transaction_status` STRING COMMENT 'Current lifecycle status of this gateway transaction as reported by the eRecording gateway or county recorder. Drives recording rejection and resubmission rate metrics.. Valid values are `PENDING|ACKNOWLEDGED|ACCEPTED|REJECTED|RETURNED|CANCELLED`',
    `transaction_type` STRING COMMENT 'Classifies the nature of the gateway exchange: initial submission, resubmission after rejection, withdrawal, status inquiry, or rejection response. [ENUM-REF-CANDIDATE: promote if values expand]. Valid values are `SUBMISSION|RESUBMISSION|WITHDRAWAL|STATUS_INQUIRY|REJECTION_RESPONSE`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time this gateway_transaction record was last modified, such as when a county response was received or provenance was fed back. Supports lifecycle history preservation per VREQ-007.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_gateway_transaction PRIMARY KEY(`gateway_transaction_id`)
) COMMENT 'Transactional SSOT for each eRecording gateway exchange (Simplifile, CSC eRecording, ePN) associated with a recording_submission. Captures the gateway package identifier, gateway vendor, outbound submission acknowledgment (ACK/NACK), gateway pre-screen';

-- ========= FOREIGN KEYS =========
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ADD CONSTRAINT `fk_recording_recording_submission_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ADD CONSTRAINT `fk_recording_recording_submission_prior_submission_recording_submission_id` FOREIGN KEY (`prior_submission_recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ADD CONSTRAINT `fk_recording_recorded_instrument_gateway_transaction_id` FOREIGN KEY (`gateway_transaction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction`(`gateway_transaction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ADD CONSTRAINT `fk_recording_recorded_instrument_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ADD CONSTRAINT `fk_recording_submission_document_gateway_transaction_id` FOREIGN KEY (`gateway_transaction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction`(`gateway_transaction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ADD CONSTRAINT `fk_recording_submission_document_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ADD CONSTRAINT `fk_recording_rejection_event_gateway_transaction_id` FOREIGN KEY (`gateway_transaction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction`(`gateway_transaction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ADD CONSTRAINT `fk_recording_rejection_event_rejection_recording_submission_id` FOREIGN KEY (`rejection_recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ADD CONSTRAINT `fk_recording_rejection_event_rejection_resubmission_submission_recording_submission_id` FOREIGN KEY (`rejection_resubmission_submission_recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ADD CONSTRAINT `fk_recording_rejection_event_submission_document_id` FOREIGN KEY (`submission_document_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document`(`submission_document_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ADD CONSTRAINT `fk_recording_gap_coverage_period_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ADD CONSTRAINT `fk_recording_fee_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ADD CONSTRAINT `fk_recording_fee_prior_fee_id` FOREIGN KEY (`prior_fee_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee`(`fee_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ADD CONSTRAINT `fk_recording_jurisdiction_erecording_jurisdiction_id` FOREIGN KEY (`erecording_jurisdiction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ADD CONSTRAINT `fk_recording_submission_status_history_gateway_transaction_id` FOREIGN KEY (`gateway_transaction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction`(`gateway_transaction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ADD CONSTRAINT `fk_recording_submission_status_history_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ADD CONSTRAINT `fk_recording_submission_status_history_submission_document_id` FOREIGN KEY (`submission_document_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document`(`submission_document_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ADD CONSTRAINT `fk_recording_gateway_transaction_prior_gateway_transaction_id` FOREIGN KEY (`prior_gateway_transaction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction`(`gateway_transaction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ADD CONSTRAINT `fk_recording_gateway_transaction_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);

-- ========= TAGS =========
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_recording` SET TAGS ('title_division' = 'operations');
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_recording` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` SET TAGS ('title_subdomain' = 'submission_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `jurisdiction_id` SET TAGS ('title_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `prior_submission_recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Prior Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `settlement_statement_id` SET TAGS ('title_business_glossary_term' = 'Settlement Statement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `submitted_by_party_id` SET TAGS ('title_business_glossary_term' = 'Submitted By Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `consideration_amount` SET TAGS ('title_business_glossary_term' = 'Consideration Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `consideration_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `document_count` SET TAGS ('title_business_glossary_term' = 'Document Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `erecording_gateway` SET TAGS ('title_business_glossary_term' = 'eRecording Gateway');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `erecording_gateway` SET TAGS ('title_value_regex' = 'simplifile|csc_erecording|indecomm|other|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `erecording_transaction_id` SET TAGS ('title_business_glossary_term' = 'eRecording Transaction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `gap_close_date` SET TAGS ('title_business_glossary_term' = 'Gap Close Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `gap_coverage_flag` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `gap_open_date` SET TAGS ('title_business_glossary_term' = 'Gap Open Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `last_rejection_date` SET TAGS ('title_business_glossary_term' = 'Last Rejection Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `last_rejection_reason_code` SET TAGS ('title_business_glossary_term' = 'Last Rejection Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `last_rejection_reason_description` SET TAGS ('title_business_glossary_term' = 'Last Rejection Reason Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Recording Submission Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `policy_issuance_lag_days` SET TAGS ('title_business_glossary_term' = 'Policy Issuance Lag Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `primary_document_type` SET TAGS ('title_business_glossary_term' = 'Primary Document Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `recording_reference_number` SET TAGS ('title_business_glossary_term' = 'Recording Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `recording_timestamp` SET TAGS ('title_business_glossary_term' = 'Recording Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `rejection_count` SET TAGS ('title_business_glossary_term' = 'Rejection Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `resubmission_date` SET TAGS ('title_business_glossary_term' = 'Resubmission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `submission_method` SET TAGS ('title_business_glossary_term' = 'Recording Submission Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `submission_method` SET TAGS ('title_value_regex' = 'erecording|physical_delivery|mail|courier');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `submission_number` SET TAGS ('title_business_glossary_term' = 'Recording Submission Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `submission_status` SET TAGS ('title_business_glossary_term' = 'Recording Submission Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `submission_timestamp` SET TAGS ('title_business_glossary_term' = 'Submission Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `submitter_role` SET TAGS ('title_business_glossary_term' = 'Submitter Role');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `submitter_role` SET TAGS ('title_value_regex' = 'closing_agent|escrow_officer|title_agent|attorney|lender|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `total_recording_fee_amount` SET TAGS ('title_business_glossary_term' = 'Total Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `total_transfer_tax_amount` SET TAGS ('title_business_glossary_term' = 'Total Transfer Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `uw_referral_required` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` SET TAGS ('title_subdomain' = 'instrument_registry');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `recorded_instrument_id` SET TAGS ('title_business_glossary_term' = 'Recorded Instrument ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `gateway_transaction_id` SET TAGS ('title_business_glossary_term' = 'eRecording Transaction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `operations_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Title Claim Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `chain_of_title_break_flag` SET TAGS ('title_business_glossary_term' = 'Chain-of-Title Break Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `consideration_amount` SET TAGS ('title_business_glossary_term' = 'Consideration Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `consideration_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `document_image_reference` SET TAGS ('title_business_glossary_term' = 'Document Image Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `erecording_gateway` SET TAGS ('title_business_glossary_term' = 'eRecording Gateway');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `erecording_gateway` SET TAGS ('title_value_regex' = 'simplifile|csc_erecording|indecomm|direct_paper|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `gap_coverage_flag` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `grantee_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `grantor_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `instrument_status` SET TAGS ('title_business_glossary_term' = 'Instrument Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `instrument_status` SET TAGS ('title_value_regex' = 'accepted|indexed|released|superseded|voided');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `instrument_subtype` SET TAGS ('title_business_glossary_term' = 'Instrument Subtype');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `instrument_type` SET TAGS ('title_business_glossary_term' = 'Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `legal_description` SET TAGS ('title_business_glossary_term' = 'Legal Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `lien_priority` SET TAGS ('title_business_glossary_term' = 'Lien Priority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `lien_priority` SET TAGS ('title_value_regex' = 'first|second|third|subordinate|unknown');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `lien_type` SET TAGS ('title_business_glossary_term' = 'Lien Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `loan_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `mers_min` SET TAGS ('title_business_glossary_term' = 'Mortgage Electronic Registration Systems (MERS) Mortgage Identification Number (MIN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `mers_min` SET TAGS ('title_value_regex' = '^[0-9]{18}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `notarization_type` SET TAGS ('title_business_glossary_term' = 'Notarization Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `notarization_type` SET TAGS ('title_value_regex' = 'traditional|ron|ipen|remote_ink_notarization');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `notary_commission_expiration_date` SET TAGS ('title_business_glossary_term' = 'Notary Commission Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `notary_name` SET TAGS ('title_business_glossary_term' = 'Notary Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `notary_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `page_count` SET TAGS ('title_business_glossary_term' = 'Page Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `prior_instrument_number` SET TAGS ('title_business_glossary_term' = 'Prior Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `recording_fee_amount` SET TAGS ('title_business_glossary_term' = 'Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `recording_jurisdiction_name` SET TAGS ('title_business_glossary_term' = 'Recording Jurisdiction Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `recording_timestamp` SET TAGS ('title_business_glossary_term' = 'Recording Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `release_satisfaction_flag` SET TAGS ('title_business_glossary_term' = 'Release / Satisfaction Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `vesting_type` SET TAGS ('title_business_glossary_term' = 'Vesting Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `vesting_type` SET TAGS ('title_value_regex' = 'sole_ownership|joint_tenancy|tenancy_in_common|community_property|trust|entity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` SET TAGS ('title_subdomain' = 'submission_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `submission_document_id` SET TAGS ('title_business_glossary_term' = 'Submission Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `gateway_transaction_id` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Transaction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `consideration_amount` SET TAGS ('title_business_glossary_term' = 'Consideration Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `document_image_reference` SET TAGS ('title_business_glossary_term' = 'Document Image Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `document_sequence_number` SET TAGS ('title_business_glossary_term' = 'Document Sequence Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `document_status` SET TAGS ('title_business_glossary_term' = 'Document Recording Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `document_subtype` SET TAGS ('title_business_glossary_term' = 'Document Subtype');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `document_title` SET TAGS ('title_business_glossary_term' = 'Document Title');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `document_type` SET TAGS ('title_business_glossary_term' = 'Document Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `erecording_gateway` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Gateway');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `erecording_gateway` SET TAGS ('title_value_regex' = 'simplifile|csc_erecording|indecomm|direct_paper|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `gap_close_date` SET TAGS ('title_business_glossary_term' = 'Gap Period Close Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `gap_coverage_flag` SET TAGS ('title_business_glossary_term' = 'Gap Coverage (GAP) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `gap_open_date` SET TAGS ('title_business_glossary_term' = 'Gap Period Open Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `is_erecording_eligible` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Eligible Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `notarization_type` SET TAGS ('title_business_glossary_term' = 'Notarization Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `notarization_type` SET TAGS ('title_value_regex' = 'traditional|ron|ipen|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `notary_commission_expiration_date` SET TAGS ('title_business_glossary_term' = 'Notary Commission Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `notary_name` SET TAGS ('title_business_glossary_term' = 'Notary Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `page_count` SET TAGS ('title_business_glossary_term' = 'Page Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `policy_issuance_lag_days` SET TAGS ('title_business_glossary_term' = 'Policy Issuance Lag Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `priority_recording_flag` SET TAGS ('title_business_glossary_term' = 'Priority Recording Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `recording_fee_amount` SET TAGS ('title_business_glossary_term' = 'Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `recording_jurisdiction_name` SET TAGS ('title_business_glossary_term' = 'Recording Jurisdiction Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `recording_reference_number` SET TAGS ('title_business_glossary_term' = 'Recording Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `recording_timestamp` SET TAGS ('title_business_glossary_term' = 'Recording Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `rejection_count` SET TAGS ('title_business_glossary_term' = 'Rejection Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `rejection_reason_code` SET TAGS ('title_business_glossary_term' = 'Rejection Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `rejection_reason_description` SET TAGS ('title_business_glossary_term' = 'Rejection Reason Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `resubmission_date` SET TAGS ('title_business_glossary_term' = 'Resubmission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` SET TAGS ('title_subdomain' = 'submission_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_event_id` SET TAGS ('title_business_glossary_term' = 'Rejection Event ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `gateway_transaction_id` SET TAGS ('title_business_glossary_term' = 'eRecording Transaction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `operations_curative_action_id` SET TAGS ('title_business_glossary_term' = 'Operations Curative Action Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_resubmission_submission_recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Resubmission Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `submission_document_id` SET TAGS ('title_business_glossary_term' = 'Submission Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `assigned_to_user` SET TAGS ('title_business_glossary_term' = 'Assigned To User');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `corrected_fee_amount` SET TAGS ('title_business_glossary_term' = 'Corrected Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `county_name` SET TAGS ('title_business_glossary_term' = 'County Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `curative_action_description` SET TAGS ('title_business_glossary_term' = 'Curative Action Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `curative_action_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `days_open` SET TAGS ('title_business_glossary_term' = 'Days Open');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `document_reference_number` SET TAGS ('title_business_glossary_term' = 'Document Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `document_type` SET TAGS ('title_business_glossary_term' = 'Document Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `erecording_gateway_name` SET TAGS ('title_business_glossary_term' = 'eRecording Gateway Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `erecording_gateway_name` SET TAGS ('title_value_regex' = 'Simplifile|CSC_eRecording|direct_submission|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `escalated_to_underwriting` SET TAGS ('title_business_glossary_term' = 'Escalated to Underwriting Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `escalation_timestamp` SET TAGS ('title_business_glossary_term' = 'Escalation Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `gap_period_days` SET TAGS ('title_business_glossary_term' = 'Gap Period Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `gap_period_impacted` SET TAGS ('title_business_glossary_term' = 'Gap Period Impacted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Rejection Event Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `number` SET TAGS ('title_business_glossary_term' = 'Rejection Event Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `original_submission_date` SET TAGS ('title_business_glossary_term' = 'Original Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `policy_issuance_impacted` SET TAGS ('title_business_glossary_term' = 'Policy Issuance Impacted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `received_timestamp` SET TAGS ('title_business_glossary_term' = 'Rejection Received Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `recording_fee_amount` SET TAGS ('title_business_glossary_term' = 'Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_category` SET TAGS ('title_business_glossary_term' = 'Rejection Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_grain` SET TAGS ('title_business_glossary_term' = 'Rejection Grain Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_grain` SET TAGS ('title_value_regex' = 'submission|document');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_notice_date` SET TAGS ('title_business_glossary_term' = 'Rejection Notice Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_notice_text` SET TAGS ('title_business_glossary_term' = 'Rejection Notice Text');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_reason_code` SET TAGS ('title_business_glossary_term' = 'Rejection Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_reason_description` SET TAGS ('title_business_glossary_term' = 'Rejection Reason Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_sequence_number` SET TAGS ('title_business_glossary_term' = 'Rejection Sequence Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_source` SET TAGS ('title_business_glossary_term' = 'Rejection Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_source` SET TAGS ('title_value_regex' = 'county_recorder|erecording_gateway|register_of_deeds|state_office');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_status` SET TAGS ('title_business_glossary_term' = 'Rejection Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `rejection_status` SET TAGS ('title_value_regex' = 'open|resolved|resubmitted|waived|escalated|closed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `resolution_method` SET TAGS ('title_business_glossary_term' = 'Resolution Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `resolution_method` SET TAGS ('title_value_regex' = 'resubmission|waiver|withdrawal|escalation|county_override');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `resolution_timestamp` SET TAGS ('title_business_glossary_term' = 'Resolution Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `resubmission_date` SET TAGS ('title_business_glossary_term' = 'Resubmission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `resubmission_deadline_date` SET TAGS ('title_business_glossary_term' = 'Resubmission Deadline Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `sla_breached` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Breached Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `sla_target_days` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Target Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `source_system_rejection_code` SET TAGS ('title_business_glossary_term' = 'Source System Rejection ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` SET TAGS ('title_subdomain' = 'instrument_registry');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_coverage_period_id` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Period ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `title_claim_id` SET TAGS ('title_business_glossary_term' = 'Title Claim Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `title_commitment_id` SET TAGS ('title_business_glossary_term' = 'Title Commitment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Recording Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Recording Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `closing_date` SET TAGS ('title_business_glossary_term' = 'Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = 'USD');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `erecording_gateway` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Gateway');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `erecording_gateway` SET TAGS ('title_value_regex' = 'simplifile|csc_erecording|indecomm|direct_county|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_close_date` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Coverage Close Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_coverage_amount` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Coverage Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_cure_method` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Cure Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_cure_method` SET TAGS ('title_value_regex' = 'recording_confirmed|affidavit|indemnity|waiver|endorsement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_cure_notes` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Cure Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_duration_days` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Duration in Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_escalation_date` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Escalation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_reference_number` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Coverage Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_risk_flag` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Risk Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_start_date` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Coverage Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_status` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Coverage Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_status` SET TAGS ('title_value_regex' = 'open|closed|expired|waived|under_review');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_type` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Coverage Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `gap_type` SET TAGS ('title_value_regex' = 'standard|extended|construction|heloc|refi');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Recorded Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `insured_instrument_type` SET TAGS ('title_business_glossary_term' = 'Insured Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `insured_instrument_type` SET TAGS ('title_value_regex' = 'deed|deed_of_trust|mortgage|assignment|release|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `is_gap_exceeded` SET TAGS ('title_business_glossary_term' = 'Gap (GAP) Duration Exceeded Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `jurisdiction_fips_code` SET TAGS ('title_business_glossary_term' = 'Jurisdiction Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `jurisdiction_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `last_rejection_reason` SET TAGS ('title_business_glossary_term' = 'Last Recording Rejection Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `last_search_date` SET TAGS ('title_business_glossary_term' = 'Last Title Search Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `max_allowed_gap_days` SET TAGS ('title_business_glossary_term' = 'Maximum Allowed Gap (GAP) Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Recording Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `policy_issuance_lag_days` SET TAGS ('title_business_glossary_term' = 'Policy Issuance Lag After Recording (Days)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `policy_issue_date` SET TAGS ('title_business_glossary_term' = 'Policy Issue Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'owner|lender|both');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `record_version` SET TAGS ('title_business_glossary_term' = 'Record Version Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `recording_confirmed_timestamp` SET TAGS ('title_business_glossary_term' = 'Recording Confirmed Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `rejection_count` SET TAGS ('title_business_glossary_term' = 'Recording Rejection Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `resubmission_date` SET TAGS ('title_business_glossary_term' = 'Recording Resubmission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `source_system_code` SET TAGS ('title_value_regex' = 'title_production|erecording_gateway|uw_system|manual');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Recording Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `uw_referral_required` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` SET TAGS ('title_data_type' = 'reference_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` SET TAGS ('title_subdomain' = 'jurisdiction_reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `fee_id` SET TAGS ('title_business_glossary_term' = 'Recording Fee Schedule ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `jurisdiction_id` SET TAGS ('title_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `prior_fee_id` SET TAGS ('title_business_glossary_term' = 'Prior Fee Schedule ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `base_fee_amount` SET TAGS ('title_business_glossary_term' = 'Base Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `fee_code` SET TAGS ('title_business_glossary_term' = 'Recording Fee Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `fee_code` SET TAGS ('title_value_regex' = '^[A-Z0-9_]{2,30}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `consideration_threshold_amount` SET TAGS ('title_business_glossary_term' = 'Consideration Threshold Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `fee_description` SET TAGS ('title_business_glossary_term' = 'Recording Fee Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `documentary_stamp_rate` SET TAGS ('title_business_glossary_term' = 'Documentary Stamp Tax Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Fee Schedule Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `enacted_date` SET TAGS ('title_business_glossary_term' = 'Fee Schedule Enacted Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `erecording_gateway` SET TAGS ('title_business_glossary_term' = 'eRecording Gateway');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `erecording_gateway` SET TAGS ('title_value_regex' = 'Simplifile|CSC|ePN|direct|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `erecording_supported` SET TAGS ('title_business_glossary_term' = 'eRecording Supported Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Fee Schedule Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `fee_status` SET TAGS ('title_business_glossary_term' = 'Recording Fee Schedule Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `fee_status` SET TAGS ('title_value_regex' = 'active|inactive|pending|superseded');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `fee_type` SET TAGS ('title_business_glossary_term' = 'Recording Fee Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `fee_type` SET TAGS ('title_value_regex' = 'base_recording|per_page|transfer_tax|documentary_stamp|mortgage_tax|indexing');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `included_pages` SET TAGS ('title_business_glossary_term' = 'Included Pages');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `indexing_fee_amount` SET TAGS ('title_business_glossary_term' = 'Indexing Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `indexing_fee_basis` SET TAGS ('title_business_glossary_term' = 'Indexing Fee Basis');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `indexing_fee_basis` SET TAGS ('title_value_regex' = 'per_document|per_name|per_parcel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `instrument_type` SET TAGS ('title_business_glossary_term' = 'Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `last_verified_date` SET TAGS ('title_business_glossary_term' = 'Last Verified Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `max_pages` SET TAGS ('title_business_glossary_term' = 'Maximum Pages');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `mortgage_tax_rate` SET TAGS ('title_business_glossary_term' = 'Mortgage Recording Tax Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `fee_name` SET TAGS ('title_business_glossary_term' = 'Recording Fee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Fee Schedule Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `paper_recording_accepted` SET TAGS ('title_business_glossary_term' = 'Paper Recording Accepted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `per_page_fee_amount` SET TAGS ('title_business_glossary_term' = 'Per-Page Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `source_reference_url` SET TAGS ('title_business_glossary_term' = 'Source Reference URL');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `statutory_authority` SET TAGS ('title_business_glossary_term' = 'Statutory Authority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `transfer_tax_exemption_available` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Exemption Available Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `transfer_tax_exemption_codes` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Exemption Codes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `transfer_tax_per_unit_amount` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Per-Unit Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `transfer_tax_rate` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `transfer_tax_unit_basis` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Unit Basis Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `verified_by` SET TAGS ('title_business_glossary_term' = 'Verified By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `version_number` SET TAGS ('title_business_glossary_term' = 'Fee Schedule Version Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` SET TAGS ('title_subdomain' = 'jurisdiction_reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `jurisdiction_id` SET TAGS ('title_business_glossary_term' = 'Jurisdiction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `erecording_jurisdiction_id` SET TAGS ('title_business_glossary_term' = 'eRecording Gateway Jurisdiction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `accepted_document_types` SET TAGS ('title_business_glossary_term' = 'Accepted Document Types');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `avg_recording_turnaround_days` SET TAGS ('title_business_glossary_term' = 'Average Recording Turnaround Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `base_recording_fee_amount` SET TAGS ('title_business_glossary_term' = 'Base Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `common_rejection_reasons` SET TAGS ('title_business_glossary_term' = 'Common Rejection Reasons');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `county_name` SET TAGS ('title_business_glossary_term' = 'County Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `cover_sheet_required` SET TAGS ('title_business_glossary_term' = 'Cover Sheet Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `cover_sheet_template_code` SET TAGS ('title_business_glossary_term' = 'Cover Sheet Template Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `data_source` SET TAGS ('title_business_glossary_term' = 'Data Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `data_source` SET TAGS ('title_value_regex' = 'simplifile|csc_erecording|county_website|manual|pria|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `erecording_accepted` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Accepted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `erecording_gateway` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Gateway');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `erecording_gateway` SET TAGS ('title_value_regex' = 'simplifile|csc_erecording|indecomm|other|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `fee_effective_date` SET TAGS ('title_business_glossary_term' = 'Fee Schedule Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `fee_expiration_date` SET TAGS ('title_business_glossary_term' = 'Fee Schedule Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `fee_per_page_amount` SET TAGS ('title_business_glossary_term' = 'Fee Per Page Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `fips_county_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `fips_county_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `font_size_minimum_pt` SET TAGS ('title_business_glossary_term' = 'Minimum Font Size (Points)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `gap_coverage_applicable` SET TAGS ('title_business_glossary_term' = 'Gap Coverage (GAP) Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `in_person_submission_accepted` SET TAGS ('title_business_glossary_term' = 'In-Person Submission Accepted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `ipen_accepted` SET TAGS ('title_business_glossary_term' = 'In-Person Electronic Notarization (IPEN) Accepted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `last_updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `last_verified_date` SET TAGS ('title_business_glossary_term' = 'Last Verified Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `mail_submission_accepted` SET TAGS ('title_business_glossary_term' = 'Mail Submission Accepted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `margin_requirement_inches` SET TAGS ('title_business_glossary_term' = 'Document Margin Requirement (Inches)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `max_pages_base_fee` SET TAGS ('title_business_glossary_term' = 'Maximum Pages Included in Base Fee');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `notarization_required` SET TAGS ('title_business_glossary_term' = 'Notarization Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_address_line1` SET TAGS ('title_business_glossary_term' = 'Recording Office Address Line 1');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_address_line1` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_address_line1` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_address_line2` SET TAGS ('title_business_glossary_term' = 'Recording Office Address Line 2');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_address_line2` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_address_line2` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_city` SET TAGS ('title_business_glossary_term' = 'Recording Office City');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_city` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_city` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_email` SET TAGS ('title_business_glossary_term' = 'Recording Office Email Address');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_email` SET TAGS ('title_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_email` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_email` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_fax` SET TAGS ('title_business_glossary_term' = 'Recording Office Fax Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_fax` SET TAGS ('title_value_regex' = '^[0-9]{10}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_fax` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_fax` SET TAGS ('title_pii_phone' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_hours` SET TAGS ('title_business_glossary_term' = 'Recording Office Hours');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_phone` SET TAGS ('title_business_glossary_term' = 'Recording Office Phone Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_phone` SET TAGS ('title_value_regex' = '^[0-9]{10}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_phone` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_phone` SET TAGS ('title_pii_phone' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_status` SET TAGS ('title_business_glossary_term' = 'Recording Office Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_status` SET TAGS ('title_value_regex' = 'active|inactive|suspended|merged');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_website_url` SET TAGS ('title_business_glossary_term' = 'Recording Office Website URL');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_zip_code` SET TAGS ('title_business_glossary_term' = 'Recording Office ZIP Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_zip_code` SET TAGS ('title_value_regex' = '^[0-9]{5}(-[0-9]{4})?$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_zip_code` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `office_zip_code` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `plant_coverage_available` SET TAGS ('title_business_glossary_term' = 'Title Plant Coverage Available Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `plant_provider_name` SET TAGS ('title_business_glossary_term' = 'Title Plant Provider Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `recording_act_type` SET TAGS ('title_business_glossary_term' = 'Recording Act Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `recording_act_type` SET TAGS ('title_value_regex' = 'race|notice|race_notice');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `recording_office_name` SET TAGS ('title_business_glossary_term' = 'Recording Office Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `recording_office_type` SET TAGS ('title_business_glossary_term' = 'Recording Office Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `recording_office_type` SET TAGS ('title_value_regex' = 'county_recorder|register_of_deeds|county_clerk|circuit_court_clerk|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `recording_reference_format` SET TAGS ('title_business_glossary_term' = 'Recording Reference Format');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `recording_reference_format` SET TAGS ('title_value_regex' = 'book_page|instrument_number|document_number|reception_number|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `rejection_rate_pct` SET TAGS ('title_business_glossary_term' = 'Recording Rejection Rate Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `ron_accepted` SET TAGS ('title_business_glossary_term' = 'Remote Online Notarization (RON) Accepted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `same_day_recording_cutoff_time` SET TAGS ('title_business_glossary_term' = 'Same-Day Recording Cutoff Time');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `state_specific_notes` SET TAGS ('title_business_glossary_term' = 'State-Specific Recording Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `time_zone` SET TAGS ('title_business_glossary_term' = 'Recording Office Time Zone');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `transfer_tax_basis` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Basis');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `transfer_tax_basis` SET TAGS ('title_value_regex' = 'full_consideration|equity_only|loan_amount|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `transfer_tax_rate` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` SET TAGS ('title_subdomain' = 'submission_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `submission_status_history_id` SET TAGS ('title_business_glossary_term' = 'Submission Status History ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `gateway_transaction_id` SET TAGS ('title_business_glossary_term' = 'eRecording Gateway Transaction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `submission_document_id` SET TAGS ('title_business_glossary_term' = 'Submission Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `county_acknowledgment_code` SET TAGS ('title_business_glossary_term' = 'County Acknowledgment Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `curative_action_description` SET TAGS ('title_business_glossary_term' = 'Curative Action Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `curative_action_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `curative_completed_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Completed Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `days_in_prior_status` SET TAGS ('title_business_glossary_term' = 'Days in Prior Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `document_type` SET TAGS ('title_business_glossary_term' = 'Document Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `erecording_gateway` SET TAGS ('title_business_glossary_term' = 'eRecording Gateway');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `erecording_gateway` SET TAGS ('title_value_regex' = 'SIMPLIFILE|CSC_ERECORDING|INDECOMM|DIRECT_COUNTY|OTHER');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `event_source` SET TAGS ('title_business_glossary_term' = 'Status Event Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `event_source` SET TAGS ('title_value_regex' = 'ERECORDING_GATEWAY|COUNTY_RECORDER|INTERNAL_SYSTEM|MANUAL_ENTRY|BATCH_PROCESS');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `event_timestamp` SET TAGS ('title_business_glossary_term' = 'Status Event Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `fee_correction_flag` SET TAGS ('title_business_glossary_term' = 'Fee Correction Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `gap_close_date` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Close Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `gap_coverage_active` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Active Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `gap_duration_days` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Duration (Days)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `gap_open_date` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Open Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `initiated_by_role` SET TAGS ('title_business_glossary_term' = 'Initiated By Role');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `initiated_by_user` SET TAGS ('title_business_glossary_term' = 'Initiated By User');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `is_resubmission` SET TAGS ('title_business_glossary_term' = 'Resubmission Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `is_terminal_state` SET TAGS ('title_business_glossary_term' = 'Terminal State Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Status Transition Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `policy_issuance_lag_days` SET TAGS ('title_business_glossary_term' = 'Policy Issuance Lag (Days)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `recording_fee_amount` SET TAGS ('title_business_glossary_term' = 'Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `recording_jurisdiction_name` SET TAGS ('title_business_glossary_term' = 'Recording Jurisdiction Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `recording_reference_number` SET TAGS ('title_business_glossary_term' = 'Recording Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `rejection_category` SET TAGS ('title_business_glossary_term' = 'Rejection Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `rejection_reason_code` SET TAGS ('title_business_glossary_term' = 'Recording Rejection Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `rejection_reason_description` SET TAGS ('title_business_glossary_term' = 'Recording Rejection Reason Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `sla_breach_flag` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `sla_threshold_days` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Threshold (Days)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `status_from` SET TAGS ('title_business_glossary_term' = 'Prior Submission Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `status_to` SET TAGS ('title_business_glossary_term' = 'New Submission Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `submission_attempt_number` SET TAGS ('title_business_glossary_term' = 'Submission Attempt Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `transition_type` SET TAGS ('title_business_glossary_term' = 'Status Transition Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` SET TAGS ('title_domain' = 'recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` SET TAGS ('title_subdomain' = 'submission_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `gateway_transaction_id` SET TAGS ('title_business_glossary_term' = 'Gateway Transaction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Submitter User Identifier');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `party_id` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `party_id` SET TAGS ('title_pii' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `prior_gateway_transaction_id` SET TAGS ('title_business_glossary_term' = 'Prior Gateway Transaction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `acknowledgment_code` SET TAGS ('title_business_glossary_term' = 'Gateway Acknowledgment Code (ACK/NACK)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `acknowledgment_code` SET TAGS ('title_value_regex' = 'ACK|NACK');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `acknowledgment_timestamp` SET TAGS ('title_business_glossary_term' = 'Gateway Acknowledgment (ACK) Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `closing_date` SET TAGS ('title_business_glossary_term' = 'Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `county_response_code` SET TAGS ('title_business_glossary_term' = 'County Recorder Response Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `county_response_message` SET TAGS ('title_business_glossary_term' = 'County Recorder Response Message');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `county_response_timestamp` SET TAGS ('title_business_glossary_term' = 'County Recorder Response Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `document_count` SET TAGS ('title_business_glossary_term' = 'Document Count in Package');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `document_type_codes` SET TAGS ('title_business_glossary_term' = 'Document Type Codes in Package');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `erecording_method` SET TAGS ('title_business_glossary_term' = 'eRecording Submission Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `erecording_method` SET TAGS ('title_value_regex' = 'ERECORDING|PAPER|HYBRID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `fee_payment_method` SET TAGS ('title_business_glossary_term' = 'Recording Fee Payment Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `fee_payment_method` SET TAGS ('title_value_regex' = 'ACH|CREDIT_CARD|ESCROW_ACCOUNT|CHECK|GATEWAY_ACCOUNT');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `fee_payment_reference` SET TAGS ('title_business_glossary_term' = 'Recording Fee Payment Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `gap_coverage_days` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Period Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `gap_period_open` SET TAGS ('title_business_glossary_term' = 'Gap Period Open Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `gateway_account_code` SET TAGS ('title_business_glossary_term' = 'Gateway Account Identifier');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `gateway_api_version` SET TAGS ('title_business_glossary_term' = 'Gateway API Version');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `gateway_package_code` SET TAGS ('title_business_glossary_term' = 'Gateway Package Identifier');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `gateway_session_code` SET TAGS ('title_business_glossary_term' = 'Gateway Session Identifier');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `gateway_vendor` SET TAGS ('title_business_glossary_term' = 'eRecording Gateway Vendor');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `gateway_vendor` SET TAGS ('title_value_regex' = 'SIMPLIFILE|CSC_ERECORDING|EPN|INDECOMM|DIRECT');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `is_expedited` SET TAGS ('title_business_glossary_term' = 'Expedited Recording Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `jurisdiction_fips_code` SET TAGS ('title_business_glossary_term' = 'Jurisdiction Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `jurisdiction_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `jurisdiction_name` SET TAGS ('title_business_glossary_term' = 'Recording Jurisdiction Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `order_number` SET TAGS ('title_business_glossary_term' = 'Title Order Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `package_page_count` SET TAGS ('title_business_glossary_term' = 'Package Total Page Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `policy_issuance_lag_days` SET TAGS ('title_business_glossary_term' = 'Policy Issuance Lag Days After Recording');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `prescreen_failure_reason` SET TAGS ('title_business_glossary_term' = 'Gateway Pre-Screen Failure Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `prescreen_status` SET TAGS ('title_business_glossary_term' = 'Gateway Pre-Screen Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `prescreen_status` SET TAGS ('title_value_regex' = 'PASSED|FAILED|BYPASSED');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `provenance_fed_back` SET TAGS ('title_business_glossary_term' = 'Recording Provenance Fed Back Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `provenance_feedback_timestamp` SET TAGS ('title_business_glossary_term' = 'Recording Provenance Feedback Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `recording_fee_amount` SET TAGS ('title_business_glossary_term' = 'Recording Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `recording_fee_currency` SET TAGS ('title_business_glossary_term' = 'Recording Fee Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `recording_fee_currency` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `recording_reference_number` SET TAGS ('title_business_glossary_term' = 'Recording Reference Number (Book/Page)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `recording_timestamp` SET TAGS ('title_business_glossary_term' = 'Recording Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `rejection_reason_code` SET TAGS ('title_business_glossary_term' = 'Recording Rejection Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `rejection_reason_description` SET TAGS ('title_business_glossary_term' = 'Recording Rejection Reason Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `resubmission_attempt_number` SET TAGS ('title_business_glossary_term' = 'Resubmission Attempt Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `sla_actual_hours` SET TAGS ('title_business_glossary_term' = 'Recording SLA Actual Hours');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `sla_target_hours` SET TAGS ('title_business_glossary_term' = 'Recording SLA Target Hours');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `submission_timestamp` SET TAGS ('title_business_glossary_term' = 'Gateway Submission Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `submitter_organization` SET TAGS ('title_business_glossary_term' = 'Submitter Organization Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `transaction_status` SET TAGS ('title_business_glossary_term' = 'Gateway Transaction Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `transaction_status` SET TAGS ('title_value_regex' = 'PENDING|ACKNOWLEDGED|ACCEPTED|REJECTED|RETURNED|CANCELLED');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Gateway Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'SUBMISSION|RESUBMISSION|WITHDRAWAL|STATUS_INQUIRY|REJECTION_RESPONSE');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
