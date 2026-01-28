# Data Privacy Runbook

**Project:** BLUEPRINTS (AR-02)  
**Audience:** Operators, Developers, Campaign Leadership  
**Purpose:** Provide clear, practical guidance for handling public and private data safely.

This runbook operationalizes the privacy decisions documented in:
- ADR-0002 (Public vs Private Data Zones)
- ADR-0003 (AI Grounding and Citations)

---

## 1) Core privacy model (non-negotiable)

BLUEPRINTS uses a **two-zone data model**:

### Public zone (`public` schema)
Contains:
- County narrative content
- Quotes (privacy-safe)
- Public datasets (Census, BLS, elections aggregates)
- AI-generated summaries and briefs
- Surveys and polling responses (non-PII)

This data is:
- intended for public display
- safe to publish
- safe to summarize with AI

---

### Private zone (`private` schema)
Contains:
- Voter registration records
- Vote history
- Segmentation and targeting data
- Import metadata
- Audit logs

This data is:
- restricted
- PII-bearing
- never exposed publicly
- never used for public AI generation

---

## 2) What must NEVER happen

The following actions are prohibited:

- Copying voter file data into the public schema
- Uploading raw voter files as source documents
- Including private voter attributes in public narratives
- Using private data as AI input for public content
- Allowing public routes to query private tables
- Exporting private data without explicit authorization

Violations are considered critical incidents.

---

## 3) Day-to-day operating rules

### 3.1 Content and listening data
- Public meeting notes must be **redacted** before entering the public zone.
- Quotes must be anonymized unless explicit permission is documented.
- Source documents in the public schema must be safe to share publicly.

If in doubt: **do not upload** — ask first.

---

### 3.2 Surveys and polling
- Public surveys may collect opinions, priorities, and qualitative input.
- Surveys must not request:
  - full names
  - addresses
  - phone numbers
  - emails
  - voter IDs
- Survey responses are treated as public-safe aggregates.

If a survey needs PII, it belongs in a **separate private workflow**, not in this system.

---

### 3.3 AI usage
- AI may summarize public content and datasets only.
- AI outputs must be stored, reviewed, and cited.
- AI must not infer individual behavior or targeting.

AI is a **synthesis tool**, not a profiling engine.

---

## 4) Developer and admin workflows

### 4.1 Database access patterns
- Public web routes and functions:
  - must never set `app.is_service`
  - can only read from public tables

- Admin or service workflows:
  - must explicitly set `SET LOCAL app.is_service = 'true'`
  - may access private tables only within that context

Example (server-side):
BEGIN;
SET LOCAL app.is_service = 'true';
-- private queries here
COMMIT;

---

### 4.2 Testing and development
- Never test private data access from public routes.
- Use fake or redacted data in development where possible.
- Validate that private table queries return zero rows without service context.

---

## 5) Incident response

### 5.1 If a potential data issue is detected
1. Stop affected processes immediately.
2. Disable public access to the affected feature if necessary.
3. Identify:
   - what data was involved
   - where it appeared
   - how it was accessed
4. Document the incident in a private log.
5. Remediate and review before re-enabling.

---

### 5.2 If unsure
When uncertain about whether data is safe:
- treat it as private
- do not publish
- escalate for review

---

## 6) Training and accountability

- All operators and developers must read this runbook.
- New contributors must be onboarded to the two-zone model.
- Repeated or intentional violations require corrective action.

---

## 7) Guiding principle

> **If the system makes it hard to do the wrong thing, it is working.**

Privacy is not a feature — it is a constraint that protects trust, credibility, and the campaign.
