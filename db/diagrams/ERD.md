# ERD (Text) — BLUEPRINTS Database

**Project:** BLUEPRINTS (AR-02)  
**Phase:** 2 — Database + Contracts  
**Purpose:** Provide a human-readable Entity Relationship Diagram for the Postgres database.

This ERD reflects the two-zone model:
- `public` schema (publishable, safe)
- `private` schema (PII, restricted)

---

## 1) Public schema ERD

### 1.1 Core content (What We Heard)

**counties**
- `counties.id` (PK)
- `counties.slug` (unique)

Relationships:
- counties 1—* `county_issues`
- counties 1—* `blueprint_sections` (optional scope)
- counties 1—* `quotes`
- counties 1—* `assets`
- counties 1—* `census_metrics` (optional)
- counties 1—* `bls_metrics`
- counties 1—* `civics_officials` (optional)
- counties 1—* `survey_forms` (optional)
- counties 1—* `survey_responses` (optional)

---

**issues**
- `issues.id` (PK)
- `issues.slug` (unique)

Relationships:
- issues 1—* `county_issues`
- issues 1—* `blueprint_sections` (optional scope)
- issues 1—* `quotes` (optional scope)
- issues 1—* `assets` (optional scope)
- issues 1—* `ai_output_scopes` (optional scope)

---

**county_issues** (join)
- `county_issues.county_id` → counties.id
- `county_issues.issue_id` → issues.id
- unique (county_id, issue_id)

---

**blueprint_sections**
- optional: `county_id` → counties.id
- optional: `issue_id` → issues.id
- `slug` unique
- markdown body

---

**quotes**
- required: `county_id` → counties.id
- optional: `issue_id` → issues.id

---

**assets**
- optional: `county_id` → counties.id
- optional: `issue_id` → issues.id

---

**glossary_terms**
- independent dictionary table
- used by UI tooltip systems (no FKs required)

---

### 1.2 Trust + provenance

**source_documents**
- `source_documents.id` (PK)
- may point to a URL or stored file key

Relationships:
- source_documents 1—* `source_chunks`
- source_documents 1—* `source_document_links`
- source_documents 1—* `ai_run_input_sources` (optional)
- source_documents 1—* `citations` (optional direct)

---

**source_chunks**
- `source_chunks.source_document_id` → source_documents.id
- unique (source_document_id, chunk_index)
- used for RAG grounding and section citations

Relationships:
- source_chunks 1—* `citations`

---

**source_document_links** (trust markers)
- `source_document_links.source_document_id` → source_documents.id
- optional links to ONE of:
  - counties
  - issues
  - blueprint_sections
  - quotes
  - assets
  - survey_forms

Purpose:
- “this source supports this public artifact”

---

### 1.3 Public data layer

**geo_counties** (optional canonical geo table)
- may overlap with counties; can be used for dataset imports

**geo_zips**
- zip boundaries and identifiers

**geo_precincts**
- precinct identifiers

**geo_districts**
- district identifiers (CD, SD, etc.)

**geo_crosswalks**
- maps between geographies (zip↔county, precinct↔district, etc.)

---

**census_metrics**
- optional: `county_id` → counties.id
- optional: `geo_zip_id` → geo_zips.id
- metric_key/value pattern

---

**bls_metrics**
- required: `county_id` → counties.id
- series_key/value pattern

---

**civics_officials**
- optional: `county_id` → counties.id
- optional: `district_id` → geo_districts.id

---

**elections**
- election metadata

**election_results**
- required: `election_id` → elections.id
- optional: `county_id` → counties.id
- optional: `geo_zip_id` → geo_zips.id
- optional: `precinct_id` → geo_precincts.id

---

### 1.4 AI layer (governed outputs)

**ai_prompts**
- unique (prompt_key, version)

Relationships:
- ai_prompts 1—* `ai_runs`

---

**ai_runs**
- `ai_runs.prompt_id` → ai_prompts.id
- tracks model, params, status

Relationships:
- ai_runs 1—* `ai_outputs`
- ai_runs 1—* `ai_run_input_sources`
- ai_runs 1—* `ai_analyses` (optional)

