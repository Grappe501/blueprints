# BLUEPRINTS — Master Build (Authoritative)

**Project:** AR-02 Blueprint Sessions Public Database + Action Platform  
**Owner:** Chris Jones for Congress (Blueprints)  
**Build Pilot:** ChatGPT (Architecture + Module Control)

**Repository:** https://github.com/Grappe501/blueprints  
**Local Root:** `C:\Users\User\Desktop\Blueprints`

---

## 0) Current Status (Live)

### Build Clock & Productivity Tracking
**Global Start:** Tuesday, Jan 27, 2026 — 11:00 AM (America/Chicago)

> Rule: Update this file after every phase. No exceptions.  
> Rule: Every phase ends with a commit + push + zip. No exceptions.  
> Rule: No schema churn unless explicitly approved.

### Phase Log
| Phase | Goal | Start | End | Duration | Status | Notes |
|------:|------|-------|-----|----------|--------|------|
| 1 | Universe skeleton + master spec | 2026-01-27 11:00 | 2026-01-27 11:45 | 45m | Complete | Skeleton created; repo structure + module system established |
| 2 | DB schemas + ingestion contracts | 2026-01-27 11:45 | 2026-01-27 18:20 | ~6h 35m | Complete (validated) | Prisma compiles; public/private schemas exist; RLS enforced + verified; indexes applied; `.env` configured + tested against Neon |
| 3 | Section 1: “What We Heard” MVP | 2026-01-27 20:30 |  |  | In Progress | Frontend + content scaffolding; trust markers; county pages MVP |
| 4 | AI pipeline v1 (grounded briefs) |  |  |  | Planned | Chunking + citations + batch generation + versioned prompts |
| 5 | Section 2: Data (Census/BLS/Civics) |  |  |  | Planned | County + ZIP metrics + caching + explainers |
| 6 | Section 3: What We Do Now |  |  |  | Planned | Talking points + congressional actions + citizen actions |
| 7 | Section 4: Teams + power building |  |  |  | Planned | Local team pages + membership + roles + actions |
| 8 | Polish + accessibility + launch hardening |  |  |  | Planned | A11y, perf, security, content QA, launch |

---

## 1) North Star: What this site must do to move people

The site is designed as a transformation funnel:

1) **Recognition** — “They heard us.”  
2) **Legibility** — “I understand what’s happening here.”  
3) **Agency** — “I know what I can do next.”  
4) **Belonging** — “I’m not alone; there’s a team here.”

**Design principle:** *Clean by default. Deep by choice.*  
Avoid busy pages. Prefer drill-down routes, expandable sections, tooltips, and guided trails.

**Editorial principle:** Community voice first, data second, action third, organizing fourth.

---

## 2) Public Product Structure (4 Sections)

### Section 1 — What We Heard (Trust Engine)
**Goal:** show communities we listened and can reflect their reality back clearly.  
**Includes:**
- County-by-county narrative, themes, quotes, photos
- Trust markers on every county page (when/where/how heard)
- Issue drilldowns and “deep dive” topic pages (multi-layer)

### Section 2 — What the Data Says (Credibility + Clarity)
**Goal:** make the underlying reality legible without overwhelming.  
**Includes:**
- County + ZIP snapshots powered by Census/BLS/Google Civics
- Charts + plain-language interpretations
- Transparent sources + last updated timestamps
- AI summaries grounded in data + session notes (with citations)

### Section 3 — What We Do Now (Momentum)
**Goal:** convert insight into movement.  
**Includes:**
- Talking points localized to county realities (campaign messaging)
- Congressional action options (policy + oversight + coalition)
- Citizen actions (local steps + volunteer pathways)

### Section 4 — Collective Action / Teams (Infrastructure)
**Goal:** build durable local power.  
**Includes:**
- Power Teams by county/community
- Team landing pages, roles, membership (privacy-aware)
- Organizing artifacts: meeting notes templates, action trackers
- Training tracks (future module expansion)

---

## 3) Site Psychology & UX System (Consistency Contracts)

### 3.1 Page Experience Rules (non-negotiable)
Every public page must have:
- One clear H1
- One-sentence subhead
- One primary next-step CTA
- Breadcrumbs for drilldowns
- Expandable sections for depth
- Hover glossary tooltips for unfamiliar terms
- “Trust markers” where claims are made (sources, dates, method)

### 3.2 Busy-Page Prevention System
If content becomes deep, it becomes:
- another route, or
- an expandable section  
**Never** a long unstructured wall of text.

