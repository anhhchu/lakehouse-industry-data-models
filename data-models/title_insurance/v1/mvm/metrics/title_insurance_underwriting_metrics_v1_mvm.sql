-- Metric views for domain: underwriting | Business: Title_Insurance | Version: 1 | Generated on: 2026-10-31 06:37:40

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_curative_action`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Curative Action business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action`"
  dimensions:
    - name: "Action Number"
      display_name: "Action number"
      expr: action_number
    - name: "Action Status"
      display_name: "Action status"
      expr: action_status
    - name: "Action Subtype"
      display_name: "Action subtype"
      expr: action_subtype
    - name: "Action Type"
      display_name: "Action type"
      expr: action_type
    - name: "Completed Date"
      display_name: "Completed date"
      expr: completed_date
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Defect Category"
      display_name: "Defect category"
      expr: defect_category
    - name: "Due Date"
      display_name: "Due date"
      expr: due_date
    - name: "Escalated Date"
      display_name: "Escalated date"
      expr: escalated_date
    - name: "Failure Reason"
      display_name: "Failure reason"
      expr: failure_reason
    - name: "Initiated Date"
      display_name: "Initiated date"
      expr: initiated_date
    - name: "Instrument Type"
      display_name: "Instrument type"
      expr: instrument_type
    - name: "Is Chain Of Title Break"
      display_name: "Is chain of title break"
      expr: is_chain_of_title_break
    - name: "Is Gap Cure"
      display_name: "Is gap cure"
      expr: is_gap_cure
    - name: "Is Marketable Title Impairment"
      display_name: "Is marketable title impairment"
      expr: is_marketable_title_impairment
    - name: "Is Sla Breached"
      display_name: "Is sla breached"
      expr: is_sla_breached
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Curative Action"
      display_name: "Distinct curative action"
      expr: COUNT(DISTINCT curative_action_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Attempt Number"
      display_name: "Total attempt number"
      expr: SUM(attempt_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Attempt Number"
      display_name: "Average attempt number"
      expr: AVG(attempt_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Curative Cost"
      display_name: "Total curative cost"
      expr: SUM(curative_cost)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Curative Cost"
      display_name: "Average curative cost"
      expr: AVG(curative_cost)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_decision`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Decision business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision`"
  dimensions:
    - name: "Conditions Imposed"
      display_name: "Conditions imposed"
      expr: conditions_imposed
    - name: "Cot Break Indicator"
      display_name: "Cot break indicator"
      expr: cot_break_indicator
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Curative Action Required"
      display_name: "Curative action required"
      expr: curative_action_required
    - name: "Curative Deadline Date"
      display_name: "Curative deadline date"
      expr: curative_deadline_date
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Decision Date"
      display_name: "Decision date"
      expr: decision_date
    - name: "Decision Number"
      display_name: "Decision number"
      expr: decision_number
    - name: "Decision Status"
      display_name: "Decision status"
      expr: decision_status
    - name: "Decision Timestamp"
      display_name: "Decision timestamp"
      expr: decision_timestamp
    - name: "Decision Type"
      display_name: "Decision type"
      expr: decision_type
    - name: "Defect Category"
      display_name: "Defect category"
      expr: defect_category
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Endorsement Required"
      display_name: "Endorsement required"
      expr: endorsement_required
    - name: "Endorsement Types"
      display_name: "Endorsement types"
      expr: endorsement_types
    - name: "Exception Scheduled"
      display_name: "Exception scheduled"
      expr: exception_scheduled
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Decision"
      display_name: "Distinct decision"
      expr: COUNT(DISTINCT decision_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Escalation Count"
      display_name: "Total escalation count"
      expr: SUM(escalation_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Escalation Count"
      display_name: "Average escalation count"
      expr: AVG(escalation_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Liability Amount"
      display_name: "Total liability amount"
      expr: SUM(liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Liability Amount"
      display_name: "Average liability amount"
      expr: AVG(liability_amount)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_endorsement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Endorsement business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement`"
  dimensions:
    - name: "Alta Form Number"
      display_name: "Alta form number"
      expr: alta_form_number
    - name: "Cancellation Date"
      display_name: "Cancellation date"
      expr: cancellation_date
    - name: "Cancellation Reason"
      display_name: "Cancellation reason"
      expr: cancellation_reason
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Coverage Category"
      display_name: "Coverage category"
      expr: coverage_category
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Description"
      display_name: "Description"
      expr: endorsement_description
    - name: "Document Image Ref"
      display_name: "Document image ref"
      expr: document_image_ref
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Electronic Delivery"
      display_name: "Electronic delivery"
      expr: electronic_delivery
    - name: "Endorsement Status"
      display_name: "Endorsement status"
      expr: endorsement_status
    - name: "Endorsement Type"
      display_name: "Endorsement type"
      expr: endorsement_type
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Gl Account Code"
      display_name: "Gl account code"
      expr: gl_account_code
    - name: "Issuance Date"
      display_name: "Issuance date"
      expr: issuance_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Endorsement"
      display_name: "Distinct endorsement"
      expr: COUNT(DISTINCT endorsement_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Additional Premium Amount"
      display_name: "Total additional premium amount"
      expr: SUM(additional_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Additional Premium Amount"
      display_name: "Average additional premium amount"
      expr: AVG(additional_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
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
    - name: "Total Liability Amount"
      display_name: "Total liability amount"
      expr: SUM(liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Liability Amount"
      display_name: "Average liability amount"
      expr: AVG(liability_amount)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_policy_exception`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Policy Exception business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception`"
  dimensions:
    - name: "Added Date"
      display_name: "Added date"
      expr: added_date
    - name: "Affects Description"
      display_name: "Affects description"
      expr: affects_description
    - name: "Carried To Policy Date"
      display_name: "Carried to policy date"
      expr: carried_to_policy_date
    - name: "Commitment Schedule Section"
      display_name: "Commitment schedule section"
      expr: commitment_schedule_section
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Required"
      display_name: "Curative action required"
      expr: curative_action_required
    - name: "Curative Action Status"
      display_name: "Curative action status"
      expr: curative_action_status
    - name: "Curative Completion Date"
      display_name: "Curative completion date"
      expr: curative_completion_date
    - name: "Deleted Date"
      display_name: "Deleted date"
      expr: deleted_date
    - name: "Endorsement Available"
      display_name: "Endorsement available"
      expr: endorsement_available
    - name: "Endorsement Type"
      display_name: "Endorsement type"
      expr: endorsement_type
    - name: "Exception Number"
      display_name: "Exception number"
      expr: exception_number
    - name: "Exception Status"
      display_name: "Exception status"
      expr: exception_status
    - name: "Exception Text"
      display_name: "Exception text"
      expr: exception_text
    - name: "Exception Type"
      display_name: "Exception type"
      expr: exception_type
    - name: "Gap Coverage Applicable"
      display_name: "Gap coverage applicable"
      expr: gap_coverage_applicable
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Policy Exception"
      display_name: "Distinct policy exception"
      expr: COUNT(DISTINCT policy_exception_id)
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
    - name: "Total Lien Amount"
      display_name: "Total lien amount"
      expr: SUM(lien_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Lien Amount"
      display_name: "Average lien amount"
      expr: AVG(lien_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Priority Position"
      display_name: "Total priority position"
      expr: SUM(priority_position)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Priority Position"
      display_name: "Average priority position"
      expr: AVG(priority_position)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_title_commitment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Title Commitment business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`"
  dimensions:
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Closing Date Actual"
      display_name: "Closing date actual"
      expr: closing_date_actual
    - name: "Closing Date Scheduled"
      display_name: "Closing date scheduled"
      expr: closing_date_scheduled
    - name: "Closing Protection Letter Flag"
      display_name: "Closing protection letter flag"
      expr: closing_protection_letter_flag
    - name: "Commitment Number"
      display_name: "Commitment number"
      expr: commitment_number
    - name: "Commitment Status"
      display_name: "Commitment status"
      expr: commitment_status
    - name: "Commitment Type"
      display_name: "Commitment type"
      expr: commitment_type
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Cpl Issue Date"
      display_name: "Cpl issue date"
      expr: cpl_issue_date
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Estate Type"
      display_name: "Estate type"
      expr: estate_type
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
    - name: "Gap Coverage Flag"
      display_name: "Gap coverage flag"
      expr: gap_coverage_flag
    - name: "Insurable Title Determination"
      display_name: "Insurable title determination"
      expr: insurable_title_determination
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Title Commitment"
      display_name: "Distinct title commitment"
      expr: COUNT(DISTINCT title_commitment_id)
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
    - name: "Total Loan Policy Amount"
      display_name: "Total loan policy amount"
      expr: SUM(loan_policy_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Loan Policy Amount"
      display_name: "Average loan policy amount"
      expr: AVG(loan_policy_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Loan Premium Amount"
      display_name: "Total loan premium amount"
      expr: SUM(loan_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Loan Premium Amount"
      display_name: "Average loan premium amount"
      expr: AVG(loan_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Open Exceptions Count"
      display_name: "Total open exceptions count"
      expr: SUM(open_exceptions_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Open Exceptions Count"
      display_name: "Average open exceptions count"
      expr: AVG(open_exceptions_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Open Requirements Count"
      display_name: "Total open requirements count"
      expr: SUM(open_requirements_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Open Requirements Count"
      display_name: "Average open requirements count"
      expr: AVG(open_requirements_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Owner Policy Amount"
      display_name: "Total owner policy amount"
      expr: SUM(owner_policy_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Owner Policy Amount"
      display_name: "Average owner policy amount"
      expr: AVG(owner_policy_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Owner Premium Amount"
      display_name: "Total owner premium amount"
      expr: SUM(owner_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Owner Premium Amount"
      display_name: "Average owner premium amount"
      expr: AVG(owner_premium_amount)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_title_finding`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Title Finding business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`"
  dimensions:
    - name: "Affects Full Parcel"
      display_name: "Affects full parcel"
      expr: affects_full_parcel
    - name: "Book Volume"
      display_name: "Book volume"
      expr: book_volume
    - name: "Cleared Date"
      display_name: "Cleared date"
      expr: cleared_date
    - name: "Cot Break Indicator"
      display_name: "Cot break indicator"
      expr: cot_break_indicator
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Required"
      display_name: "Curative action required"
      expr: curative_action_required
    - name: "Curative Deadline Date"
      display_name: "Curative deadline date"
      expr: curative_deadline_date
    - name: "Curative Notes"
      display_name: "Curative notes"
      expr: curative_notes
    - name: "Discovery Date"
      display_name: "Discovery date"
      expr: discovery_date
    - name: "Document Number"
      display_name: "Document number"
      expr: document_number
    - name: "Finding Description"
      display_name: "Finding description"
      expr: finding_description
    - name: "Finding Number"
      display_name: "Finding number"
      expr: finding_number
    - name: "Finding Status"
      display_name: "Finding status"
      expr: finding_status
    - name: "Finding Type"
      display_name: "Finding type"
      expr: finding_type
    - name: "Gap Period Indicator"
      display_name: "Gap period indicator"
      expr: gap_period_indicator
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
    - name: "Distinct Title Finding"
      display_name: "Distinct title finding"
      expr: COUNT(DISTINCT title_finding_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Lien Amount"
      display_name: "Total lien amount"
      expr: SUM(lien_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Lien Amount"
      display_name: "Average lien amount"
      expr: AVG(lien_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Lien Priority"
      display_name: "Total lien priority"
      expr: SUM(lien_priority)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Lien Priority"
      display_name: "Average lien priority"
      expr: AVG(lien_priority)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_title_policy`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Title Policy business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`"
  dimensions:
    - name: "Cancellation Date"
      display_name: "Cancellation date"
      expr: cancellation_date
    - name: "Cancellation Reason"
      display_name: "Cancellation reason"
      expr: cancellation_reason
    - name: "Companion Policy Number"
      display_name: "Companion policy number"
      expr: companion_policy_number
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Effective Time"
      display_name: "Effective time"
      expr: effective_time
    - name: "Estate Or Interest"
      display_name: "Estate or interest"
      expr: estate_or_interest
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Gap Coverage Flag"
      display_name: "Gap coverage flag"
      expr: gap_coverage_flag
    - name: "Insurable Title Flag"
      display_name: "Insurable title flag"
      expr: insurable_title_flag
    - name: "Insured Name"
      display_name: "Insured name"
      expr: insured_name
    - name: "Insured Type"
      display_name: "Insured type"
      expr: insured_type
    - name: "Issue Date"
      display_name: "Issue date"
      expr: issue_date
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
    - name: "Distinct Title Policy"
      display_name: "Distinct title policy"
      expr: COUNT(DISTINCT title_policy_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Agent Premium Split Amount"
      display_name: "Total agent premium split amount"
      expr: SUM(agent_premium_split_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Agent Premium Split Amount"
      display_name: "Average agent premium split amount"
      expr: AVG(agent_premium_split_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Endorsement Count"
      display_name: "Total endorsement count"
      expr: SUM(endorsement_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Endorsement Count"
      display_name: "Average endorsement count"
      expr: AVG(endorsement_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Liability Amount"
      display_name: "Total liability amount"
      expr: SUM(liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Liability Amount"
      display_name: "Average liability amount"
      expr: AVG(liability_amount)
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
    - name: "Total Policy Exception Count"
      display_name: "Total policy exception count"
      expr: SUM(policy_exception_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Exception Count"
      display_name: "Average policy exception count"
      expr: AVG(policy_exception_count)
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
    - name: "Total Premium Amount"
      display_name: "Total premium amount"
      expr: SUM(premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Premium Amount"
      display_name: "Average premium amount"
      expr: AVG(premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
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
    - name: "Total Underwriter Premium Split Amount"
      display_name: "Total underwriter premium split amount"
      expr: SUM(underwriter_premium_split_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Underwriter Premium Split Amount"
      display_name: "Average underwriter premium split amount"
      expr: AVG(underwriter_premium_split_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_title_requirement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Title Requirement business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement`"
  dimensions:
    - name: "Added To Commitment Date"
      display_name: "Added to commitment date"
      expr: added_to_commitment_date
    - name: "Applies To Policy Type"
      display_name: "Applies to policy type"
      expr: applies_to_policy_type
    - name: "Assigned Curative Processor"
      display_name: "Assigned curative processor"
      expr: assigned_curative_processor
    - name: "Commitment Schedule Section"
      display_name: "Commitment schedule section"
      expr: commitment_schedule_section
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Type"
      display_name: "Curative action type"
      expr: curative_action_type
    - name: "Curative Memo Reference"
      display_name: "Curative memo reference"
      expr: curative_memo_reference
    - name: "Due Date"
      display_name: "Due date"
      expr: due_date
    - name: "Evidence Document Reference"
      display_name: "Evidence document reference"
      expr: evidence_document_reference
    - name: "Gap Coverage Required"
      display_name: "Gap coverage required"
      expr: gap_coverage_required
    - name: "Grantee Name"
      display_name: "Grantee name"
      expr: grantee_name
    - name: "Grantor Name"
      display_name: "Grantor name"
      expr: grantor_name
    - name: "Identified Date"
      display_name: "Identified date"
      expr: identified_date
    - name: "Instrument Reference"
      display_name: "Instrument reference"
      expr: instrument_reference
    - name: "Is Active Version"
      display_name: "Is active version"
      expr: is_active_version
    - name: "Is Closing Condition"
      display_name: "Is closing condition"
      expr: is_closing_condition
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Title Requirement"
      display_name: "Distinct title requirement"
      expr: COUNT(DISTINCT title_requirement_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Confirmed Payoff Amount"
      display_name: "Total confirmed payoff amount"
      expr: SUM(confirmed_payoff_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Confirmed Payoff Amount"
      display_name: "Average confirmed payoff amount"
      expr: AVG(confirmed_payoff_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Estimated Payoff Amount"
      display_name: "Total estimated payoff amount"
      expr: SUM(estimated_payoff_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Estimated Payoff Amount"
      display_name: "Average estimated payoff amount"
      expr: AVG(estimated_payoff_amount)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_underwriting_title_examination`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Underwriting Title Examination business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination`"
  dimensions:
    - name: "Apn"
      display_name: "Apn"
      expr: apn
    - name: "Chain Of Title Break Flag"
      display_name: "Chain of title break flag"
      expr: chain_of_title_break_flag
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Required"
      display_name: "Curative action required"
      expr: curative_action_required
    - name: "Curative Action Type"
      display_name: "Curative action type"
      expr: curative_action_type
    - name: "Curative Deadline Date"
      display_name: "Curative deadline date"
      expr: curative_deadline_date
    - name: "Estate Type"
      display_name: "Estate type"
      expr: estate_type
    - name: "Examination Completion Timestamp"
      display_name: "Examination completion timestamp"
      expr: examination_completion_timestamp
    - name: "Examination Date"
      display_name: "Examination date"
      expr: examination_date
    - name: "Examination Number"
      display_name: "Examination number"
      expr: examination_number
    - name: "Examination Scope Notes"
      display_name: "Examination scope notes"
      expr: examination_scope_notes
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
    - name: "Examiner Opinion"
      display_name: "Examiner opinion"
      expr: examiner_opinion
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Underwriting Title Examination"
      display_name: "Distinct underwriting title examination"
      expr: COUNT(DISTINCT underwriting_title_examination_id)
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
    - name: "Total Finding Count"
      display_name: "Total finding count"
      expr: SUM(finding_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Finding Count"
      display_name: "Average finding count"
      expr: AVG(finding_count)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`underwriting_uw_referral`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Uw Referral business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`"
  dimensions:
    - name: "Channel"
      display_name: "Channel"
      expr: channel
    - name: "Closing Date Impact"
      display_name: "Closing date impact"
      expr: closing_date_impact
    - name: "Conditions Imposed"
      display_name: "Conditions imposed"
      expr: conditions_imposed
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
    - name: "Curative Deadline Date"
      display_name: "Curative deadline date"
      expr: curative_deadline_date
    - name: "Defect Description"
      display_name: "Defect description"
      expr: defect_description
    - name: "Endorsement Required"
      display_name: "Endorsement required"
      expr: endorsement_required
    - name: "Endorsement Types"
      display_name: "Endorsement types"
      expr: endorsement_types
    - name: "Exception Scheduled"
      display_name: "Exception scheduled"
      expr: exception_scheduled
    - name: "Gap Period End Date"
      display_name: "Gap period end date"
      expr: gap_period_end_date
    - name: "Gap Period Start Date"
      display_name: "Gap period start date"
      expr: gap_period_start_date
    - name: "Insurable Title Determination"
      display_name: "Insurable title determination"
      expr: insurable_title_determination
    - name: "Liability Threshold Exceeded"
      display_name: "Liability threshold exceeded"
      expr: liability_threshold_exceeded
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Uw Referral"
      display_name: "Distinct uw referral"
      expr: COUNT(DISTINCT uw_referral_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Escalation Count"
      display_name: "Total escalation count"
      expr: SUM(escalation_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Escalation Count"
      display_name: "Average escalation count"
      expr: AVG(escalation_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Liability Amount"
      display_name: "Total liability amount"
      expr: SUM(liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Liability Amount"
      display_name: "Average liability amount"
      expr: AVG(liability_amount)
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
