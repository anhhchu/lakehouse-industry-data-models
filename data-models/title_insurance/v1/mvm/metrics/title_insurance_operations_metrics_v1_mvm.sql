-- Metric views for domain: operations | Business: Title_Insurance | Version: 1 | Generated on: 2026-10-31 06:37:37

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`operations_operations_curative_action`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Operations Curative Action business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action`"
  dimensions:
    - name: "Action Notes"
      display_name: "Action notes"
      expr: action_notes
    - name: "Action Number"
      display_name: "Action number"
      expr: action_number
    - name: "Action Status"
      display_name: "Action status"
      expr: action_status
    - name: "Action Type"
      display_name: "Action type"
      expr: action_type
    - name: "Clearance Method"
      display_name: "Clearance method"
      expr: clearance_method
    - name: "Completed Date"
      display_name: "Completed date"
      expr: completed_date
    - name: "Cot Break Indicator"
      display_name: "Cot break indicator"
      expr: cot_break_indicator
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Defect Severity"
      display_name: "Defect severity"
      expr: defect_severity
    - name: "Defect Type"
      display_name: "Defect type"
      expr: defect_type
    - name: "Due Date"
      display_name: "Due date"
      expr: due_date
    - name: "Erecording Used"
      display_name: "Erecording used"
      expr: erecording_used
    - name: "Escalated Date"
      display_name: "Escalated date"
      expr: escalated_date
    - name: "Evidence Received"
      display_name: "Evidence received"
      expr: evidence_received
    - name: "Evidence Received Date"
      display_name: "Evidence received date"
      expr: evidence_received_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Operations Curative Action"
      display_name: "Distinct operations curative action"
      expr: COUNT(DISTINCT operations_curative_action_id)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Days Open"
      display_name: "Total days open"
      expr: SUM(days_open)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Days Open"
      display_name: "Average days open"
      expr: AVG(days_open)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Payoff Amount"
      display_name: "Total payoff amount"
      expr: SUM(payoff_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Payoff Amount"
      display_name: "Average payoff amount"
      expr: AVG(payoff_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Sla Target Days"
      display_name: "Total sla target days"
      expr: SUM(sla_target_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sla Target Days"
      display_name: "Average sla target days"
      expr: AVG(sla_target_days)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`operations_operations_title_examination`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Operations Title Examination business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination`"
  dimensions:
    - name: "Cot Break Description"
      display_name: "Cot break description"
      expr: cot_break_description
    - name: "Cot Break Detected"
      display_name: "Cot break detected"
      expr: cot_break_detected
    - name: "Cot Start Date"
      display_name: "Cot start date"
      expr: cot_start_date
    - name: "County Name"
      display_name: "County name"
      expr: county_name
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Evidence Completeness Flag"
      display_name: "Evidence completeness flag"
      expr: evidence_completeness_flag
    - name: "Examination Complete Timestamp"
      display_name: "Examination complete timestamp"
      expr: examination_complete_timestamp
    - name: "Examination Date"
      display_name: "Examination date"
      expr: examination_date
    - name: "Examination Number"
      display_name: "Examination number"
      expr: examination_number
    - name: "Examination Start Timestamp"
      display_name: "Examination start timestamp"
      expr: examination_start_timestamp
    - name: "Examination Status"
      display_name: "Examination status"
      expr: examination_status
    - name: "Examination Type"
      display_name: "Examination type"
      expr: examination_type
    - name: "Examiner License Number"
      display_name: "Examiner license number"
      expr: examiner_license_number
    - name: "Examiner Name"
      display_name: "Examiner name"
      expr: examiner_name
    - name: "Examiner Notes"
      display_name: "Examiner notes"
      expr: examiner_notes
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Operations Title Examination"
      display_name: "Distinct operations title examination"
      expr: COUNT(DISTINCT operations_title_examination_id)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Defect Count"
      display_name: "Total defect count"
      expr: SUM(defect_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Defect Count"
      display_name: "Average defect count"
      expr: AVG(defect_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Easement Count"
      display_name: "Total easement count"
      expr: SUM(easement_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Easement Count"
      display_name: "Average easement count"
      expr: AVG(easement_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Exception Count"
      display_name: "Total exception count"
      expr: SUM(exception_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Exception Count"
      display_name: "Average exception count"
      expr: AVG(exception_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Lien Count"
      display_name: "Total lien count"
      expr: SUM(lien_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Lien Count"
      display_name: "Average lien count"
      expr: AVG(lien_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Open Lien Amount"
      display_name: "Total open lien amount"
      expr: SUM(open_lien_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Open Lien Amount"
      display_name: "Average open lien amount"
      expr: AVG(open_lien_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Requirement Count"
      display_name: "Total requirement count"
      expr: SUM(requirement_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Requirement Count"
      display_name: "Average requirement count"
      expr: AVG(requirement_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Revision Number"
      display_name: "Total revision number"
      expr: SUM(revision_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Revision Number"
      display_name: "Average revision number"
      expr: AVG(revision_number)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`operations_order_channel`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Order Channel business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_channel`"
  dimensions:
    - name: "Affiliated Business Arrangement"
      display_name: "Affiliated business arrangement"
      expr: affiliated_business_arrangement
    - name: "Channel Category"
      display_name: "Channel category"
      expr: channel_category
    - name: "Channel Code"
      display_name: "Channel code"
      expr: channel_code
    - name: "Channel Description"
      display_name: "Channel description"
      expr: channel_description
    - name: "Channel Name"
      display_name: "Channel name"
      expr: channel_name
    - name: "Channel Owner Email"
      display_name: "Channel owner email"
      expr: channel_owner_email
    - name: "Channel Owner Name"
      display_name: "Channel owner name"
      expr: channel_owner_name
    - name: "Channel Status"
      display_name: "Channel status"
      expr: channel_status
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Closing Disclosure Form Type"
      display_name: "Closing disclosure form type"
      expr: closing_disclosure_form_type
    - name: "Cost Center Code"
      display_name: "Cost center code"
      expr: cost_center_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Default Transaction Type"
      display_name: "Default transaction type"
      expr: default_transaction_type
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Erecording Enabled"
      display_name: "Erecording enabled"
      expr: erecording_enabled
    - name: "Escrow Handling Type"
      display_name: "Escrow handling type"
      expr: escrow_handling_type
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Order Channel"
      display_name: "Distinct order channel"
      expr: COUNT(DISTINCT order_channel_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Routing Priority"
      display_name: "Total routing priority"
      expr: SUM(routing_priority)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Routing Priority"
      display_name: "Average routing priority"
      expr: AVG(routing_priority)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Sla Commitment Hours"
      display_name: "Total sla commitment hours"
      expr: SUM(sla_commitment_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sla Commitment Hours"
      display_name: "Average sla commitment hours"
      expr: AVG(sla_commitment_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Sla Intake Hours"
      display_name: "Total sla intake hours"
      expr: SUM(sla_intake_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sla Intake Hours"
      display_name: "Average sla intake hours"
      expr: AVG(sla_intake_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Sla Search Hours"
      display_name: "Total sla search hours"
      expr: SUM(sla_search_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sla Search Hours"
      display_name: "Average sla search hours"
      expr: AVG(sla_search_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Underwriter Referral Threshold Usd"
      display_name: "Total underwriter referral threshold usd"
      expr: SUM(underwriter_referral_threshold_usd)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Underwriter Referral Threshold Usd"
      display_name: "Average underwriter referral threshold usd"
      expr: AVG(underwriter_referral_threshold_usd)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Version Number"
      display_name: "Total version number"
      expr: SUM(version_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Version Number"
      display_name: "Average version number"
      expr: AVG(version_number)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`operations_order_status_history`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Order Status History business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history`"
  dimensions:
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Closing Readiness Status"
      display_name: "Closing readiness status"
      expr: closing_readiness_status
    - name: "Cot Break Identified"
      display_name: "Cot break identified"
      expr: cot_break_identified
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Erecording Enabled"
      display_name: "Erecording enabled"
      expr: erecording_enabled
    - name: "Escrow Officer Name"
      display_name: "Escrow officer name"
      expr: escrow_officer_name
    - name: "Gap Coverage Required"
      display_name: "Gap coverage required"
      expr: gap_coverage_required
    - name: "Is Current"
      display_name: "Is current"
      expr: is_current
    - name: "Is Regression"
      display_name: "Is regression"
      expr: is_regression
    - name: "New Status"
      display_name: "New status"
      expr: new_status
    - name: "Notes"
      display_name: "Notes"
      expr: notes
    - name: "Order Number"
      display_name: "Order number"
      expr: order_number
    - name: "Policy Exception Required"
      display_name: "Policy exception required"
      expr: policy_exception_required
    - name: "Prior Status"
      display_name: "Prior status"
      expr: prior_status
    - name: "Regression Reason Code"
      display_name: "Regression reason code"
      expr: regression_reason_code
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Order Status History"
      display_name: "Distinct order status history"
      expr: COUNT(DISTINCT order_status_history_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Commitment Revision Number"
      display_name: "Total commitment revision number"
      expr: SUM(commitment_revision_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Commitment Revision Number"
      display_name: "Average commitment revision number"
      expr: AVG(commitment_revision_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Duration In Prior Status Hours"
      display_name: "Total duration in prior status hours"
      expr: SUM(duration_in_prior_status_hours)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Duration In Prior Status Hours"
      display_name: "Average duration in prior status hours"
      expr: AVG(duration_in_prior_status_hours)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Open Finding Count"
      display_name: "Total open finding count"
      expr: SUM(open_finding_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Open Finding Count"
      display_name: "Average open finding count"
      expr: AVG(open_finding_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Open Requirement Count"
      display_name: "Total open requirement count"
      expr: SUM(open_requirement_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Open Requirement Count"
      display_name: "Average open requirement count"
      expr: AVG(open_requirement_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Sequence Number"
      display_name: "Total sequence number"
      expr: SUM(sequence_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sequence Number"
      display_name: "Average sequence number"
      expr: AVG(sequence_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Sla Breach Hours"
      display_name: "Total sla breach hours"
      expr: SUM(sla_breach_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sla Breach Hours"
      display_name: "Average sla breach hours"
      expr: AVG(sla_breach_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Sla Target Hours"
      display_name: "Total sla target hours"
      expr: SUM(sla_target_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sla Target Hours"
      display_name: "Average sla target hours"
      expr: AVG(sla_target_hours)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`operations_party`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Party business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`"
  dimensions:
    - name: "Code"
      display_name: "Code"
      expr: party_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Date Of Birth"
      display_name: "Date of birth"
      expr: date_of_birth
    - name: "Dba Name"
      display_name: "Dba name"
      expr: dba_name
    - name: "Deceased Date"
      display_name: "Deceased date"
      expr: deceased_date
    - name: "Entity Formation Date"
      display_name: "Entity formation date"
      expr: entity_formation_date
    - name: "Entity Formation State"
      display_name: "Entity formation state"
      expr: entity_formation_state
    - name: "Fax Number"
      display_name: "Fax number"
      expr: fax_number
    - name: "First Name"
      display_name: "First name"
      expr: first_name
    - name: "Identity Doc Ref"
      display_name: "Identity doc ref"
      expr: identity_doc_ref
    - name: "Is Deceased"
      display_name: "Is deceased"
      expr: is_deceased
    - name: "Is Do Not Contact"
      display_name: "Is do not contact"
      expr: is_do_not_contact
    - name: "Is Foreign National"
      display_name: "Is foreign national"
      expr: is_foreign_national
    - name: "Is Nppi Consent Given"
      display_name: "Is nppi consent given"
      expr: is_nppi_consent_given
    - name: "Last Name"
      display_name: "Last name"
      expr: last_name
    - name: "Legal Name"
      display_name: "Legal name"
      expr: legal_name
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Party"
      display_name: "Distinct party"
      expr: COUNT(DISTINCT party_id)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`operations_party_role`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Party Role business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Aml Screening Date"
      display_name: "Aml screening date"
      expr: aml_screening_date
    - name: "Aml Screening Status"
      display_name: "Aml screening status"
      expr: aml_screening_status
    - name: "Authority Document Ref"
      display_name: "Authority document ref"
      expr: authority_document_ref
    - name: "Authority Type"
      display_name: "Authority type"
      expr: authority_type
    - name: "Code"
      display_name: "Code"
      expr: party_role_code
    - name: "Cpl Required"
      display_name: "Cpl required"
      expr: cpl_required
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
    - name: "Firpta Withholding Required"
      display_name: "Firpta withholding required"
      expr: firpta_withholding_required
    - name: "Foreign National Flag"
      display_name: "Foreign national flag"
      expr: foreign_national_flag
    - name: "Identity Verification Date"
      display_name: "Identity verification date"
      expr: identity_verification_date
    - name: "Identity Verification Method"
      display_name: "Identity verification method"
      expr: identity_verification_method
    - name: "Identity Verified"
      display_name: "Identity verified"
      expr: identity_verified
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Party Role"
      display_name: "Distinct party role"
      expr: COUNT(DISTINCT party_role_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Ownership Percentage"
      display_name: "Total ownership percentage"
      expr: SUM(ownership_percentage)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Ownership Percentage"
      display_name: "Average ownership percentage"
      expr: AVG(ownership_percentage)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Revision Number"
      display_name: "Total revision number"
      expr: SUM(revision_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Revision Number"
      display_name: "Average revision number"
      expr: AVG(revision_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Role Sequence"
      display_name: "Total role sequence"
      expr: SUM(role_sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Role Sequence"
      display_name: "Average role sequence"
      expr: AVG(role_sequence)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`operations_service_level`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Service Level business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_operations`.`service_level`"
  dimensions:
    - name: "Approval Date"
      display_name: "Approval date"
      expr: approval_date
    - name: "Approved By"
      display_name: "Approved by"
      expr: approved_by
    - name: "Breach Penalty Applicable"
      display_name: "Breach penalty applicable"
      expr: breach_penalty_applicable
    - name: "Breach Penalty Description"
      display_name: "Breach penalty description"
      expr: breach_penalty_description
    - name: "Business Hours End"
      display_name: "Business hours end"
      expr: business_hours_end
    - name: "Business Hours Start"
      display_name: "Business hours start"
      expr: business_hours_start
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Closing Disclosure Form Type"
      display_name: "Closing disclosure form type"
      expr: closing_disclosure_form_type
    - name: "Commitment Form Type"
      display_name: "Commitment form type"
      expr: commitment_form_type
    - name: "Cpl Required"
      display_name: "Cpl required"
      expr: cpl_required
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Erecording Required"
      display_name: "Erecording required"
      expr: erecording_required
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
    - name: "Gap Coverage Required"
      display_name: "Gap coverage required"
      expr: gap_coverage_required
    - name: "Iolta Required"
      display_name: "Iolta required"
      expr: iolta_required
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Service Level"
      display_name: "Distinct service level"
      expr: COUNT(DISTINCT service_level_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Closing Readiness Hours Target"
      display_name: "Total closing readiness hours target"
      expr: SUM(closing_readiness_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Closing Readiness Hours Target"
      display_name: "Average closing readiness hours target"
      expr: AVG(closing_readiness_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Commitment Hours Target"
      display_name: "Total commitment hours target"
      expr: SUM(commitment_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Commitment Hours Target"
      display_name: "Average commitment hours target"
      expr: AVG(commitment_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Curative Hours Target"
      display_name: "Total curative hours target"
      expr: SUM(curative_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Curative Hours Target"
      display_name: "Average curative hours target"
      expr: AVG(curative_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Escalation Threshold Hours"
      display_name: "Total escalation threshold hours"
      expr: SUM(escalation_threshold_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Escalation Threshold Hours"
      display_name: "Average escalation threshold hours"
      expr: AVG(escalation_threshold_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Examination Hours Target"
      display_name: "Total examination hours target"
      expr: SUM(examination_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Examination Hours Target"
      display_name: "Average examination hours target"
      expr: AVG(examination_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Intake Hours Target"
      display_name: "Total intake hours target"
      expr: SUM(intake_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Intake Hours Target"
      display_name: "Average intake hours target"
      expr: AVG(intake_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Policy Issuance Hours Target"
      display_name: "Total policy issuance hours target"
      expr: SUM(policy_issuance_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Issuance Hours Target"
      display_name: "Average policy issuance hours target"
      expr: AVG(policy_issuance_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Recording Submission Hours Target"
      display_name: "Total recording submission hours target"
      expr: SUM(recording_submission_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Recording Submission Hours Target"
      display_name: "Average recording submission hours target"
      expr: AVG(recording_submission_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Search Hours Target"
      display_name: "Total search hours target"
      expr: SUM(search_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Search Hours Target"
      display_name: "Average search hours target"
      expr: AVG(search_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Search Years Required"
      display_name: "Total search years required"
      expr: SUM(search_years_required)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Search Years Required"
      display_name: "Average search years required"
      expr: AVG(search_years_required)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Total Order Hours Target"
      display_name: "Total total order hours target"
      expr: SUM(total_order_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Total Order Hours Target"
      display_name: "Average total order hours target"
      expr: AVG(total_order_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Uw Referral Threshold Usd"
      display_name: "Total uw referral threshold usd"
      expr: SUM(uw_referral_threshold_usd)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Uw Referral Threshold Usd"
      display_name: "Average uw referral threshold usd"
      expr: AVG(uw_referral_threshold_usd)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`operations_title_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Title Order business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`"
  dimensions:
    - name: "Actual Closing Date"
      display_name: "Actual closing date"
      expr: actual_closing_date
    - name: "Apn"
      display_name: "Apn"
      expr: apn
    - name: "Buyer Name"
      display_name: "Buyer name"
      expr: buyer_name
    - name: "Cancellation Date"
      display_name: "Cancellation date"
      expr: cancellation_date
    - name: "Cancellation Reason"
      display_name: "Cancellation reason"
      expr: cancellation_reason
    - name: "Closing Disclosure Form Type"
      display_name: "Closing disclosure form type"
      expr: closing_disclosure_form_type
    - name: "County Name"
      display_name: "County name"
      expr: county_name
    - name: "Cpl Required"
      display_name: "Cpl required"
      expr: cpl_required
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Erecording Enabled"
      display_name: "Erecording enabled"
      expr: erecording_enabled
    - name: "Escrow Officer Name"
      display_name: "Escrow officer name"
      expr: escrow_officer_name
    - name: "Fips Code"
      display_name: "Fips code"
      expr: fips_code
    - name: "Iolta Required"
      display_name: "Iolta required"
      expr: iolta_required
    - name: "Lender Loan Number"
      display_name: "Lender loan number"
      expr: lender_loan_number
    - name: "Lender Name"
      display_name: "Lender name"
      expr: lender_name
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Title Order"
      display_name: "Distinct title order"
      expr: COUNT(DISTINCT title_order_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Loan Amount"
      display_name: "Total loan amount"
      expr: SUM(loan_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Loan Amount"
      display_name: "Average loan amount"
      expr: AVG(loan_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Ltv Ratio"
      display_name: "Total ltv ratio"
      expr: SUM(ltv_ratio)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Ltv Ratio"
      display_name: "Average ltv ratio"
      expr: AVG(ltv_ratio)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Sales Price Amount"
      display_name: "Total sales price amount"
      expr: SUM(sales_price_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Sales Price Amount"
      display_name: "Average sales price amount"
      expr: AVG(sales_price_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`operations_title_search`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Title Search business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search`"
  dimensions:
    - name: "Apn"
      display_name: "Apn"
      expr: apn
    - name: "Cancellation Reason"
      display_name: "Cancellation reason"
      expr: cancellation_reason
    - name: "Cancelled Timestamp"
      display_name: "Cancelled timestamp"
      expr: cancelled_timestamp
    - name: "Completed Timestamp"
      display_name: "Completed timestamp"
      expr: completed_timestamp
    - name: "Cot Break Description"
      display_name: "Cot break description"
      expr: cot_break_description
    - name: "Cot Break Detected"
      display_name: "Cot break detected"
      expr: cot_break_detected
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Easement Found"
      display_name: "Easement found"
      expr: easement_found
    - name: "Encroachment Found"
      display_name: "Encroachment found"
      expr: encroachment_found
    - name: "Gap Period End Date"
      display_name: "Gap period end date"
      expr: gap_period_end_date
    - name: "Gap Period Start Date"
      display_name: "Gap period start date"
      expr: gap_period_start_date
    - name: "Hoa Lien Found"
      display_name: "Hoa lien found"
      expr: hoa_lien_found
    - name: "Is Automated Search"
      display_name: "Is automated search"
      expr: is_automated_search
    - name: "Is Sla Breached"
      display_name: "Is sla breached"
      expr: is_sla_breached
    - name: "Lis Pendens Found"
      display_name: "Lis pendens found"
      expr: lis_pendens_found
    - name: "Ordered Date"
      display_name: "Ordered date"
      expr: ordered_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Title Search"
      display_name: "Distinct title search"
      expr: COUNT(DISTINCT title_search_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Cot Start Year"
      display_name: "Total cot start year"
      expr: SUM(cot_start_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Cot Start Year"
      display_name: "Average cot start year"
      expr: AVG(cot_start_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Instrument Count"
      display_name: "Total instrument count"
      expr: SUM(instrument_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Instrument Count"
      display_name: "Average instrument count"
      expr: AVG(instrument_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Open Judgment Count"
      display_name: "Total open judgment count"
      expr: SUM(open_judgment_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Open Judgment Count"
      display_name: "Average open judgment count"
      expr: AVG(open_judgment_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Open Lien Count"
      display_name: "Total open lien count"
      expr: SUM(open_lien_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Open Lien Count"
      display_name: "Average open lien count"
      expr: AVG(open_lien_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Revision Number"
      display_name: "Total revision number"
      expr: SUM(revision_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Revision Number"
      display_name: "Average revision number"
      expr: AVG(revision_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Search Fee Amount"
      display_name: "Total search fee amount"
      expr: SUM(search_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Search Fee Amount"
      display_name: "Average search fee amount"
      expr: AVG(search_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Sla Hours Target"
      display_name: "Total sla hours target"
      expr: SUM(sla_hours_target)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sla Hours Target"
      display_name: "Average sla hours target"
      expr: AVG(sla_hours_target)
      format:
        type: number
        decimal_places:
          type: all
$$;