### 3.3 Drilldown Trail
All drilldowns must provide:
- Breadcrumbs
- “Next / Previous” for guided reading
- Shareable permalinks for charts and deep-dive views

### 3.4 Plain-Language Toggle (Phase 5+)
A global toggle that:
- simplifies explanations
- reduces jargon
- keeps the same facts

---

## 4) Architecture (High Level)

### 4.1 Stack (locked)
- Frontend: **Next.js (App Router) + TypeScript**
- UI: **TailwindCSS + shadcn/ui**
- Charts: **Recharts**
- Deploy: **Netlify**
- Functions: **Netlify Functions (TypeScript)**
- Database: **Neon Postgres**
- ORM: **Prisma** (schema-first, migrations tracked)

### 4.2 Two-Zone Data Security Model (locked)
**Public Zone (safe):**
- Blueprint content
- Aggregated public datasets
- Glossary and educational materials

**Private Zone (restricted):**
- Arkansas voter file (VR/VH/VRVH)
- Any PII, contact info, segmentation, targeting workflows
- Access only via admin routes + role enforcement
- Never exposed through public APIs/routes

### 4.3 Security Requirements
- Public pages/APIs cannot access private tables, ever
- Admin routes require authentication + role checks (Phase 4+ hardening)
- All AI runs logged; all data-summaries cite sources (Phase 4)
- No PII stored in client-side state
- Audit logging for private voter module actions

---

## 5) Data Domains & Core Entities (Phase 2: canonical)

### 5.1 Public Content (narrative layer)
- `County`
- `Issue`
- `CountyIssue`
- `BlueprintSection` (markdown)
- `Quote` (privacy-aware community voice)
- `Asset` (photos/docs; no secrets)
- `GlossaryTerm`
- `SourceDocument` + `SourceDocumentLink`

### 5.2 Public Data (metrics layer)
- `CensusMetric` (county + zip)
- `BLSMetric` (county)
- `CivicsOfficial` (district/county; elected officials)
- `Election` + `ElectionResult` (aggregates)
- geo tables + crosswalks (Phase 5)

### 5.3 AI Layer (first-class, grounded, versioned)
- `AIPrompt` (versioned)
- `AIRun` (inputs + provenance)
- `AIOutput` (draft/reviewed/published)
- `AIOutputScope` (county/issue/zip scoping)
- `SourceChunk` + `Citation`

### 5.4 Private Voter File (PII)
- `VoterRegistration` (VR)
- `VoteHistory` (VH)
- `ImportJob`
- `Segment`
- `AuditLog`

---

## 6) Route Map (Public + Admin)

### 6.1 Public Routes (core)
- `/blueprint` (county index + top themes across AR-02)
- `/blueprint/[county]` (county home: what we heard + snapshot scaffold)
- `/blueprint/[county]/issues`
- `/blueprint/[county]/issues/[issue]`
- `/blueprint/[county]/issues/[issue]/deep-dive`
- `/blueprint/[county]/issues/[issue]/deep-dive/[topic]`
- `/blueprint/[county]/data` (Phase 5)
- `/blueprint/[county]/data/[zip]` (Phase 5)
- `/blueprint/[county]/actions` (Phase 6)
- `/blueprint/[county]/actions/[issue]` (Phase 6)
- `/blueprint/[county]/teams` (Phase 7)
- `/blueprint/[county]/teams/[team]` (Phase 7)
- `/insights` (curated index; Phase 4+)
- `/insights/[scope]/[id]` (Phase 4+)
- `/glossary` + `/glossary/[term]`
- `/methodology` + `/sources` + `/privacy` + `/terms` + `/about`

### 6.2 Admin Routes (internal; scaffold now, enforce later)
- `/admin` (dashboard)
- `/admin/auth`
- `/admin/content/*`
- `/admin/ai/*`
- `/admin/data/*`
- `/admin/voters-private/*` (locked; private zone)

---

## 7) Phase Closure Rules (NON-NEGOTIABLE)

### 7.1 Phase end checklist
Each phase ends only when ALL are true:
1) `git status` is clean  
2) Commit created with phase message format  
3) Pushed to GitHub  
4) Zip artifact created from the pushed commit  
5) Phase Log updated (End, Duration, Status, Notes)

### 7.2 Commit message format
`Phase X / Module X.Y: <short summary>`

### 7.3 Zip artifact rule
Preferred:
- `git archive --format=zip --output blueprints_phaseX_YYYYMMDD_HHMM.zip HEAD`

---

## 8) Phase 3 — Section 1 MVP (“What We Heard”) (EXECUTION PLAN)

