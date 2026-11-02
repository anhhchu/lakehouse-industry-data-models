-- Metric views for domain: agency | Business: Title_Insurance | Version: 1 | Generated on: 2026-10-31 06:37:34

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_agent_authority`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Agent Authority business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_authority`"
  dimensions:
    - name: "Approval Date"
      display_name: "Approval date"
      expr: approval_date
    - name: "Approval Status"
      display_name: "Approval status"
      expr: approval_status
    - name: "Approved By"
      display_name: "Approved by"
      expr: approved_by
    - name: "Authority Notes"
      display_name: "Authority notes"
      expr: authority_notes
    - name: "Authority Number"
      display_name: "Authority number"
      expr: authority_number
    - name: "Authority Status"
      display_name: "Authority status"
      expr: authority_status
    - name: "Authority Tier"
      display_name: "Authority tier"
      expr: authority_tier
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Cpl Authority Flag"
      display_name: "Cpl authority flag"
      expr: cpl_authority_flag
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Endorsement Authority Flag"
      display_name: "Endorsement authority flag"
      expr: endorsement_authority_flag
    - name: "Eo Expiration Date"
      display_name: "Eo expiration date"
      expr: eo_expiration_date
    - name: "Eo Policy Number"
      display_name: "Eo policy number"
      expr: eo_policy_number
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Agent Authority"
      display_name: "Distinct agent authority"
      expr: COUNT(DISTINCT agent_authority_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Agent Premium Split Pct"
      display_name: "Total agent premium split pct"
      expr: SUM(agent_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Agent Premium Split Pct"
      display_name: "Average agent premium split pct"
      expr: AVG(agent_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Commercial Max Insured Amount"
      display_name: "Total commercial max insured amount"
      expr: SUM(commercial_max_insured_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Commercial Max Insured Amount"
      display_name: "Average commercial max insured amount"
      expr: AVG(commercial_max_insured_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Eo Coverage Amount"
      display_name: "Total eo coverage amount"
      expr: SUM(eo_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Eo Coverage Amount"
      display_name: "Average eo coverage amount"
      expr: AVG(eo_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Max Insured Amount"
      display_name: "Total max insured amount"
      expr: SUM(max_insured_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Max Insured Amount"
      display_name: "Average max insured amount"
      expr: AVG(max_insured_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Remittance Due Day"
      display_name: "Total remittance due day"
      expr: SUM(remittance_due_day)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Remittance Due Day"
      display_name: "Average remittance due day"
      expr: AVG(remittance_due_day)
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
    - name: "Total Underwriter Code"
      display_name: "Total underwriter code"
      expr: SUM(underwriter_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Underwriter Code"
      display_name: "Average underwriter code"
      expr: AVG(underwriter_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Underwriter Premium Split Pct"
      display_name: "Total underwriter premium split pct"
      expr: SUM(underwriter_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Underwriter Premium Split Pct"
      display_name: "Average underwriter premium split pct"
      expr: AVG(underwriter_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Uwref Threshold Amount"
      display_name: "Total uwref threshold amount"
      expr: SUM(uwref_threshold_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Uwref Threshold Amount"
      display_name: "Average uwref threshold amount"
      expr: AVG(uwref_threshold_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_agent_license`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Agent License business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_license`"
  dimensions:
    - name: "Appointment Date"
      display_name: "Appointment date"
      expr: appointment_date
    - name: "Appointment Termination Date"
      display_name: "Appointment termination date"
      expr: appointment_termination_date
    - name: "Authority Hold Flag"
      display_name: "Authority hold flag"
      expr: authority_hold_flag
    - name: "Authority Hold Reason"
      display_name: "Authority hold reason"
      expr: authority_hold_reason
    - name: "Background Check Date"
      display_name: "Background check date"
      expr: background_check_date
    - name: "Background Check Status"
      display_name: "Background check status"
      expr: background_check_status
    - name: "Ce Compliance Status"
      display_name: "Ce compliance status"
      expr: ce_compliance_status
    - name: "Continuing Education Required"
      display_name: "Continuing education required"
      expr: continuing_education_required
    - name: "Domicile State Code"
      display_name: "Domicile state code"
      expr: domicile_state_code
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Eo Carrier Name"
      display_name: "Eo carrier name"
      expr: eo_carrier_name
    - name: "Eo Expiration Date"
      display_name: "Eo expiration date"
      expr: eo_expiration_date
    - name: "Eo Policy Number"
      display_name: "Eo policy number"
      expr: eo_policy_number
    - name: "Eo Verified Date"
      display_name: "Eo verified date"
      expr: eo_verified_date
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
    - name: "Issue Date"
      display_name: "Issue date"
      expr: issue_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Agent License"
      display_name: "Distinct agent license"
      expr: COUNT(DISTINCT agent_license_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Appointing Underwriter Code"
      display_name: "Total appointing underwriter code"
      expr: SUM(appointing_underwriter_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Appointing Underwriter Code"
      display_name: "Average appointing underwriter code"
      expr: AVG(appointing_underwriter_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Ce Credit Hours Completed"
      display_name: "Total ce credit hours completed"
      expr: SUM(ce_credit_hours_completed)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Ce Credit Hours Completed"
      display_name: "Average ce credit hours completed"
      expr: AVG(ce_credit_hours_completed)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Ce Credit Hours Required"
      display_name: "Total ce credit hours required"
      expr: SUM(ce_credit_hours_required)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Ce Credit Hours Required"
      display_name: "Average ce credit hours required"
      expr: AVG(ce_credit_hours_required)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Eo Coverage Amount"
      display_name: "Total eo coverage amount"
      expr: SUM(eo_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Eo Coverage Amount"
      display_name: "Average eo coverage amount"
      expr: AVG(eo_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total License Revision Number"
      display_name: "Total license revision number"
      expr: SUM(license_revision_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average License Revision Number"
      display_name: "Average license revision number"
      expr: AVG(license_revision_number)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_agent_profile`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Agent Profile business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`"
  dimensions:
    - name: "Agency Agreement Number"
      display_name: "Agency agreement number"
      expr: agency_agreement_number
    - name: "Agent Code"
      display_name: "Agent code"
      expr: agent_code
    - name: "Agent Status"
      display_name: "Agent status"
      expr: agent_status
    - name: "Agent Type"
      display_name: "Agent type"
      expr: agent_type
    - name: "Alta Best Practices Certified"
      display_name: "Alta best practices certified"
      expr: alta_best_practices_certified
    - name: "Alta Certification Date"
      display_name: "Alta certification date"
      expr: alta_certification_date
    - name: "Alta Certification Expiration Date"
      display_name: "Alta certification expiration date"
      expr: alta_certification_expiration_date
    - name: "Appointment Effective Date"
      display_name: "Appointment effective date"
      expr: appointment_effective_date
    - name: "Appointment Expiration Date"
      display_name: "Appointment expiration date"
      expr: appointment_expiration_date
    - name: "Authority Level"
      display_name: "Authority level"
      expr: authority_level
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Cpl Authority Flag"
      display_name: "Cpl authority flag"
      expr: cpl_authority_flag
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Dba Name"
      display_name: "Dba name"
      expr: dba_name
    - name: "Eo Carrier Name"
      display_name: "Eo carrier name"
      expr: eo_carrier_name
    - name: "Eo Expiration Date"
      display_name: "Eo expiration date"
      expr: eo_expiration_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Agent Profile"
      display_name: "Distinct agent profile"
      expr: COUNT(DISTINCT agent_profile_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Agent Premium Split Pct"
      display_name: "Total agent premium split pct"
      expr: SUM(agent_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Agent Premium Split Pct"
      display_name: "Average agent premium split pct"
      expr: AVG(agent_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Eo Coverage Amount"
      display_name: "Total eo coverage amount"
      expr: SUM(eo_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Eo Coverage Amount"
      display_name: "Average eo coverage amount"
      expr: AVG(eo_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Fidelity Bond Amount"
      display_name: "Total fidelity bond amount"
      expr: SUM(fidelity_bond_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Fidelity Bond Amount"
      display_name: "Average fidelity bond amount"
      expr: AVG(fidelity_bond_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Max Policy Liability Amount"
      display_name: "Total max policy liability amount"
      expr: SUM(max_policy_liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Max Policy Liability Amount"
      display_name: "Average max policy liability amount"
      expr: AVG(max_policy_liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Remittance Due Day"
      display_name: "Total remittance due day"
      expr: SUM(remittance_due_day)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Remittance Due Day"
      display_name: "Average remittance due day"
      expr: AVG(remittance_due_day)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Underwriter Split Pct"
      display_name: "Total underwriter split pct"
      expr: SUM(underwriter_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Underwriter Split Pct"
      display_name: "Average underwriter split pct"
      expr: AVG(underwriter_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_agent_remittance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Agent Remittance business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_remittance`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Due Date"
      display_name: "Due date"
      expr: due_date
    - name: "Exception Flag"
      display_name: "Exception flag"
      expr: exception_flag
    - name: "Exception Reason"
      display_name: "Exception reason"
      expr: exception_reason
    - name: "Gl Batch Reference"
      display_name: "Gl batch reference"
      expr: gl_batch_reference
    - name: "Is Late"
      display_name: "Is late"
      expr: is_late
    - name: "Notes"
      display_name: "Notes"
      expr: notes
    - name: "Payment Method"
      display_name: "Payment method"
      expr: payment_method
    - name: "Payment Reference"
      display_name: "Payment reference"
      expr: payment_reference
    - name: "Period End Date"
      display_name: "Period end date"
      expr: period_end_date
    - name: "Period Start Date"
      display_name: "Period start date"
      expr: period_start_date
    - name: "Reconciliation Date"
      display_name: "Reconciliation date"
      expr: reconciliation_date
    - name: "Reconciliation Status"
      display_name: "Reconciliation status"
      expr: reconciliation_status
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Agent Remittance"
      display_name: "Distinct agent remittance"
      expr: COUNT(DISTINCT agent_remittance_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Agent Retained Amount"
      display_name: "Total agent retained amount"
      expr: SUM(agent_retained_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Agent Retained Amount"
      display_name: "Average agent retained amount"
      expr: AVG(agent_retained_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Amount Received"
      display_name: "Total amount received"
      expr: SUM(amount_received)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Amount Received"
      display_name: "Average amount received"
      expr: AVG(amount_received)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Cpl Fee Amount"
      display_name: "Total cpl fee amount"
      expr: SUM(cpl_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Cpl Fee Amount"
      display_name: "Average cpl fee amount"
      expr: AVG(cpl_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Days Past Due"
      display_name: "Total days past due"
      expr: SUM(days_past_due)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Days Past Due"
      display_name: "Average days past due"
      expr: AVG(days_past_due)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Endorsement Premium Amount"
      display_name: "Total endorsement premium amount"
      expr: SUM(endorsement_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Endorsement Premium Amount"
      display_name: "Average endorsement premium amount"
      expr: AVG(endorsement_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Gross Premium Amount"
      display_name: "Total gross premium amount"
      expr: SUM(gross_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Gross Premium Amount"
      display_name: "Average gross premium amount"
      expr: AVG(gross_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Late Fee Amount"
      display_name: "Total late fee amount"
      expr: SUM(late_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Late Fee Amount"
      display_name: "Average late fee amount"
      expr: AVG(late_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Ltp Count"
      display_name: "Total ltp count"
      expr: SUM(ltp_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Ltp Count"
      display_name: "Average ltp count"
      expr: AVG(ltp_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Net Remittance Amount"
      display_name: "Total net remittance amount"
      expr: SUM(net_remittance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Net Remittance Amount"
      display_name: "Average net remittance amount"
      expr: AVG(net_remittance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Otp Count"
      display_name: "Total otp count"
      expr: SUM(otp_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Otp Count"
      display_name: "Average otp count"
      expr: AVG(otp_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Policy Count"
      display_name: "Total policy count"
      expr: SUM(policy_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Count"
      display_name: "Average policy count"
      expr: AVG(policy_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Reissue Credit Amount"
      display_name: "Total reissue credit amount"
      expr: SUM(reissue_credit_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Reissue Credit Amount"
      display_name: "Average reissue credit amount"
      expr: AVG(reissue_credit_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_agreement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Agreement business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`"
  dimensions:
    - name: "Agreement Status"
      display_name: "Agreement status"
      expr: agreement_status
    - name: "Agreement Type"
      display_name: "Agreement type"
      expr: agreement_type
    - name: "Audit Frequency"
      display_name: "Audit frequency"
      expr: audit_frequency
    - name: "Authority Level"
      display_name: "Authority level"
      expr: authority_level
    - name: "Auto Renewal Flag"
      display_name: "Auto renewal flag"
      expr: auto_renewal_flag
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Commercial Authority Flag"
      display_name: "Commercial authority flag"
      expr: commercial_authority_flag
    - name: "Cpl Authority Flag"
      display_name: "Cpl authority flag"
      expr: cpl_authority_flag
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Current Version Number"
      display_name: "Current version number"
      expr: current_version_number
    - name: "Document Reference Code"
      display_name: "Document reference code"
      expr: document_reference_code
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Endorsement Authority Flag"
      display_name: "Endorsement authority flag"
      expr: endorsement_authority_flag
    - name: "Eo Carrier Name"
      display_name: "Eo carrier name"
      expr: eo_carrier_name
    - name: "Eo Expiration Date"
      display_name: "Eo expiration date"
      expr: eo_expiration_date
    - name: "Eo Policy Number"
      display_name: "Eo policy number"
      expr: eo_policy_number
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Agreement"
      display_name: "Distinct agreement"
      expr: COUNT(DISTINCT agreement_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Agent Premium Split Pct"
      display_name: "Total agent premium split pct"
      expr: SUM(agent_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Agent Premium Split Pct"
      display_name: "Average agent premium split pct"
      expr: AVG(agent_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Aggregate Liability Limit"
      display_name: "Total aggregate liability limit"
      expr: SUM(aggregate_liability_limit)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Aggregate Liability Limit"
      display_name: "Average aggregate liability limit"
      expr: AVG(aggregate_liability_limit)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Amendment Count"
      display_name: "Total amendment count"
      expr: SUM(amendment_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Amendment Count"
      display_name: "Average amendment count"
      expr: AVG(amendment_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Eo Coverage Amount"
      display_name: "Total eo coverage amount"
      expr: SUM(eo_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Eo Coverage Amount"
      display_name: "Average eo coverage amount"
      expr: AVG(eo_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Fidelity Bond Amount"
      display_name: "Total fidelity bond amount"
      expr: SUM(fidelity_bond_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Fidelity Bond Amount"
      display_name: "Average fidelity bond amount"
      expr: AVG(fidelity_bond_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Max Liability Amount"
      display_name: "Total max liability amount"
      expr: SUM(max_liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Max Liability Amount"
      display_name: "Average max liability amount"
      expr: AVG(max_liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Notice Period Days"
      display_name: "Total notice period days"
      expr: SUM(notice_period_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Notice Period Days"
      display_name: "Average notice period days"
      expr: AVG(notice_period_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Remittance Due Days"
      display_name: "Total remittance due days"
      expr: SUM(remittance_due_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Remittance Due Days"
      display_name: "Average remittance due days"
      expr: AVG(remittance_due_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Underwriter Premium Split Pct"
      display_name: "Total underwriter premium split pct"
      expr: SUM(underwriter_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Underwriter Premium Split Pct"
      display_name: "Average underwriter premium split pct"
      expr: AVG(underwriter_premium_split_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_cpl_issuance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Cpl Issuance business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance`"
  dimensions:
    - name: "Actual Closing Date"
      display_name: "Actual closing date"
      expr: actual_closing_date
    - name: "Agent License Number"
      display_name: "Agent license number"
      expr: agent_license_number
    - name: "Agent Name"
      display_name: "Agent name"
      expr: agent_name
    - name: "Agent State Code"
      display_name: "Agent state code"
      expr: agent_state_code
    - name: "Cancellation Date"
      display_name: "Cancellation date"
      expr: cancellation_date
    - name: "Cancellation Reason"
      display_name: "Cancellation reason"
      expr: cancellation_reason
    - name: "Claim Made Indicator"
      display_name: "Claim made indicator"
      expr: claim_made_indicator
    - name: "Closing Location"
      display_name: "Closing location"
      expr: closing_location
    - name: "Closing Officer Name"
      display_name: "Closing officer name"
      expr: closing_officer_name
    - name: "Cpl Fee Collected"
      display_name: "Cpl fee collected"
      expr: cpl_fee_collected
    - name: "Cpl Form Version"
      display_name: "Cpl form version"
      expr: cpl_form_version
    - name: "Cpl Number"
      display_name: "Cpl number"
      expr: cpl_number
    - name: "Cpl Status"
      display_name: "Cpl status"
      expr: cpl_status
    - name: "Cpl Type"
      display_name: "Cpl type"
      expr: cpl_type
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Delivery Confirmation Ref"
      display_name: "Delivery confirmation ref"
      expr: delivery_confirmation_ref
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Cpl Issuance"
      display_name: "Distinct cpl issuance"
      expr: COUNT(DISTINCT cpl_issuance_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Cpl Fee Amount"
      display_name: "Total cpl fee amount"
      expr: SUM(cpl_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Cpl Fee Amount"
      display_name: "Average cpl fee amount"
      expr: AVG(cpl_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
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
    - name: "Total Purchase Price"
      display_name: "Total purchase price"
      expr: SUM(purchase_price)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Purchase Price"
      display_name: "Average purchase price"
      expr: AVG(purchase_price)
      format:
        type: currency
        currency_code: USD
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
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_eo_coverage`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Eo Coverage business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`eo_coverage`"
  dimensions:
    - name: "Additional Insured Flag"
      display_name: "Additional insured flag"
      expr: additional_insured_flag
    - name: "Cancellation Date"
      display_name: "Cancellation date"
      expr: cancellation_date
    - name: "Cancellation Reason"
      display_name: "Cancellation reason"
      expr: cancellation_reason
    - name: "Carrier Naic Code"
      display_name: "Carrier naic code"
      expr: carrier_naic_code
    - name: "Carrier Name"
      display_name: "Carrier name"
      expr: carrier_name
    - name: "Certificate Holder Name"
      display_name: "Certificate holder name"
      expr: certificate_holder_name
    - name: "Certificate Number"
      display_name: "Certificate number"
      expr: certificate_number
    - name: "Coverage Gap Flag"
      display_name: "Coverage gap flag"
      expr: coverage_gap_flag
    - name: "Coverage Status"
      display_name: "Coverage status"
      expr: coverage_status
    - name: "Coverage Type"
      display_name: "Coverage type"
      expr: coverage_type
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Document Reference Code"
      display_name: "Document reference code"
      expr: document_reference_code
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
    - name: "Extended Reporting End Date"
      display_name: "Extended reporting end date"
      expr: extended_reporting_end_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Eo Coverage"
      display_name: "Distinct eo coverage"
      expr: COUNT(DISTINCT eo_coverage_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Aggregate Limit"
      display_name: "Total aggregate limit"
      expr: SUM(aggregate_limit)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Aggregate Limit"
      display_name: "Average aggregate limit"
      expr: AVG(aggregate_limit)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Coverage Gap Days"
      display_name: "Total coverage gap days"
      expr: SUM(coverage_gap_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Coverage Gap Days"
      display_name: "Average coverage gap days"
      expr: AVG(coverage_gap_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Days Until Expiration"
      display_name: "Total days until expiration"
      expr: SUM(days_until_expiration)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Days Until Expiration"
      display_name: "Average days until expiration"
      expr: AVG(days_until_expiration)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Deductible Amount"
      display_name: "Total deductible amount"
      expr: SUM(deductible_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Deductible Amount"
      display_name: "Average deductible amount"
      expr: AVG(deductible_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Minimum Required Aggregate"
      display_name: "Total minimum required aggregate"
      expr: SUM(minimum_required_aggregate)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Minimum Required Aggregate"
      display_name: "Average minimum required aggregate"
      expr: AVG(minimum_required_aggregate)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Minimum Required Per Occurrence"
      display_name: "Total minimum required per occurrence"
      expr: SUM(minimum_required_per_occurrence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Minimum Required Per Occurrence"
      display_name: "Average minimum required per occurrence"
      expr: AVG(minimum_required_per_occurrence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Per Occurrence Limit"
      display_name: "Total per occurrence limit"
      expr: SUM(per_occurrence_limit)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Per Occurrence Limit"
      display_name: "Average per occurrence limit"
      expr: AVG(per_occurrence_limit)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_oversight_review`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Oversight Review business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review`"
  dimensions:
    - name: "Authority Action Taken"
      display_name: "Authority action taken"
      expr: authority_action_taken
    - name: "Completion Date"
      display_name: "Completion date"
      expr: completion_date
    - name: "Corrective Action Due Date"
      display_name: "Corrective action due date"
      expr: corrective_action_due_date
    - name: "Corrective Action Received Date"
      display_name: "Corrective action received date"
      expr: corrective_action_received_date
    - name: "Corrective Action Required Flag"
      display_name: "Corrective action required flag"
      expr: corrective_action_required_flag
    - name: "Corrective Action Status"
      display_name: "Corrective action status"
      expr: corrective_action_status
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Critical Finding Flag"
      display_name: "Critical finding flag"
      expr: critical_finding_flag
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Eo Coverage Status"
      display_name: "Eo coverage status"
      expr: eo_coverage_status
    - name: "Eo Verified Flag"
      display_name: "Eo verified flag"
      expr: eo_verified_flag
    - name: "Escrow Audit Flag"
      display_name: "Escrow audit flag"
      expr: escrow_audit_flag
    - name: "Escrow Compliance Status"
      display_name: "Escrow compliance status"
      expr: escrow_compliance_status
    - name: "Finding Categories"
      display_name: "Finding categories"
      expr: finding_categories
    - name: "Findings Summary"
      display_name: "Findings summary"
      expr: findings_summary
    - name: "License Compliance Status"
      display_name: "License compliance status"
      expr: license_compliance_status
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Oversight Review"
      display_name: "Distinct oversight review"
      expr: COUNT(DISTINCT oversight_review_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Document Reference Code"
      display_name: "Total document reference code"
      expr: SUM(document_reference_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Document Reference Code"
      display_name: "Average document reference code"
      expr: AVG(document_reference_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Files Sampled Count"
      display_name: "Total files sampled count"
      expr: SUM(files_sampled_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Files Sampled Count"
      display_name: "Average files sampled count"
      expr: AVG(files_sampled_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Files With Findings Count"
      display_name: "Total files with findings count"
      expr: SUM(files_with_findings_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Files With Findings Count"
      display_name: "Average files with findings count"
      expr: AVG(files_with_findings_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Remittance Variance Amount"
      display_name: "Total remittance variance amount"
      expr: SUM(remittance_variance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Remittance Variance Amount"
      display_name: "Average remittance variance amount"
      expr: AVG(remittance_variance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_premium_split_schedule`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Premium Split Schedule business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule`"
  dimensions:
    - name: "Approval Date"
      display_name: "Approval date"
      expr: approval_date
    - name: "Approval Status"
      display_name: "Approval status"
      expr: approval_status
    - name: "Approved By"
      display_name: "Approved by"
      expr: approved_by
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
    - name: "Is Tiered Schedule"
      display_name: "Is tiered schedule"
      expr: is_tiered_schedule
    - name: "Notes"
      display_name: "Notes"
      expr: notes
    - name: "Policy Type"
      display_name: "Policy type"
      expr: policy_type
    - name: "Property Type Scope"
      display_name: "Property type scope"
      expr: property_type_scope
    - name: "Rate Source"
      display_name: "Rate source"
      expr: rate_source
    - name: "Reissue Credit Applies"
      display_name: "Reissue credit applies"
      expr: reissue_credit_applies
    - name: "Remittance Frequency"
      display_name: "Remittance frequency"
      expr: remittance_frequency
    - name: "Revision Reason"
      display_name: "Revision reason"
      expr: revision_reason
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Premium Split Schedule"
      display_name: "Distinct premium split schedule"
      expr: COUNT(DISTINCT premium_split_schedule_id)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Agent Split Rate"
      display_name: "Total agent split rate"
      expr: SUM(agent_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Agent Split Rate"
      display_name: "Average agent split rate"
      expr: AVG(agent_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Cpl Fee Split Rate"
      display_name: "Total cpl fee split rate"
      expr: SUM(cpl_fee_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Cpl Fee Split Rate"
      display_name: "Average cpl fee split rate"
      expr: AVG(cpl_fee_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Endorsement Split Rate"
      display_name: "Total endorsement split rate"
      expr: SUM(endorsement_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Endorsement Split Rate"
      display_name: "Average endorsement split rate"
      expr: AVG(endorsement_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Minimum Agent Remittance Amount"
      display_name: "Total minimum agent remittance amount"
      expr: SUM(minimum_agent_remittance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Minimum Agent Remittance Amount"
      display_name: "Average minimum agent remittance amount"
      expr: AVG(minimum_agent_remittance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Premium Ceiling Amount"
      display_name: "Total premium ceiling amount"
      expr: SUM(premium_ceiling_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Premium Ceiling Amount"
      display_name: "Average premium ceiling amount"
      expr: AVG(premium_ceiling_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Premium Floor Amount"
      display_name: "Total premium floor amount"
      expr: SUM(premium_floor_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Premium Floor Amount"
      display_name: "Average premium floor amount"
      expr: AVG(premium_floor_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Remittance Due Days"
      display_name: "Total remittance due days"
      expr: SUM(remittance_due_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Remittance Due Days"
      display_name: "Average remittance due days"
      expr: AVG(remittance_due_days)
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
    - name: "Total Tier Sequence"
      display_name: "Total tier sequence"
      expr: SUM(tier_sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Tier Sequence"
      display_name: "Average tier sequence"
      expr: AVG(tier_sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Underwriter Split Rate"
      display_name: "Total underwriter split rate"
      expr: SUM(underwriter_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Underwriter Split Rate"
      display_name: "Average underwriter split rate"
      expr: AVG(underwriter_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`agency_remittance_line`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Remittance Line business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line`"
  dimensions:
    - name: "Accepted Date"
      display_name: "Accepted date"
      expr: accepted_date
    - name: "Adjustment Reason"
      display_name: "Adjustment reason"
      expr: adjustment_reason
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Closing Date"
      display_name: "Closing date"
      expr: closing_date
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Gl Account Code"
      display_name: "Gl account code"
      expr: gl_account_code
    - name: "Is Late Remittance"
      display_name: "Is late remittance"
      expr: is_late_remittance
    - name: "Is Reissue Credit Applied"
      display_name: "Is reissue credit applied"
      expr: is_reissue_credit_applied
    - name: "Is Simultaneous Issue"
      display_name: "Is simultaneous issue"
      expr: is_simultaneous_issue
    - name: "Line Status"
      display_name: "Line status"
      expr: line_status
    - name: "Notes"
      display_name: "Notes"
      expr: notes
    - name: "Policy Effective Date"
      display_name: "Policy effective date"
      expr: policy_effective_date
    - name: "Policy Issue Date"
      display_name: "Policy issue date"
      expr: policy_issue_date
    - name: "Policy Number"
      display_name: "Policy number"
      expr: policy_number
    - name: "Policy Type"
      display_name: "Policy type"
      expr: policy_type
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Remittance Line"
      display_name: "Distinct remittance line"
      expr: COUNT(DISTINCT remittance_line_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Adjustment Amount"
      display_name: "Total adjustment amount"
      expr: SUM(adjustment_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Adjustment Amount"
      display_name: "Average adjustment amount"
      expr: AVG(adjustment_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Agent Premium Share"
      display_name: "Total agent premium share"
      expr: SUM(agent_premium_share)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Agent Premium Share"
      display_name: "Average agent premium share"
      expr: AVG(agent_premium_share)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Agent Split Rate"
      display_name: "Total agent split rate"
      expr: SUM(agent_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Agent Split Rate"
      display_name: "Average agent split rate"
      expr: AVG(agent_split_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Cpl Fee Amount"
      display_name: "Total cpl fee amount"
      expr: SUM(cpl_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Cpl Fee Amount"
      display_name: "Average cpl fee amount"
      expr: AVG(cpl_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Cpl Underwriter Share"
      display_name: "Total cpl underwriter share"
      expr: SUM(cpl_underwriter_share)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Cpl Underwriter Share"
      display_name: "Average cpl underwriter share"
      expr: AVG(cpl_underwriter_share)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Days Past Due"
      display_name: "Total days past due"
      expr: SUM(days_past_due)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Days Past Due"
      display_name: "Average days past due"
      expr: AVG(days_past_due)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Endorsement Premium Amount"
      display_name: "Total endorsement premium amount"
      expr: SUM(endorsement_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Endorsement Premium Amount"
      display_name: "Average endorsement premium amount"
      expr: AVG(endorsement_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Endorsement Underwriter Share"
      display_name: "Total endorsement underwriter share"
      expr: SUM(endorsement_underwriter_share)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Endorsement Underwriter Share"
      display_name: "Average endorsement underwriter share"
      expr: AVG(endorsement_underwriter_share)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Gross Premium Amount"
      display_name: "Total gross premium amount"
      expr: SUM(gross_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Gross Premium Amount"
      display_name: "Average gross premium amount"
      expr: AVG(gross_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Insured Amount"
      display_name: "Total insured amount"
      expr: SUM(insured_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Insured Amount"
      display_name: "Average insured amount"
      expr: AVG(insured_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Line Sequence"
      display_name: "Total line sequence"
      expr: SUM(line_sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Line Sequence"
      display_name: "Average line sequence"
      expr: AVG(line_sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Net Premium Amount"
      display_name: "Total net premium amount"
      expr: SUM(net_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Net Premium Amount"
      display_name: "Average net premium amount"
      expr: AVG(net_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;