---

**ai_run_input_sources**
- `run_id` → ai_runs.id
- optional `source_document_id` → source_documents.id
- records what the run was allowed to use

---

**ai_outputs**
- `run_id` → ai_runs.id
- status: draft/reviewed/published
- content_md is canonical output body

Relationships:
- ai_outputs 1—* `ai_output_sections`
- ai_outputs 1—* `ai_output_scopes`

---

**ai_output_sections**
- `output_id` → ai_outputs.id
- unique (output_id, section_key)

Relationships:
- ai_output_sections 1—* `citations`

---

**ai_output_scopes**
- `output_id` → ai_outputs.id
- scope_type: county/issue/zip/district/statewide/custom
- optional:
  - county_id → counties.id
  - issue_id → issues.id
  - geo_zip_id → geo_zips.id
  - district_id → geo_districts.id

---

**citations**
- required: `output_section_id` → ai_output_sections.id
- optional:
  - `source_chunk_id` → source_chunks.id
  - `source_document_id` → source_documents.id

Purpose:
- “this section claim is grounded in this source”

---

### 1.5 Surveys + voice hooks (public-safe)

**survey_forms**
- `slug` unique
- status: draft/active/closed/archived
- optional: `county_id` → counties.id

Relationships:
- survey_forms 1—* `survey_questions`
- survey_forms 1—* `survey_responses`
- survey_forms optional referenced by `source_document_links`

---

**survey_questions**
- `form_id` → survey_forms.id
- unique (form_id, question_key)

Relationships:
- survey_questions 1—* `survey_question_options`
- survey_questions 1—* `survey_response_items`

---

**survey_question_options**
- `question_id` → survey_questions.id
- unique (question_id, value_key)

Relationships:
- referenced by response items (single select)
- referenced by join table (multi select)

---

**survey_responses**
- `form_id` → survey_forms.id
- optional: `county_id` → counties.id

Relationships:
- survey_responses 1—* `survey_response_items`

---

**survey_response_items**
- `response_id` → survey_responses.id
- `question_id` → survey_questions.id
- optional:
  - selected_option_id → survey_question_options.id
  - media_asset_id → media_assets.id (voice input hook)

Relationships:
- survey_response_items 1—* `survey_response_item_options` (multi-select)

---

**survey_response_item_options** (multi-select join)
- `response_item_id` → survey_response_items.id
- `option_id` → survey_question_options.id
- unique (response_item_id, option_id)

---

**media_assets**
- stored media metadata (audio/video/etc.)
- may be attached to survey response items

Relationships:
- media_assets 1—* `transcripts`
- media_assets 1—* `ai_analyses` (optional)

---

**transcripts**
- `media_asset_id` → media_assets.id
- stores transcript text + optional segments JSON

Relationships:
- transcripts 1—* `ai_analyses` (optional)

---

**ai_analyses**
- optional:
  - transcript_id → transcripts.id
  - media_asset_id → media_assets.id
  - ai_run_id → ai_runs.id
- stores analysis JSON (sentiment estimate, tags, speaking rate estimate)

---

## 2) Private schema ERD (PII restricted)

**private.voter_registration**
- `state_voter_id` unique
- PII: name, DOB, address

Relationships:
- voter_registration 1—* `vote_history`
- voter_registration *—* `segments` via `segment_members`

---

**private.vote_history**
- `voter_id` → voter_registration.id

---

**private.segments**
- `slug` unique

Relationships:
- segments *—* voter_registration via `segment_members`

---

**private.segment_members**
- `segment_id` → segments.id
- `voter_id` → voter_registration.id
- unique (segment_id, voter_id)

---

**private.import_jobs**
- tracks file imports (VR/VH)
- referenced by audit logs

---

**private.audit_logs**
- optional: `import_job_id` → import_jobs.id
- records actions on private zone

---

## 3) Boundary rule (critical)

There are **no foreign keys** from `public.*` tables to `private.*` tables.

Access to `private.*` is enforced by:
- schema isolation
- RLS enabled and forced
- service-context session requirement

This is the hard wall that prevents accidental exposure.

---
