-- Metric views for domain: recording | Business: Title_Insurance | Version: 1 | Generated on: 2026-10-31 06:37:34

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`recording_fee`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fee business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_recording`.`fee`"
  dimensions:
    - name: "Code"
      display_name: "Code"
      expr: fee_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Description"
      display_name: "Description"
      expr: fee_description
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Enacted Date"
      display_name: "Enacted date"
      expr: enacted_date
    - name: "Erecording Gateway"
      display_name: "Erecording gateway"
      expr: erecording_gateway
    - name: "Erecording Supported"
      display_name: "Erecording supported"
      expr: erecording_supported
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
    - name: "Fee Status"
      display_name: "Fee status"
      expr: fee_status
    - name: "Fee Type"
      display_name: "Fee type"
      expr: fee_type
    - name: "Indexing Fee Basis"
      display_name: "Indexing fee basis"
      expr: indexing_fee_basis
    - name: "Instrument Type"
      display_name: "Instrument type"
      expr: instrument_type
    - name: "Last Verified Date"
      display_name: "Last verified date"
      expr: last_verified_date
    - name: "Name"
      display_name: "Name"
      expr: fee_name
    - name: "Notes"
      display_name: "Notes"
      expr: notes
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Fee"
      display_name: "Distinct fee"
      expr: COUNT(DISTINCT fee_id)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Base Fee Amount"
      display_name: "Total base fee amount"
      expr: SUM(base_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Base Fee Amount"
      display_name: "Average base fee amount"
      expr: AVG(base_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Consideration Threshold Amount"
      display_name: "Total consideration threshold amount"
      expr: SUM(consideration_threshold_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Consideration Threshold Amount"
      display_name: "Average consideration threshold amount"
      expr: AVG(consideration_threshold_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Documentary Stamp Rate"
      display_name: "Total documentary stamp rate"
      expr: SUM(documentary_stamp_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Documentary Stamp Rate"
      display_name: "Average documentary stamp rate"
      expr: AVG(documentary_stamp_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Included Pages"
      display_name: "Total included pages"
      expr: SUM(included_pages)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Included Pages"
      display_name: "Average included pages"
      expr: AVG(included_pages)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Indexing Fee Amount"
      display_name: "Total indexing fee amount"
      expr: SUM(indexing_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Indexing Fee Amount"
      display_name: "Average indexing fee amount"
      expr: AVG(indexing_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Max Pages"
      display_name: "Total max pages"
      expr: SUM(max_pages)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Max Pages"
      display_name: "Average max pages"
      expr: AVG(max_pages)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Mortgage Tax Rate"
      display_name: "Total mortgage tax rate"
      expr: SUM(mortgage_tax_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Mortgage Tax Rate"
      display_name: "Average mortgage tax rate"
      expr: AVG(mortgage_tax_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Per Page Fee Amount"
      display_name: "Total per page fee amount"
      expr: SUM(per_page_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Per Page Fee Amount"
      display_name: "Average per page fee amount"
      expr: AVG(per_page_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Transfer Tax Per Unit Amount"
      display_name: "Total transfer tax per unit amount"
      expr: SUM(transfer_tax_per_unit_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Transfer Tax Per Unit Amount"
      display_name: "Average transfer tax per unit amount"
      expr: AVG(transfer_tax_per_unit_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Transfer Tax Rate"
      display_name: "Total transfer tax rate"
      expr: SUM(transfer_tax_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Transfer Tax Rate"
      display_name: "Average transfer tax rate"
      expr: AVG(transfer_tax_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Transfer Tax Unit Basis"
      display_name: "Total transfer tax unit basis"
      expr: SUM(transfer_tax_unit_basis)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Transfer Tax Unit Basis"
      display_name: "Average transfer tax unit basis"
      expr: AVG(transfer_tax_unit_basis)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`recording_gap_coverage_period`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Gap Coverage Period business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Book Number"
      display_name: "Book number"
      expr: book_number
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Closing Date"
      display_name: "Closing date"
      expr: closing_date
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Erecording Gateway"
      display_name: "Erecording gateway"
      expr: erecording_gateway
    - name: "Gap Close Date"
      display_name: "Gap close date"
      expr: gap_close_date
    - name: "Gap Cure Method"
      display_name: "Gap cure method"
      expr: gap_cure_method
    - name: "Gap Cure Notes"
      display_name: "Gap cure notes"
      expr: gap_cure_notes
    - name: "Gap Escalation Date"
      display_name: "Gap escalation date"
      expr: gap_escalation_date
    - name: "Gap Reference Number"
      display_name: "Gap reference number"
      expr: gap_reference_number
    - name: "Gap Risk Flag"
      display_name: "Gap risk flag"
      expr: gap_risk_flag
    - name: "Gap Start Date"
      display_name: "Gap start date"
      expr: gap_start_date
    - name: "Gap Status"
      display_name: "Gap status"
      expr: gap_status
    - name: "Gap Type"
      display_name: "Gap type"
      expr: gap_type
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Gap Coverage Period"
      display_name: "Distinct gap coverage period"
      expr: COUNT(DISTINCT gap_coverage_period_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Gap Coverage Amount"
      display_name: "Total gap coverage amount"
      expr: SUM(gap_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Gap Coverage Amount"
      display_name: "Average gap coverage amount"
      expr: AVG(gap_coverage_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Gap Duration Days"
      display_name: "Total gap duration days"
      expr: SUM(gap_duration_days)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Gap Duration Days"
      display_name: "Average gap duration days"
      expr: AVG(gap_duration_days)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Max Allowed Gap Days"
      display_name: "Total max allowed gap days"
      expr: SUM(max_allowed_gap_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Max Allowed Gap Days"
      display_name: "Average max allowed gap days"
      expr: AVG(max_allowed_gap_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Policy Issuance Lag Days"
      display_name: "Total policy issuance lag days"
      expr: SUM(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Issuance Lag Days"
      display_name: "Average policy issuance lag days"
      expr: AVG(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Record Version"
      display_name: "Total record version"
      expr: SUM(record_version)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Record Version"
      display_name: "Average record version"
      expr: AVG(record_version)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Rejection Count"
      display_name: "Total rejection count"
      expr: SUM(rejection_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Rejection Count"
      display_name: "Average rejection count"
      expr: AVG(rejection_count)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`recording_gateway_transaction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Gateway Transaction business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction`"
  dimensions:
    - name: "Acknowledgment Code"
      display_name: "Acknowledgment code"
      expr: acknowledgment_code
    - name: "Acknowledgment Timestamp"
      display_name: "Acknowledgment timestamp"
      expr: acknowledgment_timestamp
    - name: "Closing Date"
      display_name: "Closing date"
      expr: closing_date
    - name: "County Response Code"
      display_name: "County response code"
      expr: county_response_code
    - name: "County Response Message"
      display_name: "County response message"
      expr: county_response_message
    - name: "County Response Timestamp"
      display_name: "County response timestamp"
      expr: county_response_timestamp
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Document Type Codes"
      display_name: "Document type codes"
      expr: document_type_codes
    - name: "Erecording Method"
      display_name: "Erecording method"
      expr: erecording_method
    - name: "Fee Payment Method"
      display_name: "Fee payment method"
      expr: fee_payment_method
    - name: "Fee Payment Reference"
      display_name: "Fee payment reference"
      expr: fee_payment_reference
    - name: "Gap Period Open"
      display_name: "Gap period open"
      expr: gap_period_open
    - name: "Gateway Account Code"
      display_name: "Gateway account code"
      expr: gateway_account_code
    - name: "Gateway Api Version"
      display_name: "Gateway api version"
      expr: gateway_api_version
    - name: "Gateway Package Code"
      display_name: "Gateway package code"
      expr: gateway_package_code
    - name: "Gateway Session Code"
      display_name: "Gateway session code"
      expr: gateway_session_code
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Gateway Transaction"
      display_name: "Distinct gateway transaction"
      expr: COUNT(DISTINCT gateway_transaction_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Document Count"
      display_name: "Total document count"
      expr: SUM(document_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Document Count"
      display_name: "Average document count"
      expr: AVG(document_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Gap Coverage Days"
      display_name: "Total gap coverage days"
      expr: SUM(gap_coverage_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Gap Coverage Days"
      display_name: "Average gap coverage days"
      expr: AVG(gap_coverage_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Package Page Count"
      display_name: "Total package page count"
      expr: SUM(package_page_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Package Page Count"
      display_name: "Average package page count"
      expr: AVG(package_page_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Policy Issuance Lag Days"
      display_name: "Total policy issuance lag days"
      expr: SUM(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Issuance Lag Days"
      display_name: "Average policy issuance lag days"
      expr: AVG(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Recording Fee Amount"
      display_name: "Total recording fee amount"
      expr: SUM(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recording Fee Amount"
      display_name: "Average recording fee amount"
      expr: AVG(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Resubmission Attempt Number"
      display_name: "Total resubmission attempt number"
      expr: SUM(resubmission_attempt_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Resubmission Attempt Number"
      display_name: "Average resubmission attempt number"
      expr: AVG(resubmission_attempt_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Sla Actual Hours"
      display_name: "Total sla actual hours"
      expr: SUM(sla_actual_hours)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sla Actual Hours"
      display_name: "Average sla actual hours"
      expr: AVG(sla_actual_hours)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`recording_jurisdiction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Jurisdiction business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction`"
  dimensions:
    - name: "Accepted Document Types"
      display_name: "Accepted document types"
      expr: accepted_document_types
    - name: "Common Rejection Reasons"
      display_name: "Common rejection reasons"
      expr: common_rejection_reasons
    - name: "County Name"
      display_name: "County name"
      expr: county_name
    - name: "Cover Sheet Required"
      display_name: "Cover sheet required"
      expr: cover_sheet_required
    - name: "Cover Sheet Template Code"
      display_name: "Cover sheet template code"
      expr: cover_sheet_template_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Data Source"
      display_name: "Data source"
      expr: data_source
    - name: "Erecording Accepted"
      display_name: "Erecording accepted"
      expr: erecording_accepted
    - name: "Erecording Gateway"
      display_name: "Erecording gateway"
      expr: erecording_gateway
    - name: "Fee Effective Date"
      display_name: "Fee effective date"
      expr: fee_effective_date
    - name: "Fee Expiration Date"
      display_name: "Fee expiration date"
      expr: fee_expiration_date
    - name: "Fips County Code"
      display_name: "Fips county code"
      expr: fips_county_code
    - name: "Gap Coverage Applicable"
      display_name: "Gap coverage applicable"
      expr: gap_coverage_applicable
    - name: "In Person Submission Accepted"
      display_name: "In person submission accepted"
      expr: in_person_submission_accepted
    - name: "Ipen Accepted"
      display_name: "Ipen accepted"
      expr: ipen_accepted
    - name: "Last Updated Timestamp"
      display_name: "Last updated timestamp"
      expr: last_updated_timestamp
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Jurisdiction"
      display_name: "Distinct jurisdiction"
      expr: COUNT(DISTINCT jurisdiction_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Avg Recording Turnaround Days"
      display_name: "Total avg recording turnaround days"
      expr: SUM(avg_recording_turnaround_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Avg Recording Turnaround Days"
      display_name: "Average avg recording turnaround days"
      expr: AVG(avg_recording_turnaround_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Base Recording Fee Amount"
      display_name: "Total base recording fee amount"
      expr: SUM(base_recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Base Recording Fee Amount"
      display_name: "Average base recording fee amount"
      expr: AVG(base_recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Fee Per Page Amount"
      display_name: "Total fee per page amount"
      expr: SUM(fee_per_page_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Fee Per Page Amount"
      display_name: "Average fee per page amount"
      expr: AVG(fee_per_page_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Font Size Minimum Pt"
      display_name: "Total font size minimum pt"
      expr: SUM(font_size_minimum_pt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Font Size Minimum Pt"
      display_name: "Average font size minimum pt"
      expr: AVG(font_size_minimum_pt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Margin Requirement Inches"
      display_name: "Total margin requirement inches"
      expr: SUM(margin_requirement_inches)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Margin Requirement Inches"
      display_name: "Average margin requirement inches"
      expr: AVG(margin_requirement_inches)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Max Pages Base Fee"
      display_name: "Total max pages base fee"
      expr: SUM(max_pages_base_fee)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Max Pages Base Fee"
      display_name: "Average max pages base fee"
      expr: AVG(max_pages_base_fee)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Rejection Rate Pct"
      display_name: "Total rejection rate pct"
      expr: SUM(rejection_rate_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Rejection Rate Pct"
      display_name: "Average rejection rate pct"
      expr: AVG(rejection_rate_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Transfer Tax Rate"
      display_name: "Total transfer tax rate"
      expr: SUM(transfer_tax_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Transfer Tax Rate"
      display_name: "Average transfer tax rate"
      expr: AVG(transfer_tax_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`recording_recorded_instrument`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Recorded Instrument business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Apn"
      display_name: "Apn"
      expr: apn
    - name: "Book Number"
      display_name: "Book number"
      expr: book_number
    - name: "Chain Of Title Break Flag"
      display_name: "Chain of title break flag"
      expr: chain_of_title_break_flag
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Document Image Reference"
      display_name: "Document image reference"
      expr: document_image_reference
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Erecording Gateway"
      display_name: "Erecording gateway"
      expr: erecording_gateway
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Gap Coverage Flag"
      display_name: "Gap coverage flag"
      expr: gap_coverage_flag
    - name: "Grantee Name"
      display_name: "Grantee name"
      expr: grantee_name
    - name: "Grantor Name"
      display_name: "Grantor name"
      expr: grantor_name
    - name: "Instrument Number"
      display_name: "Instrument number"
      expr: instrument_number
    - name: "Instrument Status"
      display_name: "Instrument status"
      expr: instrument_status
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Recorded Instrument"
      display_name: "Distinct recorded instrument"
      expr: COUNT(DISTINCT recorded_instrument_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Consideration Amount"
      display_name: "Total consideration amount"
      expr: SUM(consideration_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Consideration Amount"
      display_name: "Average consideration amount"
      expr: AVG(consideration_amount)
      format:
        type: percentage
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
    - name: "Total Page Count"
      display_name: "Total page count"
      expr: SUM(page_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Page Count"
      display_name: "Average page count"
      expr: AVG(page_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Recording Fee Amount"
      display_name: "Total recording fee amount"
      expr: SUM(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recording Fee Amount"
      display_name: "Average recording fee amount"
      expr: AVG(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Transfer Tax Amount"
      display_name: "Total transfer tax amount"
      expr: SUM(transfer_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Transfer Tax Amount"
      display_name: "Average transfer tax amount"
      expr: AVG(transfer_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`recording_recording_submission`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Recording Submission business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Book Number"
      display_name: "Book number"
      expr: book_number
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
    - name: "Erecording Gateway"
      display_name: "Erecording gateway"
      expr: erecording_gateway
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Gap Close Date"
      display_name: "Gap close date"
      expr: gap_close_date
    - name: "Gap Coverage Flag"
      display_name: "Gap coverage flag"
      expr: gap_coverage_flag
    - name: "Gap Open Date"
      display_name: "Gap open date"
      expr: gap_open_date
    - name: "Instrument Number"
      display_name: "Instrument number"
      expr: instrument_number
    - name: "Last Rejection Date"
      display_name: "Last rejection date"
      expr: last_rejection_date
    - name: "Last Rejection Reason Code"
      display_name: "Last rejection reason code"
      expr: last_rejection_reason_code
    - name: "Last Rejection Reason Description"
      display_name: "Last rejection reason description"
      expr: last_rejection_reason_description
    - name: "Notes"
      display_name: "Notes"
      expr: notes
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Recording Submission"
      display_name: "Distinct recording submission"
      expr: COUNT(DISTINCT recording_submission_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Consideration Amount"
      display_name: "Total consideration amount"
      expr: SUM(consideration_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Consideration Amount"
      display_name: "Average consideration amount"
      expr: AVG(consideration_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Document Count"
      display_name: "Total document count"
      expr: SUM(document_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Document Count"
      display_name: "Average document count"
      expr: AVG(document_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Policy Issuance Lag Days"
      display_name: "Total policy issuance lag days"
      expr: SUM(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Issuance Lag Days"
      display_name: "Average policy issuance lag days"
      expr: AVG(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Rejection Count"
      display_name: "Total rejection count"
      expr: SUM(rejection_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Rejection Count"
      display_name: "Average rejection count"
      expr: AVG(rejection_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Total Recording Fee Amount"
      display_name: "Total total recording fee amount"
      expr: SUM(total_recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Total Recording Fee Amount"
      display_name: "Average total recording fee amount"
      expr: AVG(total_recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Total Transfer Tax Amount"
      display_name: "Total total transfer tax amount"
      expr: SUM(total_transfer_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Total Transfer Tax Amount"
      display_name: "Average total transfer tax amount"
      expr: AVG(total_transfer_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`recording_rejection_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Rejection Event business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event`"
  dimensions:
    - name: "Assigned To User"
      display_name: "Assigned to user"
      expr: assigned_to_user
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "County Name"
      display_name: "County name"
      expr: county_name
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Description"
      display_name: "Curative action description"
      expr: curative_action_description
    - name: "Curative Action Required"
      display_name: "Curative action required"
      expr: curative_action_required
    - name: "Document Reference Number"
      display_name: "Document reference number"
      expr: document_reference_number
    - name: "Document Type"
      display_name: "Document type"
      expr: document_type
    - name: "Erecording Gateway Name"
      display_name: "Erecording gateway name"
      expr: erecording_gateway_name
    - name: "Escalated To Underwriting"
      display_name: "Escalated to underwriting"
      expr: escalated_to_underwriting
    - name: "Escalation Timestamp"
      display_name: "Escalation timestamp"
      expr: escalation_timestamp
    - name: "Gap Period Impacted"
      display_name: "Gap period impacted"
      expr: gap_period_impacted
    - name: "Notes"
      display_name: "Notes"
      expr: notes
    - name: "Number"
      display_name: "Number"
      expr: number
    - name: "Original Submission Date"
      display_name: "Original submission date"
      expr: original_submission_date
    - name: "Policy Issuance Impacted"
      display_name: "Policy issuance impacted"
      expr: policy_issuance_impacted
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Rejection Event"
      display_name: "Distinct rejection event"
      expr: COUNT(DISTINCT rejection_event_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Corrected Fee Amount"
      display_name: "Total corrected fee amount"
      expr: SUM(corrected_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Corrected Fee Amount"
      display_name: "Average corrected fee amount"
      expr: AVG(corrected_fee_amount)
      format:
        type: currency
        currency_code: USD
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
    - name: "Total Gap Period Days"
      display_name: "Total gap period days"
      expr: SUM(gap_period_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Gap Period Days"
      display_name: "Average gap period days"
      expr: AVG(gap_period_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Recording Fee Amount"
      display_name: "Total recording fee amount"
      expr: SUM(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recording Fee Amount"
      display_name: "Average recording fee amount"
      expr: AVG(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Rejection Sequence Number"
      display_name: "Total rejection sequence number"
      expr: SUM(rejection_sequence_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Rejection Sequence Number"
      display_name: "Average rejection sequence number"
      expr: AVG(rejection_sequence_number)
      format:
        type: number
        decimal_places:
          type: all
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`recording_submission_document`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Submission Document business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Book Number"
      display_name: "Book number"
      expr: book_number
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Document Image Reference"
      display_name: "Document image reference"
      expr: document_image_reference
    - name: "Document Status"
      display_name: "Document status"
      expr: document_status
    - name: "Document Subtype"
      display_name: "Document subtype"
      expr: document_subtype
    - name: "Document Title"
      display_name: "Document title"
      expr: document_title
    - name: "Document Type"
      display_name: "Document type"
      expr: document_type
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Erecording Gateway"
      display_name: "Erecording gateway"
      expr: erecording_gateway
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Gap Close Date"
      display_name: "Gap close date"
      expr: gap_close_date
    - name: "Gap Coverage Flag"
      display_name: "Gap coverage flag"
      expr: gap_coverage_flag
    - name: "Gap Open Date"
      display_name: "Gap open date"
      expr: gap_open_date
    - name: "Grantee Name"
      display_name: "Grantee name"
      expr: grantee_name
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Submission Document"
      display_name: "Distinct submission document"
      expr: COUNT(DISTINCT submission_document_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Consideration Amount"
      display_name: "Total consideration amount"
      expr: SUM(consideration_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Consideration Amount"
      display_name: "Average consideration amount"
      expr: AVG(consideration_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Document Sequence Number"
      display_name: "Total document sequence number"
      expr: SUM(document_sequence_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Document Sequence Number"
      display_name: "Average document sequence number"
      expr: AVG(document_sequence_number)
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
    - name: "Total Page Count"
      display_name: "Total page count"
      expr: SUM(page_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Page Count"
      display_name: "Average page count"
      expr: AVG(page_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Policy Issuance Lag Days"
      display_name: "Total policy issuance lag days"
      expr: SUM(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Issuance Lag Days"
      display_name: "Average policy issuance lag days"
      expr: AVG(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Recording Fee Amount"
      display_name: "Total recording fee amount"
      expr: SUM(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recording Fee Amount"
      display_name: "Average recording fee amount"
      expr: AVG(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Rejection Count"
      display_name: "Total rejection count"
      expr: SUM(rejection_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Rejection Count"
      display_name: "Average rejection count"
      expr: AVG(rejection_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Transfer Tax Amount"
      display_name: "Total transfer tax amount"
      expr: SUM(transfer_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Transfer Tax Amount"
      display_name: "Average transfer tax amount"
      expr: AVG(transfer_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`recording_submission_status_history`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Submission Status History business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Book Number"
      display_name: "Book number"
      expr: book_number
    - name: "County Acknowledgment Code"
      display_name: "County acknowledgment code"
      expr: county_acknowledgment_code
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Description"
      display_name: "Curative action description"
      expr: curative_action_description
    - name: "Curative Action Required"
      display_name: "Curative action required"
      expr: curative_action_required
    - name: "Curative Completed Date"
      display_name: "Curative completed date"
      expr: curative_completed_date
    - name: "Document Type"
      display_name: "Document type"
      expr: document_type
    - name: "Erecording Gateway"
      display_name: "Erecording gateway"
      expr: erecording_gateway
    - name: "Event Source"
      display_name: "Event source"
      expr: event_source
    - name: "Event Timestamp"
      display_name: "Event timestamp"
      expr: event_timestamp
    - name: "Fee Correction Flag"
      display_name: "Fee correction flag"
      expr: fee_correction_flag
    - name: "Gap Close Date"
      display_name: "Gap close date"
      expr: gap_close_date
    - name: "Gap Coverage Active"
      display_name: "Gap coverage active"
      expr: gap_coverage_active
    - name: "Gap Open Date"
      display_name: "Gap open date"
      expr: gap_open_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Submission Status History"
      display_name: "Distinct submission status history"
      expr: COUNT(DISTINCT submission_status_history_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Days In Prior Status"
      display_name: "Total days in prior status"
      expr: SUM(days_in_prior_status)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Days In Prior Status"
      display_name: "Average days in prior status"
      expr: AVG(days_in_prior_status)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Gap Duration Days"
      display_name: "Total gap duration days"
      expr: SUM(gap_duration_days)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Gap Duration Days"
      display_name: "Average gap duration days"
      expr: AVG(gap_duration_days)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Policy Issuance Lag Days"
      display_name: "Total policy issuance lag days"
      expr: SUM(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Issuance Lag Days"
      display_name: "Average policy issuance lag days"
      expr: AVG(policy_issuance_lag_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Recording Fee Amount"
      display_name: "Total recording fee amount"
      expr: SUM(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recording Fee Amount"
      display_name: "Average recording fee amount"
      expr: AVG(recording_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Sla Threshold Days"
      display_name: "Total sla threshold days"
      expr: SUM(sla_threshold_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sla Threshold Days"
      display_name: "Average sla threshold days"
      expr: AVG(sla_threshold_days)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Submission Attempt Number"
      display_name: "Total submission attempt number"
      expr: SUM(submission_attempt_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Submission Attempt Number"
      display_name: "Average submission attempt number"
      expr: AVG(submission_attempt_number)
      format:
        type: number
        decimal_places:
          type: all
$$;
