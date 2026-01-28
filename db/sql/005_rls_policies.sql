-- db/sql/005_rls_policies.sql
-- BLUEPRINTS — Phase 2 / Module 2.1
-- Row-Level Security (RLS) policies for PRIVATE schema (PII protection).
--
-- GOAL:
-- - PRIVATE schema is completely inaccessible by default
-- - Only trusted backend roles may read/write
-- - PUBLIC schema remains open (no RLS)
--
-- ASSUMPTION:
-- - Application connects using a trusted role (e.g. neondb_owner or app_service)
-- - Public/API users NEVER connect with this role

BEGIN;

-- --------------------------------------------------
-- 1) ENABLE RLS ON ALL PRIVATE TABLES
-- --------------------------------------------------

ALTER TABLE private.voter_registration ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.vote_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.segments ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.segment_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.import_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE private.audit_logs ENABLE ROW LEVEL SECURITY;

-- --------------------------------------------------
-- 2) REMOVE ANY EXISTING POLICIES (IDEMPOTENT)
-- --------------------------------------------------

DROP POLICY IF EXISTS voter_registration_service_policy ON private.voter_registration;
DROP POLICY IF EXISTS vote_history_service_policy ON private.vote_history;
DROP POLICY IF EXISTS segments_service_policy ON private.segments;
DROP POLICY IF EXISTS segment_members_service_policy ON private.segment_members;
DROP POLICY IF EXISTS import_jobs_service_policy ON private.import_jobs;
DROP POLICY IF EXISTS audit_logs_service_policy ON private.audit_logs;

-- --------------------------------------------------
-- 3) SERVICE-ONLY ACCESS POLICIES
-- --------------------------------------------------
-- These policies allow FULL access ONLY to trusted DB roles.
-- Replace role name if you later create a dedicated app role.

-- Voter Registration
CREATE POLICY voter_registration_service_policy
ON private.voter_registration
FOR ALL
USING (current_user = 'neondb_owner')
WITH CHECK (current_user = 'neondb_owner');

-- Vote History
CREATE POLICY vote_history_service_policy
ON private.vote_history
FOR ALL
USING (current_user = 'neondb_owner')
WITH CHECK (current_user = 'neondb_owner');

-- Segments
CREATE POLICY segments_service_policy
ON private.segments
FOR ALL
USING (current_user = 'neondb_owner')
WITH CHECK (current_user = 'neondb_owner');

-- Segment Members
CREATE POLICY segment_members_service_policy
ON private.segment_members
FOR ALL
USING (current_user = 'neondb_owner')
WITH CHECK (current_user = 'neondb_owner');

-- Import Jobs
CREATE POLICY import_jobs_service_policy
ON private.import_jobs
FOR ALL
USING (current_user = 'neondb_owner')
WITH CHECK (current_user = 'neondb_owner');

-- Audit Logs
CREATE POLICY audit_logs_service_policy
ON private.audit_logs
FOR ALL
USING (current_user = 'neondb_owner')
WITH CHECK (current_user = 'neondb_owner');

-- --------------------------------------------------
-- 4) FORCE RLS (NO BYPASS, EVEN FOR TABLE OWNER)
-- --------------------------------------------------

ALTER TABLE private.voter_registration FORCE ROW LEVEL SECURITY;
ALTER TABLE private.vote_history FORCE ROW LEVEL SECURITY;
ALTER TABLE private.segments FORCE ROW LEVEL SECURITY;
ALTER TABLE private.segment_members FORCE ROW LEVEL SECURITY;
ALTER TABLE private.import_jobs FORCE ROW LEVEL SECURITY;
ALTER TABLE private.audit_logs FORCE ROW LEVEL SECURITY;

COMMIT;

-- --------------------------------------------------
-- RESULT:
-- ✔ PRIVATE schema locked
-- ✔ No public reads possible
-- ✔ Only trusted backend role may access voter data
-- ✔ Safe for deployment + resale
-- --------------------------------------------------
