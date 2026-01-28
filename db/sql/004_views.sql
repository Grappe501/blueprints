-- db/sql/005_rls_policies.sql
-- BLUEPRINTS — Phase 2 / Module 2.1
-- Row Level Security (RLS) policies enforcing PUBLIC vs PRIVATE zone boundaries.
--
-- Strategy:
-- - Enable and FORCE RLS on all private.* tables.
-- - Default deny (no access) unless the connection/session is marked as service.
-- - Service access is granted via a session variable: app.is_service = 'true'
--
-- Why session variable?
-- - We do not yet define application DB roles/users in Phase 2.
-- - Netlify Functions (server-side) can set SET LOCAL app.is_service='true' when needed.
-- - Public routes/functions never set it, so private tables remain inaccessible.
--
-- Later improvement (future module):
-- - Create separate DB users and role-based policies; keep this as defense in depth.

-- 0) Ensure schemas exist
CREATE SCHEMA IF NOT EXISTS public;
CREATE SCHEMA IF NOT EXISTS private;

-- 1) Defense-in-depth: revoke broad privileges on private schema from PUBLIC
REVOKE ALL ON SCHEMA private FROM PUBLIC;

-- Note: In managed Postgres, your DB owner/admin still has access.
-- RLS + FORCE RLS below ensures even owners are constrained by policies.

-- 2) Helper: predicate for service-only access
-- We use current_setting(..., true) so it returns NULL instead of throwing if unset.
-- The predicate evaluates to true only when app.is_service='true' for the session/txn.
-- Example usage in Netlify Function:
--   await db.query("BEGIN");
--   await db.query("SET LOCAL app.is_service = 'true'");
--   ...private queries...
--   await db.query("COMMIT");
--
-- For clarity, the predicate is repeated inline in each policy.

-- 3) Enable + FORCE RLS on all private tables

ALTER TABLE private.voter_registration ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.voter_registration FORCE ROW LEVEL SECURITY;

ALTER TABLE private.vote_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.vote_history FORCE ROW LEVEL SECURITY;

ALTER TABLE private.segments ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.segments FORCE ROW LEVEL SECURITY;

ALTER TABLE private.segment_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.segment_members FORCE ROW LEVEL SECURITY;

ALTER TABLE private.import_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.import_jobs FORCE ROW LEVEL SECURITY;

ALTER TABLE private.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.audit_logs FORCE ROW LEVEL SECURITY;

-- 4) Drop existing policies if re-running (idempotent-ish)
DO $$ BEGIN
  -- voter_registration
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='private' AND tablename='voter_registration') THEN
    EXECUTE 'DROP POLICY IF EXISTS voter_registration_service_select ON private.voter_registration';
    EXECUTE 'DROP POLICY IF EXISTS voter_registration_service_modify ON private.voter_registration';
  END IF;

  -- vote_history
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='private' AND tablename='vote_history') THEN
    EXECUTE 'DROP POLICY IF EXISTS vote_history_service_select ON private.vote_history';
    EXECUTE 'DROP POLICY IF EXISTS vote_history_service_modify ON private.vote_history';
  END IF;

  -- segments
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='private' AND tablename='segments') THEN
    EXECUTE 'DROP POLICY IF EXISTS segments_service_select ON private.segments';
    EXECUTE 'DROP POLICY IF EXISTS segments_service_modify ON private.segments';
  END IF;

  -- segment_members
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='private' AND tablename='segment_members') THEN
    EXECUTE 'DROP POLICY IF EXISTS segment_members_service_select ON private.segment_members';
    EXECUTE 'DROP POLICY IF EXISTS segment_members_service_modify ON private.segment_members';
  END IF;

  -- import_jobs
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='private' AND tablename='import_jobs') THEN
    EXECUTE 'DROP POLICY IF EXISTS import_jobs_service_select ON private.import_jobs';
    EXECUTE 'DROP POLICY IF EXISTS import_jobs_service_modify ON private.import_jobs';
  END IF;

  -- audit_logs
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='private' AND tablename='audit_logs') THEN
    EXECUTE 'DROP POLICY IF EXISTS audit_logs_service_select ON private.audit_logs';
    EXECUTE 'DROP POLICY IF EXISTS audit_logs_service_modify ON private.audit_logs';
  END IF;
END $$;

-- 5) Create service-only policies (SELECT + MODIFY)

-- voter_registration
CREATE POLICY voter_registration_service_select
  ON private.voter_registration
  FOR SELECT
  USING (current_setting('app.is_service', true) = 'true');

CREATE POLICY voter_registration_service_modify
  ON private.voter_registration
  FOR INSERT, UPDATE, DELETE
  USING (current_setting('app.is_service', true) = 'true')
  WITH CHECK (current_setting('app.is_service', true) = 'true');

-- vote_history
CREATE POLICY vote_history_service_select
  ON private.vote_history
  FOR SELECT
  USING (current_setting('app.is_service', true) = 'true');

CREATE POLICY vote_history_service_modify
  ON private.vote_history
  FOR INSERT, UPDATE, DELETE
  USING (current_setting('app.is_service', true) = 'true')
  WITH CHECK (current_setting('app.is_service', true) = 'true');

-- segments
CREATE POLICY segments_service_select
  ON private.segments
  FOR SELECT
  USING (current_setting('app.is_service', true) = 'true');

CREATE POLICY segments_service_modify
  ON private.segments
  FOR INSERT, UPDATE, DELETE
  USING (current_setting('app.is_service', true) = 'true')
  WITH CHECK (current_setting('app.is_service', true) = 'true');

-- segment_members
CREATE POLICY segment_members_service_select
  ON private.segment_members
  FOR SELECT
  USING (current_setting('app.is_service', true) = 'true');

CREATE POLICY segment_members_service_modify
  ON private.segment_members
  FOR INSERT, UPDATE, DELETE
  USING (current_setting('app.is_service', true) = 'true')
  WITH CHECK (current_setting('app.is_service', true) = 'true');

-- import_jobs
CREATE POLICY import_jobs_service_select
  ON private.import_jobs
  FOR SELECT
  USING (current_setting('app.is_service', true) = 'true');

CREATE POLICY import_jobs_service_modify
  ON private.import_jobs
  FOR INSERT, UPDATE, DELETE
  USING (current_setting('app.is_service', true) = 'true')
  WITH CHECK (current_setting('app.is_service', true) = 'true');

-- audit_logs
CREATE POLICY audit_logs_service_select
  ON private.audit_logs
  FOR SELECT
  USING (current_setting('app.is_service', true) = 'true');

CREATE POLICY audit_logs_service_modify
  ON private.audit_logs
  FOR INSERT, UPDATE, DELETE
  USING (current_setting('app.is_service', true) = 'true')
  WITH CHECK (current_setting('app.is_service', true) = 'true');

-- 6) Optional: ensure no accidental grants exist on private tables
-- (Safe: does not remove owner privileges; RLS still applies.)
REVOKE ALL ON ALL TABLES IN SCHEMA private FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA private FROM PUBLIC;

-- End.
