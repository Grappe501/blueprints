-- db/sql/001_public_schema.sql
-- BLUEPRINTS — Phase 2 / Module 2.1
-- PUBLIC schema: content, metrics, AI, surveys, voice hooks (NO PII).
-- Mirrors db/prisma/schema.prisma (public models only).

-- 0) Safety + prerequisites
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS public;

-- 1) ENUM TYPES (public) — idempotent
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='publishstatus' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.PublishStatus AS ENUM ('draft', 'reviewed', 'published');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='yesnounknown' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.YesNoUnknown AS ENUM ('yes', 'no', 'unknown');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='assettype' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.AssetType AS ENUM ('photo', 'document', 'audio', 'video', 'other');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='crosswalktype' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.CrosswalkType AS ENUM (
      'zip_to_county',
      'precinct_to_district',
      'precinct_to_county',
      'zip_to_district',
      'other'
    );
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='airunstatus' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.AIRunStatus AS ENUM ('queued', 'running', 'succeeded', 'failed', 'canceled');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='aioutputtype' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.AIOutputType AS ENUM (
      'county_brief',
      'issue_brief',
      'zip_snapshot',
      'talking_points',
      'action_options',
      'glossary_draft',
      'other'
    );
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='aiscopetype' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.AIScopeType AS ENUM ('county', 'issue', 'zip', 'district', 'statewide', 'custom');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='airuninputkind' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.AIRunInputKind AS ENUM ('source_document', 'dataset', 'manual_note', 'other');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='surveyformstatus' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.SurveyFormStatus AS ENUM ('draft', 'active', 'closed', 'archived');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='surveyquestiontype' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.SurveyQuestionType AS ENUM (
      'text',
      'long_text',
      'number',
      'boolean',
      'single_select',
      'multi_select',
      'rating'
    );
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
    WHERE t.typname='analysistype' AND n.nspname='public'
  ) THEN
    CREATE TYPE public.AnalysisType AS ENUM (
      'transcription_summary',
      'sentiment_estimate',
      'emotion_tags_estimate',
      'speaking_rate_estimate',
      'other'
    );
  END IF;
END $$;

-- 2) CORE CONTENT TABLES

