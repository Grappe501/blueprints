# Environment Variables Reference

**Project:** BLUEPRINTS (AR-02)  
**Audience:** Developers, Operators  
**Purpose:** Document all required environment variables and their intended use.

This document defines the contract between the application code and its runtime configuration.

**Secrets must never be committed to the repository.**  
All values are set via the Netlify environment variable UI.

---

## 1) Database

### `DATABASE_URL`
**Required:** Yes  
**Scope:** Server-side only  

Connection string for the Postgres database (Neon).

Used by:
- Prisma
- Netlify server functions
- Admin workflows
- AI batch jobs

Notes:
- Each campaign instance (CD2, CD1, Senate, etc.) gets its own database and URL.
- Never exposed to the client.

---

## 2) AI

### `OPENAI_API_KEY`
**Required:** Yes (for AI features)  
**Scope:** Server-side only  

API key for AI generation.

Used by:
- batch AI generation jobs
- admin-triggered runs

Rules:
- Never used directly in client-side code.
- All outputs are stored and reviewed before publication.

---

## 3) Public data APIs

### `CENSUS_API_KEY`
**Required:** Yes (Phase 5+)  
**Scope:** Server-side only  

Used to fetch Census data for county and ZIP metrics.

---

### `BLS_API_KEY`
**Required:** Yes (Phase 5+)  
**Scope:** Server-side only  

Used to fetch Bureau of Labor Statistics data.

---

### `GOOGLE_CIVICS_API_KEY`
**Required:** Yes (Phase 5+)  
**Scope:** Server-side only  

Used to fetch elected official metadata.

---

## 4) Auth / admin (future modules)

These variables are reserved for future admin authentication and authorization layers.

### `ADMIN_JWT_SECRET`
**Required:** Not yet (future module)  
**Scope:** Server-side only  

Used to sign admin authentication tokens.

---

### `SESSION_SECRET`
**Required:** Not yet (future module)  
**Scope:** Server-side only  

Used for secure session handling.

---

## 5) Service context (RLS support)

### `APP_SERVICE_MODE`
**Required:** No (runtime-controlled)  
**Scope:** Server-side only  

Optional flag used by server code to determine when to set:

SET LOCAL app.is_service = 'true'

This variable does **not** grant access by itself; it is used by server code to decide whether to enter a service context.

---

## 6) Client-exposed variables

Client-exposed variables (prefixed with `NEXT_PUBLIC_`) should be treated as **public information**.

At present:
- No client-exposed environment variables are required for Phase 2.

If added later, they must:
- not contain secrets
- not enable access to private data
- be documented explicitly here

---

## 7) Deployment checklist (per campaign instance)

For each new deployment (e.g., CD1, CD2, Senate):

1. Create a new Netlify site
2. Create a new Neon database
3. Set `DATABASE_URL`
4. Set `OPENAI_API_KEY`
5. (Later phases) set public data API keys
6. Deploy from the same codebase

No data is shared across instances.

---

## 8) Validation

Before considering a deployment valid:
- App starts without missing env var errors
- Database migrations run successfully
- Public pages load without server errors
- Private queries fail unless service context is set

---

## 9) Governance

This document must be updated whenever:
- a new environment variable is introduced
- the scope of an existing variable changes
- a variable becomes client-exposed

Changes that affect security or privacy require a new ADR.
