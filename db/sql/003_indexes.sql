-- db/sql/003_indexes.sql
-- BLUEPRINTS — Phase 2 / Module 2.1
-- Indexes for performance and intended query patterns.
-- Safe to re-run (IF NOT EXISTS).

-- -----------------------------
-- PUBLIC schema indexes
-- -----------------------------

-- Counties / Issues: slug uniqueness already creates indexes.
-- Add supporting indexes for common filters.
CREATE INDEX IF NOT EXISTS idx_counties_is_active
  ON public.counties (is_active);

CREATE INDEX IF NOT EXISTS idx_issues_is_active
  ON public.issues (is_active);

-- CountyIssues join lookups
CREATE INDEX IF NOT EXISTS idx_county_issues_county_id
  ON public.county_issues (county_id);

CREATE INDEX IF NOT EXISTS idx_county_issues_issue_id
  ON public.county_issues (issue_id);

-- Blueprint sections: scoped content
CREATE INDEX IF NOT EXISTS idx_blueprint_sections_county_id
  ON public.blueprint_sections (county_id);

CREATE INDEX IF NOT EXISTS idx_blueprint_sections_issue_id
  ON public.blueprint_sections (issue_id);

-- Quotes / Assets: scoped retrieval
CREATE INDEX IF NOT EXISTS idx_quotes_county_id
  ON public.quotes (county_id);

CREATE INDEX IF NOT EXISTS idx_quotes_issue_id
  ON public.quotes (issue_id);

CREATE INDEX IF NOT EXISTS idx_assets_county_id
  ON public.assets (county_id);

CREATE INDEX IF NOT EXISTS idx_assets_issue_id
  ON public.assets (issue_id);

-- Source docs / chunks: trust engine performance
CREATE INDEX IF NOT EXISTS idx_source_chunks_source_document_id
  ON public.source_chunks (source_document_id);

CREATE INDEX IF NOT EXISTS idx_source_chunks_content_hash
  ON public.source_chunks (content_hash);

CREATE INDEX IF NOT EXISTS idx_source_document_links_source_document_id
  ON public.source_document_links (source_document_id);

CREATE INDEX IF NOT EXISTS idx_source_document_links_county_id
  ON public.source_document_links (county_id);

CREATE INDEX IF NOT EXISTS idx_source_document_links_issue_id
  ON public.source_document_links (issue_id);

CREATE INDEX IF NOT EXISTS idx_source_document_links_blueprint_section_id
  ON public.source_document_links (blueprint_section_id);

CREATE INDEX IF NOT EXISTS idx_source_document_links_quote_id
  ON public.source_document_links (quote_id);

CREATE INDEX IF NOT EXISTS idx_source_document_links_asset_id
  ON public.source_document_links (asset_id);

CREATE INDEX IF NOT EXISTS idx_source_document_links_survey_form_id
  ON public.source_document_links (survey_form_id);

-- Metrics: County Snapshot query patterns
CREATE INDEX IF NOT EXISTS idx_census_metrics_county_metric
  ON public.census_metrics (county_id, metric_key);

CREATE INDEX IF NOT EXISTS idx_census_metrics_zip_metric
  ON public.census_metrics (geo_zip_id, metric_key);

CREATE INDEX IF NOT EXISTS idx_bls_metrics_county_series
  ON public.bls_metrics (county_id, series_key);

-- Civics officials
CREATE INDEX IF NOT EXISTS idx_civics_officials_county_id
  ON public.civics_officials (county_id);

CREATE INDEX IF NOT EXISTS idx_civics_officials_district_id
  ON public.civics_officials (district_id);

-- Elections / results
CREATE INDEX IF NOT EXISTS idx_elections_election_date
  ON public.elections (election_date);

CREATE INDEX IF NOT EXISTS idx_election_results_election_id
  ON public.election_results (election_id);

CREATE INDEX IF NOT EXISTS idx_election_results_county_id
  ON public.election_results (county_id);

CREATE INDEX IF NOT EXISTS idx_election_results_precinct_id
  ON public.election_results (precinct_id);

-- Geo: crosswalk lookups
CREATE INDEX IF NOT EXISTS idx_geo_crosswalks_type
  ON public.geo_crosswalks (crosswalk_type);

-- AI: intended query patterns
CREATE INDEX IF NOT EXISTS idx_ai_prompts_prompt_key
  ON public.ai_prompts (prompt_key);

CREATE INDEX IF NOT EXISTS idx_ai_runs_prompt_id
  ON public.ai_runs (prompt_id);

CREATE INDEX IF NOT EXISTS idx_ai_runs_status
  ON public.ai_runs (status);

CREATE INDEX IF NOT EXISTS idx_ai_outputs_run_id
  ON public.ai_outputs (run_id);

CREATE INDEX IF NOT EXISTS idx_ai_outputs_status_type
  ON public.ai_outputs (status, output_type);

CREATE INDEX IF NOT EXISTS idx_ai_output_sections_output_id
  ON public.ai_output_sections (output_id);

CREATE INDEX IF NOT EXISTS idx_ai_output_scopes_output_id
  ON public.ai_output_scopes (output_id);

CREATE INDEX IF NOT EXISTS idx_ai_output_scopes_scope_type
  ON public.ai_output_scopes (scope_type);

