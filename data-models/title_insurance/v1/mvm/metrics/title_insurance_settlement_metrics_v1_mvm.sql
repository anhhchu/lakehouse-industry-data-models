-- Metric views for domain: settlement | Business: Title_Insurance | Version: 1 | Generated on: 2026-10-31 06:37:33

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`settlement_closing_document`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Closing Document business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Document Number"
      display_name: "Document number"
      expr: document_number
    - name: "Document Source"
      display_name: "Document source"
      expr: document_source
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
    - name: "Erecording Status"
      display_name: "Erecording status"
      expr: erecording_status
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Execution Method"
      display_name: "Execution method"
      expr: execution_method
    - name: "Fips Code"
      display_name: "Fips code"
      expr: fips_code
    - name: "Grantee Name"
      display_name: "Grantee name"
      expr: grantee_name
    - name: "Grantor Name"
      display_name: "Grantor name"
      expr: grantor_name
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Closing Document"
      display_name: "Distinct closing document"
      expr: COUNT(DISTINCT closing_document_id)
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
    - name: "Total Document Page Count"
      display_name: "Total document page count"
      expr: SUM(document_page_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Document Page Count"
      display_name: "Average document page count"
      expr: AVG(document_page_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Document Version"
      display_name: "Total document version"
      expr: SUM(document_version)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Document Version"
      display_name: "Average document version"
      expr: AVG(document_version)
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
    - name: "Total Resubmission Count"
      display_name: "Total resubmission count"
      expr: SUM(resubmission_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Resubmission Count"
      display_name: "Average resubmission count"
      expr: AVG(resubmission_count)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`settlement_closing_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Closing Order business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order`"
  dimensions:
    - name: "Actual Closing Timestamp"
      display_name: "Actual closing timestamp"
      expr: actual_closing_timestamp
    - name: "All Requirements Cleared"
      display_name: "All requirements cleared"
      expr: all_requirements_cleared
    - name: "Cancellation Date"
      display_name: "Cancellation date"
      expr: cancellation_date
    - name: "Cancellation Reason"
      display_name: "Cancellation reason"
      expr: cancellation_reason
    - name: "Cd Acknowledged Date"
      display_name: "Cd acknowledged date"
      expr: cd_acknowledged_date
    - name: "Cd Delivery Date"
      display_name: "Cd delivery date"
      expr: cd_delivery_date
    - name: "Channel Type"
      display_name: "Channel type"
      expr: channel_type
    - name: "Closing Location Type"
      display_name: "Closing location type"
      expr: closing_location_type
    - name: "Closing Method"
      display_name: "Closing method"
      expr: closing_method
    - name: "Closing Readiness Status"
      display_name: "Closing readiness status"
      expr: closing_readiness_status
    - name: "Closing Status"
      display_name: "Closing status"
      expr: closing_status
    - name: "Cpl Issued"
      display_name: "Cpl issued"
      expr: cpl_issued
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Disbursement Date"
      display_name: "Disbursement date"
      expr: disbursement_date
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Closing Order"
      display_name: "Distinct closing order"
      expr: COUNT(DISTINCT closing_order_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Cash To Close Amount"
      display_name: "Total cash to close amount"
      expr: SUM(cash_to_close_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Cash To Close Amount"
      display_name: "Average cash to close amount"
      expr: AVG(cash_to_close_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Earnest Money Deposit Amount"
      display_name: "Total earnest money deposit amount"
      expr: SUM(earnest_money_deposit_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Earnest Money Deposit Amount"
      display_name: "Average earnest money deposit amount"
      expr: AVG(earnest_money_deposit_amount)
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
    - name: "Total Purchase Price Amount"
      display_name: "Total purchase price amount"
      expr: SUM(purchase_price_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Purchase Price Amount"
      display_name: "Average purchase price amount"
      expr: AVG(purchase_price_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Title Premium Lender Amount"
      display_name: "Total title premium lender amount"
      expr: SUM(title_premium_lender_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Title Premium Lender Amount"
      display_name: "Average title premium lender amount"
      expr: AVG(title_premium_lender_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Title Premium Owner Amount"
      display_name: "Total title premium owner amount"
      expr: SUM(title_premium_owner_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Title Premium Owner Amount"
      display_name: "Average title premium owner amount"
      expr: AVG(title_premium_owner_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Total Settlement Charges Amount"
      display_name: "Total total settlement charges amount"
      expr: SUM(total_settlement_charges_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Total Settlement Charges Amount"
      display_name: "Average total settlement charges amount"
      expr: AVG(total_settlement_charges_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`settlement_disbursement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Disbursement business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement`"
  dimensions:
    - name: "Aba Routing Number"
      display_name: "Aba routing number"
      expr: aba_routing_number
    - name: "Authorization Timestamp"
      display_name: "Authorization timestamp"
      expr: authorization_timestamp
    - name: "Authorized By"
      display_name: "Authorized by"
      expr: authorized_by
    - name: "Bank Account Ref"
      display_name: "Bank account ref"
      expr: bank_account_ref
    - name: "Bank Name"
      display_name: "Bank name"
      expr: bank_name
    - name: "Cleared Date"
      display_name: "Cleared date"
      expr: cleared_date
    - name: "Cost Center Code"
      display_name: "Cost center code"
      expr: cost_center_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Disbursement Status"
      display_name: "Disbursement status"
      expr: disbursement_status
    - name: "Disbursement Type"
      display_name: "Disbursement type"
      expr: disbursement_type
    - name: "Escrow Trust Account Number"
      display_name: "Escrow trust account number"
      expr: escrow_trust_account_number
    - name: "Gl Account Code"
      display_name: "Gl account code"
      expr: gl_account_code
    - name: "Is Gap Period Disbursement"
      display_name: "Is gap period disbursement"
      expr: is_gap_period_disbursement
    - name: "Issued Date"
      display_name: "Issued date"
      expr: issued_date
    - name: "Memo"
      display_name: "Memo"
      expr: memo
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Disbursement"
      display_name: "Distinct disbursement"
      expr: COUNT(DISTINCT disbursement_id)
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
    - name: "Total Amount"
      display_name: "Total amount"
      expr: SUM(amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Amount"
      display_name: "Average amount"
      expr: AVG(amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Loan Payoff Amount"
      display_name: "Total loan payoff amount"
      expr: SUM(loan_payoff_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Loan Payoff Amount"
      display_name: "Average loan payoff amount"
      expr: AVG(loan_payoff_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Net Disbursement Amount"
      display_name: "Total net disbursement amount"
      expr: SUM(net_disbursement_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Net Disbursement Amount"
      display_name: "Average net disbursement amount"
      expr: AVG(net_disbursement_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`settlement_escrow_ledger`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Escrow Ledger business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger`"
  dimensions:
    - name: "Actual Closing Date"
      display_name: "Actual closing date"
      expr: actual_closing_date
    - name: "Cpl Issued"
      display_name: "Cpl issued"
      expr: cpl_issued
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Disbursement Authorization Method"
      display_name: "Disbursement authorization method"
      expr: disbursement_authorization_method
    - name: "Emd Received Date"
      display_name: "Emd received date"
      expr: emd_received_date
    - name: "Gl Account Code"
      display_name: "Gl account code"
      expr: gl_account_code
    - name: "Holdback Release Date"
      display_name: "Holdback release date"
      expr: holdback_release_date
    - name: "Iolta Account Flag"
      display_name: "Iolta account flag"
      expr: iolta_account_flag
    - name: "Last Updated Timestamp"
      display_name: "Last updated timestamp"
      expr: last_updated_timestamp
    - name: "Ledger Close Date"
      display_name: "Ledger close date"
      expr: ledger_close_date
    - name: "Ledger Number"
      display_name: "Ledger number"
      expr: ledger_number
    - name: "Ledger Status"
      display_name: "Ledger status"
      expr: ledger_status
    - name: "Ledger Type"
      display_name: "Ledger type"
      expr: ledger_type
    - name: "Opening Date"
      display_name: "Opening date"
      expr: opening_date
    - name: "Out Of Balance Reason"
      display_name: "Out of balance reason"
      expr: out_of_balance_reason
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Escrow Ledger"
      display_name: "Distinct escrow ledger"
      expr: COUNT(DISTINCT escrow_ledger_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Branch Code"
      display_name: "Total branch code"
      expr: SUM(branch_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Branch Code"
      display_name: "Average branch code"
      expr: AVG(branch_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Buyer Funds Amount"
      display_name: "Total buyer funds amount"
      expr: SUM(buyer_funds_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Buyer Funds Amount"
      display_name: "Average buyer funds amount"
      expr: AVG(buyer_funds_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Current Balance"
      display_name: "Total current balance"
      expr: SUM(current_balance)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Current Balance"
      display_name: "Average current balance"
      expr: AVG(current_balance)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Emd Amount"
      display_name: "Total emd amount"
      expr: SUM(emd_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Emd Amount"
      display_name: "Average emd amount"
      expr: AVG(emd_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Escrow Fee Amount"
      display_name: "Total escrow fee amount"
      expr: SUM(escrow_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Escrow Fee Amount"
      display_name: "Average escrow fee amount"
      expr: AVG(escrow_fee_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Holdback Amount"
      display_name: "Total holdback amount"
      expr: SUM(holdback_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Holdback Amount"
      display_name: "Average holdback amount"
      expr: AVG(holdback_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Loan Proceeds Amount"
      display_name: "Total loan proceeds amount"
      expr: SUM(loan_proceeds_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Loan Proceeds Amount"
      display_name: "Average loan proceeds amount"
      expr: AVG(loan_proceeds_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Out Of Balance Amount"
      display_name: "Total out of balance amount"
      expr: SUM(out_of_balance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Out Of Balance Amount"
      display_name: "Average out of balance amount"
      expr: AVG(out_of_balance_amount)
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
    - name: "Total Seller Proceeds Amount"
      display_name: "Total seller proceeds amount"
      expr: SUM(seller_proceeds_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Seller Proceeds Amount"
      display_name: "Average seller proceeds amount"
      expr: AVG(seller_proceeds_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Title Premium Amount"
      display_name: "Total title premium amount"
      expr: SUM(title_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Title Premium Amount"
      display_name: "Average title premium amount"
      expr: AVG(title_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`settlement_escrow_receipt`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Escrow Receipt business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt`"
  dimensions:
    - name: "Ach Trace Number"
      display_name: "Ach trace number"
      expr: ach_trace_number
    - name: "Check Number"
      display_name: "Check number"
      expr: check_number
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Emd Contract Date"
      display_name: "Emd contract date"
      expr: emd_contract_date
    - name: "Emd Flag"
      display_name: "Emd flag"
      expr: emd_flag
    - name: "Fraud Alert Flag"
      display_name: "Fraud alert flag"
      expr: fraud_alert_flag
    - name: "Fraud Alert Notes"
      display_name: "Fraud alert notes"
      expr: fraud_alert_notes
    - name: "Funds Type"
      display_name: "Funds type"
      expr: funds_type
    - name: "Gl Account Code"
      display_name: "Gl account code"
      expr: gl_account_code
    - name: "Iolta Account Flag"
      display_name: "Iolta account flag"
      expr: iolta_account_flag
    - name: "Memo"
      display_name: "Memo"
      expr: memo
    - name: "Positive Pay Submitted Flag"
      display_name: "Positive pay submitted flag"
      expr: positive_pay_submitted_flag
    - name: "Posted Timestamp"
      display_name: "Posted timestamp"
      expr: posted_timestamp
    - name: "Receipt Date"
      display_name: "Receipt date"
      expr: receipt_date
    - name: "Receipt Number"
      display_name: "Receipt number"
      expr: receipt_number
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Escrow Receipt"
      display_name: "Distinct escrow receipt"
      expr: COUNT(DISTINCT escrow_receipt_id)
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
    - name: "Total Branch Code"
      display_name: "Total branch code"
      expr: SUM(branch_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Branch Code"
      display_name: "Average branch code"
      expr: AVG(branch_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Expected Receipt Amount"
      display_name: "Total expected receipt amount"
      expr: SUM(expected_receipt_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Expected Receipt Amount"
      display_name: "Average expected receipt amount"
      expr: AVG(expected_receipt_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Net Receipt Amount"
      display_name: "Total net receipt amount"
      expr: SUM(net_receipt_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Net Receipt Amount"
      display_name: "Average net receipt amount"
      expr: AVG(net_receipt_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Receipt Amount"
      display_name: "Total receipt amount"
      expr: SUM(receipt_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Receipt Amount"
      display_name: "Average receipt amount"
      expr: AVG(receipt_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Variance Amount"
      display_name: "Total variance amount"
      expr: SUM(variance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Variance Amount"
      display_name: "Average variance amount"
      expr: AVG(variance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`settlement_escrow_reconciliation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Escrow Reconciliation business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation`"
  dimensions:
    - name: "Account Type"
      display_name: "Account type"
      expr: account_type
    - name: "Approval Date"
      display_name: "Approval date"
      expr: approval_date
    - name: "Approval Notes"
      display_name: "Approval notes"
      expr: approval_notes
    - name: "Bank Account Number Masked"
      display_name: "Bank account number masked"
      expr: bank_account_number_masked
    - name: "Bank Name"
      display_name: "Bank name"
      expr: bank_name
    - name: "Bank Routing Number"
      display_name: "Bank routing number"
      expr: bank_routing_number
    - name: "Bank Statement Date"
      display_name: "Bank statement date"
      expr: bank_statement_date
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Is Balanced"
      display_name: "Is balanced"
      expr: is_balanced
    - name: "Is Regulatory Reportable"
      display_name: "Is regulatory reportable"
      expr: is_regulatory_reportable
    - name: "Positive Pay Submission Date"
      display_name: "Positive pay submission date"
      expr: positive_pay_submission_date
    - name: "Positive Pay Submitted"
      display_name: "Positive pay submitted"
      expr: positive_pay_submitted
    - name: "Reconciliation Date"
      display_name: "Reconciliation date"
      expr: reconciliation_date
    - name: "Reconciliation Number"
      display_name: "Reconciliation number"
      expr: reconciliation_number
    - name: "Reconciliation Period End Date"
      display_name: "Reconciliation period end date"
      expr: reconciliation_period_end_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Escrow Reconciliation"
      display_name: "Distinct escrow reconciliation"
      expr: COUNT(DISTINCT escrow_reconciliation_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Adjusted Bank Balance"
      display_name: "Total adjusted bank balance"
      expr: SUM(adjusted_bank_balance)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Adjusted Bank Balance"
      display_name: "Average adjusted bank balance"
      expr: AVG(adjusted_bank_balance)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Bank Statement Balance"
      display_name: "Total bank statement balance"
      expr: SUM(bank_statement_balance)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Bank Statement Balance"
      display_name: "Average bank statement balance"
      expr: AVG(bank_statement_balance)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Bank To Ledger Variance"
      display_name: "Total bank to ledger variance"
      expr: SUM(bank_to_ledger_variance)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Bank To Ledger Variance"
      display_name: "Average bank to ledger variance"
      expr: AVG(bank_to_ledger_variance)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Branch Code"
      display_name: "Total branch code"
      expr: SUM(branch_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Branch Code"
      display_name: "Average branch code"
      expr: AVG(branch_code)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Days To Reconcile"
      display_name: "Total days to reconcile"
      expr: SUM(days_to_reconcile)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Days To Reconcile"
      display_name: "Average days to reconcile"
      expr: AVG(days_to_reconcile)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Escrow Ledger Balance"
      display_name: "Total escrow ledger balance"
      expr: SUM(escrow_ledger_balance)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Escrow Ledger Balance"
      display_name: "Average escrow ledger balance"
      expr: AVG(escrow_ledger_balance)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Ledger To File Variance"
      display_name: "Total ledger to file variance"
      expr: SUM(ledger_to_file_variance)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Ledger To File Variance"
      display_name: "Average ledger to file variance"
      expr: AVG(ledger_to_file_variance)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Open File Balance Aggregate"
      display_name: "Total open file balance aggregate"
      expr: SUM(open_file_balance_aggregate)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Open File Balance Aggregate"
      display_name: "Average open file balance aggregate"
      expr: AVG(open_file_balance_aggregate)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Open File Count"
      display_name: "Total open file count"
      expr: SUM(open_file_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Open File Count"
      display_name: "Average open file count"
      expr: AVG(open_file_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Outstanding Check Count"
      display_name: "Total outstanding check count"
      expr: SUM(outstanding_check_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Outstanding Check Count"
      display_name: "Average outstanding check count"
      expr: AVG(outstanding_check_count)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Outstanding Checks Amount"
      display_name: "Total outstanding checks amount"
      expr: SUM(outstanding_checks_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Outstanding Checks Amount"
      display_name: "Average outstanding checks amount"
      expr: AVG(outstanding_checks_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Outstanding Deposits Amount"
      display_name: "Total outstanding deposits amount"
      expr: SUM(outstanding_deposits_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Outstanding Deposits Amount"
      display_name: "Average outstanding deposits amount"
      expr: AVG(outstanding_deposits_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`settlement_premium_charge`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Premium Charge business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge`"
  dimensions:
    - name: "Authorized By"
      display_name: "Authorized by"
      expr: authorized_by
    - name: "Cd Line Item Code"
      display_name: "Cd line item code"
      expr: cd_line_item_code
    - name: "Charge Date"
      display_name: "Charge date"
      expr: charge_date
    - name: "Charge Number"
      display_name: "Charge number"
      expr: charge_number
    - name: "Charge Status"
      display_name: "Charge status"
      expr: charge_status
    - name: "Charge Type"
      display_name: "Charge type"
      expr: charge_type
    - name: "Collected Date"
      display_name: "Collected date"
      expr: collected_date
    - name: "County Fips Code"
      display_name: "County fips code"
      expr: county_fips_code
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Endorsement Type Code"
      display_name: "Endorsement type code"
      expr: endorsement_type_code
    - name: "Gl Account Code"
      display_name: "Gl account code"
      expr: gl_account_code
    - name: "Hud1 Line Number"
      display_name: "Hud1 line number"
      expr: hud1_line_number
    - name: "Notes"
      display_name: "Notes"
      expr: notes
    - name: "Paid By Party"
      display_name: "Paid by party"
      expr: paid_by_party
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
    - name: "Distinct Premium Charge"
      display_name: "Distinct premium charge"
      expr: COUNT(DISTINCT premium_charge_id)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
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
    - name: "Total Base Premium Amount"
      display_name: "Total base premium amount"
      expr: SUM(base_premium_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Base Premium Amount"
      display_name: "Average base premium amount"
      expr: AVG(base_premium_amount)
      format:
        type: currency
        currency_code: USD
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
    - name: "Total Net Charge Amount"
      display_name: "Total net charge amount"
      expr: SUM(net_charge_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Net Charge Amount"
      display_name: "Average net charge amount"
      expr: AVG(net_charge_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Prior Policy Amount"
      display_name: "Total prior policy amount"
      expr: SUM(prior_policy_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Prior Policy Amount"
      display_name: "Average prior policy amount"
      expr: AVG(prior_policy_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Rate Per Thousand"
      display_name: "Total rate per thousand"
      expr: SUM(rate_per_thousand)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Rate Per Thousand"
      display_name: "Average rate per thousand"
      expr: AVG(rate_per_thousand)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Split Percentage"
      display_name: "Total split percentage"
      expr: SUM(split_percentage)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Split Percentage"
      display_name: "Average split percentage"
      expr: AVG(split_percentage)
      format:
        type: percentage
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`settlement_settlement_statement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Settlement Statement business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Closing Date"
      display_name: "Closing date"
      expr: closing_date
    - name: "Closing Location"
      display_name: "Closing location"
      expr: closing_location
    - name: "Closing Method"
      display_name: "Closing method"
      expr: closing_method
    - name: "Cpl Issued"
      display_name: "Cpl issued"
      expr: cpl_issued
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Disbursement Date"
      display_name: "Disbursement date"
      expr: disbursement_date
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Irs 1099s Required"
      display_name: "Irs 1099s required"
      expr: irs_1099s_required
    - name: "Production Channel"
      display_name: "Production channel"
      expr: production_channel
    - name: "Recording Date"
      display_name: "Recording date"
      expr: recording_date
    - name: "Rescission Expiry Date"
      display_name: "Rescission expiry date"
      expr: rescission_expiry_date
    - name: "Revision Reason"
      display_name: "Revision reason"
      expr: revision_reason
    - name: "Settlement Agent Name"
      display_name: "Settlement agent name"
      expr: settlement_agent_name
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Settlement Statement"
      display_name: "Distinct settlement statement"
      expr: COUNT(DISTINCT settlement_statement_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Cash To Close"
      display_name: "Total cash to close"
      expr: SUM(cash_to_close)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Cash To Close"
      display_name: "Average cash to close"
      expr: AVG(cash_to_close)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Earnest Money Deposit"
      display_name: "Total earnest money deposit"
      expr: SUM(earnest_money_deposit)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Earnest Money Deposit"
      display_name: "Average earnest money deposit"
      expr: AVG(earnest_money_deposit)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Gross Amount Due Borrower"
      display_name: "Total gross amount due borrower"
      expr: SUM(gross_amount_due_borrower)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Gross Amount Due Borrower"
      display_name: "Average gross amount due borrower"
      expr: AVG(gross_amount_due_borrower)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Hoa Dues Prorated"
      display_name: "Total hoa dues prorated"
      expr: SUM(hoa_dues_prorated)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Hoa Dues Prorated"
      display_name: "Average hoa dues prorated"
      expr: AVG(hoa_dues_prorated)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Lender Title Premium"
      display_name: "Total lender title premium"
      expr: SUM(lender_title_premium)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Lender Title Premium"
      display_name: "Average lender title premium"
      expr: AVG(lender_title_premium)
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
    - name: "Total Owner Title Premium"
      display_name: "Total owner title premium"
      expr: SUM(owner_title_premium)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Owner Title Premium"
      display_name: "Average owner title premium"
      expr: AVG(owner_title_premium)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Payoff First Mortgage"
      display_name: "Total payoff first mortgage"
      expr: SUM(payoff_first_mortgage)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Payoff First Mortgage"
      display_name: "Average payoff first mortgage"
      expr: AVG(payoff_first_mortgage)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Payoff Second Mortgage"
      display_name: "Total payoff second mortgage"
      expr: SUM(payoff_second_mortgage)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Payoff Second Mortgage"
      display_name: "Average payoff second mortgage"
      expr: AVG(payoff_second_mortgage)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Prorated Taxes"
      display_name: "Total prorated taxes"
      expr: SUM(prorated_taxes)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Prorated Taxes"
      display_name: "Average prorated taxes"
      expr: AVG(prorated_taxes)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Real Estate Commission"
      display_name: "Total real estate commission"
      expr: SUM(real_estate_commission)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Real Estate Commission"
      display_name: "Average real estate commission"
      expr: AVG(real_estate_commission)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Recording Fees"
      display_name: "Total recording fees"
      expr: SUM(recording_fees)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Recording Fees"
      display_name: "Average recording fees"
      expr: AVG(recording_fees)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`settlement_wire_instruction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Wire Instruction business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction`"
  dimensions:
    - name: "Aba Routing Number Token"
      display_name: "Aba routing number token"
      expr: aba_routing_number_token
    - name: "Account Number Token"
      display_name: "Account number token"
      expr: account_number_token
    - name: "Account Type"
      display_name: "Account type"
      expr: account_type
    - name: "Approved By"
      display_name: "Approved by"
      expr: approved_by
    - name: "Approved Timestamp"
      display_name: "Approved timestamp"
      expr: approved_timestamp
    - name: "Bank Address Line1"
      display_name: "Bank address line1"
      expr: bank_address_line1
    - name: "Bank City"
      display_name: "Bank city"
      expr: bank_city
    - name: "Bank Country Code"
      display_name: "Bank country code"
      expr: bank_country_code
    - name: "Bank Name"
      display_name: "Bank name"
      expr: bank_name
    - name: "Bank State"
      display_name: "Bank state"
      expr: bank_state
    - name: "Beneficiary Name"
      display_name: "Beneficiary name"
      expr: beneficiary_name
    - name: "Change Reason"
      display_name: "Change reason"
      expr: change_reason
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Delivery Channel"
      display_name: "Delivery channel"
      expr: delivery_channel
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Wire Instruction"
      display_name: "Distinct wire instruction"
      expr: COUNT(DISTINCT wire_instruction_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Expected Wire Amount"
      display_name: "Total expected wire amount"
      expr: SUM(expected_wire_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Expected Wire Amount"
      display_name: "Average expected wire amount"
      expr: AVG(expected_wire_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;