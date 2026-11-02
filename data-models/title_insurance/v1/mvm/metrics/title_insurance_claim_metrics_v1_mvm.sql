-- Metric views for domain: claim | Business: Title_Insurance | Version: 1 | Generated on: 2026-10-31 06:37:43

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_claim_curative_action`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Claim Curative Action business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action`"
  dimensions:
    - name: "Action Description"
      display_name: "Action description"
      expr: action_description
    - name: "Action Number"
      display_name: "Action number"
      expr: action_number
    - name: "Action Status"
      display_name: "Action status"
      expr: action_status
    - name: "Action Type"
      display_name: "Action type"
      expr: action_type
    - name: "Actual Resolution Date"
      display_name: "Actual resolution date"
      expr: actual_resolution_date
    - name: "Chain Of Title Break"
      display_name: "Chain of title break"
      expr: chain_of_title_break
    - name: "Cost Currency Code"
      display_name: "Cost currency code"
      expr: cost_currency_code
    - name: "Court Jurisdiction"
      display_name: "Court jurisdiction"
      expr: court_jurisdiction
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Instrument Type"
      display_name: "Curative instrument type"
      expr: curative_instrument_type
    - name: "Defect Type"
      display_name: "Defect type"
      expr: defect_type
    - name: "Escalation Date"
      display_name: "Escalation date"
      expr: escalation_date
    - name: "Evidence Document Ref"
      display_name: "Evidence document ref"
      expr: evidence_document_ref
    - name: "Gap Cure Required"
      display_name: "Gap cure required"
      expr: gap_cure_required
    - name: "Initiated Date"
      display_name: "Initiated date"
      expr: initiated_date
    - name: "Instrument Document Number"
      display_name: "Instrument document number"
      expr: instrument_document_number
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Claim Curative Action"
      display_name: "Distinct claim curative action"
      expr: COUNT(DISTINCT claim_curative_action_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Actual Cost Amount"
      display_name: "Total actual cost amount"
      expr: SUM(actual_cost_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Actual Cost Amount"
      display_name: "Average actual cost amount"
      expr: AVG(actual_cost_amount)
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
    - name: "Total Estimated Cost Amount"
      display_name: "Total estimated cost amount"
      expr: SUM(estimated_cost_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Estimated Cost Amount"
      display_name: "Average estimated cost amount"
      expr: AVG(estimated_cost_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
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
    - name: "Total Recovery Amount"
      display_name: "Total recovery amount"
      expr: SUM(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recovery Amount"
      display_name: "Average recovery amount"
      expr: AVG(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Reserve Impact Amount"
      display_name: "Total reserve impact amount"
      expr: SUM(reserve_impact_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Reserve Impact Amount"
      display_name: "Average reserve impact amount"
      expr: AVG(reserve_impact_amount)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_claim_party`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Claim Party business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party`"
  dimensions:
    - name: "Contact Email"
      display_name: "Contact email"
      expr: contact_email
    - name: "Contact Phone"
      display_name: "Contact phone"
      expr: contact_phone
    - name: "Counsel Bar Number"
      display_name: "Counsel bar number"
      expr: counsel_bar_number
    - name: "Counsel Firm Name"
      display_name: "Counsel firm name"
      expr: counsel_firm_name
    - name: "Coverage Denial Reason"
      display_name: "Coverage denial reason"
      expr: coverage_denial_reason
    - name: "Coverage Determination"
      display_name: "Coverage determination"
      expr: coverage_determination
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Demand Letter Date"
      display_name: "Demand letter date"
      expr: demand_letter_date
    - name: "Identity Verification Method"
      display_name: "Identity verification method"
      expr: identity_verification_method
    - name: "Identity Verified Indicator"
      display_name: "Identity verified indicator"
      expr: identity_verified_indicator
    - name: "Is Adverse Party"
      display_name: "Is adverse party"
      expr: is_adverse_party
    - name: "Is Insured Party"
      display_name: "Is insured party"
      expr: is_insured_party
    - name: "Is Primary Claimant"
      display_name: "Is primary claimant"
      expr: is_primary_claimant
    - name: "Mailing Address Line1"
      display_name: "Mailing address line1"
      expr: mailing_address_line1
    - name: "Mailing Address Line2"
      display_name: "Mailing address line2"
      expr: mailing_address_line2
    - name: "Mailing City"
      display_name: "Mailing city"
      expr: mailing_city
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Claim Party"
      display_name: "Distinct claim party"
      expr: COUNT(DISTINCT claim_party_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Approved Loss Amount"
      display_name: "Total approved loss amount"
      expr: SUM(approved_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Approved Loss Amount"
      display_name: "Average approved loss amount"
      expr: AVG(approved_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Claimed Loss Amount"
      display_name: "Total claimed loss amount"
      expr: SUM(claimed_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Claimed Loss Amount"
      display_name: "Average claimed loss amount"
      expr: AVG(claimed_loss_amount)
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
    - name: "Total Recovery Amount"
      display_name: "Total recovery amount"
      expr: SUM(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recovery Amount"
      display_name: "Average recovery amount"
      expr: AVG(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_coverage_decision`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Coverage Decision business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision`"
  dimensions:
    - name: "Appeal Deadline Date"
      display_name: "Appeal deadline date"
      expr: appeal_deadline_date
    - name: "Appeal Received Date"
      display_name: "Appeal received date"
      expr: appeal_received_date
    - name: "Chain Of Title Break Flag"
      display_name: "Chain of title break flag"
      expr: chain_of_title_break_flag
    - name: "Coverage Analysis Narrative"
      display_name: "Coverage analysis narrative"
      expr: coverage_analysis_narrative
    - name: "Coverage Position"
      display_name: "Coverage position"
      expr: coverage_position
    - name: "Covered Risk Number"
      display_name: "Covered risk number"
      expr: covered_risk_number
    - name: "Curative Resolution Required Flag"
      display_name: "Curative resolution required flag"
      expr: curative_resolution_required_flag
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
    - name: "Denial Reason Code"
      display_name: "Denial reason code"
      expr: denial_reason_code
    - name: "Denial Reason Description"
      display_name: "Denial reason description"
      expr: denial_reason_description
    - name: "Endorsement Applicability Flag"
      display_name: "Endorsement applicability flag"
      expr: endorsement_applicability_flag
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Coverage Decision"
      display_name: "Distinct coverage decision"
      expr: COUNT(DISTINCT coverage_decision_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Covered Loss Amount"
      display_name: "Total covered loss amount"
      expr: SUM(covered_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Covered Loss Amount"
      display_name: "Average covered loss amount"
      expr: AVG(covered_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Denied Loss Amount"
      display_name: "Total denied loss amount"
      expr: SUM(denied_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Denied Loss Amount"
      display_name: "Average denied loss amount"
      expr: AVG(denied_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Excess Amount"
      display_name: "Total excess amount"
      expr: SUM(excess_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Excess Amount"
      display_name: "Average excess amount"
      expr: AVG(excess_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Policy Liability Amount"
      display_name: "Total policy liability amount"
      expr: SUM(policy_liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Policy Liability Amount"
      display_name: "Average policy liability amount"
      expr: AVG(policy_liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Revision Sequence"
      display_name: "Total revision sequence"
      expr: SUM(revision_sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Revision Sequence"
      display_name: "Average revision sequence"
      expr: AVG(revision_sequence)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Event business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`event`"
  dimensions:
    - name: "Claim Number"
      display_name: "Claim number"
      expr: claim_number
    - name: "Coverage Decision"
      display_name: "Coverage decision"
      expr: coverage_decision
    - name: "Coverage Denial Reason"
      display_name: "Coverage denial reason"
      expr: coverage_denial_reason
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Required"
      display_name: "Curative action required"
      expr: curative_action_required
    - name: "Curative Action Type"
      display_name: "Curative action type"
      expr: curative_action_type
    - name: "Curative Resolution Date"
      display_name: "Curative resolution date"
      expr: curative_resolution_date
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Description"
      display_name: "Description"
      expr: event_description
    - name: "Event Timestamp"
      display_name: "Event timestamp"
      expr: event_timestamp
    - name: "Event Type"
      display_name: "Event type"
      expr: event_type
    - name: "Fnol Date"
      display_name: "Fnol date"
      expr: fnol_date
    - name: "Ibnr Flag"
      display_name: "Ibnr flag"
      expr: ibnr_flag
    - name: "Investigation Start Date"
      display_name: "Investigation start date"
      expr: investigation_start_date
    - name: "Loss Date"
      display_name: "Loss date"
      expr: loss_date
    - name: "New Claim Status"
      display_name: "New claim status"
      expr: new_claim_status
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Event"
      display_name: "Distinct event"
      expr: COUNT(DISTINCT event_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Claimed Loss Amount"
      display_name: "Total claimed loss amount"
      expr: SUM(claimed_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Claimed Loss Amount"
      display_name: "Average claimed loss amount"
      expr: AVG(claimed_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Expense Amount"
      display_name: "Total expense amount"
      expr: SUM(expense_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Expense Amount"
      display_name: "Average expense amount"
      expr: AVG(expense_amount)
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
    - name: "Total Loss Payment Amount"
      display_name: "Total loss payment amount"
      expr: SUM(loss_payment_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Loss Payment Amount"
      display_name: "Average loss payment amount"
      expr: AVG(loss_payment_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Prior Reserve Amount"
      display_name: "Total prior reserve amount"
      expr: SUM(prior_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Prior Reserve Amount"
      display_name: "Average prior reserve amount"
      expr: AVG(prior_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Recovery Amount"
      display_name: "Total recovery amount"
      expr: SUM(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recovery Amount"
      display_name: "Average recovery amount"
      expr: AVG(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Reserve Amount"
      display_name: "Total reserve amount"
      expr: SUM(reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Reserve Amount"
      display_name: "Average reserve amount"
      expr: AVG(reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Reserve Change Amount"
      display_name: "Total reserve change amount"
      expr: SUM(reserve_change_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Reserve Change Amount"
      display_name: "Average reserve change amount"
      expr: AVG(reserve_change_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Sequence"
      display_name: "Total sequence"
      expr: SUM(sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Sequence"
      display_name: "Average sequence"
      expr: AVG(sequence)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_investigation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Investigation business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation`"
  dimensions:
    - name: "Agency Involved Flag"
      display_name: "Agency involved flag"
      expr: agency_involved_flag
    - name: "Apn"
      display_name: "Apn"
      expr: apn
    - name: "Chain Of Title Break Flag"
      display_name: "Chain of title break flag"
      expr: chain_of_title_break_flag
    - name: "Claimant Name"
      display_name: "Claimant name"
      expr: claimant_name
    - name: "Completion Date"
      display_name: "Completion date"
      expr: completion_date
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Coverage Analysis Narrative"
      display_name: "Coverage analysis narrative"
      expr: coverage_analysis_narrative
    - name: "Coverage Determination"
      display_name: "Coverage determination"
      expr: coverage_determination
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Required Flag"
      display_name: "Curative action required flag"
      expr: curative_action_required_flag
    - name: "Curative Action Status"
      display_name: "Curative action status"
      expr: curative_action_status
    - name: "Curative Completion Date"
      display_name: "Curative completion date"
      expr: curative_completion_date
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Document Receipt Date"
      display_name: "Document receipt date"
      expr: document_receipt_date
    - name: "Document Request Date"
      display_name: "Document request date"
      expr: document_request_date
    - name: "Eo Coverage Flag"
      display_name: "Eo coverage flag"
      expr: eo_coverage_flag
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Investigation"
      display_name: "Distinct investigation"
      expr: COUNT(DISTINCT investigation_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Estimated Loss Amount"
      display_name: "Total estimated loss amount"
      expr: SUM(estimated_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Estimated Loss Amount"
      display_name: "Average estimated loss amount"
      expr: AVG(estimated_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Policy Amount"
      display_name: "Total policy amount"
      expr: SUM(policy_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Policy Amount"
      display_name: "Average policy amount"
      expr: AVG(policy_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Recommended Reserve Amount"
      display_name: "Total recommended reserve amount"
      expr: SUM(recommended_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recommended Reserve Amount"
      display_name: "Average recommended reserve amount"
      expr: AVG(recommended_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_loss_payment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Loss Payment business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment`"
  dimensions:
    - name: "Approval Authority Level"
      display_name: "Approval authority level"
      expr: approval_authority_level
    - name: "Approval Date"
      display_name: "Approval date"
      expr: approval_date
    - name: "Bank Account Ref"
      display_name: "Bank account ref"
      expr: bank_account_ref
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Claim Number"
      display_name: "Claim number"
      expr: claim_number
    - name: "Cleared Date"
      display_name: "Cleared date"
      expr: cleared_date
    - name: "Cost Center Code"
      display_name: "Cost center code"
      expr: cost_center_code
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Gl Account Code"
      display_name: "Gl account code"
      expr: gl_account_code
    - name: "Irs 1099 Required"
      display_name: "Irs 1099 required"
      expr: irs_1099_required
    - name: "Is Final Payment"
      display_name: "Is final payment"
      expr: is_final_payment
    - name: "Naic Loss Cause Code"
      display_name: "Naic loss cause code"
      expr: naic_loss_cause_code
    - name: "Payee Name"
      display_name: "Payee name"
      expr: payee_name
    - name: "Payee Type"
      display_name: "Payee type"
      expr: payee_type
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Loss Payment"
      display_name: "Distinct loss payment"
      expr: COUNT(DISTINCT loss_payment_id)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Approved Amount"
      display_name: "Total approved amount"
      expr: SUM(approved_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Approved Amount"
      display_name: "Average approved amount"
      expr: AVG(approved_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Cumulative Paid Amount"
      display_name: "Total cumulative paid amount"
      expr: SUM(cumulative_paid_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Cumulative Paid Amount"
      display_name: "Average cumulative paid amount"
      expr: AVG(cumulative_paid_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Payment Amount"
      display_name: "Total payment amount"
      expr: SUM(payment_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Payment Amount"
      display_name: "Average payment amount"
      expr: AVG(payment_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Policy Liability Limit"
      display_name: "Total policy liability limit"
      expr: SUM(policy_liability_limit)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Liability Limit"
      display_name: "Average policy liability limit"
      expr: AVG(policy_liability_limit)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Reserve Release Amount"
      display_name: "Total reserve release amount"
      expr: SUM(reserve_release_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Reserve Release Amount"
      display_name: "Average reserve release amount"
      expr: AVG(reserve_release_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Tax Withholding Amount"
      display_name: "Total tax withholding amount"
      expr: SUM(tax_withholding_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Tax Withholding Amount"
      display_name: "Average tax withholding amount"
      expr: AVG(tax_withholding_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_recovery_receipt`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Recovery Receipt business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt`"
  dimensions:
    - name: "Bank Reference Number"
      display_name: "Bank reference number"
      expr: bank_reference_number
    - name: "Check Number"
      display_name: "Check number"
      expr: check_number
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Gl Account Code"
      display_name: "Gl account code"
      expr: gl_account_code
    - name: "Gl Posting Date"
      display_name: "Gl posting date"
      expr: gl_posting_date
    - name: "Is Final Receipt"
      display_name: "Is final receipt"
      expr: is_final_receipt
    - name: "Is Full Recovery"
      display_name: "Is full recovery"
      expr: is_full_recovery
    - name: "Naic Recovery Code"
      display_name: "Naic recovery code"
      expr: naic_recovery_code
    - name: "Payor Tax Identifier"
      display_name: "Payor tax identifier"
      expr: payor_tax_identifier
    - name: "Policy Type"
      display_name: "Policy type"
      expr: policy_type
    - name: "Receipt Date"
      display_name: "Receipt date"
      expr: receipt_date
    - name: "Receipt Number"
      display_name: "Receipt number"
      expr: receipt_number
    - name: "Recovery Method"
      display_name: "Recovery method"
      expr: recovery_method
    - name: "Recovery Notes"
      display_name: "Recovery notes"
      expr: recovery_notes
    - name: "Recovery Source Name"
      display_name: "Recovery source name"
      expr: recovery_source_name
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Recovery Receipt"
      display_name: "Distinct recovery receipt"
      expr: COUNT(DISTINCT recovery_receipt_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Agent Recovery Share Amount"
      display_name: "Total agent recovery share amount"
      expr: SUM(agent_recovery_share_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Agent Recovery Share Amount"
      display_name: "Average agent recovery share amount"
      expr: AVG(agent_recovery_share_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Applied To Loss Amount"
      display_name: "Total applied to loss amount"
      expr: SUM(applied_to_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Applied To Loss Amount"
      display_name: "Average applied to loss amount"
      expr: AVG(applied_to_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Expected Recovery Amount"
      display_name: "Total expected recovery amount"
      expr: SUM(expected_recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Expected Recovery Amount"
      display_name: "Average expected recovery amount"
      expr: AVG(expected_recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Expense Recovery Amount"
      display_name: "Total expense recovery amount"
      expr: SUM(expense_recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Expense Recovery Amount"
      display_name: "Average expense recovery amount"
      expr: AVG(expense_recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Net Recovery Amount"
      display_name: "Total net recovery amount"
      expr: SUM(net_recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Net Recovery Amount"
      display_name: "Average net recovery amount"
      expr: AVG(net_recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Recovery Amount"
      display_name: "Total recovery amount"
      expr: SUM(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recovery Amount"
      display_name: "Average recovery amount"
      expr: AVG(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Recovery Expense Amount"
      display_name: "Total recovery expense amount"
      expr: SUM(recovery_expense_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recovery Expense Amount"
      display_name: "Average recovery expense amount"
      expr: AVG(recovery_expense_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Recovery Rate Pct"
      display_name: "Total recovery rate pct"
      expr: SUM(recovery_rate_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recovery Rate Pct"
      display_name: "Average recovery rate pct"
      expr: AVG(recovery_rate_pct)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Reserve Reduction Amount"
      display_name: "Total reserve reduction amount"
      expr: SUM(reserve_reduction_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Reserve Reduction Amount"
      display_name: "Average reserve reduction amount"
      expr: AVG(reserve_reduction_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Underwriter Recovery Share Amount"
      display_name: "Total underwriter recovery share amount"
      expr: SUM(underwriter_recovery_share_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Underwriter Recovery Share Amount"
      display_name: "Average underwriter recovery share amount"
      expr: AVG(underwriter_recovery_share_amount)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_regulatory_loss_report`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Regulatory Loss Report business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Actuarial Opinion Date"
      display_name: "Actuarial opinion date"
      expr: actuarial_opinion_date
    - name: "Actuary Certification Flag"
      display_name: "Actuary certification flag"
      expr: actuary_certification_flag
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Filing Confirmation Number"
      display_name: "Filing confirmation number"
      expr: filing_confirmation_number
    - name: "Filing Method"
      display_name: "Filing method"
      expr: filing_method
    - name: "Jurisdiction State Fips"
      display_name: "Jurisdiction state fips"
      expr: jurisdiction_state_fips
    - name: "Jurisdiction State Name"
      display_name: "Jurisdiction state name"
      expr: jurisdiction_state_name
    - name: "Naic Company Code"
      display_name: "Naic company code"
      expr: naic_company_code
    - name: "Policy Type"
      display_name: "Policy type"
      expr: policy_type
    - name: "Preparer Name"
      display_name: "Preparer name"
      expr: preparer_name
    - name: "Preparer Title"
      display_name: "Preparer title"
      expr: preparer_title
    - name: "Production Channel"
      display_name: "Production channel"
      expr: production_channel
    - name: "Regulatory Notes"
      display_name: "Regulatory notes"
      expr: regulatory_notes
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Regulatory Loss Report"
      display_name: "Distinct regulatory loss report"
      expr: COUNT(DISTINCT regulatory_loss_report_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Amendment Number"
      display_name: "Total amendment number"
      expr: SUM(amendment_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Amendment Number"
      display_name: "Average amendment number"
      expr: AVG(amendment_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Average Claim Severity Amt"
      display_name: "Total average claim severity amt"
      expr: SUM(average_claim_severity_amt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Average Claim Severity Amt"
      display_name: "Average average claim severity amt"
      expr: AVG(average_claim_severity_amt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Case Reserve Amt"
      display_name: "Total case reserve amt"
      expr: SUM(case_reserve_amt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Case Reserve Amt"
      display_name: "Average case reserve amt"
      expr: AVG(case_reserve_amt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Claim Count Closed"
      display_name: "Total claim count closed"
      expr: SUM(claim_count_closed)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Claim Count Closed"
      display_name: "Average claim count closed"
      expr: AVG(claim_count_closed)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Claim Count Open End"
      display_name: "Total claim count open end"
      expr: SUM(claim_count_open_end)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Claim Count Open End"
      display_name: "Average claim count open end"
      expr: AVG(claim_count_open_end)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Claim Count Reported"
      display_name: "Total claim count reported"
      expr: SUM(claim_count_reported)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Claim Count Reported"
      display_name: "Average claim count reported"
      expr: AVG(claim_count_reported)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Direct Losses Paid Amt"
      display_name: "Total direct losses paid amt"
      expr: SUM(direct_losses_paid_amt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Direct Losses Paid Amt"
      display_name: "Average direct losses paid amt"
      expr: AVG(direct_losses_paid_amt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Direct Premiums Written Amt"
      display_name: "Total direct premiums written amt"
      expr: SUM(direct_premiums_written_amt)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Direct Premiums Written Amt"
      display_name: "Average direct premiums written amt"
      expr: AVG(direct_premiums_written_amt)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Ibnr Reserve Amt"
      display_name: "Total ibnr reserve amt"
      expr: SUM(ibnr_reserve_amt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Ibnr Reserve Amt"
      display_name: "Average ibnr reserve amt"
      expr: AVG(ibnr_reserve_amt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Loss Adjustment Expense Amt"
      display_name: "Total loss adjustment expense amt"
      expr: SUM(loss_adjustment_expense_amt)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Loss Adjustment Expense Amt"
      display_name: "Average loss adjustment expense amt"
      expr: AVG(loss_adjustment_expense_amt)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Loss Ratio"
      display_name: "Total loss ratio"
      expr: SUM(loss_ratio)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Loss Ratio"
      display_name: "Average loss ratio"
      expr: AVG(loss_ratio)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Net Losses Amt"
      display_name: "Total net losses amt"
      expr: SUM(net_losses_amt)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Net Losses Amt"
      display_name: "Average net losses amt"
      expr: AVG(net_losses_amt)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_reserve`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Reserve business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve`"
  dimensions:
    - name: "Actuarial Method Code"
      display_name: "Actuarial method code"
      expr: actuarial_method_code
    - name: "Adequacy Review Date"
      display_name: "Adequacy review date"
      expr: adequacy_review_date
    - name: "Approval Date"
      display_name: "Approval date"
      expr: approval_date
    - name: "Approval Required"
      display_name: "Approval required"
      expr: approval_required
    - name: "Basis"
      display_name: "Basis"
      expr: basis
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Pending"
      display_name: "Curative action pending"
      expr: curative_action_pending
    - name: "Curative Resolution Date"
      display_name: "Curative resolution date"
      expr: curative_resolution_date
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
    - name: "Large Loss Flag"
      display_name: "Large loss flag"
      expr: large_loss_flag
    - name: "Litigation Flag"
      display_name: "Litigation flag"
      expr: litigation_flag
    - name: "Policy Type"
      display_name: "Policy type"
      expr: policy_type
    - name: "Reserve Number"
      display_name: "Reserve number"
      expr: reserve_number
    - name: "Reserve Status"
      display_name: "Reserve status"
      expr: reserve_status
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Reserve"
      display_name: "Distinct reserve"
      expr: COUNT(DISTINCT reserve_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Accident Year"
      display_name: "Total accident year"
      expr: SUM(accident_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Accident Year"
      display_name: "Average accident year"
      expr: AVG(accident_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Alae Reserve Amount"
      display_name: "Total alae reserve amount"
      expr: SUM(alae_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Alae Reserve Amount"
      display_name: "Average alae reserve amount"
      expr: AVG(alae_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Case Reserve Amount"
      display_name: "Total case reserve amount"
      expr: SUM(case_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Case Reserve Amount"
      display_name: "Average case reserve amount"
      expr: AVG(case_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Ibnr Reserve Amount"
      display_name: "Total ibnr reserve amount"
      expr: SUM(ibnr_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Ibnr Reserve Amount"
      display_name: "Average ibnr reserve amount"
      expr: AVG(ibnr_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Large Loss Threshold Amount"
      display_name: "Total large loss threshold amount"
      expr: SUM(large_loss_threshold_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Large Loss Threshold Amount"
      display_name: "Average large loss threshold amount"
      expr: AVG(large_loss_threshold_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Loss Reserve Amount"
      display_name: "Total loss reserve amount"
      expr: SUM(loss_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Loss Reserve Amount"
      display_name: "Average loss reserve amount"
      expr: AVG(loss_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Net Reserve Amount"
      display_name: "Total net reserve amount"
      expr: SUM(net_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Net Reserve Amount"
      display_name: "Average net reserve amount"
      expr: AVG(net_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Policy Liability Amount"
      display_name: "Total policy liability amount"
      expr: SUM(policy_liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Policy Liability Amount"
      display_name: "Average policy liability amount"
      expr: AVG(policy_liability_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Policy Year"
      display_name: "Total policy year"
      expr: SUM(policy_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Policy Year"
      display_name: "Average policy year"
      expr: AVG(policy_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Reinsurance Recoverable Amount"
      display_name: "Total reinsurance recoverable amount"
      expr: SUM(reinsurance_recoverable_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Reinsurance Recoverable Amount"
      display_name: "Average reinsurance recoverable amount"
      expr: AVG(reinsurance_recoverable_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Reporting Period Quarter"
      display_name: "Total reporting period quarter"
      expr: SUM(reporting_period_quarter)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Reporting Period Quarter"
      display_name: "Average reporting period quarter"
      expr: AVG(reporting_period_quarter)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Reporting Period Year"
      display_name: "Total reporting period year"
      expr: SUM(reporting_period_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Reporting Period Year"
      display_name: "Average reporting period year"
      expr: AVG(reporting_period_year)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`claim_title_claim`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Title Claim business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`"
  dimensions:
    - name: "Chain Of Title Break Flag"
      display_name: "Chain of title break flag"
      expr: chain_of_title_break_flag
    - name: "Claim Number"
      display_name: "Claim number"
      expr: claim_number
    - name: "Claim Status"
      display_name: "Claim status"
      expr: claim_status
    - name: "Claim Type"
      display_name: "Claim type"
      expr: claim_type
    - name: "Closure Date"
      display_name: "Closure date"
      expr: closure_date
    - name: "Closure Reason"
      display_name: "Closure reason"
      expr: closure_reason
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Coverage Analysis Outcome"
      display_name: "Coverage analysis outcome"
      expr: coverage_analysis_outcome
    - name: "Coverage Denial Reason"
      display_name: "Coverage denial reason"
      expr: coverage_denial_reason
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Description"
      display_name: "Curative action description"
      expr: curative_action_description
    - name: "Curative Resolution Flag"
      display_name: "Curative resolution flag"
      expr: curative_resolution_flag
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Fnol Date"
      display_name: "Fnol date"
      expr: fnol_date
    - name: "Fnol Received Timestamp"
      display_name: "Fnol received timestamp"
      expr: fnol_received_timestamp
    - name: "Gap Coverage Flag"
      display_name: "Gap coverage flag"
      expr: gap_coverage_flag
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Title Claim"
      display_name: "Distinct title claim"
      expr: COUNT(DISTINCT title_claim_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Case Reserve Amount"
      display_name: "Total case reserve amount"
      expr: SUM(case_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Case Reserve Amount"
      display_name: "Average case reserve amount"
      expr: AVG(case_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Claimed Loss Amount"
      display_name: "Total claimed loss amount"
      expr: SUM(claimed_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Claimed Loss Amount"
      display_name: "Average claimed loss amount"
      expr: AVG(claimed_loss_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Expense Reserve Amount"
      display_name: "Total expense reserve amount"
      expr: SUM(expense_reserve_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Expense Reserve Amount"
      display_name: "Average expense reserve amount"
      expr: AVG(expense_reserve_amount)
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
    - name: "Total Recovery Amount"
      display_name: "Total recovery amount"
      expr: SUM(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Recovery Amount"
      display_name: "Average recovery amount"
      expr: AVG(recovery_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Reopen Count"
      display_name: "Total reopen count"
      expr: SUM(reopen_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Reopen Count"
      display_name: "Average reopen count"
      expr: AVG(reopen_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Total Paid Expense Amount"
      display_name: "Total total paid expense amount"
      expr: SUM(total_paid_expense_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Total Paid Expense Amount"
      display_name: "Average total paid expense amount"
      expr: AVG(total_paid_expense_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Total Paid Indemnity Amount"
      display_name: "Total total paid indemnity amount"
      expr: SUM(total_paid_indemnity_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Total Paid Indemnity Amount"
      display_name: "Average total paid indemnity amount"
      expr: AVG(total_paid_indemnity_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;
