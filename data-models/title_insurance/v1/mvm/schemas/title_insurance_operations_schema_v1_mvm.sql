-- Schema for Domain: operations | Business: Title_Insurance | Version: v1_mvm
-- Generated on: 2026-10-31 06:39:30

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `serverless_stable_dvmvgw_catalog`.`ti_operations` COMMENT 'Core operational backbone owning the title-production transaction spine: title-order intake and channel routing (direct branch, centralized lender, independent agent), order lifecycle and status tracking, transaction-type classification (purchase';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` (
    `title_order_id` BIGINT COMMENT 'Unique surrogate identifier for the title order record. Primary key for the title_order entity in the operations domain.',
    `agent_profile_id` BIGINT COMMENT 'References the independent title agent profile when the order is produced through the independent agent channel. Null for direct branch and centralized lender orders.',
    `order_channel_id` BIGINT COMMENT 'References the order channel through which this title order was received (direct branch, centralized lender, or independent agent).',
    `parcel_id` BIGINT COMMENT 'References the parcel record associated with the subject property for this title order.',
    `actual_closing_date` DATE COMMENT 'Date the transaction actually closed and funds were disbursed. Populated post-closing. Used for cycle-time analysis and comparison against scheduled closing date.',
    `apn` STRING COMMENT 'Assessors Parcel Number assigned by the county assessor to uniquely identify the subject property for tax and recording purposes. Also known as PIN in some jurisdictions.',
    `buyer_name` STRING COMMENT 'Full legal name of the buyer (purchase) or borrower (refinance/HELOC). Restricted PII. Used for vesting, policy issuance, and NPPI-controlled workflows.',
    `cancellation_date` DATE COMMENT 'Date the title order was cancelled, if applicable. Populated only when order_status is cancelled. Used for fallout analysis and pipeline reporting.',
    `cancellation_reason` STRING COMMENT 'Reason code for order cancellation. Used for fallout root-cause analysis and pipeline management reporting.. Valid values are `buyer_withdrew|financing_fell_through|property_issue|duplicate_order|lender_cancelled|other`',
    `closing_disclosure_form_type` STRING COMMENT 'Type of settlement/closing disclosure form required: Closing Disclosure (CD) for TRID loans, HUD-1 for pre-TRID or exempt, ALTA Settlement Statement, or none for non-applicable transactions.. Valid values are `cd|hud1|alta_ss|none`',
    `county_name` STRING COMMENT 'County name where the subject property is located. Determines the recording jurisdiction and county recorder/register of deeds office for document submission.',
    `cpl_required` BOOLEAN COMMENT 'Indicates whether a Closing Protection Letter (CPL) must be issued to the lender for this order. Required by most institutional lenders for independent agent closings.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the title_order record was first created in the data platform. Audit field for record provenance and lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this order. Defaults to USD for domestic US transactions.. Valid values are `^[A-Z]{3}$`',
    `erecording_enabled` BOOLEAN COMMENT 'Indicates whether documents for this order will be submitted via eRecording (e.g., Simplifile, CSC eRecording) rather than physical recording at the county recorders office.',
    `escrow_officer_name` STRING COMMENT 'Name of the escrow officer or closing agent assigned to manage the escrow trust account and closing for this title order.',
    `fips_code` STRING COMMENT 'Five-digit FIPS county code identifying the county of the subject property. Used for county-level regulatory reporting, recording jurisdiction routing, and MERS reporting.. Valid values are `^[0-9]{5}$`',
    `iolta_required` BOOLEAN COMMENT 'Indicates whether escrow funds must be held in an IOLTA-compliant trust account for this order, as required by state bar rules in applicable jurisdictions.',
    `lender_loan_number` STRING COMMENT 'Lender-assigned loan number for cross-referencing the title order with the lenders origination system. Required for TRID compliance and closing disclosure reconciliation.',
    `lender_name` STRING COMMENT 'Name of the mortgage lender or financial institution ordering the lender title policy. Key party reference for lender channel routing and CPL issuance.',
    `lender_policy_required` BOOLEAN COMMENT 'Indicates whether a lenders title policy (LTP) is required for this order. Typically required by the mortgage lender as a condition of the loan.',
    `loan_amount` DECIMAL(15,2) COMMENT 'Principal loan amount in US dollars for which the lender title policy (LTP) will be issued. Drives lender policy premium calculation and LTV/CLTV analysis.',
    `ltv_ratio` DECIMAL(6,4) COMMENT 'Ratio of the loan amount to the property sales price or appraised value, expressed as a decimal (e.g., 0.8000 = 80%). Used for underwriting risk tier assignment and referral thresholds.',
    `mers_reporting_required` BOOLEAN COMMENT 'Indicates whether the mortgage instrument must be registered with MERS. Applicable when the lender uses MERS as the mortgagee of record.',
    `order_date` DATE COMMENT 'Calendar date the title order was received and entered into the Title Production System. Serves as the BUSINESS_EVENT_TIMESTAMP anchor for SLA and cycle-time measurement.',
    `order_notes` STRING COMMENT 'Free-text operational notes entered by intake staff or processors regarding special instructions, lender requirements, or order-specific conditions.',
    `order_number` STRING COMMENT 'Externally visible, human-readable order number assigned at intake by the Title Production System (e.g., SoftPro, RamQuest, Qualia). Used across all downstream modules.. Valid values are `^[A-Z0-9-]{6,30}$`',
    `order_received_timestamp` TIMESTAMP COMMENT 'Precise date and time the title order was received by the system, including timezone offset. Used for intraday SLA measurement and intake-to-search cycle-time analytics.',
    `order_status` STRING COMMENT 'Current lifecycle status of the title order from intake through closing. Drives workflow routing and SLA tracking. [ENUM-REF-CANDIDATE: open|in_search|in_examination|commitment_issued|cleared_to_close|closed|cancelled|on_hold — promote to reference',
    `owner_policy_required` BOOLEAN COMMENT 'Indicates whether an owners title policy (OTP) is required or requested for this order. Drives policy issuance workflow and premium calculation.',
    `prior_order_number` STRING COMMENT 'Order number of a prior title order on the same property, if this order is a continuation, reissue, or refinance of a previous transaction. Supports chain-of-title and reissue rate credit.',
    `production_source` STRING COMMENT 'Identifies the production channel source for this order: direct branch, centralized lender, or independent agent. Used for revenue attribution and channel performance reporting.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `property_address_line1` STRING COMMENT 'Primary street address line of the subject property for this title order. Denormalized here for operational convenience and search/reporting without joining to property.',
    `property_city` STRING COMMENT 'City of the subject property. Used for jurisdiction routing, state filing, and geographic reporting.',
    `property_state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the subject property. Drives state-specific underwriting rules, rate filings, and regulatory reporting.. Valid values are `^[A-Z]{2}$`',
    `property_zip_code` STRING COMMENT 'Five- or nine-digit ZIP code of the subject property. Used for geographic risk segmentation, rate zone assignment, and county routing.. Valid values are `^[0-9]{5}(-[0-9]{4})?$`',
    `respa_applicable` BOOLEAN COMMENT 'Indicates whether RESPA requirements apply to this transaction, governing settlement service disclosures and affiliated business arrangements.',
    `ron_enabled` BOOLEAN COMMENT 'Indicates whether Remote Online Notarization (RON) is authorized and enabled for the closing of this title order, subject to state law.',
    `sales_price_amount` DECIMAL(15,2) COMMENT 'Contract purchase price of the subject property in US dollars. Used for owner policy premium calculation, LTV computation, and underwriting risk assessment. Null for refinance orders.',
    `scheduled_closing_date` DATE COMMENT 'Anticipated closing date for the transaction as scheduled at order intake or updated during the order lifecycle. Drives closing readiness and SLA monitoring.',
    `seller_name` STRING COMMENT 'Full legal name of the property seller. Restricted PII. Applicable to purchase transactions; null for refinance/HELOC. Used for chain-of-title and vesting verification.',
    `sla_commitment_due_date` DATE COMMENT 'Target date by which the title commitment must be issued per the applicable SLA for this orders channel and transaction type. Used for commitment issuance lag reporting.',
    `title_examiner_name` STRING COMMENT 'Name of the title examiner assigned to perform the title examination and identify defects, encumbrances, and chain-of-title breaks for this order.',
    `transaction_type` STRING COMMENT 'Classification of the real estate transaction type driving this title order: purchase, refinance (REFI), home equity line of credit (HELOC), construction, or commercial.. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `trid_applicable` BOOLEAN COMMENT 'Indicates whether TRID disclosure requirements apply to this transaction. True for most residential purchase and refinance loans; false for exempt transaction types.',
    `underwriter_code` STRING COMMENT 'Code identifying the title insurance underwriter (e.g., FNF, FAF, STC, ORI) backing the policies issued on this order. Drives premium split and remittance routing.. Valid values are `^[A-Z0-9]{2,10}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the title_order record in the data platform. Used for change detection and incremental processing.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_title_order PRIMARY KEY(`title_order_id`)
) COMMENT 'Core transaction spine for the operations domain. Represents a single title-insurance order from intake through closing, capturing transaction type (purchase, refinance, HELOC, construction, commercial), channel routing (direct branch, centralized lender';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` (
    `party_id` BIGINT COMMENT 'Unique surrogate identifier for a party record in the title-insurance master party registry. Serves as the primary key across all title production, escrow, underwriting, and claims systems.',
    `party_code` STRING COMMENT 'Business-facing alphanumeric identifier assigned to the party by the title production system (e.g., SoftPro, RamQuest, Qualia). Used for cross-system reconciliation and CRM lookup.. Valid values are `^PTY-[A-Z0-9]{6,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the party record was first created in the title production or CRM system. Supports audit trail, data lineage, and SOX control evidence.',
    `date_of_birth` DATE COMMENT 'Birth date of a natural-person party. Used for identity verification, OFAC/FinCEN screening, and distinguishing same-name individuals in chain-of-title searches. Stored per GLBA NPPI controls.',
    `dba_name` STRING COMMENT 'Trade name or assumed name under which an organization operates, distinct from its legal entity name. Relevant for independent title agents and settlement service providers.',
    `deceased_date` DATE COMMENT 'Date of death for a natural-person party. Used to determine whether a conveyance occurred before or after death, which is critical for chain-of-title validity and estate underwriting.',
    `entity_formation_date` DATE COMMENT 'Date on which a legal entity was formally incorporated, organized, or registered. Used to verify the entity existed at the time of a conveyance for chain-of-title validity.',
    `entity_formation_state` STRING COMMENT 'Two-letter US state code where a legal entity (corporation, LLC, trust) was formed or registered. Used to validate authority to convey and underwriting risk assessment for organizational parties.. Valid values are `^[A-Z]{2}$`',
    `fax_number` STRING COMMENT 'Fax number for the party, primarily used for lender, attorney, and independent agent communications where fax remains a standard document delivery channel.. Valid values are `^+?[1-9]d{1,14}$`',
    `first_name` STRING COMMENT 'Given name of a natural-person party. Populated only when party_type is individual. Used for closing document preparation and NPPI-controlled communications.',
    `identity_doc_ref` STRING COMMENT 'Vault reference token pointing to the partys government-issued identity document (drivers license, passport) stored in the NPPI Vault. Required for RON/IPEN and closing identity verification.',
    `is_deceased` BOOLEAN COMMENT 'Indicates the party is deceased. Triggers estate/probate underwriting review, blocks new transaction role assignments, and preserves historical chain-of-title and claims records.',
    `is_do_not_contact` BOOLEAN COMMENT 'Indicates the party has opted out of marketing and non-essential communications. Enforced in CRM and title production system routing to comply with TCPA and CCPA opt-out requirements.',
    `is_foreign_national` BOOLEAN COMMENT 'Indicates whether the party is a non-US citizen or foreign entity. Triggers FIRPTA withholding analysis, additional underwriting review, and FinCEN beneficial ownership disclosure requirements.',
    `is_nppi_consent_given` BOOLEAN COMMENT 'Indicates whether the party has provided consent for sharing Non-Public Personal Information (NPPI) with affiliated settlement service providers per GLBA privacy notice requirements.',
    `last_name` STRING COMMENT 'Surname of a natural-person party. Used in grantor/grantee index searches and chain-of-title assembly. Retained for historical vesting even after legal name change.',
    `legal_name` STRING COMMENT 'Full legal name of the party exactly as it appears on vesting instruments, deeds, or articles of incorporation. Used for title commitment Schedule A vesting and policy issuance.',
    `mailing_address_line1` STRING COMMENT 'First line of the partys mailing address (street number and name). Used for commitment and policy delivery, 1099-S mailing, and RESPA/TRID disclosure delivery.',
    `mailing_address_line2` STRING COMMENT 'Second line of the partys mailing address (suite, unit, apartment number). Supplements mailing_address_line1 for complete postal delivery.',
    `mailing_city` STRING COMMENT 'City component of the partys mailing address. Required for RESPA/TRID disclosure delivery and IRS 1099-S reporting.',
    `mailing_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the partys mailing address. Relevant for foreign national buyers, foreign lenders, and FIRPTA withholding determination.. Valid values are `^[A-Z]{3}$`',
    `mailing_postal_code` STRING COMMENT 'ZIP or ZIP+4 postal code for the partys mailing address. Used for geographic risk segmentation, premium tax filing, and USPS delivery validation.. Valid values are `^d{5}(-d{4})?$`',
    `mailing_state` STRING COMMENT 'Two-letter US state code for the partys mailing address. Used for state-specific regulatory disclosure routing and premium tax jurisdiction determination.. Valid values are `^[A-Z]{2}$`',
    `marital_status` STRING COMMENT 'Marital status of a natural-person party at the time of the transaction. Drives spousal signature requirements, homestead rights analysis, and vesting options on title commitment Schedule A.. Valid values are `single|married|divorced|widowed|separated|unknown`',
    `middle_name` STRING COMMENT 'Middle name or initial of a natural-person party. Required for grantor/grantee name matching in chain-of-title searches to distinguish parties with common first and last names.',
    `mobile_phone` STRING COMMENT 'Mobile telephone number for the party. Used for SMS closing alerts, RON session links, and two-factor identity verification during electronic notarization.. Valid values are `^+?[1-9]d{1,14}$`',
    `name_suffix` STRING COMMENT 'Generational or professional suffix appended to an individual party name (e.g., Jr., Sr., II). Critical for distinguishing same-name grantor/grantee pairs in chain-of-title searches.. Valid values are `Jr.|Sr.|II|III|IV|Esq.`',
    `nppi_consent_date` DATE COMMENT 'Date on which the party provided or last renewed NPPI consent. Used to determine consent currency and trigger re-consent workflows per GLBA annual notice requirements.',
    `ofac_screen_date` DATE COMMENT 'Most recent date on which the party was screened against the OFAC SDN list. Used to determine whether a re-screen is required before closing based on elapsed time thresholds.',
    `ofac_screen_result` STRING COMMENT 'Outcome of the most recent OFAC SDN screening for this party. A hit or inconclusive result blocks closing until underwriting review is completed.. Valid values are `clear|hit|pending_review|inconclusive`',
    `ofac_screened` BOOLEAN COMMENT 'Indicates whether the party has been screened against the OFAC Specially Designated Nationals (SDN) list. Required for FinCEN compliance and underwriting approval prior to closing.',
    `organization_name` STRING COMMENT 'Legal entity name for organizations, trusts, estates, or government bodies. Populated when party_type is not individual. Used for vesting, lender identification, and agency agreement records.',
    `party_status` STRING COMMENT 'Current lifecycle state of the party record. Inactive or dissolved parties are retained for historical chain-of-title and claims analysis but excluded from active transaction routing.. Valid values are `active|inactive|merged|deceased|dissolved|suspended`',
    `party_type` STRING COMMENT 'Classifies the party as a natural person or legal entity. Drives vesting, signature, and NPPI handling rules. [ENUM-REF-CANDIDATE: individual|organization|trust|estate|government|other — promote to reference product]. Valid values are `individual|organization|trust|estate|government|other`',
    `preferred_contact_method` STRING COMMENT 'Partys preferred channel for receiving closing documents, commitment updates, and settlement communications. Drives automated delivery routing in the title production system.. Valid values are `email|phone|mail|fax|portal`',
    `primary_email` STRING COMMENT 'Primary email address for the party used for closing coordination, commitment delivery, and TRID/CD disclosures. Classified as NPPI under GLBA for individual parties.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_phone` STRING COMMENT 'Primary telephone number for the party in E.164 format. Used for closing scheduling, RON/IPEN coordination, and identity verification callbacks.. Valid values are `^+?[1-9]d{1,14}$`',
    `record_effective_date` DATE COMMENT 'Business-effective date from which this party record version is considered authoritative. Supports bi-temporal modeling for chain-of-title and ownership interest evidence provenance.',
    `record_expiry_date` DATE COMMENT 'Date on which this party record version is superseded by a newer version. Null indicates the current active version. Supports SCD Type 2 history for party identity changes.',
    `secondary_email` STRING COMMENT 'Alternate email address for the party, used when primary email is undeliverable or for routing copies of closing documents to a secondary contact such as a co-borrower or attorney.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `source_system_party_code` STRING COMMENT 'Native identifier for this party in the originating operational system (e.g., SoftPro contact ID, Salesforce Account ID). Used for cross-system reconciliation and master data management.',
    `tax_id_ref` STRING COMMENT 'Tokenized or vault reference to the partys Tax Identification Number (TIN) or Social Security Number (SSN). Actual value stored in the NPPI Vault per GLBA. Used for IRS 1099-S reporting and IOLTA compliance.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the party record. Used for change-data-capture (CDC) processing, master data synchronization, and audit trail maintenance.',
    `vesting_type` STRING COMMENT 'How the party holds or will hold title to real property (e.g., joint tenancy, tenancy in common, community property). Populates Schedule A of the title commitment and drives survivorship and conveyance rules.. Valid values are `sole_and_separate|joint_tenancy|tenancy_in_common|community_property|trust|other`',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_party PRIMARY KEY(`party_id`)
) COMMENT 'Master entity for every natural person or legal entity participating in a title transaction. Stores identity attributes (name, entity type, tax-ID reference, contact information, address) without embedding a role.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` (
    `party_role_id` BIGINT COMMENT 'Unique surrogate identifier for each party-role assignment record on a title order. Primary key of the party_role association entity.',
    `cpl_issuance_id` BIGINT COMMENT 'Reference to the CPL issuance record covering this party in this role. Populated when cpl_required is true and a CPL has been issued.',
    `party_id` BIGINT COMMENT 'Reference to the party record representing the person or organization assigned to this role on the title order.',
    `superseded_by_role_party_role_id` BIGINT COMMENT 'Reference to the party_role record that replaced this assignment when a role was revised or transferred. Supports lifecycle transition and revision history per VREQ-007.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order on which this party holds the specified role. Anchors the role assignment to the production transaction spine.',
    `acceptance_date` DATE COMMENT 'Date the role assignment was formally accepted or confirmed by the relevant party or system. Distinct from execution, effective, submission, and recording dates per VREQ-008.',
    `aml_screening_date` DATE COMMENT 'Date on which the most recent AML/OFAC screening was performed for this party in this role. Used for compliance audit and re-screening interval tracking.',
    `aml_screening_status` STRING COMMENT 'Result of AML/OFAC/FinCEN screening for this party in this role. Supports fraud controls and regulatory compliance for high-value and cash transactions.. Valid values are `pending|cleared|flagged|escalated|exempt`',
    `authority_document_ref` STRING COMMENT 'Reference identifier for the document establishing the partys authority (e.g., POA instrument number, trust agreement reference, letters testamentary). Links to document management system.',
    `authority_type` STRING COMMENT 'Basis of authority under which the party acts in this role (e.g., self, power of attorney, trustee, executor, guardian, corporate officer). Drives curative and underwriting requirements.. Valid values are `self|power_of_attorney|trustee|executor|guardian|corporate_officer`',
    `party_role_code` STRING COMMENT 'Standardized alphanumeric code identifying the role type, aligned with MISMO or ALTA role code conventions (e.g., BUYER, SELLER, BRRWR, LNDR). Used for system integration and reporting.. Valid values are `^[A-Z0-9_]{2,30}$`',
    `cpl_required` BOOLEAN COMMENT 'Indicates whether a Closing Protection Letter (CPL) must be issued naming this party in this role. Typically required for lender parties in lender-channel transactions.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this party-role assignment record was first created in the system. Audit trail for record provenance per VREQ-007.',
    `effective_date` DATE COMMENT 'Date on which this party-role assignment became legally or operationally effective. Distinct from execution, submission, acceptance, and recording dates per VREQ-008.',
    `execution_date` DATE COMMENT 'Date the party executed or signed the document or agreement establishing this role. Distinct from effective, submission, acceptance, and recording dates per VREQ-008.',
    `expiration_date` DATE COMMENT 'Date on which this party-role assignment expires or is no longer valid. Null for open-ended assignments. Supports effective-dated role history per VREQ-007.',
    `firpta_withholding_required` BOOLEAN COMMENT 'Indicates whether FIRPTA withholding applies to this party in this role (typically seller parties who are foreign nationals). Drives escrow withholding and IRS reporting obligations.',
    `foreign_national_flag` BOOLEAN COMMENT 'Indicates whether this party is a foreign national or foreign entity, triggering FIRPTA withholding requirements, FinCEN beneficial ownership reporting, and enhanced due diligence.',
    `identity_verification_date` DATE COMMENT 'Date on which the partys identity was verified for this role assignment. Used for compliance audit trails and fraud control.',
    `identity_verification_method` STRING COMMENT 'Method used to verify the partys identity for this role (e.g., in-person, Remote Online Notarization (RON), In-Person Electronic Notarization (IPEN), knowledge-based authentication).',
    `identity_verified` BOOLEAN COMMENT 'Indicates whether the partys identity has been verified for this role assignment through an approved identity verification process (e.g., ID check, RON/IPEN verification).',
    `is_primary` BOOLEAN COMMENT 'Indicates whether this party is the primary holder of the role when multiple parties share the same role type on an order (e.g., primary borrower vs. co-borrower).',
    `is_vesting_party` BOOLEAN COMMENT 'Indicates whether this party appears on the vesting (title-holding) instrument for the subject property. Critical for Schedule A vesting language and ownership interest tracking.',
    `marital_status` STRING COMMENT 'Marital status of the party as relevant to vesting and spousal consent requirements. Required for community property states and certain title underwriting determinations.. Valid values are `single|married|divorced|widowed|separated|unknown`',
    `notice_delivery_method` STRING COMMENT 'Preferred method for delivering title-related notices and disclosures to this party in this role (email, mail, fax, portal, none). Supports TRID/RESPA disclosure delivery tracking.. Valid values are `email|mail|fax|portal|none`',
    `nppi_vault_ref` STRING COMMENT 'Tokenized reference to the NPPI Vault record holding sensitive identifiers (SSN/TIN, identity documents) for this party in this role. Actual NPPI is never stored here per GLBA/CCPA.',
    `ownership_percentage` DECIMAL(5,4) COMMENT 'Fractional ownership interest held by this party when vesting type is tenancy in common or similar. Expressed as a decimal (e.g., 0.5000 = 50%). Null for sole ownership.',
    `party_capacity` STRING COMMENT 'Legal capacity in which the party acts in this role: individual (natural person), entity (corporation/LLC/partnership), trust, estate, government body, or other.. Valid values are `individual|entity|trust|estate|government|other`',
    `respa_affiliated_flag` BOOLEAN COMMENT 'Indicates whether this party has an affiliated business arrangement (AfBA) with the title company in this role, requiring RESPA Section 8 disclosure.',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this party-role assignment, incremented each time the role record is materially updated. Supports lifecycle history tracking per VREQ-007.',
    `role_category` STRING COMMENT 'Broad grouping of the role type for reporting and routing: principal (buyer/seller/borrower), service_provider (agent/attorney/notary), lender, government, or other.. Valid values are `principal|service_provider|lender|government|other`',
    `role_notes` STRING COMMENT 'Free-text notes or instructions specific to this partys role on the order (e.g., special handling instructions, POA limitations, trust restrictions). Not for NPPI.',
    `role_sequence` BIGINT COMMENT 'Ordinal position when multiple parties share the same role type on a single order (e.g., co-buyer 1, co-buyer 2). Enables ordered display and processing of co-principals.',
    `role_source_system` STRING COMMENT 'Originating system from which this party-role assignment was created or imported (e.g., title production system, CRM/order routing platform, lender portal, agency management system).. Valid values are `title_production|crm|lender_portal|agency_system|manual|other`',
    `role_status` STRING COMMENT 'Current lifecycle state of this party-role assignment. Supports lifecycle transition tracking per VREQ-007 (active, inactive, superseded, withdrawn, pending).. Valid values are `active|inactive|superseded|withdrawn|pending`',
    `role_type` STRING COMMENT 'Contextual role the party holds on this title order (e.g., buyer, seller, borrower, lender, trustee, agent). One party may hold multiple simultaneous roles per VREQ-006.. Valid values are `buyer|seller|borrower|lender|trustee|agent`',
    `source_system_ref` STRING COMMENT 'External identifier for this party-role record in the originating system of record (e.g., SoftPro party ID, Qualia contact ID, CRM contact ID). Supports cross-system reconciliation.',
    `spouse_consent_required` BOOLEAN COMMENT 'Indicates whether spousal consent or joinder is required for this partys role in the transaction, based on marital status and state community property or homestead laws.',
    `submission_date` DATE COMMENT 'Date this party-role assignment record was submitted into the title production system. Distinct from execution, effective, acceptance, and recording dates per VREQ-008.',
    `trid_disclosure_required` BOOLEAN COMMENT 'Indicates whether TRID disclosures (Loan Estimate / Closing Disclosure) must be provided to this party in this role. Typically true for borrower parties on covered loan transactions.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this party-role assignment record. Supports change detection and audit trail per VREQ-007.',
    `vesting_type` STRING COMMENT 'Form of title ownership vesting for this party on the subject property (e.g., joint tenancy, tenancy in common, community property, trust). Populated when is_vesting_party is true.. Valid values are `sole_ownership|joint_tenancy|tenancy_in_common|community_property|trust|other`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_party_role PRIMARY KEY(`party_role_id`)
) COMMENT 'Association entity assigning a party (party_id) to a specific contextual role on a specific title_order, enabling one party to hold multiple simultaneous roles (e.g., buyer and borrower, or seller and trustee) per VREQ-006.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` (
    `title_search_id` BIGINT COMMENT 'Unique surrogate identifier for the title search record. Primary key for the title_search entity within the operations domain.',
    `abstractor_party_id` BIGINT COMMENT 'Foreign key linking to operations.party. Business justification: Links the title search to the party master for the abstractor who performed the search. Currently abstractor_name is stored as STRING (denormalized).',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to recording.jurisdiction. Business justification: Searches are performed against specific county recording offices. Jurisdiction determines plant coverage dates, recording fees, erecording capability, and turnaround times.',
    `legal_description_id` BIGINT COMMENT 'Reference to the legal description record used as the search boundary for this title search. Ensures search scope is tied to the correct metes-and-bounds or PLSS description.',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel record against which this title search was executed. Supports chain-of-title assembly and property-level search history.',
    `prior_search_title_search_id` BIGINT COMMENT 'Reference to a prior title search on the same property or order, enabling update search linkage and chain-of-search provenance. Null for initial full searches.',
    `title_order_id` BIGINT COMMENT 'Reference to the parent title order that initiated this search. Links the search to the order lifecycle and channel routing context.',
    `apn` STRING COMMENT 'Assessors Parcel Number assigned by the county assessor. Used to locate the parcel in county tax and recorder indexes during the title search.',
    `cancellation_reason` STRING COMMENT 'Free-text or coded reason for search cancellation (e.g., order withdrawn, duplicate order, property changed). Populated only when search_status is cancelled.',
    `cancelled_timestamp` TIMESTAMP COMMENT 'Date and time the title search was cancelled, if applicable. Null when search was not cancelled. Supports cancellation rate and reason analysis.',
    `completed_timestamp` TIMESTAMP COMMENT 'Date and time the title search results were returned and marked complete. Used to calculate actual search turnaround time against SLA targets.',
    `cot_break_description` STRING COMMENT 'Narrative description of the chain-of-title break identified, including the gap period and missing instrument type. Populated only when cot_break_detected is True.',
    `cot_break_detected` BOOLEAN COMMENT 'Indicates whether a break in the chain of title was identified during this search. True triggers escalation to examination and curative processing.',
    `cot_start_year` BIGINT COMMENT 'Earliest year from which the chain-of-title was assembled in this search. Supports COT completeness and break detection metrics.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time this title search record was first created in the data platform. Audit timestamp for data lineage and record provenance.',
    `easement_found` BOOLEAN COMMENT 'Indicates whether one or more easements (ROW, utility, access) were identified during the search. Easements are typically carried as Schedule B-II exceptions.',
    `encroachment_found` BOOLEAN COMMENT 'Indicates whether an encroachment was identified during the search (e.g., from survey or prior instrument). May require survey endorsement or curative action.',
    `gap_period_end_date` DATE COMMENT 'End date of the gap period, typically the actual recording date. Null until recording is confirmed. Supports gap coverage period duration and risk metrics.',
    `gap_period_start_date` DATE COMMENT 'Start date of the gap period between the search cutoff date and the anticipated recording date. Used to assess gap coverage risk and coordinate with the recording team.',
    `hoa_lien_found` BOOLEAN COMMENT 'Indicates whether a homeowners association (HOA) lien or delinquent assessment was identified during the search. Requires payoff letter or clearance before closing.',
    `instrument_count` BIGINT COMMENT 'Total number of recorded instruments (deeds, mortgages, liens, releases, etc.) identified and indexed during this title search. Supports evidence completeness metrics.',
    `is_automated_search` BOOLEAN COMMENT 'Indicates whether the search was executed via an automated title plant system (e.g., DataTrace automated pull) versus a manual abstractor. Supports quality and cost analytics.',
    `is_sla_breached` BOOLEAN COMMENT 'Indicates whether the title search exceeded its SLA target hours. True when completed_timestamp minus ordered_timestamp exceeds sla_hours_target.',
    `lis_pendens_found` BOOLEAN COMMENT 'Indicates whether a lis pendens (LP) was identified against the property during the search. True requires underwriting review before commitment issuance.',
    `open_judgment_count` BIGINT COMMENT 'Number of open judgment liens against the property or vested owners identified during the search. Distinct from tax and mechanics liens for underwriting triage.',
    `open_lien_count` BIGINT COMMENT 'Number of open or unresolved liens (tax, mechanics, judgment, HOA) identified during the search. Feeds unresolved defect and lien aging metrics.',
    `ordered_date` DATE COMMENT 'Calendar date on which the title search was ordered or requested. Used as the start point for search turnaround and SLA cycle-time measurement.',
    `ordered_timestamp` TIMESTAMP COMMENT 'Precise date and time the title search was ordered. Supports intraday SLA tracking and search queue prioritization in the title production system.',
    `plant_coverage_from_date` DATE COMMENT 'Earliest date covered by the title plant or public-record index used in this search. Defines the start of the chain-of-title (COT) period examined.',
    `plant_coverage_to_date` DATE COMMENT 'Latest date covered by the title plant or public-record index used in this search. Defines the end of the COT period and the effective search cutoff.',
    `prior_deed_type` STRING COMMENT 'Type of the most recent vesting deed identified in the chain of title (WD, SWD, QCD, grant deed, trustee deed). Informs underwriting risk and coverage scope.. Valid values are `warranty_deed|special_warranty_deed|quit_claim_deed|grant_deed|trustee_deed|other`',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this search record. Incremented when a search is updated or supplemented. Supports lifecycle history and revision frequency metrics.',
    `search_fee_amount` DECIMAL(12,2) COMMENT 'Dollar amount charged by the search vendor or abstractor for this title search. Used for vendor cost tracking, settlement statement line items, and profitability analysis.',
    `search_fee_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the search fee amount. Defaults to USD for domestic transactions; retained for multi-currency reporting consistency.. Valid values are `^[A-Z]{3}$`',
    `search_from_date` DATE COMMENT 'Start date of the title search period as specified in the search order. May differ from plant coverage dates when a specific lookback period is requested.',
    `search_number` STRING COMMENT 'Externally visible, human-readable identifier assigned to this title search by the title production system (e.g., SoftPro, RamQuest). Used in correspondence and audit trails.. Valid values are `^TS-[0-9]{4}-[0-9]{6}$`',
    `search_purpose` STRING COMMENT 'Transaction type driving the search request: purchase, refinance, HELOC, construction, commercial, or equity loan. Aligns search scope with underwriting requirements.. Valid values are `purchase|refinance|heloc|construction|commercial|equity_loan`',
    `search_result_document_ref` STRING COMMENT 'Reference identifier or URL to the search result package stored in the document management and imaging system. Supports evidence completeness and provenance tracking.',
    `search_source_type` STRING COMMENT 'Indicates whether the search was performed against a title plant, direct public records, an automated search engine, manual abstractor review, or a hybrid combination.. Valid values are `title_plant|public_record|automated|manual|hybrid`',
    `search_status` STRING COMMENT 'Current lifecycle status of the title search. Drives clearance cycle-time metrics and search aging dashboards. [ENUM-REF-CANDIDATE: ordered|in_progress|completed|cancelled|on_hold|failed — promote to reference product]. Valid values are `ordered|in_progress|completed|cancelled|on_hold|failed`',
    `search_to_date` DATE COMMENT 'End date of the title search period as specified in the search order. Represents the effective date through which public records were reviewed.',
    `search_type` STRING COMMENT 'Classification of the search scope: full chain-of-title, update, Ownership and Encumbrance (O&E) report, two-owner, 30-year, or current-owner. Determines depth of plant/public-record review.. Valid values are `full|update|oe_report|two_owner|30_year|current_owner`',
    `search_vendor_code` STRING COMMENT 'Code identifying the title plant or search vendor used to execute this search (e.g., DataTrace, TitlePoint, county plant). Supports vendor performance and cost tracking.',
    `search_vendor_name` STRING COMMENT 'Full name of the title plant or search vendor that performed the search (e.g., DataTrace, TitlePoint). Retained for display and reporting when vendor code alone is insufficient.',
    `sla_due_date` DATE COMMENT 'Contractual or operational due date by which the title search must be completed. Derived from ordered_date plus channel SLA hours; stored for direct SLA breach detection.',
    `sla_hours_target` BIGINT COMMENT 'Number of business hours within which the search must be completed per the applicable channel or product SLA. Enables SLA compliance reporting.',
    `source_system_search_code` STRING COMMENT 'Native identifier for this search record in the originating title production system (e.g., SoftPro Select, RamQuest Horizon, Qualia). Supports system-of-record traceability.',
    `tax_lien_found` BOOLEAN COMMENT 'Indicates whether a federal or state tax lien was identified against the property or vested owner during the search. Triggers requirement for payoff or release.',
    `ucc_filing_found` BOOLEAN COMMENT 'Indicates whether a UCC filing was identified against the property or owner during the search. Relevant for commercial transactions and fixture filings.',
    `vesting_deed_instrument_number` STRING COMMENT 'County recorder instrument number for the most recent vesting deed. Provides direct reference to the recorded instrument for evidence and provenance.',
    `vesting_deed_recording_date` DATE COMMENT 'Date the most recent vesting deed was recorded in the county recorders office. Establishes the effective date of current ownership in the chain of title.',
    `vesting_grantee_name` STRING COMMENT 'Name of the grantee (current vested owner) on the most recent vesting deed. Must match the seller/borrower identity for commitment issuance.',
    `vesting_grantor_name` STRING COMMENT 'Name of the grantor on the most recent vesting deed as found in the grantor-grantee index. Used to verify current ownership and identify potential title defects.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_title_search PRIMARY KEY(`title_search_id`)
) COMMENT 'Legally and operationally distinct entity representing the execution of a title search against public records and the title plant for a specific order. Captures search type (full, update, O&E, two-owner, 30-year), search vendor or plant source (DataTrace';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` (
    `operations_title_examination_id` BIGINT COMMENT 'Unique surrogate primary key for the title examination record within the operations domain. Globally unique identifier for this examiner review event.',
    `agent_profile_id` BIGINT COMMENT 'Foreign key linking to agency.agent_profile. Business justification: Title examinations performed by agent staff require agent context for oversight reviews, audit sampling, examiner quality tracking, and regulatory compliance.',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: Title examiners analyze specific legal description versions to identify defects, chain-of-title breaks, and boundary issues.',
    `party_id` BIGINT COMMENT 'Reference to the party record for the title examiner responsible for this examination. Supports examiner workload, performance, and cycle-time analytics.',
    `prior_exam_operations_title_examination_id` BIGINT COMMENT 'Reference to a prior title examination record this examination updates or supersedes. Supports lifecycle revision history and bring-down examination traceability per VREQ-007.',
    `title_order_id` BIGINT COMMENT 'Reference to the parent title order for which this examination was performed. Links the examination to the originating transaction spine.',
    `title_search_id` BIGINT COMMENT 'Reference to the title search whose results are being examined. Preserves the legally distinct relationship between search assembly and examiner review.',
    `cot_break_description` STRING COMMENT 'Narrative description of the chain-of-title break identified, including the time period affected and the nature of the gap (missing deed, unrecorded conveyance, etc.).',
    `cot_break_detected` BOOLEAN COMMENT 'Indicates whether the examiner identified a break or gap in the chain-of-title during this examination. Directly supports chain-of-title break metrics per VREQ-016.',
    `cot_start_date` DATE COMMENT 'Earliest date in the chain-of-title reviewed during this examination. Establishes the historical depth of the title review for marketability analysis.',
    `county_name` STRING COMMENT 'Name of the county or jurisdiction in which the subject property is located. Determines applicable recording requirements and county plant search standards.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this title examination record was first created in the data platform. Audit control field for record provenance.',
    `defect_count` BIGINT COMMENT 'Total number of title defects, clouds, or encumbrances identified during this examination. Supports unresolved defect and lien metrics per VREQ-016.',
    `easement_count` BIGINT COMMENT 'Number of easements, rights-of-way (ROW), or CC&Rs identified during the examination. Supports encumbrance completeness and Schedule B-II exception population.',
    `effective_date` DATE COMMENT 'Date through which the title examination is effective, i.e., the date to which the chain-of-title was examined. Distinct from examination_date per VREQ-008.',
    `evidence_completeness_flag` BOOLEAN COMMENT 'Indicates whether all required supporting evidence (deeds, releases, satisfactions, court orders) was available and reviewed during the examination. Supports evidence completeness metrics per VREQ-016.',
    `examination_complete_timestamp` TIMESTAMP COMMENT 'Precise date and time when the examiner marked the examination complete or referred it. Paired with start timestamp to compute examination cycle time.',
    `examination_date` DATE COMMENT 'Calendar date on which the title examiner completed or substantially performed the examination review. Principal business event date for cycle-time measurement.',
    `examination_number` STRING COMMENT 'Externally visible alphanumeric identifier assigned to this examination by the title production system (e.g., SoftPro/RamQuest exam module). Used for cross-system traceability.',
    `examination_start_timestamp` TIMESTAMP COMMENT 'Precise date and time when the examiner began the title examination in the production system. Used to calculate examination duration and SLA compliance.',
    `examination_status` STRING COMMENT 'Current lifecycle state of the title examination. Drives workflow routing: in_progress (active review), complete (exam finished), referred (sent to underwriter), on_hold, cancelled.. Valid values are `in_progress|complete|referred|on_hold|cancelled`',
    `examination_type` STRING COMMENT 'Classification of the examination scope: full chain-of-title review, update/bring-down of prior exam, O&E (Ownership and Encumbrance) report, or gap period review.. Valid values are `full|update|bring_down|oe_report|gap`',
    `examiner_license_number` STRING COMMENT 'State-issued license or certification number of the title examiner, where applicable. Supports regulatory compliance and examiner qualification tracking.',
    `examiner_name` STRING COMMENT 'Full name of the title examiner who performed the review, captured at time of examination for historical accuracy independent of party record changes.',
    `examiner_notes` STRING COMMENT 'Free-text narrative notes entered by the title examiner summarizing findings, concerns, or curative recommendations not captured in structured fields.',
    `exception_count` BIGINT COMMENT 'Total number of Schedule B-II exceptions identified during this examination. Supports unresolved exception and underwriting referral rate metrics.',
    `fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county of the subject property. Used for jurisdiction-level reporting, plant access, and regulatory reporting alignment.. Valid values are `^[0-9]{5}$`',
    `gap_coverage_required` BOOLEAN COMMENT 'Indicates whether the examiner identified a gap period requiring gap coverage (GAPcure) between the search-through date and the anticipated recording date.',
    `judgment_lien_detected` BOOLEAN COMMENT 'Indicates whether a judgment lien against the current owner or a prior owner was identified during the examination. Requires curative action before policy issuance.',
    `lien_count` BIGINT COMMENT 'Total number of open liens (tax, mechanics, judgment, HOA, HELOC, etc.) identified during the examination. Supports unresolved lien metrics per VREQ-016.',
    `lis_pendens_detected` BOOLEAN COMMENT 'Indicates whether a lis pendens (LP) was identified during the examination, signaling pending litigation affecting the property title.',
    `mers_lien_detected` BOOLEAN COMMENT 'Indicates whether a MERS-registered mortgage or deed of trust was identified during the examination, requiring MERS-specific curative or release procedures.',
    `missing_evidence_description` STRING COMMENT 'Narrative description of any evidence items that were unavailable or incomplete at the time of examination, supporting evidence provenance tracking per VREQ-016.',
    `open_lien_amount` DECIMAL(18,2) COMMENT 'Aggregate dollar amount of all open liens identified during the examination. Supports lien severity and underwriting risk assessment. Currency: USD.',
    `property_state_code` STRING COMMENT 'Two-letter USPS state code for the property jurisdiction. Determines applicable state title standards, examination requirements, and regulatory framework.. Valid values are `^[A-Z]{2}$`',
    `requirement_count` BIGINT COMMENT 'Total number of Schedule B-I requirements raised by this examination. Supports open and aging title requirements metrics per VREQ-016.',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this examination record. Increments when the examination is updated or superseded, preserving the full revision history per VREQ-007.',
    `revision_reason` STRING COMMENT 'Narrative explanation for why this examination was revised or superseded (e.g., new search results received, additional instruments found, examiner correction).',
    `search_through_date` DATE COMMENT 'The date through which the underlying title search was run and upon which the examination is based. Defines the temporal boundary of the chain-of-title reviewed.',
    `source_system_exam_code` STRING COMMENT 'Native identifier for this examination record in the originating title production system (SoftPro, RamQuest, Qualia). Enables cross-system reconciliation and audit traceability.',
    `tax_lien_detected` BOOLEAN COMMENT 'Indicates whether a federal, state, or local tax lien was identified during the examination. Triggers curative requirement and potential underwriting referral.',
    `title_opinion` STRING COMMENT 'Examiners overall title opinion resulting from the examination: marketable, insurable, uninsurable, conditional (subject to requirements), or defective. Core underwriting input.. Valid values are `marketable|insurable|uninsurable|conditional|defective`',
    `transaction_type` STRING COMMENT 'Type of real estate transaction for which this examination was performed. Contextualizes the examination scope and applicable title standards.. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this title examination record was last modified in the data platform. Audit control field for change tracking and incremental load processing.',
    `uw_referral_reason` STRING COMMENT 'Narrative reason the examiner flagged this examination for underwriter review (e.g., unresolved lien, COT break, high-risk encumbrance, complex easement).',
    `uw_referral_required` BOOLEAN COMMENT 'Flag indicating the examiner determined this examination requires underwriter review before a commitment can be issued. Drives underwriting referral rate metrics.',
    `vesting_deed_type` STRING COMMENT 'Type of deed by which current ownership is vested as identified during examination (WD, SWD, QCD, etc.). Informs title insurability and Schedule A vesting language.. Valid values are `warranty_deed|special_warranty_deed|quit_claim_deed|grant_deed|trustee_deed|other`',
    `vesting_description` STRING COMMENT 'Narrative description of how title is currently vested (e.g., joint tenancy, tenancy in common, community property, trust). Populates Schedule A of the commitment.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_operations_title_examination PRIMARY KEY(`operations_title_examination_id`)
) COMMENT 'Legally and operationally distinct entity representing the examiners review and analysis of search results for a specific title order. Captures examiner identity, examination date, examination status (in-progress, complete, referred), overall title';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` (
    `order_status_history_id` BIGINT COMMENT 'Unique surrogate identifier for each status transition record in the title order lifecycle history. Primary key of this append-only event log.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent profile associated with this order at the time of this transition. Populated for orders produced through the independent agent channel.',
    `party_id` BIGINT COMMENT 'Application user ID or system service account identifier that initiated this status transition. Used for audit trail and accountability tracking.',
    `recording_submission_id` BIGINT COMMENT 'Foreign key linking to recording.recording_submission. Business justification: Order status transitions often triggered by recording events (submission accepted, rejected, recorded). Tracks recording impact on order lifecycle per VREQ-007.',
    `source_event_order_status_history_id` BIGINT COMMENT 'Unique event or transaction identifier from the originating Title Production System (SoftPro/RamQuest/Qualia) for this status change. Supports lineage and deduplication.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order whose status changed. Links this history record to the parent title order entity.',
    `uw_referral_id` BIGINT COMMENT 'Reference to the underwriting referral record associated with this status transition, if applicable. Links to the uw_referral entity in the underwriting domain.',
    `channel_type` STRING COMMENT 'Production channel through which the title order was received at the time of this transition. Supports SLA and cycle-time analysis by channel.. Valid values are `DIRECT_BRANCH|CENTRALIZED_LENDER|INDEPENDENT_AGENT`',
    `closing_readiness_status` STRING COMMENT 'Operational assessment of the orders readiness to proceed to closing at the time of this transition. Supports closing readiness metrics per VREQ-016.. Valid values are `NOT_READY|CONDITIONALLY_READY|READY|CLOSED`',
    `commitment_revision_number` BIGINT COMMENT 'Revision number of the title commitment in effect at the time of this status transition. Supports commitment revision frequency metrics per VREQ-016.',
    `cot_break_identified` BOOLEAN COMMENT 'Indicates whether a chain-of-title break was identified at or before this status transition. Supports chain-of-title break metrics per VREQ-016.',
    `county_fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county jurisdiction for this title order at the time of this transition. Used for recording jurisdiction and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this status history record was first written to the Silver layer. Audit field for data lineage and ETL traceability.',
    `duration_in_prior_status_hours` DECIMAL(10,2) COMMENT 'Number of hours the title order spent in the prior_status before this transition. Supports clearance cycle-time and stage-level throughput analytics.',
    `erecording_enabled` BOOLEAN COMMENT 'Indicates whether electronic recording via an eRecording gateway (e.g., Simplifile, CSC) was enabled for this order at the time of this transition.',
    `escrow_officer_name` STRING COMMENT 'Name of the escrow officer assigned to this title order at the time of this status transition. Denormalized for operational reporting without requiring a party join.',
    `gap_coverage_required` BOOLEAN COMMENT 'Indicates whether gap coverage was required for this order at the time of this status transition, covering the period between search and recording.',
    `is_current` BOOLEAN COMMENT 'Indicates whether this record represents the most recent status of the title order. Facilitates efficient current-state queries without full history scan.',
    `is_regression` BOOLEAN COMMENT 'Indicates whether this transition represents a backward movement in the title order lifecycle (e.g., from cleared_to_close back to requirements_open). Flags rework events.',
    `new_status` STRING COMMENT 'Status of the title order after this transition. Represents the current state entered at this point in the lifecycle. [ENUM-REF-CANDIDATE',
    `notes` STRING COMMENT 'Free-text operational notes recorded by the user or system at the time of this status transition. Provides additional context beyond the reason code and description.',
    `open_finding_count` BIGINT COMMENT 'Number of unresolved title findings (defects, liens, encumbrances) at the time of this status transition. Supports unresolved defects and liens metrics.',
    `open_requirement_count` BIGINT COMMENT 'Number of open Schedule B-I title requirements at the time of this status transition. Supports open and aging title requirements metrics per VREQ-016.',
    `order_number` STRING COMMENT 'Human-readable title order number from the Title Production System (e.g., SoftPro/RamQuest/Qualia) at the time of this transition. Denormalized for audit traceability.',
    `policy_exception_required` BOOLEAN COMMENT 'Indicates whether a policy exception was required at this status transition point. Supports underwriting exception rate metrics per VREQ-016.',
    `prior_status` STRING COMMENT 'Status of the title order immediately before this transition. Null for the initial intake record. [ENUM-REF-CANDIDATE',
    `regression_reason_code` STRING COMMENT 'Standardized code explaining why a backward status transition occurred. Populated only when is_regression is true. Supports curative action aging and rework analysis.',
    `ron_enabled` BOOLEAN COMMENT 'Indicates whether Remote Online Notarization was enabled for this order at the time of this status transition.',
    `sequence_number` BIGINT COMMENT 'Monotonically increasing sequence number of this transition within the title orders lifecycle history. Enables ordered reconstruction of the full status timeline.',
    `sla_breach_hours` DECIMAL(10,2) COMMENT 'Number of hours by which the SLA was exceeded for this status stage. Null if SLA was met. Used for aging and SLA severity reporting.',
    `sla_breached` BOOLEAN COMMENT 'Indicates whether the SLA target for this status stage was breached. Set to true when the order remained in the new status beyond sla_due_timestamp.',
    `sla_due_timestamp` TIMESTAMP COMMENT 'Calculated deadline timestamp by which the order must exit the new status to meet SLA. Derived from transition_timestamp plus sla_target_hours at write time.',
    `sla_target_hours` DECIMAL(10,2) COMMENT 'The contracted or configured SLA target in hours for completing the new status stage. Used to measure on-time performance and clearance cycle-time compliance.',
    `state_code` STRING COMMENT 'Two-letter US state code for the jurisdiction governing this title order at the time of this transition. Denormalized for state-level SLA and regulatory reporting.. Valid values are `^[A-Z]{2}$`',
    `title_examiner_name` STRING COMMENT 'Name of the title examiner assigned to this order at the time of this status transition. Supports examiner workload and cycle-time performance analytics.',
    `transaction_type` STRING COMMENT 'Classification of the real estate transaction type at the time of this status transition. Denormalized for lifecycle analytics segmented by transaction type.. Valid values are `PURCHASE|REFINANCE|HELOC|CONSTRUCTION|COMMERCIAL`',
    `transition_reason_code` STRING COMMENT 'Standardized code identifying the business reason or trigger for this status transition. Supports workflow analytics and SLA root-cause reporting. [ENUM-REF-CANDIDATE',
    `transition_reason_description` STRING COMMENT 'Free-text narrative explaining the reason for the status transition, entered by the user or system. Supplements the reason code with operational context.',
    `transition_timestamp` TIMESTAMP COMMENT 'Exact date and time (with timezone offset) when the status transition occurred. Principal event time for SLA measurement and clearance cycle-time analytics.',
    `triggered_by_system` STRING COMMENT 'Name of the operational system that originated this transition event (e.g., SoftPro Select, RamQuest, Qualia, eRecording Gateway, CRM). Supports provenance tracking.',
    `triggered_by_type` STRING COMMENT 'Indicates whether the status transition was initiated by a human user, an automated system process, an external integration, a scheduled job, or an underwriter action.. Valid values are `USER|SYSTEM|INTEGRATION|SCHEDULER|UNDERWRITER`',
    `triggered_by_user_name` STRING COMMENT 'Display name of the user or system process that triggered this transition. Denormalized for audit readability without requiring a join to user directory.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this status history record was last modified in the Silver layer. Supports incremental load detection and audit trail maintenance.',
    `uw_referral_required` BOOLEAN COMMENT 'Indicates whether an underwriting referral was required as part of or triggering this status transition. Supports underwriting referral and exception rate metrics.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_order_status_history PRIMARY KEY(`order_status_history_id`)
) COMMENT 'Lifecycle history entity that preserves every status transition of a title order from intake through closing and post-closing. Captures prior status, new status, transition timestamp, triggering user or system, transition reason code, and any SLA';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` (
    `operations_curative_action_id` BIGINT COMMENT 'Unique surrogate identifier for each curative action record within the title production operations domain. Primary key for this entity.',
    `assigned_to_party_id` BIGINT COMMENT 'Reference to the party (curative specialist, title examiner, or external vendor) responsible for executing this curative action. Supports workload and aging analysis.',
    `easement_restriction_id` BIGINT COMMENT 'Foreign key linking to property.easement_restriction. Business justification: Curative actions address easement and restriction issues (missing releases, ambiguous language, encroachments, HOA violations).',
    `encumbrance_id` BIGINT COMMENT 'Foreign key linking to property.encumbrance. Business justification: Curative actions resolve specific encumbrances (mortgages, judgments, tax liens). Processors track payoff demands, release instruments, and satisfaction recordings per encumbrance.',
    `operations_title_examination_id` BIGINT COMMENT 'Reference to the title examination during which the defect or requirement necessitating this curative action was identified.',
    `recording_submission_id` BIGINT COMMENT 'Foreign key linking to recording.recording_submission. Business justification: Curative actions often result in resubmissions after recording rejection (corrected docs, additional signatures). Tracks curative-to-resubmission cycle time per VREQ-016.',
    `title_evidence_id` BIGINT COMMENT 'Reference to the document management record containing the curative evidence (e.g., recorded release, satisfaction, affidavit) that proves the defect has been cleared.',
    `title_finding_id` BIGINT COMMENT 'Reference to the title examination finding (defect, lien, encumbrance, or cloud on title) that triggered this curative action, if applicable.',
    `title_order_id` BIGINT COMMENT 'Reference to the parent title order under which this curative action is being performed. Links the curative step to the originating transaction.',
    `title_requirement_id` BIGINT COMMENT 'Reference to the Schedule B-I title requirement or defect that this curative action is intended to clear. Owned by the underwriting domain.',
    `uw_referral_id` BIGINT COMMENT 'Reference to the underwriting referral record created when this curative action was escalated to the underwriter for risk review and approval.',
    `action_notes` STRING COMMENT 'Free-text operational notes entered by the curative specialist documenting correspondence, status updates, obstacles, and resolution details for this curative action.',
    `action_number` STRING COMMENT 'Externally visible, human-readable identifier for this curative action (e.g., CA-2024-00123). Used in correspondence, tracking, and curative processing memos (CPM).',
    `action_status` STRING COMMENT 'Current lifecycle state of the curative action. Drives clearance cycle-time metrics and closing readiness dashboards. Transitions: open → in_progress → pending_receipt → completed or waived.. Valid values are `open|in_progress|pending_receipt|completed|waived|escalated`',
    `action_type` STRING COMMENT 'Classification of the curative step required to clear the defect or requirement. Examples include obtain release, record reconveyance, obtain payoff, record satisfaction, obtain affidavit.. Valid values are `obtain_release|record_reconveyance|obtain_payoff|record_satisfaction|obtain_affidavit|other`',
    `clearance_method` STRING COMMENT 'Method by which the title defect or requirement was ultimately cleared. Supports curative action effectiveness analysis and underwriting exception rate metrics per VREQ-016.. Valid values are `recorded_instrument|payoff_disbursement|affidavit|court_order|waiver|insured_over`',
    `completed_date` DATE COMMENT 'Calendar date on which the curative action was marked complete and the associated requirement or defect was cleared. Null if not yet completed.',
    `cot_break_indicator` BOOLEAN COMMENT 'Indicates whether this curative action is specifically addressing a chain-of-title break (gap in the grantor-grantee index or missing conveyance). Supports COT break metrics per VREQ-016.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this curative action record was first created in the title production system. Audit field supporting record provenance and lifecycle tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for monetary amounts on this curative action record. Typically USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `days_open` BIGINT COMMENT 'Number of calendar days this curative action has been open as of the last update. Stored for aging bucket reporting; supports open and aging title requirements metrics per VREQ-016.',
    `defect_severity` STRING COMMENT 'Underwriter-assigned severity rating of the title defect being cured. Critical defects block commitment issuance; high defects require UW referral; medium and low may be handled operationally.. Valid values are `critical|high|medium|low`',
    `defect_type` STRING COMMENT 'Classification of the underlying title defect or encumbrance being cured (e.g., tax lien, mechanics lien, judgment lien, lis pendens, HOA lien, unreleased mortgage, chain-of-title break).',
    `due_date` DATE COMMENT 'Target date by which this curative action must be completed to support the scheduled closing date. Drives SLA monitoring and closing readiness metrics.',
    `erecording_used` BOOLEAN COMMENT 'Indicates whether the curative instrument was submitted via electronic recording (eRecording) gateway (e.g., Simplifile, CSC eRecording) rather than physical submission.',
    `escalated_date` DATE COMMENT 'Date on which this curative action was escalated to underwriting, management, or legal due to inability to clear within standard processing. Null if not escalated.',
    `evidence_received` BOOLEAN COMMENT 'Indicates whether the documentary evidence required to confirm clearance of the defect or requirement has been received and imaged into the document management system.',
    `evidence_received_date` DATE COMMENT 'Date on which the curative evidence document was received and confirmed by the title operations team. Supports evidence completeness and provenance metrics per VREQ-016.',
    `fips_code` STRING COMMENT 'Five-digit FIPS code identifying the county jurisdiction for recording the curative instrument. Used for jurisdiction routing and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `gap_coverage_required` BOOLEAN COMMENT 'Indicates whether gap coverage is required for this curative action due to the period between the effective date of the title search and the recording of the insured instrument.',
    `instrument_acceptance_date` DATE COMMENT 'Date the county recorder or relevant authority accepted the curative instrument for recording. Distinct from execution, effective, submission, and recording dates per VREQ-008.',
    `instrument_effective_date` DATE COMMENT 'Date the curative instrument becomes legally effective, which may differ from execution or recording date. Distinct from execution, submission, acceptance, and recording dates per VREQ-008.',
    `instrument_execution_date` DATE COMMENT 'Date the curative instrument (release, reconveyance, satisfaction, etc.) was signed or executed by the relevant party. Distinct from effective, submission, acceptance, and recording dates per VREQ-008.',
    `instrument_recording_date` DATE COMMENT 'Date the curative instrument was officially recorded in the public record by the county recorder. Distinct from execution, effective, submission, and acceptance dates per VREQ-008.',
    `instrument_reference_number` STRING COMMENT 'Recording number, document number, or external reference identifier of the instrument obtained or recorded as part of this curative action. Supports evidence provenance tracking.',
    `instrument_submission_date` DATE COMMENT 'Date the curative instrument was submitted to the county recorder or relevant authority for recording or filing. Distinct from execution, effective, acceptance, and recording dates per VREQ-008.',
    `instrument_type` STRING COMMENT 'Type of legal instrument required or obtained to cure the defect (e.g., release, reconveyance, satisfaction, subordination, affidavit, court order, deed). [ENUM-REF-CANDIDATE',
    `lienholder_loan_number` STRING COMMENT 'Loan or account number assigned by the lienholder to the obligation being cured. Used to obtain payoff demands and track correspondence with the lienholder.',
    `lienholder_name` STRING COMMENT 'Name of the lienholder, creditor, or encumbrancer whose interest must be released or satisfied as part of this curative action (e.g., lender, taxing authority, HOA, judgment creditor).',
    `mers_min` STRING COMMENT '18-digit MERS Mortgage Identification Number for the mortgage or deed of trust being released or reconveyed as part of this curative action, if registered with MERS.. Valid values are `^[0-9]{18}$`',
    `opened_date` DATE COMMENT 'Calendar date on which this curative action was opened and assigned. Used as the start point for curative action aging and clearance cycle-time calculations.',
    `payoff_amount` DECIMAL(18,2) COMMENT 'Dollar amount required to satisfy and release the lien, mortgage, or encumbrance being cured. Applicable for payoff-type curative actions. Classified confidential due to financial sensitivity.',
    `payoff_good_through_date` DATE COMMENT 'Expiration date of the payoff quote obtained from the lienholder. After this date, a new payoff demand must be obtained before disbursement.',
    `prior_action_status` STRING COMMENT 'Previous lifecycle status of this curative action before the most recent status transition. Preserves material lifecycle transitions per VREQ-007 for audit and revision history.. Valid values are `open|in_progress|pending_receipt|completed|waived|escalated`',
    `priority` STRING COMMENT 'Operational priority assigned to this curative action, reflecting closing timeline urgency. Rush items are tracked for SLA breach risk and closing readiness reporting.. Valid values are `rush|standard|low`',
    `recording_jurisdiction` STRING COMMENT 'County and state jurisdiction where the curative instrument was or will be recorded (e.g., Cook County, IL). Used for eRecording routing and recording fee calculation.',
    `responsible_party_role` STRING COMMENT 'Role of the party assigned to execute this curative action within the title production workflow. Supports contextual role assignment per VREQ-006.. Valid values are `curative_specialist|title_examiner|escrow_officer|external_vendor|underwriter`',
    `sla_breached` BOOLEAN COMMENT 'Indicates whether this curative action exceeded its SLA target days without completion. True when days_open exceeds sla_target_days and action_status is not completed or waived.',
    `sla_target_days` BIGINT COMMENT 'Maximum number of calendar days allowed to complete this curative action per the applicable service level agreement or internal processing standard.',
    `status_changed_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent status transition for this curative action. Supports lifecycle history preservation per VREQ-007 and SLA breach detection.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this curative action record in the title production system. Supports incremental data loading and audit trail maintenance.',
    `uw_referral_required` BOOLEAN COMMENT 'Indicates whether this curative action requires escalation to the underwriter for approval before the associated requirement can be waived or the defect insured over.',
    `waived_date` DATE COMMENT 'Date on which the requirement or defect was formally waived by the underwriter, allowing the transaction to proceed without full cure. Null if not waived.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_operations_curative_action PRIMARY KEY(`operations_curative_action_id`)
) COMMENT 'Operational entity tracking each curative step taken to clear a title requirement or defect identified during examination. Captures the linked title requirement (owned by underwriting domain), curative action type (obtain release, record reconveyance';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` (
    `order_channel_id` BIGINT COMMENT 'Unique surrogate identifier for each order origination and routing channel record. Primary key for the order_channel reference master. [REFERENCE_LOOKUP: canonical_skip_reason — this entity is a REFERENCE_LOOKUP classifying origination channels; per-role',
    `affiliated_business_arrangement` BOOLEAN COMMENT 'Indicates whether this channel involves an affiliated business arrangement as defined under RESPA Section 8(c)(4). True = AfBA disclosure required at order intake. Supports regulatory compliance tracking.',
    `channel_category` STRING COMMENT 'Broader grouping of channels for management reporting: retail (branch/consumer), institutional (lender/wholesale), agency (independent agent), or digital (online/consumer-direct). Supports segment-level performance analysis.. Valid values are `retail|institutional|agency|digital`',
    `channel_code` STRING COMMENT 'Short, system-recognized alphanumeric code uniquely identifying the channel (e.g., DIR_BRANCH, CENT_LENDER, IND_AGENT, CONS_DIRECT, WHOLESALE). Used as the operational lookup key in title production and CRM routing systems.. Valid values are `^[A-Z0-9_]{2,30}$`',
    `channel_description` STRING COMMENT 'Free-text narrative describing the channels business purpose, scope, and operational characteristics. Used for onboarding documentation and internal reference.',
    `channel_name` STRING COMMENT 'Human-readable business name of the origination channel (e.g., Direct Branch, Centralized Lender, Independent Agent, Consumer Direct, Wholesale). Displayed in dashboards, reports, and order intake screens.',
    `channel_owner_email` STRING COMMENT 'Business email address of the internal channel owner. Used for operational notifications, SLA breach alerts, and governance communications. Classified confidential as internal business contact.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `channel_owner_name` STRING COMMENT 'Name of the internal business owner or manager responsible for this channels performance, configuration, and compliance. Used for escalation routing and governance accountability.',
    `channel_status` STRING COMMENT 'Current operational lifecycle status of the channel record. active channels accept new orders; inactive are retired; suspended are temporarily halted; pending are awaiting activation approval.. Valid values are `active|inactive|suspended|pending`',
    `channel_type` STRING COMMENT 'High-level classification of the channel: direct (branch-originated), lender (centralized lender channel), agent (independent title agent), consumer (consumer-direct), or wholesale. Drives routing logic and SLA assignment.. Valid values are `direct|lender|agent|consumer|wholesale`',
    `closing_disclosure_form_type` STRING COMMENT 'Settlement statement form type required for closings through this channel: cd (Closing Disclosure / TRID), hud1 (HUD-1 for pre-TRID or exempt transactions), alta_ss (ALTA Settlement Statement), or none.. Valid values are `cd|hud1|alta_ss|none`',
    `cost_center_code` STRING COMMENT 'ERP cost center code associated with this channel for expense allocation and profitability reporting. Supports channel-level P&L analysis and management reporting.. Valid values are `^[A-Z0-9-]{2,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this channel record was first created in the system of record. Supports audit trail, data lineage, and record provenance tracking per ALTA Best Practices Pillar 3.',
    `default_transaction_type` STRING COMMENT 'The predominant real-estate transaction type associated with this channel (purchase, refinance, HELOC, construction, commercial). Used to pre-populate order intake forms and apply channel-specific underwriting rules.. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `effective_date` DATE COMMENT 'Date on which this channel became or becomes operationally active and eligible to receive title orders. Supports effective-dated channel configuration and lifecycle history per VREQ-007.',
    `erecording_enabled` BOOLEAN COMMENT 'Indicates whether electronic recording submission is enabled for orders originating through this channel. True = eRecording via Simplifile/CSC gateway is the default submission method.',
    `escrow_handling_type` STRING COMMENT 'Indicates how escrow trust account management is handled for transactions from this channel: in_house (company escrow officer), agent_handled (independent agent manages escrow), lender_controlled, or none (no escrow).. Valid values are `in_house|agent_handled|lender_controlled|none`',
    `expiration_date` DATE COMMENT 'Date on which this channel configuration expires or is scheduled for deactivation. Null indicates no planned expiration. Supports lifecycle transition tracking and channel sunset management.',
    `external_channel_ref_code` STRING COMMENT 'External identifier for this channel as assigned by a lender, partner, or CRM system (e.g., Salesforce channel ID, lender-assigned branch code). Enables cross-system reconciliation and order traceability.',
    `gl_revenue_account_code` STRING COMMENT 'General Ledger account code to which premium revenue from orders originating through this channel is posted. Enables channel-level revenue recognition and financial reporting in the ERP/GL system.. Valid values are `^[A-Z0-9-]{3,20}$`',
    `iolta_required` BOOLEAN COMMENT 'Indicates whether escrow funds for this channel must be held in an IOLTA-compliant trust account. Applies in states where attorney-conducted closings are mandatory. Supports ALTA Best Practices Pillar 1 compliance.',
    `ipen_enabled` BOOLEAN COMMENT 'Indicates whether In-Person Electronic Notarization (IPEN) closings are permitted for transactions originating through this channel. Distinct from RON; requires physical presence of notary and signer.',
    `is_default_channel` BOOLEAN COMMENT 'Indicates whether this channel is the system default when no explicit channel is specified at order intake. Only one channel should be flagged as default per production source type. Supports order routing fallback logic.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this channel record was most recently modified. Supports change detection, incremental ETL processing, and audit trail requirements.',
    `lender_integration_type` STRING COMMENT 'Technical integration method used for lender-channel order delivery: API (real-time), file_transfer (batch), portal (manual web entry), or none (not a lender channel). Drives automation and SLA differentiation.. Valid values are `api|file_transfer|portal|none`',
    `lender_platform_name` STRING COMMENT 'Name of the lenders loan origination system or order delivery platform (e.g., Encompass, Blend, ICE Mortgage Technology) used to transmit orders through this channel. Null for non-lender channels.',
    `mers_reporting_required` BOOLEAN COMMENT 'Indicates whether MERS registration and reporting is required for mortgage instruments originated through this channel. Applies primarily to lender and wholesale channels handling DOT/mortgage instruments.',
    `nppi_data_sharing_permitted` BOOLEAN COMMENT 'Indicates whether NPPI (SSN, TIN, bank account, wire instructions) may be shared with counterparties through this channel under applicable GLBA and state privacy agreements. False = NPPI sharing restricted.',
    `order_intake_method` STRING COMMENT 'Technical method by which orders are received through this channel: API integration, web portal, email, phone, fax, or EDI. Determines automation level and SLA baseline for order intake processing.. Valid values are `api|portal|email|phone|fax|edi`',
    `premium_split_type` STRING COMMENT 'Indicates the premium revenue split model applicable to this channel: direct (100% retained by underwriter), agency (split with independent agent per agency agreement), or net_retained (net premium after agent remittance).. Valid values are `direct|agency|net_retained`',
    `production_source` STRING COMMENT 'Identifies the business production source model through which orders arrive: branch (direct office), lender_channel (centralized lender integration), independent_agent, consumer_direct, or wholesale. Aligns with ALTA production-source reporting.. Valid values are `branch|lender_channel|independent_agent|consumer_direct|wholesale`',
    `remittance_required` BOOLEAN COMMENT 'Indicates whether premium remittance to the underwriter is required for orders originating through this channel. True = remittance required (independent agent channels). Supports agency remittance timeliness metrics.',
    `requires_agency_agreement` BOOLEAN COMMENT 'Indicates whether orders originating through this channel require a valid independent agent agreement on file before order acceptance. True = agency agreement mandatory (applies to independent agent channels).',
    `requires_cpl` BOOLEAN COMMENT 'Indicates whether a Closing Protection Letter (CPL) must be issued for transactions originating through this channel. CPLs protect lenders against agent fraud or dishonesty. Mandatory for most lender and agent channels.',
    `respa_applicable` BOOLEAN COMMENT 'Indicates whether RESPA requirements apply to transactions originating through this channel. Governs settlement service provider disclosures, affiliated business arrangements, and kickback prohibitions.',
    `ron_enabled` BOOLEAN COMMENT 'Indicates whether Remote Online Notarization (RON) closings are permitted for transactions originating through this channel. Drives closing coordination workflow and notary assignment logic.',
    `routing_priority` BIGINT COMMENT 'Numeric priority rank (lower value = higher priority) used by the order routing engine to assign orders from this channel to processing queues, branches, or examiners. Supports SLA-driven workload balancing.',
    `sla_commitment_hours` DECIMAL(5,2) COMMENT 'Maximum number of business hours from completed examination to title commitment issuance for this channel. Supports closing readiness and commitment revision frequency metrics.',
    `sla_intake_hours` DECIMAL(5,2) COMMENT 'Maximum number of business hours allowed from order receipt to order acknowledgment/acceptance for this channel. Drives title clearance cycle-time SLA monitoring and operational reporting.',
    `sla_search_hours` DECIMAL(5,2) COMMENT 'Maximum number of business hours from order acceptance to title search delivery for this channel. Used to measure and report title clearance cycle time by channel.',
    `sox_control_applicable` BOOLEAN COMMENT 'Indicates whether SOX internal controls over financial reporting apply to revenue and premium transactions originating through this channel. Supports ERP/GL audit trail requirements.',
    `state_jurisdiction_scope` STRING COMMENT 'Comma-delimited list of US state codes (e.g., CA,TX,FL) in which this channel is authorized to originate title orders. Null or ALL indicates nationwide authorization. Supports state-level regulatory reporting.',
    `supports_commercial` BOOLEAN COMMENT 'Indicates whether this channel is authorized to originate commercial real-estate title orders. True = commercial orders accepted. Commercial orders typically require elevated underwriting referral thresholds.',
    `supports_residential` BOOLEAN COMMENT 'Indicates whether this channel is authorized to originate residential title orders (purchase, refinance, HELOC). True = residential orders accepted; False = residential orders not routed through this channel.',
    `suspension_date` DATE COMMENT 'Date on which this channel was suspended from accepting new orders. Null if channel has never been suspended. Preserves lifecycle transition history per VREQ-007.',
    `suspension_reason` STRING COMMENT 'Free-text explanation of why this channel was suspended (e.g., regulatory action, compliance failure, contract termination). Null if channel has never been suspended. Supports audit and lifecycle history.',
    `trid_applicable` BOOLEAN COMMENT 'Indicates whether TRID disclosure requirements (Closing Disclosure / Loan Estimate) apply to transactions originating through this channel. True for most residential purchase and refinance lender channels.',
    `underwriter_referral_threshold_usd` DECIMAL(15,2) COMMENT 'Liability amount in USD above which orders from this channel must be referred to the underwriter for risk review. Supports underwriting referral and exception rate metrics by channel.',
    `version_number` BIGINT COMMENT 'Monotonically incrementing version counter for this channel record. Incremented on each configuration change. Supports lifecycle revision history and prior classification preservation per VREQ-007.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_order_channel PRIMARY KEY(`order_channel_id`)
) COMMENT 'Reference master classifying the origination and routing channels through which title orders are received and processed (direct branch, centralized lender, independent agent, consumer direct, wholesale).';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` (
    `service_level_id` BIGINT COMMENT 'Unique surrogate identifier for a service-level agreement record defining turn-time commitments for title orders by channel, transaction type, and product tier.',
    `order_channel_id` BIGINT COMMENT 'Reference to the order channel (direct branch, centralized lender, independent agent) to which this service-level agreement applies.',
    `approval_date` DATE COMMENT 'Date on which this SLA definition was formally approved for use. Distinct from effective_date; supports lifecycle revision history per VREQ-007.',
    `approved_by` STRING COMMENT 'Name or identifier of the operations manager or executive who approved this SLA definition. Supports governance and audit trail for SLA lifecycle management.',
    `breach_penalty_applicable` BOOLEAN COMMENT 'Indicates whether a contractual penalty or credit applies when this SLA is breached. True for lender channel agreements with negotiated service credits.',
    `breach_penalty_description` STRING COMMENT 'Narrative description of the contractual penalty or service credit terms that apply upon SLA breach (e.g., fee waiver, rate reduction). Populated only when breach_penalty_applicable is true.',
    `business_hours_end` STRING COMMENT 'Local time (HH:MM, 24-hour) at which the business day ends for SLA measurement purposes (e.g., 17:00). Used in conjunction with business_hours_start for cycle-time calculations.. Valid values are `^([01]d|2[0-3]):[0-5]d$`',
    `business_hours_start` STRING COMMENT 'Local time (HH:MM, 24-hour) at which the business day begins for SLA measurement purposes (e.g., 08:00). Used to calculate business-hour turn-time compliance.. Valid values are `^([01]d|2[0-3]):[0-5]d$`',
    `channel_type` STRING COMMENT 'Production channel category for which this SLA is defined: direct branch, centralized lender, or independent agent. Mirrors the channel routing model in the CRM/order routing platform.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `closing_disclosure_form_type` STRING COMMENT 'Settlement statement form type required for closings under this SLA: Closing Disclosure (CD), HUD-1, ALTA Settlement Statement (ALTA SS), or custom. Driven by TRID/RESPA applicability.. Valid values are `cd|hud1|alta_ss|custom`',
    `closing_readiness_hours_target` BIGINT COMMENT 'Maximum number of business hours from cleared requirements to confirmed closing readiness (CD/HUD-1/ALTA settlement statement prepared). Supports closing readiness metrics per VREQ-016.',
    `commitment_form_type` STRING COMMENT 'ALTA commitment form version or state-specific form required for commitments issued under this SLA (e.g., ALTA 2021, ALTA 2016). Governs Schedule A, B-I, B-II structure.. Valid values are `alta_2021|alta_2016|state_specific|custom`',
    `commitment_hours_target` BIGINT COMMENT 'Maximum number of business hours from examination completion to issuance of the title commitment (Schedule A, B-I, B-II). Drives commitment revision frequency metrics.',
    `cpl_required` BOOLEAN COMMENT 'Indicates whether a Closing Protection Letter (CPL) must be issued to the lender for orders governed by this SLA. Typically required for centralized lender and independent agent channels.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service-level record was first created in the title production system. Audit field supporting SLA lifecycle and revision history tracking per VREQ-007.',
    `curative_hours_target` BIGINT COMMENT 'Maximum number of business hours allocated for curative action processing and clearance of Schedule B-I requirements. Supports curative action aging and effectiveness metrics.',
    `effective_date` DATE COMMENT 'Date on which this service-level agreement becomes binding and applicable to new title orders. Distinct from the record creation date per VREQ-008.',
    `erecording_required` BOOLEAN COMMENT 'Indicates whether eRecording via gateway (e.g., Simplifile, CSC) is required for orders under this SLA. Affects recording submission turn-time targets and rejection/resubmission tracking.',
    `escalation_threshold_hours` BIGINT COMMENT 'Number of business hours before the total SLA target at which an at-risk order is escalated to a supervisor or account manager. Supports proactive SLA breach prevention.',
    `examination_hours_target` BIGINT COMMENT 'Maximum number of business hours from search delivery to completion of title examination and defect identification. Supports open and aging title requirements metrics.',
    `expiration_date` DATE COMMENT 'Date on which this SLA ceases to be applicable to new orders. Null for open-ended agreements. Supports lifecycle transition tracking per VREQ-007.',
    `gap_coverage_required` BOOLEAN COMMENT 'Indicates whether gap coverage (GAP) — insuring the period between search date and recording — is required for orders governed by this SLA. Common in lender channel agreements.',
    `intake_hours_target` BIGINT COMMENT 'Maximum number of business hours from order receipt to confirmed order intake/acknowledgment. Supports title clearance cycle-time metrics per VREQ-016.',
    `iolta_required` BOOLEAN COMMENT 'Indicates whether escrow funds for orders under this SLA must be held in an IOLTA-compliant trust account. State bar and regulatory requirement for attorney-closing states.',
    `ipen_permitted` BOOLEAN COMMENT 'Indicates whether In-Person Electronic Notarization (IPEN) is permitted for closings governed by this SLA. Distinct from RON; state-specific authorization required.',
    `lender_name` STRING COMMENT 'Name of the lender or lender channel for which this SLA is specifically negotiated. Null for generic SLAs not tied to a specific lender. Supports lender-specific cycle-time reporting.',
    `lender_platform` STRING COMMENT 'Name of the lender integration platform (e.g., Encompass, Blend, SimpleNexus) through which orders governed by this SLA are received. Supports CRM/order routing platform alignment.',
    `measurement_basis` STRING COMMENT 'Defines whether SLA turn-time targets are measured in business hours, calendar hours, business days, or calendar days. Critical for accurate cycle-time calculation and lender reporting.. Valid values are `business_hours|calendar_hours|business_days|calendar_days`',
    `policy_issuance_hours_target` BIGINT COMMENT 'Maximum number of business hours from recording confirmation to issuance of owner (OTP) and lender (LTP) title policies. Supports policy issuance lag after recording metric per VREQ-016.',
    `product_tier` STRING COMMENT 'Service tier classification applied to this SLA (e.g., standard, expedited, premium, bulk). Drives turn-time targets and pricing in the title production system.. Valid values are `standard|expedited|premium|bulk`',
    `recording_submission_hours_target` BIGINT COMMENT 'Maximum number of business hours from closing to submission of documents to the county recorder/register of deeds via eRecording gateway. Supports recording rejection and resubmission rate metrics.',
    `respa_applicable` BOOLEAN COMMENT 'Indicates whether RESPA requirements (HUD-1/CD, affiliated business arrangement disclosures) apply to orders governed by this SLA.',
    `ron_permitted` BOOLEAN COMMENT 'Indicates whether Remote Online Notarization (RON) is permitted for closings governed by this SLA. State-specific; affects closing coordination and document execution workflows.',
    `search_hours_target` BIGINT COMMENT 'Maximum number of business hours from order intake to delivery of completed title search and chain-of-title (COT) assembly. Key metric for clearance cycle-time analysis.',
    `search_type_required` STRING COMMENT 'Minimum search type required for orders under this SLA: full chain-of-title search, two-owner search, update search, Ownership and Encumbrance (O&E) report, or title plant search.. Valid values are `full_search|two_owner|update|oe_report|plant_search`',
    `search_years_required` BIGINT COMMENT 'Minimum number of years of chain-of-title history required for the title search under this SLA (e.g., 40 years for full search, 2 years for two-owner). Drives evidence completeness metrics.',
    `sla_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying this service-level tier (e.g., SLA-REFI-LENDER-GOLD). Used in order routing and lender integration platforms.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `sla_description` STRING COMMENT 'Free-text narrative describing the scope, conditions, and special terms of this service-level agreement. Used for lender onboarding documentation and internal reference.',
    `sla_name` STRING COMMENT 'Human-readable name for this service-level tier (e.g., Lender Gold Refinance 48-Hour). Displayed in production system dashboards and lender-facing portals.',
    `sla_status` STRING COMMENT 'Current lifecycle state of this SLA record: active (in use), draft (pending approval), inactive (suspended), superseded (replaced by newer version), or expired (past end date).. Valid values are `active|inactive|draft|superseded|expired`',
    `sla_version` STRING COMMENT 'Version identifier for this SLA definition, supporting lifecycle revision tracking (e.g., 1.0, 2.3). Enables audit of prior SLA terms per VREQ-007.. Valid values are `^[0-9]+.[0-9]+$`',
    `state_jurisdiction` STRING COMMENT 'Two-letter US state code (FIPS) for the jurisdiction to which this SLA applies. State-specific regulatory requirements (e.g., state DOI rules) may drive different turn-time commitments.. Valid values are `^[A-Z]{2}$`',
    `superseded_by_sla_code` STRING COMMENT 'SLA code of the newer version that replaced this record when status is superseded. Enables forward-chaining of SLA revision history per VREQ-007.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the jurisdiction or branch where this SLA is applied (e.g., America/Chicago). Ensures accurate business-hour turn-time measurement across geographies.',
    `total_order_hours_target` BIGINT COMMENT 'Maximum total business hours from order intake to policy issuance, representing the end-to-end title clearance cycle-time commitment. Primary SLA metric for lender channel reporting.',
    `transaction_type` STRING COMMENT 'Classification of the real-estate transaction type to which this SLA applies: purchase, refinance (REFI), home-equity line of credit (HELOC), construction, or commercial.. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `trid_applicable` BOOLEAN COMMENT 'Indicates whether TRID disclosure timing requirements apply to orders governed by this SLA. Drives CD issuance timing constraints and closing readiness targets.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this service-level record. Supports change detection and SLA revision frequency analysis in the silver layer.',
    `uw_referral_threshold_usd` DECIMAL(18,2) COMMENT 'Liability amount in USD at or above which orders governed by this SLA require underwriting referral (UWR). Supports underwriting referral and exception rate metrics per VREQ-016.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_service_level PRIMARY KEY(`service_level_id`)
) COMMENT 'Reference/master entity defining service-level agreements and turn-time commitments applied to title orders by channel, transaction type, and product tier.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ADD CONSTRAINT `fk_operations_title_order_order_channel_id` FOREIGN KEY (`order_channel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel`(`order_channel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ADD CONSTRAINT `fk_operations_party_role_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ADD CONSTRAINT `fk_operations_party_role_superseded_by_role_party_role_id` FOREIGN KEY (`superseded_by_role_party_role_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role`(`party_role_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ADD CONSTRAINT `fk_operations_party_role_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ADD CONSTRAINT `fk_operations_title_search_abstractor_party_id` FOREIGN KEY (`abstractor_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ADD CONSTRAINT `fk_operations_title_search_prior_search_title_search_id` FOREIGN KEY (`prior_search_title_search_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search`(`title_search_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ADD CONSTRAINT `fk_operations_title_search_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ADD CONSTRAINT `fk_operations_operations_title_examination_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ADD CONSTRAINT `fk_operations_operations_title_examination_prior_exam_operations_title_examination_id` FOREIGN KEY (`prior_exam_operations_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination`(`operations_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ADD CONSTRAINT `fk_operations_operations_title_examination_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ADD CONSTRAINT `fk_operations_operations_title_examination_title_search_id` FOREIGN KEY (`title_search_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search`(`title_search_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ADD CONSTRAINT `fk_operations_order_status_history_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ADD CONSTRAINT `fk_operations_order_status_history_source_event_order_status_history_id` FOREIGN KEY (`source_event_order_status_history_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history`(`order_status_history_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ADD CONSTRAINT `fk_operations_order_status_history_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_assigned_to_party_id` FOREIGN KEY (`assigned_to_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_operations_title_examination_id` FOREIGN KEY (`operations_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination`(`operations_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ADD CONSTRAINT `fk_operations_service_level_order_channel_id` FOREIGN KEY (`order_channel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel`(`order_channel_id`);

-- ========= TAGS =========
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_operations` SET TAGS ('title_division' = 'operations');
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_operations` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` SET TAGS ('title_subdomain' = 'order_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Independent Agent Profile ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `order_channel_id` SET TAGS ('title_business_glossary_term' = 'Order Channel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `actual_closing_date` SET TAGS ('title_business_glossary_term' = 'Actual Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `buyer_name` SET TAGS ('title_business_glossary_term' = 'Buyer / Borrower Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `buyer_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `buyer_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `cancellation_date` SET TAGS ('title_business_glossary_term' = 'Order Cancellation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `cancellation_reason` SET TAGS ('title_business_glossary_term' = 'Order Cancellation Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `cancellation_reason` SET TAGS ('title_value_regex' = 'buyer_withdrew|financing_fell_through|property_issue|duplicate_order|lender_cancelled|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `closing_disclosure_form_type` SET TAGS ('title_business_glossary_term' = 'Closing Disclosure Form Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `closing_disclosure_form_type` SET TAGS ('title_value_regex' = 'cd|hud1|alta_ss|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `county_name` SET TAGS ('title_business_glossary_term' = 'Subject Property County Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `cpl_required` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `erecording_enabled` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Enabled Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `escrow_officer_name` SET TAGS ('title_business_glossary_term' = 'Escrow Officer (EOT) Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `iolta_required` SET TAGS ('title_business_glossary_term' = 'Interest on Lawyers Trust Account (IOLTA) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `lender_loan_number` SET TAGS ('title_business_glossary_term' = 'Lender Loan Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `lender_name` SET TAGS ('title_business_glossary_term' = 'Lender Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `lender_policy_required` SET TAGS ('title_business_glossary_term' = 'Lender Title Policy (LTP) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `loan_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `loan_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `ltv_ratio` SET TAGS ('title_business_glossary_term' = 'Loan-to-Value Ratio (LTV)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `mers_reporting_required` SET TAGS ('title_business_glossary_term' = 'Mortgage Electronic Registration Systems (MERS) Reporting Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `order_date` SET TAGS ('title_business_glossary_term' = 'Order Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `order_notes` SET TAGS ('title_business_glossary_term' = 'Title Order Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `order_number` SET TAGS ('title_business_glossary_term' = 'Title Order Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `order_number` SET TAGS ('title_value_regex' = '^[A-Z0-9-]{6,30}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `order_received_timestamp` SET TAGS ('title_business_glossary_term' = 'Order Received Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `order_status` SET TAGS ('title_business_glossary_term' = 'Title Order Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `owner_policy_required` SET TAGS ('title_business_glossary_term' = 'Owner Title Policy (OTP) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `prior_order_number` SET TAGS ('title_business_glossary_term' = 'Prior Title Order Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `production_source` SET TAGS ('title_business_glossary_term' = 'Production Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `production_source` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_address_line1` SET TAGS ('title_business_glossary_term' = 'Subject Property Address Line 1');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_address_line1` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_address_line1` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_city` SET TAGS ('title_business_glossary_term' = 'Subject Property City');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_state_code` SET TAGS ('title_business_glossary_term' = 'Subject Property State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_zip_code` SET TAGS ('title_business_glossary_term' = 'Subject Property ZIP Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_zip_code` SET TAGS ('title_value_regex' = '^[0-9]{5}(-[0-9]{4})?$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_zip_code` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `property_zip_code` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `respa_applicable` SET TAGS ('title_business_glossary_term' = 'Real Estate Settlement Procedures Act (RESPA) Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `ron_enabled` SET TAGS ('title_business_glossary_term' = 'Remote Online Notarization (RON) Enabled Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `sales_price_amount` SET TAGS ('title_business_glossary_term' = 'Sales Price Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `sales_price_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `sales_price_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `scheduled_closing_date` SET TAGS ('title_business_glossary_term' = 'Scheduled Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `seller_name` SET TAGS ('title_business_glossary_term' = 'Seller Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `seller_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `seller_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `sla_commitment_due_date` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Commitment Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `title_examiner_name` SET TAGS ('title_business_glossary_term' = 'Title Examiner Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `trid_applicable` SET TAGS ('title_business_glossary_term' = 'TILA-RESPA Integrated Disclosure (TRID) Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `underwriter_code` SET TAGS ('title_business_glossary_term' = 'Underwriter Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `underwriter_code` SET TAGS ('title_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` SET TAGS ('title_subdomain' = 'order_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `party_code` SET TAGS ('title_business_glossary_term' = 'Party Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `party_code` SET TAGS ('title_value_regex' = '^PTY-[A-Z0-9]{6,20}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `date_of_birth` SET TAGS ('title_business_glossary_term' = 'Date of Birth');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `date_of_birth` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `date_of_birth` SET TAGS ('title_pii_dob' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `dba_name` SET TAGS ('title_business_glossary_term' = 'Doing Business As (DBA) Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `dba_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `deceased_date` SET TAGS ('title_business_glossary_term' = 'Deceased Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `deceased_date` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `entity_formation_date` SET TAGS ('title_business_glossary_term' = 'Entity Formation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `entity_formation_state` SET TAGS ('title_business_glossary_term' = 'Entity Formation State');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `entity_formation_state` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `fax_number` SET TAGS ('title_business_glossary_term' = 'Fax Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `fax_number` SET TAGS ('title_value_regex' = '^+?[1-9]d{1,14}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `fax_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `fax_number` SET TAGS ('title_pii_phone' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `first_name` SET TAGS ('title_business_glossary_term' = 'First Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `first_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `first_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `identity_doc_ref` SET TAGS ('title_business_glossary_term' = 'Identity Document Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `identity_doc_ref` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `identity_doc_ref` SET TAGS ('title_pii_identifier' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `is_deceased` SET TAGS ('title_business_glossary_term' = 'Deceased Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `is_do_not_contact` SET TAGS ('title_business_glossary_term' = 'Do Not Contact Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `is_foreign_national` SET TAGS ('title_business_glossary_term' = 'Foreign National Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `is_nppi_consent_given` SET TAGS ('title_business_glossary_term' = 'Non-Public Personal Information (NPPI) Consent Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `last_name` SET TAGS ('title_business_glossary_term' = 'Last Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `last_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `last_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `legal_name` SET TAGS ('title_business_glossary_term' = 'Legal Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `legal_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `legal_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_address_line1` SET TAGS ('title_business_glossary_term' = 'Mailing Address Line 1');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_address_line1` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_address_line1` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_address_line2` SET TAGS ('title_business_glossary_term' = 'Mailing Address Line 2');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_address_line2` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_address_line2` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_city` SET TAGS ('title_business_glossary_term' = 'Mailing City');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_city` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_city` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_country` SET TAGS ('title_business_glossary_term' = 'Mailing Country');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_country` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_postal_code` SET TAGS ('title_business_glossary_term' = 'Mailing Postal Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_postal_code` SET TAGS ('title_value_regex' = '^d{5}(-d{4})?$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_postal_code` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_postal_code` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_state` SET TAGS ('title_business_glossary_term' = 'Mailing State');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_state` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_state` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mailing_state` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `marital_status` SET TAGS ('title_business_glossary_term' = 'Marital Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `marital_status` SET TAGS ('title_value_regex' = 'single|married|divorced|widowed|separated|unknown');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `marital_status` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `middle_name` SET TAGS ('title_business_glossary_term' = 'Middle Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `middle_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `middle_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mobile_phone` SET TAGS ('title_business_glossary_term' = 'Mobile Phone Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mobile_phone` SET TAGS ('title_value_regex' = '^+?[1-9]d{1,14}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mobile_phone` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `mobile_phone` SET TAGS ('title_pii_phone' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `name_suffix` SET TAGS ('title_business_glossary_term' = 'Name Suffix');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `name_suffix` SET TAGS ('title_value_regex' = 'Jr.|Sr.|II|III|IV|Esq.');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `nppi_consent_date` SET TAGS ('title_business_glossary_term' = 'Non-Public Personal Information (NPPI) Consent Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `ofac_screen_date` SET TAGS ('title_business_glossary_term' = 'OFAC Screen Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `ofac_screen_result` SET TAGS ('title_business_glossary_term' = 'OFAC Screen Result');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `ofac_screen_result` SET TAGS ('title_value_regex' = 'clear|hit|pending_review|inconclusive');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `ofac_screened` SET TAGS ('title_business_glossary_term' = 'OFAC Screened Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `organization_name` SET TAGS ('title_business_glossary_term' = 'Organization Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `organization_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `party_status` SET TAGS ('title_business_glossary_term' = 'Party Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `party_status` SET TAGS ('title_value_regex' = 'active|inactive|merged|deceased|dissolved|suspended');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `party_type` SET TAGS ('title_business_glossary_term' = 'Party Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `party_type` SET TAGS ('title_value_regex' = 'individual|organization|trust|estate|government|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `preferred_contact_method` SET TAGS ('title_business_glossary_term' = 'Preferred Contact Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `preferred_contact_method` SET TAGS ('title_value_regex' = 'email|phone|mail|fax|portal');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `primary_email` SET TAGS ('title_business_glossary_term' = 'Primary Email Address');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `primary_email` SET TAGS ('title_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `primary_email` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `primary_email` SET TAGS ('title_pii_email' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `primary_phone` SET TAGS ('title_business_glossary_term' = 'Primary Phone Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `primary_phone` SET TAGS ('title_value_regex' = '^+?[1-9]d{1,14}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `primary_phone` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `primary_phone` SET TAGS ('title_pii_phone' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `record_effective_date` SET TAGS ('title_business_glossary_term' = 'Record Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `record_expiry_date` SET TAGS ('title_business_glossary_term' = 'Record Expiry Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `secondary_email` SET TAGS ('title_business_glossary_term' = 'Secondary Email Address');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `secondary_email` SET TAGS ('title_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `secondary_email` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `secondary_email` SET TAGS ('title_pii_email' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `source_system_party_code` SET TAGS ('title_business_glossary_term' = 'Source System Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `tax_id_ref` SET TAGS ('title_business_glossary_term' = 'Tax Identifier (TIN/SSN) Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `tax_id_ref` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `tax_id_ref` SET TAGS ('title_pii_identifier' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `vesting_type` SET TAGS ('title_business_glossary_term' = 'Vesting Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `vesting_type` SET TAGS ('title_value_regex' = 'sole_and_separate|joint_tenancy|tenancy_in_common|community_property|trust|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` SET TAGS ('title_data_type' = 'association_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` SET TAGS ('title_subdomain' = 'order_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `party_role_id` SET TAGS ('title_business_glossary_term' = 'Party Role ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `cpl_issuance_id` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issuance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `superseded_by_role_party_role_id` SET TAGS ('title_business_glossary_term' = 'Superseded By Role ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `aml_screening_date` SET TAGS ('title_business_glossary_term' = 'Anti-Money Laundering (AML) Screening Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `aml_screening_status` SET TAGS ('title_business_glossary_term' = 'Anti-Money Laundering (AML) Screening Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `aml_screening_status` SET TAGS ('title_value_regex' = 'pending|cleared|flagged|escalated|exempt');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `authority_document_ref` SET TAGS ('title_business_glossary_term' = 'Authority Document Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `authority_type` SET TAGS ('title_business_glossary_term' = 'Authority Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `authority_type` SET TAGS ('title_value_regex' = 'self|power_of_attorney|trustee|executor|guardian|corporate_officer');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `party_role_code` SET TAGS ('title_business_glossary_term' = 'Party Role Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `party_role_code` SET TAGS ('title_value_regex' = '^[A-Z0-9_]{2,30}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `cpl_required` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `firpta_withholding_required` SET TAGS ('title_business_glossary_term' = 'Foreign Investment in Real Property Tax Act (FIRPTA) Withholding Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `foreign_national_flag` SET TAGS ('title_business_glossary_term' = 'Foreign National Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `identity_verification_date` SET TAGS ('title_business_glossary_term' = 'Identity Verification Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `identity_verification_method` SET TAGS ('title_business_glossary_term' = 'Identity Verification Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `identity_verified` SET TAGS ('title_business_glossary_term' = 'Identity Verified Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `is_primary` SET TAGS ('title_business_glossary_term' = 'Is Primary Role Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `is_vesting_party` SET TAGS ('title_business_glossary_term' = 'Is Vesting Party Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `marital_status` SET TAGS ('title_business_glossary_term' = 'Marital Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `marital_status` SET TAGS ('title_value_regex' = 'single|married|divorced|widowed|separated|unknown');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `marital_status` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `notice_delivery_method` SET TAGS ('title_business_glossary_term' = 'Notice Delivery Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `notice_delivery_method` SET TAGS ('title_value_regex' = 'email|mail|fax|portal|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `nppi_vault_ref` SET TAGS ('title_business_glossary_term' = 'Non-Public Personal Information (NPPI) Vault Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `nppi_vault_ref` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `nppi_vault_ref` SET TAGS ('title_pii_identifier' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `ownership_percentage` SET TAGS ('title_business_glossary_term' = 'Ownership Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `party_capacity` SET TAGS ('title_business_glossary_term' = 'Party Capacity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `party_capacity` SET TAGS ('title_value_regex' = 'individual|entity|trust|estate|government|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `respa_affiliated_flag` SET TAGS ('title_business_glossary_term' = 'Real Estate Settlement Procedures Act (RESPA) Affiliated Business Arrangement Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_category` SET TAGS ('title_business_glossary_term' = 'Role Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_category` SET TAGS ('title_value_regex' = 'principal|service_provider|lender|government|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_notes` SET TAGS ('title_business_glossary_term' = 'Role Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_sequence` SET TAGS ('title_business_glossary_term' = 'Role Sequence');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_source_system` SET TAGS ('title_business_glossary_term' = 'Role Source System');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_source_system` SET TAGS ('title_value_regex' = 'title_production|crm|lender_portal|agency_system|manual|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_status` SET TAGS ('title_business_glossary_term' = 'Role Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_status` SET TAGS ('title_value_regex' = 'active|inactive|superseded|withdrawn|pending');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_type` SET TAGS ('title_business_glossary_term' = 'Role Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `role_type` SET TAGS ('title_value_regex' = 'buyer|seller|borrower|lender|trustee|agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `source_system_ref` SET TAGS ('title_business_glossary_term' = 'Source System Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `spouse_consent_required` SET TAGS ('title_business_glossary_term' = 'Spouse Consent Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `trid_disclosure_required` SET TAGS ('title_business_glossary_term' = 'TILA-RESPA Integrated Disclosure (TRID) Required Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `vesting_type` SET TAGS ('title_business_glossary_term' = 'Vesting Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `vesting_type` SET TAGS ('title_value_regex' = 'sole_ownership|joint_tenancy|tenancy_in_common|community_property|trust|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` SET TAGS ('title_subdomain' = 'title_processing');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `title_search_id` SET TAGS ('title_business_glossary_term' = 'Title Search ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `abstractor_party_id` SET TAGS ('title_business_glossary_term' = 'Abstractor Party Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `jurisdiction_id` SET TAGS ('title_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `prior_search_title_search_id` SET TAGS ('title_business_glossary_term' = 'Prior Title Search ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `cancellation_reason` SET TAGS ('title_business_glossary_term' = 'Search Cancellation Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `cancelled_timestamp` SET TAGS ('title_business_glossary_term' = 'Search Cancelled Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `completed_timestamp` SET TAGS ('title_business_glossary_term' = 'Search Completed Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `cot_break_description` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `cot_break_detected` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Detected Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `cot_start_year` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Start Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `easement_found` SET TAGS ('title_business_glossary_term' = 'Easement Found Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `encroachment_found` SET TAGS ('title_business_glossary_term' = 'Encroachment Found Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `gap_period_end_date` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Period End Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `gap_period_start_date` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Period Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `hoa_lien_found` SET TAGS ('title_business_glossary_term' = 'Homeowners Association (HOA) Lien Found Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `instrument_count` SET TAGS ('title_business_glossary_term' = 'Instrument Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `is_automated_search` SET TAGS ('title_business_glossary_term' = 'Automated Search Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `is_sla_breached` SET TAGS ('title_business_glossary_term' = 'Search Service Level Agreement (SLA) Breach Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `lis_pendens_found` SET TAGS ('title_business_glossary_term' = 'Lis Pendens (LP) Found Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `open_judgment_count` SET TAGS ('title_business_glossary_term' = 'Open Judgment Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `open_lien_count` SET TAGS ('title_business_glossary_term' = 'Open Lien Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `ordered_date` SET TAGS ('title_business_glossary_term' = 'Search Ordered Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `ordered_timestamp` SET TAGS ('title_business_glossary_term' = 'Search Ordered Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `plant_coverage_from_date` SET TAGS ('title_business_glossary_term' = 'Title Plant Coverage From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `plant_coverage_to_date` SET TAGS ('title_business_glossary_term' = 'Title Plant Coverage To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `prior_deed_type` SET TAGS ('title_business_glossary_term' = 'Prior Deed Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `prior_deed_type` SET TAGS ('title_value_regex' = 'warranty_deed|special_warranty_deed|quit_claim_deed|grant_deed|trustee_deed|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Search Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_fee_amount` SET TAGS ('title_business_glossary_term' = 'Title Search Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_fee_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_fee_currency` SET TAGS ('title_business_glossary_term' = 'Title Search Fee Currency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_fee_currency` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_from_date` SET TAGS ('title_business_glossary_term' = 'Search From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_number` SET TAGS ('title_business_glossary_term' = 'Title Search Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_number` SET TAGS ('title_value_regex' = '^TS-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_purpose` SET TAGS ('title_business_glossary_term' = 'Title Search Purpose');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_purpose` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|equity_loan');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_result_document_ref` SET TAGS ('title_business_glossary_term' = 'Search Result Document Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_source_type` SET TAGS ('title_business_glossary_term' = 'Search Source Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_source_type` SET TAGS ('title_value_regex' = 'title_plant|public_record|automated|manual|hybrid');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_status` SET TAGS ('title_business_glossary_term' = 'Title Search Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_status` SET TAGS ('title_value_regex' = 'ordered|in_progress|completed|cancelled|on_hold|failed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_to_date` SET TAGS ('title_business_glossary_term' = 'Search To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_type` SET TAGS ('title_business_glossary_term' = 'Title Search Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_type` SET TAGS ('title_value_regex' = 'full|update|oe_report|two_owner|30_year|current_owner');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_vendor_code` SET TAGS ('title_business_glossary_term' = 'Search Vendor Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `search_vendor_name` SET TAGS ('title_business_glossary_term' = 'Search Vendor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `sla_due_date` SET TAGS ('title_business_glossary_term' = 'Search Service Level Agreement (SLA) Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `sla_hours_target` SET TAGS ('title_business_glossary_term' = 'Search Service Level Agreement (SLA) Target Hours');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `source_system_search_code` SET TAGS ('title_business_glossary_term' = 'Source System Search ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `tax_lien_found` SET TAGS ('title_business_glossary_term' = 'Tax Lien Found Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `ucc_filing_found` SET TAGS ('title_business_glossary_term' = 'Uniform Commercial Code (UCC) Filing Found Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `vesting_deed_instrument_number` SET TAGS ('title_business_glossary_term' = 'Vesting Deed Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `vesting_deed_recording_date` SET TAGS ('title_business_glossary_term' = 'Vesting Deed Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `vesting_grantee_name` SET TAGS ('title_business_glossary_term' = 'Vesting Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `vesting_grantor_name` SET TAGS ('title_business_glossary_term' = 'Vesting Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` SET TAGS ('title_subdomain' = 'title_processing');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `operations_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Operations Title Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Examiner Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `prior_exam_operations_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Prior Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `title_search_id` SET TAGS ('title_business_glossary_term' = 'Title Search ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `cot_break_description` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `cot_break_detected` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Detected');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `cot_start_date` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `county_name` SET TAGS ('title_business_glossary_term' = 'County Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `defect_count` SET TAGS ('title_business_glossary_term' = 'Defect Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `easement_count` SET TAGS ('title_business_glossary_term' = 'Easement Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `evidence_completeness_flag` SET TAGS ('title_business_glossary_term' = 'Evidence Completeness Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examination_complete_timestamp` SET TAGS ('title_business_glossary_term' = 'Examination Complete Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examination_date` SET TAGS ('title_business_glossary_term' = 'Examination Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examination_number` SET TAGS ('title_business_glossary_term' = 'Examination Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examination_start_timestamp` SET TAGS ('title_business_glossary_term' = 'Examination Start Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examination_status` SET TAGS ('title_business_glossary_term' = 'Examination Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examination_status` SET TAGS ('title_value_regex' = 'in_progress|complete|referred|on_hold|cancelled');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examination_type` SET TAGS ('title_business_glossary_term' = 'Examination Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examination_type` SET TAGS ('title_value_regex' = 'full|update|bring_down|oe_report|gap');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examiner_license_number` SET TAGS ('title_business_glossary_term' = 'Examiner License Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examiner_name` SET TAGS ('title_business_glossary_term' = 'Examiner Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `examiner_notes` SET TAGS ('title_business_glossary_term' = 'Examiner Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `exception_count` SET TAGS ('title_business_glossary_term' = 'Exception Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `gap_coverage_required` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Required');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `judgment_lien_detected` SET TAGS ('title_business_glossary_term' = 'Judgment Lien Detected');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `lien_count` SET TAGS ('title_business_glossary_term' = 'Lien Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `lis_pendens_detected` SET TAGS ('title_business_glossary_term' = 'Lis Pendens (LP) Detected');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `mers_lien_detected` SET TAGS ('title_business_glossary_term' = 'Mortgage Electronic Registration Systems (MERS) Lien Detected');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `missing_evidence_description` SET TAGS ('title_business_glossary_term' = 'Missing Evidence Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `open_lien_amount` SET TAGS ('title_business_glossary_term' = 'Open Lien Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `open_lien_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `property_state_code` SET TAGS ('title_business_glossary_term' = 'Property State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `property_state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `requirement_count` SET TAGS ('title_business_glossary_term' = 'Requirement Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `search_through_date` SET TAGS ('title_business_glossary_term' = 'Search Through Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `source_system_exam_code` SET TAGS ('title_business_glossary_term' = 'Source System Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `tax_lien_detected` SET TAGS ('title_business_glossary_term' = 'Tax Lien Detected');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `title_opinion` SET TAGS ('title_business_glossary_term' = 'Title Opinion');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `title_opinion` SET TAGS ('title_value_regex' = 'marketable|insurable|uninsurable|conditional|defective');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `uw_referral_reason` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `uw_referral_required` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral Required');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `vesting_deed_type` SET TAGS ('title_business_glossary_term' = 'Vesting Deed Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `vesting_deed_type` SET TAGS ('title_value_regex' = 'warranty_deed|special_warranty_deed|quit_claim_deed|grant_deed|trustee_deed|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `vesting_description` SET TAGS ('title_business_glossary_term' = 'Vesting Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` SET TAGS ('title_subdomain' = 'order_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `order_status_history_id` SET TAGS ('title_business_glossary_term' = 'Order Status History ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Independent Agent Profile ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Transition Triggered By User ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `party_id` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `party_id` SET TAGS ('title_pii' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `source_event_order_status_history_id` SET TAGS ('title_business_glossary_term' = 'Source System Event ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Order Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'DIRECT_BRANCH|CENTRALIZED_LENDER|INDEPENDENT_AGENT');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `closing_readiness_status` SET TAGS ('title_business_glossary_term' = 'Closing Readiness Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `closing_readiness_status` SET TAGS ('title_value_regex' = 'NOT_READY|CONDITIONALLY_READY|READY|CLOSED');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `commitment_revision_number` SET TAGS ('title_business_glossary_term' = 'Title Commitment Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `cot_break_identified` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Identified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `duration_in_prior_status_hours` SET TAGS ('title_business_glossary_term' = 'Duration in Prior Status (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `erecording_enabled` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Enabled Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `escrow_officer_name` SET TAGS ('title_business_glossary_term' = 'Escrow Officer Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `gap_coverage_required` SET TAGS ('title_business_glossary_term' = 'Gap Coverage (GAP) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `is_current` SET TAGS ('title_business_glossary_term' = 'Current Status Record Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `is_regression` SET TAGS ('title_business_glossary_term' = 'Status Regression Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `new_status` SET TAGS ('title_business_glossary_term' = 'New Order Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Transition Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `open_finding_count` SET TAGS ('title_business_glossary_term' = 'Open Title Finding Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `open_requirement_count` SET TAGS ('title_business_glossary_term' = 'Open Title Requirement Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `order_number` SET TAGS ('title_business_glossary_term' = 'Order Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `policy_exception_required` SET TAGS ('title_business_glossary_term' = 'Policy Exception (PE) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `prior_status` SET TAGS ('title_business_glossary_term' = 'Prior Order Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `regression_reason_code` SET TAGS ('title_business_glossary_term' = 'Status Regression Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `ron_enabled` SET TAGS ('title_business_glossary_term' = 'Remote Online Notarization (RON) Enabled Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `sequence_number` SET TAGS ('title_business_glossary_term' = 'Status Transition Sequence Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `sla_breach_hours` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Breach Duration Hours');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `sla_breached` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Breached Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `sla_due_timestamp` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Due Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `sla_target_hours` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Target Hours');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Jurisdiction Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `title_examiner_name` SET TAGS ('title_business_glossary_term' = 'Title Examiner Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'PURCHASE|REFINANCE|HELOC|CONSTRUCTION|COMMERCIAL');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `transition_reason_code` SET TAGS ('title_business_glossary_term' = 'Status Transition Reason Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `transition_reason_description` SET TAGS ('title_business_glossary_term' = 'Status Transition Reason Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `transition_timestamp` SET TAGS ('title_business_glossary_term' = 'Status Transition Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `triggered_by_system` SET TAGS ('title_business_glossary_term' = 'Triggering Source System');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `triggered_by_type` SET TAGS ('title_business_glossary_term' = 'Transition Triggered By Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `triggered_by_type` SET TAGS ('title_value_regex' = 'USER|SYSTEM|INTEGRATION|SCHEDULER|UNDERWRITER');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `triggered_by_user_name` SET TAGS ('title_business_glossary_term' = 'Transition Triggered By User Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `triggered_by_user_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `triggered_by_user_name` SET TAGS ('title_pii_identifier' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `uw_referral_required` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` SET TAGS ('title_subdomain' = 'title_processing');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `operations_curative_action_id` SET TAGS ('title_business_glossary_term' = 'Operations Curative Action ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `assigned_to_party_id` SET TAGS ('title_business_glossary_term' = 'Assigned Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `easement_restriction_id` SET TAGS ('title_business_glossary_term' = 'Easement Restriction Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `encumbrance_id` SET TAGS ('title_business_glossary_term' = 'Encumbrance Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `operations_title_examination_id` SET TAGS ('title_business_glossary_term' = 'Title Examination ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `title_evidence_id` SET TAGS ('title_business_glossary_term' = 'Evidence Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `title_finding_id` SET TAGS ('title_business_glossary_term' = 'Title Finding ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `title_requirement_id` SET TAGS ('title_business_glossary_term' = 'Title Requirement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `uw_referral_id` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `action_notes` SET TAGS ('title_business_glossary_term' = 'Curative Action Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `action_number` SET TAGS ('title_business_glossary_term' = 'Curative Action Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `action_status` SET TAGS ('title_business_glossary_term' = 'Curative Action Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `action_status` SET TAGS ('title_value_regex' = 'open|in_progress|pending_receipt|completed|waived|escalated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `action_type` SET TAGS ('title_business_glossary_term' = 'Curative Action Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `action_type` SET TAGS ('title_value_regex' = 'obtain_release|record_reconveyance|obtain_payoff|record_satisfaction|obtain_affidavit|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `clearance_method` SET TAGS ('title_business_glossary_term' = 'Clearance Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `clearance_method` SET TAGS ('title_value_regex' = 'recorded_instrument|payoff_disbursement|affidavit|court_order|waiver|insured_over');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `completed_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Completed Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `cot_break_indicator` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `days_open` SET TAGS ('title_business_glossary_term' = 'Days Open');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `defect_severity` SET TAGS ('title_business_glossary_term' = 'Defect Severity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `defect_severity` SET TAGS ('title_value_regex' = 'critical|high|medium|low');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `defect_type` SET TAGS ('title_business_glossary_term' = 'Title Defect Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `due_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `erecording_used` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Used Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `escalated_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Escalated Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `evidence_received` SET TAGS ('title_business_glossary_term' = 'Curative Evidence Received Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `evidence_received_date` SET TAGS ('title_business_glossary_term' = 'Curative Evidence Received Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `gap_coverage_required` SET TAGS ('title_business_glossary_term' = 'Gap Coverage (GAP) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `instrument_acceptance_date` SET TAGS ('title_business_glossary_term' = 'Instrument Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `instrument_effective_date` SET TAGS ('title_business_glossary_term' = 'Instrument Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `instrument_execution_date` SET TAGS ('title_business_glossary_term' = 'Instrument Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `instrument_recording_date` SET TAGS ('title_business_glossary_term' = 'Instrument Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `instrument_reference_number` SET TAGS ('title_business_glossary_term' = 'Curative Instrument Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `instrument_submission_date` SET TAGS ('title_business_glossary_term' = 'Instrument Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `instrument_type` SET TAGS ('title_business_glossary_term' = 'Curative Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `lienholder_loan_number` SET TAGS ('title_business_glossary_term' = 'Lienholder Loan Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `lienholder_name` SET TAGS ('title_business_glossary_term' = 'Lienholder Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `mers_min` SET TAGS ('title_business_glossary_term' = 'Mortgage Electronic Registration Systems (MERS) Mortgage Identification Number (MIN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `mers_min` SET TAGS ('title_value_regex' = '^[0-9]{18}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `opened_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Opened Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `payoff_amount` SET TAGS ('title_business_glossary_term' = 'Payoff Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `payoff_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `payoff_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `payoff_good_through_date` SET TAGS ('title_business_glossary_term' = 'Payoff Good-Through Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `prior_action_status` SET TAGS ('title_business_glossary_term' = 'Prior Curative Action Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `prior_action_status` SET TAGS ('title_value_regex' = 'open|in_progress|pending_receipt|completed|waived|escalated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `priority` SET TAGS ('title_business_glossary_term' = 'Curative Action Priority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `priority` SET TAGS ('title_value_regex' = 'rush|standard|low');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `recording_jurisdiction` SET TAGS ('title_business_glossary_term' = 'Recording Jurisdiction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `responsible_party_role` SET TAGS ('title_business_glossary_term' = 'Responsible Party Role');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `responsible_party_role` SET TAGS ('title_value_regex' = 'curative_specialist|title_examiner|escrow_officer|external_vendor|underwriter');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `sla_breached` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Breached Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `sla_target_days` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Target Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `status_changed_timestamp` SET TAGS ('title_business_glossary_term' = 'Status Changed Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `uw_referral_required` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `waived_date` SET TAGS ('title_business_glossary_term' = 'Curative Action Waived Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` SET TAGS ('title_data_type' = 'reference_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` SET TAGS ('title_subdomain' = 'order_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `order_channel_id` SET TAGS ('title_business_glossary_term' = 'Order Channel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `affiliated_business_arrangement` SET TAGS ('title_business_glossary_term' = 'Affiliated Business Arrangement (AfBA) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_category` SET TAGS ('title_business_glossary_term' = 'Order Channel Category');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_category` SET TAGS ('title_value_regex' = 'retail|institutional|agency|digital');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_code` SET TAGS ('title_business_glossary_term' = 'Order Channel Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_code` SET TAGS ('title_value_regex' = '^[A-Z0-9_]{2,30}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_description` SET TAGS ('title_business_glossary_term' = 'Order Channel Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_name` SET TAGS ('title_business_glossary_term' = 'Order Channel Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_owner_email` SET TAGS ('title_business_glossary_term' = 'Channel Owner Email Address');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_owner_email` SET TAGS ('title_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_owner_email` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_owner_email` SET TAGS ('title_pii_email' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_owner_name` SET TAGS ('title_business_glossary_term' = 'Channel Owner Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_status` SET TAGS ('title_business_glossary_term' = 'Order Channel Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_status` SET TAGS ('title_value_regex' = 'active|inactive|suspended|pending');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Order Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'direct|lender|agent|consumer|wholesale');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `closing_disclosure_form_type` SET TAGS ('title_business_glossary_term' = 'Closing Disclosure Form Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `closing_disclosure_form_type` SET TAGS ('title_value_regex' = 'cd|hud1|alta_ss|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `cost_center_code` SET TAGS ('title_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `cost_center_code` SET TAGS ('title_value_regex' = '^[A-Z0-9-]{2,20}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `default_transaction_type` SET TAGS ('title_business_glossary_term' = 'Default Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `default_transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Channel Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `erecording_enabled` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Enabled Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `escrow_handling_type` SET TAGS ('title_business_glossary_term' = 'Escrow Handling Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `escrow_handling_type` SET TAGS ('title_value_regex' = 'in_house|agent_handled|lender_controlled|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Channel Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `external_channel_ref_code` SET TAGS ('title_business_glossary_term' = 'External Channel Reference Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `gl_revenue_account_code` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Revenue Account Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `gl_revenue_account_code` SET TAGS ('title_value_regex' = '^[A-Z0-9-]{3,20}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `iolta_required` SET TAGS ('title_business_glossary_term' = 'Interest on Lawyers Trust Account (IOLTA) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `ipen_enabled` SET TAGS ('title_business_glossary_term' = 'In-Person Electronic Notarization (IPEN) Enabled Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `is_default_channel` SET TAGS ('title_business_glossary_term' = 'Is Default Channel Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `last_updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `lender_integration_type` SET TAGS ('title_business_glossary_term' = 'Lender Integration Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `lender_integration_type` SET TAGS ('title_value_regex' = 'api|file_transfer|portal|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `lender_platform_name` SET TAGS ('title_business_glossary_term' = 'Lender Platform Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `mers_reporting_required` SET TAGS ('title_business_glossary_term' = 'Mortgage Electronic Registration Systems (MERS) Reporting Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `nppi_data_sharing_permitted` SET TAGS ('title_business_glossary_term' = 'Non-Public Personal Information (NPPI) Data Sharing Permitted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `order_intake_method` SET TAGS ('title_business_glossary_term' = 'Order Intake Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `order_intake_method` SET TAGS ('title_value_regex' = 'api|portal|email|phone|fax|edi');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `premium_split_type` SET TAGS ('title_business_glossary_term' = 'Premium Split Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `premium_split_type` SET TAGS ('title_value_regex' = 'direct|agency|net_retained');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `production_source` SET TAGS ('title_business_glossary_term' = 'Production Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `production_source` SET TAGS ('title_value_regex' = 'branch|lender_channel|independent_agent|consumer_direct|wholesale');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `remittance_required` SET TAGS ('title_business_glossary_term' = 'Premium Remittance Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `requires_agency_agreement` SET TAGS ('title_business_glossary_term' = 'Requires Agency Agreement Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `requires_cpl` SET TAGS ('title_business_glossary_term' = 'Requires Closing Protection Letter (CPL) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `respa_applicable` SET TAGS ('title_business_glossary_term' = 'Real Estate Settlement Procedures Act (RESPA) Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `ron_enabled` SET TAGS ('title_business_glossary_term' = 'Remote Online Notarization (RON) Enabled Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `routing_priority` SET TAGS ('title_business_glossary_term' = 'Routing Priority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `sla_commitment_hours` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Commitment Issuance Hours');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `sla_intake_hours` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Order Intake Hours');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `sla_search_hours` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Title Search Hours');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `sox_control_applicable` SET TAGS ('title_business_glossary_term' = 'Sarbanes-Oxley (SOX) Control Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `state_jurisdiction_scope` SET TAGS ('title_business_glossary_term' = 'State Jurisdiction Scope');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `supports_commercial` SET TAGS ('title_business_glossary_term' = 'Supports Commercial Transactions Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `supports_residential` SET TAGS ('title_business_glossary_term' = 'Supports Residential Transactions Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `suspension_date` SET TAGS ('title_business_glossary_term' = 'Channel Suspension Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `suspension_reason` SET TAGS ('title_business_glossary_term' = 'Channel Suspension Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `trid_applicable` SET TAGS ('title_business_glossary_term' = 'TILA-RESPA Integrated Disclosure (TRID) Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `underwriter_referral_threshold_usd` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral Threshold Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `version_number` SET TAGS ('title_business_glossary_term' = 'Channel Configuration Version Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` SET TAGS ('title_domain' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` SET TAGS ('title_subdomain' = 'order_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `service_level_id` SET TAGS ('title_business_glossary_term' = 'Service Level ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `order_channel_id` SET TAGS ('title_business_glossary_term' = 'Order Channel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `approval_date` SET TAGS ('title_business_glossary_term' = 'SLA Approval Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `approved_by` SET TAGS ('title_business_glossary_term' = 'SLA Approved By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `breach_penalty_applicable` SET TAGS ('title_business_glossary_term' = 'SLA Breach Penalty Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `breach_penalty_description` SET TAGS ('title_business_glossary_term' = 'SLA Breach Penalty Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `business_hours_end` SET TAGS ('title_business_glossary_term' = 'Business Hours End Time');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `business_hours_end` SET TAGS ('title_value_regex' = '^([01]d|2[0-3]):[0-5]d$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `business_hours_start` SET TAGS ('title_business_glossary_term' = 'Business Hours Start Time');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `business_hours_start` SET TAGS ('title_value_regex' = '^([01]d|2[0-3]):[0-5]d$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `closing_disclosure_form_type` SET TAGS ('title_business_glossary_term' = 'Closing Disclosure Form Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `closing_disclosure_form_type` SET TAGS ('title_value_regex' = 'cd|hud1|alta_ss|custom');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `closing_readiness_hours_target` SET TAGS ('title_business_glossary_term' = 'Closing Readiness Turn-Time Target (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `commitment_form_type` SET TAGS ('title_business_glossary_term' = 'Title Commitment Form Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `commitment_form_type` SET TAGS ('title_value_regex' = 'alta_2021|alta_2016|state_specific|custom');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `commitment_hours_target` SET TAGS ('title_business_glossary_term' = 'Title Commitment Issuance Turn-Time Target (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `cpl_required` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `curative_hours_target` SET TAGS ('title_business_glossary_term' = 'Curative Processing Turn-Time Target (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `erecording_required` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `escalation_threshold_hours` SET TAGS ('title_business_glossary_term' = 'Escalation Threshold (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `examination_hours_target` SET TAGS ('title_business_glossary_term' = 'Title Examination Turn-Time Target (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `gap_coverage_required` SET TAGS ('title_business_glossary_term' = 'Gap Coverage (GAP) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `intake_hours_target` SET TAGS ('title_business_glossary_term' = 'Order Intake Turn-Time Target (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `iolta_required` SET TAGS ('title_business_glossary_term' = 'Interest on Lawyers Trust Account (IOLTA) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `ipen_permitted` SET TAGS ('title_business_glossary_term' = 'In-Person Electronic Notarization (IPEN) Permitted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `lender_name` SET TAGS ('title_business_glossary_term' = 'Lender Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `lender_platform` SET TAGS ('title_business_glossary_term' = 'Lender Integration Platform');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `measurement_basis` SET TAGS ('title_business_glossary_term' = 'Turn-Time Measurement Basis');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `measurement_basis` SET TAGS ('title_value_regex' = 'business_hours|calendar_hours|business_days|calendar_days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `policy_issuance_hours_target` SET TAGS ('title_business_glossary_term' = 'Policy Issuance Turn-Time Target (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `product_tier` SET TAGS ('title_business_glossary_term' = 'Product Tier');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `product_tier` SET TAGS ('title_value_regex' = 'standard|expedited|premium|bulk');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `recording_submission_hours_target` SET TAGS ('title_business_glossary_term' = 'Recording Submission Turn-Time Target (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `respa_applicable` SET TAGS ('title_business_glossary_term' = 'Real Estate Settlement Procedures Act (RESPA) Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `ron_permitted` SET TAGS ('title_business_glossary_term' = 'Remote Online Notarization (RON) Permitted Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `search_hours_target` SET TAGS ('title_business_glossary_term' = 'Title Search Turn-Time Target (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `search_type_required` SET TAGS ('title_business_glossary_term' = 'Required Search Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `search_type_required` SET TAGS ('title_value_regex' = 'full_search|two_owner|update|oe_report|plant_search');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `search_years_required` SET TAGS ('title_business_glossary_term' = 'Required Search Period (Years)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `sla_code` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `sla_code` SET TAGS ('title_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `sla_description` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `sla_name` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `sla_status` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `sla_status` SET TAGS ('title_value_regex' = 'active|inactive|draft|superseded|expired');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `sla_version` SET TAGS ('title_business_glossary_term' = 'Service Level Agreement (SLA) Version');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `sla_version` SET TAGS ('title_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `state_jurisdiction` SET TAGS ('title_business_glossary_term' = 'State Jurisdiction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `state_jurisdiction` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `superseded_by_sla_code` SET TAGS ('title_business_glossary_term' = 'Superseded By Service Level Agreement (SLA) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `superseded_by_sla_code` SET TAGS ('title_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `time_zone` SET TAGS ('title_business_glossary_term' = 'Time Zone');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `total_order_hours_target` SET TAGS ('title_business_glossary_term' = 'Total Order Turn-Time Target (Hours)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `trid_applicable` SET TAGS ('title_business_glossary_term' = 'TILA-RESPA Integrated Disclosure (TRID) Applicable Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `uw_referral_threshold_usd` SET TAGS ('title_business_glossary_term' = 'Underwriting (UW) Referral Threshold Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
