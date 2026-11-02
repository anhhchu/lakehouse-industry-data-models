-- Schema for Domain: property | Business: Title_Insurance | Version: v1_mvm
-- Generated on: 2026-10-31 06:39:30

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `serverless_stable_dvmvgw_catalog`.`ti_property` COMMENT 'Authoritative SSOT for real-property identity and reference data, modeled as three legally distinct entities: property, parcel, and legal_description. Owns APN/PIN identifiers, FIPS county codes, legal descriptions (metes-and-bounds, PLSS';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` (
    `property_id` BIGINT COMMENT 'Unique surrogate identifier for the real-property asset record. Primary key for the property master entity, consumed as a foreign key by parcel, legal_description, title_order, ownership_interest, and all downstream domain products.',
    `prior_property_id` BIGINT COMMENT 'Self-referencing identifier pointing to the predecessor property record when this property was created from a split, merger, or re-platting event. Preserves chain-of-title continuity and lifecycle history per VREQ-007.',
    `annual_tax_amount` DECIMAL(14,2) COMMENT 'Most recent annual property tax levy amount in USD as recorded by the county tax authority. Used in settlement statement (CD/HUD-1) proration calculations and escrow impound analysis.',
    `assessed_value` DECIMAL(18,2) COMMENT 'Most recent county assessor assessed value of the property in USD. Used as a reference data point for underwriting, policy amount reasonableness checks, and tax lien exposure analysis.',
    `assessed_value_year` BIGINT COMMENT 'Tax year for which the assessed_value was determined by the county assessor. Ensures temporal accuracy when comparing assessed values across multiple tax years.',
    `building_sqft` DECIMAL(14,2) COMMENT 'Total above-grade finished living area or building footprint in square feet as recorded by the county assessor. Supports AVM, underwriting, and policy coverage amount validation.',
    `ccr_flag` BOOLEAN COMMENT 'Indicates whether the property is subject to recorded Covenants, Conditions, and Restrictions (CC&Rs). CC&Rs are listed as Schedule B-II exceptions and reviewed for use restriction violations.',
    `census_tract` STRING COMMENT 'US Census Bureau census tract identifier for the property location. Used for HMDA/CRA regulatory reporting, fair lending analysis, and geographic risk segmentation.. Valid values are `^[0-9]{4,6}(.[0-9]{2})?$`',
    `chain_of_title_break_flag` BOOLEAN COMMENT 'Indicates whether a break in the chain of title has been identified for this property during title examination. A True value requires curative action and underwriting referral before commitment issuance.',
    `city` STRING COMMENT 'City or municipality in which the property is located. Used for jurisdiction determination, recording fee schedules, and regulatory reporting.',
    `cloud_on_title_flag` BOOLEAN COMMENT 'Indicates the presence of an unresolved defect, encumbrance, or adverse claim that impairs the property title. Triggers underwriting referral and curative processing workflow.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the property location. Defaults to USA for domestic transactions; supports cross-border commercial title operations.. Valid values are `^[A-Z]{3}$`',
    `county_name` STRING COMMENT 'Name of the county or parish in which the property is located. Determines the recording jurisdiction, county recorder office, and applicable recording fees and transfer taxes.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the property master record was first created in the lakehouse Silver layer. Supports audit trail, data lineage, and record provenance per VREQ-007.',
    `easement_flag` BOOLEAN COMMENT 'Indicates whether one or more recorded easements (e.g., utility, access, ROW) affect the property. Triggers Schedule B-II exception listing and potential ALTA endorsement requirements.',
    `encroachment_flag` BOOLEAN COMMENT 'Indicates whether a survey or examination has identified an encroachment onto or from the property. May require ALTA survey, curative action, or endorsement to insure over.',
    `fips_code` STRING COMMENT 'Five-digit FIPS county code (2-digit state + 3-digit county) uniquely identifying the county jurisdiction. Used for title plant indexing, recording submission routing, and regulatory geographic reporting.. Valid values are `^[0-9]{5}$`',
    `flood_zone_code` STRING COMMENT 'FEMA National Flood Insurance Program (NFIP) flood zone designation for the property (e.g., AE, X, VE). Informs underwriting risk assessment and mandatory flood insurance disclosure requirements.',
    `flood_zone_determination_date` DATE COMMENT 'Date on which the current FEMA flood zone determination was made for this property. Required for RESPA flood zone disclosure compliance and underwriting file documentation.',
    `hoa_annual_assessment` DECIMAL(14,2) COMMENT 'Annual HOA assessment amount in USD applicable to this property. Used in settlement statement proration and escrow impound calculations where HOA fees are escrowed.',
    `hoa_flag` BOOLEAN COMMENT 'Indicates whether the property is subject to a Homeowners Association (HOA). A True value triggers HOA lien search, assessment verification, and potential title requirement for HOA estoppel letter.',
    `hoa_name` STRING COMMENT 'Legal name of the Homeowners Association governing the property. Required for HOA lien search, estoppel letter request, and CC&R review in the title examination process.',
    `land_use_code` STRING COMMENT 'Assessor or county land use classification code describing the current use of the property (e.g., single-family residential, multi-family, commercial retail). Sourced from the Property Information and County Data System.',
    `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the property in decimal degrees (WGS 84). Supports spatial analysis, flood zone determination, and automated valuation model (AVM) inputs.',
    `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the property in decimal degrees (WGS 84). Supports spatial analysis, flood zone determination, and AVM inputs.',
    `lot_size_sqft` DECIMAL(14,2) COMMENT 'Total land area of the property lot expressed in square feet as recorded by the county assessor. Used in underwriting risk assessment, AVM inputs, and survey comparison.',
    `market_value` DECIMAL(18,2) COMMENT 'Estimated fair market value of the property in USD, sourced from an AVM, appraisal, or broker price opinion. Used for policy amount validation, LTV calculation, and underwriting risk assessment.',
    `market_value_source` STRING COMMENT 'Source methodology used to derive the market_value (AVM, appraisal, broker price opinion, assessor, sale price, or other). Required for provenance tracking and underwriting file documentation.. Valid values are `avm|appraisal|bpo|assessor|sale_price|other`',
    `marketable_title_flag` BOOLEAN COMMENT 'Indicates whether the property currently holds a marketable title status based on the most recent title examination. A False value signals an open cloud on title requiring curative action before policy issuance.',
    `municipality_name` STRING COMMENT 'Name of the incorporated municipality, township, or special district governing the property. Relevant for zoning, building permit history, and local transfer tax determination.',
    `number_of_units` BIGINT COMMENT 'Count of residential or commercial units within the property structure (e.g., 1 for single-family, 4 for a quadplex). Determines applicable policy form and underwriting guidelines.',
    `plat_book` STRING COMMENT 'Recorded plat book number or volume in which the subdivision plat map is filed with the county recorder. Used in legal description verification and chain-of-title assembly.',
    `plat_page` STRING COMMENT 'Recorded plat page or folio number within the plat book where the subdivision map is filed. Used alongside plat_book for precise legal description and title plant cross-reference.',
    `property_status` STRING COMMENT 'Current lifecycle status of the property master record. Tracks whether the property is active in the title plant, has been merged or split into other parcels, condemned, or demolished. Supports chain-of-title continuity.. Valid values are `active|inactive|merged|split|condemned|demolished`',
    `property_type` STRING COMMENT 'Classification of the real-property asset by use category (e.g., residential single-family, commercial, condominium, co-op, vacant land, construction). Drives underwriting rules, policy forms, and endorsement eligibility.. Valid values are `residential|commercial|condo|co_op|vacant_land|construction`',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this property record was originally sourced (e.g., title production system, title plant, county data system). Supports data lineage and provenance tracking.. Valid values are `title_production|title_plant|county_data|crm|other`',
    `source_system_property_ref` STRING COMMENT 'The native property identifier or file number assigned by the originating source system (e.g., SoftPro property ID, DataTrace property key). Enables back-reference to the system of record for reconciliation.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the state in which the property is located. Governs applicable state insurance regulations, recording statutes, and title plant jurisdiction.. Valid values are `^[A-Z]{2}$`',
    `street_address` STRING COMMENT 'Full street address of the property including house number, street name, unit/suite designator. Primary human-readable location identifier used in title commitments, policies, and settlement statements.',
    `subdivision_name` STRING COMMENT 'Name of the recorded plat subdivision or development in which the property is located. Used in legal description assembly, title plant indexing, and CC&R identification.',
    `tax_delinquency_flag` BOOLEAN COMMENT 'Indicates whether the property has any outstanding delinquent property tax amounts as of the most recent tax search. A True value triggers a title requirement for payoff prior to or at closing.',
    `tax_year` BIGINT COMMENT 'Tax year corresponding to the annual_tax_amount. Ensures correct proration period is applied in settlement calculations and identifies potential delinquency exposure.',
    `transaction_type` STRING COMMENT 'Type of real-estate transaction associated with this property record (purchase, refinance, home equity/HELOC, construction, commercial). Determines applicable TRID/RESPA disclosure requirements and title workflow.. Valid values are `purchase|refinance|home_equity|construction|commercial`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the property master record. Used for change detection, incremental ETL processing, and audit trail maintenance.',
    `year_built` BIGINT COMMENT 'Year in which the primary structure on the property was originally constructed, as recorded by the county assessor. Used in underwriting risk scoring and AVM valuation.',
    `zip_code` STRING COMMENT 'USPS ZIP or ZIP+4 postal code for the property location. Used for geographic risk segmentation, premium rating, and regulatory reporting.. Valid values are `^[0-9]{5}(-[0-9]{4})?$`',
    `zoning_code` STRING COMMENT 'Local government zoning classification assigned to the property (e.g., R-1, C-2, M-1). Relevant to underwriting review for use conformity, encroachment analysis, and commercial title risk.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_property PRIMARY KEY(`property_id`)
) COMMENT 'Authoritative SSOT master record for a real-property asset as a legally distinct entity separate from parcel and legal_description. Captures the property type (residential, commercial, condo, co-op, vacant land, construction), transaction type (purchase';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` (
    `parcel_id` BIGINT COMMENT 'Unique surrogate identifier for the assessor parcel record within the title insurance platform. Primary key for the parcel entity.',
    `legal_description_id` BIGINT COMMENT 'Foreign key reference to the authoritative legal description record associated with this parcel. Supports the legally distinct legal_description entity per VREQ-004.',
    `property_id` BIGINT COMMENT 'Foreign key reference to the parent property record. Links the assessor parcel to its associated property entity in the property domain.',
    `acreage` DECIMAL(18,6) COMMENT 'Total land area of the parcel expressed in acres as recorded by the county assessor. Used for property valuation, underwriting risk assessment, and legal description verification.',
    `annual_tax_amount` DECIMAL(18,2) COMMENT 'Annual real property tax amount billed for the parcel based on the assessed value and applicable tax rate. Used in settlement statement proration and escrow impound calculations.',
    `apn` STRING COMMENT 'Assessors Parcel Number assigned by the county assessor office. Primary external identifier used to locate the parcel in county tax and recorder systems.',
    `assessed_improvement_value` DECIMAL(18,2) COMMENT 'County assessors assessed value of improvements (structures) on the parcel, excluding land. Used with assessed_land_value for total assessed value and tax computation.',
    `assessed_land_value` DECIMAL(18,2) COMMENT 'County assessors assessed value of the land component of the parcel, excluding improvements. Used for tax calculation, underwriting valuation, and LTV analysis.',
    `assessed_total_value` DECIMAL(18,2) COMMENT 'Total assessed value of the parcel (land plus improvements) as determined by the county assessor. Used for property tax billing and underwriting risk analysis.',
    `assessment_year` BIGINT COMMENT 'Tax year for which the assessed values on this parcel record are applicable. Used to track annual assessment changes and historical valuation trends.',
    `block_number` STRING COMMENT 'Block number assigned to the parcel within its recorded subdivision plat. Used with lot_number to form the platted legal description.',
    `county_name` STRING COMMENT 'Full name of the county or parish in which the parcel is located as recognized by the county recorder or register of deeds office.',
    `data_effective_date` DATE COMMENT 'Date as of which the parcel data in this record is current and authoritative. Used to track data currency for title search, examination, and ownership interest analysis.',
    `fips_code` STRING COMMENT 'Five-digit FIPS county code identifying the county in which the parcel is located. Used for jurisdictional routing, regulatory reporting, and county recorder integration.. Valid values are `^[0-9]{5}$`',
    `flood_map_panel_number` STRING COMMENT 'FEMA Flood Insurance Rate Map (FIRM) panel number applicable to the parcel. Used with flood_zone_code to identify the specific FIRM panel for flood determination documentation.',
    `flood_zone_code` STRING COMMENT 'FEMA National Flood Insurance Program (NFIP) flood zone designation for the parcel (e.g., AE, X, VE). Used in underwriting risk assessment and lender flood insurance requirements.',
    `hoa_flag` BOOLEAN COMMENT 'Indicates whether the parcel is subject to a Homeowners Association (HOA). A true value requires HOA lien search and assessment verification during title examination.',
    `hoa_name` STRING COMMENT 'Name of the Homeowners Association (HOA) governing the parcel. Used to identify the HOA for lien search, assessment demand, and CC&R review during title examination.',
    `land_use_code` STRING COMMENT 'Assessor land use code assigned to the parcel indicating the specific use classification (e.g., single-family residential, multi-family, commercial retail). Sourced from county assessor records.',
    `latitude` DECIMAL(10,7) COMMENT 'Geographic latitude coordinate of the parcel centroid in decimal degrees (WGS84). Used for spatial analysis, flood zone determination, and property information services.',
    `longitude` DECIMAL(10,7) COMMENT 'Geographic longitude coordinate of the parcel centroid in decimal degrees (WGS84). Used with latitude for spatial analysis, flood zone determination, and mapping.',
    `lot_area_sqft` DECIMAL(18,2) COMMENT 'Total lot area of the parcel expressed in square feet. Complements acreage for residential and commercial underwriting analysis and property information reporting.',
    `lot_depth_ft` DECIMAL(10,2) COMMENT 'Depth of the parcel lot measured in feet as recorded by the county assessor or plat map. Used in legal description verification and encroachment analysis.',
    `lot_number` STRING COMMENT 'Lot number assigned to the parcel within its recorded subdivision plat. Core component of the platted legal description used in title commitments and policies.',
    `lot_width_ft` DECIMAL(10,2) COMMENT 'Width of the parcel lot measured in feet as recorded by the county assessor or plat map. Used in legal description verification and encroachment analysis.',
    `mers_min` STRING COMMENT '18-digit MERS Mortgage Identification Number associated with the parcels registered mortgage. Used to identify and track mortgage assignments in the MERS registry during title search.. Valid values are `^[0-9]{18}$`',
    `parcel_status` STRING COMMENT 'Current lifecycle status of the parcel as maintained by the county assessor. Reflects whether the parcel is active, has been merged into another parcel, split, or retired.. Valid values are `active|inactive|merged|split|retired|pending`',
    `parcel_type` STRING COMMENT 'Classification of the parcel by land use type as determined by the county assessor. Drives underwriting risk segmentation and policy coverage analysis. [ENUM-REF-CANDIDATE: residential|commercial|industrial|agricultural|vacant|mixed_use|exempt — promote. Valid values are `residential|commercial|industrial|agricultural|vacant|mixed_use`',
    `pin` STRING COMMENT 'Parcel Identification Number as assigned by the county recorder or jurisdiction. May differ from APN in jurisdictions that maintain separate assessor and recorder numbering systems.',
    `plat_book` STRING COMMENT 'Plat book number in which the subdivision map for this parcel is recorded at the county recorders office. Used to locate the recorded plat for legal description verification.',
    `plat_page` STRING COMMENT 'Page number within the plat book where the subdivision map for this parcel is recorded. Used with plat_book to locate the recorded plat instrument.',
    `range` STRING COMMENT 'Range designation within the PLSS grid (e.g., R5E). Used with township and section to form the PLSS legal description for rural and unplatted parcels.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the parcel record was first created in the title insurance platform. Supports audit trail and data provenance requirements per ALTA Best Practices and SOC 2.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the parcel record was last modified in the title insurance platform. Used for change detection, data refresh tracking, and audit trail maintenance.',
    `section_number` STRING COMMENT 'Section number within the Public Land Survey System (PLSS) township/range grid. Used for metes-and-bounds and PLSS legal descriptions in non-platted rural parcels.',
    `situs_address_line1` STRING COMMENT 'Primary street address line of the parcels physical location (situs address) as recorded by the county assessor. Distinct from mailing address; used for property identification.',
    `situs_address_line2` STRING COMMENT 'Secondary street address line for the parcels physical location (unit, suite, building number). Supplements situs_address_line1 for multi-unit or complex properties.',
    `situs_city` STRING COMMENT 'City or municipality of the parcels physical situs address as recorded by the county assessor. Used for jurisdictional routing and property information reporting.',
    `situs_zip_code` STRING COMMENT 'Five-digit or ZIP+4 postal code of the parcels physical situs address. Used for property information, tax routing, and geographic analysis.. Valid values are `^[0-9]{5}(-[0-9]{4})?$`',
    `source_system_parcel_key` STRING COMMENT 'Native parcel identifier from the originating Property Information and County Data System (e.g., DataTrace, TitlePoint). Used for lineage tracing and data refresh reconciliation.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the state in which the parcel is located. Used for jurisdictional routing and state department of insurance reporting.. Valid values are `^[A-Z]{2}$`',
    `subdivision_name` STRING COMMENT 'Name of the recorded plat subdivision or development in which the parcel is located. Used in legal description assembly and chain-of-title analysis.',
    `tax_account_number` STRING COMMENT 'Tax account number assigned by the county tax collector or treasurer for billing and collection of real property taxes associated with this parcel.',
    `tax_delinquent_amount` DECIMAL(18,2) COMMENT 'Total amount of delinquent property taxes, penalties, and interest outstanding on the parcel. Populated when tax_delinquent_flag is true; drives title requirement and curative action.',
    `tax_delinquent_flag` BOOLEAN COMMENT 'Indicates whether the parcel has delinquent property taxes as of the last data refresh. A true value triggers a title requirement for tax payoff prior to closing.',
    `tax_exemption_type` STRING COMMENT 'Type of property tax exemption applied to the parcel by the county assessor (e.g., homestead, senior, veteran). Affects tax proration in settlement and underwriting analysis.. Valid values are `homestead|senior|veteran|disability|agricultural|none`',
    `township` STRING COMMENT 'Township designation within the PLSS grid (e.g., T2N). Used with range and section to form the PLSS legal description for rural and unplatted parcels.',
    `zoning_code` STRING COMMENT 'Municipal or county zoning designation for the parcel (e.g., R-1, C-2, M-1). Used in title examination to identify zoning encumbrances and compliance with permitted use.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_parcel PRIMARY KEY(`parcel_id`)
) COMMENT 'Legally distinct entity representing the assessor parcel as defined by the county recorder or assessor office. Owns the APN (Assessors Parcel Number), PIN (Parcel Identification Number), FIPS county code, tax account number, acreage, lot dimensions, and';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` (
    `legal_description_id` BIGINT COMMENT 'Unique surrogate identifier for the legal description record. Primary key for the legal_description entity in the property domain.',
    `prior_description_legal_description_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding version of this legal description. Enables chain-of-description history and prior classification preservation per VREQ-007.',
    `property_id` BIGINT COMMENT 'Reference to the parent property entity. Enables direct linkage from legal description to the property record for title and underwriting workflows.',
    `area_acres` DECIMAL(18,6) COMMENT 'Total land area of the described parcel expressed in acres. Used in underwriting risk assessment, policy coverage determination, and commercial transaction analysis.',
    `area_sq_ft` DECIMAL(18,2) COMMENT 'Total land area of the described parcel expressed in square feet. Commonly used for residential and commercial underwriting and settlement calculations.',
    `block_number` STRING COMMENT 'Block number within the recorded subdivision or plat. Applicable when description_type is plat_subdivision or lot_block. Used with lot_number for full lot-block identification.',
    `building_number` STRING COMMENT 'Building or phase identifier within a condominium or multi-building development. Supplements unit_number for complex condo legal descriptions.',
    `county_name` STRING COMMENT 'Name of the county or parish where the property is located. Used in title search routing, recording submission, and Schedule A formatting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this legal description record was first created in the system. Audit field supporting record provenance and lifecycle tracking.',
    `description_source` STRING COMMENT 'Origin source from which this legal description was extracted or derived. Supports evidence and provenance capture across the title lifecycle. [ENUM-REF-CANDIDATE: recorded_deed|plat_map|alta_survey|title_plant|assessor_record|prior_policy|other — promote',
    `description_status` STRING COMMENT 'Current lifecycle status of this legal description record. Active indicates the current operative description; superseded preserves prior versions per VREQ-007 lifecycle history requirements.. Valid values are `active|superseded|draft|under_review|rejected`',
    `description_type` STRING COMMENT 'Classification of the legal description format. Metes and bounds (M&B), Public Land Survey System (PLSS) township/range/section, plat/subdivision lot-block, condominium unit, or other.. Valid values are `metes_and_bounds|plss|plat_subdivision|lot_block|condo_unit|other`',
    `description_variance_notes` STRING COMMENT 'Narrative notes documenting any discrepancy or variance between this legal description and the description appearing in a prior instrument, commitment, or policy.',
    `effective_date` DATE COMMENT 'Date on which this legal description became operative, typically the recording date of the source instrument. Supports effective-dated history per VREQ-007.',
    `execution_date` DATE COMMENT 'Date the source instrument (deed, plat, or survey) was signed/executed by the grantor or surveyor. Distinct from recording_date and effective_date per VREQ-008.',
    `fips_county_code` STRING COMMENT 'Five-digit FIPS county code identifying the county jurisdiction where the property is located. Used for county recorder routing, tax assessment, and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `full_text` STRING COMMENT 'Complete verbatim text of the legal description as it appears in the recorded instrument or title commitment Schedule A. Authoritative SSOT for the legal description string.',
    `gap_notes` STRING COMMENT 'Examiner or underwriter notes describing the nature of any identified gap between this legal description and the prior recorded description. Supports curative processing.',
    `has_gap_risk` BOOLEAN COMMENT 'Flags whether a gap exists between the legal description in the current instrument and the prior recorded description, indicating potential chain-of-title break or gap coverage need.',
    `is_current` BOOLEAN COMMENT 'Indicates whether this is the currently operative legal description for the associated parcel. True for the active version; False for superseded or historical versions.',
    `is_schedule_a_approved` BOOLEAN COMMENT 'Indicates whether this legal description has been reviewed and approved by the examiner or underwriter for use in the title commitment or policy Schedule A.',
    `lot_number` STRING COMMENT 'Lot number within the recorded subdivision or plat. Applicable when description_type is plat_subdivision or lot_block. Core identifier for platted parcels.',
    `metes_bounds_point_of_beginning` STRING COMMENT 'Narrative description of the point of beginning (POB) for a metes-and-bounds legal description. Applicable when description_type is metes_and_bounds.',
    `plat_book` STRING COMMENT 'Book number or volume of the recorded plat map in the county recorders index. Used to locate the source plat document for title examination.',
    `plat_page` STRING COMMENT 'Page number within the plat book where the subdivision map is recorded. Used in conjunction with plat_book to locate the source plat document.',
    `plss_aliquot_parts` STRING COMMENT 'Aliquot part subdivisions within the PLSS section (e.g., NE1/4 of SW1/4). Applicable when description_type is plss. Provides precise parcel location within a section.',
    `plss_principal_meridian` STRING COMMENT 'Name or code of the PLSS principal meridian governing the township/range/section coordinates (e.g., Willamette, Boise, 6th PM). Applicable when description_type is plss.',
    `plss_range` STRING COMMENT 'Range designation in the PLSS coordinate system (e.g., R3E, R7W). Applicable when description_type is plss. Used in chain-of-title and search indexing.',
    `plss_section` STRING COMMENT 'Section number (1–36) within the PLSS township/range grid. Applicable when description_type is plss. Core identifier for PLSS-based legal descriptions.',
    `plss_state` STRING COMMENT 'Two-letter US state code for the PLSS meridian context. Applicable only when description_type is plss. Identifies the principal meridian jurisdiction.. Valid values are `^[A-Z]{2}$`',
    `plss_township` STRING COMMENT 'Township designation in the PLSS coordinate system (e.g., T2N, T5S). Applicable when description_type is plss. Used in chain-of-title and search indexing.',
    `recording_date` DATE COMMENT 'Date the source instrument establishing this legal description was recorded with the county recorder or register of deeds. Distinct from effective_date per VREQ-008.',
    `recording_reference` STRING COMMENT 'Official recording reference (book/page, document number, or instrument number) of the source instrument from which this legal description derives. Links description to county recorder index.',
    `schedule_a_text` STRING COMMENT 'The legal description text as formatted and printed in the title commitment or policy Schedule A. May differ slightly from the raw recorded instrument text due to standardization.',
    `source_instrument_id` BIGINT COMMENT 'Reference to the recorded instrument (deed, plat, or other document) from which this legal description was extracted. Supports evidence and provenance capture.',
    `standardized_text` STRING COMMENT 'Normalized or standardized version of the legal description text produced by the title plant or search automation system for indexing and comparison purposes.',
    `state_code` STRING COMMENT 'Two-letter US state abbreviation for the jurisdiction where the property is located. Used for state-specific title insurance rate filing and regulatory compliance.. Valid values are `^[A-Z]{2}$`',
    `subdivision_name` STRING COMMENT 'Name of the recorded plat or subdivision as shown on the plat map filed with the county recorder. Applicable when description_type is plat_subdivision or lot_block.',
    `superseded_date` DATE COMMENT 'Date on which this legal description was replaced by a newer version. Null if currently active. Preserves prior classification history per VREQ-007.',
    `survey_date` DATE COMMENT 'Date of the land survey from which the metes-and-bounds or ALTA/NSPS survey legal description was derived. Used to assess description currency and gap risk.',
    `surveyor_license_number` STRING COMMENT 'State-issued professional license number of the land surveyor who prepared the survey. Supports evidence provenance and regulatory compliance verification.',
    `surveyor_name` STRING COMMENT 'Name of the licensed land surveyor or surveying firm that prepared the survey underlying this legal description. Used for evidence provenance and E&O tracking.',
    `title_plant_index_key` STRING COMMENT 'Index key or reference code assigned by the title plant or search automation system (e.g., DataTrace, TitlePoint) to locate this legal description in the plant index.',
    `unit_number` STRING COMMENT 'Unit identifier for condominium or planned unit development descriptions. Applicable when description_type is condo_unit. Used in Schedule A for condo title policies.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this legal description record was last modified. Audit field supporting change tracking and data lineage in the silver layer.',
    `version_number` BIGINT COMMENT 'Sequential version counter for this legal description on the associated parcel. Increments each time the description is revised or corrected, supporting lifecycle revision tracking.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_legal_description PRIMARY KEY(`legal_description_id`)
) COMMENT 'Legally distinct entity capturing the full text and structured components of the propertys legal description as it appears in recorded instruments and title commitments (Schedule A).';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` (
    `ownership_interest_id` BIGINT COMMENT 'Unique surrogate identifier for an effective-dated ownership interest record representing a vested ownership stake in a property held by a party. Primary key per VREQ-005.',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: Each ownership interest is vested according to specific legal description. Critical for gap analysis when legal descriptions change (lot splits, consolidations).',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel entity that this ownership interest encumbers. Links the interest to the authoritative parcel record in the property domain.',
    `party_id` BIGINT COMMENT 'Reference to the party (individual, trust, entity, or co-owner) holding this ownership interest. Supports VREQ-006 multi-role party modeling.',
    `prior_interest_ownership_interest_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding ownership interest record in the chain of title. Enables linked-list traversal of the full ownership history.',
    `property_id` BIGINT COMMENT 'Reference to the parent property entity. Provides the top-level real-property context for this ownership interest record.',
    `acquisition_type` STRING COMMENT 'Nature of the transaction by which this ownership interest was acquired (e.g., purchase, gift, inheritance, foreclosure). Informs underwriting risk classification and chain-of-title analysis.',
    `book_number` STRING COMMENT 'Deed book or volume number assigned by the county recorder where the instrument is indexed. Used in conjunction with page_number for traditional county plant lookups.',
    `chain_of_title_sequence` BIGINT COMMENT 'Sequential position of this ownership interest record within the chain of title (COT) for the parcel. Enables ordered traversal of ownership history and detection of chain-of-title breaks.',
    `cloud_on_title_flag` BOOLEAN COMMENT 'Indicates the presence of a cloud on title — an outstanding claim, encumbrance, or defect that impairs the owners ability to convey clear title. Triggers curative processing.',
    `consideration_amount` DECIMAL(18,2) COMMENT 'Purchase price or consideration stated on the conveying instrument in USD. Used for transfer tax calculation, underwriting risk assessment, and LTV analysis.',
    `consideration_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the consideration amount. Defaults to USD for domestic US transactions.. Valid values are `^[A-Z]{3}$`',
    `cot_break_description` STRING COMMENT 'Narrative description of the nature of the chain-of-title break or gap identified at this interest record. Used by examiners to document curative requirements.',
    `cot_break_flag` BOOLEAN COMMENT 'Indicates whether a break or gap exists in the chain of title at this interest record (e.g., missing link between grantor and prior grantee). Triggers curative action in the examination workflow.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this ownership interest record was first created in the system. Supports audit trail and provenance tracking per VREQ-007.',
    `effective_date` DATE COMMENT 'Date on which this ownership interest became legally effective, typically the recording date of the conveying instrument. Start of the effective-dated ownership period per VREQ-005.',
    `entity_type` STRING COMMENT 'Legal entity classification of the party holding this ownership interest (e.g., individual, LLC, corporation, trust). Drives authority and capacity verification requirements.',
    `evidence_document_id` BIGINT COMMENT 'Reference to the recorded instrument or document that evidences this ownership interest (e.g., warranty deed, quit claim deed). Supports VREQ-005 evidence-backed ownership.',
    `examiner_notes` STRING COMMENT 'Free-text notes entered by the title examiner regarding this ownership interest record, including observations about vesting, authority, or chain-of-title issues.',
    `execution_date` DATE COMMENT 'Date the conveying instrument (deed) was signed by the grantor. Distinct from effective and recording dates per VREQ-008.',
    `expiration_date` DATE COMMENT 'Date on which this ownership interest ended or was superseded by a subsequent conveyance. Null for currently active interests. Closes the effective-dated period per VREQ-005.',
    `gap_period_flag` BOOLEAN COMMENT 'Indicates whether this interest record falls within a gap period (GAP) between the effective search date and the recording of the current transaction. Triggers gap coverage underwriting review.',
    `grantee_name` STRING COMMENT 'Full legal name of the party receiving the interest (grantee) as it appears on the recorded instrument. Supports grantor/grantee index and chain-of-title assembly.',
    `grantor_name` STRING COMMENT 'Full legal name of the party conveying the interest (grantor) as it appears on the recorded instrument. Supports grantor/grantee index and chain-of-title assembly.',
    `instrument_number` STRING COMMENT 'Official document or instrument number assigned by the county recorder at the time of recording. Used to retrieve the recorded instrument from the county index.',
    `instrument_type` STRING COMMENT 'Type of recorded instrument conveying this ownership interest (e.g., Warranty Deed (WD), Quit Claim Deed (QCD), Special Warranty Deed (SWD)). Affects title insurance risk assessment.. Valid values are `warranty_deed|quit_claim_deed|special_warranty_deed|grant_deed|trustee_deed|sheriff_deed`',
    `insurable_title_flag` BOOLEAN COMMENT 'Indicates whether the title associated with this ownership interest is insurable by the underwriter, even if not fully marketable. Distinct from marketable title determination.',
    `interest_status` STRING COMMENT 'Current lifecycle state of this ownership interest record. Active indicates current vested ownership; superseded indicates a prior record replaced by a subsequent conveyance.. Valid values are `active|superseded|released|terminated|pending`',
    `interest_type` STRING COMMENT 'Classification of the estate or interest held (e.g., fee simple, life estate, leasehold). Determines the nature and scope of the ownership right conveyed.. Valid values are `fee_simple|life_estate|leasehold|easement|remainder|reversion`',
    `marketable_title_flag` BOOLEAN COMMENT 'Indicates whether the title associated with this ownership interest has been determined to be marketable (free from reasonable doubt as to validity). Set by the title examiner.',
    `mers_flag` BOOLEAN COMMENT 'Indicates whether the associated mortgage or deed of trust is registered with MERS (Mortgage Electronic Registration Systems), affecting lien holder identification in the chain of title.',
    `ownership_percentage` DECIMAL(7,4) COMMENT 'Fractional ownership share held by this party expressed as a percentage (e.g., 50.0000 for an equal co-owner). Must sum to 100 across all active interests for a parcel.',
    `page_number` STRING COMMENT 'Page number within the deed book where the instrument is recorded. Used with book_number for traditional county plant and title plant index lookups.',
    `prior_classification` STRING COMMENT 'Previous interest_type or vesting_type classification before a reclassification event. Preserves lifecycle history of ownership classification changes per VREQ-007.',
    `reclassification_reason` STRING COMMENT 'Reason for any change in the ownership interest classification or status (e.g., correction of vesting language, court order, curative deed). Supports lifecycle history per VREQ-007.',
    `recording_date` DATE COMMENT 'Date the conveying instrument was officially recorded with the county recorder or register of deeds. Establishes constructive notice and priority. Distinct field per VREQ-008.',
    `source_reference_number` STRING COMMENT 'Identifier assigned by the source system of record to this ownership interest or conveying instrument. Enables traceability and reconciliation back to the originating system.',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this ownership interest record was sourced (e.g., title plant, county recorder, title production system).. Valid values are `title_plant|county_recorder|title_production|property_info`',
    `state_of_formation` STRING COMMENT 'Two-letter US state code where a corporate or LLC entity holding title was formed. Required for entity authority and good-standing verification in underwriting.. Valid values are `^[A-Z]{2}$`',
    `transfer_tax_amount` DECIMAL(18,2) COMMENT 'Documentary transfer tax or deed stamp tax assessed on the conveyance in USD. Calculated from consideration amount and applicable state/county tax rate.',
    `trust_name` STRING COMMENT 'Legal name of the trust holding title, if the vesting type is trust. Required for Schedule A vesting language and trustee authority verification.',
    `trustee_name` STRING COMMENT 'Full legal name of the trustee acting on behalf of a trust that holds title. Required when vesting_type is trust for Schedule A and authority verification.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this ownership interest record was last modified. Supports change tracking, audit trail, and lifecycle history preservation per VREQ-007.',
    `vesting_name` STRING COMMENT 'Exact vesting language as it appears on the deed or title instrument (e.g., John Doe and Jane Doe, as joint tenants). Used verbatim in Schedule A of the title commitment and policy.',
    `vesting_type` STRING COMMENT 'Legal form of title vesting describing how ownership is held among one or more parties (e.g., joint tenancy, tenancy in common, community property). Drives survivorship and transfer rules.. Valid values are `sole_ownership|joint_tenancy|tenancy_in_common|community_property|tenancy_by_entirety|trust`',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_ownership_interest PRIMARY KEY(`ownership_interest_id`)
) COMMENT 'Effective-dated ownership interest record representing a vested ownership stake in a property held by a party (individual, trust, entity, or co-owner). Implements VREQ-005: ownership is modeled as a set of time-bounded interest records supported by';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` (
    `title_evidence_id` BIGINT COMMENT 'Unique surrogate identifier for each title evidence record in the property domain. Primary key for the title_evidence product.',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: Title evidence documents reference specific legal description versions used in chain of title.',
    `ownership_interest_id` BIGINT COMMENT 'Reference to the effective-dated ownership interest record this evidence supports or establishes. Enables evidence-backed chain-of-title analysis.',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel record this evidence pertains to. Anchors evidence to the authoritative parcel entity in the property domain.',
    `superseded_by_evidence_id` BIGINT COMMENT 'Reference to the title_evidence record that supersedes this one when evidence is revised or replaced. Enables forward-chaining of evidence revision history.',
    `title_order_id` BIGINT COMMENT 'Reference to the title order under which this evidence was collected or produced. Links evidence to the originating transaction workflow.',
    `acceptance_date` DATE COMMENT 'Date the county recorder formally accepted the instrument for recording. Distinct from submission_date; used to measure recording acceptance lag and rejection/resubmission tracking.',
    `book_number` STRING COMMENT 'Official deed book or volume number assigned by the county recorder where the instrument is recorded. Used in conjunction with page_number for legacy plant index lookups.',
    `chain_of_title_sequence` BIGINT COMMENT 'Ordinal position of this instrument within the assembled chain of title for the parcel. Enables sequential chain-of-title analysis and break detection.',
    `consideration_amount` DECIMAL(18,2) COMMENT 'Dollar amount of consideration stated on the instrument (e.g., purchase price on a deed). Used for transfer tax calculation, LTV analysis, and underwriting risk assessment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this title_evidence record was first created in the lakehouse. Audit field for record provenance and data lineage tracking.',
    `curative_status` STRING COMMENT 'Current curative processing status for any defect associated with this evidence. Tracks whether curative action is required, in progress, cleared, or an exception has been taken.. Valid values are `not_required|pending|in_progress|cleared|waived|exception_taken`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for monetary amounts on this evidence record. Defaults to USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `defect_description` STRING COMMENT 'Free-text description of the title defect, cloud, or chain-of-title break identified in connection with this evidence record. Populated when defect_indicator_flag is true.',
    `defect_indicator_flag` BOOLEAN COMMENT 'Indicates whether this evidence record has been flagged as containing or contributing to a title defect, cloud on title, or chain-of-title break requiring curative action.',
    `document_image_url` STRING COMMENT 'URL or path to the scanned or electronic image of the source instrument in the document management or imaging system. Supports evidence completeness and provenance verification.',
    `effective_date` DATE COMMENT 'Date the instrument becomes legally effective or operative. May differ from execution and recording dates. Required for effective-dated ownership interest analysis per VREQ-005.',
    `encumbrance_type` STRING COMMENT 'Classification of the encumbrance or restriction evidenced by this instrument. Used for Schedule B-II exception drafting and underwriting risk assessment. [ENUM-REF-CANDIDATE: promote to reference product]',
    `erecording_flag` BOOLEAN COMMENT 'Indicates whether the instrument was submitted and recorded electronically via an eRecording gateway (e.g., Simplifile, CSC eRecording). Used for recording channel analytics.',
    `evidence_number` STRING COMMENT 'Externally-known business identifier assigned to this evidence record by the title production system or document management system. Used for cross-system traceability.. Valid values are `^EVD-[0-9]{8,12}$`',
    `evidence_status` STRING COMMENT 'Current lifecycle state of the evidence record. Tracks whether the evidence is active, has been superseded by a later instrument, voided, or archived per retention policy.. Valid values are `pending|active|superseded|voided|archived`',
    `evidence_subtype` STRING COMMENT 'Further classification within the evidence type (e.g., Warranty Deed, Quit Claim Deed, Deed of Trust, Special Warranty Deed, Mechanics Lien, Tax Lien, Judgment Lien). Supports granular chain-of-title analysis.',
    `evidence_type` STRING COMMENT 'Classification of the source document or data artifact (e.g., deed, mortgage, lien, easement, plat, survey). Drives chain-of-title assembly and defect identification.',
    `examiner_notes` STRING COMMENT 'Free-text notes entered by the title examiner regarding the significance, interpretation, or concerns associated with this evidence record during the examination process.',
    `execution_date` DATE COMMENT 'Date the instrument was signed or executed by the parties. Distinct from effective, recording, and submission dates per VREQ-008 date separation requirements.',
    `fips_code` STRING COMMENT 'Five-digit FIPS county code identifying the county where the instrument was recorded. Used for jurisdiction routing, plant index lookups, and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `gap_period_flag` BOOLEAN COMMENT 'Indicates whether this evidence falls within the gap period between the effective date of the title search and the recording of the insured instrument. Used for gap coverage analysis.',
    `grantee_name` STRING COMMENT 'Name of the grantee (transferee, mortgagee, or lienholder) as it appears on the instrument. Used for grantor/grantee index searches and chain-of-title assembly.',
    `grantor_name` STRING COMMENT 'Name of the grantor (transferor, mortgagor, or lienor) as it appears on the instrument. Used for grantor/grantee index searches and chain-of-title assembly.',
    `image_available_flag` BOOLEAN COMMENT 'Indicates whether a scanned or electronic image of the instrument is available in the document management system. Used for evidence completeness scoring and audit readiness.',
    `instrument_number` STRING COMMENT 'Official instrument or document number assigned by the county recorder or register of deeds upon recording. Primary identifier for recorded instruments in the chain of title.',
    `jurisdiction_name` STRING COMMENT 'Name of the county, parish, or recording jurisdiction where the instrument is recorded. Complements the FIPS code for human-readable reporting and routing.',
    `lien_amount` DECIMAL(18,2) COMMENT 'Dollar amount of the lien, mortgage, or encumbrance stated on the instrument. Applicable for mortgage, deed of trust, mechanics lien, judgment lien, and tax lien evidence types.',
    `notarized_flag` BOOLEAN COMMENT 'Indicates whether the instrument was notarized at execution. Required for recording eligibility in most jurisdictions and for underwriting evidence completeness.',
    `notary_state` STRING COMMENT 'Two-letter US state code of the state in which the instrument was notarized. Used for notarial authority validation and recording eligibility checks.. Valid values are `^[A-Z]{2}$`',
    `page_number` STRING COMMENT 'Official page number within the deed book or volume where the instrument is recorded. Used with book_number for legacy county plant index lookups.',
    `prior_classification` STRING COMMENT 'Previous evidence_type or evidence_subtype classification before any reclassification event. Preserves lifecycle history and prior classifications per VREQ-007.',
    `prior_instrument_number` STRING COMMENT 'Instrument number of the immediately preceding instrument in the chain of title that this evidence links to or satisfies. Used for chain-of-title continuity and break detection.',
    `recording_date` DATE COMMENT 'Date the instrument was officially recorded by the county recorder or register of deeds. Establishes constructive notice and priority in the chain of title.',
    `release_satisfaction_flag` BOOLEAN COMMENT 'Indicates whether this evidence record represents a release, satisfaction, reconveyance, or discharge of a prior encumbrance. True if this instrument clears a prior lien or encumbrance.',
    `retrieved_timestamp` TIMESTAMP COMMENT 'Timestamp when this evidence record was retrieved from the source system or plant index. Represents the principal business event time for evidence collection. Used for search cycle time metrics.',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this evidence record. Incremented each time the evidence is updated or reclassified. Supports lifecycle history and audit trail per VREQ-007.',
    `ron_flag` BOOLEAN COMMENT 'Indicates whether the instrument was notarized via Remote Online Notarization (RON). Relevant for recording eligibility and underwriting risk assessment in RON-enabled jurisdictions.',
    `source_reference_code` STRING COMMENT 'Identifier of this evidence record in the originating source system (e.g., DataTrace document ID, Simplifile submission ID, county plant index key). Enables provenance traceability.',
    `state_code` STRING COMMENT 'Two-letter US state abbreviation for the jurisdiction where the instrument was recorded. Used for state-level regulatory reporting and underwriting authority routing.. Valid values are `^[A-Z]{2}$`',
    `submission_date` DATE COMMENT 'Date the instrument was submitted to the county recorder for recording. Distinct from recording_date; used to track recording submission lag and gap period analysis.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this title_evidence record was last modified in the lakehouse. Audit field for change tracking and incremental processing.',
    `vesting_type` STRING COMMENT 'Form of ownership vesting as stated on the instrument (e.g., joint tenancy, tenancy in common, community property, trust). Critical for ownership interest modeling and policy issuance.. Valid values are `sole_ownership|joint_tenancy|tenancy_in_common|community_property|trust|entity`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_title_evidence PRIMARY KEY(`title_evidence_id`)
) COMMENT 'Provenance and evidence record capturing each source document or data artifact used to establish or support an ownership interest, encumbrance, easement, survey/plat, or chain-of-title link.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` (
    `encumbrance_id` BIGINT COMMENT 'Unique surrogate identifier for each encumbrance, lien, or cloud-on-title record affecting a parcel or property. Primary key of the encumbrance entity.',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: Encumbrances are recorded against specific legal descriptions. When legal descriptions change (lot splits, consolidations), encumbrances must be tracked to correct legal',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel record against which this encumbrance is recorded. Links the encumbrance to the authoritative parcel entity in the property domain.',
    `property_id` BIGINT COMMENT 'Reference to the property record associated with this encumbrance. Supports encumbrances that span multiple parcels under a single property umbrella.',
    `recorded_instrument_id` BIGINT COMMENT 'Foreign key linking to recording.recorded_instrument. Business justification: Encumbrances (mortgages, liens, judgments) are created by recorded instruments—essential for lien priority determination, payoff tracking, and underwriting exception analysis.',
    `title_evidence_id` BIGINT COMMENT 'Foreign key linking to property.title_evidence. Business justification: Encumbrances are discovered through title evidence. Critical for VREQ-009 provenance requirements — every material finding (encumbrance) must reference its evidence source.',
    `apn` STRING COMMENT 'Assessors Parcel Number assigned by the county assessor to the parcel affected by this encumbrance. Cross-reference for tax records and property information system lookups.',
    `balance_as_of_date` DATE COMMENT 'Date as of which the current_balance_amount was determined or reported. Required to assess payoff accuracy and staleness of balance information.',
    `case_number` STRING COMMENT 'Court case number associated with a judgment lien, lis pendens, or foreclosure action. Required for judgment lien and LP encumbrance types to support curative research.',
    `classification_changed_date` DATE COMMENT 'Date on which the encumbrance type or status was reclassified. Used with prior_classification to maintain a lightweight lifecycle history without a full audit table.',
    `court_name` STRING COMMENT 'Name of the court that entered the judgment or filed the lis pendens. Applicable to judgment lien and lis pendens encumbrance types.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this encumbrance record was first created in the system. Audit field supporting data lineage and provenance tracking per VREQ-007.',
    `curative_action_type` STRING COMMENT 'Type of curative action required or taken to resolve this encumbrance (e.g., payoff, release, subordination, satisfaction, reconveyance, discharge). Null if no curative action required.',
    `curative_completed_date` DATE COMMENT 'Date on which the curative action for this encumbrance was completed and the encumbrance was cleared. Populated when curative_status transitions to completed.',
    `curative_status` STRING COMMENT 'Current status of the curative processing effort for this encumbrance (e.g., not required, pending, in progress, completed, waived, escalated). Supports curative aging and closing readiness metrics.. Valid values are `not_required|pending|in_progress|completed|waived|escalated`',
    `current_balance_amount` DECIMAL(18,2) COMMENT 'Most recently known outstanding balance of the encumbrance as of the balance_as_of_date. Used for payoff estimation and underwriting risk assessment. Null for non-monetary encumbrances.',
    `discovered_date` DATE COMMENT 'Date this encumbrance was first identified during a title search or examination. Supports evidence provenance, search completeness auditing, and chain-of-title gap analysis.',
    `easement_purpose` STRING COMMENT 'Stated purpose of the easement (e.g., utility, drainage, access, right-of-way, pipeline). Applicable when encumbrance_type is easement. Supports underwriting exception analysis.',
    `easement_type` STRING COMMENT 'Classification of easement when encumbrance_type is easement (e.g., appurtenant, in gross, prescriptive, implied, express, ROW). Null or not_applicable for non-easement encumbrance types.. Valid values are `appurtenant|in_gross|prescriptive|implied|express|not_applicable`',
    `effective_date` DATE COMMENT 'Date the encumbrance becomes legally effective or binding, which may differ from execution_date or recording_date (e.g., tax lien attachment date). Required per VREQ-008.',
    `encumbrance_status` STRING COMMENT 'Current lifecycle status of the encumbrance indicating whether it remains a cloud on title or has been resolved (e.g., active, released, satisfied, subordinated, expired, disputed, pending cure).',
    `encumbrance_type` STRING COMMENT 'Classification of the encumbrance by legal instrument type (e.g., tax lien, mechanics lien, judgment lien, HOA lien, lis pendens, deed of trust, mortgage, UCC filing, easement, CC&R, encroachment).',
    `execution_date` DATE COMMENT 'Date the encumbrance instrument was signed or executed by the parties. Distinct from recording_date; may precede recording by days or weeks. Required per VREQ-008.',
    `fips_county_code` STRING COMMENT 'Five-digit FIPS county code identifying the county jurisdiction where the encumbrance is recorded. Used for jurisdiction routing, regulatory reporting, and county plant searches.. Valid values are `^[0-9]{5}$`',
    `grantee_name` STRING COMMENT 'Name of the grantee (creditor, lender, beneficiary, or lienholder) as it appears on the recorded instrument. Used in grantor/grantee index searches and lien holder identification.',
    `grantor_name` STRING COMMENT 'Name of the grantor (obligor, debtor, or property owner) as it appears on the recorded instrument creating this encumbrance. Used in grantor/grantee index searches.',
    `hoa_name` STRING COMMENT 'Name of the homeowners association asserting an HOA assessment lien against the property. Applicable to HOA lien encumbrance type. Used for curative demand letter routing.',
    `interest_rate` DECIMAL(8,6) COMMENT 'Annual interest rate applicable to the encumbrance as stated in the underlying instrument. Expressed as a decimal (e.g., 0.065 = 6.5%). Null for non-interest-bearing encumbrances.',
    `is_curative_required` BOOLEAN COMMENT 'Indicates whether a curative action (payoff, release, subordination, or other clearance) is required to resolve this encumbrance prior to or at closing. Drives requirement generation.',
    `is_insured_exception` BOOLEAN COMMENT 'Indicates whether this encumbrance has been listed as a Schedule B-II exception in an issued title commitment or policy. True = exception taken; False = not excepted or insured over.',
    `lien_position_number` BIGINT COMMENT 'Numeric ordinal position of this lien among all liens on the parcel (1 = first lien, 2 = second lien, etc.). Supports automated priority ordering and chain-of-title analysis.',
    `lien_priority` STRING COMMENT 'Priority position of the lien or encumbrance relative to other encumbrances on the same parcel (e.g., first, second, junior, senior, subordinate). Critical for underwriting and foreclosure analysis.. Valid values are `first|second|third|junior|senior|subordinate`',
    `loan_number` STRING COMMENT 'Lender-assigned loan number associated with the mortgage or deed of trust encumbrance. Used to correlate with lender systems for payoff demand and subordination requests.',
    `maturity_date` DATE COMMENT 'Date on which the underlying obligation (mortgage, deed of trust, or lien) is scheduled to mature or expire. Null for perpetual encumbrances such as easements or CC&Rs.',
    `mers_min` STRING COMMENT '18-digit MERS Mortgage Identification Number assigned when the mortgage or deed of trust is registered with MERS. Enables electronic tracking of beneficial ownership and servicing transfers.. Valid values are `^[0-9]{18}$`',
    `notes` STRING COMMENT 'Free-text examiner or underwriter notes describing the nature, history, or curative requirements of this encumbrance. Supports title examination workflow and underwriting referral documentation.',
    `number` STRING COMMENT 'Externally assigned or internally generated reference number uniquely identifying this encumbrance within the title production system (e.g., SoftPro/RamQuest lien reference).',
    `original_principal_amount` DECIMAL(18,2) COMMENT 'Original face amount of the lien, mortgage, deed of trust, or judgment as stated in the recorded instrument. Expressed in USD. Null for non-monetary encumbrances such as easements or CC&Rs.',
    `payoff_demand_amount` DECIMAL(18,2) COMMENT 'Total amount required to fully satisfy and release this encumbrance as stated in the payoff demand letter, valid through payoff_good_through_date. Used in settlement statement preparation.',
    `payoff_good_through_date` DATE COMMENT 'Date through which the payoff demand amount is valid. After this date, a new payoff demand must be obtained. Critical for closing coordination and settlement statement preparation.',
    `per_diem_interest_amount` DECIMAL(10,2) COMMENT 'Daily interest accrual amount on the encumbrance, used to calculate payoff amounts at closing. Expressed in USD. Applicable to interest-bearing liens and mortgages.',
    `prior_classification` STRING COMMENT 'Previous encumbrance_type or encumbrance_status classification before the most recent reclassification. Preserves lifecycle history and prior classifications per VREQ-007.',
    `release_date` DATE COMMENT 'Date the encumbrance was released, satisfied, or reconveyed as recorded with the county. Populated when encumbrance_status transitions to released or satisfied.',
    `release_instrument_number` STRING COMMENT 'Recording instrument number of the release, satisfaction, reconveyance, or discharge document that extinguished this encumbrance. Supports curative evidence and chain-of-title clearance.',
    `source_system_reference` STRING COMMENT 'Identifier or reference code from the originating system of record (e.g., Title Plant, DataTrace, TitlePoint, county plant index) where this encumbrance was discovered or sourced.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the jurisdiction where the encumbrance is recorded. Used for state-specific lien law application and regulatory reporting.. Valid values are `^[A-Z]{2}$`',
    `subtype` STRING COMMENT 'Further classification within the encumbrance type (e.g., federal tax lien vs. state tax lien, purchase money mortgage vs. HELOC, ROW easement vs. utility easement). Supports granular underwriting analysis.',
    `tax_lien_serial_number` STRING COMMENT 'IRS or state-assigned serial number for a federal or state tax lien certificate. Used to verify lien identity and obtain payoff or release from the taxing authority.',
    `tax_year` STRING COMMENT 'Tax year to which a tax lien or delinquent tax encumbrance applies. Applicable to federal, state, and county tax lien types. Supports tax lien aging and curative prioritization.. Valid values are `^[0-9]{4}$`',
    `ucc_filing_number` STRING COMMENT 'Secretary of State filing number for a UCC financing statement encumbering fixtures or personal property associated with the real property. Applicable to UCC filing encumbrance type.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this encumbrance record was last modified. Audit field supporting change tracking, curative workflow monitoring, and data lineage per VREQ-007.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_encumbrance PRIMARY KEY(`encumbrance_id`)
) COMMENT 'Master record for each encumbrance, lien, or cloud on title affecting a parcel or property. Covers tax liens (federal, state, county), mechanics liens, judgment liens, HOA assessment liens, lis pendens (LP), deeds of trust (DOT), mortgages (PMM, HELOC';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` (
    `easement_restriction_id` BIGINT COMMENT 'Unique surrogate identifier for each easement, right-of-way, covenant, condition, restriction, or encroachment record affecting a parcel. Primary key.',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel record that is burdened or benefited by this easement or restriction. Core link to the property domain parcel entity.',
    `property_id` BIGINT COMMENT 'Reference to the parent property record associated with this easement or restriction, supporting property-level aggregation and title analysis.',
    `recorded_instrument_id` BIGINT COMMENT 'Reference to the recorded instrument (deed, plat, declaration, or separate easement document) that created or evidences this easement or restriction.',
    `title_evidence_id` BIGINT COMMENT 'Foreign key linking to property.title_evidence. Business justification: Easements and restrictions are discovered through title evidence documents. Replaces STRING evidence_document_ref with proper FK for provenance tracking per VREQ-009.',
    `appurtenant_flag` BOOLEAN COMMENT 'Indicates whether the easement runs with the land (appurtenant) as opposed to being an easement in gross. True = appurtenant; False = in gross. Affects transferability analysis.',
    `area_sq_ft` DECIMAL(14,2) COMMENT 'Total area of the easement or restricted zone in square feet. Supports underwriting assessment of the proportional impact on the insured parcel.',
    `benefiting_utility` STRING COMMENT 'Name of the utility company, municipality, HOA, or other entity that holds or benefits from the easement. Relevant for utility, drainage, and ROW easements.',
    `blanket_flag` BOOLEAN COMMENT 'Indicates whether the easement is a blanket easement covering the entire parcel without a defined corridor. Blanket easements require special underwriting review and Schedule B-II exception language.',
    `book_number` STRING COMMENT 'Book or volume number in the county recorder index where the creating instrument is recorded. Used for plant search verification and chain-of-title assembly.',
    `cc_r_document_name` STRING COMMENT 'Name or title of the CC&R declaration document that contains the restriction, e.g., Declaration of Covenants, Conditions and Restrictions for [Subdivision Name].',
    `classification_change_date` DATE COMMENT 'Date on which the restriction type or underwriting impact classification was last changed. Supports lifecycle history and audit trail per VREQ-007.',
    `curative_action_required` BOOLEAN COMMENT 'Indicates whether a curative action (e.g., release, subordination, vacation, or survey correction) is required to resolve or modify this easement or restriction prior to closing.',
    `curative_notes` STRING COMMENT 'Free-text notes describing the curative action required or taken to address this easement or restriction, including status of release or vacation proceedings.',
    `dominant_estate_description` STRING COMMENT 'Legal description or narrative identifying the dominant tenement (benefited parcel) for appurtenant easements. Null for easements in gross or restrictions with no dominant estate.',
    `easement_subtype` STRING COMMENT 'Granular classification within the restriction type, e.g., utility easement, drainage easement, access easement, conservation easement, slope easement, pipeline easement.',
    `effective_date` DATE COMMENT 'Date the easement or restriction became legally effective, which may differ from execution or recording date. Distinct field per VREQ-008.',
    `encroachment_description` STRING COMMENT 'Narrative description of any physical encroachment associated with this record, including the encroaching structure, direction, and estimated extent. Populated when restriction_type = encroachment.',
    `exception_language` STRING COMMENT 'Verbatim or standardized exception language used in Schedule B-II of the title commitment or policy for this easement or restriction. Sourced from underwriter-approved language library.',
    `exclusive_flag` BOOLEAN COMMENT 'Indicates whether the easement is exclusive to the grantee, preventing the grantor or other parties from using the same area for the same purpose.',
    `execution_date` DATE COMMENT 'Date the easement or restriction instrument was signed by the grantor. Distinct from recording date and effective date per VREQ-008 date separation requirements.',
    `expiration_date` DATE COMMENT 'Date on which the easement or restriction expires by its own terms, if a fixed term is stated. Null for perpetual easements and restrictions.',
    `fips_code` STRING COMMENT 'Five-digit FIPS county code identifying the county where the easement or restriction is recorded. Supports multi-jurisdiction title plant queries and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `grantee_name` STRING COMMENT 'Name of the party who received the easement benefit or is bound by the restriction, as it appears in the recorded instrument. Supports grantee index and benefited-party identification.',
    `grantor_name` STRING COMMENT 'Name of the party who granted the easement or imposed the restriction, as it appears in the recorded instrument. Supports grantor/grantee index and chain-of-title analysis.',
    `hoa_name` STRING COMMENT 'Name of the Homeowners Association (HOA) that administers or enforces the CC&Rs or restriction, if applicable. Supports HOA lien and assessment tracking.',
    `instrument_number` STRING COMMENT 'County recorder assigned instrument or document number for the creating instrument. Primary external reference for eRecording and plant search systems.',
    `location_description` STRING COMMENT 'Narrative or metes-and-bounds description of the physical location and extent of the easement area or restricted zone on the parcel, as stated in the recorded instrument.',
    `notes` STRING COMMENT 'Free-text notes entered by the title examiner or underwriter regarding the nature, impact, or disposition of this easement or restriction. Supports examination workflow.',
    `page_number` STRING COMMENT 'Page number within the deed book where the creating instrument is recorded. Used together with book_number for precise plant index reference.',
    `permitted_use` STRING COMMENT 'Description of the specific use or activity permitted under the easement, e.g., installation and maintenance of underground utilities, pedestrian access, drainage.',
    `prior_classification` STRING COMMENT 'Previous restriction_type or underwriting_impact classification before the most recent reclassification. Preserves lifecycle history per VREQ-007 material lifecycle transition requirements.',
    `prohibited_use` STRING COMMENT 'Description of uses or activities expressly prohibited by the restriction or covenant, e.g., no structures within easement area, no commercial use, no subdivision below minimum lot size.',
    `recording_date` DATE COMMENT 'Date the instrument creating this easement or restriction was recorded with the county recorder or register of deeds. Establishes constructive notice and priority. Distinct field per VREQ-008.',
    `reference_number` STRING COMMENT 'Externally assigned identifier for this easement or restriction as recorded in the county plant or title plant index, e.g., instrument number, document number, or plant reference.',
    `release_date` DATE COMMENT 'Date on which the easement or restriction was formally released, vacated, or extinguished by recorded instrument. Supports lifecycle history and curative clearance tracking.',
    `release_instrument_number` STRING COMMENT 'County recorder instrument number of the recorded release, satisfaction, or vacation document that extinguished this easement or restriction.',
    `restriction_status` STRING COMMENT 'Current lifecycle state of the easement or restriction. Drives title clearance workflow and Schedule B-II exception inclusion or removal decisions.. Valid values are `active|released|expired|disputed|under_review|vacated`',
    `restriction_text` STRING COMMENT 'Verbatim or summarized text of the restriction, covenant, or easement purpose as stated in the recorded instrument. Used for Schedule B-II exception drafting and underwriting review.',
    `restriction_type` STRING COMMENT 'High-level classification of the use restriction. Drives underwriting treatment and Schedule B-II exception language. [ENUM-REF-CANDIDATE: easement|right_of_way|covenant|encroachment|cc_and_r|restriction|license|profit_a_prendre — promote to reference. Valid values are `easement|right_of_way|covenant|encroachment|cc_and_r|restriction`',
    `schedule_b2_exception_flag` BOOLEAN COMMENT 'Indicates whether this easement or restriction is included as a printed exception in Schedule B-II of the title commitment or policy. True = included as exception.',
    `servient_estate_description` STRING COMMENT 'Legal description or narrative identifying the servient tenement (burdened parcel) for appurtenant easements. Confirms which parcel bears the burden when multiple parcels are involved.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the state in which the easement or restriction is recorded. Supports state-level regulatory and underwriting rule application.. Valid values are `^[A-Z]{2}$`',
    `survey_reference` STRING COMMENT 'Reference to the ALTA/NSPS land title survey or plat map that depicts the easement or encroachment, including surveyor name, date, and job number where available.',
    `underwriting_impact` STRING COMMENT 'Underwriting determination of how this easement or restriction affects insurability. Drives Schedule B-II exception inclusion, referral routing, and curative action assignment.. Valid values are `insurable|non_insurable|exception_required|referral_required|curative_required|informational`',
    `width_ft` DECIMAL(10,2) COMMENT 'Width of the easement corridor or restricted strip in feet, as stated in the recorded instrument. Used for survey verification and encroachment analysis.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_easement_restriction PRIMARY KEY(`easement_restriction_id`)
) COMMENT 'Master record for easements, rights-of-way (ROW), covenants, conditions and restrictions (CC&Rs), encroachments, and other use restrictions affecting a parcel.';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` (
    `tax_assessment_id` BIGINT COMMENT 'Unique surrogate identifier for each tax assessment record in the title insurance property domain. Primary key for the tax_assessment product.',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel entity for which this tax assessment applies. Links the assessment to the authoritative parcel record in the property domain.',
    `property_id` BIGINT COMMENT 'Foreign key linking to property.property. Business justification: Tax assessments roll up to property level for title clearance analysis. While tax_assessment → parcel exists for the legal unit, property-level aggregation is needed for reporting',
    `annual_tax_amount` DECIMAL(18,2) COMMENT 'Total annual property tax levy billed for the parcel for the tax year, computed from net taxable value and tax rate. Used in settlement statement (CD/HUD-1) proration calculations.',
    `apn` STRING COMMENT 'Assessors Parcel Number assigned by the county assessor to uniquely identify the taxable parcel. Also known as PIN (Parcel Identification Number) in some jurisdictions.',
    `appeal_adjusted_value` DECIMAL(18,2) COMMENT 'Revised total assessed value as determined by the county appeals board following a successful appeal. Replaces total_assessed_value for billing if appeal is resolved.',
    `appeal_filed_date` DATE COMMENT 'Date on which the assessment appeal was filed with the county appeals board. Populated only when appeal_flag is true.',
    `appeal_flag` BOOLEAN COMMENT 'Indicates whether a formal appeal of the assessed value has been filed with the county assessment appeals board for this tax year.',
    `appeal_resolution_date` DATE COMMENT 'Date on which the assessment appeal was resolved by the county appeals board. Null if appeal is still pending.',
    `assessment_date` DATE COMMENT 'Date on which the county assessor established the assessed value for this tax year. Represents the principal real-world event date for this assessment record.',
    `assessment_status` STRING COMMENT 'Current lifecycle status of the assessment record: preliminary (not yet certified), certified (official), appealed (under formal appeal), adjusted (post-appeal change), or final.. Valid values are `preliminary|certified|appealed|adjusted|final`',
    `assessment_type` STRING COMMENT 'Classification of the assessment: annual (regular cycle), supplemental (triggered by ownership change or improvement), corrected, escaped (omitted prior year), or special district levy.. Valid values are `annual|supplemental|corrected|escaped|special_district`',
    `certified_date` DATE COMMENT 'Date the county assessor officially certified the assessment roll for this parcel and tax year. Marks transition from preliminary to certified status.',
    `data_as_of_date` DATE COMMENT 'Date as of which the assessment data was retrieved or last refreshed from the county assessor or property information system. Indicates data currency for title examination.',
    `delinquent_amount` DECIMAL(18,2) COMMENT 'Outstanding delinquent tax balance including penalties and interest as of the most recent update. A non-zero value triggers a title requirement for payoff at closing.',
    `effective_date` DATE COMMENT 'Date from which this assessment record is operative for billing and lien purposes. Distinct from assessment_date (valuation date) and lien_date (lien attachment date).',
    `exemption_amount` DECIMAL(18,2) COMMENT 'Dollar amount of assessed value exempted from taxation (e.g., homestead, veteran, senior, or nonprofit exemptions). Reduces the net taxable value.',
    `exemption_type` STRING COMMENT 'Classification of the exemption applied to this assessment: homestead, veteran, senior, nonprofit, agricultural, or none. Affects net taxable value and lien exposure.. Valid values are `homestead|veteran|senior|nonprofit|agricultural|none`',
    `fips_code` STRING COMMENT 'Five-digit FIPS code identifying the state and county of the taxing jurisdiction. Used for jurisdictional routing and regulatory reporting.. Valid values are `^[0-9]{5}$`',
    `first_installment_amount` DECIMAL(18,2) COMMENT 'Amount due for the first installment of the annual property tax bill. Relevant for escrow proration and closing disclosure preparation.',
    `first_installment_due_date` DATE COMMENT 'Due date for the first installment of the property tax bill. Used to determine delinquency status and escrow disbursement timing.',
    `improvement_assessed_value` DECIMAL(18,2) COMMENT 'County assessors assessed value allocated to structures and improvements on the parcel, exclusive of land. Supports LTV and coverage analysis.',
    `interest_amount` DECIMAL(18,2) COMMENT 'Interest charges accrued on delinquent taxes as assessed by the county tax collector. Included in payoff demand for title clearance.',
    `land_assessed_value` DECIMAL(18,2) COMMENT 'County assessors assessed value allocated to the land component of the parcel, exclusive of improvements. Used in underwriting and title risk analysis.',
    `lien_date` DATE COMMENT 'Date on which the property tax lien attaches to the parcel by operation of law. Critical for title examination to determine priority of tax liens relative to other encumbrances.',
    `net_taxable_value` DECIMAL(18,2) COMMENT 'Assessed value after deducting all applicable exemptions. This is the base upon which the tax levy is calculated by the taxing authority.',
    `paid_amount` DECIMAL(18,2) COMMENT 'Total dollar amount paid against this tax assessment to date. Supports partial payment tracking and delinquency calculation.',
    `paid_date` DATE COMMENT 'Date on which the property tax was paid in full or the most recent installment was paid. Used to confirm tax clearance at closing.',
    `payment_status` STRING COMMENT 'Current payment status of the tax bill: paid, unpaid, partial, delinquent, or in_redemption (tax sale redemption period). Drives title clearance and lien exception decisions.. Valid values are `paid|unpaid|partial|delinquent|in_redemption`',
    `penalty_amount` DECIMAL(18,2) COMMENT 'Penalty charges accrued on delinquent taxes as assessed by the county tax collector. Included in payoff demand for title clearance.',
    `prior_year_assessed_value` DECIMAL(18,2) COMMENT 'Total assessed value from the immediately preceding tax year. Supports year-over-year valuation trend analysis and appeal basis determination.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this tax assessment record was first created in the title insurance data platform. Audit field for data lineage and provenance tracking.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this tax assessment record was most recently updated in the title insurance data platform. Supports change tracking and data freshness monitoring.',
    `redemption_expiry_date` DATE COMMENT 'Date by which the prior owner must redeem the parcel after a tax sale. After this date, the tax deed purchaser obtains clear title. Critical for title examination.',
    `second_installment_amount` DECIMAL(18,2) COMMENT 'Amount due for the second installment of the annual property tax bill. Relevant for escrow proration and closing disclosure preparation.',
    `second_installment_due_date` DATE COMMENT 'Due date for the second installment of the property tax bill. Used to determine delinquency status and escrow disbursement timing.',
    `source_system_ref` STRING COMMENT 'Identifier or reference code from the originating county assessor or property information system (e.g., DataTrace, TitlePoint) from which this record was sourced.',
    `special_assessment_amount` DECIMAL(18,2) COMMENT 'Annual dollar amount of special assessments levied against the parcel (e.g., Mello-Roos CFD, local improvement district). Disclosed on the closing disclosure.',
    `special_assessment_flag` BOOLEAN COMMENT 'Indicates whether a special assessment (e.g., Mello-Roos, improvement district, HOA assessment lien) is levied against the parcel in addition to general property taxes.',
    `tax_bill_number` STRING COMMENT 'Externally assigned tax bill or statement number issued by the county tax collector for this assessment year. Used for payment tracking and lien verification.',
    `tax_district_code` STRING COMMENT 'Code identifying the tax rate area or tax district within the county that governs the composite mill rate applied to this parcel.',
    `tax_rate` DECIMAL(10,6) COMMENT 'Composite tax rate (mill rate) applied to the net taxable value to compute the annual tax levy. Expressed as a decimal (e.g., 0.012500 = 1.25%). Includes all overlapping taxing districts.',
    `tax_sale_date` DATE COMMENT 'Date of the tax sale at which the parcel was or is scheduled to be sold for delinquent taxes. Populated only when tax_sale_flag is true.',
    `tax_sale_flag` BOOLEAN COMMENT 'Indicates whether the parcel has been sold or is scheduled for sale at a tax sale due to delinquency. A true value is a critical title defect requiring curative action.',
    `tax_year` BIGINT COMMENT 'Calendar or fiscal year for which this tax assessment applies. Supports year-by-year valuation and payment history tracking per the SSOT mandate.',
    `taxing_authority_name` STRING COMMENT 'Name of the primary taxing authority (county tax collector or treasurer) responsible for billing and collecting property taxes for this parcel.',
    `total_assessed_value` DECIMAL(18,2) COMMENT 'Sum of land and improvement assessed values as certified by the county assessor for the tax year. Authoritative valuation figure for tax billing and title underwriting.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_tax_assessment PRIMARY KEY(`tax_assessment_id`)
) COMMENT 'Annual or supplemental tax and assessment record for a parcel, sourced from the county assessor and tax collector. This product is the AUTHORITATIVE SSOT for year-by-year valuation and payment history; parcel carries only current/point-in-time summary';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` (
    `lifecycle_event_id` BIGINT COMMENT 'Unique surrogate identifier for each property lifecycle event record in the Property Information and County Data System.',
    `easement_restriction_id` BIGINT COMMENT 'Foreign key linking to property.easement_restriction. Business justification: Lifecycle events track easement and restriction changes (grants, releases, modifications).',
    `encumbrance_id` BIGINT COMMENT 'Foreign key linking to property.encumbrance. Business justification: Lifecycle events track lien recordings, releases, and encumbrance status changes. Direct FK to specific encumbrance record needed for complete lifecycle tracking per VREQ-007.',
    `legal_description_id` BIGINT COMMENT 'Reference to the legal_description entity affected by this event. Populated when the event involves a legal description amendment or replacement.',
    `ownership_interest_id` BIGINT COMMENT 'Reference to the ownership_interest record created or superseded by this lifecycle event. Supports effective-dated ownership chain per VREQ-005.',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel entity affected by this lifecycle event. Populated when the event is parcel-specific (e.g., parcel split/merge, APN reassignment).',
    `property_id` BIGINT COMMENT 'Reference to the property entity that is the subject of this lifecycle event. Establishes the authoritative property context for the event.',
    `recording_submission_id` BIGINT COMMENT 'Foreign key linking to recording.recording_submission. Business justification: Lifecycle events track recording submission outcomes (acceptance, rejection, gap periods)—operational workflow for monitoring recording status, gap coverage periods, and policy',
    `superseded_event_id` BIGINT COMMENT 'Self-referencing identifier of the prior lifecycle event that this record supersedes or amends. Null for original events. Preserves revision history and prior classifications per VREQ-007.',
    `tax_assessment_id` BIGINT COMMENT 'Foreign key linking to property.tax_assessment. Business justification: Tax assessment changes (supplemental assessments, appeals, tax lien filings) are material lifecycle events.',
    `title_evidence_id` BIGINT COMMENT 'Foreign key linking to property.title_evidence. Business justification: Lifecycle events are triggered by or documented through title evidence. Links the event to its source evidence document for provenance per VREQ-009 evidence and provenance',
    `title_order_id` BIGINT COMMENT 'Reference to the title order in the Title Production System (e.g., SoftPro/RamQuest) that triggered or is associated with this lifecycle event. Supports end-to-end title workflow traceability.',
    `acceptance_date` DATE COMMENT 'Date the county recorder formally accepted the instrument for recording. Per VREQ-008, distinct from submission_date and recording_date. Null if not yet accepted or rejected.',
    `apn` STRING COMMENT 'Assessors Parcel Number assigned by the county assessor at the time of this lifecycle event. Captures the APN as it existed at event time, supporting parcel split/merge history.',
    `book_number` STRING COMMENT 'Official deed book or volume number assigned by the county recorder where the instrument is indexed. Used in conjunction with page_number for traditional county recording references.',
    `chain_of_title_break` BOOLEAN COMMENT 'Indicates whether this lifecycle event introduces or resolves a break in the chain of title. True signals a COT defect requiring curative action or underwriting review.',
    `consideration_amount` DECIMAL(18,2) COMMENT 'Dollar amount of consideration stated in the instrument evidencing this lifecycle event (e.g., purchase price on a deed). Used for transfer tax calculation and underwriting risk assessment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this lifecycle event record was first created in the lakehouse Silver layer. Audit field distinct from event_timestamp (the real-world event time).',
    `curative_required` BOOLEAN COMMENT 'Indicates whether this lifecycle event requires curative processing to clear a defect, lien, or encumbrance before title can be insured. Drives curative workflow initiation.',
    `curative_status` STRING COMMENT 'Current status of curative processing for this lifecycle event. Tracks progress from identification through clearance or waiver. Null when curative_required is false.. Valid values are `not_required|pending|in_progress|cleared|waived|escalated`',
    `effective_date` DATE COMMENT 'Calendar date on which the lifecycle change becomes legally effective for title and ownership purposes. Per VREQ-008, distinct from execution_date, recording_date, and other document date fields.',
    `encumbrance_type` STRING COMMENT 'Type of encumbrance, easement, or restriction associated with this lifecycle event. Populated for encumbrance_attachment and encumbrance_release event types.',
    `erecording_flag` BOOLEAN COMMENT 'Indicates whether the instrument associated with this lifecycle event was submitted and recorded electronically via an eRecording gateway (e.g., Simplifile, CSC eRecording).',
    `event_notes` STRING COMMENT 'Free-text field for examiner or processor notes describing the nature, context, or significance of this lifecycle event. Supports curative and underwriting review workflows.',
    `event_number` STRING COMMENT 'Externally visible, human-readable identifier for this lifecycle event (e.g., LE-2024-00123). Used for cross-system traceability and audit references.',
    `event_status` STRING COMMENT 'Current workflow state of this lifecycle event record. Superseded indicates a later event has replaced this one; voided indicates the event was recorded in error.. Valid values are `pending|active|superseded|voided|under_review`',
    `event_subtype` STRING COMMENT 'Secondary classification providing finer granularity within an event_type (e.g., within vesting_change: joint_tenancy_to_tenancy_in_common, addition_of_co_owner). Free-form or controlled per event_type.',
    `event_timestamp` TIMESTAMP COMMENT 'The precise date and time the real-world lifecycle transition occurred or was legally effective. This is the principal business event time, distinct from record audit timestamps.',
    `event_type` STRING COMMENT 'Categorical discriminator identifying the kind of material lifecycle transition captured. [ENUM-REF-CANDIDATE',
    `evidence_document_ref` STRING COMMENT 'Reference identifier or URI to the supporting evidence document in the Document Management and Imaging System (e.g., scanned deed, recorded instrument image). Supports evidence provenance per VREQ-007.',
    `execution_date` DATE COMMENT 'Date the underlying instrument or document evidencing this lifecycle event was signed/executed by the parties. Per VREQ-008, distinct from effective_date and recording_date.',
    `fips_code` STRING COMMENT 'Five-digit FIPS county code identifying the jurisdiction where this lifecycle event was recorded. Supports county-level reporting and routing to the correct recorder office.. Valid values are `^[0-9]{5}$`',
    `gap_period_flag` BOOLEAN COMMENT 'Indicates whether this lifecycle event falls within a gap period between the effective date of a title search and the recording of the insured instrument. Supports GAP coverage analysis.',
    `grantee_name` STRING COMMENT 'Name of the grantee (receiving party) associated with the instrument evidencing this lifecycle event. Supports grantor/grantee index and chain-of-title assembly.',
    `grantor_name` STRING COMMENT 'Name of the grantor (transferring party) associated with the instrument evidencing this lifecycle event. Supports grantor/grantee index and chain-of-title assembly.',
    `instrument_number` STRING COMMENT 'Official document/instrument number assigned by the county recorder upon recording. Used to cross-reference the recorded instrument in the county index and title plant.',
    `instrument_type` STRING COMMENT 'Type of recorded instrument evidencing this lifecycle event (e.g., WD, QCD, SWD, DOT, reconveyance). [ENUM-REF-CANDIDATE',
    `lien_amount` DECIMAL(18,2) COMMENT 'Dollar amount of the lien, encumbrance, or judgment associated with this lifecycle event (e.g., mechanics lien, tax lien, HOA assessment). Null for non-lien event types.',
    `new_classification` STRING COMMENT 'The property type, vesting form, parcel status, or legal description classification established by this lifecycle event. Paired with prior_classification to document the transition.',
    `new_vesting` STRING COMMENT 'The vesting language or tenancy form established by this lifecycle event. Null for non-vesting event types. Supports chain-of-title and ownership interest analysis.',
    `notarization_type` STRING COMMENT 'Method by which the instrument was notarized: traditional in-person, Remote Online Notarization (RON), or In-Person Electronic Notarization (IPEN). Supports compliance and validity tracking.. Valid values are `in_person|ron|ipen|traditional`',
    `notary_name` STRING COMMENT 'Name of the notary public who acknowledged the instrument associated with this lifecycle event. Supports document validity verification and RON/IPEN compliance tracking.',
    `page_number` STRING COMMENT 'Official page number within the deed book assigned by the county recorder. Used with book_number for traditional county recording cross-reference.',
    `prior_apn` STRING COMMENT 'The APN that existed before a parcel split, merge, or reassignment event. Null for non-parcel-change events. Supports parcel lineage and chain-of-title continuity.',
    `prior_classification` STRING COMMENT 'The property type, vesting form, parcel status, or legal description classification that existed immediately before this lifecycle event. Preserves prior state per VREQ-007 for chain-of-title and audit analysis.',
    `prior_vesting` STRING COMMENT 'The vesting language or tenancy form (e.g., joint tenancy, tenancy in common, community property) in effect before a vesting_change event. Null for non-vesting event types.',
    `recorded_by_party` STRING COMMENT 'Name of the party (individual, title company, or attorney) who submitted the instrument for recording with the county recorder. Supports recording accountability and audit.',
    `recording_date` DATE COMMENT 'Date the instrument evidencing this lifecycle event was recorded with the county recorder or register of deeds. Per VREQ-008, distinct from execution_date and effective_date.',
    `revision_number` BIGINT COMMENT 'Sequential revision counter for this lifecycle event record. Starts at 1 for the original event; increments with each amendment. Supports lifecycle history tracking per VREQ-007.',
    `revision_reason` STRING COMMENT 'Free-text explanation of why this lifecycle event record was revised or superseded (e.g., corrective deed recorded, APN reassigned by assessor). Required when revision_number > 1.',
    `source_system_event_code` STRING COMMENT 'Native identifier of this lifecycle event in the originating operational system (e.g., DataTrace event ID, Simplifile submission ID). Supports cross-system reconciliation and provenance.',
    `submission_date` DATE COMMENT 'Date the instrument was submitted to the county recorder for recording. Per VREQ-008, distinct from acceptance_date and recording_date. Supports recording rejection and resubmission tracking.',
    `transfer_tax_amount` DECIMAL(18,2) COMMENT 'Documentary transfer tax or deed stamp tax assessed on this lifecycle event by the county or state. Relevant for deed-type events; null for non-transfer events.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this lifecycle event record was last modified in the lakehouse Silver layer. Supports change data capture, audit trails, and incremental processing.',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_lifecycle_event PRIMARY KEY(`lifecycle_event_id`)
) COMMENT 'Transactional record capturing material lifecycle transitions and reclassifications for a property, parcel, or ownership interest per VREQ-007. Event types include: property type reclassification, parcel split/merge, legal description amendment, vesting';

CREATE OR REPLACE TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` (
    `grantor_grantee_index_id` BIGINT COMMENT 'Unique surrogate identifier for each grantor-grantee index record linking a grantor and grantee party to a recorded instrument affecting a parcel or property.',
    `grantor_grantee_party_id` BIGINT COMMENT 'Reference to the party record representing the grantee (transferee, mortgagee, lienholder) named in the recorded instrument.',
    `legal_description_id` BIGINT COMMENT 'Foreign key linking to property.legal_description. Business justification: Each grantor/grantee index entry references specific legal description (property being conveyed).',
    `parcel_id` BIGINT COMMENT 'Reference to the parcel record affected by the recorded instrument captured in this grantor-grantee index entry.',
    `primary_grantor_party_id` BIGINT COMMENT 'Reference to the party record representing the grantor (transferor, mortgagor, lienor) named in the recorded instrument.',
    `prior_index_id` BIGINT COMMENT 'Self-referencing identifier pointing to the immediately preceding grantor-grantee index entry in the chain of title for this parcel, enabling linked-list traversal of ownership history.',
    `property_id` BIGINT COMMENT 'Reference to the property record associated with this grantor-grantee index entry, providing the authoritative property context for the instrument.',
    `recorded_instrument_id` BIGINT COMMENT 'Reference to the recorded instrument (deed, mortgage, release, lien, etc.) that this grantor-grantee index entry indexes.',
    `apn` STRING COMMENT 'Assessors Parcel Number as it appears on the recorded instrument or in the county index, used to link the index entry to the parcel record and support property-specific chain-of-title searches.',
    `book_number` STRING COMMENT 'Official deed book or volume number assigned by the county recorder where the instrument is physically or digitally recorded, used for traditional book-and-page citation.',
    `chain_of_title_sequence` BIGINT COMMENT 'Ordinal sequence number of this index entry within the chain of title for the parcel, enabling ordered traversal of ownership history from earliest to most recent conveyance.',
    `consideration_amount` DECIMAL(18,2) COMMENT 'Dollar amount of consideration stated in the instrument (e.g., purchase price on a deed). May be nominal ($1.00) or actual; used for transfer tax calculation and market value analysis.',
    `consideration_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the consideration amount stated in the instrument. Typically USD for domestic US title transactions.. Valid values are `^[A-Z]{3}$`',
    `cot_break_description` STRING COMMENT 'Free-text description of the nature of the chain-of-title break detected at this index entry, used by examiners to document the defect and initiate curative processing.',
    `cot_break_flag` BOOLEAN COMMENT 'Indicates a detected break or gap in the chain of title at this index entry (e.g., grantor does not match prior grantee), triggering curative action or underwriting referral.',
    `county_name` STRING COMMENT 'Name of the county or recording jurisdiction where the instrument was recorded, complementing the FIPS code for human-readable identification of the recording authority.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this grantor-grantee index record was first created in the system of record, used for audit trail and data provenance tracking.',
    `effective_date` DATE COMMENT 'Date the instrument becomes legally effective, which may differ from execution or recording date. Distinct from execution_date, recording_date, submission_date, and acceptance_date per VREQ-008.',
    `estate_type` STRING COMMENT 'Type of estate or interest conveyed by the instrument (e.g., fee simple, life estate, leasehold, easement), used to classify the nature of the ownership interest transferred.. Valid values are `fee_simple|fee_tail|life_estate|leasehold|easement|other`',
    `execution_date` DATE COMMENT 'Date the instrument was signed/executed by the grantor. Distinct from recording date, effective date, and acceptance date per VREQ-008 date separation requirements.',
    `fips_code` STRING COMMENT 'Five-digit FIPS county code identifying the county where the instrument was recorded, used to route searches to the correct county recorder index and title plant.. Valid values are `^[0-9]{5}$`',
    `grantee_entity_type` STRING COMMENT 'Classification of the grantee as an individual person or legal entity type, used to assess vesting capacity and taking title. [ENUM-REF-CANDIDATE: individual|corporation|llc|trust|partnership|government|estate|other — promote to reference product]',
    `grantee_name_as_indexed` STRING COMMENT 'Full name of the grantee exactly as it appears in the county recorder or title plant grantor-grantee index, preserving original spelling for chain-of-title search accuracy.',
    `grantee_name_standardized` STRING COMMENT 'Normalized/standardized form of the grantee name used for fuzzy matching and chain-of-title continuity analysis across index entries with spelling variations.',
    `grantor_entity_type` STRING COMMENT 'Classification of the grantor as an individual person or legal entity type, used to assess vesting capacity and authority to convey. [ENUM-REF-CANDIDATE: individual|corporation|llc|trust|partnership|government|estate|other — promote to reference product]',
    `grantor_name_as_indexed` STRING COMMENT 'Full name of the grantor exactly as it appears in the county recorder or title plant grantor-grantee index, preserving original spelling for chain-of-title search accuracy.',
    `grantor_name_standardized` STRING COMMENT 'Normalized/standardized form of the grantor name used for fuzzy matching and chain-of-title continuity analysis across index entries with spelling variations.',
    `index_entry_date` DATE COMMENT 'Date this grantor-grantee index record was entered into the title plant or internal system, which may differ from the county recording date for plant-lag tracking.',
    `index_source` STRING COMMENT 'Source system or authority from which this grantor-grantee index entry was obtained (e.g., county recorder direct, DataTrace title plant, TitlePoint). Supports evidence provenance tracking.. Valid values are `county_recorder|title_plant|datatrace|titlepoint|manual_entry|other`',
    `index_status` STRING COMMENT 'Current lifecycle status of this grantor-grantee index record. Superseded indicates a corrected or amended instrument has replaced this entry in the chain of title.. Valid values are `active|superseded|voided|under_review`',
    `instrument_number` STRING COMMENT 'Official instrument number or document number assigned by the county recorder or register of deeds at the time of recording, used as the primary external reference for the recorded instrument.',
    `instrument_type` STRING COMMENT 'Type of recorded instrument captured by this index entry (e.g., Warranty Deed (WD), Quit Claim Deed (QCD), Deed of Trust (DOT), mortgage, release, lien). [ENUM-REF-CANDIDATE',
    `lien_position` BIGINT COMMENT 'Priority position of the lien or encumbrance created by the instrument (1 = first lien, 2 = second lien, etc.), determined by recording date and any subordination agreements.',
    `loan_amount` DECIMAL(18,2) COMMENT 'Original principal loan amount secured by the instrument (applicable to deeds of trust, mortgages, HELOCs). Used for lien priority analysis and Loan-to-Value (LTV) assessment.',
    `nominal_consideration_flag` BOOLEAN COMMENT 'Indicates whether the stated consideration is nominal (e.g., $1.00 or love and affection) rather than the actual market value, signaling a non-arms-length transfer for underwriting review.',
    `notary_commission_expiry_date` DATE COMMENT 'Expiration date of the notarys commission at the time of acknowledgment, used to verify the notary was duly commissioned when the instrument was executed.',
    `notary_name` STRING COMMENT 'Name of the notary public who acknowledged the grantors signature on the instrument, as recorded in the acknowledgment clause. Used to verify proper execution.',
    `page_number` STRING COMMENT 'Official page number within the deed book or volume where the instrument is recorded, completing the book-and-page citation used in chain-of-title references.',
    `recording_date` DATE COMMENT 'Date the instrument was officially recorded by the county recorder or register of deeds. Distinct from execution date and effective date; establishes priority in the chain of title.',
    `recording_timestamp` TIMESTAMP COMMENT 'Exact date and time the instrument was stamped as recorded by the county recorder, used for priority determination when multiple instruments are recorded on the same date.',
    `release_instrument_number` STRING COMMENT 'Instrument number of the recorded release, reconveyance, or satisfaction that discharged the lien or encumbrance created by this instrument, if applicable.',
    `release_recording_date` DATE COMMENT 'Date the release, reconveyance, or satisfaction of the instrument was recorded, confirming the lien or encumbrance has been discharged from the chain of title.',
    `source_reference_number` STRING COMMENT 'External reference number assigned by the source system (county recorder, title plant, or eRecording gateway) for this index entry, used for reconciliation and audit traceability.',
    `state_code` STRING COMMENT 'Two-letter USPS state abbreviation for the state where the instrument was recorded, used for jurisdiction routing and regulatory compliance.. Valid values are `^[A-Z]{2}$`',
    `transfer_tax_amount` DECIMAL(18,2) COMMENT 'Documentary transfer tax or deed stamp tax amount paid at recording, as noted on the instrument face. Used for consideration verification and tax compliance reporting.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this grantor-grantee index record was last modified in the system of record, supporting change tracking and lifecycle history preservation per VREQ-007.',
    `vesting_type` STRING COMMENT 'Form of title vesting by which the grantee takes ownership (e.g., joint tenancy, tenancy in common, community property), critical for ownership interest modeling and survivorship analysis.',
    `valid_from` TIMESTAMP COMMENT 'Start date when this record version became effective. Valid values are `yyyy-MM-dd`',
    `valid_to` TIMESTAMP COMMENT 'End date when this record version ceased to be effective (NULL if current). Valid values are `yyyy-MM-dd`',
    `change_date` TIMESTAMP COMMENT 'Date and time when this record was last modified. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    `changed_by` STRING COMMENT 'User or process that last modified this record',
    `created_by` STRING COMMENT 'User or process that created this record',
    `creation_date` TIMESTAMP COMMENT 'Date and time when this record was created. Valid values are `yyyy-MM-ddTHH:mm:ss.SSSXXX`',
    CONSTRAINT pk_grantor_grantee_index PRIMARY KEY(`grantor_grantee_index_id`)
) COMMENT 'Index record linking a grantor party and a grantee party to a recorded instrument affecting a parcel or property, supporting grantor/grantee name-index searches as performed against the title plant and county recorder indices.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ADD CONSTRAINT `fk_property_property_prior_property_id` FOREIGN KEY (`prior_property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ADD CONSTRAINT `fk_property_parcel_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ADD CONSTRAINT `fk_property_parcel_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ADD CONSTRAINT `fk_property_legal_description_prior_description_legal_description_id` FOREIGN KEY (`prior_description_legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ADD CONSTRAINT `fk_property_legal_description_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ADD CONSTRAINT `fk_property_ownership_interest_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ADD CONSTRAINT `fk_property_ownership_interest_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ADD CONSTRAINT `fk_property_ownership_interest_prior_interest_ownership_interest_id` FOREIGN KEY (`prior_interest_ownership_interest_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest`(`ownership_interest_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ADD CONSTRAINT `fk_property_ownership_interest_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ADD CONSTRAINT `fk_property_title_evidence_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ADD CONSTRAINT `fk_property_title_evidence_ownership_interest_id` FOREIGN KEY (`ownership_interest_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest`(`ownership_interest_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ADD CONSTRAINT `fk_property_title_evidence_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ADD CONSTRAINT `fk_property_title_evidence_superseded_by_evidence_id` FOREIGN KEY (`superseded_by_evidence_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`(`title_evidence_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ADD CONSTRAINT `fk_property_encumbrance_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ADD CONSTRAINT `fk_property_encumbrance_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ADD CONSTRAINT `fk_property_encumbrance_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ADD CONSTRAINT `fk_property_encumbrance_title_evidence_id` FOREIGN KEY (`title_evidence_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`(`title_evidence_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ADD CONSTRAINT `fk_property_easement_restriction_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ADD CONSTRAINT `fk_property_easement_restriction_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ADD CONSTRAINT `fk_property_easement_restriction_title_evidence_id` FOREIGN KEY (`title_evidence_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`(`title_evidence_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ADD CONSTRAINT `fk_property_tax_assessment_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ADD CONSTRAINT `fk_property_tax_assessment_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_easement_restriction_id` FOREIGN KEY (`easement_restriction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction`(`easement_restriction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_encumbrance_id` FOREIGN KEY (`encumbrance_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance`(`encumbrance_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_ownership_interest_id` FOREIGN KEY (`ownership_interest_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest`(`ownership_interest_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_tax_assessment_id` FOREIGN KEY (`tax_assessment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment`(`tax_assessment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_title_evidence_id` FOREIGN KEY (`title_evidence_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`(`title_evidence_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ADD CONSTRAINT `fk_property_grantor_grantee_index_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ADD CONSTRAINT `fk_property_grantor_grantee_index_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ADD CONSTRAINT `fk_property_grantor_grantee_index_prior_index_id` FOREIGN KEY (`prior_index_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index`(`grantor_grantee_index_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ADD CONSTRAINT `fk_property_grantor_grantee_index_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);

-- ========= TAGS =========
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_property` SET TAGS ('title_division' = 'operations');
ALTER SCHEMA `serverless_stable_dvmvgw_catalog`.`ti_property` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` SET TAGS ('title_subdomain' = 'asset_registry');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `prior_property_id` SET TAGS ('title_business_glossary_term' = 'Prior Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `annual_tax_amount` SET TAGS ('title_business_glossary_term' = 'Annual Property Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `assessed_value` SET TAGS ('title_business_glossary_term' = 'Assessed Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `assessed_value_year` SET TAGS ('title_business_glossary_term' = 'Assessed Value Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `building_sqft` SET TAGS ('title_business_glossary_term' = 'Building Square Footage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `ccr_flag` SET TAGS ('title_business_glossary_term' = 'Covenants, Conditions and Restrictions (CC&R) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `census_tract` SET TAGS ('title_business_glossary_term' = 'Census Tract Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `census_tract` SET TAGS ('title_value_regex' = '^[0-9]{4,6}(.[0-9]{2})?$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `chain_of_title_break_flag` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `city` SET TAGS ('title_business_glossary_term' = 'Property City');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `cloud_on_title_flag` SET TAGS ('title_business_glossary_term' = 'Cloud on Title Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `country_code` SET TAGS ('title_business_glossary_term' = 'Country Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `country_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `county_name` SET TAGS ('title_business_glossary_term' = 'Property County Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `easement_flag` SET TAGS ('title_business_glossary_term' = 'Easement Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `encroachment_flag` SET TAGS ('title_business_glossary_term' = 'Encroachment Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `flood_zone_code` SET TAGS ('title_business_glossary_term' = 'FEMA Flood Zone Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `flood_zone_determination_date` SET TAGS ('title_business_glossary_term' = 'Flood Zone Determination Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `hoa_annual_assessment` SET TAGS ('title_business_glossary_term' = 'HOA Annual Assessment Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `hoa_flag` SET TAGS ('title_business_glossary_term' = 'Homeowners Association (HOA) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `hoa_name` SET TAGS ('title_business_glossary_term' = 'Homeowners Association (HOA) Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `land_use_code` SET TAGS ('title_business_glossary_term' = 'Land Use Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `latitude` SET TAGS ('title_business_glossary_term' = 'Property Latitude');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `latitude` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `latitude` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `longitude` SET TAGS ('title_business_glossary_term' = 'Property Longitude');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `longitude` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `longitude` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `lot_size_sqft` SET TAGS ('title_business_glossary_term' = 'Lot Size (Square Feet)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `market_value` SET TAGS ('title_business_glossary_term' = 'Market Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `market_value_source` SET TAGS ('title_business_glossary_term' = 'Market Value Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `market_value_source` SET TAGS ('title_value_regex' = 'avm|appraisal|bpo|assessor|sale_price|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `marketable_title_flag` SET TAGS ('title_business_glossary_term' = 'Marketable Title Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `municipality_name` SET TAGS ('title_business_glossary_term' = 'Municipality Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `number_of_units` SET TAGS ('title_business_glossary_term' = 'Number of Units');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `plat_book` SET TAGS ('title_business_glossary_term' = 'Plat Book Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `plat_page` SET TAGS ('title_business_glossary_term' = 'Plat Page Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `property_status` SET TAGS ('title_business_glossary_term' = 'Property Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `property_status` SET TAGS ('title_value_regex' = 'active|inactive|merged|split|condemned|demolished');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `property_type` SET TAGS ('title_business_glossary_term' = 'Property Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `property_type` SET TAGS ('title_value_regex' = 'residential|commercial|condo|co_op|vacant_land|construction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `source_system_code` SET TAGS ('title_value_regex' = 'title_production|title_plant|county_data|crm|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `source_system_property_ref` SET TAGS ('title_business_glossary_term' = 'Source System Property Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'Property State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `street_address` SET TAGS ('title_business_glossary_term' = 'Property Street Address');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `street_address` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `street_address` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `subdivision_name` SET TAGS ('title_business_glossary_term' = 'Subdivision Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `tax_delinquency_flag` SET TAGS ('title_business_glossary_term' = 'Tax Delinquency Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `tax_year` SET TAGS ('title_business_glossary_term' = 'Tax Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `transaction_type` SET TAGS ('title_business_glossary_term' = 'Transaction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `transaction_type` SET TAGS ('title_value_regex' = 'purchase|refinance|home_equity|construction|commercial');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `year_built` SET TAGS ('title_business_glossary_term' = 'Year Built');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `zip_code` SET TAGS ('title_business_glossary_term' = 'Property ZIP Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `zip_code` SET TAGS ('title_value_regex' = '^[0-9]{5}(-[0-9]{4})?$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `zip_code` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `zip_code` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `zoning_code` SET TAGS ('title_business_glossary_term' = 'Zoning Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`property` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` SET TAGS ('title_subdomain' = 'asset_registry');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `acreage` SET TAGS ('title_business_glossary_term' = 'Parcel Acreage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `annual_tax_amount` SET TAGS ('title_business_glossary_term' = 'Annual Property Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `annual_tax_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `assessed_improvement_value` SET TAGS ('title_business_glossary_term' = 'Assessed Improvement Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `assessed_improvement_value` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `assessed_land_value` SET TAGS ('title_business_glossary_term' = 'Assessed Land Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `assessed_land_value` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `assessed_total_value` SET TAGS ('title_business_glossary_term' = 'Assessed Total Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `assessed_total_value` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `assessment_year` SET TAGS ('title_business_glossary_term' = 'Assessment Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `block_number` SET TAGS ('title_business_glossary_term' = 'Block Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `county_name` SET TAGS ('title_business_glossary_term' = 'County Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `data_effective_date` SET TAGS ('title_business_glossary_term' = 'Data Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `flood_map_panel_number` SET TAGS ('title_business_glossary_term' = 'FEMA Flood Map Panel Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `flood_zone_code` SET TAGS ('title_business_glossary_term' = 'FEMA Flood Zone Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `hoa_flag` SET TAGS ('title_business_glossary_term' = 'Homeowners Association (HOA) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `hoa_name` SET TAGS ('title_business_glossary_term' = 'Homeowners Association (HOA) Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `land_use_code` SET TAGS ('title_business_glossary_term' = 'Land Use Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `latitude` SET TAGS ('title_business_glossary_term' = 'Parcel Latitude');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `latitude` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `latitude` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `longitude` SET TAGS ('title_business_glossary_term' = 'Parcel Longitude');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `longitude` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `longitude` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `lot_area_sqft` SET TAGS ('title_business_glossary_term' = 'Lot Area (Square Feet)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `lot_depth_ft` SET TAGS ('title_business_glossary_term' = 'Lot Depth (Feet)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `lot_number` SET TAGS ('title_business_glossary_term' = 'Lot Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `lot_width_ft` SET TAGS ('title_business_glossary_term' = 'Lot Width (Feet)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `mers_min` SET TAGS ('title_business_glossary_term' = 'Mortgage Electronic Registration Systems (MERS) Mortgage Identification Number (MIN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `mers_min` SET TAGS ('title_value_regex' = '^[0-9]{18}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `parcel_status` SET TAGS ('title_business_glossary_term' = 'Parcel Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `parcel_status` SET TAGS ('title_value_regex' = 'active|inactive|merged|split|retired|pending');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `parcel_type` SET TAGS ('title_business_glossary_term' = 'Parcel Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `parcel_type` SET TAGS ('title_value_regex' = 'residential|commercial|industrial|agricultural|vacant|mixed_use');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `pin` SET TAGS ('title_business_glossary_term' = 'Parcel Identification Number (PIN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `plat_book` SET TAGS ('title_business_glossary_term' = 'Plat Book');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `plat_page` SET TAGS ('title_business_glossary_term' = 'Plat Page');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `range` SET TAGS ('title_business_glossary_term' = 'Public Land Survey System (PLSS) Range');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `record_created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `record_updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `section_number` SET TAGS ('title_business_glossary_term' = 'Public Land Survey System (PLSS) Section Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_address_line1` SET TAGS ('title_business_glossary_term' = 'Situs Address Line 1');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_address_line1` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_address_line1` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_address_line2` SET TAGS ('title_business_glossary_term' = 'Situs Address Line 2');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_address_line2` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_address_line2` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_city` SET TAGS ('title_business_glossary_term' = 'Situs City');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_zip_code` SET TAGS ('title_business_glossary_term' = 'Situs ZIP Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_zip_code` SET TAGS ('title_value_regex' = '^[0-9]{5}(-[0-9]{4})?$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_zip_code` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `situs_zip_code` SET TAGS ('title_pii_address' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `source_system_parcel_key` SET TAGS ('title_business_glossary_term' = 'Source System Parcel Key');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `subdivision_name` SET TAGS ('title_business_glossary_term' = 'Subdivision Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `tax_account_number` SET TAGS ('title_business_glossary_term' = 'Tax Account Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `tax_account_number` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `tax_account_number` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `tax_delinquent_amount` SET TAGS ('title_business_glossary_term' = 'Tax Delinquent Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `tax_delinquent_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `tax_delinquent_flag` SET TAGS ('title_business_glossary_term' = 'Tax Delinquent Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `tax_exemption_type` SET TAGS ('title_business_glossary_term' = 'Tax Exemption Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `tax_exemption_type` SET TAGS ('title_value_regex' = 'homestead|senior|veteran|disability|agricultural|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `township` SET TAGS ('title_business_glossary_term' = 'Public Land Survey System (PLSS) Township');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `zoning_code` SET TAGS ('title_business_glossary_term' = 'Zoning Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` SET TAGS ('title_subdomain' = 'asset_registry');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `prior_description_legal_description_id` SET TAGS ('title_business_glossary_term' = 'Prior Legal Description ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `area_acres` SET TAGS ('title_business_glossary_term' = 'Area in Acres');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `area_sq_ft` SET TAGS ('title_business_glossary_term' = 'Area in Square Feet');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `block_number` SET TAGS ('title_business_glossary_term' = 'Block Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `building_number` SET TAGS ('title_business_glossary_term' = 'Building Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `county_name` SET TAGS ('title_business_glossary_term' = 'County Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `description_source` SET TAGS ('title_business_glossary_term' = 'Legal Description Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `description_status` SET TAGS ('title_business_glossary_term' = 'Legal Description Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `description_status` SET TAGS ('title_value_regex' = 'active|superseded|draft|under_review|rejected');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `description_type` SET TAGS ('title_business_glossary_term' = 'Legal Description Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `description_type` SET TAGS ('title_value_regex' = 'metes_and_bounds|plss|plat_subdivision|lot_block|condo_unit|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `description_variance_notes` SET TAGS ('title_business_glossary_term' = 'Legal Description Variance Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `fips_county_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `fips_county_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `full_text` SET TAGS ('title_business_glossary_term' = 'Legal Description Full Text');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `gap_notes` SET TAGS ('title_business_glossary_term' = 'Gap Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `has_gap_risk` SET TAGS ('title_business_glossary_term' = 'Gap Risk Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `is_current` SET TAGS ('title_business_glossary_term' = 'Is Current Legal Description Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `is_schedule_a_approved` SET TAGS ('title_business_glossary_term' = 'Schedule A Approved Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `lot_number` SET TAGS ('title_business_glossary_term' = 'Lot Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `metes_bounds_point_of_beginning` SET TAGS ('title_business_glossary_term' = 'Metes and Bounds Point of Beginning');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `plat_book` SET TAGS ('title_business_glossary_term' = 'Plat Book');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `plat_page` SET TAGS ('title_business_glossary_term' = 'Plat Page');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `plss_aliquot_parts` SET TAGS ('title_business_glossary_term' = 'Public Land Survey System (PLSS) Aliquot Parts');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `plss_principal_meridian` SET TAGS ('title_business_glossary_term' = 'Public Land Survey System (PLSS) Principal Meridian');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `plss_range` SET TAGS ('title_business_glossary_term' = 'Public Land Survey System (PLSS) Range');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `plss_section` SET TAGS ('title_business_glossary_term' = 'Public Land Survey System (PLSS) Section');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `plss_state` SET TAGS ('title_business_glossary_term' = 'Public Land Survey System (PLSS) State');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `plss_state` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `plss_township` SET TAGS ('title_business_glossary_term' = 'Public Land Survey System (PLSS) Township');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `recording_reference` SET TAGS ('title_business_glossary_term' = 'Recording Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `schedule_a_text` SET TAGS ('title_business_glossary_term' = 'Schedule A Legal Description Text');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `source_instrument_id` SET TAGS ('title_business_glossary_term' = 'Source Instrument ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `standardized_text` SET TAGS ('title_business_glossary_term' = 'Standardized Legal Description Text');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `subdivision_name` SET TAGS ('title_business_glossary_term' = 'Subdivision Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `superseded_date` SET TAGS ('title_business_glossary_term' = 'Superseded Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `survey_date` SET TAGS ('title_business_glossary_term' = 'Survey Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `surveyor_license_number` SET TAGS ('title_business_glossary_term' = 'Surveyor License Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `surveyor_name` SET TAGS ('title_business_glossary_term' = 'Surveyor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `title_plant_index_key` SET TAGS ('title_business_glossary_term' = 'Title Plant Index Key');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `unit_number` SET TAGS ('title_business_glossary_term' = 'Condominium Unit Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `version_number` SET TAGS ('title_business_glossary_term' = 'Legal Description Version Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` SET TAGS ('title_subdomain' = 'ownership_evidence');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `ownership_interest_id` SET TAGS ('title_business_glossary_term' = 'Ownership Interest ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `party_id` SET TAGS ('title_business_glossary_term' = 'Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `prior_interest_ownership_interest_id` SET TAGS ('title_business_glossary_term' = 'Prior Ownership Interest ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `acquisition_type` SET TAGS ('title_business_glossary_term' = 'Acquisition Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `chain_of_title_sequence` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Sequence');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `cloud_on_title_flag` SET TAGS ('title_business_glossary_term' = 'Cloud on Title Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `consideration_amount` SET TAGS ('title_business_glossary_term' = 'Consideration Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `consideration_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `consideration_currency` SET TAGS ('title_business_glossary_term' = 'Consideration Currency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `consideration_currency` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `cot_break_description` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `cot_break_flag` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `entity_type` SET TAGS ('title_business_glossary_term' = 'Entity Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `evidence_document_id` SET TAGS ('title_business_glossary_term' = 'Evidence Document ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `examiner_notes` SET TAGS ('title_business_glossary_term' = 'Examiner Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `gap_period_flag` SET TAGS ('title_business_glossary_term' = 'Gap Period Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `grantee_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `grantee_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `grantor_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `grantor_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `instrument_type` SET TAGS ('title_business_glossary_term' = 'Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `instrument_type` SET TAGS ('title_value_regex' = 'warranty_deed|quit_claim_deed|special_warranty_deed|grant_deed|trustee_deed|sheriff_deed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `insurable_title_flag` SET TAGS ('title_business_glossary_term' = 'Insurable Title Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `interest_status` SET TAGS ('title_business_glossary_term' = 'Ownership Interest Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `interest_status` SET TAGS ('title_value_regex' = 'active|superseded|released|terminated|pending');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `interest_type` SET TAGS ('title_business_glossary_term' = 'Ownership Interest Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `interest_type` SET TAGS ('title_value_regex' = 'fee_simple|life_estate|leasehold|easement|remainder|reversion');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `marketable_title_flag` SET TAGS ('title_business_glossary_term' = 'Marketable Title Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `mers_flag` SET TAGS ('title_business_glossary_term' = 'Mortgage Electronic Registration Systems (MERS) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `ownership_percentage` SET TAGS ('title_business_glossary_term' = 'Ownership Percentage');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `prior_classification` SET TAGS ('title_business_glossary_term' = 'Prior Classification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `reclassification_reason` SET TAGS ('title_business_glossary_term' = 'Reclassification Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `source_reference_number` SET TAGS ('title_business_glossary_term' = 'Source Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `source_system_code` SET TAGS ('title_business_glossary_term' = 'Source System Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `source_system_code` SET TAGS ('title_value_regex' = 'title_plant|county_recorder|title_production|property_info');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `state_of_formation` SET TAGS ('title_business_glossary_term' = 'State of Formation');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `state_of_formation` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `trust_name` SET TAGS ('title_business_glossary_term' = 'Trust Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `trust_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `trustee_name` SET TAGS ('title_business_glossary_term' = 'Trustee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `trustee_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `trustee_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `vesting_name` SET TAGS ('title_business_glossary_term' = 'Vesting Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `vesting_name` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `vesting_name` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `vesting_type` SET TAGS ('title_business_glossary_term' = 'Vesting Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `vesting_type` SET TAGS ('title_value_regex' = 'sole_ownership|joint_tenancy|tenancy_in_common|community_property|tenancy_by_entirety|trust');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` SET TAGS ('title_subdomain' = 'ownership_evidence');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `title_evidence_id` SET TAGS ('title_business_glossary_term' = 'Title Evidence ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `ownership_interest_id` SET TAGS ('title_business_glossary_term' = 'Ownership Interest ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `superseded_by_evidence_id` SET TAGS ('title_business_glossary_term' = 'Superseded By Evidence ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `chain_of_title_sequence` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Sequence Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `consideration_amount` SET TAGS ('title_business_glossary_term' = 'Consideration Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `consideration_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `consideration_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `curative_status` SET TAGS ('title_business_glossary_term' = 'Curative Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `curative_status` SET TAGS ('title_value_regex' = 'not_required|pending|in_progress|cleared|waived|exception_taken');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `currency_code` SET TAGS ('title_business_glossary_term' = 'Currency Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `currency_code` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `defect_description` SET TAGS ('title_business_glossary_term' = 'Defect Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `defect_indicator_flag` SET TAGS ('title_business_glossary_term' = 'Defect Indicator Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `document_image_url` SET TAGS ('title_business_glossary_term' = 'Document Image URL');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `encumbrance_type` SET TAGS ('title_business_glossary_term' = 'Encumbrance Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `erecording_flag` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `evidence_number` SET TAGS ('title_business_glossary_term' = 'Evidence Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `evidence_number` SET TAGS ('title_value_regex' = '^EVD-[0-9]{8,12}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `evidence_status` SET TAGS ('title_business_glossary_term' = 'Evidence Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `evidence_status` SET TAGS ('title_value_regex' = 'pending|active|superseded|voided|archived');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `evidence_subtype` SET TAGS ('title_business_glossary_term' = 'Evidence Subtype');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `evidence_type` SET TAGS ('title_business_glossary_term' = 'Evidence Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `examiner_notes` SET TAGS ('title_business_glossary_term' = 'Examiner Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `gap_period_flag` SET TAGS ('title_business_glossary_term' = 'Gap Period Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `image_available_flag` SET TAGS ('title_business_glossary_term' = 'Image Available Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `jurisdiction_name` SET TAGS ('title_business_glossary_term' = 'Recording Jurisdiction Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `lien_amount` SET TAGS ('title_business_glossary_term' = 'Lien Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `lien_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `lien_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `notarized_flag` SET TAGS ('title_business_glossary_term' = 'Notarized Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `notary_state` SET TAGS ('title_business_glossary_term' = 'Notary State');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `notary_state` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `prior_classification` SET TAGS ('title_business_glossary_term' = 'Prior Classification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `prior_instrument_number` SET TAGS ('title_business_glossary_term' = 'Prior Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `release_satisfaction_flag` SET TAGS ('title_business_glossary_term' = 'Release or Satisfaction Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `retrieved_timestamp` SET TAGS ('title_business_glossary_term' = 'Evidence Retrieved Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `ron_flag` SET TAGS ('title_business_glossary_term' = 'Remote Online Notarization (RON) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `source_reference_code` SET TAGS ('title_business_glossary_term' = 'Source System Reference ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `vesting_type` SET TAGS ('title_business_glossary_term' = 'Vesting Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `vesting_type` SET TAGS ('title_value_regex' = 'sole_ownership|joint_tenancy|tenancy_in_common|community_property|trust|entity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` SET TAGS ('title_subdomain' = 'title_encumbrances');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `encumbrance_id` SET TAGS ('title_business_glossary_term' = 'Encumbrance ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `recorded_instrument_id` SET TAGS ('title_business_glossary_term' = 'Recorded Instrument Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `title_evidence_id` SET TAGS ('title_business_glossary_term' = 'Title Evidence Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `balance_as_of_date` SET TAGS ('title_business_glossary_term' = 'Balance As-Of Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `case_number` SET TAGS ('title_business_glossary_term' = 'Case Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `classification_changed_date` SET TAGS ('title_business_glossary_term' = 'Classification Changed Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `court_name` SET TAGS ('title_business_glossary_term' = 'Court Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `curative_action_type` SET TAGS ('title_business_glossary_term' = 'Curative Action Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `curative_completed_date` SET TAGS ('title_business_glossary_term' = 'Curative Completed Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `curative_status` SET TAGS ('title_business_glossary_term' = 'Curative Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `curative_status` SET TAGS ('title_value_regex' = 'not_required|pending|in_progress|completed|waived|escalated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `current_balance_amount` SET TAGS ('title_business_glossary_term' = 'Current Balance Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `current_balance_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `discovered_date` SET TAGS ('title_business_glossary_term' = 'Discovered Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `easement_purpose` SET TAGS ('title_business_glossary_term' = 'Easement Purpose');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `easement_type` SET TAGS ('title_business_glossary_term' = 'Easement Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `easement_type` SET TAGS ('title_value_regex' = 'appurtenant|in_gross|prescriptive|implied|express|not_applicable');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `encumbrance_status` SET TAGS ('title_business_glossary_term' = 'Encumbrance Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `encumbrance_type` SET TAGS ('title_business_glossary_term' = 'Encumbrance Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `fips_county_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `fips_county_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `grantee_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `grantor_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `hoa_name` SET TAGS ('title_business_glossary_term' = 'Homeowners Association (HOA) Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `interest_rate` SET TAGS ('title_business_glossary_term' = 'Interest Rate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `is_curative_required` SET TAGS ('title_business_glossary_term' = 'Is Curative Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `is_insured_exception` SET TAGS ('title_business_glossary_term' = 'Is Insured Exception Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `lien_position_number` SET TAGS ('title_business_glossary_term' = 'Lien Position Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `lien_priority` SET TAGS ('title_business_glossary_term' = 'Lien Priority');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `lien_priority` SET TAGS ('title_value_regex' = 'first|second|third|junior|senior|subordinate');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `loan_number` SET TAGS ('title_business_glossary_term' = 'Loan Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `loan_number` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `maturity_date` SET TAGS ('title_business_glossary_term' = 'Maturity Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `mers_min` SET TAGS ('title_business_glossary_term' = 'Mortgage Electronic Registration Systems (MERS) Mortgage Identification Number (MIN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `mers_min` SET TAGS ('title_value_regex' = '^[0-9]{18}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Encumbrance Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `number` SET TAGS ('title_business_glossary_term' = 'Encumbrance Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `original_principal_amount` SET TAGS ('title_business_glossary_term' = 'Original Principal Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `original_principal_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `payoff_demand_amount` SET TAGS ('title_business_glossary_term' = 'Payoff Demand Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `payoff_demand_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `payoff_good_through_date` SET TAGS ('title_business_glossary_term' = 'Payoff Good-Through Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `per_diem_interest_amount` SET TAGS ('title_business_glossary_term' = 'Per Diem Interest Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `per_diem_interest_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `prior_classification` SET TAGS ('title_business_glossary_term' = 'Prior Classification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `release_date` SET TAGS ('title_business_glossary_term' = 'Release Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `release_instrument_number` SET TAGS ('title_business_glossary_term' = 'Release Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `source_system_reference` SET TAGS ('title_business_glossary_term' = 'Source System Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `subtype` SET TAGS ('title_business_glossary_term' = 'Encumbrance Subtype');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `tax_lien_serial_number` SET TAGS ('title_business_glossary_term' = 'Tax Lien Serial Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `tax_year` SET TAGS ('title_business_glossary_term' = 'Tax Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `tax_year` SET TAGS ('title_value_regex' = '^[0-9]{4}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `ucc_filing_number` SET TAGS ('title_business_glossary_term' = 'Uniform Commercial Code (UCC) Filing Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` SET TAGS ('title_subdomain' = 'title_encumbrances');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `easement_restriction_id` SET TAGS ('title_business_glossary_term' = 'Easement and Restriction ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `recorded_instrument_id` SET TAGS ('title_business_glossary_term' = 'Recorded Instrument ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `title_evidence_id` SET TAGS ('title_business_glossary_term' = 'Title Evidence Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `appurtenant_flag` SET TAGS ('title_business_glossary_term' = 'Appurtenant Easement Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `area_sq_ft` SET TAGS ('title_business_glossary_term' = 'Easement Area (Square Feet)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `benefiting_utility` SET TAGS ('title_business_glossary_term' = 'Benefiting Utility or Entity');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `blanket_flag` SET TAGS ('title_business_glossary_term' = 'Blanket Easement Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Deed Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `cc_r_document_name` SET TAGS ('title_business_glossary_term' = 'Covenants Conditions and Restrictions (CC&R) Document Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `classification_change_date` SET TAGS ('title_business_glossary_term' = 'Classification Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `curative_action_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `curative_notes` SET TAGS ('title_business_glossary_term' = 'Curative Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `dominant_estate_description` SET TAGS ('title_business_glossary_term' = 'Dominant Estate Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `easement_subtype` SET TAGS ('title_business_glossary_term' = 'Easement Subtype');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `encroachment_description` SET TAGS ('title_business_glossary_term' = 'Encroachment Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `exception_language` SET TAGS ('title_business_glossary_term' = 'Schedule B-II Exception Language');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `exclusive_flag` SET TAGS ('title_business_glossary_term' = 'Exclusive Easement Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `expiration_date` SET TAGS ('title_business_glossary_term' = 'Expiration Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `hoa_name` SET TAGS ('title_business_glossary_term' = 'Homeowners Association (HOA) Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `location_description` SET TAGS ('title_business_glossary_term' = 'Easement Location Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `notes` SET TAGS ('title_business_glossary_term' = 'Examiner Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Deed Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `permitted_use` SET TAGS ('title_business_glossary_term' = 'Permitted Use Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `prior_classification` SET TAGS ('title_business_glossary_term' = 'Prior Classification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `prohibited_use` SET TAGS ('title_business_glossary_term' = 'Prohibited Use Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `reference_number` SET TAGS ('title_business_glossary_term' = 'Easement Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `release_date` SET TAGS ('title_business_glossary_term' = 'Release or Vacation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `release_instrument_number` SET TAGS ('title_business_glossary_term' = 'Release Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `restriction_status` SET TAGS ('title_business_glossary_term' = 'Restriction Lifecycle Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `restriction_status` SET TAGS ('title_value_regex' = 'active|released|expired|disputed|under_review|vacated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `restriction_text` SET TAGS ('title_business_glossary_term' = 'Restriction Text');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `restriction_type` SET TAGS ('title_business_glossary_term' = 'Easement and Restriction Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `restriction_type` SET TAGS ('title_value_regex' = 'easement|right_of_way|covenant|encroachment|cc_and_r|restriction');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `schedule_b2_exception_flag` SET TAGS ('title_business_glossary_term' = 'Schedule B-II Exception Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `servient_estate_description` SET TAGS ('title_business_glossary_term' = 'Servient Estate Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `survey_reference` SET TAGS ('title_business_glossary_term' = 'Survey Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `underwriting_impact` SET TAGS ('title_business_glossary_term' = 'Underwriting Impact Classification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `underwriting_impact` SET TAGS ('title_value_regex' = 'insurable|non_insurable|exception_required|referral_required|curative_required|informational');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `width_ft` SET TAGS ('title_business_glossary_term' = 'Easement Width (Feet)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` SET TAGS ('title_subdomain' = 'asset_registry');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `tax_assessment_id` SET TAGS ('title_business_glossary_term' = 'Tax Assessment ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `annual_tax_amount` SET TAGS ('title_business_glossary_term' = 'Annual Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `annual_tax_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `appeal_adjusted_value` SET TAGS ('title_business_glossary_term' = 'Appeal Adjusted Assessed Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `appeal_adjusted_value` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `appeal_filed_date` SET TAGS ('title_business_glossary_term' = 'Assessment Appeal Filed Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `appeal_flag` SET TAGS ('title_business_glossary_term' = 'Assessment Appeal Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `appeal_resolution_date` SET TAGS ('title_business_glossary_term' = 'Assessment Appeal Resolution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `assessment_date` SET TAGS ('title_business_glossary_term' = 'Assessment Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `assessment_status` SET TAGS ('title_business_glossary_term' = 'Tax Assessment Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `assessment_status` SET TAGS ('title_value_regex' = 'preliminary|certified|appealed|adjusted|final');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `assessment_type` SET TAGS ('title_business_glossary_term' = 'Tax Assessment Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `assessment_type` SET TAGS ('title_value_regex' = 'annual|supplemental|corrected|escaped|special_district');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `certified_date` SET TAGS ('title_business_glossary_term' = 'Assessment Certified Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `data_as_of_date` SET TAGS ('title_business_glossary_term' = 'Data As-Of Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `delinquent_amount` SET TAGS ('title_business_glossary_term' = 'Delinquent Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `delinquent_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Assessment Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `exemption_amount` SET TAGS ('title_business_glossary_term' = 'Tax Exemption Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `exemption_type` SET TAGS ('title_business_glossary_term' = 'Tax Exemption Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `exemption_type` SET TAGS ('title_value_regex' = 'homestead|veteran|senior|nonprofit|agricultural|none');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `first_installment_amount` SET TAGS ('title_business_glossary_term' = 'First Installment Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `first_installment_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `first_installment_due_date` SET TAGS ('title_business_glossary_term' = 'First Installment Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `improvement_assessed_value` SET TAGS ('title_business_glossary_term' = 'Improvement Assessed Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `improvement_assessed_value` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `interest_amount` SET TAGS ('title_business_glossary_term' = 'Tax Interest Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `interest_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `land_assessed_value` SET TAGS ('title_business_glossary_term' = 'Land Assessed Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `land_assessed_value` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `lien_date` SET TAGS ('title_business_glossary_term' = 'Tax Lien Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `net_taxable_value` SET TAGS ('title_business_glossary_term' = 'Net Taxable Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `net_taxable_value` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `paid_amount` SET TAGS ('title_business_glossary_term' = 'Tax Paid Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `paid_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `paid_date` SET TAGS ('title_business_glossary_term' = 'Tax Paid Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `payment_status` SET TAGS ('title_business_glossary_term' = 'Tax Payment Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `payment_status` SET TAGS ('title_value_regex' = 'paid|unpaid|partial|delinquent|in_redemption');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `penalty_amount` SET TAGS ('title_business_glossary_term' = 'Tax Penalty Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `penalty_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `prior_year_assessed_value` SET TAGS ('title_business_glossary_term' = 'Prior Year Assessed Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `prior_year_assessed_value` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `record_created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `record_updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `redemption_expiry_date` SET TAGS ('title_business_glossary_term' = 'Tax Sale Redemption Expiry Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `second_installment_amount` SET TAGS ('title_business_glossary_term' = 'Second Installment Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `second_installment_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `second_installment_due_date` SET TAGS ('title_business_glossary_term' = 'Second Installment Due Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `source_system_ref` SET TAGS ('title_business_glossary_term' = 'Source System Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `special_assessment_amount` SET TAGS ('title_business_glossary_term' = 'Special Assessment Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `special_assessment_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `special_assessment_flag` SET TAGS ('title_business_glossary_term' = 'Special Assessment Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `tax_bill_number` SET TAGS ('title_business_glossary_term' = 'Tax Bill Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `tax_district_code` SET TAGS ('title_business_glossary_term' = 'Tax District Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `tax_rate` SET TAGS ('title_business_glossary_term' = 'Tax Rate (Mill Rate)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `tax_sale_date` SET TAGS ('title_business_glossary_term' = 'Tax Sale Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `tax_sale_flag` SET TAGS ('title_business_glossary_term' = 'Tax Sale Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `tax_year` SET TAGS ('title_business_glossary_term' = 'Tax Assessment Year');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `taxing_authority_name` SET TAGS ('title_business_glossary_term' = 'Taxing Authority Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `total_assessed_value` SET TAGS ('title_business_glossary_term' = 'Total Assessed Value');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `total_assessed_value` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`tax_assessment` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` SET TAGS ('title_data_type' = 'transactional_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` SET TAGS ('title_subdomain' = 'asset_registry');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `lifecycle_event_id` SET TAGS ('title_business_glossary_term' = 'Lifecycle Event ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `easement_restriction_id` SET TAGS ('title_business_glossary_term' = 'Easement Restriction Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `encumbrance_id` SET TAGS ('title_business_glossary_term' = 'Encumbrance Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `ownership_interest_id` SET TAGS ('title_business_glossary_term' = 'Ownership Interest ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `recording_submission_id` SET TAGS ('title_business_glossary_term' = 'Recording Submission Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `superseded_event_id` SET TAGS ('title_business_glossary_term' = 'Superseded Lifecycle Event ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `tax_assessment_id` SET TAGS ('title_business_glossary_term' = 'Tax Assessment Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `title_evidence_id` SET TAGS ('title_business_glossary_term' = 'Title Evidence Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `title_order_id` SET TAGS ('title_business_glossary_term' = 'Title Order ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `acceptance_date` SET TAGS ('title_business_glossary_term' = 'Acceptance Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `chain_of_title_break` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Indicator');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `consideration_amount` SET TAGS ('title_business_glossary_term' = 'Consideration Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `consideration_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `consideration_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `curative_required` SET TAGS ('title_business_glossary_term' = 'Curative Action Required Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `curative_status` SET TAGS ('title_business_glossary_term' = 'Curative Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `curative_status` SET TAGS ('title_value_regex' = 'not_required|pending|in_progress|cleared|waived|escalated');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `encumbrance_type` SET TAGS ('title_business_glossary_term' = 'Encumbrance Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `erecording_flag` SET TAGS ('title_business_glossary_term' = 'Electronic Recording (eRecording) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `event_notes` SET TAGS ('title_business_glossary_term' = 'Lifecycle Event Notes');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `event_number` SET TAGS ('title_business_glossary_term' = 'Lifecycle Event Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `event_status` SET TAGS ('title_business_glossary_term' = 'Lifecycle Event Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `event_status` SET TAGS ('title_value_regex' = 'pending|active|superseded|voided|under_review');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `event_subtype` SET TAGS ('title_business_glossary_term' = 'Lifecycle Event Subtype');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `event_timestamp` SET TAGS ('title_business_glossary_term' = 'Lifecycle Event Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `event_type` SET TAGS ('title_business_glossary_term' = 'Lifecycle Event Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `evidence_document_ref` SET TAGS ('title_business_glossary_term' = 'Evidence Document Reference');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `gap_period_flag` SET TAGS ('title_business_glossary_term' = 'Gap Period (GAP) Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `grantee_name` SET TAGS ('title_business_glossary_term' = 'Grantee Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `grantee_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `grantor_name` SET TAGS ('title_business_glossary_term' = 'Grantor Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `grantor_name` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `instrument_type` SET TAGS ('title_business_glossary_term' = 'Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `lien_amount` SET TAGS ('title_business_glossary_term' = 'Lien Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `lien_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `lien_amount` SET TAGS ('title_pii_financial' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `new_classification` SET TAGS ('title_business_glossary_term' = 'New Classification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `new_vesting` SET TAGS ('title_business_glossary_term' = 'New Vesting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `notarization_type` SET TAGS ('title_business_glossary_term' = 'Notarization Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `notarization_type` SET TAGS ('title_value_regex' = 'in_person|ron|ipen|traditional');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `notary_name` SET TAGS ('title_business_glossary_term' = 'Notary Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `prior_apn` SET TAGS ('title_business_glossary_term' = 'Prior Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `prior_classification` SET TAGS ('title_business_glossary_term' = 'Prior Classification');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `prior_vesting` SET TAGS ('title_business_glossary_term' = 'Prior Vesting');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `recorded_by_party` SET TAGS ('title_business_glossary_term' = 'Recorded By Party');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `revision_number` SET TAGS ('title_business_glossary_term' = 'Revision Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `revision_reason` SET TAGS ('title_business_glossary_term' = 'Revision Reason');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `source_system_event_code` SET TAGS ('title_business_glossary_term' = 'Source System Event ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `submission_date` SET TAGS ('title_business_glossary_term' = 'Submission Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` SET TAGS ('title_data_type' = 'master_data');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` SET TAGS ('title_domain' = 'property');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` SET TAGS ('title_division' = 'operations');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` SET TAGS ('title_subdomain' = 'ownership_evidence');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantor_grantee_index_id` SET TAGS ('title_business_glossary_term' = 'Grantor Grantee Index ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantor_grantee_party_id` SET TAGS ('title_business_glossary_term' = 'Grantee Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `legal_description_id` SET TAGS ('title_business_glossary_term' = 'Legal Description Id (Foreign Key)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `parcel_id` SET TAGS ('title_business_glossary_term' = 'Parcel ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `primary_grantor_party_id` SET TAGS ('title_business_glossary_term' = 'Grantor Party ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `prior_index_id` SET TAGS ('title_business_glossary_term' = 'Prior Index ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `property_id` SET TAGS ('title_business_glossary_term' = 'Property ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `recorded_instrument_id` SET TAGS ('title_business_glossary_term' = 'Recorded Instrument ID');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `apn` SET TAGS ('title_business_glossary_term' = 'Assessors Parcel Number (APN)');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `book_number` SET TAGS ('title_business_glossary_term' = 'Book Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `chain_of_title_sequence` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Sequence');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `consideration_amount` SET TAGS ('title_business_glossary_term' = 'Consideration Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `consideration_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `consideration_currency` SET TAGS ('title_business_glossary_term' = 'Consideration Currency');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `consideration_currency` SET TAGS ('title_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `cot_break_description` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Description');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `cot_break_flag` SET TAGS ('title_business_glossary_term' = 'Chain of Title (COT) Break Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `county_name` SET TAGS ('title_business_glossary_term' = 'County Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `created_timestamp` SET TAGS ('title_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `effective_date` SET TAGS ('title_business_glossary_term' = 'Effective Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `estate_type` SET TAGS ('title_business_glossary_term' = 'Estate Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `estate_type` SET TAGS ('title_value_regex' = 'fee_simple|fee_tail|life_estate|leasehold|easement|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `execution_date` SET TAGS ('title_business_glossary_term' = 'Execution Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `fips_code` SET TAGS ('title_business_glossary_term' = 'Federal Information Processing Standards (FIPS) County Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `fips_code` SET TAGS ('title_value_regex' = '^[0-9]{5}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantee_entity_type` SET TAGS ('title_business_glossary_term' = 'Grantee Entity Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantee_name_as_indexed` SET TAGS ('title_business_glossary_term' = 'Grantee Name As Indexed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantee_name_as_indexed` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantee_name_as_indexed` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantee_name_standardized` SET TAGS ('title_business_glossary_term' = 'Grantee Name Standardized');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantee_name_standardized` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantee_name_standardized` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantor_entity_type` SET TAGS ('title_business_glossary_term' = 'Grantor Entity Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantor_name_as_indexed` SET TAGS ('title_business_glossary_term' = 'Grantor Name As Indexed');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantor_name_as_indexed` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantor_name_as_indexed` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantor_name_standardized` SET TAGS ('title_business_glossary_term' = 'Grantor Name Standardized');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantor_name_standardized` SET TAGS ('title_restricted' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `grantor_name_standardized` SET TAGS ('title_pii_name' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `index_entry_date` SET TAGS ('title_business_glossary_term' = 'Index Entry Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `index_source` SET TAGS ('title_business_glossary_term' = 'Index Source');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `index_source` SET TAGS ('title_value_regex' = 'county_recorder|title_plant|datatrace|titlepoint|manual_entry|other');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `index_status` SET TAGS ('title_business_glossary_term' = 'Index Status');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `index_status` SET TAGS ('title_value_regex' = 'active|superseded|voided|under_review');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `instrument_number` SET TAGS ('title_business_glossary_term' = 'Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `instrument_type` SET TAGS ('title_business_glossary_term' = 'Instrument Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `lien_position` SET TAGS ('title_business_glossary_term' = 'Lien Position');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `loan_amount` SET TAGS ('title_business_glossary_term' = 'Loan Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `loan_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `nominal_consideration_flag` SET TAGS ('title_business_glossary_term' = 'Nominal Consideration Flag');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `notary_commission_expiry_date` SET TAGS ('title_business_glossary_term' = 'Notary Commission Expiry Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `notary_name` SET TAGS ('title_business_glossary_term' = 'Notary Name');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `page_number` SET TAGS ('title_business_glossary_term' = 'Page Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `recording_date` SET TAGS ('title_business_glossary_term' = 'Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `recording_timestamp` SET TAGS ('title_business_glossary_term' = 'Recording Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `release_instrument_number` SET TAGS ('title_business_glossary_term' = 'Release Instrument Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `release_recording_date` SET TAGS ('title_business_glossary_term' = 'Release Recording Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `source_reference_number` SET TAGS ('title_business_glossary_term' = 'Source Reference Number');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `state_code` SET TAGS ('title_business_glossary_term' = 'State Code');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `state_code` SET TAGS ('title_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_business_glossary_term' = 'Transfer Tax Amount');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `transfer_tax_amount` SET TAGS ('title_confidential' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `updated_timestamp` SET TAGS ('title_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `vesting_type` SET TAGS ('title_business_glossary_term' = 'Vesting Type');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `valid_from` SET TAGS ('title_business_glossary_term' = 'Valid From Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `valid_from` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `valid_from` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `valid_to` SET TAGS ('title_business_glossary_term' = 'Valid To Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `valid_to` SET TAGS ('title_value_regex' = 'yyyy-MM-dd');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `valid_to` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `change_date` SET TAGS ('title_business_glossary_term' = 'Change Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `change_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `change_date` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `changed_by` SET TAGS ('title_business_glossary_term' = 'Changed By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `changed_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `created_by` SET TAGS ('title_business_glossary_term' = 'Created By');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `created_by` SET TAGS ('title_internal' = 'true');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `creation_date` SET TAGS ('title_business_glossary_term' = 'Creation Date');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `creation_date` SET TAGS ('title_value_regex' = 'yyyy-MM-ddTHH:mm:ss.SSSXXX');
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ALTER COLUMN `creation_date` SET TAGS ('title_internal' = 'true');