**Phase 3 Start:** Tuesday, Jan 27, 2026 — 8:30 PM (America/Chicago)  
**Goal:** Ship Section 1 MVP public experience: `/blueprint` index + `/blueprint/[county]` county page with “What We Heard” narrative, quotes, photo strip, trust markers, and a lightweight “snapshot scaffold” panel.

### 8.0 Phase 3 entry gate (must be true before writing new Phase 3 code)
- Phase 2 is committed + pushed
- Phase 2 zip generated from the pushed commit
- `master_build.md` reflects Phase 2 completion + Phase 3 start (this file)

> If Phase 2 is validated but still uncommitted locally, do a single closure commit:
> `Phase 2 / Module 2.1: schemas, contracts, RLS, indexes (validated on Neon)`

---

## 9) Phase 3 Modules (10–15 files each)

### Module 3.1 — Public Site Foundations (layout + nav + page contracts)
**Purpose:** establish a clean, consistent UI frame so every page follows the “one H1 / one CTA / breadcrumbs / depth via accordions” contract.

**Files (target 10–15):**
1) `apps/public_site/app/layout.tsx` (real layout; metadata; global shell)
2) `apps/public_site/app/page.tsx` (home stub that points to Blueprint)
3) `apps/public_site/components/site/Header.tsx`
4) `apps/public_site/components/site/Footer.tsx`
5) `apps/public_site/components/site/Breadcrumbs.tsx`
6) `apps/public_site/components/site/PageHeader.tsx` (H1 + subhead + CTA)
7) `apps/public_site/components/site/SectionCard.tsx`
8) `apps/public_site/components/site/TrustMarkers.tsx` (UI pattern only; data later)
9) `apps/public_site/components/site/PlainLanguageToggle.tsx` (stub; disabled until Phase 5)
10) `apps/public_site/lib/routes.ts` (route helpers)
11) `apps/public_site/styles/globals.css` (confirm Tailwind pipeline)
12) `apps/public_site/tests/smoke/public_routes.test.ts` (basic render smoke)

**Micro-steps (locked order):**
1) Implement `PageHeader` contract (H1, subhead, CTA)
2) Implement `Breadcrumbs` contract (stable + accessible)
3) Implement `TrustMarkers` UI component (date/location/method/source)
4) Wire `layout.tsx` to use Header/Footer
5) Ensure routes compile and dev server runs

**DoD:**
- `npm run dev` renders home and blueprint route without crashing
- All components are accessible baseline (semantic headings, nav landmarks)
- No DB dependency yet

**Commit:**
`Phase 3 / Module 3.1: public shell, breadcrumbs, page header, trust marker UI`

---

### Module 3.2 — Server Data Access (public schema only; read-only)
**Purpose:** create a safe, minimal Prisma access layer for public pages (NO private schema access, no mutation).

**Files (target 10–15):**
1) `apps/public_site/lib/db/prisma.ts` (Prisma singleton)
2) `apps/public_site/lib/db/public.ts` (read-only query functions)
3) `apps/public_site/lib/types/public.ts` (view models)
4) `apps/public_site/lib/validators/slug.ts`
5) `apps/public_site/lib/cache.ts` (simple memoization wrapper; optional)
6) `apps/public_site/app/(public)/blueprint/loading.tsx`
7) `apps/public_site/app/(public)/blueprint/[county]/loading.tsx`
8) `apps/public_site/tests/db/public_queries.test.ts`
9) `docs/dev/public_site_dev.md` (how to run + env expectations)
10) `ops/runbooks/public_readonly_rules.md` (hard rule: never query private schema here)

**Micro-steps (locked order):**
1) Create `prisma.ts` singleton (server-only)
2) Implement `getCounties()`, `getCountyBySlug()`
3) Implement `getFeaturedIssuesForCounty()`, `getBlueprintSectionsForCounty()`, `getQuotesForCounty()`, `getAssetsForCounty()`
4) Add guards: if any query tries to touch private schema → fail build (code-level convention + review gate)
5) Add tests (basic)

**DoD:**
- County list and county detail queries run in dev
- No writes, no private access
- Tests pass

**Commit:**
`Phase 3 / Module 3.2: prisma public read layer (counties, issues, sections, quotes, assets)`

---

### Module 3.3 — `/blueprint` Index MVP (County cards + trust posture)
**Purpose:** deliver the first public “What We Heard” entry point.

