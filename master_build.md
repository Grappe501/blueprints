BLUEPRINTS — Master Build (Authoritative)

Project: AR-02 Blueprint Sessions Public Database + Action Platform
Owner: Chris Jones for Congress (Blueprints)
Build Pilot: ChatGPT (Architecture + Module Control)

Repository: https://github.com/Grappe501/blueprints

Local Root: C:\Users\User\Desktop\Blueprints

0) Current Status (Live)
Build Clock & Productivity Tracking

Global Start: Tuesday, Jan 27, 2026 — 11:00 AM (America/Chicago)

Rule: Update this file after every phase. No exceptions.
Rule: Every phase ends with a commit + push + zip. No exceptions.
Rule: No schema churn unless explicitly approved.

Phase Log
Phase	Goal	Start	End	Duration	Status	Notes
1	Universe skeleton + master spec	2026-01-27 11:00	2026-01-27 11:45	45m	Complete	Skeleton created; repo structure + module system established
2	DB schemas + ingestion contracts	2026-01-27 11:45	2026-01-27 18:20	~6h 35m	Complete (validated)	Prisma compiles; public/private schemas exist; RLS enforced + verified; indexes applied; .env configured + tested against Neon
3	Section 1: “What We Heard” MVP	2026-01-27 20:30			In Progress	Frontend scaffolding + route stability fixes complete; DB read layer still pending
1) North Star: What this site must do to move people

The site is designed as a transformation funnel:

Recognition — “They heard us.”

Legibility — “I understand what’s happening here.”

Agency — “I know what I can do next.”

Belonging — “I’m not alone; there’s a team here.”

Design principle: Clean by default. Deep by choice.
Avoid busy pages. Prefer drill-down routes, expandable sections, tooltips, and guided trails.

Editorial principle: Community voice first, data second, action third, organizing fourth.

2) Public Product Structure (4 Sections)
Section 1 — What We Heard (Trust Engine)

Goal: show communities we listened and can reflect their reality back clearly.
Includes:

County-by-county narrative, themes, quotes, photos

Trust markers on every county page (when/where/how heard)

Issue drilldowns and “deep dive” topic pages (multi-layer)

Section 2 — What the Data Says (Credibility + Clarity)

Goal: make the underlying reality legible without overwhelming.
Includes:

County + ZIP snapshots powered by Census/BLS/Google Civics

Charts + plain-language interpretations

Transparent sources + last updated timestamps

AI summaries grounded in data + session notes (with citations)

Section 3 — What We Do Now (Momentum)

Goal: convert insight into movement.
Includes:

Talking points localized to county realities (campaign messaging)

Congressional action options (policy + oversight + coalition)

Citizen actions (local steps + volunteer pathways)

Section 4 — Collective Action / Teams (Infrastructure)

Goal: build durable local power.
Includes:

Power Teams by county/community

Team landing pages, roles, membership (privacy-aware)

Organizing artifacts: meeting notes templates, action trackers

Training tracks (future module expansion)

3) Site Psychology & UX System (Consistency Contracts)
3.1 Page Experience Rules (non-negotiable)

Every public page must have:

One clear H1

One-sentence subhead

One primary next-step CTA

Breadcrumbs for drilldowns

Expandable sections for depth

Hover glossary tooltips for unfamiliar terms

“Trust markers” where claims are made (sources, dates, method)

3.2 Busy-Page Prevention System

If content becomes deep, it becomes:

another route, or

an expandable section
Never a long unstructured wall of text.

3.3 Drilldown Trail

All drilldowns must provide:

Breadcrumbs

“Next / Previous” for guided reading

Shareable permalinks for charts and deep-dive views

3.4 Plain-Language Toggle (Phase 5+)

A global toggle that:

simplifies explanations

reduces jargon

keeps the same facts

4) Architecture (High Level)
4.1 Stack (locked)

Frontend: Next.js (App Router) + TypeScript

UI: TailwindCSS + shadcn/ui

Charts: Recharts

Deploy: Netlify

