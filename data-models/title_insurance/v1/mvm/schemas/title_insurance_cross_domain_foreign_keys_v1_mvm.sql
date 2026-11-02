-- Cross-Domain Foreign Keys for Business: Title_Insurance | Version: v1_mvm
-- Generated on: 2026-10-31 06:39:31
-- Total cross-domain FK constraints: 225
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: agency, claim, operations, property, recording, settlement, underwriting

-- ========= agency --> operations (7 constraint(s)) =========
-- Requires: agency schema, operations schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement` ADD CONSTRAINT `fk_agency_agreement_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule` ADD CONSTRAINT `fk_agency_premium_split_schedule_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ADD CONSTRAINT `fk_agency_cpl_issuance_cpl_insured_lender_party_id` FOREIGN KEY (`cpl_insured_lender_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ADD CONSTRAINT `fk_agency_cpl_issuance_cpl_party_id` FOREIGN KEY (`cpl_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ADD CONSTRAINT `fk_agency_cpl_issuance_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`oversight_review` ADD CONSTRAINT `fk_agency_oversight_review_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ADD CONSTRAINT `fk_agency_remittance_line_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);

-- ========= agency --> property (5 constraint(s)) =========
-- Requires: agency schema, property schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ADD CONSTRAINT `fk_agency_cpl_issuance_insured_ownership_interest_id` FOREIGN KEY (`insured_ownership_interest_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest`(`ownership_interest_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ADD CONSTRAINT `fk_agency_cpl_issuance_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance` ADD CONSTRAINT `fk_agency_cpl_issuance_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ADD CONSTRAINT `fk_agency_remittance_line_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ADD CONSTRAINT `fk_agency_remittance_line_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);

-- ========= agency --> underwriting (1 constraint(s)) =========
-- Requires: agency schema, underwriting schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_agency`.`remittance_line` ADD CONSTRAINT `fk_agency_remittance_line_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);

-- ========= claim --> agency (4 constraint(s)) =========
-- Requires: claim schema, agency schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ADD CONSTRAINT `fk_claim_event_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);