CREATE INDEX IF NOT EXISTS idx_ai_output_scopes_county_id
  ON public.ai_output_scopes (county_id);

CREATE INDEX IF NOT EXISTS idx_ai_output_scopes_issue_id
  ON public.ai_output_scopes (issue_id);

CREATE INDEX IF NOT EXISTS idx_ai_output_scopes_geo_zip_id
  ON public.ai_output_scopes (geo_zip_id);

CREATE INDEX IF NOT EXISTS idx_ai_output_scopes_district_id
  ON public.ai_output_scopes (district_id);

CREATE INDEX IF NOT EXISTS idx_citations_output_section_id
  ON public.citations (output_section_id);

CREATE INDEX IF NOT EXISTS idx_citations_source_chunk_id
  ON public.citations (source_chunk_id);

CREATE INDEX IF NOT EXISTS idx_citations_source_document_id
  ON public.citations (source_document_id);

CREATE INDEX IF NOT EXISTS idx_ai_run_input_sources_run_id
  ON public.ai_run_input_sources (run_id);

CREATE INDEX IF NOT EXISTS idx_ai_run_input_sources_source_document_id
  ON public.ai_run_input_sources (source_document_id);

-- Surveys: share links + analytics + fast admin
CREATE INDEX IF NOT EXISTS idx_survey_forms_status
  ON public.survey_forms (status);

CREATE INDEX IF NOT EXISTS idx_survey_forms_county_id
  ON public.survey_forms (county_id);

-- IMPORTANT: slug is UNIQUE already (=> indexed), but we add a named index
-- to make intent explicit and keep query plans stable across environments.
CREATE INDEX IF NOT EXISTS idx_survey_forms_slug
  ON public.survey_forms (slug);

CREATE INDEX IF NOT EXISTS idx_survey_questions_form_active_order
  ON public.survey_questions (form_id, is_active, sort_order);

CREATE INDEX IF NOT EXISTS idx_survey_question_options_question_id
  ON public.survey_question_options (question_id);

CREATE INDEX IF NOT EXISTS idx_survey_question_options_question_order
  ON public.survey_question_options (question_id, sort_order);

CREATE INDEX IF NOT EXISTS idx_survey_responses_form_submitted
  ON public.survey_responses (form_id, submitted_at);

CREATE INDEX IF NOT EXISTS idx_survey_responses_county_id
  ON public.survey_responses (county_id);

CREATE INDEX IF NOT EXISTS idx_survey_response_items_response_id
  ON public.survey_response_items (response_id);

CREATE INDEX IF NOT EXISTS idx_survey_response_items_question_id
  ON public.survey_response_items (question_id);

CREATE INDEX IF NOT EXISTS idx_survey_response_items_selected_option_id
  ON public.survey_response_items (selected_option_id);

CREATE INDEX IF NOT EXISTS idx_survey_response_items_media_asset_id
  ON public.survey_response_items (media_asset_id);

CREATE INDEX IF NOT EXISTS idx_survey_response_item_options_response_item_id
  ON public.survey_response_item_options (response_item_id);

CREATE INDEX IF NOT EXISTS idx_survey_response_item_options_option_id
  ON public.survey_response_item_options (option_id);

-- Voice hooks
CREATE INDEX IF NOT EXISTS idx_media_assets_asset_type
  ON public.media_assets (asset_type);

CREATE INDEX IF NOT EXISTS idx_transcripts_media_asset_id
  ON public.transcripts (media_asset_id);

CREATE INDEX IF NOT EXISTS idx_ai_analyses_type
  ON public.ai_analyses (analysis_type);

CREATE INDEX IF NOT EXISTS idx_ai_analyses_transcript_id
  ON public.ai_analyses (transcript_id);

CREATE INDEX IF NOT EXISTS idx_ai_analyses_media_asset_id
  ON public.ai_analyses (media_asset_id);

CREATE INDEX IF NOT EXISTS idx_ai_analyses_ai_run_id
  ON public.ai_analyses (ai_run_id);

-- -----------------------------
-- PRIVATE schema indexes
-- -----------------------------

-- Voter lookups and joins
-- state_voter_id is UNIQUE already => indexed, but include join-friendly indexes below.

CREATE INDEX IF NOT EXISTS idx_vote_history_voter_id
  ON private.vote_history (voter_id);

CREATE INDEX IF NOT EXISTS idx_vote_history_voter_election_date
  ON private.vote_history (voter_id, election_date);

CREATE INDEX IF NOT EXISTS idx_segment_members_segment_id
  ON private.segment_members (segment_id);

CREATE INDEX IF NOT EXISTS idx_segment_members_voter_id
  ON private.segment_members (voter_id);

-- Import jobs
CREATE INDEX IF NOT EXISTS idx_import_jobs_kind
  ON private.import_jobs (kind);

CREATE INDEX IF NOT EXISTS idx_import_jobs_status
  ON private.import_jobs (status);

-- Audit logs
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at
  ON private.audit_logs (created_at);

CREATE INDEX IF NOT EXISTS idx_audit_logs_action
  ON private.audit_logs (action);

CREATE INDEX IF NOT EXISTS idx_audit_logs_import_job_id
  ON private.audit_logs (import_job_id);