Functions: Netlify Functions (TypeScript)

Database: Neon Postgres

ORM: Prisma (schema-first, migrations tracked)

4.2 Two-Zone Data Security Model (locked)

Public Zone (safe):

Blueprint content

Aggregated public datasets

Glossary and educational materials

Private Zone (restricted):

Arkansas voter file (VR/VH/VRVH)

Any PII, contact info, segmentation, targeting workflows

Access only via admin routes + role enforcement

Never exposed through public APIs/routes

4.3 Security Requirements

Public pages/APIs cannot access private tables, ever

Admin routes require authentication + role checks (Phase 4+)

All AI runs logged; all data-summaries cite sources (Phase 4)

No PII stored in client-side state

Audit logging for private voter module actions

5) Data Domains & Core Entities (Phase 2: canonical)
5.1 Public Content (narrative layer)

County

Issue

CountyIssue

BlueprintSection (markdown)

Quote (privacy-aware community voice)

Asset (photos/docs; no secrets)

GlossaryTerm

SourceDocument + SourceDocumentLink

5.2 Public Data (metrics layer)

CensusMetric (county + zip)

BLSMetric (county)

CivicsOfficial (district/county)

Election + ElectionResult

geo tables + crosswalks (Phase 5)

5.3 AI Layer (first-class, grounded, versioned)

AIPrompt

AIRun

AIOutput

AIOutputScope

SourceChunk + Citation

5.4 Private Voter File (PII)

VoterRegistration

VoteHistory

ImportJob

Segment

AuditLog

6) Route Map (Public + Admin)
6.1 Public Routes

/blueprint

/blueprint/[county]

/blueprint/[county]/issues

/blueprint/[county]/issues/[issue]

/blueprint/[county]/issues/[issue]/deep-dive

/blueprint/[county]/issues/[issue]/deep-dive/[topic]

/blueprint/[county]/data (Phase 5)

/blueprint/[county]/data/[zip] (Phase 5)

/blueprint/[county]/actions (Phase 6)

/blueprint/[county]/actions/[issue] (Phase 6)

/blueprint/[county]/teams (Phase 7)

/blueprint/[county]/teams/[team] (Phase 7)

/insights

/insights/[scope]/[id]

/glossary + /glossary/[term]

/methodology + /sources + /privacy + /terms + /about

6.2 Admin Routes

/admin

/admin/auth

/admin/content/*

/admin/ai/*

/admin/data/*

/admin/voters-private/*

7) Phase Closure Rules (NON-NEGOTIABLE)
7.1 Phase end checklist

Each phase ends only when ALL are true:

git status is clean

Commit created with phase message format

Pushed to GitHub

Zip artifact created from pushed commit

Phase Log updated

7.2 Commit message format

Phase X / Module X.Y: <short summary>

7.3 Zip artifact rule

git archive --format=zip --output blueprints_phaseX_YYYYMMDD_HHMM.zip HEAD

8) Phase 3 — Section 1 MVP (“What We Heard”)

Phase 3 Start: Tuesday, Jan 27, 2026 — 8:30 PM
Goal: Ship /blueprint + /blueprint/[county] MVP with trust posture and humane empty states.

Phase 3 Truth (locked)

UI shell exists and renders

Routes are stable

County registry corrected to AR-02 core eight counties

Placeholder pages prevent routing crashes

Module 3.2 (DB read layer) is the next required step

9) Phase 3 Modules (locked execution order)
Module 3.1 — Public Site Foundations

Status: Complete

Module 3.2 — Server Data Access (public, read-only)

Status: Next required work
Commit:
Phase 3 / Module 3.2: prisma public read layer (counties, issues, sections, quotes, assets)

Module 3.3 — /blueprint Index MVP

Status: Partial; requires DB-backed counties

Module 3.4 — /blueprint/[county] County Page MVP

Status: Partial; requires DB-backed content

Module 3.5 — Minimal Issue Surfacing

Status: Scaffolded

10) Agreement Lock

Unless vetoed by the owner, this file governs all future builds.