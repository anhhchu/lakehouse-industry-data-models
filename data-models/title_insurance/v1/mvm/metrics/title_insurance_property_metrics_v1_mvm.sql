-- Metric views for domain: property | Business: Title_Insurance | Version: 1 | Generated on: 2026-10-31 06:37:34

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_easement_restriction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Easement Restriction business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction`"
  dimensions:
    - name: "Appurtenant Flag"
      display_name: "Appurtenant flag"
      expr: appurtenant_flag
    - name: "Benefiting Utility"
      display_name: "Benefiting utility"
      expr: benefiting_utility
    - name: "Blanket Flag"
      display_name: "Blanket flag"
      expr: blanket_flag
    - name: "Book Number"
      display_name: "Book number"
      expr: book_number
    - name: "Cc R Document Name"
      display_name: "Cc r document name"
      expr: cc_r_document_name
    - name: "Classification Change Date"
      display_name: "Classification change date"
      expr: classification_change_date
    - name: "Curative Action Required"
      display_name: "Curative action required"
      expr: curative_action_required
    - name: "Curative Notes"
      display_name: "Curative notes"
      expr: curative_notes
    - name: "Dominant Estate Description"
      display_name: "Dominant estate description"
      expr: dominant_estate_description
    - name: "Easement Subtype"
      display_name: "Easement subtype"
      expr: easement_subtype
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Encroachment Description"
      display_name: "Encroachment description"
      expr: encroachment_description
    - name: "Exception Language"
      display_name: "Exception language"
      expr: exception_language
    - name: "Exclusive Flag"
      display_name: "Exclusive flag"
      expr: exclusive_flag
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
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
    - name: "Distinct Easement Restriction"
      display_name: "Distinct easement restriction"
      expr: COUNT(DISTINCT easement_restriction_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Area Sq Ft"
      display_name: "Total area sq ft"
      expr: SUM(area_sq_ft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Area Sq Ft"
      display_name: "Average area sq ft"
      expr: AVG(area_sq_ft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Width Ft"
      display_name: "Total width ft"
      expr: SUM(width_ft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Width Ft"
      display_name: "Average width ft"
      expr: AVG(width_ft)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_encumbrance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Encumbrance business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance`"
  dimensions:
    - name: "Apn"
      display_name: "Apn"
      expr: apn
    - name: "Balance As Of Date"
      display_name: "Balance as of date"
      expr: balance_as_of_date
    - name: "Case Number"
      display_name: "Case number"
      expr: case_number
    - name: "Classification Changed Date"
      display_name: "Classification changed date"
      expr: classification_changed_date
    - name: "Court Name"
      display_name: "Court name"
      expr: court_name
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Action Type"
      display_name: "Curative action type"
      expr: curative_action_type
    - name: "Curative Completed Date"
      display_name: "Curative completed date"
      expr: curative_completed_date
    - name: "Curative Status"
      display_name: "Curative status"
      expr: curative_status
    - name: "Discovered Date"
      display_name: "Discovered date"
      expr: discovered_date
    - name: "Easement Purpose"
      display_name: "Easement purpose"
      expr: easement_purpose
    - name: "Easement Type"
      display_name: "Easement type"
      expr: easement_type
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Encumbrance Status"
      display_name: "Encumbrance status"
      expr: encumbrance_status
    - name: "Encumbrance Type"
      display_name: "Encumbrance type"
      expr: encumbrance_type
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Encumbrance"
      display_name: "Distinct encumbrance"
      expr: COUNT(DISTINCT encumbrance_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Current Balance Amount"
      display_name: "Total current balance amount"
      expr: SUM(current_balance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Current Balance Amount"
      display_name: "Average current balance amount"
      expr: AVG(current_balance_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Interest Rate"
      display_name: "Total interest rate"
      expr: SUM(interest_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Average Interest Rate"
      display_name: "Average interest rate"
      expr: AVG(interest_rate)
      format:
        type: percentage
        decimal_places:
          type: exact
          places: 2
    - name: "Total Lien Position Number"
      display_name: "Total lien position number"
      expr: SUM(lien_position_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Lien Position Number"
      display_name: "Average lien position number"
      expr: AVG(lien_position_number)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Original Principal Amount"
      display_name: "Total original principal amount"
      expr: SUM(original_principal_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Original Principal Amount"
      display_name: "Average original principal amount"
      expr: AVG(original_principal_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Payoff Demand Amount"
      display_name: "Total payoff demand amount"
      expr: SUM(payoff_demand_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Payoff Demand Amount"
      display_name: "Average payoff demand amount"
      expr: AVG(payoff_demand_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Per Diem Interest Amount"
      display_name: "Total per diem interest amount"
      expr: SUM(per_diem_interest_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Per Diem Interest Amount"
      display_name: "Average per diem interest amount"
      expr: AVG(per_diem_interest_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_grantor_grantee_index`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Grantor Grantee Index business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index`"
  dimensions:
    - name: "Apn"
      display_name: "Apn"
      expr: apn
    - name: "Book Number"
      display_name: "Book number"
      expr: book_number
    - name: "Consideration Currency"
      display_name: "Consideration currency"
      expr: consideration_currency
    - name: "Cot Break Description"
      display_name: "Cot break description"
      expr: cot_break_description
    - name: "Cot Break Flag"
      display_name: "Cot break flag"
      expr: cot_break_flag
    - name: "County Name"
      display_name: "County name"
      expr: county_name
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Estate Type"
      display_name: "Estate type"
      expr: estate_type
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Fips Code"
      display_name: "Fips code"
      expr: fips_code
    - name: "Grantee Entity Type"
      display_name: "Grantee entity type"
      expr: grantee_entity_type
    - name: "Grantee Name As Indexed"
      display_name: "Grantee name as indexed"
      expr: grantee_name_as_indexed
    - name: "Grantee Name Standardized"
      display_name: "Grantee name standardized"
      expr: grantee_name_standardized
    - name: "Grantor Entity Type"
      display_name: "Grantor entity type"
      expr: grantor_entity_type
    - name: "Grantor Name As Indexed"
      display_name: "Grantor name as indexed"
      expr: grantor_name_as_indexed
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Grantor Grantee Index"
      display_name: "Distinct grantor grantee index"
      expr: COUNT(DISTINCT grantor_grantee_index_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Chain Of Title Sequence"
      display_name: "Total chain of title sequence"
      expr: SUM(chain_of_title_sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Chain Of Title Sequence"
      display_name: "Average chain of title sequence"
      expr: AVG(chain_of_title_sequence)
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
    - name: "Total Lien Position"
      display_name: "Total lien position"
      expr: SUM(lien_position)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Lien Position"
      display_name: "Average lien position"
      expr: AVG(lien_position)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_legal_description`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Legal Description business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`"
  dimensions:
    - name: "Block Number"
      display_name: "Block number"
      expr: block_number
    - name: "Building Number"
      display_name: "Building number"
      expr: building_number
    - name: "County Name"
      display_name: "County name"
      expr: county_name
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Description Source"
      display_name: "Description source"
      expr: description_source
    - name: "Description Status"
      display_name: "Description status"
      expr: description_status
    - name: "Description Type"
      display_name: "Description type"
      expr: description_type
    - name: "Description Variance Notes"
      display_name: "Description variance notes"
      expr: description_variance_notes
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Fips County Code"
      display_name: "Fips county code"
      expr: fips_county_code
    - name: "Full Text"
      display_name: "Full text"
      expr: full_text
    - name: "Gap Notes"
      display_name: "Gap notes"
      expr: gap_notes
    - name: "Has Gap Risk"
      display_name: "Has gap risk"
      expr: has_gap_risk
    - name: "Is Current"
      display_name: "Is current"
      expr: is_current
    - name: "Is Schedule A Approved"
      display_name: "Is schedule a approved"
      expr: is_schedule_a_approved
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Legal Description"
      display_name: "Distinct legal description"
      expr: COUNT(DISTINCT legal_description_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Area Acres"
      display_name: "Total area acres"
      expr: SUM(area_acres)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Area Acres"
      display_name: "Average area acres"
      expr: AVG(area_acres)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Area Sq Ft"
      display_name: "Total area sq ft"
      expr: SUM(area_sq_ft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Area Sq Ft"
      display_name: "Average area sq ft"
      expr: AVG(area_sq_ft)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_lifecycle_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Lifecycle Event business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event`"
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
    - name: "Chain Of Title Break"
      display_name: "Chain of title break"
      expr: chain_of_title_break
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Required"
      display_name: "Curative required"
      expr: curative_required
    - name: "Curative Status"
      display_name: "Curative status"
      expr: curative_status
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Encumbrance Type"
      display_name: "Encumbrance type"
      expr: encumbrance_type
    - name: "Erecording Flag"
      display_name: "Erecording flag"
      expr: erecording_flag
    - name: "Event Notes"
      display_name: "Event notes"
      expr: event_notes
    - name: "Event Number"
      display_name: "Event number"
      expr: event_number
    - name: "Event Status"
      display_name: "Event status"
      expr: event_status
    - name: "Event Subtype"
      display_name: "Event subtype"
      expr: event_subtype
    - name: "Event Timestamp"
      display_name: "Event timestamp"
      expr: event_timestamp
    - name: "Event Type"
      display_name: "Event type"
      expr: event_type
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Lifecycle Event"
      display_name: "Distinct lifecycle event"
      expr: COUNT(DISTINCT lifecycle_event_id)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_ownership_interest`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Ownership Interest business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest`"
  dimensions:
    - name: "Acquisition Type"
      display_name: "Acquisition type"
      expr: acquisition_type
    - name: "Book Number"
      display_name: "Book number"
      expr: book_number
    - name: "Cloud On Title Flag"
      display_name: "Cloud on title flag"
      expr: cloud_on_title_flag
    - name: "Consideration Currency"
      display_name: "Consideration currency"
      expr: consideration_currency
    - name: "Cot Break Description"
      display_name: "Cot break description"
      expr: cot_break_description
    - name: "Cot Break Flag"
      display_name: "Cot break flag"
      expr: cot_break_flag
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Entity Type"
      display_name: "Entity type"
      expr: entity_type
    - name: "Examiner Notes"
      display_name: "Examiner notes"
      expr: examiner_notes
    - name: "Execution Date"
      display_name: "Execution date"
      expr: execution_date
    - name: "Expiration Date"
      display_name: "Expiration date"
      expr: expiration_date
    - name: "Gap Period Flag"
      display_name: "Gap period flag"
      expr: gap_period_flag
    - name: "Grantee Name"
      display_name: "Grantee name"
      expr: grantee_name
    - name: "Grantor Name"
      display_name: "Grantor name"
      expr: grantor_name
    - name: "Instrument Number"
      display_name: "Instrument number"
      expr: instrument_number
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Ownership Interest"
      display_name: "Distinct ownership interest"
      expr: COUNT(DISTINCT ownership_interest_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Chain Of Title Sequence"
      display_name: "Total chain of title sequence"
      expr: SUM(chain_of_title_sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Chain Of Title Sequence"
      display_name: "Average chain of title sequence"
      expr: AVG(chain_of_title_sequence)
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

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_parcel`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Parcel business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`"
  dimensions:
    - name: "Apn"
      display_name: "Apn"
      expr: apn
    - name: "Block Number"
      display_name: "Block number"
      expr: block_number
    - name: "County Name"
      display_name: "County name"
      expr: county_name
    - name: "Data Effective Date"
      display_name: "Data effective date"
      expr: data_effective_date
    - name: "Fips Code"
      display_name: "Fips code"
      expr: fips_code
    - name: "Flood Map Panel Number"
      display_name: "Flood map panel number"
      expr: flood_map_panel_number
    - name: "Flood Zone Code"
      display_name: "Flood zone code"
      expr: flood_zone_code
    - name: "Hoa Flag"
      display_name: "Hoa flag"
      expr: hoa_flag
    - name: "Hoa Name"
      display_name: "Hoa name"
      expr: hoa_name
    - name: "Land Use Code"
      display_name: "Land use code"
      expr: land_use_code
    - name: "Lot Number"
      display_name: "Lot number"
      expr: lot_number
    - name: "Mers Min"
      display_name: "Mers min"
      expr: mers_min
    - name: "Parcel Status"
      display_name: "Parcel status"
      expr: parcel_status
    - name: "Parcel Type"
      display_name: "Parcel type"
      expr: parcel_type
    - name: "Pin"
      display_name: "Pin"
      expr: pin
    - name: "Plat Book"
      display_name: "Plat book"
      expr: plat_book
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Parcel"
      display_name: "Distinct parcel"
      expr: COUNT(DISTINCT parcel_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Acreage"
      display_name: "Total acreage"
      expr: SUM(acreage)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Acreage"
      display_name: "Average acreage"
      expr: AVG(acreage)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Annual Tax Amount"
      display_name: "Total annual tax amount"
      expr: SUM(annual_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Annual Tax Amount"
      display_name: "Average annual tax amount"
      expr: AVG(annual_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Assessed Improvement Value"
      display_name: "Total assessed improvement value"
      expr: SUM(assessed_improvement_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Assessed Improvement Value"
      display_name: "Average assessed improvement value"
      expr: AVG(assessed_improvement_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Assessed Land Value"
      display_name: "Total assessed land value"
      expr: SUM(assessed_land_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Assessed Land Value"
      display_name: "Average assessed land value"
      expr: AVG(assessed_land_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Assessed Total Value"
      display_name: "Total assessed total value"
      expr: SUM(assessed_total_value)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Assessed Total Value"
      display_name: "Average assessed total value"
      expr: AVG(assessed_total_value)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Assessment Year"
      display_name: "Total assessment year"
      expr: SUM(assessment_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Assessment Year"
      display_name: "Average assessment year"
      expr: AVG(assessment_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Latitude"
      display_name: "Total latitude"
      expr: SUM(latitude)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Latitude"
      display_name: "Average latitude"
      expr: AVG(latitude)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Longitude"
      display_name: "Total longitude"
      expr: SUM(longitude)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Longitude"
      display_name: "Average longitude"
      expr: AVG(longitude)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Lot Area Sqft"
      display_name: "Total lot area sqft"
      expr: SUM(lot_area_sqft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Lot Area Sqft"
      display_name: "Average lot area sqft"
      expr: AVG(lot_area_sqft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Lot Depth Ft"
      display_name: "Total lot depth ft"
      expr: SUM(lot_depth_ft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Lot Depth Ft"
      display_name: "Average lot depth ft"
      expr: AVG(lot_depth_ft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Lot Width Ft"
      display_name: "Total lot width ft"
      expr: SUM(lot_width_ft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Lot Width Ft"
      display_name: "Average lot width ft"
      expr: AVG(lot_width_ft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Tax Delinquent Amount"
      display_name: "Total tax delinquent amount"
      expr: SUM(tax_delinquent_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Tax Delinquent Amount"
      display_name: "Average tax delinquent amount"
      expr: AVG(tax_delinquent_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_property`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Property business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`property`"
  dimensions:
    - name: "Ccr Flag"
      display_name: "Ccr flag"
      expr: ccr_flag
    - name: "Census Tract"
      display_name: "Census tract"
      expr: census_tract
    - name: "Chain Of Title Break Flag"
      display_name: "Chain of title break flag"
      expr: chain_of_title_break_flag
    - name: "City"
      display_name: "City"
      expr: city
    - name: "Cloud On Title Flag"
      display_name: "Cloud on title flag"
      expr: cloud_on_title_flag
    - name: "Country Code"
      display_name: "Country code"
      expr: country_code
    - name: "County Name"
      display_name: "County name"
      expr: county_name
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Easement Flag"
      display_name: "Easement flag"
      expr: easement_flag
    - name: "Encroachment Flag"
      display_name: "Encroachment flag"
      expr: encroachment_flag
    - name: "Fips Code"
      display_name: "Fips code"
      expr: fips_code
    - name: "Flood Zone Code"
      display_name: "Flood zone code"
      expr: flood_zone_code
    - name: "Flood Zone Determination Date"
      display_name: "Flood zone determination date"
      expr: flood_zone_determination_date
    - name: "Hoa Flag"
      display_name: "Hoa flag"
      expr: hoa_flag
    - name: "Hoa Name"
      display_name: "Hoa name"
      expr: hoa_name
    - name: "Land Use Code"
      display_name: "Land use code"
      expr: land_use_code
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Property"
      display_name: "Distinct property"
      expr: COUNT(DISTINCT property_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Annual Tax Amount"
      display_name: "Total annual tax amount"
      expr: SUM(annual_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Annual Tax Amount"
      display_name: "Average annual tax amount"
      expr: AVG(annual_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Assessed Value"
      display_name: "Total assessed value"
      expr: SUM(assessed_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Assessed Value"
      display_name: "Average assessed value"
      expr: AVG(assessed_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Assessed Value Year"
      display_name: "Total assessed value year"
      expr: SUM(assessed_value_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Assessed Value Year"
      display_name: "Average assessed value year"
      expr: AVG(assessed_value_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Building Sqft"
      display_name: "Total building sqft"
      expr: SUM(building_sqft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Building Sqft"
      display_name: "Average building sqft"
      expr: AVG(building_sqft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Hoa Annual Assessment"
      display_name: "Total hoa annual assessment"
      expr: SUM(hoa_annual_assessment)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Hoa Annual Assessment"
      display_name: "Average hoa annual assessment"
      expr: AVG(hoa_annual_assessment)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Latitude"
      display_name: "Total latitude"
      expr: SUM(latitude)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Latitude"
      display_name: "Average latitude"
      expr: AVG(latitude)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Longitude"
      display_name: "Total longitude"
      expr: SUM(longitude)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Longitude"
      display_name: "Average longitude"
      expr: AVG(longitude)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Lot Size Sqft"
      display_name: "Total lot size sqft"
      expr: SUM(lot_size_sqft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Lot Size Sqft"
      display_name: "Average lot size sqft"
      expr: AVG(lot_size_sqft)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Market Value"
      display_name: "Total market value"
      expr: SUM(market_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Market Value"
      display_name: "Average market value"
      expr: AVG(market_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Number Of Units"
      display_name: "Total number of units"
      expr: SUM(number_of_units)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Number Of Units"
      display_name: "Average number of units"
      expr: AVG(number_of_units)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Tax Year"
      display_name: "Total tax year"
      expr: SUM(tax_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Tax Year"
      display_name: "Average tax year"
      expr: AVG(tax_year)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Year Built"
      display_name: "Total year built"
      expr: SUM(year_built)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Year Built"
      display_name: "Average year built"
      expr: AVG(year_built)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_tax_assessment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Tax Assessment business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment`"
  dimensions:
    - name: "Apn"
      display_name: "Apn"
      expr: apn
    - name: "Appeal Filed Date"
      display_name: "Appeal filed date"
      expr: appeal_filed_date
    - name: "Appeal Flag"
      display_name: "Appeal flag"
      expr: appeal_flag
    - name: "Appeal Resolution Date"
      display_name: "Appeal resolution date"
      expr: appeal_resolution_date
    - name: "Assessment Date"
      display_name: "Assessment date"
      expr: assessment_date
    - name: "Assessment Status"
      display_name: "Assessment status"
      expr: assessment_status
    - name: "Assessment Type"
      display_name: "Assessment type"
      expr: assessment_type
    - name: "Certified Date"
      display_name: "Certified date"
      expr: certified_date
    - name: "Data As Of Date"
      display_name: "Data as of date"
      expr: data_as_of_date
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Exemption Type"
      display_name: "Exemption type"
      expr: exemption_type
    - name: "Fips Code"
      display_name: "Fips code"
      expr: fips_code
    - name: "First Installment Due Date"
      display_name: "First installment due date"
      expr: first_installment_due_date
    - name: "Lien Date"
      display_name: "Lien date"
      expr: lien_date
    - name: "Paid Date"
      display_name: "Paid date"
      expr: paid_date
    - name: "Payment Status"
      display_name: "Payment status"
      expr: payment_status
  measures:
    - name: "Row Count"
      display_name: "Row count"
      expr: COUNT(1)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Distinct Tax Assessment"
      display_name: "Distinct tax assessment"
      expr: COUNT(DISTINCT tax_assessment_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Annual Tax Amount"
      display_name: "Total annual tax amount"
      expr: SUM(annual_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Annual Tax Amount"
      display_name: "Average annual tax amount"
      expr: AVG(annual_tax_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Appeal Adjusted Value"
      display_name: "Total appeal adjusted value"
      expr: SUM(appeal_adjusted_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Appeal Adjusted Value"
      display_name: "Average appeal adjusted value"
      expr: AVG(appeal_adjusted_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Delinquent Amount"
      display_name: "Total delinquent amount"
      expr: SUM(delinquent_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Delinquent Amount"
      display_name: "Average delinquent amount"
      expr: AVG(delinquent_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Exemption Amount"
      display_name: "Total exemption amount"
      expr: SUM(exemption_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Exemption Amount"
      display_name: "Average exemption amount"
      expr: AVG(exemption_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total First Installment Amount"
      display_name: "Total first installment amount"
      expr: SUM(first_installment_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average First Installment Amount"
      display_name: "Average first installment amount"
      expr: AVG(first_installment_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Improvement Assessed Value"
      display_name: "Total improvement assessed value"
      expr: SUM(improvement_assessed_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Improvement Assessed Value"
      display_name: "Average improvement assessed value"
      expr: AVG(improvement_assessed_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Interest Amount"
      display_name: "Total interest amount"
      expr: SUM(interest_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Interest Amount"
      display_name: "Average interest amount"
      expr: AVG(interest_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Land Assessed Value"
      display_name: "Total land assessed value"
      expr: SUM(land_assessed_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Land Assessed Value"
      display_name: "Average land assessed value"
      expr: AVG(land_assessed_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Net Taxable Value"
      display_name: "Total net taxable value"
      expr: SUM(net_taxable_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Net Taxable Value"
      display_name: "Average net taxable value"
      expr: AVG(net_taxable_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Paid Amount"
      display_name: "Total paid amount"
      expr: SUM(paid_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Paid Amount"
      display_name: "Average paid amount"
      expr: AVG(paid_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Penalty Amount"
      display_name: "Total penalty amount"
      expr: SUM(penalty_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Average Penalty Amount"
      display_name: "Average penalty amount"
      expr: AVG(penalty_amount)
      format:
        type: currency
        currency_code: USD
        decimal_places:
          type: exact
          places: 2
    - name: "Total Prior Year Assessed Value"
      display_name: "Total prior year assessed value"
      expr: SUM(prior_year_assessed_value)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Prior Year Assessed Value"
      display_name: "Average prior year assessed value"
      expr: AVG(prior_year_assessed_value)
      format:
        type: number
        decimal_places:
          type: all
$$;

CREATE OR REPLACE VIEW `serverless_stable_dvmvgw_catalog`.`_metrics`.`property_title_evidence`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Title Evidence business metrics"
  source: "`serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`"
  dimensions:
    - name: "Acceptance Date"
      display_name: "Acceptance date"
      expr: acceptance_date
    - name: "Book Number"
      display_name: "Book number"
      expr: book_number
    - name: "Created Timestamp"
      display_name: "Created timestamp"
      expr: created_timestamp
    - name: "Curative Status"
      display_name: "Curative status"
      expr: curative_status
    - name: "Currency Code"
      display_name: "Currency code"
      expr: currency_code
    - name: "Defect Description"
      display_name: "Defect description"
      expr: defect_description
    - name: "Defect Indicator Flag"
      display_name: "Defect indicator flag"
      expr: defect_indicator_flag
    - name: "Document Image Url"
      display_name: "Document image url"
      expr: document_image_url
    - name: "Effective Date"
      display_name: "Effective date"
      expr: effective_date
    - name: "Encumbrance Type"
      display_name: "Encumbrance type"
      expr: encumbrance_type
    - name: "Erecording Flag"
      display_name: "Erecording flag"
      expr: erecording_flag
    - name: "Evidence Number"
      display_name: "Evidence number"
      expr: evidence_number
    - name: "Evidence Status"
      display_name: "Evidence status"
      expr: evidence_status
    - name: "Evidence Subtype"
      display_name: "Evidence subtype"
      expr: evidence_subtype
    - name: "Evidence Type"
      display_name: "Evidence type"
      expr: evidence_type
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
    - name: "Distinct Title Evidence"
      display_name: "Distinct title evidence"
      expr: COUNT(DISTINCT title_evidence_id)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Total Chain Of Title Sequence"
      display_name: "Total chain of title sequence"
      expr: SUM(chain_of_title_sequence)
      format:
        type: number
        decimal_places:
          type: all
    - name: "Average Chain Of Title Sequence"
      display_name: "Average chain of title sequence"
      expr: AVG(chain_of_title_sequence)
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