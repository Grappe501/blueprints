-- db/sql/002_private_voters_schema.sql
-- BLUEPRINTS — Phase 2 / Module 2.1
-- PRIVATE schema: voter file + segmentation + imports + audit logs (PII restricted).
-- Mirrors db/prisma/schema.prisma (private models only).
--
-- RLS is NOT applied here. RLS is enforced in db/sql/005_rls_policies.sql.

-- 0) Safety + prerequisites
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1) Create private schema
CREATE SCHEMA IF NOT EXISTS private;

-- 2) ENUM TYPES (private)
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
                 WHERE t.typname='importjobkind' AND n.nspname='private') THEN
    CREATE TYPE private.ImportJobKind AS ENUM ('voter_registration', 'vote_history', 'other');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
                 WHERE t.typname='importjobstatus' AND n.nspname='private') THEN
    CREATE TYPE private.ImportJobStatus AS ENUM ('queued', 'running', 'succeeded', 'failed');
  END IF;
END $$;

-- 3) Core voter file tables

-- Canonical voter registration record (VR)
CREATE TABLE IF NOT EXISTS private.voter_registration (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Stable voter identifier from the state file
  state_voter_id text NOT NULL UNIQUE,

  -- PII fields
  first_name    text,
  middle_name   text,
  last_name     text,
  suffix        text,
  date_of_birth timestamptz,

  address_line1 text,
  address_line2 text,
  city          text,
  state         text,
  zip           text,

  party         text,
  status        text,

  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

-- Vote history (VH): one row per voter per election event
CREATE TABLE IF NOT EXISTS private.vote_history (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  voter_id      uuid NOT NULL REFERENCES private.voter_registration(id) ON DELETE CASCADE,

  election_date timestamptz,
  election_name text,
  vote_type     text,

  created_at    timestamptz NOT NULL DEFAULT now()
);

-- 4) Segmentation

CREATE TABLE IF NOT EXISTS private.segments (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,
  slug        text NOT NULL UNIQUE,
  description text,

  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

-- Many-to-many membership: voters can be in many segments; segments contain many voters.
CREATE TABLE IF NOT EXISTS private.segment_members (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  segment_id uuid NOT NULL REFERENCES private.segments(id) ON DELETE CASCADE,
  voter_id   uuid NOT NULL REFERENCES private.voter_registration(id) ON DELETE CASCADE,

  created_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT segment_members_unique UNIQUE (segment_id, voter_id)
);

-- 5) Import tracking

CREATE TABLE IF NOT EXISTS private.import_jobs (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  kind         private.ImportJobKind NOT NULL DEFAULT 'other',
  status       private.ImportJobStatus NOT NULL DEFAULT 'queued',

  file_name    text,
  file_hash    text,
  row_count    integer,

  started_at   timestamptz,
  completed_at timestamptz,
  error_text   text,

  created_at   timestamptz NOT NULL DEFAULT now()
);

-- 6) Audit logs (private actions)
-- Auth model is future; we store actor_label for now.
CREATE TABLE IF NOT EXISTS private.audit_logs (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  actor_label  text,
  action       text NOT NULL,
  entity_type  text,
  entity_id    text,

  metadata_json jsonb,

  import_job_id uuid REFERENCES private.import_jobs(id) ON DELETE SET NULL,

  created_at   timestamptz NOT NULL DEFAULT now()
);

-- Notes:
-- - Do not add triggers here; Prisma manages updated_at via @updatedAt semantics.
-- - RLS is enforced in db/sql/005_rls_policies.sql.