CREATE TABLE IF NOT EXISTS public.counties (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name       text NOT NULL,
  slug       text NOT NULL UNIQUE,
  fips_code  text UNIQUE,
  is_active  boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.issues (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name       text NOT NULL,
  slug       text NOT NULL UNIQUE,
  summary    text,
  is_active  boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.county_issues (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  county_id  uuid NOT NULL REFERENCES public.counties(id) ON DELETE CASCADE,
  issue_id   uuid NOT NULL REFERENCES public.issues(id)   ON DELETE CASCADE,
  featured   boolean NOT NULL DEFAULT false,
  sort_order integer,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT county_issues_unique UNIQUE (county_id, issue_id)
);

CREATE TABLE IF NOT EXISTS public.blueprint_sections (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug        text NOT NULL UNIQUE,
  title       text NOT NULL,
  body_md     text NOT NULL,
  county_id   uuid REFERENCES public.counties(id) ON DELETE SET NULL,
  issue_id    uuid REFERENCES public.issues(id)   ON DELETE SET NULL,
  sort_order  integer,
  is_pinned   boolean NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.quotes (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  text              text NOT NULL,
  attribution_label text,
  county_id          uuid NOT NULL REFERENCES public.counties(id) ON DELETE CASCADE,
  issue_id           uuid REFERENCES public.issues(id) ON DELETE SET NULL,
  source_note        text,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.assets (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  asset_type  public.AssetType NOT NULL DEFAULT 'other',
  title       text,
  caption     text,
  credit      text,
  license     text,
  url         text,
  storage_key text,
  county_id   uuid REFERENCES public.counties(id) ON DELETE SET NULL,
  issue_id    uuid REFERENCES public.issues(id)   ON DELETE SET NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.glossary_terms (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  term          text NOT NULL UNIQUE,
  slug          text NOT NULL UNIQUE,
  definition_md text NOT NULL,
  examples_md   text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

-- 3) TRUST SOURCES (public-safe documents + chunking)

CREATE TABLE IF NOT EXISTS public.source_documents (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title        text NOT NULL,
  url          text,
  storage_key  text,
  publisher    text,
  published_at timestamptz,
  captured_at  timestamptz,
  method_note  text,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.source_chunks (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_document_id  uuid NOT NULL REFERENCES public.source_documents(id) ON DELETE CASCADE,
  chunk_index         integer NOT NULL,
  content             text NOT NULL,
  content_hash        text NOT NULL,
  locator_json        jsonb,
  created_at          timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT source_chunks_unique UNIQUE (source_document_id, chunk_index)
);

-- Generic links (trust markers)
-- IMPORTANT: do NOT FK survey_form_id yet (survey_forms is created later). We'll add FK after.
CREATE TABLE IF NOT EXISTS public.source_document_links (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_document_id   uuid NOT NULL REFERENCES public.source_documents(id) ON DELETE CASCADE,

  county_id            uuid REFERENCES public.counties(id) ON DELETE SET NULL,
  issue_id             uuid REFERENCES public.issues(id)   ON DELETE SET NULL,
  blueprint_section_id uuid REFERENCES public.blueprint_sections(id) ON DELETE SET NULL,
  quote_id             uuid REFERENCES public.quotes(id)   ON DELETE SET NULL,
  asset_id             uuid REFERENCES public.assets(id)   ON DELETE SET NULL,

  survey_form_id       uuid, -- FK added later once survey_forms exists

  note                text,
  created_at          timestamptz NOT NULL DEFAULT now()
);

-- 4) GEO + METRICS + CIVICS + ELECTIONS (public aggregates)

CREATE TABLE IF NOT EXISTS public.geo_counties (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fips_code  text UNIQUE,
  name       text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.geo_zips (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  zip_code   text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.geo_precincts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name          text,
  precinct_code text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.geo_districts (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  district_code text NOT NULL UNIQUE,
  district_type text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.geo_crosswalks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  crosswalk_type  public.CrosswalkType NOT NULL,

  from_geo_zip_id      uuid REFERENCES public.geo_zips(id)      ON DELETE SET NULL,
  from_geo_precinct_id uuid REFERENCES public.geo_precincts(id) ON DELETE SET NULL,
  from_geo_district_id uuid REFERENCES public.geo_districts(id) ON DELETE SET NULL,
  from_geo_county_fips text,

  to_geo_zip_id        uuid REFERENCES public.geo_zips(id)      ON DELETE SET NULL,
  to_geo_precinct_id   uuid REFERENCES public.geo_precincts(id) ON DELETE SET NULL,
  to_geo_district_id   uuid REFERENCES public.geo_districts(id) ON DELETE SET NULL,
  to_geo_county_fips   text,

  weight          double precision,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.census_metrics (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  county_id    uuid REFERENCES public.counties(id) ON DELETE SET NULL,
  geo_zip_id   uuid REFERENCES public.geo_zips(id) ON DELETE SET NULL,
  metric_key   text NOT NULL,
  metric_label text,
  value        double precision,
  value_text   text,
  as_of_date   timestamptz,
  source_note  text,
  created_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.bls_metrics (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  county_id    uuid NOT NULL REFERENCES public.counties(id) ON DELETE CASCADE,
  series_key   text NOT NULL,
  series_label text,
  value        double precision,
  as_of_date   timestamptz,
  source_note  text,
  created_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.civics_officials (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,
  office_name text NOT NULL,
  party       text,
  phone       text,
  website     text,
  photo_url   text,
  county_id   uuid REFERENCES public.counties(id) ON DELETE SET NULL,
  district_id uuid REFERENCES public.geo_districts(id) ON DELETE SET NULL,
  source_note text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.elections (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name          text NOT NULL,
  election_date timestamptz NOT NULL,
  election_type text,
  notes         text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.election_results (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  election_id  uuid NOT NULL REFERENCES public.elections(id) ON DELETE CASCADE,
  county_id    uuid REFERENCES public.counties(id) ON DELETE SET NULL,
  geo_zip_id   uuid REFERENCES public.geo_zips(id) ON DELETE SET NULL,
  precinct_id  uuid REFERENCES public.geo_precincts(id) ON DELETE SET NULL,
  choice_label text NOT NULL,
  votes        integer,
  vote_share   double precision,
  created_at   timestamptz NOT NULL DEFAULT now()
);

-- 5) AI LAYER (public, governed)

CREATE TABLE IF NOT EXISTS public.ai_prompts (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  prompt_key  text NOT NULL,
  version     integer NOT NULL,
  name        text NOT NULL,
  description text,
  template    text NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT ai_prompts_unique UNIQUE (prompt_key, version)
);

CREATE TABLE IF NOT EXISTS public.ai_runs (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  prompt_id     uuid NOT NULL REFERENCES public.ai_prompts(id) ON DELETE CASCADE,
  model         text NOT NULL,
  params_json   jsonb,
  status        public.AIRunStatus NOT NULL DEFAULT 'queued',
  started_at    timestamptz,
  completed_at  timestamptz,
  error_text    text,
  input_summary text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.ai_run_input_sources (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id             uuid NOT NULL REFERENCES public.ai_runs(id) ON DELETE CASCADE,
  kind               public.AIRunInputKind NOT NULL DEFAULT 'source_document',
  source_document_id uuid REFERENCES public.source_documents(id) ON DELETE SET NULL,
  external_key       text,
  notes              text,
  created_at         timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.ai_outputs (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id       uuid NOT NULL REFERENCES public.ai_runs(id) ON DELETE CASCADE,
  output_type  public.AIOutputType NOT NULL DEFAULT 'other',
  status       public.PublishStatus NOT NULL DEFAULT 'draft',
  title        text,
  summary      text,
  content_md   text NOT NULL,
  reviewed_at  timestamptz,
  published_at timestamptz,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.ai_output_sections (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  output_id   uuid NOT NULL REFERENCES public.ai_outputs(id) ON DELETE CASCADE,
  section_key text NOT NULL,
  heading     text,
  "order"     integer NOT NULL DEFAULT 0,
  content_md  text NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT ai_output_sections_unique UNIQUE (output_id, section_key)
);

CREATE TABLE IF NOT EXISTS public.ai_output_scopes (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  output_id   uuid NOT NULL REFERENCES public.ai_outputs(id) ON DELETE CASCADE,
  scope_type  public.AIScopeType NOT NULL,
  county_id   uuid REFERENCES public.counties(id) ON DELETE SET NULL,
  issue_id    uuid REFERENCES public.issues(id) ON DELETE SET NULL,
  geo_zip_id  uuid REFERENCES public.geo_zips(id) ON DELETE SET NULL,
  district_id uuid REFERENCES public.geo_districts(id) ON DELETE SET NULL,
  custom_key  text,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.citations (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  output_section_id  uuid NOT NULL REFERENCES public.ai_output_sections(id) ON DELETE CASCADE,
  source_chunk_id    uuid REFERENCES public.source_chunks(id) ON DELETE SET NULL,
  source_document_id uuid REFERENCES public.source_documents(id) ON DELETE SET NULL,
  label              text,
  locator_json       jsonb,
  created_at         timestamptz NOT NULL DEFAULT now()
);

-- 6) SURVEYS / POLLING + VOICE HOOKS

CREATE TABLE IF NOT EXISTS public.survey_forms (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title          text NOT NULL,
  description_md text,
  slug           text NOT NULL UNIQUE,
  status         public.SurveyFormStatus NOT NULL DEFAULT 'draft',
  start_at       timestamptz,
  end_at         timestamptz,
  county_id      uuid REFERENCES public.counties(id) ON DELETE SET NULL,
  context_label  text,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.survey_questions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  form_id       uuid NOT NULL REFERENCES public.survey_forms(id) ON DELETE CASCADE,
  question_key  text NOT NULL,
  prompt        text NOT NULL,
  help_text     text,
  question_type public.SurveyQuestionType NOT NULL,
  required      boolean NOT NULL DEFAULT false,
  sort_order    integer NOT NULL DEFAULT 0,
  is_active     boolean NOT NULL DEFAULT true,
  allow_voice   boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT survey_questions_unique UNIQUE (form_id, question_key)
);

CREATE TABLE IF NOT EXISTS public.survey_question_options (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id uuid NOT NULL REFERENCES public.survey_questions(id) ON DELETE CASCADE,
  value_key   text NOT NULL,
  label       text NOT NULL,
  sort_order  integer NOT NULL DEFAULT 0,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT survey_question_options_unique UNIQUE (question_id, value_key)
);

CREATE TABLE IF NOT EXISTS public.survey_responses (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  form_id      uuid NOT NULL REFERENCES public.survey_forms(id) ON DELETE CASCADE,
  county_id    uuid REFERENCES public.counties(id) ON DELETE SET NULL,
  source_label text,
  submitted_at timestamptz NOT NULL DEFAULT now(),
  ip_hash      text,
  user_agent   text,
  created_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.media_assets (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  asset_type       public.AssetType NOT NULL DEFAULT 'audio',
  storage_provider text,
  storage_key      text,
  url              text,
  mime_type        text,
  size_bytes       integer,
  duration_ms      integer,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.survey_response_items (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  response_id        uuid NOT NULL REFERENCES public.survey_responses(id) ON DELETE CASCADE,
  question_id        uuid NOT NULL REFERENCES public.survey_questions(id) ON DELETE CASCADE,
  value_text         text,
  value_number       double precision,
  value_boolean      boolean,
  selected_option_id uuid REFERENCES public.survey_question_options(id) ON DELETE SET NULL,
  media_asset_id     uuid REFERENCES public.media_assets(id) ON DELETE SET NULL,
  created_at         timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.survey_response_item_options (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  response_item_id uuid NOT NULL REFERENCES public.survey_response_items(id) ON DELETE CASCADE,
  option_id        uuid NOT NULL REFERENCES public.survey_question_options(id) ON DELETE CASCADE,
  created_at       timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT survey_response_item_options_unique UNIQUE (response_item_id, option_id)
);

CREATE TABLE IF NOT EXISTS public.transcripts (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  media_asset_id   uuid NOT NULL REFERENCES public.media_assets(id) ON DELETE CASCADE,
  provider         text,
  provider_version text,
  language         text,
  transcript_text  text NOT NULL,
  segments_json    jsonb,
  created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.ai_analyses (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  transcript_id  uuid REFERENCES public.transcripts(id) ON DELETE SET NULL,
  media_asset_id uuid REFERENCES public.media_assets(id) ON DELETE SET NULL,
  ai_run_id       uuid REFERENCES public.ai_runs(id) ON DELETE SET NULL,
  analysis_type  public.AnalysisType NOT NULL DEFAULT 'other',
  content_json   jsonb NOT NULL,
  notes          text,
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- 7) Add FK for source_document_links.survey_form_id now that survey_forms exists
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'source_document_links_survey_form_fk'
  ) THEN
    ALTER TABLE public.source_document_links
      ADD CONSTRAINT source_document_links_survey_form_fk
      FOREIGN KEY (survey_form_id) REFERENCES public.survey_forms(id) ON DELETE SET NULL;
  END IF;
END $$;

-- NOTE: updated_at triggers are intentionally handled at application/Prisma layer.