-- ========= claim --> operations (21 constraint(s)) =========
-- Requires: claim schema, operations schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_title_assigned_counsel_party_id` FOREIGN KEY (`title_assigned_counsel_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_title_claimant_party_id` FOREIGN KEY (`title_claimant_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_title_party_id` FOREIGN KEY (`title_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ADD CONSTRAINT `fk_claim_event_event_claimant_party_id` FOREIGN KEY (`event_claimant_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ADD CONSTRAINT `fk_claim_event_event_party_id` FOREIGN KEY (`event_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ADD CONSTRAINT `fk_claim_event_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ADD CONSTRAINT `fk_claim_reserve_approved_by_user_party_id` FOREIGN KEY (`approved_by_user_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ADD CONSTRAINT `fk_claim_reserve_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_loss_party_id` FOREIGN KEY (`loss_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_loss_payee_party_id` FOREIGN KEY (`loss_payee_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ADD CONSTRAINT `fk_claim_recovery_receipt_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ADD CONSTRAINT `fk_claim_recovery_receipt_recovery_counsel_party_id` FOREIGN KEY (`recovery_counsel_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ADD CONSTRAINT `fk_claim_recovery_receipt_recovery_source_party_id` FOREIGN KEY (`recovery_source_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_investigation_assigned_counsel_party_id` FOREIGN KEY (`investigation_assigned_counsel_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_investigation_party_id` FOREIGN KEY (`investigation_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ADD CONSTRAINT `fk_claim_claim_party_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_coverage_approving_authority_party_id` FOREIGN KEY (`coverage_approving_authority_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_coverage_party_id` FOREIGN KEY (`coverage_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);

-- ========= claim --> property (11 constraint(s)) =========
-- Requires: claim schema, property schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ADD CONSTRAINT `fk_claim_event_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_easement_restriction_id` FOREIGN KEY (`easement_restriction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction`(`easement_restriction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_encumbrance_id` FOREIGN KEY (`encumbrance_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance`(`encumbrance_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ADD CONSTRAINT `fk_claim_regulatory_loss_report_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);

-- ========= claim --> recording (3 constraint(s)) =========
-- Requires: claim schema, recording schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_recorded_instrument_id` FOREIGN KEY (`recorded_instrument_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument`(`recorded_instrument_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_recorded_instrument_id` FOREIGN KEY (`recorded_instrument_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument`(`recorded_instrument_id`);

-- ========= claim --> settlement (2 constraint(s)) =========
-- Requires: claim schema, settlement schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_disbursement_id` FOREIGN KEY (`disbursement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement`(`disbursement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_closing_document_id` FOREIGN KEY (`closing_document_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document`(`closing_document_id`);

-- ========= claim --> underwriting (25 constraint(s)) =========
-- Requires: claim schema, underwriting schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim` ADD CONSTRAINT `fk_claim_title_claim_underwriting_title_examination_id` FOREIGN KEY (`underwriting_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination`(`underwriting_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event` ADD CONSTRAINT `fk_claim_event_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`reserve` ADD CONSTRAINT `fk_claim_reserve_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_curative_action_id` FOREIGN KEY (`curative_action_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action`(`curative_action_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`loss_payment` ADD CONSTRAINT `fk_claim_loss_payment_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`recovery_receipt` ADD CONSTRAINT `fk_claim_recovery_receipt_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`investigation` ADD CONSTRAINT `fk_claim_investigation_underwriting_title_examination_id` FOREIGN KEY (`underwriting_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination`(`underwriting_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_curative_action_id` FOREIGN KEY (`curative_action_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action`(`curative_action_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_title_finding_id` FOREIGN KEY (`title_finding_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`(`title_finding_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_title_requirement_id` FOREIGN KEY (`title_requirement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement`(`title_requirement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_underwriting_title_examination_id` FOREIGN KEY (`underwriting_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination`(`underwriting_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_curative_action` ADD CONSTRAINT `fk_claim_claim_curative_action_uw_referral_id` FOREIGN KEY (`uw_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`claim_party` ADD CONSTRAINT `fk_claim_claim_party_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`regulatory_loss_report` ADD CONSTRAINT `fk_claim_regulatory_loss_report_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_curative_action_id` FOREIGN KEY (`curative_action_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action`(`curative_action_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_title_finding_id` FOREIGN KEY (`title_finding_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`(`title_finding_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_underwriting_title_examination_id` FOREIGN KEY (`underwriting_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination`(`underwriting_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_claim`.`coverage_decision` ADD CONSTRAINT `fk_claim_coverage_decision_uw_referral_id` FOREIGN KEY (`uw_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);

-- ========= operations --> agency (4 constraint(s)) =========
-- Requires: operations schema, agency schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ADD CONSTRAINT `fk_operations_title_order_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role` ADD CONSTRAINT `fk_operations_party_role_cpl_issuance_id` FOREIGN KEY (`cpl_issuance_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance`(`cpl_issuance_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ADD CONSTRAINT `fk_operations_operations_title_examination_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ADD CONSTRAINT `fk_operations_order_status_history_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);

-- ========= operations --> property (7 constraint(s)) =========
-- Requires: operations schema, property schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order` ADD CONSTRAINT `fk_operations_title_order_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ADD CONSTRAINT `fk_operations_title_search_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ADD CONSTRAINT `fk_operations_title_search_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination` ADD CONSTRAINT `fk_operations_operations_title_examination_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_easement_restriction_id` FOREIGN KEY (`easement_restriction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction`(`easement_restriction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_encumbrance_id` FOREIGN KEY (`encumbrance_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance`(`encumbrance_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_title_evidence_id` FOREIGN KEY (`title_evidence_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`(`title_evidence_id`);

-- ========= operations --> recording (3 constraint(s)) =========
-- Requires: operations schema, recording schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search` ADD CONSTRAINT `fk_operations_title_search_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ADD CONSTRAINT `fk_operations_order_status_history_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);

-- ========= operations --> underwriting (4 constraint(s)) =========
-- Requires: operations schema, underwriting schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`order_status_history` ADD CONSTRAINT `fk_operations_order_status_history_uw_referral_id` FOREIGN KEY (`uw_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_title_finding_id` FOREIGN KEY (`title_finding_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`(`title_finding_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_title_requirement_id` FOREIGN KEY (`title_requirement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement`(`title_requirement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action` ADD CONSTRAINT `fk_operations_operations_curative_action_uw_referral_id` FOREIGN KEY (`uw_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);

-- ========= property --> claim (1 constraint(s)) =========
-- Requires: property schema, claim schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_superseded_event_id` FOREIGN KEY (`superseded_event_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`event`(`event_id`);

-- ========= property --> operations (5 constraint(s)) =========
-- Requires: property schema, operations schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`ownership_interest` ADD CONSTRAINT `fk_property_ownership_interest_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence` ADD CONSTRAINT `fk_property_title_evidence_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ADD CONSTRAINT `fk_property_grantor_grantee_index_grantor_grantee_party_id` FOREIGN KEY (`grantor_grantee_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ADD CONSTRAINT `fk_property_grantor_grantee_index_primary_grantor_party_id` FOREIGN KEY (`primary_grantor_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);

-- ========= property --> recording (4 constraint(s)) =========
-- Requires: property schema, recording schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`encumbrance` ADD CONSTRAINT `fk_property_encumbrance_recorded_instrument_id` FOREIGN KEY (`recorded_instrument_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument`(`recorded_instrument_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`easement_restriction` ADD CONSTRAINT `fk_property_easement_restriction_recorded_instrument_id` FOREIGN KEY (`recorded_instrument_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument`(`recorded_instrument_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`lifecycle_event` ADD CONSTRAINT `fk_property_lifecycle_event_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_property`.`grantor_grantee_index` ADD CONSTRAINT `fk_property_grantor_grantee_index_recorded_instrument_id` FOREIGN KEY (`recorded_instrument_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument`(`recorded_instrument_id`);

-- ========= recording --> agency (5 constraint(s)) =========
-- Requires: recording schema, agency schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ADD CONSTRAINT `fk_recording_recording_submission_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ADD CONSTRAINT `fk_recording_recorded_instrument_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ADD CONSTRAINT `fk_recording_submission_document_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ADD CONSTRAINT `fk_recording_rejection_event_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ADD CONSTRAINT `fk_recording_gap_coverage_period_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);

-- ========= recording --> claim (2 constraint(s)) =========
-- Requires: recording schema, claim schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ADD CONSTRAINT `fk_recording_recorded_instrument_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ADD CONSTRAINT `fk_recording_gap_coverage_period_title_claim_id` FOREIGN KEY (`title_claim_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_claim`.`title_claim`(`title_claim_id`);

-- ========= recording --> operations (11 constraint(s)) =========
-- Requires: recording schema, operations schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ADD CONSTRAINT `fk_recording_recording_submission_submitted_by_party_id` FOREIGN KEY (`submitted_by_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ADD CONSTRAINT `fk_recording_recording_submission_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ADD CONSTRAINT `fk_recording_recorded_instrument_operations_title_examination_id` FOREIGN KEY (`operations_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination`(`operations_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ADD CONSTRAINT `fk_recording_recorded_instrument_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_document` ADD CONSTRAINT `fk_recording_submission_document_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ADD CONSTRAINT `fk_recording_rejection_event_operations_curative_action_id` FOREIGN KEY (`operations_curative_action_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_curative_action`(`operations_curative_action_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`rejection_event` ADD CONSTRAINT `fk_recording_rejection_event_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ADD CONSTRAINT `fk_recording_gap_coverage_period_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ADD CONSTRAINT `fk_recording_submission_status_history_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`submission_status_history` ADD CONSTRAINT `fk_recording_submission_status_history_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gateway_transaction` ADD CONSTRAINT `fk_recording_gateway_transaction_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);

-- ========= recording --> property (1 constraint(s)) =========
-- Requires: recording schema, property schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ADD CONSTRAINT `fk_recording_recorded_instrument_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);

-- ========= recording --> settlement (1 constraint(s)) =========
-- Requires: recording schema, settlement schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ADD CONSTRAINT `fk_recording_recording_submission_settlement_statement_id` FOREIGN KEY (`settlement_statement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement`(`settlement_statement_id`);

-- ========= recording --> underwriting (6 constraint(s)) =========
-- Requires: recording schema, underwriting schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ADD CONSTRAINT `fk_recording_recording_submission_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission` ADD CONSTRAINT `fk_recording_recording_submission_uw_referral_id` FOREIGN KEY (`uw_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recorded_instrument` ADD CONSTRAINT `fk_recording_recorded_instrument_title_finding_id` FOREIGN KEY (`title_finding_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding`(`title_finding_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ADD CONSTRAINT `fk_recording_gap_coverage_period_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ADD CONSTRAINT `fk_recording_gap_coverage_period_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_recording`.`gap_coverage_period` ADD CONSTRAINT `fk_recording_gap_coverage_period_uw_referral_id` FOREIGN KEY (`uw_referral_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral`(`uw_referral_id`);

-- ========= settlement --> agency (7 constraint(s)) =========
-- Requires: settlement schema, agency schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_agency_agreement_id` FOREIGN KEY (`agency_agreement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agreement`(`agreement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_cpl_issuance_id` FOREIGN KEY (`cpl_issuance_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance`(`cpl_issuance_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ADD CONSTRAINT `fk_settlement_escrow_ledger_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ADD CONSTRAINT `fk_settlement_escrow_ledger_cpl_issuance_id` FOREIGN KEY (`cpl_issuance_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`cpl_issuance`(`cpl_issuance_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ADD CONSTRAINT `fk_settlement_premium_charge_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ADD CONSTRAINT `fk_settlement_premium_charge_premium_split_schedule_id` FOREIGN KEY (`premium_split_schedule_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`premium_split_schedule`(`premium_split_schedule_id`);

-- ========= settlement --> operations (19 constraint(s)) =========
-- Requires: settlement schema, operations schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_closing_escrow_officer_party_id` FOREIGN KEY (`closing_escrow_officer_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_closing_lender_party_id` FOREIGN KEY (`closing_lender_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_primary_closing_agent_party_id` FOREIGN KEY (`primary_closing_agent_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ADD CONSTRAINT `fk_settlement_settlement_statement_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ADD CONSTRAINT `fk_settlement_escrow_ledger_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ADD CONSTRAINT `fk_settlement_escrow_ledger_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ADD CONSTRAINT `fk_settlement_disbursement_payee_party_id` FOREIGN KEY (`payee_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ADD CONSTRAINT `fk_settlement_disbursement_payee_party_role_id` FOREIGN KEY (`payee_party_role_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role`(`party_role_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ADD CONSTRAINT `fk_settlement_disbursement_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`wire_instruction` ADD CONSTRAINT `fk_settlement_wire_instruction_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ADD CONSTRAINT `fk_settlement_premium_charge_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ADD CONSTRAINT `fk_settlement_closing_document_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ADD CONSTRAINT `fk_settlement_escrow_reconciliation_approved_by_supervisor_party_id` FOREIGN KEY (`approved_by_supervisor_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_reconciliation` ADD CONSTRAINT `fk_settlement_escrow_reconciliation_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ADD CONSTRAINT `fk_settlement_escrow_receipt_escrow_officer_party_id` FOREIGN KEY (`escrow_officer_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ADD CONSTRAINT `fk_settlement_escrow_receipt_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ADD CONSTRAINT `fk_settlement_escrow_receipt_remitter_party_role_id` FOREIGN KEY (`remitter_party_role_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party_role`(`party_role_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ADD CONSTRAINT `fk_settlement_escrow_receipt_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);

-- ========= settlement --> property (11 constraint(s)) =========
-- Requires: settlement schema, property schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ADD CONSTRAINT `fk_settlement_settlement_statement_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ADD CONSTRAINT `fk_settlement_settlement_statement_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ADD CONSTRAINT `fk_settlement_escrow_ledger_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ADD CONSTRAINT `fk_settlement_disbursement_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ADD CONSTRAINT `fk_settlement_premium_charge_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ADD CONSTRAINT `fk_settlement_premium_charge_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ADD CONSTRAINT `fk_settlement_closing_document_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ADD CONSTRAINT `fk_settlement_closing_document_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ADD CONSTRAINT `fk_settlement_closing_document_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_receipt` ADD CONSTRAINT `fk_settlement_escrow_receipt_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);

-- ========= settlement --> recording (1 constraint(s)) =========
-- Requires: settlement schema, recording schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ADD CONSTRAINT `fk_settlement_closing_document_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);

-- ========= settlement --> underwriting (9 constraint(s)) =========
-- Requires: settlement schema, underwriting schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_order` ADD CONSTRAINT `fk_settlement_closing_order_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ADD CONSTRAINT `fk_settlement_settlement_statement_title_commitment_id` FOREIGN KEY (`title_commitment_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment`(`title_commitment_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`settlement_statement` ADD CONSTRAINT `fk_settlement_settlement_statement_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`escrow_ledger` ADD CONSTRAINT `fk_settlement_escrow_ledger_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`disbursement` ADD CONSTRAINT `fk_settlement_disbursement_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ADD CONSTRAINT `fk_settlement_premium_charge_endorsement_id` FOREIGN KEY (`endorsement_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement`(`endorsement_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`premium_charge` ADD CONSTRAINT `fk_settlement_premium_charge_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_settlement`.`closing_document` ADD CONSTRAINT `fk_settlement_closing_document_title_policy_id` FOREIGN KEY (`title_policy_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy`(`title_policy_id`);

-- ========= underwriting --> agency (5 constraint(s)) =========
-- Requires: underwriting schema, agency schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ADD CONSTRAINT `fk_underwriting_title_commitment_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ADD CONSTRAINT `fk_underwriting_title_policy_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ADD CONSTRAINT `fk_underwriting_endorsement_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_agent_profile_id` FOREIGN KEY (`agent_profile_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_agency`.`agent_profile`(`agent_profile_id`);

-- ========= underwriting --> operations (27 constraint(s)) =========
-- Requires: underwriting schema, operations schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ADD CONSTRAINT `fk_underwriting_title_finding_operations_title_examination_id` FOREIGN KEY (`operations_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination`(`operations_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ADD CONSTRAINT `fk_underwriting_title_finding_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ADD CONSTRAINT `fk_underwriting_title_finding_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ADD CONSTRAINT `fk_underwriting_title_finding_title_search_id` FOREIGN KEY (`title_search_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search`(`title_search_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ADD CONSTRAINT `fk_underwriting_title_requirement_operations_title_examination_id` FOREIGN KEY (`operations_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination`(`operations_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ADD CONSTRAINT `fk_underwriting_title_requirement_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ADD CONSTRAINT `fk_underwriting_title_requirement_title_search_id` FOREIGN KEY (`title_search_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search`(`title_search_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ADD CONSTRAINT `fk_underwriting_policy_exception_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ADD CONSTRAINT `fk_underwriting_policy_exception_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ADD CONSTRAINT `fk_underwriting_title_commitment_operations_title_examination_id` FOREIGN KEY (`operations_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination`(`operations_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ADD CONSTRAINT `fk_underwriting_title_commitment_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ADD CONSTRAINT `fk_underwriting_title_commitment_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ADD CONSTRAINT `fk_underwriting_title_commitment_underwriter_id` FOREIGN KEY (`underwriter_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ADD CONSTRAINT `fk_underwriting_title_policy_originating_title_order_id` FOREIGN KEY (`originating_title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ADD CONSTRAINT `fk_underwriting_endorsement_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_uw_assigned_underwriter_party_id` FOREIGN KEY (`uw_assigned_underwriter_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_uw_party_id` FOREIGN KEY (`uw_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_assigned_party_id` FOREIGN KEY (`assigned_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_operations_title_examination_id` FOREIGN KEY (`operations_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination`(`operations_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ADD CONSTRAINT `fk_underwriting_underwriting_title_examination_examiner_party_id` FOREIGN KEY (`examiner_party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ADD CONSTRAINT `fk_underwriting_underwriting_title_examination_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`underwriting_title_examination` ADD CONSTRAINT `fk_underwriting_underwriting_title_examination_title_search_id` FOREIGN KEY (`title_search_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_search`(`title_search_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_operations_title_examination_id` FOREIGN KEY (`operations_title_examination_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`operations_title_examination`(`operations_title_examination_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_party_id` FOREIGN KEY (`party_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`party`(`party_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_title_order_id` FOREIGN KEY (`title_order_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_operations`.`title_order`(`title_order_id`);

-- ========= underwriting --> property (12 constraint(s)) =========
-- Requires: underwriting schema, property schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ADD CONSTRAINT `fk_underwriting_title_finding_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_finding` ADD CONSTRAINT `fk_underwriting_title_finding_title_evidence_id` FOREIGN KEY (`title_evidence_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`(`title_evidence_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_requirement` ADD CONSTRAINT `fk_underwriting_title_requirement_parcel_id` FOREIGN KEY (`parcel_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`parcel`(`parcel_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`policy_exception` ADD CONSTRAINT `fk_underwriting_policy_exception_title_evidence_id` FOREIGN KEY (`title_evidence_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`(`title_evidence_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ADD CONSTRAINT `fk_underwriting_title_commitment_legal_description_id` FOREIGN KEY (`legal_description_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`legal_description`(`legal_description_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_commitment` ADD CONSTRAINT `fk_underwriting_title_commitment_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`title_policy` ADD CONSTRAINT `fk_underwriting_title_policy_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`endorsement` ADD CONSTRAINT `fk_underwriting_endorsement_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`uw_referral` ADD CONSTRAINT `fk_underwriting_uw_referral_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_title_evidence_id` FOREIGN KEY (`title_evidence_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`(`title_evidence_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_property_id` FOREIGN KEY (`property_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`property`(`property_id`);
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`decision` ADD CONSTRAINT `fk_underwriting_decision_title_evidence_id` FOREIGN KEY (`title_evidence_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_property`.`title_evidence`(`title_evidence_id`);

-- ========= underwriting --> recording (1 constraint(s)) =========
-- Requires: underwriting schema, recording schema
ALTER TABLE `serverless_stable_dvmvgw_catalog`.`ti_underwriting`.`curative_action` ADD CONSTRAINT `fk_underwriting_curative_action_recording_submission_id` FOREIGN KEY (`recording_submission_id`) REFERENCES `serverless_stable_dvmvgw_catalog`.`ti_recording`.`recording_submission`(`recording_submission_id`);
