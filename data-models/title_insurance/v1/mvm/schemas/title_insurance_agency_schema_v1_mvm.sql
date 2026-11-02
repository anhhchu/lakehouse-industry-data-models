-- Schema for Domain: agency | Business: Title_Insurance | Version: v1_mvm
-- Generated on: 2026-10-31 06:39:29

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `serverless_stable_dvmvgw_catalog`.`ti_agency` COMMENT 'Owns the independent title-agent channel and distribution relationships: agent onboarding, licensing and E&O verification, agency-agreement and authority-level management, CPL issuance, ongoing oversight and compliance monitoring, premium remittance';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` (
    `agent_authority_id` BIGINT COMMENT 'Unique surrogate identifier for the effective-dated agent authority record. Primary key for the agent_authority product in the Agency Management and Remittance System.',
    `agency_agreement_id` BIGINT COMMENT 'Reference to the parent agency agreement under which this authority level is granted. Links authority record to the governing contractual relationship between agent and underwriter.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent party record. Identifies the licensed agent entity to whom this underwriting authority is granted.',
    `prior_authority_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding authority record that this record supersedes. Enables chain-of-authority history and lifecycle revision tracking per VREQ-007.',
    `agent_premium_split_pct` DECIMAL(5,4) COMMENT 'Contractual percentage of gross title insurance premium retained by the agent (the split) under this authority agreement. Expressed as a decimal (e.g., 0.7000 = 70%). Confidential commercial term.',
    `approval_date` DATE COMMENT 'Date on which the underwriter formally approved this authority grant. Distinct from effective_date — approval may precede the authoritys effective start date.',
    `approval_status` STRING COMMENT 'Underwriter approval workflow status for this authority grant. Distinct from authority_status — captures the internal approval lifecycle before the authority becomes active.. Valid values are `pending|approved|conditionally_approved|denied|withdrawn`',
    `approved_by` STRING COMMENT 'Name or identifier of the underwriter representative who approved this authority grant. Provides audit trail for authority approval decisions.',
    `authority_notes` STRING COMMENT 'Free-text field for underwriter-recorded conditions, restrictions, or special instructions associated with this authority grant not captured in structured fields.',
    `authority_number` STRING COMMENT 'Externally-known alphanumeric identifier assigned by the underwriter to this specific authority grant. Used in policy jackets, CPL issuance, and remittance reconciliation as the SSOT reference code.. Valid values are `^[A-Z0-9-]{4,30}$`',
    `authority_status` STRING COMMENT 'Current lifecycle state of this authority record. Controls whether the agent may issue policies under this authority grant. Drives compliance monitoring and oversight workflows.. Valid values are `active|suspended|terminated|pending|expired`',
    `authority_tier` STRING COMMENT 'Classification of the underwriting authority level granted to the agent. Determines the scope of transactions the agent may independently underwrite without referral.. Valid values are `standard|limited|expanded|commercial|restricted`',
    `channel_type` STRING COMMENT 'Distribution channel classification for this authority record. Distinguishes independent title agents from direct branch operations and centralized lender channel partners.. Valid values are `independent_agent|direct_branch|lender_channel`',
    `commercial_max_insured_amount` DECIMAL(18,2) COMMENT 'Maximum insured amount for commercial real estate transactions specifically. May differ from max_insured_amount which applies to residential. Null if commercial transactions are not authorized.',
    `county_fips_code` STRING COMMENT 'Five-digit FIPS county code further restricting the geographic scope of this authority to a specific county or set of counties. Null if authority applies statewide.. Valid values are `^[0-9]{5}$`',
    `cpl_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent is authorized to issue Closing Protection Letters (CPLs) under this authority grant. CPL issuance requires explicit underwriter authorization separate from policy issuance authority.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this authority record was first created in the Agency Management and Remittance System. Audit trail for record provenance per SOC 2 and ALTA Best Practices.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to the max_insured_amount and premium split thresholds. Typically USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date on which this authority grant becomes binding and the agent is authorized to issue policies under its terms. Start of the effective-dated authority period per VREQ-008.',
    `endorsement_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent is authorized to issue ALTA endorsements (e.g., ALTA 9, ALTA 8.1, ALTA 22) independently without underwriter countersignature under this authority grant.',
    `eo_coverage_amount` DECIMAL(18,2) COMMENT 'Dollar amount of E&O insurance coverage in force for the agent at the time this authority was granted. Must meet underwriter minimum requirements for the authority tier.',
    `eo_expiration_date` DATE COMMENT 'Expiration date of the agents E&O insurance policy. Monitoring this date against authority_status supports ongoing compliance oversight and lapse detection.',
    `eo_policy_number` STRING COMMENT 'Policy number of the agents Errors and Omissions (E&O) insurance policy verified at the time this authority was granted. Required by underwriters as a condition of agency appointment.',
    `escrow_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent is authorized to conduct escrow and settlement services (hold IOLTA/trust funds, disburse proceeds) under this authority grant.',
    `expiration_date` DATE COMMENT 'Date on which this authority grant expires and the agents authorization to issue policies under its terms ends. Null indicates an open-ended authority subject to agreement termination.',
    `gap_coverage_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent is authorized to provide gap coverage (GAP) — insuring the period between closing and recording — under this authority grant without underwriter countersignature.',
    `license_expiration_date` DATE COMMENT 'Expiration date of the agents state title insurance license. Authority cannot remain active beyond license expiration. Supports compliance monitoring and oversight workflows.',
    `license_number` STRING COMMENT 'State-issued title insurance agent or title company license number verified at the time this authority was granted. Required for regulatory compliance in the applicable state jurisdiction.',
    `max_insured_amount` DECIMAL(18,2) COMMENT 'Maximum single-transaction insured amount (in USD) the agent is authorized to underwrite independently under this authority tier without escalating to the underwriter for approval.',
    `oversight_review_date` DATE COMMENT 'Date of the most recent underwriter oversight review or audit of the agents compliance with this authority. Supports ongoing agency oversight and compliance monitoring workflows.',
    `oversight_review_result` STRING COMMENT 'Outcome of the most recent underwriter oversight review of the agent under this authority. Drives escalation, suspension, or remediation workflows per ALTA Best Practices Pillar 6.. Valid values are `satisfactory|conditional|unsatisfactory|pending|not_reviewed`',
    `policy_type_scope` STRING COMMENT 'Specifies whether the agent is authorized to issue owner title policies (OTP), lender title policies (LTP), or both under this authority grant. Aligns with VREQ-010 owner/lender policy distinction.. Valid values are `owner|lender|both`',
    `remittance_due_day` BIGINT COMMENT 'Day of the month (1–31) by which the agent must submit the remittance report and payment to the underwriter for the prior period. Used to calculate remittance timeliness and aging.',
    `remittance_frequency` STRING COMMENT 'Contractual frequency at which the agent must remit the underwriters premium share. Drives agency remittance-timeliness metrics per VREQ-016.. Valid values are `monthly|quarterly|semi_annual|annual|per_transaction`',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this authority record within the same agency agreement. Increments each time authority terms are amended. Supports lifecycle history per VREQ-007.',
    `revision_reason` STRING COMMENT 'Free-text explanation of why this authority record was created as a revision of the prior record (e.g., tier upgrade, max amount increase, geographic expansion, compliance correction).',
    `state_code` STRING COMMENT 'Two-letter US state code identifying the jurisdiction in which this authority is granted. Authority is state-specific due to state-level insurance licensing and regulatory requirements.. Valid values are `^[A-Z]{2}$`',
    `termination_date` DATE COMMENT 'Date on which this authority was explicitly terminated prior to its scheduled expiration. Populated only when authority is revoked or cancelled mid-term. Distinct from expiration_date per lifecycle preservation (VREQ-007).',
    `termination_reason` STRING COMMENT 'Reason code explaining why this authority was terminated before its scheduled expiration. Supports oversight reporting and regulatory compliance. [ENUM-REF-CANDIDATE: promote if reasons expand beyond 6]',
    `transaction_type_scope` STRING COMMENT 'Defines which transaction types the agent is authorized to handle under this authority. Restricts or expands the agents operational scope. [ENUM-REF-CANDIDATE: promote if transaction types expand]. Valid values are `residential_purchase|refinance|home_equity|construction|commercial|all`',
    `underwriter_code` BIGINT COMMENT 'Reference to the title underwriter (carrier) granting this authority. Identifies which underwriting company has authorized the agent to issue policies on its behalf.',
    `underwriter_premium_split_pct` DECIMAL(5,4) COMMENT 'Contractual percentage of gross title insurance premium remitted to the underwriter (the underwriters share of the split). Must sum to 1.0 with agent_premium_split_pct. Confidential commercial term.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this authority record was last modified in the Agency Management and Remittance System. Supports change detection and audit trail for lifecycle transitions per VREQ-007.',
    `uwref_threshold_amount` DECIMAL(18,2) COMMENT 'Transaction insured amount above which the agent must refer the transaction to the underwriter for approval before issuing a commitment or policy. Supports underwriting referral rate metrics per VREQ-016.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_agent_authority PRIMARY KEY(`agent_authority_id`)
) COMMENT 'Effective-dated authority record defining the specific underwriting authority level granted to an independent title agent under an agency agreement, including authority tier (standard, limited, expanded, commercial), maximum insured amount, transaction';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` (
    `agent_license_id` BIGINT COMMENT 'Unique surrogate identifier for each effective-dated agent license record in the agency management system.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the agent entity (individual producer or agency firm) that holds this license. Supports one agent holding multiple licenses across states.',
    `appointing_underwriter_code` BIGINT COMMENT 'Reference to the title underwriter entity that holds the active appointment for this license with the state DOI. An agent may be appointed by multiple underwriters.',
    `appointment_date` DATE COMMENT 'Date on which the appointing underwriter filed the agent appointment with the state DOI for this license. Required for authority validation.',
    `appointment_termination_date` DATE COMMENT 'Date on which the underwriter appointment for this license was terminated with the state DOI. Null if appointment is currently active.',
    `authority_hold_flag` BOOLEAN COMMENT 'Indicates whether this license is currently subject to an authority hold that prevents the agent from issuing commitments or policies under this license.',
    `authority_hold_reason` STRING COMMENT 'Free-text description of the reason an authority hold has been placed on this license (e.g., expired E&O, CE deficiency, DOI investigation). Null when no hold is active.',
    `background_check_date` DATE COMMENT 'Date on which the most recent background check was completed for the agent associated with this license. Drives re-screening schedule compliance.',
    `background_check_status` STRING COMMENT 'Status of the background check conducted on the agent in connection with this license. Required for ALTA Best Practices Pillar 3 onboarding compliance.. Valid values are `passed|failed|pending|waived`',
    `ce_compliance_status` STRING COMMENT 'Current CE compliance status for this licenses renewal cycle. Drives proactive outreach and authority hold workflows when deficient.. Valid values are `compliant|deficient|exempt|pending_verification`',
    `ce_credit_hours_completed` DECIMAL(5,2) COMMENT 'Number of continuing education credit hours completed by the agent toward the current renewal cycle requirement. Used for compliance gap monitoring.',
    `ce_credit_hours_required` DECIMAL(5,2) COMMENT 'Number of continuing education credit hours required by the state for renewal of this license in the current renewal cycle.',
    `continuing_education_required` BOOLEAN COMMENT 'Indicates whether the state requires continuing education (CE) credits for renewal of this license. Drives CE compliance tracking workflows.',
    `domicile_state_code` STRING COMMENT 'Two-letter USPS code for the agents home state of domicile. Used to distinguish resident from non-resident licenses and to apply reciprocity rules.. Valid values are `^[A-Z]{2}$`',
    `effective_date` DATE COMMENT 'Date on which this license record version becomes effective. Supports effective-dated history when a license is renewed, reinstated, or reclassified.',
    `eo_carrier_name` STRING COMMENT 'Name of the insurance carrier providing the E&O coverage associated with this agent license. Used for coverage verification and oversight.',
    `eo_coverage_amount` DECIMAL(18,2) COMMENT 'Dollar amount of E&O coverage in force for this agent license. Verified against minimum coverage thresholds required by the underwriter or state DOI.',
    `eo_expiration_date` DATE COMMENT 'Date on which the E&O insurance policy associated with this agent license expires. Triggers renewal verification workflow before expiration.',
    `eo_policy_number` STRING COMMENT 'Policy number of the Errors and Omissions (E&O) insurance policy covering this agent license. Required for ALTA Best Practices compliance verification.',
    `eo_verified_date` DATE COMMENT 'Date on which E&O coverage for this license was last verified by the agency oversight team. Supports ALTA Best Practices audit evidence.',
    `expiration_date` DATE COMMENT 'Date on which this license expires and must be renewed to remain in good standing. Used for proactive renewal tracking and authority suspension workflows.',
    `issue_date` DATE COMMENT 'Date on which the state DOI originally issued this license to the agent entity. Establishes the start of the licenses initial effective period.',
    `license_change_reason` STRING COMMENT 'Reason code describing why this license record version was created or updated. Preserves material lifecycle transitions per VREQ-007. [ENUM-REF-CANDIDATE: initial_issuance|renewal|reinstatement|class_change|suspension|revocation|correction — 7 candidates',
    `license_class` STRING COMMENT 'Classification of the license type as defined by the issuing state DOI. Distinguishes title agent, title producer, escrow agent, settlement agent, and notary signing agent authorizations.. Valid values are `title_agent|title_producer|title_insurer|escrow_agent|settlement_agent|notary_signing_agent`',
    `license_number` STRING COMMENT 'State-issued title insurance producer or agent license number as assigned by the state Department of Insurance. Primary external business identifier for this license record.',
    `license_revision_number` BIGINT COMMENT 'Sequential revision counter incremented each time this license record is updated (renewal, reinstatement, class change). Supports lifecycle history per VREQ-007.',
    `license_status` STRING COMMENT 'Current lifecycle status of the license as reported by the issuing state DOI. Drives agent authority eligibility checks and oversight workflows.. Valid values are `active|suspended|expired|revoked|pending|cancelled`',
    `license_type` STRING COMMENT 'Indicates whether the license is held by an individual producer, a business entity (agency firm), or a branch office. Drives onboarding and authority workflows.. Valid values are `individual|entity|branch`',
    `license_verification_source` STRING COMMENT 'Source used to verify the license status (e.g., NIPR national producer database, state DOI portal, manual review). Supports evidence provenance per VREQ-007.. Valid values are `nipr|state_doi_portal|manual|third_party`',
    `license_verified_date` DATE COMMENT 'Date on which the license status was last verified against the authoritative source (NIPR or state DOI). Drives re-verification scheduling.',
    `lines_of_authority` STRING COMMENT 'Comma-delimited list of insurance lines of authority granted under this license (e.g., Title, Escrow, Settlement). Sourced from state DOI appointment records.',
    `nipr_producer_number` STRING COMMENT 'NIPR-assigned national producer number (NPN) for the agent, used to cross-reference license records across states in the NAIC national database.',
    `prior_license_number` STRING COMMENT 'Previous state-issued license number superseded by this record, if applicable. Preserves chain-of-license history for lifecycle traceability per VREQ-007.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this agent license record was first created in the lakehouse silver layer. Supports audit trail and data lineage.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this agent license record was last modified in the lakehouse silver layer. Supports change detection and incremental processing.',
    `regulatory_action_description` STRING COMMENT 'Brief description of any active or historical regulatory action taken by the state DOI against this license. Null when no regulatory action exists.',
    `regulatory_action_flag` BOOLEAN COMMENT 'Indicates whether the state DOI has taken or initiated a regulatory action (investigation, consent order, fine) against this license. Triggers escalated oversight.',
    `reinstatement_date` DATE COMMENT 'Date on which a previously suspended or expired license was reinstated by the state DOI. Null if the license has never been reinstated.',
    `renewal_date` DATE COMMENT 'Date on which the license was most recently renewed by the state DOI. Null if the license has never been renewed since original issuance.',
    `resident_nonresident_flag` BOOLEAN COMMENT 'Indicates whether this is a resident license (agent domiciled in the issuing state) or a non-resident license (agent licensed in a state other than domicile).',
    `revocation_date` DATE COMMENT 'Date on which the state DOI permanently revoked this license. Null if not revoked. Preserved for lifecycle history and regulatory reporting.',
    `source_system_license_key` STRING COMMENT 'Natural key or record identifier for this license as stored in the Agency Management and Remittance System (e.g., SoftPro, RamQuest). Supports lineage and reconciliation.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the issuing jurisdiction (e.g., TX, CA, FL). Human-readable complement to state_fips_code for reporting and display.. Valid values are `^[A-Z]{2}$`',
    `state_fips_code` STRING COMMENT 'Two-digit FIPS code identifying the U.S. state or territory that issued this license. Used for jurisdiction-level compliance reporting and authority scoping.. Valid values are `^[0-9]{2}$`',
    `suspension_date` DATE COMMENT 'Date on which the state DOI suspended this license, if applicable. Null when license is not suspended. Supports lifecycle history per VREQ-007.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_agent_license PRIMARY KEY(`agent_license_id`)
) COMMENT 'Effective-dated record of each state-issued title insurance producer or agent license held by an agent entity, including license number, state FIPS code, license class, issue date, expiration date, renewal date, and current status (active, suspended';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` (
    `agent_profile_id` BIGINT COMMENT 'Unique surrogate identifier for the agent profile record. Primary key for the agent_profile entity in the agency domain.',
    `agency_agreement_number` STRING COMMENT 'Unique identifier of the executed agency agreement between the independent title agent and the underwriter. Links to the agreement document in the Document Management System.',
    `agent_code` STRING COMMENT 'Unique alphanumeric code assigned by the underwriter to identify the agent in the Agency Management and Remittance System. Used on remittance reports, policy registers, and premium splits.. Valid values are `^[A-Z0-9]{4,20}$`',
    `agent_premium_split_pct` DECIMAL(5,4) COMMENT 'Contractual percentage of collected title insurance premium retained by the agent per the agency agreement. The remainder is remitted to the underwriter. Expressed as a decimal (e.g., 0.8000 = 80%).',
    `agent_status` STRING COMMENT 'Current lifecycle status of the agent appointment with the underwriter. Controls whether the agent may issue commitments, policies, and CPLs. Drives oversight and compliance monitoring.. Valid values are `active|suspended|terminated|pending_approval|probation`',
    `agent_type` STRING COMMENT 'Legal entity structure of the agent (individual, corporation, LLC, partnership, or government entity). Determines tax reporting obligations, E&O requirements, and agency agreement terms.. Valid values are `individual|corporation|llc|partnership|government`',
    `alta_best_practices_certified` BOOLEAN COMMENT 'Indicates whether the agent has obtained a current ALTA Best Practices certification from an approved third-party assessor. Required by many lender clients and underwriters for active status.',
    `alta_certification_date` DATE COMMENT 'Date the agent most recently received ALTA Best Practices certification. Used to track certification currency and trigger recertification workflows.',
    `alta_certification_expiration_date` DATE COMMENT 'Expiration date of the agents current ALTA Best Practices certification. Triggers recertification alerts and may affect agent authority level if expired.',
    `appointment_effective_date` DATE COMMENT 'Date the underwriter appointment became effective, authorizing the agent to issue title commitments and policies on behalf of the underwriter. Distinct from onboarding date.',
    `appointment_expiration_date` DATE COMMENT 'Date the current underwriter appointment expires or is scheduled for renewal. Null for perpetual appointments. Used to trigger renewal workflows and compliance alerts.',
    `authority_level` STRING COMMENT 'Underwriter-assigned authority level controlling the types and amounts of title commitments, policies, and CPLs the agent may issue without referral. Drives underwriting workflow routing.. Valid values are `standard|enhanced|restricted|cpl_only`',
    `channel_type` STRING COMMENT 'Classifies the agent as an independent title agent (ITA), direct branch, centralized lender channel partner, or commercial channel. Drives routing, remittance, and oversight rules.. Valid values are `independent_agent|direct_branch|lender_channel|commercial_channel`',
    `cpl_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent is authorized to issue Closing Protection Letters (CPLs) on behalf of the underwriter. CPL authority is separately granted and tracked per ALTA CPL standards.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the agent profile record was first created in the Agency Management and Remittance System. Supports audit trail and record provenance per VREQ-007.',
    `dba_name` STRING COMMENT 'Trade or assumed name under which the agent operates, if different from the legal entity name. Required for marketing materials, closing documents, and consumer-facing disclosures.',
    `eo_carrier_name` STRING COMMENT 'Name of the insurance carrier providing the agents Errors and Omissions (E&O) professional liability coverage. Required by ALTA Best Practices and underwriter agency agreements.',
    `eo_coverage_amount` DECIMAL(18,2) COMMENT 'Maximum coverage limit of the agents E&O policy in USD. Underwriter verifies this meets minimum thresholds per agency agreement and ALTA Best Practices Pillar 3 requirements.',
    `eo_expiration_date` DATE COMMENT 'Expiration date of the agents current E&O insurance policy. Triggers compliance alerts when approaching expiration. Agent authority may be suspended if E&O lapses.',
    `eo_policy_number` STRING COMMENT 'Policy number of the agents current E&O professional liability insurance policy. Required for underwriter oversight and ALTA Best Practices compliance verification.',
    `escrow_account_verified_date` DATE COMMENT 'Most recent date the underwriter verified the agents escrow/trust account compliance per ALTA Best Practices Pillar 2. Used for ongoing oversight and audit scheduling.',
    `fidelity_bond_amount` DECIMAL(18,2) COMMENT 'Coverage amount of the agents fidelity bond or employee dishonesty insurance in USD. Required by many underwriters and state regulations to protect against employee theft of escrow funds.',
    `fidelity_bond_expiration_date` DATE COMMENT 'Expiration date of the agents fidelity bond or employee dishonesty coverage. Used to trigger renewal alerts and compliance monitoring.',
    `fips_county_code` STRING COMMENT 'Five-digit FIPS county code for the county in which the agents primary office is located. Used for geographic segmentation, county-level reporting, and plant access authorization.. Valid values are `^[0-9]{5}$`',
    `iolta_account_flag` BOOLEAN COMMENT 'Indicates whether the agent maintains a separate IOLTA or escrow trust account as required by ALTA Best Practices Pillar 2 and applicable state bar or insurance regulations.',
    `last_audit_date` DATE COMMENT 'Date of the most recent underwriter compliance audit or examination of the agent. Used to schedule next audit and track oversight cadence per ALTA Best Practices and agency agreement.',
    `last_audit_result` STRING COMMENT 'Outcome of the most recent underwriter compliance audit. Drives agent status changes, remediation workflows, and authority level adjustments.. Valid values are `satisfactory|conditional|unsatisfactory|pending_review`',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the agent profile record was most recently modified. Supports change tracking, audit trail, and lifecycle history preservation per VREQ-007.',
    `legal_entity_name` STRING COMMENT 'Full legal name of the independent title agent, direct branch, or lender-channel partner as registered with the state and underwriter. Used for licensing, remittance, and policy issuance.',
    `max_policy_liability_amount` DECIMAL(18,2) COMMENT 'Maximum single-transaction policy liability amount in USD the agent is authorized to issue without underwriter referral. Transactions exceeding this threshold require Underwriting Referral (UWR).',
    `naic_company_code` STRING COMMENT 'Five-digit NAIC company code assigned to the agent entity for regulatory reporting and state filing purposes. Required for NAIC annual statement submissions.. Valid values are `^[0-9]{5}$`',
    `office_address_line1` STRING COMMENT 'Street address line 1 of the agents primary office location. Used for regulatory filings, policy documents, and consumer-facing disclosures.',
    `office_address_line2` STRING COMMENT 'Street address line 2 (suite, unit, floor) of the agents primary office location. Supplemental to office_address_line1 for complete mailing address.',
    `office_city` STRING COMMENT 'City of the agents primary office location. Used for geographic segmentation, regulatory filings, and market analysis.',
    `office_state` STRING COMMENT 'Two-letter USPS state abbreviation for the agents primary office location. Determines applicable state insurance regulations, rate filings, and remittance rules.. Valid values are `^[A-Z]{2}$`',
    `office_zip_code` STRING COMMENT 'ZIP or ZIP+4 postal code of the agents primary office location. Used for geographic analysis, regulatory filings, and market segmentation.. Valid values are `^[0-9]{5}(-[0-9]{4})?$`',
    `onboarding_date` DATE COMMENT 'Date the agent completed onboarding and was approved to conduct business under the agency agreement. Marks the start of the agent relationship for remittance timeliness and oversight tracking.',
    `operating_states` STRING COMMENT 'Comma-delimited list of two-letter state abbreviations where the agent is licensed and authorized to conduct title insurance business. Drives multi-state authority and compliance monitoring.',
    `primary_contact_email` STRING COMMENT 'Business email address of the primary contact at the agent office. Used for underwriter communications, remittance notices, compliance alerts, and CPL issuance notifications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Full name of the primary business contact at the agent office responsible for underwriter communications, remittance, and compliance matters.',
    `primary_contact_phone` STRING COMMENT 'Business phone number of the primary contact at the agent office. Used for underwriter communications and compliance outreach.. Valid values are `^+?[0-9-s().]{7,20}$`',
    `primary_license_expiration_date` DATE COMMENT 'Expiration date of the agents primary state title insurance license. Used to trigger renewal alerts and suspend authority if license lapses.',
    `primary_license_state` STRING COMMENT 'Two-letter USPS state abbreviation for the state in which the agent holds their primary title insurance license. Governs applicable regulatory requirements and remittance rules.. Valid values are `^[A-Z]{2}$`',
    `primary_state_license_number` STRING COMMENT 'State-issued title insurance producer or agency license number for the agents primary state of operation. Required for appointment filings and regulatory compliance verification.',
    `remittance_due_day` BIGINT COMMENT 'Day of the month (1-31) by which the agent must submit premium remittance to the underwriter per the agency agreement. Used to calculate remittance timeliness metrics.',
    `remittance_schedule_type` STRING COMMENT 'Frequency at which the agent is required to remit collected title insurance premiums to the underwriter. Drives remittance timeliness monitoring and agency settlement processing.. Valid values are `monthly|quarterly|semi_annual|annual|per_transaction`',
    `tax_id_reference` STRING COMMENT 'Tokenized reference to the agents Federal Tax Identification Number (TIN/EIN) stored in the Identity and NPPI Vault. Used for IRS 1099 reporting and premium remittance reconciliation. Raw TIN not stored here.',
    `termination_date` DATE COMMENT 'Date the agency relationship was formally terminated. Null for active agents. Required for lifecycle history preservation per VREQ-007 and regulatory reporting.',
    `termination_reason` STRING COMMENT 'Reason code for the termination of the agency relationship. Required for regulatory reporting to state departments of insurance and underwriter risk management.',
    `underwriter_split_pct` DECIMAL(5,4) COMMENT 'Contractual percentage of collected title insurance premium remitted to the underwriter per the agency agreement. Should sum to 1.0000 with agent_premium_split_pct.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_agent_profile PRIMARY KEY(`agent_profile_id`)
) COMMENT 'Master record and SSOT for every independent title agent (ITA), direct branch, and lender-channel partner in the distribution network. Captures agent identity, legal entity name, DBA, NAIC code, state license numbers, E&O carrier/policy references';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` (
    `agreement_id` BIGINT COMMENT 'Unique surrogate identifier for the agency agreement record in the title insurance system of record.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent or direct-branch party that is a signatory to this agency agreement.',
    `party_id` BIGINT COMMENT 'Reference to the title underwriter (e.g., FNF, FAF, STC, ORI) that is the issuing underwriter party to this agency agreement.',
    `prior_agreement_id` BIGINT COMMENT 'Reference to the predecessor agency agreement record that this agreement supersedes or renews. Null for initial agreements. Preserves chain-of-agreement history per VREQ-007.',
    `agent_premium_split_pct` DECIMAL(5,4) COMMENT 'Contractual percentage of gross title premium retained by the agent (e.g., 0.8000 = 80%). The underwriter retains the remainder. Drives remittance calculation.',
    `aggregate_liability_limit` DECIMAL(18,2) COMMENT 'Maximum aggregate insured liability (in USD) the agent may carry in a rolling 12-month period before mandatory underwriter review. Supports risk-exposure monitoring.',
    `agreement_status` STRING COMMENT 'Current lifecycle state of the agency agreement. Controls whether the agent may issue commitments and policies under this agreement. [ENUM-REF-CANDIDATE: draft|active|suspended|terminated|expired|pending_renewal — promote to reference product]. Valid values are `draft|active|suspended|terminated|expired|pending_renewal`',
    `agreement_type` STRING COMMENT 'Classification of the agency relationship: independent agent, direct branch, centralized lender channel, or affiliated agency. Drives authority and remittance rules.. Valid values are `independent_agent|direct_branch|lender_channel|affiliated_agency`',
    `amendment_count` BIGINT COMMENT 'Running count of formal amendments executed against this agency agreement. Supports lifecycle revision tracking per VREQ-007.',
    `audit_frequency` STRING COMMENT 'Contractual frequency at which the underwriter is entitled to conduct an agency audit of the agents books, records, and escrow accounts under this agreement.. Valid values are `annual|biennial|triennial|as_needed`',
    `authority_level` STRING COMMENT 'Scope of underwriting authority granted to the agent: full authority to issue all products, limited to specific transaction types, conditional on referral, or suspended.. Valid values are `full|limited|conditional|suspended`',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the agency agreement automatically renews at expiration unless either party provides notice of non-renewal within the notice period.',
    `channel_type` STRING COMMENT 'Distribution channel classification for this agreement: direct branch, independent agent, or centralized lender channel. Aligns with order-routing and premium-reporting segmentation.. Valid values are `direct_branch|independent_agent|lender_channel`',
    `commercial_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent is authorized to handle commercial real-estate transactions under this agreement. False restricts agent to residential transactions only.',
    `cpl_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent is authorized to issue Closing Protection Letters (CPLs) under this agreement. True = CPL authority granted.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this agency agreement record was first created in the Agency Management and Remittance System. Audit trail for record provenance.',
    `current_version_number` STRING COMMENT 'Version identifier of the current executed agreement document (e.g., 1.0, 2.3). Incremented with each amendment. Supports revision history per VREQ-007.. Valid values are `^[0-9]+.[0-9]+$`',
    `document_reference_code` STRING COMMENT 'Identifier of the executed agreement document in the Document Management and Imaging System. Enables retrieval of the signed agreement for audit and legal review.',
    `effective_date` DATE COMMENT 'Date on which the agency agreement becomes legally binding and the agent is authorized to issue title products. Distinct from execution date per VREQ-008.',
    `endorsement_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent is authorized to issue ALTA endorsements (e.g., ALTA 9, ALTA 8.1, ALTA 22) without underwriter pre-approval under this agreement.',
    `eo_carrier_name` STRING COMMENT 'Name of the insurance carrier providing the agents E&O coverage. Used for underwriter oversight and ALTA Best Practices Pillar 3 audit.',
    `eo_coverage_amount` DECIMAL(18,2) COMMENT 'Minimum required E&O coverage amount (in USD) as stipulated in the agency agreement. Verified at onboarding and each renewal cycle.',
    `eo_expiration_date` DATE COMMENT 'Expiration date of the agents current E&O insurance policy. Agreement may be suspended if E&O lapses. Drives compliance-monitoring alerts.',
    `eo_policy_number` STRING COMMENT 'Policy number of the agents Errors and Omissions (E&O) insurance policy required under the agency agreement. Supports ALTA Best Practices Pillar 3 compliance verification.',
    `escrow_authority_flag` BOOLEAN COMMENT 'Indicates whether the agent is authorized to conduct escrow closings and hold trust funds under this agreement. Drives IOLTA compliance monitoring.',
    `execution_date` DATE COMMENT 'Date on which all parties physically or electronically signed the agency agreement. Distinct from effective date per VREQ-008.',
    `expiration_date` DATE COMMENT 'Date on which the agency agreement is scheduled to expire unless renewed. Null for perpetual agreements. Used for renewal-pipeline and compliance-monitoring metrics.',
    `fidelity_bond_amount` DECIMAL(18,2) COMMENT 'Face amount (in USD) of the fidelity/surety bond held by the agent. Null if no bond is required under this agreement.',
    `fidelity_bond_expiration_date` DATE COMMENT 'Expiration date of the agents fidelity bond. Null if no bond is required. Monitored alongside E&O expiration for compliance continuity.',
    `fidelity_bond_number` STRING COMMENT 'Bond number of the agents fidelity/surety bond if required by the underwriter or state regulator as a condition of the agency agreement.',
    `geographic_territory` STRING COMMENT 'Description or code of the geographic territory (state(s), county FIPS codes, or MSA) within which the agent is authorized to issue title products under this agreement.',
    `governing_law_state` STRING COMMENT 'Two-letter US state code identifying the state whose laws govern interpretation and enforcement of this agency agreement.. Valid values are `^[A-Z]{2}$`',
    `last_audit_date` DATE COMMENT 'Date of the most recently completed underwriter audit of this agent under this agreement. Used to calculate days-since-last-audit for oversight metrics.',
    `max_liability_amount` DECIMAL(18,2) COMMENT 'Maximum insured amount (in USD) the agent is authorized to issue on a single title policy without underwriter referral. Enforces per-transaction authority ceiling.',
    `next_audit_due_date` DATE COMMENT 'Scheduled or calculated due date for the next underwriter audit of this agent. Derived from last_audit_date and audit_frequency but stored for operational scheduling.',
    `notes` STRING COMMENT 'Free-text field for underwriter or compliance officer notes regarding special conditions, waivers, or observations associated with this agency agreement.',
    `notice_period_days` BIGINT COMMENT 'Number of calendar days of written notice required by either party to terminate the agency agreement without cause, as specified in the agreement terms.',
    `number` STRING COMMENT 'Externally-known unique alphanumeric identifier assigned to this agency agreement by the underwriter, used in remittance and compliance correspondence.. Valid values are `^AGT-[0-9]{4}-[A-Z0-9]{6,12}$`',
    `oversight_risk_tier` STRING COMMENT 'Underwriter-assigned risk tier for this agent based on volume, compliance history, and audit findings. Drives audit frequency and enhanced monitoring requirements.. Valid values are `low|medium|high|critical`',
    `remittance_due_days` BIGINT COMMENT 'Number of calendar days after the close of the remittance period within which the agent must submit the remittance report and payment to the underwriter.',
    `remittance_frequency` STRING COMMENT 'Contractual frequency at which the agent must remit the underwriters share of collected premiums. Drives remittance-timeliness metric and agency settlement schedule.. Valid values are `monthly|quarterly|semi_annual|annual|per_transaction`',
    `renewal_date` DATE COMMENT 'Date on which the agency agreement was most recently renewed. Null if never renewed. Supports renewal-cycle tracking and remittance-timeliness metrics.',
    `state_codes` STRING COMMENT 'Comma-separated list of two-letter US state codes in which the agent is licensed and authorized to issue title products under this agreement (e.g., TX,OK,NM).. Valid values are `^([A-Z]{2})(,[A-Z]{2})*$`',
    `termination_date` DATE COMMENT 'Actual date on which the agency agreement was terminated prior to or at expiration. Null if agreement is still active or expired naturally.',
    `termination_reason` STRING COMMENT 'Reason code for agreement termination. Supports agency oversight reporting and regulatory compliance. [ENUM-REF-CANDIDATE: voluntary|non_renewal|compliance_violation|underwriter_action|license_lapse|eo_lapse|mutual_consent — promote to reference product]',
    `transaction_types_authorized` STRING COMMENT 'Comma-separated list of transaction types the agent may handle: purchase, refinance, HELOC, construction, commercial. Null means all types permitted per authority_level.',
    `underwriter_premium_split_pct` DECIMAL(5,4) COMMENT 'Contractual percentage of gross title premium remitted to the underwriter (e.g., 0.2000 = 20%). Must sum to 1.0 with agent_premium_split_pct.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this agency agreement record was most recently modified. Used for change-data-capture and incremental lakehouse ingestion.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_agreement PRIMARY KEY(`agreement_id`)
) COMMENT 'Formal agency agreement between the title underwriter and an independent title agent or direct branch, governing the scope of authority, geographic territory, transaction types, premium split schedule, remittance terms, and compliance obligations.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` (
    `eo_coverage_id` BIGINT COMMENT 'Unique surrogate identifier for an E&O insurance coverage record associated with an independent title agent. Primary key for this entity.',
    `agency_agreement_id` BIGINT COMMENT 'Reference to the agency agreement under which this E&O coverage requirement applies. Links the coverage record to the specific contractual authority relationship between agent and underwriter.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent entity for whom this E&O coverage record is maintained. Links coverage to the agent profile in the Agency Management System.',
    `additional_insured_flag` BOOLEAN COMMENT 'Indicates whether the underwriter or title company is listed as an additional insured on the agents E&O policy. Some underwriter agency agreements require additional insured status.',
    `aggregate_limit` DECIMAL(18,2) COMMENT 'Maximum total dollar amount the E&O policy will pay across all covered claims during the policy period. Used to assess overall coverage adequacy relative to agent transaction volume.',
    `cancellation_date` DATE COMMENT 'Date on which the E&O policy was cancelled by the carrier or agent, if applicable. Null for active or expired policies. Triggers immediate agent authority review and potential suspension.',
    `cancellation_reason` STRING COMMENT 'Reason code for policy cancellation when coverage_status is cancelled. Used to assess whether cancellation was voluntary or involuntary and to inform agent risk classification.. Valid values are `non_payment|underwriter_request|agent_request|carrier_withdrawal|other`',
    `carrier_naic_code` STRING COMMENT 'Five-digit NAIC company code assigned to the E&O carrier. Enables regulatory lookup of carrier licensing, financial ratings, and admitted status by state.. Valid values are `^[0-9]{5}$`',
    `carrier_name` STRING COMMENT 'Legal name of the insurance carrier underwriting the E&O policy. Used to assess carrier financial strength and validate coverage acceptability per underwriter requirements.',
    `certificate_holder_name` STRING COMMENT 'Name of the certificate holder listed on the E&O certificate of insurance, typically the underwriter or title company requiring proof of coverage from the independent agent.',
    `certificate_number` STRING COMMENT 'Number from the ACORD certificate of insurance or equivalent document provided as evidence of E&O coverage. Used to cross-reference the physical or electronic certificate on file.',
    `coverage_gap_days` BIGINT COMMENT 'Number of calendar days of lapsed E&O coverage between the prior policy expiration and the current policy effective date. Zero or null when no gap exists. Used for risk scoring.',
    `coverage_gap_flag` BOOLEAN COMMENT 'Indicates whether a gap in continuous E&O coverage exists between the prior policy expiration and the current policy effective date. A gap may expose the agent and underwriter to uninsured risk.',
    `coverage_status` STRING COMMENT 'Current lifecycle status of the E&O coverage record. Drives agent authority eligibility; an agent with non-active status may be suspended from issuing commitments or policies.. Valid values are `active|expired|cancelled|pending_renewal|lapsed|suspended`',
    `coverage_type` STRING COMMENT 'Indicates whether the E&O policy is written on a claims-made, occurrence, or claims-made-and-reported basis. Affects how claims are triggered and reported under the policy.. Valid values are `claims_made|occurrence|claims_made_reported`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this E&O coverage record was first created in the Agency Management and Remittance System. Supports audit trail and record provenance per VREQ-007.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary limit and deductible amounts on this E&O coverage record. Typically USD for domestic title agents.. Valid values are `^[A-Z]{3}$`',
    `days_until_expiration` BIGINT COMMENT 'Number of calendar days remaining until the E&O policy expires, calculated from the current date. Used for aging and expiration-risk dashboards in agency oversight reporting.',
    `deductible_amount` DECIMAL(18,2) COMMENT 'Dollar amount the agent is responsible for paying per claim before E&O coverage applies. Relevant to underwriter risk assessment and agent financial responsibility evaluation.',
    `document_reference_code` STRING COMMENT 'Identifier referencing the stored certificate of insurance or policy document in the Document Management and Imaging System. Enables retrieval of the source evidence for audit purposes.',
    `effective_date` DATE COMMENT 'Date on which the E&O policy coverage begins. Used to determine whether coverage was in force at the time of a specific title transaction or claim event.',
    `expiration_date` DATE COMMENT 'Date on which the E&O policy coverage expires. Triggers renewal workflow and agent authority suspension if not renewed prior to expiration.',
    `extended_reporting_end_date` DATE COMMENT 'End date of the extended reporting period (tail coverage) if applicable. Null when no ERP endorsement is in effect. Used to determine whether late-reported claims remain eligible.',
    `extended_reporting_period_flag` BOOLEAN COMMENT 'Indicates whether an extended reporting period (tail coverage) endorsement is in effect, allowing claims to be reported after policy expiration for acts occurring during the policy period.',
    `meets_minimum_requirements` BOOLEAN COMMENT 'Computed flag indicating whether the current E&O coverage meets all underwriter-mandated minimum requirements for per-occurrence limit, aggregate limit, and policy status. Drives authority eligibility.',
    `minimum_required_aggregate` DECIMAL(18,2) COMMENT 'Underwriter-mandated minimum aggregate coverage limit required for this agents authority level. Used to flag coverage deficiency when actual aggregate limit falls below threshold.',
    `minimum_required_per_occurrence` DECIMAL(18,2) COMMENT 'Underwriter-mandated minimum per-occurrence coverage limit required for this agents authority level. Used to flag coverage deficiency when actual per-occurrence limit falls below threshold.',
    `named_insured` STRING COMMENT 'Legal name of the entity or individual listed as the named insured on the E&O policy. Must match the agent entity name on file to confirm coverage applies to the correct party.',
    `notes` STRING COMMENT 'Free-text field for agency oversight staff to record observations, exceptions, or follow-up actions related to this E&O coverage record. Not used for structured data.',
    `per_occurrence_limit` DECIMAL(18,2) COMMENT 'Maximum dollar amount the E&O policy will pay for a single covered claim or occurrence. Compared against underwriter minimum coverage thresholds for agent authority approval.',
    `policy_number` STRING COMMENT 'The carrier-assigned policy number for the E&O insurance policy. Used as the primary external business identifier for the coverage record and referenced during agent oversight audits.',
    `prior_policy_number` STRING COMMENT 'Policy number of the immediately preceding E&O policy for this agent. Supports chain-of-coverage analysis and retroactive date continuity verification for claims-made policies.',
    `renewal_reminder_date` DATE COMMENT 'Date on which the renewal reminder notification was sent to the agent. Null if no reminder has been sent. Used to track compliance outreach timing relative to expiration date.',
    `renewal_reminder_sent_flag` BOOLEAN COMMENT 'Indicates whether a renewal reminder notification has been sent to the agent prior to policy expiration. Supports proactive compliance management and prevents inadvertent coverage lapses.',
    `retroactive_date` DATE COMMENT 'For claims-made policies, the earliest date from which covered acts or omissions are eligible for coverage. Critical for determining whether prior title work is covered under the current policy.',
    `source_record_code` STRING COMMENT 'Native identifier of this E&O coverage record in the originating source system. Used for reconciliation between the lakehouse Silver layer and the upstream Agency Management System.',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this E&O coverage record originated, such as the Agency Management and Remittance System or CRM. Supports data lineage tracking.. Valid values are `agency_mgmt|crm|manual_entry`',
    `state_code` STRING COMMENT 'Two-letter USPS state code for the state in which the E&O policy is primarily applicable or where the agent is licensed. Some states impose minimum E&O requirements by regulation.. Valid values are `^[A-Z]{2}$`',
    `state_minimum_required_flag` BOOLEAN COMMENT 'Indicates whether the state in which the agent operates mandates a minimum E&O coverage level by regulation. Used to distinguish regulatory minimums from underwriter contractual minimums.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this E&O coverage record was most recently modified. Used to detect stale records and to sequence updates during incremental data loads to the Silver layer.',
    `verification_date` DATE COMMENT 'Date on which the E&O coverage was most recently verified as active and compliant by the agency oversight team. Used to track verification currency and schedule re-verification.',
    `verification_method` STRING COMMENT 'Method used to verify the E&O coverage, such as review of a certificate of insurance, direct carrier confirmation, or third-party database lookup. Affects verification reliability scoring.. Valid values are `certificate_of_insurance|carrier_confirmation|agent_self_report|third_party_database`',
    `verification_status` STRING COMMENT 'Status of the internal verification process confirming the E&O policy is valid, in force, and meets underwriter minimum requirements. Drives agent onboarding and ongoing compliance workflows.. Valid values are `verified|unverified|pending|failed|waived`',
    `verified_by` STRING COMMENT 'Name or identifier of the staff member or automated process that performed the most recent E&O coverage verification. Supports audit trail for agency compliance oversight.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_eo_coverage PRIMARY KEY(`eo_coverage_id`)
) COMMENT 'Errors and Omissions (E&O) insurance coverage record for an independent title agent, capturing carrier name, policy number, coverage effective date, expiration date, per-occurrence limit, aggregate limit, deductible, and verification status.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` (
    `premium_split_schedule_id` BIGINT COMMENT 'Unique surrogate identifier for a premium split schedule record defining contractual agent/underwriter split rates for an agency agreement.',
    `agency_agreement_id` BIGINT COMMENT 'Reference to the agency agreement under which this premium split schedule is defined. Links the split schedule to the governing contractual relationship.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent or agency entity to which this split schedule applies. Supports agent-level remittance and oversight reporting.',
    `party_id` BIGINT COMMENT 'Reference to the title underwriter (e.g., FNF, FAF, STC, ORI) that is the counterparty to the agent in this split arrangement.',
    `superseded_by_schedule_premium_split_schedule_id` BIGINT COMMENT 'Reference to the newer premium_split_schedule record that replaced this one. Null if this is the current active schedule. Preserves revision history per VREQ-007.',
    `agent_split_rate` DECIMAL(7,6) COMMENT 'Contractual proportion of gross premium retained by the independent title agent, expressed as a decimal (e.g., 0.800000 = 80%). Core metric for remittance-timeliness analysis.',
    `approval_date` DATE COMMENT 'Date on which this split schedule received final internal approval. Distinct from effective_date; a schedule may be approved before it becomes effective.',
    `approval_status` STRING COMMENT 'Internal workflow approval status of this split schedule before it becomes operative. Tracks underwriting and compliance sign-off on negotiated split terms.. Valid values are `draft|pending_approval|approved|rejected`',
    `approved_by` STRING COMMENT 'Name or identifier of the underwriter authority or compliance officer who approved this split schedule. Supports audit trail and SOX controls.',
    `channel_type` STRING COMMENT 'Distribution channel to which this split schedule applies: independent agent, direct branch, or centralized lender channel. Supports channel-level remittance analytics.. Valid values are `independent_agent|direct_branch|lender_channel`',
    `cpl_fee_split_rate` DECIMAL(7,6) COMMENT 'Agents contractual split rate applied to Closing Protection Letter (CPL) fees collected. Distinct from policy premium split rates.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this premium split schedule record was first created in the data platform. Supports audit trail and record provenance.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this schedule. Typically USD for US domestic title operations.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date on which this premium split schedule becomes contractually binding and applicable to new policy transactions. Supports effective-dated rate lookup.',
    `endorsement_split_rate` DECIMAL(7,6) COMMENT 'Agents contractual split rate applied specifically to ALTA endorsement premiums (e.g., ALTA 9, ALTA 8.1, ALTA 22). May differ from base policy split rate.',
    `expiration_date` DATE COMMENT 'Date on which this premium split schedule ceases to apply. Null indicates an open-ended schedule with no defined end date.',
    `is_tiered_schedule` BOOLEAN COMMENT 'Indicates whether this schedule is one tier within a multi-tier split structure. True when premium_floor_amount and premium_ceiling_amount define a band.',
    `minimum_agent_remittance_amount` DECIMAL(15,2) COMMENT 'Minimum dollar amount the agent must remit to the underwriter per remittance cycle, regardless of split calculation. Null if no minimum applies.',
    `notes` STRING COMMENT 'Free-text operational notes or special conditions associated with this split schedule, such as volume incentive clauses or underwriter-specific exceptions.',
    `policy_type` STRING COMMENT 'Indicates whether this split schedule applies to the Owners Title Policy (OTP), Lenders Title Policy (LTP), or both. Owner and lender policies carry distinct split rates per VREQ-010.. Valid values are `owner|lender|both`',
    `premium_ceiling_amount` DECIMAL(15,2) COMMENT 'Maximum gross premium threshold above which this split schedule no longer applies. Null indicates no upper bound. Supports tiered split structures.',
    `premium_floor_amount` DECIMAL(15,2) COMMENT 'Minimum gross premium threshold below which this split schedule applies. Supports tiered split structures where rates change at premium breakpoints.',
    `property_type_scope` STRING COMMENT 'Indicates whether this split schedule applies to residential, commercial, or both property types. Commercial transactions may carry different negotiated split rates.. Valid values are `residential|commercial|both`',
    `rate_source` STRING COMMENT 'Indicates whether the split rates are derived from state-filed rates, individually negotiated contract terms, or a statutory minimum/maximum rate schedule.. Valid values are `filed_rate|negotiated_rate|statutory_rate`',
    `reissue_credit_applies` BOOLEAN COMMENT 'Indicates whether reissue/refinance credit discounts are factored into the premium base before applying the split rates under this schedule.',
    `remittance_due_days` BIGINT COMMENT 'Number of calendar days after the close of the remittance period by which the agent must submit payment to the underwriter. Used for timeliness monitoring.',
    `remittance_frequency` STRING COMMENT 'Contractual frequency at which the agent must remit the underwriters share of collected premiums. Drives remittance-timeliness metric calculations.. Valid values are `monthly|quarterly|semi_annual|annual|per_policy`',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this split schedule within the agency agreement. Version 1 is the original; increments with each amendment. Supports lifecycle history per VREQ-007.',
    `revision_reason` STRING COMMENT 'Free-text explanation for why this split schedule was created or amended (e.g., state rate filing change, contract renegotiation, regulatory directive).',
    `schedule_name` STRING COMMENT 'Human-readable name or label for this split schedule (e.g., Residential Standard 80/20 — TX 2024). Aids identification in the agency management system.',
    `schedule_number` STRING COMMENT 'Externally-known alphanumeric identifier for this split schedule, as referenced in the agency agreement and remittance system. Used for audit and reconciliation.',
    `schedule_status` STRING COMMENT 'Current lifecycle status of the split schedule. superseded indicates a newer schedule has replaced this one; terminated indicates the agreement ended.. Valid values are `active|pending|superseded|terminated|suspended`',
    `simultaneous_issue_rate_applies` BOOLEAN COMMENT 'Indicates whether the simultaneous issue (owner + lender issued together) discounted premium rate applies as the basis for split calculation under this schedule.',
    `source_record_code` STRING COMMENT 'Native primary key or record identifier from the originating source system. Enables lineage tracing and reconciliation back to the agency management system.',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this split schedule record was sourced (e.g., agency management and remittance system identifier).',
    `split_basis` STRING COMMENT 'Defines the premium base on which the split rates are applied: gross collected premium, net premium after deductions, or the state-filed statutory rate.. Valid values are `gross_premium|net_premium|statutory_rate`',
    `state_code` STRING COMMENT 'Two-letter US state postal code identifying the jurisdiction in which this split schedule applies. Split rates are state-regulated and vary by state.. Valid values are `^[A-Z]{2}$`',
    `supersedes_schedule_id` BIGINT COMMENT 'Reference to the prior premium_split_schedule record that this schedule replaced. Null if this is the original schedule. Supports chain-of-revision traceability.',
    `termination_date` DATE COMMENT 'Date on which this split schedule was formally terminated, if applicable. Distinct from expiration_date; termination may occur before the scheduled expiry.',
    `termination_reason` STRING COMMENT 'Reason for early termination of this split schedule (e.g., agency agreement cancelled, agent license revoked, underwriter withdrawal from state).',
    `tier_sequence` BIGINT COMMENT 'Ordinal position of this tier within a tiered split schedule (1 = lowest premium band). Null for non-tiered schedules. Used to apply the correct rate band.',
    `transaction_type` STRING COMMENT 'Category of real estate transaction to which this split rate applies (e.g., residential purchase, REFI, HELOC, construction, commercial). Rates may differ by transaction type.. Valid values are `purchase|refinance|heloc|construction|commercial|other`',
    `underwriter_split_rate` DECIMAL(7,6) COMMENT 'Contractual proportion of gross premium remitted to the underwriter, expressed as a decimal (e.g., 0.200000 = 20%). Must sum to 1.0 with agent_split_rate.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this premium split schedule record. Used for change detection and incremental data loading in the Silver layer.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_premium_split_schedule PRIMARY KEY(`premium_split_schedule_id`)
) COMMENT 'Reference (non-transactional) schedule defining contractual agent/underwriter premium split rates for an agency agreement, segmented by transaction type (residential purchase, refinance, HELOC, commercial), policy type (owner OTP vs lender LTP), state';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` (
    `cpl_issuance_id` BIGINT COMMENT 'Unique surrogate identifier for a Closing Protection Letter (CPL) issuance record in the agency management system.',
    `agency_agreement_id` BIGINT COMMENT 'Reference to the agency agreement under which the independent agent is authorized to conduct closings covered by this CPL.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent on whose behalf the CPL is issued by the underwriter, as registered in the agency management system.',
    `cpl_insured_lender_party_id` BIGINT COMMENT 'Reference to the lender or institutional party named as the insured on this CPL, typically the mortgage lender funding the transaction.',
    `cpl_party_id` BIGINT COMMENT 'Reference to the title underwriter entity (e.g., FNF, FAF, STC, ORI) that issued and is liable under this CPL.',
    `insured_ownership_interest_id` BIGINT COMMENT 'Foreign key linking to property.ownership_interest. Business justification: CPL is issued at closing when ownership interest transfers. Links CPL to the specific ownership interest being insured (buyers new interest or lenders lien).',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: CPL documents must reference the legal description that defines the insured property. Legal description is the authoritative definition of what the CPL covers.',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: CPL (Closing Protection Letter) is issued for a specific property parcel. Currently cpl_issuance has denormalized property address fields but no FK to the authoritative property.parcel.',
    `superseded_by_cpl_cpl_issuance_id` BIGINT COMMENT 'Self-referencing identifier pointing to the replacement CPL issuance record when this CPL has been superseded by a revised or corrected version.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order for which this CPL was issued, linking the CPL to the underlying transaction in the title production system.',
    `actual_closing_date` DATE COMMENT 'Date on which the real estate closing actually occurred under this CPL. Null if closing has not yet taken place.',
    `agent_license_number` STRING COMMENT 'State-issued title insurance agent license number for the independent agent at time of CPL issuance, confirming active licensure.',
    `agent_name` STRING COMMENT 'Legal business name of the independent title agent on whose behalf the CPL is issued, as it appears on the CPL document.',
    `agent_state_code` STRING COMMENT 'Two-letter USPS state code for the state in which the agent is licensed and appointed to issue this CPL.. Valid values are `^[A-Z]{2}$`',
    `cancellation_date` DATE COMMENT 'Date on which the CPL was cancelled prior to expiration, if applicable. Null when the CPL was not cancelled.',
    `cancellation_reason` STRING COMMENT 'Reason code explaining why the CPL was cancelled. [ENUM-REF-CANDIDATE: transaction_cancelled|policy_issued|superseded|agent_request|underwriter_request|other — promote to reference product]. Valid values are `transaction_cancelled|policy_issued|superseded|agent_request|underwriter_request|other`',
    `claim_made_indicator` BOOLEAN COMMENT 'Indicates whether a claim has been made against this CPL by the insured lender, triggering claims administration workflow.',
    `closing_location` STRING COMMENT 'Address or description of the location where the closing is scheduled to occur, as referenced in the CPL.',
    `closing_officer_name` STRING COMMENT 'Name of the closing or escrow officer at the agent office who will conduct the closing covered by this CPL.',
    `cpl_fee_amount` DECIMAL(18,2) COMMENT 'Fee charged for issuance of this CPL, as filed with the applicable state Department of Insurance. May be zero in states where CPLs are issued at no charge.',
    `cpl_fee_collected` BOOLEAN COMMENT 'Indicates whether the CPL issuance fee has been collected from the insured lender or applicable party at time of issuance.',
    `cpl_form_version` STRING COMMENT 'Version identifier of the ALTA CPL form used for this issuance (e.g., ALTA 2016 CPL Form), ensuring regulatory and form-version traceability.',
    `cpl_number` STRING COMMENT 'Externally-known alphanumeric identifier assigned to this CPL by the underwriter or agency management system, used for tracking and reference across parties.',
    `cpl_status` STRING COMMENT 'Current lifecycle status of the CPL issuance record: draft, issued, cancelled, expired, or superseded by a revised CPL.. Valid values are `draft|issued|cancelled|expired|superseded`',
    `cpl_type` STRING COMMENT 'Classifies the CPL by the party protected: lender, buyer, seller, or combined lender and buyer, per ALTA CPL form options.. Valid values are `lender|buyer|seller|lender_and_buyer`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time at which this CPL issuance record was first created in the system, used for audit trail and record provenance.',
    `delivery_confirmation_ref` STRING COMMENT 'Confirmation number, email message ID, or portal acknowledgment reference confirming successful delivery of the CPL to the insured lender.',
    `delivery_method` STRING COMMENT 'Method by which the CPL was delivered to the insured lender: email, fax, mail, lender portal, or electronic transmission.. Valid values are `email|fax|mail|portal|electronic`',
    `delivery_timestamp` TIMESTAMP COMMENT 'Date and time at which the CPL was transmitted or delivered to the insured lender, used for timeliness tracking and audit.',
    `document_image_ref` STRING COMMENT 'Reference key or URI to the signed CPL document image stored in the document management and imaging system for evidence and provenance.',
    `effective_date` DATE COMMENT 'Date on which CPL coverage becomes effective, which may differ from the issue date. Governs the start of underwriter liability under the letter.',
    `eo_coverage_verified` BOOLEAN COMMENT 'Indicates whether the agents Errors and Omissions (E&O) insurance coverage was verified as active and sufficient at the time of CPL issuance.',
    `eo_policy_number` STRING COMMENT 'E&O insurance policy number for the independent agent at time of CPL issuance, confirming required coverage per ALTA Best Practices Pillar 3.',
    `expiration_date` DATE COMMENT 'Date on which the CPL coverage expires if the closing has not occurred. Null indicates the CPL remains open until cancelled or superseded.',
    `insured_lender_address` STRING COMMENT 'Full mailing address of the insured lender as stated on the CPL, used for delivery and regulatory record-keeping.',
    `insured_lender_name` STRING COMMENT 'Full legal name of the lender or institutional party named as the insured on the CPL, as it appears on the issued CPL document.',
    `issue_date` DATE COMMENT 'Calendar date on which the CPL was formally issued by the underwriter, representing the principal business event date for this record.',
    `loan_amount` DECIMAL(18,2) COMMENT 'Dollar amount of the mortgage loan associated with this CPL, used to establish the scope of underwriter liability. Denominated in USD.',
    `prior_cpl_id` BIGINT COMMENT 'Reference to the prior CPL issuance record that this record supersedes, preserving the revision chain for lifecycle history per VREQ-007.',
    `purchase_price` DECIMAL(18,2) COMMENT 'Contract purchase price of the subject property for purchase transactions, as stated on the CPL or associated sales contract. Null for refinance transactions.',
    `revision_number` BIGINT COMMENT 'Sequential integer tracking the revision version of this CPL within the same transaction, starting at 1 for the original issuance.',
    `scheduled_closing_date` DATE COMMENT 'Anticipated date of the real estate closing for which this CPL provides protection, used for expiration and pipeline management.',
    `source_system_ref` STRING COMMENT 'Identifier of the originating record in the agency management or title production system (e.g., SoftPro, RamQuest) for lineage and reconciliation.',
    `state_specific_form_indicator` BOOLEAN COMMENT 'Indicates whether a state-mandated or state-approved CPL form was used instead of the standard ALTA form, as required by certain state Departments of Insurance.',
    `transaction_type` STRING COMMENT 'Classification of the underlying real estate transaction type for which the CPL is issued: purchase, refinance, HELOC, construction, commercial, or home equity.. Valid values are `purchase|refinance|heloc|construction|commercial|home_equity`',
    `underwriter_name` STRING COMMENT 'Legal name of the title underwriter issuing the CPL (e.g., Fidelity National Title, Stewart Title Guaranty), as it appears on the CPL document.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time at which this CPL issuance record was most recently modified, supporting change tracking and audit compliance.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_cpl_issuance PRIMARY KEY(`cpl_issuance_id`)
) COMMENT 'Closing Protection Letter (CPL) issuance record representing a specific CPL issued by the underwriter on behalf of an independent title agent for a given transaction or lender.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` (
    `oversight_review_id` BIGINT COMMENT 'Unique surrogate identifier for the oversight review record. Primary key for the agency compliance and performance review entity.',
    `agency_agreement_id` BIGINT COMMENT 'Reference to the agency agreement under which the agent operates, providing contractual context for the review scope and authority.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent or agency entity that is the subject of this oversight review.',
    `prior_review_oversight_review_id` BIGINT COMMENT 'Reference to the immediately preceding oversight review record for this agent, enabling review history chain and trend analysis.',
    `title_order_id` BIGINT COMMENT 'Foreign key linking to operations.title_order. Business justification: Oversight reviews sample specific order files to audit agent compliance, title examination quality, escrow handling, and closing procedures.',
    `authority_action_taken` STRING COMMENT 'Regulatory or contractual action taken against the agents authority as a result of this review: none, warning, restriction, suspension, termination, or DOI referral.. Valid values are `none|warning_issued|authority_restricted|authority_suspended|authority_terminated|referred_to_doi`',
    `completion_date` DATE COMMENT 'Date on which all review activities, including agent response and finding resolution, were finalized and the review was closed.',
    `corrective_action_due_date` DATE COMMENT 'Deadline by which the agent must submit or complete the corrective action plan in response to findings from this review.',
    `corrective_action_received_date` DATE COMMENT 'Date on which the agents corrective action plan or response was received by the underwriter oversight team.',
    `corrective_action_required_flag` BOOLEAN COMMENT 'Indicates whether the review findings require the agent to submit a formal corrective action plan (CAP) to address identified deficiencies.',
    `corrective_action_status` STRING COMMENT 'Current status of the corrective action plan: not_required, pending, received, accepted, rejected, or overdue. Tracks remediation lifecycle.. Valid values are `not_required|pending|received|accepted|rejected|overdue`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this oversight review record was first created in the agency management system. Supports audit trail and record provenance.',
    `critical_finding_flag` BOOLEAN COMMENT 'Indicates whether the review identified at least one critical finding requiring immediate escalation, remediation, or potential authority suspension.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to monetary amounts in this review record. Typically USD for domestic US title operations.. Valid values are `^[A-Z]{3}$`',
    `document_reference_code` BIGINT COMMENT 'Reference to the document management system record containing the formal review report, supporting evidence, and agent correspondence.',
    `eo_coverage_status` STRING COMMENT 'Status of the agents E&O coverage as determined during this review: current, expiring_soon, expired, below_minimum, or not_verified.. Valid values are `current|expiring_soon|expired|below_minimum|not_verified`',
    `eo_verified_flag` BOOLEAN COMMENT 'Indicates whether the agents E&O insurance coverage was verified as current and meeting minimum requirements during this review.',
    `escrow_audit_flag` BOOLEAN COMMENT 'Indicates whether this review included an examination of the agents escrow/trust account records for compliance with IOLTA and state trust accounting rules.',
    `escrow_compliance_status` STRING COMMENT 'Outcome of the escrow/trust account audit component: compliant, shortfall, overage, reconciliation_gap, or not_audited if escrow was not in scope.. Valid values are `compliant|shortfall|overage|reconciliation_gap|not_audited`',
    `files_sampled_count` BIGINT COMMENT 'Number of title order files or transaction records selected for review during a random file review or annual audit. Supports sampling methodology documentation.',
    `files_with_findings_count` BIGINT COMMENT 'Number of sampled files in which one or more compliance findings or deficiencies were identified. Used to compute deficiency rate.',
    `finding_categories` STRING COMMENT 'Comma-separated list of finding category codes identified (e.g., remittance_late, eo_lapsed, escrow_shortfall, licensing_gap, file_deficiency). Supports trend analysis.',
    `findings_summary` STRING COMMENT 'Narrative summary of key findings identified during the review, including deficiencies, exceptions, and areas of non-compliance observed.',
    `license_compliance_status` STRING COMMENT 'Licensing compliance determination from this review: compliant, deficient (missing states), expired, suspended, or not_verified.. Valid values are `compliant|deficient|expired|suspended|not_verified`',
    `license_verified_flag` BOOLEAN COMMENT 'Indicates whether the agents title insurance license(s) were verified as active and in good standing in all applicable states during this review.',
    `next_review_due_date` DATE COMMENT 'Scheduled due date for the next oversight review of this agent, determined by risk tier, audit frequency in the agency agreement, and findings from this review.',
    `overall_rating` STRING COMMENT 'Composite compliance and performance rating assigned at the conclusion of the review: satisfactory, needs_improvement, unsatisfactory, or critical.. Valid values are `satisfactory|needs_improvement|unsatisfactory|critical`',
    `period_end_date` DATE COMMENT 'End date of the business activity period under review. Together with period_start_date defines the audit window.',
    `period_start_date` DATE COMMENT 'Start date of the business activity period under review (e.g., the remittance period, file production period, or licensing period being audited).',
    `regulatory_referral_date` DATE COMMENT 'Date on which the regulatory referral was submitted to the state DOI or other authority. Populated only when regulatory_referral_flag is true.',
    `regulatory_referral_flag` BOOLEAN COMMENT 'Indicates whether findings from this review were referred to a state Department of Insurance or other regulatory body for further action.',
    `remittance_audit_flag` BOOLEAN COMMENT 'Indicates whether this review included an audit of the agents premium remittance records and timeliness against the agency agreement schedule.',
    `remittance_compliance_status` STRING COMMENT 'Outcome of the remittance audit component: compliant, late_remittances, underpayment, overpayment, or not_audited if remittance was not in scope.. Valid values are `compliant|late_remittances|underpayment|overpayment|not_audited`',
    `remittance_variance_amount` DECIMAL(18,2) COMMENT 'Dollar amount of identified remittance discrepancy (underpayment or overpayment) discovered during the remittance audit component of this review.',
    `review_date` DATE COMMENT 'The date on which the oversight review was conducted or initiated. Principal business event date for scheduling, aging, and timeliness metrics.',
    `review_method` STRING COMMENT 'Method by which the oversight review was conducted: on_site (at agent office), remote (virtual/electronic), desk_review (document submission only), or hybrid.. Valid values are `on_site|remote|desk_review|hybrid`',
    `review_notes` STRING COMMENT 'Free-text notes recorded by the reviewer capturing context, agent responses, mitigating circumstances, or follow-up actions not captured in structured fields.',
    `review_number` STRING COMMENT 'Externally visible, human-readable identifier assigned to this oversight review. Used in correspondence, audit trails, and regulatory submissions.. Valid values are `^OVR-[0-9]{4}-[0-9]{6}$`',
    `review_scope` STRING COMMENT 'Narrative description of the scope of the review, including which files, periods, processes, or compliance areas were examined.',
    `review_status` STRING COMMENT 'Current lifecycle state of the oversight review: scheduled, in_progress, pending_response (awaiting agent reply), completed, cancelled, or escalated to underwriter compliance.. Valid values are `scheduled|in_progress|pending_response|completed|cancelled|escalated`',
    `review_type` STRING COMMENT 'Classification of the review: annual audit, random file review, E&O verification, licensing check, remittance audit, or for-cause review. [ENUM-REF-CANDIDATE. Valid values are `annual_audit|random_file_review|eo_verification|licensing_check|remittance_audit|for_cause_review`',
    `reviewer_department` STRING COMMENT 'Organizational department or unit responsible for conducting the review (e.g., Agency Compliance, Underwriting Oversight, Internal Audit).',
    `reviewer_employee_code` STRING COMMENT 'Internal employee identifier of the reviewer conducting the oversight review. Links to HR/identity systems for access control and audit.',
    `reviewer_name` STRING COMMENT 'Full name of the underwriter compliance officer, auditor, or oversight analyst who conducted the review. Supports accountability and audit trail.',
    `risk_tier_after` STRING COMMENT 'Agent oversight risk tier classification assigned as a result of this review. Compared to risk_tier_before to track risk migration.. Valid values are `low|moderate|elevated|high|critical`',
    `risk_tier_before` STRING COMMENT 'Agent oversight risk tier classification assigned prior to this review. Used to measure risk tier migration resulting from review findings.. Valid values are `low|moderate|elevated|high|critical`',
    `scheduled_date` DATE COMMENT 'The originally planned date for the oversight review. Compared against review_date to measure scheduling adherence and overdue reviews.',
    `state_code` STRING COMMENT 'Two-letter US state code identifying the primary state jurisdiction under which this oversight review was conducted and findings apply.. Valid values are `^[A-Z]{2}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this oversight review record. Used for change detection, incremental ETL, and audit trail.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_oversight_review PRIMARY KEY(`oversight_review_id`)
) COMMENT 'Periodic compliance and performance oversight review record for an independent title agent, capturing review type (annual audit, random file review, E&O verification, licensing check, remittance audit), review date, reviewer identity, findings summary';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` (
    `agent_remittance_id` BIGINT COMMENT 'Unique surrogate identifier for the agent remittance header record. Primary key for the agency settlement cycle transaction.',
    `agency_agreement_id` BIGINT COMMENT 'Reference to the governing agency agreement under which this remittance is processed, establishing the contractual basis for the premium split.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent entity submitting or receiving this remittance. Links to the agent profile master record.',
    `premium_split_schedule_id` BIGINT COMMENT 'Reference to the premium split schedule that governs agent and underwriter share calculations applied to this remittance period.',
    `prior_remittance_agent_remittance_id` BIGINT COMMENT 'Reference to the previous remittance record that this corrected or supplemental remittance supersedes. Supports lifecycle revision history per VREQ-007.',
    `acceptance_date` DATE COMMENT 'Date the underwriter formally accepted and validated the remittance submission. Distinct from submission_date per VREQ-008 date separation requirements.',
    `agent_retained_amount` DECIMAL(18,2) COMMENT 'Dollar amount of gross premium retained by the agent per the applicable premium split schedule. Equals gross premium multiplied by the agent split rate.',
    `amount_received` DECIMAL(18,2) COMMENT 'Actual dollar amount received by the underwriter from the agent for this remittance. May differ from net_remittance_amount if partial payment or overpayment occurred.',
    `channel_type` STRING COMMENT 'Distribution channel through which the business was produced: independent agent, direct branch, or centralized lender channel. Supports channel-level remittance analytics.. Valid values are `independent_agent|direct_branch|lender_channel`',
    `cpl_fee_amount` DECIMAL(18,2) COMMENT 'Total Closing Protection Letter (CPL) fees collected by the agent during the remittance period, subject to the CPL fee split rate in the premium split schedule.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this remittance record was first created in the agency management system. Supports audit trail and record provenance per VREQ-007.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this remittance record. Typically USD for domestic US title insurance transactions.. Valid values are `^[A-Z]{3}$`',
    `days_past_due` BIGINT COMMENT 'Number of calendar days the remittance submission or payment is past the contractual due_date. Used for agency remittance timeliness metrics per VREQ-016.',
    `due_date` DATE COMMENT 'Contractual deadline by which the agent must submit and fund this remittance per the agency agreement remittance schedule terms.',
    `endorsement_premium_amount` DECIMAL(18,2) COMMENT 'Total premium collected for ALTA endorsements (e.g., ALTA 9, ALTA 8.1, ALTA 22) issued during the remittance period, reported separately from base policy premium.',
    `exception_flag` BOOLEAN COMMENT 'Indicates this remittance has been flagged for manual review due to variance, missing policies, late submission, or other discrepancy requiring underwriter investigation.',
    `exception_reason` STRING COMMENT 'Free-text or coded description of the reason this remittance was flagged as an exception, such as variance, missing policy detail, or suspected fraud indicator.',
    `gl_batch_reference` STRING COMMENT 'Reference to the ERP/GL batch or journal entry number created when this remittance was posted to the general ledger for premium revenue recognition.',
    `gross_premium_amount` DECIMAL(18,2) COMMENT 'Total gross title insurance premium collected by the agent for all policies in the remittance period before any splits, credits, or adjustments are applied.',
    `is_late` BOOLEAN COMMENT 'Indicates whether this remittance was submitted or funded after the contractual due date. True when submission_date or settlement_date exceeds due_date.',
    `late_fee_amount` DECIMAL(18,2) COMMENT 'Contractual late fee assessed against the agent for failure to remit by the due date, per the agency agreement penalty terms.',
    `ltp_count` BIGINT COMMENT 'Number of Lenders Title Policies (LTP) included in this remittance period. Supports owner-versus-lender policy coverage analytics per VREQ-016.',
    `net_remittance_amount` DECIMAL(18,2) COMMENT 'Final net amount due to the underwriter after applying all credits, adjustments, and split calculations. This is the amount the agent must fund to settle the remittance.',
    `notes` STRING COMMENT 'Free-text operational notes entered by the underwriter or agency oversight team regarding this remittance, such as dispute details, follow-up actions, or audit observations.',
    `otp_count` BIGINT COMMENT 'Number of Owners Title Policies (OTP) included in this remittance period. Supports owner-versus-lender policy coverage analytics per VREQ-016.',
    `payment_method` STRING COMMENT 'Method by which the agent funded the remittance to the underwriter (e.g., wire transfer, ACH, check). Relevant for reconciliation and fraud controls.. Valid values are `wire|ach|check|offset|electronic_funds_transfer`',
    `payment_reference` STRING COMMENT 'Bank or payment system reference number (wire confirmation, ACH trace number, check number) associated with the funds transfer for this remittance settlement.',
    `period_end_date` DATE COMMENT 'Last calendar date of the remittance reporting period. Defines the inclusive end of the policy issuance window covered by this remittance batch.',
    `period_start_date` DATE COMMENT 'First calendar date of the remittance reporting period. Defines the inclusive start of the policy issuance window covered by this remittance batch.',
    `policy_count` BIGINT COMMENT 'Total number of title insurance policies (owner and lender combined) included in this remittance period. Used for frequency and volume analytics.',
    `reconciliation_date` DATE COMMENT 'Date on which the remittance was fully reconciled against the underwriters policy registry and general ledger. Null if reconciliation is not yet complete.',
    `reconciliation_status` STRING COMMENT 'Current reconciliation state of the remittance against the underwriters policy registry and GL. Drives escrow receipt-disbursement reconciliation metrics per VREQ-016.. Valid values are `unreconciled|in_progress|reconciled|disputed`',
    `reissue_credit_amount` DECIMAL(18,2) COMMENT 'Total reissue credit adjustments applied to the gross premium in this remittance period, reducing the remittable premium where prior policies qualify for reissue rates.',
    `remittance_frequency` STRING COMMENT 'Contractual frequency at which the agent is required to submit remittances per the agency agreement. Drives due-date calculation and timeliness monitoring.. Valid values are `weekly|biweekly|monthly|quarterly|annual`',
    `remittance_number` STRING COMMENT 'Externally visible, human-readable identifier assigned to this remittance batch by the agency management system. Used for reconciliation and audit trail.. Valid values are `^REM-[A-Z0-9]{4,20}$`',
    `remittance_status` STRING COMMENT 'Current lifecycle state of the remittance record. Drives workflow routing and aging metrics for agency remittance timeliness reporting. [ENUM-REF-CANDIDATE: draft|submitted|under_review|accepted|rejected|settled|voided — promote to reference product]',
    `remittance_type` STRING COMMENT 'Classification of the remittance submission: periodic (scheduled cycle), supplemental (out-of-cycle), corrected (amendment to prior), final (contract close-out), or advance.. Valid values are `periodic|supplemental|corrected|final|advance`',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for corrected or amended remittance submissions. Version 1 is the original; increments with each correction per lifecycle history requirements.',
    `revision_reason` STRING COMMENT 'Business justification for a corrected or amended remittance submission, such as policy count correction, premium recalculation, or split rate adjustment.',
    `settlement_date` DATE COMMENT 'Date on which funds were actually transferred and the remittance was financially settled between the agent and the underwriter.',
    `simultaneous_issue_credit_amount` DECIMAL(18,2) COMMENT 'Total simultaneous issue rate credits applied when owner and lender policies are issued concurrently, reducing the combined premium in this remittance period.',
    `state_code` STRING COMMENT 'Two-letter USPS state code identifying the primary state jurisdiction for this remittance. Determines applicable state DOI remittance rules and rate filings.. Valid values are `^[A-Z]{2}$`',
    `submission_date` DATE COMMENT 'Calendar date on which the agent formally submitted this remittance to the underwriter. Used to calculate remittance timeliness against contractual due dates.',
    `transaction_type_scope` STRING COMMENT 'Primary real estate transaction type(s) covered by this remittance period (e.g., purchase, refinance, HELOC). Supports transaction-mix analytics and rate-filing compliance.. Valid values are `purchase|refinance|heloc|construction|commercial|home_equity`',
    `underwriter_code` BIGINT COMMENT 'Reference to the title underwriter entity receiving the remittance. Supports multi-underwriter agency relationships and underwriter-level remittance analytics.',
    `underwriter_due_amount` DECIMAL(18,2) COMMENT 'Dollar amount of gross premium owed to the underwriter per the premium split schedule. Equals gross premium minus agent retained amount before adjustments.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent modification to this remittance record. Used for change detection, audit, and incremental data pipeline processing.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Difference between net_remittance_amount and amount_received. Positive value indicates underpayment; negative indicates overpayment. Drives exception and follow-up workflows.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_agent_remittance PRIMARY KEY(`agent_remittance_id`)
) COMMENT 'Transactional header record for a periodic premium remittance submitted by (or billed to) an independent title agent to the underwriter, representing the agency-settlement cycle.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` (
    `remittance_line_id` BIGINT COMMENT 'Unique surrogate identifier for a single remittance line record within an agent premium remittance batch. Primary key for the remittance_line entity.',
    `agency_agreement_id` BIGINT COMMENT 'Reference to the agency agreement under which this remittance line is processed. Establishes the contractual authority for the agent/underwriter relationship.',
    `agent_profile_id` BIGINT COMMENT 'Reference to the independent title agent submitting this remittance line. Supports agent-level remittance timeliness and split reconciliation reporting.',
    `agent_remittance_id` BIGINT COMMENT 'Foreign key reference to the parent agent_remittance header record. Links this line to the remittance batch submitted by the independent agent to the underwriter.',
    `parcel_id` BIGINT COMMENT 'Foreign key linking to property.parcel. Business justification: Remittance lines report premium on policies covering specific parcels. Parcel is the fundamental unit of title insurance; linking enables premium reconciliation by jurisdiction',
    `premium_split_schedule_id` BIGINT COMMENT 'Reference to the premium_split_schedule governing the agent/underwriter split rates applied to this line. Ensures split calculation is traceable to the approved schedule.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Remittance lines track premium by property transaction. Essential for reconciling premium to title orders, analyzing revenue by property type/transaction type, detecting duplicate',
    `title_order_id` BIGINT COMMENT 'Reference to the title order associated with this remittance line. Enables traceability from premium remittance back to the originating title order.',
    `title_policy_id` BIGINT COMMENT 'Reference to the issued title policy (owner or lender) for which premium is being remitted. Core link for policy-level remittance reconciliation.',
    `accepted_date` DATE COMMENT 'Date the underwriter formally accepted this remittance line as correct and complete. Marks the completion of the remittance reconciliation lifecycle for this line. Distinct from submission date.',
    `adjustment_amount` DECIMAL(18,2) COMMENT 'Dollar amount of any post-submission adjustment applied to this remittance line (e.g., correction for rate error, credit memo, or dispute resolution). Negative values indicate credits.',
    `adjustment_reason` STRING COMMENT 'Reason code for any adjustment applied to this remittance line. Required when adjustment_amount is non-zero. Supports audit trail and dispute resolution workflows.. Valid values are `rate_correction|credit_memo|dispute_resolution|cancellation|reissue_correction|other`',
    `agent_premium_share` DECIMAL(18,2) COMMENT 'Computed dollar amount retained by the agent: net_premium_amount multiplied by agent_split_rate. Represents the agents earned commission on this policy line.',
    `agent_split_rate` DECIMAL(7,6) COMMENT 'Decimal rate representing the agents share of net premium per the applicable premium_split_schedule (e.g., 0.800000 = 80%). Captured at line level for audit and dispute resolution.',
    `channel_type` STRING COMMENT 'Distribution channel through which the underlying title order and policy were originated. Supports channel-level remittance analytics and split schedule applicability validation.. Valid values are `direct_branch|centralized_lender|independent_agent`',
    `closing_date` DATE COMMENT 'Date the real estate transaction closed. Anchors the remittance timeliness calculation; remittance due date is typically computed relative to closing date per the agency agreement.',
    `county_fips_code` STRING COMMENT 'Five-digit Federal Information Processing Standards (FIPS) county code for the property location. Supports county-level remittance analysis and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `cpl_fee_amount` DECIMAL(18,2) COMMENT 'Fee charged for the Closing Protection Letter (CPL) associated with this transaction, if applicable. Subject to its own split rate per the premium_split_schedule.',
    `cpl_underwriter_share` DECIMAL(18,2) COMMENT 'Underwriters share of the CPL fee computed using the CPL fee split rate from the premium_split_schedule. Included in total underwriter remittance for this line.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this line. Defaults to USD for domestic US title transactions. Required for multi-currency compliance.. Valid values are `^[A-Z]{3}$`',
    `days_past_due` BIGINT COMMENT 'Number of calendar days between remittance_due_date and remittance_submitted_date. Positive values indicate late remittance; zero or negative indicates on-time or early submission.',
    `endorsement_premium_amount` DECIMAL(18,2) COMMENT 'Total premium charged for all ALTA endorsements attached to this policy (e.g., ALTA 9, ALTA 8.1, ALTA 22). Tracked separately from base policy premium for endorsement revenue analysis.',
    `endorsement_underwriter_share` DECIMAL(18,2) COMMENT 'Underwriters share of endorsement premium computed using the endorsement split rate from the premium_split_schedule. Included in total underwriter remittance for this line.',
    `gl_account_code` STRING COMMENT 'General ledger account code to which the underwriter premium share for this line is posted in the ERP/GL system. Supports premium revenue recognition and financial reconciliation.',
    `gross_premium_amount` DECIMAL(18,2) COMMENT 'Total gross title insurance premium charged to the insured for this policy before any reissue credit, simultaneous issue discount, or split allocation. Basis for split calculation.',
    `insured_amount` DECIMAL(18,2) COMMENT 'The face amount of insurance coverage provided by this policy (purchase price for OTP, loan amount for LTP). Used to validate premium calculation against filed rate tables.',
    `is_late_remittance` BOOLEAN COMMENT 'Indicates whether this remittance line was submitted after the contractual remittance due date. True when remittance_submitted_date exceeds remittance_due_date. Drives timeliness compliance reporting.',
    `is_reissue_credit_applied` BOOLEAN COMMENT 'Indicates whether a reissue credit was applied to reduce the gross premium on this line. When true, reissue_credit_amount must be populated and greater than zero.',
    `is_simultaneous_issue` BOOLEAN COMMENT 'Indicates whether this policy line is part of a simultaneous owner/lender policy issuance on the same transaction. Affects premium calculation and split schedule applicability.',
    `line_sequence` BIGINT COMMENT 'Sequential line number within the parent remittance batch, starting at 1. Used for ordering, display, and reconciliation of individual policy lines within a remittance.',
    `line_status` STRING COMMENT 'Current processing status of this remittance line. Drives reconciliation workflow: pending=awaiting underwriter acceptance; accepted=confirmed; rejected=disputed; adjusted=corrected; reversed=backed out; voided=cancelled.. Valid values are `pending|accepted|rejected|adjusted|reversed|voided`',
    `net_premium_amount` DECIMAL(18,2) COMMENT 'Net title insurance premium after deducting reissue credit and simultaneous issue credit from gross premium. This is the base amount to which the agent/underwriter split rates are applied.',
    `notes` STRING COMMENT 'Free-text notes or comments entered by the agent or underwriter regarding this remittance line. Used for exception documentation, dispute context, or manual override explanations.',
    `policy_effective_date` DATE COMMENT 'Date the title policy became effective (typically the closing/recording date). Used to determine the applicable rate filing period and remittance due date calculation.',
    `policy_issue_date` DATE COMMENT 'Date the title policy was formally issued by the agent. Distinct from effective date; used to measure policy issuance lag and remittance timeliness from issuance.',
    `policy_number` STRING COMMENT 'The externally-known title policy number (e.g., OTP or LTP policy number) for which premium is being remitted. Denormalized for reconciliation without requiring a policy join.',
    `policy_type` STRING COMMENT 'Type of title insurance policy or coverage instrument being remitted. OTP (Owners Title Policy), LTP (Lenders Title Policy), CPL (Closing Protection Letter), or endorsement premium.. Valid values are `owner|lender|cpl|endorsement`',
    `prior_policy_number` STRING COMMENT 'Policy number of the prior title policy used as the basis for a reissue credit calculation. Required when is_reissue_credit_applied is true for audit and rate compliance verification.',
    `rate_filing_reference` STRING COMMENT 'Reference to the state-filed rate schedule used to calculate the gross premium for this line (e.g., state filing number or rate manual version). Supports regulatory audit and rate compliance.',
    `reissue_credit_amount` DECIMAL(18,2) COMMENT 'Dollar amount of reissue credit applied to reduce the gross premium when a prior policy exists on the same property. Reduces the net premium base subject to split.',
    `rejection_reason` STRING COMMENT 'Reason provided by the underwriter when this remittance line is rejected or disputed (e.g., incorrect split rate, missing policy number, rate calculation error). Populated when line_status is rejected.',
    `remittance_due_date` DATE COMMENT 'Date by which the underwriter share for this line must be remitted per the agency agreement remittance schedule. Key date for remittance timeliness metric calculation.',
    `remittance_submitted_date` DATE COMMENT 'Actual date this remittance line was submitted to the underwriter as part of the agent remittance batch. Used to compute days-late for remittance timeliness reporting.',
    `simultaneous_issue_credit_amount` DECIMAL(18,2) COMMENT 'Dollar credit applied when owner and lender policies are issued simultaneously on the same transaction. Reduces the lesser policy premium per ALTA simultaneous issue rate rules.',
    `source_system_line_ref` STRING COMMENT 'Native line identifier from the Agency Management and Remittance System (e.g., SoftPro, RamQuest) that originated this remittance line. Enables traceability back to the system of record.',
    `split_basis` STRING COMMENT 'Basis on which the agent/underwriter premium split is calculated for this line: net_premium (after credits), gross_premium (before credits), or flat_fee. Sourced from the premium_split_schedule.. Valid values are `net_premium|gross_premium|flat_fee`',
    `state_code` STRING COMMENT 'Two-letter US state code for the property jurisdiction where the policy was issued. Determines applicable state rate filing, split schedule, and regulatory remittance requirements.. Valid values are `^[A-Z]{2}$`',
    `total_underwriter_remittance` DECIMAL(18,2) COMMENT 'Total amount due to the underwriter for this line: sum of underwriter_premium_share, endorsement_underwriter_share, and cpl_underwriter_share. The controlling remittance amount for this line.',
    `transaction_type` STRING COMMENT 'Real estate transaction type underlying the policy being remitted. Supports segmentation of remittance analytics by transaction category (purchase, REFI, HELOC, construction, commercial).. Valid values are `purchase|refinance|heloc|construction|commercial`',
    `underwriter_code` BIGINT COMMENT 'Reference to the title underwriter (e.g., FNF, FAF, STC, ORI) receiving the remittance for this line. Required for multi-underwriter agent scenarios and underwriter-level settlement reporting.',
    `underwriter_premium_share` DECIMAL(18,2) COMMENT 'Computed dollar amount due to the underwriter: net_premium_amount multiplied by underwriter_split_rate. This is the amount being remitted to the underwriter for this line.',
    `underwriter_split_rate` DECIMAL(7,6) COMMENT 'Decimal rate representing the underwriters share of net premium per the applicable premium_split_schedule (e.g., 0.200000 = 20%). Must sum to 1.0 with agent_split_rate.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_remittance_line PRIMARY KEY(`remittance_line_id`)
) COMMENT 'Line-level detail of an agent_remittance, one row per policy/transaction premium being remitted. Captures source policy or order reference, policy type (owner/lender), gross premium, applied premium_split_schedule rate, computed underwriter share';

-- ========= FOREIGN KEYS =========
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ADD CONSTRAINT `fk_agency_agent_authority_agency_agreement_id` FOREIGN KEY (`agency_agreement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`(`agreement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ADD CONSTRAINT `fk_agency_agent_authority_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ADD CONSTRAINT `fk_agency_agent_authority_prior_authority_id` FOREIGN KEY (`prior_authority_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority`(`agent_authority_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ADD CONSTRAINT `fk_agency_agent_license_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ADD CONSTRAINT `fk_agency_agreement_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ADD CONSTRAINT `fk_agency_agreement_prior_agreement_id` FOREIGN KEY (`prior_agreement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`(`agreement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ADD CONSTRAINT `fk_agency_eo_coverage_agency_agreement_id` FOREIGN KEY (`agency_agreement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`(`agreement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ADD CONSTRAINT `fk_agency_eo_coverage_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ADD CONSTRAINT `fk_agency_premium_split_schedule_agency_agreement_id` FOREIGN KEY (`agency_agreement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`(`agreement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ADD CONSTRAINT `fk_agency_premium_split_schedule_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ADD CONSTRAINT `fk_agency_premium_split_schedule_superseded_by_schedule_premium_split_schedule_id` FOREIGN KEY (`superseded_by_schedule_premium_split_schedule_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule`(`premium_split_schedule_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ADD CONSTRAINT `fk_agency_cpl_issuance_agency_agreement_id` FOREIGN KEY (`agency_agreement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`(`agreement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ADD CONSTRAINT `fk_agency_cpl_issuance_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ADD CONSTRAINT `fk_agency_cpl_issuance_superseded_by_cpl_cpl_issuance_id` FOREIGN KEY (`superseded_by_cpl_cpl_issuance_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance`(`cpl_issuance_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ADD CONSTRAINT `fk_agency_oversight_review_agency_agreement_id` FOREIGN KEY (`agency_agreement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`(`agreement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ADD CONSTRAINT `fk_agency_oversight_review_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ADD CONSTRAINT `fk_agency_oversight_review_prior_review_oversight_review_id` FOREIGN KEY (`prior_review_oversight_review_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review`(`oversight_review_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ADD CONSTRAINT `fk_agency_agent_remittance_agency_agreement_id` FOREIGN KEY (`agency_agreement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`(`agreement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ADD CONSTRAINT `fk_agency_agent_remittance_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ADD CONSTRAINT `fk_agency_agent_remittance_premium_split_schedule_id` FOREIGN KEY (`premium_split_schedule_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule`(`premium_split_schedule_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ADD CONSTRAINT `fk_agency_agent_remittance_prior_remittance_agent_remittance_id` FOREIGN KEY (`prior_remittance_agent_remittance_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance`(`agent_remittance_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ADD CONSTRAINT `fk_agency_remittance_line_agency_agreement_id` FOREIGN KEY (`agency_agreement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`(`agreement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ADD CONSTRAINT `fk_agency_remittance_line_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ADD CONSTRAINT `fk_agency_remittance_line_agent_remittance_id` FOREIGN KEY (`agent_remittance_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance`(`agent_remittance_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ADD CONSTRAINT `fk_agency_remittance_line_premium_split_schedule_id` FOREIGN KEY (`premium_split_schedule_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule`(`premium_split_schedule_id`);

-- ========= TAGS =========
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_agency` SET TAGS ('title_division' = 'business');
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_agency` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` SET TAGS ('title_subdomain' = 'partner_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `agent_authority_id` SET TAGS ('title_business_glossary_term' = 'Agent Authority ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `agency_agreement_id` SET TAGS ('title_business_glossary_term' = 'Agency Agreement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `prior_authority_id` SET TAGS ('title_business_glossary_term' = 'Prior Authority ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `agent_premium_split_pct` SET TAGS ('title_business_glossary_term' = 'Agent Premium Split Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `agent_premium_split_pct` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `approval_date` SET TAGS ('title_business_glossary_term' = 'Approval Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `approval_status` SET TAGS ('title_business_glossary_term' = 'Approval Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `approval_status` SET TAGS ('title_value_regex' = 'pending|approved|conditionally_approved|denied|withdrawn');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `approved_by` SET TAGS ('title_business_glossary_term' = 'Approved By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `authority_notes` SET TAGS ('title_business_glossary_term' = 'Authority Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `authority_number` SET TAGS ('title_business_glossary_term' = 'Authority Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `authority_number` SET TAGS ('title_value_regex' = '^[A-Z0-9-]{4,30}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `authority_status` SET TAGS ('title_business_glossary_term' = 'Authority Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `authority_status` SET TAGS ('title_value_regex' = 'active|suspended|terminated|pending|expired');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `authority_tier` SET TAGS ('title_business_glossary_term' = 'Authority Tier');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `authority_tier` SET TAGS ('title_value_regex' = 'standard|limited|expanded|commercial|restricted');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'independent_agent|direct_branch|lender_channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `commercial_max_insured_amount` SET TAGS ('title_business_glossary_term' = 'Commercial Maximum Insured Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `cpl_authority_flag` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Authority Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `endorsement_authority_flag` SET TAGS ('title_business_glossary_term' = 'Endorsement Authority Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `eo_coverage_amount` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `eo_expiration_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `eo_policy_number` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `escrow_authority_flag` SET TAGS ('title_business_glossary_term' = 'Escrow Authority Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `gap_coverage_authority_flag` SET TAGS ('title_business_glossary_term' = 'Gap Coverage Authority Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `license_expiration_date` SET TAGS ('title_business_glossary_term' = 'License Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `license_number` SET TAGS ('title_business_glossary_term' = 'Agent License Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `max_insured_amount` SET TAGS ('title_business_glossary_term' = 'Maximum Insured Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `oversight_review_date` SET TAGS ('title_business_glossary_term' = 'Oversight Review Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `oversight_review_result` SET TAGS ('title_business_glossary_term' = 'Oversight Review Result');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `oversight_review_result` SET TAGS ('title_value_regex' = 'satisfactory|conditional|unsatisfactory|pending|not_reviewed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `policy_type_scope` SET TAGS ('title_business_glossary_term' = 'Policy Type Scope');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `policy_type_scope` SET TAGS ('title_value_regex' = 'owner|lender|both');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `remittance_due_day` SET TAGS ('title_business_glossary_term' = 'Remittance Due Day');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `remittance_frequency` SET TAGS ('title_business_glossary_term' = 'Remittance Frequency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `remittance_frequency` SET TAGS ('title_value_regex' = 'monthly|quarterly|semi_annual|annual|per_transaction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `termination_date` SET TAGS ('title_business_glossary_term' = 'Termination Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `termination_reason` SET TAGS ('title_business_glossary_term' = 'Termination Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `transaction_type_scope` SET TAGS ('title_business_glossary_term' = 'Transaction Type Scope');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `transaction_type_scope` SET TAGS ('title_value_regex' = 'residential_purchase|refinance|home_equity|construction|commercial|all');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `underwriter_code` SET TAGS ('title_business_glossary_term' = 'Underwriter ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `underwriter_premium_split_pct` SET TAGS ('title_business_glossary_term' = 'Underwriter Premium Split Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `underwriter_premium_split_pct` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `uwref_threshold_amount` SET TAGS ('title_business_glossary_term' = 'Underwriting Referral (UWR) Threshold Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` SET TAGS ('title_subdomain' = 'partner_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `agent_license_id` SET TAGS ('title_business_glossary_term' = 'Agent License ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Entity ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `appointing_underwriter_code` SET TAGS ('title_business_glossary_term' = 'Appointing Underwriter ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `appointment_date` SET TAGS ('title_business_glossary_term' = 'Underwriter Appointment Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `appointment_termination_date` SET TAGS ('title_business_glossary_term' = 'Underwriter Appointment Termination Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `authority_hold_flag` SET TAGS ('title_business_glossary_term' = 'Authority Hold Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `authority_hold_reason` SET TAGS ('title_business_glossary_term' = 'Authority Hold Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `background_check_date` SET TAGS ('title_business_glossary_term' = 'Background Check Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `background_check_status` SET TAGS ('title_business_glossary_term' = 'Background Check Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `background_check_status` SET TAGS ('title_value_regex' = 'passed|failed|pending|waived');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `ce_compliance_status` SET TAGS ('title_business_glossary_term' = 'Continuing Education (CE) Compliance Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `ce_compliance_status` SET TAGS ('title_value_regex' = 'compliant|deficient|exempt|pending_verification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `ce_credit_hours_completed` SET TAGS ('title_business_glossary_term' = 'Continuing Education (CE) Credit Hours Completed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `ce_credit_hours_required` SET TAGS ('title_business_glossary_term' = 'Continuing Education (CE) Credit Hours Required');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `continuing_education_required` SET TAGS ('title_business_glossary_term' = 'Continuing Education (CE) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `domicile_state_code` SET TAGS ('title_business_glossary_term' = 'Domicile State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `domicile_state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'License Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `eo_carrier_name` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Carrier Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `eo_coverage_amount` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `eo_expiration_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Policy Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `eo_policy_number` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `eo_verified_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Verification Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'License Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `issue_date` SET TAGS ('title_business_glossary_term' = 'License Issue Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_change_reason` SET TAGS ('title_business_glossary_term' = 'License Change Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_class` SET TAGS ('title_business_glossary_term' = 'License Class');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_class` SET TAGS ('title_value_regex' = 'title_agent|title_producer|title_insurer|escrow_agent|settlement_agent|notary_signing_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_number` SET TAGS ('title_business_glossary_term' = 'License Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_revision_number` SET TAGS ('title_business_glossary_term' = 'License Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_status` SET TAGS ('title_business_glossary_term' = 'License Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_status` SET TAGS ('title_value_regex' = 'active|suspended|expired|revoked|pending|cancelled');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_type` SET TAGS ('title_business_glossary_term' = 'License Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_type` SET TAGS ('title_value_regex' = 'individual|entity|branch');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_verification_source` SET TAGS ('title_business_glossary_term' = 'License Verification Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_verification_source` SET TAGS ('title_value_regex' = 'nipr|state_doi_portal|manual|third_party');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `license_verified_date` SET TAGS ('title_business_glossary_term' = 'License Verified Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `lines_of_authority` SET TAGS ('title_business_glossary_term' = 'Lines of Authority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `nipr_producer_number` SET TAGS ('title_business_glossary_term' = 'National Insurance Producer Registry (NIPR) Producer Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `prior_license_number` SET TAGS ('title_business_glossary_term' = 'Prior License Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `record_created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `record_updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `regulatory_action_description` SET TAGS ('title_business_glossary_term' = 'Regulatory Action Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `regulatory_action_flag` SET TAGS ('title_business_glossary_term' = 'Regulatory Action Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `reinstatement_date` SET TAGS ('title_business_glossary_term' = 'License Reinstatement Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `renewal_date` SET TAGS ('title_business_glossary_term' = 'License Renewal Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `resident_nonresident_flag` SET TAGS ('title_business_glossary_term' = 'Resident / Non-Resident License Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `revocation_date` SET TAGS ('title_business_glossary_term' = 'License Revocation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `source_system_license_key` SET TAGS ('title_business_glossary_term' = 'Source System License Key');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `state_fips_code` SET TAGS ('title_business_glossary_term' = 'State Federal Information Processing Standards (FIPS) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `state_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `suspension_date` SET TAGS ('title_business_glossary_term' = 'License Suspension Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` SET TAGS ('title_subdomain' = 'partner_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent Profile ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agency_agreement_number` SET TAGS ('title_business_glossary_term' = 'Agency Agreement Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agent_code` SET TAGS ('title_business_glossary_term' = 'Agent Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agent_code` SET TAGS ('title_value_regex' = '^[A-Z0-9]{4,20}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agent_premium_split_pct` SET TAGS ('title_business_glossary_term' = 'Agent Premium Split Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agent_premium_split_pct` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agent_status` SET TAGS ('title_business_glossary_term' = 'Agent Appointment Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agent_status` SET TAGS ('title_value_regex' = 'active|suspended|terminated|pending_approval|probation');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agent_type` SET TAGS ('title_business_glossary_term' = 'Agent Entity Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `agent_type` SET TAGS ('title_value_regex' = 'individual|corporation|llc|partnership|government');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `alta_best_practices_certified` SET TAGS ('title_business_glossary_term' = 'ALTA Best Practices Certification Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `alta_certification_date` SET TAGS ('title_business_glossary_term' = 'ALTA Best Practices Certification Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `alta_certification_expiration_date` SET TAGS ('title_business_glossary_term' = 'ALTA Best Practices Certification Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `appointment_effective_date` SET TAGS ('title_business_glossary_term' = 'Agency Appointment Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `appointment_expiration_date` SET TAGS ('title_business_glossary_term' = 'Agency Appointment Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `authority_level` SET TAGS ('title_business_glossary_term' = 'Agent Authority Level');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `authority_level` SET TAGS ('title_value_regex' = 'standard|enhanced|restricted|cpl_only');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Distribution Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'independent_agent|direct_branch|lender_channel|commercial_channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `cpl_authority_flag` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issuance Authority Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `dba_name` SET TAGS ('title_business_glossary_term' = 'Doing Business As (DBA) Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `dba_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `eo_carrier_name` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Insurance Carrier Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `eo_coverage_amount` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `eo_coverage_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `eo_expiration_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Policy Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `eo_policy_number` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `eo_policy_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `escrow_account_verified_date` SET TAGS ('title_business_glossary_term' = 'Escrow Account Verification Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `fidelity_bond_amount` SET TAGS ('title_business_glossary_term' = 'Fidelity Bond Coverage Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `fidelity_bond_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `fidelity_bond_expiration_date` SET TAGS ('title_business_glossary_term' = 'Fidelity Bond Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `fips_county_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `fips_county_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `iolta_account_flag` SET TAGS ('title_business_glossary_term' = 'Interest on Lawyers Trust Account (IOLTA) Escrow Account Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `last_audit_date` SET TAGS ('title_business_glossary_term' = 'Last Underwriter Audit Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `last_audit_result` SET TAGS ('title_business_glossary_term' = 'Last Underwriter Audit Result');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `last_audit_result` SET TAGS ('title_value_regex' = 'satisfactory|conditional|unsatisfactory|pending_review');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `last_updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `legal_entity_name` SET TAGS ('title_business_glossary_term' = 'Legal Entity Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `legal_entity_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `max_policy_liability_amount` SET TAGS ('title_business_glossary_term' = 'Maximum Policy Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `naic_company_code` SET TAGS ('title_business_glossary_term' = 'National Association of Insurance Commissioners (NAIC) Company Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `naic_company_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_address_line1` SET TAGS ('title_business_glossary_term' = 'Office Address Line 1');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_address_line1` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_address_line1` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_address_line2` SET TAGS ('title_business_glossary_term' = 'Office Address Line 2');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_address_line2` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_address_line2` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_city` SET TAGS ('title_business_glossary_term' = 'Office City');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_city` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_city` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_state` SET TAGS ('title_business_glossary_term' = 'Office State');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_state` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_zip_code` SET TAGS ('title_business_glossary_term' = 'Office ZIP Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_zip_code` SET TAGS ('title_value_regex' = '^[0-9]{5}(-[0-9]{4})?$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_zip_code` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `office_zip_code` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `onboarding_date` SET TAGS ('title_business_glossary_term' = 'Agent Onboarding Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `operating_states` SET TAGS ('title_business_glossary_term' = 'Operating States');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_email` SET TAGS ('title_business_glossary_term' = 'Primary Contact Email Address');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_email` SET TAGS ('title_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_email` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_email` SET TAGS ('title_pii_email' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_name` SET TAGS ('title_business_glossary_term' = 'Primary Contact Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_phone` SET TAGS ('title_business_glossary_term' = 'Primary Contact Phone Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_phone` SET TAGS ('title_value_regex' = '^+?[0-9-s().]{7,20}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_phone` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_contact_phone` SET TAGS ('title_pii_phone' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_license_expiration_date` SET TAGS ('title_business_glossary_term' = 'Primary License Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_license_state` SET TAGS ('title_business_glossary_term' = 'Primary License State');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_license_state` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_state_license_number` SET TAGS ('title_business_glossary_term' = 'Primary State Title Insurance License Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `primary_state_license_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `remittance_due_day` SET TAGS ('title_business_glossary_term' = 'Remittance Due Day of Month');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `remittance_schedule_type` SET TAGS ('title_business_glossary_term' = 'Premium Remittance Schedule Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `remittance_schedule_type` SET TAGS ('title_value_regex' = 'monthly|quarterly|semi_annual|annual|per_transaction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `tax_id_reference` SET TAGS ('title_business_glossary_term' = 'Tax Identification Number (TIN) Vault Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `tax_id_reference` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `tax_id_reference` SET TAGS ('title_pii_identifier' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `termination_date` SET TAGS ('title_business_glossary_term' = 'Agent Termination Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `termination_reason` SET TAGS ('title_business_glossary_term' = 'Agent Termination Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `underwriter_split_pct` SET TAGS ('title_business_glossary_term' = 'Underwriter Premium Split Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `underwriter_split_pct` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` SET TAGS ('title_subdomain' = 'partner_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `agreement_id` SET TAGS ('title_business_glossary_term' = 'Agency Agreement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Independent Title Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Title Underwriter ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `prior_agreement_id` SET TAGS ('title_business_glossary_term' = 'Prior Agency Agreement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `agent_premium_split_pct` SET TAGS ('title_business_glossary_term' = 'Agent Premium Split Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `agent_premium_split_pct` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `aggregate_liability_limit` SET TAGS ('title_business_glossary_term' = 'Aggregate Annual Liability Limit');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `aggregate_liability_limit` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `agreement_status` SET TAGS ('title_business_glossary_term' = 'Agency Agreement Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `agreement_status` SET TAGS ('title_value_regex' = 'draft|active|suspended|terminated|expired|pending_renewal');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `agreement_type` SET TAGS ('title_business_glossary_term' = 'Agency Agreement Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `agreement_type` SET TAGS ('title_value_regex' = 'independent_agent|direct_branch|lender_channel|affiliated_agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `amendment_count` SET TAGS ('title_business_glossary_term' = 'Agreement Amendment Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `audit_frequency` SET TAGS ('title_business_glossary_term' = 'Agency Audit Frequency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `audit_frequency` SET TAGS ('title_value_regex' = 'annual|biennial|triennial|as_needed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `authority_level` SET TAGS ('title_business_glossary_term' = 'Agency Authority Level');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `authority_level` SET TAGS ('title_value_regex' = 'full|limited|conditional|suspended');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('title_business_glossary_term' = 'Automatic Renewal Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Distribution Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'direct_branch|independent_agent|lender_channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `commercial_authority_flag` SET TAGS ('title_business_glossary_term' = 'Commercial Transaction Authority Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `cpl_authority_flag` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issuance Authority Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `current_version_number` SET TAGS ('title_business_glossary_term' = 'Current Agreement Version Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `current_version_number` SET TAGS ('title_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `document_reference_code` SET TAGS ('title_business_glossary_term' = 'Agreement Document Reference ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Agreement Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `endorsement_authority_flag` SET TAGS ('title_business_glossary_term' = 'ALTA Endorsement Issuance Authority Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `eo_carrier_name` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Carrier Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `eo_coverage_amount` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `eo_coverage_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `eo_expiration_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Policy Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `eo_policy_number` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `eo_policy_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `escrow_authority_flag` SET TAGS ('title_business_glossary_term' = 'Escrow Closing Authority Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Agreement Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Agreement Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `fidelity_bond_amount` SET TAGS ('title_business_glossary_term' = 'Fidelity Bond Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `fidelity_bond_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `fidelity_bond_expiration_date` SET TAGS ('title_business_glossary_term' = 'Fidelity Bond Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `fidelity_bond_number` SET TAGS ('title_business_glossary_term' = 'Fidelity Bond Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `fidelity_bond_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `geographic_territory` SET TAGS ('title_business_glossary_term' = 'Authorized Geographic Territory');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `governing_law_state` SET TAGS ('title_business_glossary_term' = 'Governing Law State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `governing_law_state` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `last_audit_date` SET TAGS ('title_business_glossary_term' = 'Last Agency Audit Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `max_liability_amount` SET TAGS ('title_business_glossary_term' = 'Maximum Single-Transaction Liability Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `max_liability_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `next_audit_due_date` SET TAGS ('title_business_glossary_term' = 'Next Agency Audit Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Agency Agreement Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `notice_period_days` SET TAGS ('title_business_glossary_term' = 'Termination Notice Period Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `number` SET TAGS ('title_business_glossary_term' = 'Agency Agreement Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `number` SET TAGS ('title_value_regex' = '^AGT-[0-9]{4}-[A-Z0-9]{6,12}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `oversight_risk_tier` SET TAGS ('title_business_glossary_term' = 'Agency Oversight Risk Tier');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `oversight_risk_tier` SET TAGS ('title_value_regex' = 'low|medium|high|critical');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `remittance_due_days` SET TAGS ('title_business_glossary_term' = 'Remittance Due Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `remittance_frequency` SET TAGS ('title_business_glossary_term' = 'Premium Remittance Frequency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `remittance_frequency` SET TAGS ('title_value_regex' = 'monthly|quarterly|semi_annual|annual|per_transaction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `renewal_date` SET TAGS ('title_business_glossary_term' = 'Agreement Renewal Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `state_codes` SET TAGS ('title_business_glossary_term' = 'Authorized State Codes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `state_codes` SET TAGS ('title_value_regex' = '^([A-Z]{2})(,[A-Z]{2})*$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `termination_date` SET TAGS ('title_business_glossary_term' = 'Agreement Termination Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `termination_reason` SET TAGS ('title_business_glossary_term' = 'Agreement Termination Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `transaction_types_authorized` SET TAGS ('title_business_glossary_term' = 'Authorized Transaction Types');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `underwriter_premium_split_pct` SET TAGS ('title_business_glossary_term' = 'Underwriter Premium Split Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `underwriter_premium_split_pct` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` SET TAGS ('title_subdomain' = 'partner_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `eo_coverage_id` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `agency_agreement_id` SET TAGS ('title_business_glossary_term' = 'Agency Agreement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `additional_insured_flag` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Additional Insured Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `aggregate_limit` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Aggregate Limit');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `aggregate_limit` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `cancellation_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Cancellation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `cancellation_reason` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Cancellation Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `cancellation_reason` SET TAGS ('title_value_regex' = 'non_payment|underwriter_request|agent_request|carrier_withdrawal|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `carrier_naic_code` SET TAGS ('title_business_glossary_term' = 'Carrier National Association of Insurance Commissioners (NAIC) Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `carrier_naic_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `carrier_name` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Carrier Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `certificate_holder_name` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Certificate Holder Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `certificate_number` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Certificate of Insurance Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `certificate_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `coverage_gap_days` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Gap Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `coverage_gap_flag` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Gap Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `coverage_status` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `coverage_status` SET TAGS ('title_value_regex' = 'active|expired|cancelled|pending_renewal|lapsed|suspended');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `coverage_type` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `coverage_type` SET TAGS ('title_value_regex' = 'claims_made|occurrence|claims_made_reported');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `days_until_expiration` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Days Until Expiration');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `deductible_amount` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Deductible Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `deductible_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `document_reference_code` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Document Reference ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `extended_reporting_end_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Extended Reporting Period End Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `extended_reporting_period_flag` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Extended Reporting Period (ERP) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `meets_minimum_requirements` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Meets Minimum Requirements Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `minimum_required_aggregate` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Minimum Required Aggregate Limit');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `minimum_required_per_occurrence` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Minimum Required Per-Occurrence Limit');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `named_insured` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Named Insured');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `named_insured` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `per_occurrence_limit` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Per-Occurrence Limit');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `per_occurrence_limit` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `policy_number` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `policy_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `prior_policy_number` SET TAGS ('title_business_glossary_term' = 'Prior Errors and Omissions (E&O) Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `prior_policy_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `renewal_reminder_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Renewal Reminder Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `renewal_reminder_sent_flag` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Renewal Reminder Sent Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `retroactive_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Retroactive Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `source_record_code` SET TAGS ('title_business_glossary_term' = 'Source Record ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `source_system_code` SET TAGS ('title_value_regex' = 'agency_mgmt|crm|manual_entry');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `state_minimum_required_flag` SET TAGS ('title_business_glossary_term' = 'State Minimum Errors and Omissions (E&O) Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `verification_date` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Verification Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `verification_method` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Verification Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `verification_method` SET TAGS ('title_value_regex' = 'certificate_of_insurance|carrier_confirmation|agent_self_report|third_party_database');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `verification_status` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Verification Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `verification_status` SET TAGS ('title_value_regex' = 'verified|unverified|pending|failed|waived');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `verified_by` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Verified By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` SET TAGS ('title_data_type' = 'reference_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` SET TAGS ('title_subdomain' = 'partner_management');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `premium_split_schedule_id` SET TAGS ('title_business_glossary_term' = 'Premium Split Schedule ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `agency_agreement_id` SET TAGS ('title_business_glossary_term' = 'Agency Agreement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Underwriter ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `superseded_by_schedule_premium_split_schedule_id` SET TAGS ('title_business_glossary_term' = 'Superseded By Schedule ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `agent_split_rate` SET TAGS ('title_business_glossary_term' = 'Agent Premium Split Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `agent_split_rate` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `approval_date` SET TAGS ('title_business_glossary_term' = 'Approval Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `approval_status` SET TAGS ('title_business_glossary_term' = 'Approval Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `approval_status` SET TAGS ('title_value_regex' = 'draft|pending_approval|approved|rejected');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `approved_by` SET TAGS ('title_business_glossary_term' = 'Approved By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Distribution Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'independent_agent|direct_branch|lender_channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `cpl_fee_split_rate` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Fee Split Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `cpl_fee_split_rate` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `endorsement_split_rate` SET TAGS ('title_business_glossary_term' = 'Endorsement Premium Split Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `endorsement_split_rate` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `is_tiered_schedule` SET TAGS ('title_business_glossary_term' = 'Is Tiered Schedule Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `minimum_agent_remittance_amount` SET TAGS ('title_business_glossary_term' = 'Minimum Agent Remittance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `minimum_agent_remittance_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Schedule Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'owner|lender|both');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `premium_ceiling_amount` SET TAGS ('title_business_glossary_term' = 'Premium Ceiling Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `premium_ceiling_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `premium_floor_amount` SET TAGS ('title_business_glossary_term' = 'Premium Floor Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `premium_floor_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `property_type_scope` SET TAGS ('title_business_glossary_term' = 'Property Type Scope');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `property_type_scope` SET TAGS ('title_value_regex' = 'residential|commercial|both');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `rate_source` SET TAGS ('title_business_glossary_term' = 'Rate Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `rate_source` SET TAGS ('title_value_regex' = 'filed_rate|negotiated_rate|statutory_rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `reissue_credit_applies` SET TAGS ('title_business_glossary_term' = 'Reissue Credit Applies Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `remittance_due_days` SET TAGS ('title_business_glossary_term' = 'Remittance Due Days');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `remittance_frequency` SET TAGS ('title_business_glossary_term' = 'Remittance Frequency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `remittance_frequency` SET TAGS ('title_value_regex' = 'monthly|quarterly|semi_annual|annual|per_policy');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `schedule_name` SET TAGS ('title_business_glossary_term' = 'Premium Split Schedule Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `schedule_number` SET TAGS ('title_business_glossary_term' = 'Premium Split Schedule Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `schedule_status` SET TAGS ('title_business_glossary_term' = 'Premium Split Schedule Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `schedule_status` SET TAGS ('title_value_regex' = 'active|pending|superseded|terminated|suspended');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `simultaneous_issue_rate_applies` SET TAGS ('title_business_glossary_term' = 'Simultaneous Issue Rate Applies Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `source_record_code` SET TAGS ('title_business_glossary_term' = 'Source Record ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `split_basis` SET TAGS ('title_business_glossary_term' = 'Premium Split Basis');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `split_basis` SET TAGS ('title_value_regex' = 'gross_premium|net_premium|statutory_rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `supersedes_schedule_id` SET TAGS ('title_business_glossary_term' = 'Supersedes Schedule ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `termination_date` SET TAGS ('title_business_glossary_term' = 'Termination Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `termination_reason` SET TAGS ('title_business_glossary_term' = 'Termination Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `tier_sequence` SET TAGS ('title_business_glossary_term' = 'Tier Sequence Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `underwriter_split_rate` SET TAGS ('title_business_glossary_term' = 'Underwriter Premium Split Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `underwriter_split_rate` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` SET TAGS ('title_subdomain' = 'oversight_remittance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_issuance_id` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Issuance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `agency_agreement_id` SET TAGS ('title_business_glossary_term' = 'Agency Agreement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Independent Title Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_insured_lender_party_id` SET TAGS ('title_business_glossary_term' = 'Insured Lender (Party) ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_party_id` SET TAGS ('title_business_glossary_term' = 'Underwriter ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `insured_ownership_interest_id` SET TAGS ('title_business_glossary_term' = 'Insured Ownership Interest Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `superseded_by_cpl_cpl_issuance_id` SET TAGS ('title_business_glossary_term' = 'Superseded By CPL Issuance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `actual_closing_date` SET TAGS ('title_business_glossary_term' = 'Actual Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `agent_license_number` SET TAGS ('title_business_glossary_term' = 'Agent License Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `agent_name` SET TAGS ('title_business_glossary_term' = 'Independent Title Agent Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `agent_state_code` SET TAGS ('title_business_glossary_term' = 'Agent License State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `agent_state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cancellation_date` SET TAGS ('title_business_glossary_term' = 'CPL Cancellation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cancellation_reason` SET TAGS ('title_business_glossary_term' = 'CPL Cancellation Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cancellation_reason` SET TAGS ('title_value_regex' = 'transaction_cancelled|policy_issued|superseded|agent_request|underwriter_request|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `claim_made_indicator` SET TAGS ('title_business_glossary_term' = 'CPL Claim Made Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `closing_location` SET TAGS ('title_business_glossary_term' = 'Closing Location');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `closing_officer_name` SET TAGS ('title_business_glossary_term' = 'Closing Officer / Escrow Officer Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_fee_amount` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Fee Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_fee_collected` SET TAGS ('title_business_glossary_term' = 'CPL Fee Collected Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_form_version` SET TAGS ('title_business_glossary_term' = 'CPL Form Version');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_number` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_status` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_status` SET TAGS ('title_value_regex' = 'draft|issued|cancelled|expired|superseded');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_type` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `cpl_type` SET TAGS ('title_value_regex' = 'lender|buyer|seller|lender_and_buyer');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `delivery_confirmation_ref` SET TAGS ('title_business_glossary_term' = 'CPL Delivery Confirmation Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `delivery_method` SET TAGS ('title_business_glossary_term' = 'CPL Delivery Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `delivery_method` SET TAGS ('title_value_regex' = 'email|fax|mail|portal|electronic');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `delivery_timestamp` SET TAGS ('title_business_glossary_term' = 'CPL Delivery Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `document_image_ref` SET TAGS ('title_business_glossary_term' = 'CPL Document Image Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'CPL Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `eo_coverage_verified` SET TAGS ('title_business_glossary_term' = 'E&O Coverage Verified Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `eo_policy_number` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'CPL Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `insured_lender_address` SET TAGS ('title_business_glossary_term' = 'Insured Lender Address');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `insured_lender_address` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `insured_lender_address` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `insured_lender_name` SET TAGS ('title_business_glossary_term' = 'Insured Lender Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `issue_date` SET TAGS ('title_business_glossary_term' = 'CPL Issue Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `loan_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `loan_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `prior_cpl_id` SET TAGS ('title_business_glossary_term' = 'Prior CPL Issuance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `purchase_price` SET TAGS ('title_business_glossary_term' = 'Purchase Price (USD)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `purchase_price` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `purchase_price` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'CPL Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `scheduled_closing_date` SET TAGS ('title_business_glossary_term' = 'Scheduled Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `source_system_ref` SET TAGS ('title_business_glossary_term' = 'Source System Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `state_specific_form_indicator` SET TAGS ('title_business_glossary_term' = 'State-Specific CPL Form Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|home_equity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `underwriter_name` SET TAGS ('title_business_glossary_term' = 'Underwriter Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` SET TAGS ('title_subdomain' = 'oversight_remittance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `oversight_review_id` SET TAGS ('title_business_glossary_term' = 'Oversight Review ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `agency_agreement_id` SET TAGS ('title_business_glossary_term' = 'Agency Agreement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `prior_review_oversight_review_id` SET TAGS ('title_business_glossary_term' = 'Prior Oversight Review ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `authority_action_taken` SET TAGS ('title_business_glossary_term' = 'Authority Action Taken');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `authority_action_taken` SET TAGS ('title_value_regex' = 'none|warning_issued|authority_restricted|authority_suspended|authority_terminated|referred_to_doi');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `completion_date` SET TAGS ('title_business_glossary_term' = 'Review Completion Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `corrective_action_due_date` SET TAGS ('title_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `corrective_action_received_date` SET TAGS ('title_business_glossary_term' = 'Corrective Action Received Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `corrective_action_required_flag` SET TAGS ('title_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `corrective_action_status` SET TAGS ('title_business_glossary_term' = 'Corrective Action Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `corrective_action_status` SET TAGS ('title_value_regex' = 'not_required|pending|received|accepted|rejected|overdue');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `critical_finding_flag` SET TAGS ('title_business_glossary_term' = 'Critical Finding Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `document_reference_code` SET TAGS ('title_business_glossary_term' = 'Document Reference ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `eo_coverage_status` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Coverage Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `eo_coverage_status` SET TAGS ('title_value_regex' = 'current|expiring_soon|expired|below_minimum|not_verified');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `eo_verified_flag` SET TAGS ('title_business_glossary_term' = 'Errors and Omissions (E&O) Verified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `escrow_audit_flag` SET TAGS ('title_business_glossary_term' = 'Escrow Audit Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `escrow_compliance_status` SET TAGS ('title_business_glossary_term' = 'Escrow Compliance Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `escrow_compliance_status` SET TAGS ('title_value_regex' = 'compliant|shortfall|overage|reconciliation_gap|not_audited');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `files_sampled_count` SET TAGS ('title_business_glossary_term' = 'Files Sampled Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `files_with_findings_count` SET TAGS ('title_business_glossary_term' = 'Files With Findings Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `finding_categories` SET TAGS ('title_business_glossary_term' = 'Finding Categories');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `findings_summary` SET TAGS ('title_business_glossary_term' = 'Findings Summary');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `license_compliance_status` SET TAGS ('title_business_glossary_term' = 'License Compliance Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `license_compliance_status` SET TAGS ('title_value_regex' = 'compliant|deficient|expired|suspended|not_verified');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `license_verified_flag` SET TAGS ('title_business_glossary_term' = 'License Verified Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `next_review_due_date` SET TAGS ('title_business_glossary_term' = 'Next Review Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `overall_rating` SET TAGS ('title_business_glossary_term' = 'Overall Compliance Rating');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `overall_rating` SET TAGS ('title_value_regex' = 'satisfactory|needs_improvement|unsatisfactory|critical');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `period_end_date` SET TAGS ('title_business_glossary_term' = 'Review Period End Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `period_start_date` SET TAGS ('title_business_glossary_term' = 'Review Period Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `regulatory_referral_date` SET TAGS ('title_business_glossary_term' = 'Regulatory Referral Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `regulatory_referral_flag` SET TAGS ('title_business_glossary_term' = 'Regulatory Referral Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `remittance_audit_flag` SET TAGS ('title_business_glossary_term' = 'Remittance Audit Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `remittance_compliance_status` SET TAGS ('title_business_glossary_term' = 'Remittance Compliance Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `remittance_compliance_status` SET TAGS ('title_value_regex' = 'compliant|late_remittances|underpayment|overpayment|not_audited');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `remittance_variance_amount` SET TAGS ('title_business_glossary_term' = 'Remittance Variance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `remittance_variance_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_date` SET TAGS ('title_business_glossary_term' = 'Review Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_method` SET TAGS ('title_business_glossary_term' = 'Review Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_method` SET TAGS ('title_value_regex' = 'on_site|remote|desk_review|hybrid');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_notes` SET TAGS ('title_business_glossary_term' = 'Review Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_number` SET TAGS ('title_business_glossary_term' = 'Oversight Review Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_number` SET TAGS ('title_value_regex' = '^OVR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_scope` SET TAGS ('title_business_glossary_term' = 'Review Scope Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_status` SET TAGS ('title_business_glossary_term' = 'Oversight Review Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_status` SET TAGS ('title_value_regex' = 'scheduled|in_progress|pending_response|completed|cancelled|escalated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_type` SET TAGS ('title_business_glossary_term' = 'Oversight Review Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `review_type` SET TAGS ('title_value_regex' = 'annual_audit|random_file_review|eo_verification|licensing_check|remittance_audit|for_cause_review');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `reviewer_department` SET TAGS ('title_business_glossary_term' = 'Reviewer Department');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `reviewer_employee_code` SET TAGS ('title_business_glossary_term' = 'Reviewer Employee ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `reviewer_employee_code` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `reviewer_employee_code` SET TAGS ('title_pii' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `reviewer_name` SET TAGS ('title_business_glossary_term' = 'Reviewer Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `risk_tier_after` SET TAGS ('title_business_glossary_term' = 'Risk Tier After Review');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `risk_tier_after` SET TAGS ('title_value_regex' = 'low|moderate|elevated|high|critical');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `risk_tier_before` SET TAGS ('title_business_glossary_term' = 'Risk Tier Before Review');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `risk_tier_before` SET TAGS ('title_value_regex' = 'low|moderate|elevated|high|critical');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `scheduled_date` SET TAGS ('title_business_glossary_term' = 'Scheduled Review Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` SET TAGS ('title_subdomain' = 'oversight_remittance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `agent_remittance_id` SET TAGS ('title_business_glossary_term' = 'Agent Remittance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `agency_agreement_id` SET TAGS ('title_business_glossary_term' = 'Agency Agreement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `premium_split_schedule_id` SET TAGS ('title_business_glossary_term' = 'Premium Split Schedule ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `prior_remittance_agent_remittance_id` SET TAGS ('title_business_glossary_term' = 'Prior Remittance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Remittance Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `agent_retained_amount` SET TAGS ('title_business_glossary_term' = 'Agent Retained Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `agent_retained_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `agent_retained_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `amount_received` SET TAGS ('title_business_glossary_term' = 'Amount Received');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `amount_received` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `amount_received` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Distribution Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'independent_agent|direct_branch|lender_channel');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `cpl_fee_amount` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `cpl_fee_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `cpl_fee_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `days_past_due` SET TAGS ('title_business_glossary_term' = 'Days Past Due');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `due_date` SET TAGS ('title_business_glossary_term' = 'Remittance Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `endorsement_premium_amount` SET TAGS ('title_business_glossary_term' = 'Endorsement Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `endorsement_premium_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `endorsement_premium_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `exception_flag` SET TAGS ('title_business_glossary_term' = 'Remittance Exception Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `exception_reason` SET TAGS ('title_business_glossary_term' = 'Remittance Exception Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `gl_batch_reference` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Batch Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `gross_premium_amount` SET TAGS ('title_business_glossary_term' = 'Gross Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `gross_premium_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `gross_premium_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `is_late` SET TAGS ('title_business_glossary_term' = 'Is Late Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `late_fee_amount` SET TAGS ('title_business_glossary_term' = 'Late Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `late_fee_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `late_fee_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `ltp_count` SET TAGS ('title_business_glossary_term' = 'Lenders Title Policy (LTP) Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `net_remittance_amount` SET TAGS ('title_business_glossary_term' = 'Net Remittance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `net_remittance_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `net_remittance_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Remittance Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `otp_count` SET TAGS ('title_business_glossary_term' = 'Owners Title Policy (OTP) Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `payment_method` SET TAGS ('title_business_glossary_term' = 'Payment Method');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `payment_method` SET TAGS ('title_value_regex' = 'wire|ach|check|offset|electronic_funds_transfer');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `payment_reference` SET TAGS ('title_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `period_end_date` SET TAGS ('title_business_glossary_term' = 'Remittance Period End Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `period_start_date` SET TAGS ('title_business_glossary_term' = 'Remittance Period Start Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `policy_count` SET TAGS ('title_business_glossary_term' = 'Policy Count');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `reconciliation_date` SET TAGS ('title_business_glossary_term' = 'Reconciliation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `reconciliation_status` SET TAGS ('title_business_glossary_term' = 'Reconciliation Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `reconciliation_status` SET TAGS ('title_value_regex' = 'unreconciled|in_progress|reconciled|disputed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `reissue_credit_amount` SET TAGS ('title_business_glossary_term' = 'Reissue Credit Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `reissue_credit_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `reissue_credit_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `remittance_frequency` SET TAGS ('title_business_glossary_term' = 'Remittance Frequency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `remittance_frequency` SET TAGS ('title_value_regex' = 'weekly|biweekly|monthly|quarterly|annual');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `remittance_number` SET TAGS ('title_business_glossary_term' = 'Remittance Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `remittance_number` SET TAGS ('title_value_regex' = '^REM-[A-Z0-9]{4,20}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `remittance_status` SET TAGS ('title_business_glossary_term' = 'Remittance Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `remittance_type` SET TAGS ('title_business_glossary_term' = 'Remittance Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `remittance_type` SET TAGS ('title_value_regex' = 'periodic|supplemental|corrected|final|advance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `settlement_date` SET TAGS ('title_business_glossary_term' = 'Agency Settlement Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `simultaneous_issue_credit_amount` SET TAGS ('title_business_glossary_term' = 'Simultaneous Issue Credit Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `simultaneous_issue_credit_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `simultaneous_issue_credit_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Remittance Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `transaction_type_scope` SET TAGS ('title_business_glossary_term' = 'Transaction Type Scope');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `transaction_type_scope` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial|home_equity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `underwriter_code` SET TAGS ('title_business_glossary_term' = 'Underwriter ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `underwriter_due_amount` SET TAGS ('title_business_glossary_term' = 'Underwriter Due Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `underwriter_due_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `underwriter_due_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `variance_amount` SET TAGS ('title_business_glossary_term' = 'Remittance Variance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `variance_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `variance_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` SET TAGS ('title_domain' = 'agency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` SET TAGS ('title_division' = 'business');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` SET TAGS ('title_subdomain' = 'oversight_remittance');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `remittance_line_id` SET TAGS ('title_business_glossary_term' = 'Remittance Line ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `agency_agreement_id` SET TAGS ('title_business_glossary_term' = 'Agency Agreement ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `agent_profile_id` SET TAGS ('title_business_glossary_term' = 'Agent ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `agent_remittance_id` SET TAGS ('title_business_glossary_term' = 'Agent Remittance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `premium_split_schedule_id` SET TAGS ('title_business_glossary_term' = 'Premium Split Schedule ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `title_policy_id` SET TAGS ('title_business_glossary_term' = 'Title Policy ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `accepted_date` SET TAGS ('title_business_glossary_term' = 'Accepted Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `adjustment_amount` SET TAGS ('title_business_glossary_term' = 'Adjustment Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `adjustment_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `adjustment_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `adjustment_reason` SET TAGS ('title_business_glossary_term' = 'Adjustment Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `adjustment_reason` SET TAGS ('title_value_regex' = 'rate_correction|credit_memo|dispute_resolution|cancellation|reissue_correction|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `agent_premium_share` SET TAGS ('title_business_glossary_term' = 'Agent Premium Share Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `agent_premium_share` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `agent_premium_share` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `agent_split_rate` SET TAGS ('title_business_glossary_term' = 'Agent Split Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `channel_type` SET TAGS ('title_business_glossary_term' = 'Channel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `channel_type` SET TAGS ('title_value_regex' = 'direct_branch|centralized_lender|independent_agent');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `closing_date` SET TAGS ('title_business_glossary_term' = 'Closing Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `county_fips_code` SET TAGS ('title_business_glossary_term' = 'County FIPS Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `county_fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `cpl_fee_amount` SET TAGS ('title_business_glossary_term' = 'Closing Protection Letter (CPL) Fee Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `cpl_fee_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `cpl_fee_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `cpl_underwriter_share` SET TAGS ('title_business_glossary_term' = 'CPL Underwriter Share Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `cpl_underwriter_share` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `cpl_underwriter_share` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `days_past_due` SET TAGS ('title_business_glossary_term' = 'Days Past Due');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `endorsement_premium_amount` SET TAGS ('title_business_glossary_term' = 'Endorsement Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `endorsement_premium_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `endorsement_premium_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `endorsement_underwriter_share` SET TAGS ('title_business_glossary_term' = 'Endorsement Underwriter Share Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `endorsement_underwriter_share` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `endorsement_underwriter_share` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `gl_account_code` SET TAGS ('title_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `gross_premium_amount` SET TAGS ('title_business_glossary_term' = 'Gross Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `gross_premium_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `gross_premium_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `insured_amount` SET TAGS ('title_business_glossary_term' = 'Insured Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `insured_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `insured_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `is_late_remittance` SET TAGS ('title_business_glossary_term' = 'Is Late Remittance Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `is_reissue_credit_applied` SET TAGS ('title_business_glossary_term' = 'Is Reissue Credit Applied Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `is_simultaneous_issue` SET TAGS ('title_business_glossary_term' = 'Is Simultaneous Issue Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `line_sequence` SET TAGS ('title_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `line_status` SET TAGS ('title_business_glossary_term' = 'Remittance Line Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `line_status` SET TAGS ('title_value_regex' = 'pending|accepted|rejected|adjusted|reversed|voided');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `net_premium_amount` SET TAGS ('title_business_glossary_term' = 'Net Premium Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `net_premium_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `net_premium_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Remittance Line Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `policy_effective_date` SET TAGS ('title_business_glossary_term' = 'Policy Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `policy_issue_date` SET TAGS ('title_business_glossary_term' = 'Policy Issue Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `policy_number` SET TAGS ('title_business_glossary_term' = 'Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `policy_type` SET TAGS ('title_business_glossary_term' = 'Policy Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `policy_type` SET TAGS ('title_value_regex' = 'owner|lender|cpl|endorsement');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `prior_policy_number` SET TAGS ('title_business_glossary_term' = 'Prior Policy Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `rate_filing_reference` SET TAGS ('title_business_glossary_term' = 'Rate Filing Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `reissue_credit_amount` SET TAGS ('title_business_glossary_term' = 'Reissue Credit Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `reissue_credit_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `reissue_credit_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `rejection_reason` SET TAGS ('title_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `remittance_due_date` SET TAGS ('title_business_glossary_term' = 'Remittance Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `remittance_submitted_date` SET TAGS ('title_business_glossary_term' = 'Remittance Submitted Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `simultaneous_issue_credit_amount` SET TAGS ('title_business_glossary_term' = 'Simultaneous Issue Credit Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `simultaneous_issue_credit_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `simultaneous_issue_credit_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `source_system_line_ref` SET TAGS ('title_business_glossary_term' = 'Source System Line Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `split_basis` SET TAGS ('title_business_glossary_term' = 'Split Basis');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `split_basis` SET TAGS ('title_value_regex' = 'net_premium|gross_premium|flat_fee');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `total_underwriter_remittance` SET TAGS ('title_business_glossary_term' = 'Total Underwriter Remittance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `total_underwriter_remittance` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `total_underwriter_remittance` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|heloc|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `underwriter_code` SET TAGS ('title_business_glossary_term' = 'Underwriter ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `underwriter_premium_share` SET TAGS ('title_business_glossary_term' = 'Underwriter Premium Share Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `underwriter_premium_share` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `underwriter_premium_share` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `underwriter_split_rate` SET TAGS ('title_business_glossary_term' = 'Underwriter Split Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