**Files (target 10–15):**
1) `apps/public_site/app/(public)/blueprint/page.tsx`
2) `apps/public_site/components/blueprint/CountyCard.tsx`
3) `apps/public_site/components/blueprint/CountyGrid.tsx`
4) `apps/public_site/components/blueprint/TopThemesBar.tsx` (scaffold; counts later)
5) `apps/public_site/components/blueprint/BlueprintIntro.tsx`
6) `apps/public_site/components/blueprint/TrustPostureCallout.tsx`
7) `apps/public_site/components/blueprint/BlueprintNav.tsx`
8) `apps/public_site/lib/viewmodels/blueprintIndex.ts`
9) `apps/public_site/tests/ui/blueprint_index.test.ts`

**Micro-steps (locked order):**
1) Render counties from DB via Module 3.2 queries
2) County cards link to `/blueprint/[county]`
3) Show “methodology/trust posture” callout linking `/methodology` + `/sources`
4) Add breadcrumbs + PageHeader contract

**DoD:**
- `/blueprint` loads and shows all active counties
- Click-through works
- No empty-page UX

**Commit:**
`Phase 3 / Module 3.3: blueprint index MVP (county grid + trust posture)`

---

### Module 3.4 — `/blueprint/[county]` County Page MVP (“What We Heard”)
**Purpose:** the core trust engine page per county.

**Files (target 10–15):**
1) `apps/public_site/app/(public)/blueprint/[county]/page.tsx`
2) `apps/public_site/components/blueprint/CountyHeader.tsx`
3) `apps/public_site/components/blueprint/CountySnapshotScaffold.tsx` (placeholder until Phase 5)
4) `apps/public_site/components/blueprint/WhatWeHeardSection.tsx` (from BlueprintSections)
5) `apps/public_site/components/blueprint/QuoteCarousel.tsx` (simple; accessible)
6) `apps/public_site/components/blueprint/PhotoStrip.tsx`
7) `apps/public_site/components/blueprint/IssueChips.tsx` (links to issues route; scaffold)
8) `apps/public_site/lib/viewmodels/countyPage.ts`
9) `apps/public_site/app/(public)/blueprint/[county]/not-found.tsx`
10) `apps/public_site/tests/ui/county_page.test.ts`

**Micro-steps (locked order):**
1) Load county by slug; 404 on miss
2) Render PageHeader + breadcrumbs
3) Render “What We Heard” section (markdown from BlueprintSections)
4) Render Quotes + Photos (if none, show “coming soon” with trust posture)
5) Render TrustMarkers block (date/location/method/source note placeholders until ingest)

**DoD:**
- County page loads for valid slug
- Shows narrative content if present
- Graceful empty states for missing quotes/assets/sections
- Trust marker UX is present even if content incomplete

**Commit:**
`Phase 3 / Module 3.4: county page MVP (what we heard + quotes + photos + trust markers)`

---

### Module 3.5 — Minimal Issue Surfacing (scaffold routes, no deep content yet)
**Purpose:** prevent dead-end nav; make “issues” feel real without building deep-dive yet.

**Files (target 10–15):**
1) `apps/public_site/app/(public)/blueprint/[county]/issues/page.tsx`
2) `apps/public_site/app/(public)/blueprint/[county]/issues/[issue]/page.tsx`
3) `apps/public_site/components/issues/IssueList.tsx`
4) `apps/public_site/components/issues/IssueSummary.tsx`
5) `apps/public_site/lib/viewmodels/issues.ts`
6) `apps/public_site/tests/ui/issues_routes.test.ts`

**DoD:**
- Issue list loads from CountyIssue join
- Issue page shows summary + placeholder sections

**Commit:**
`Phase 3 / Module 3.5: issue routes scaffold (county issues list + issue page)`

---

## 10) Phase 3 Definition of Done (MVP ship bar)

Phase 3 is complete when:
- `/blueprint` works end-to-end
- `/blueprint/[county]` works end-to-end
- Trust marker UI exists and is consistently displayed
- Empty states are humane (no blank pages)
- No schema changes were required
- Phase 3 ends with commit + push + Phase 3 zip
- Phase Log updated with End time + duration

---

## 11) Immediate Commands (operator checklist)

### If Phase 2 still needs closure in Git
Run in repo root:

1) `git status`
2) `git add -A`
3) `git commit -m "Phase 2 / Module 2.1: schemas, contracts, RLS, indexes (validated on Neon)"`
4) `git push`
5) `git archive --format=zip --output blueprints_phase2_20260127_XXXX.zip HEAD`

### Start Phase 3 work
1) Create Module 3.1 files
2) `git add -A`
3) `git commit -m "Phase 3 / Module 3.1: public shell, breadcrumbs, page header, trust marker UI"`
4) `git push`

---

## 12) Agreement Lock
Unless vetoed by owner, this spec governs all builds.
