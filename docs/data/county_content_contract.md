# County Content Contract (Public Narrative Layer)

**Project:** BLUEPRINTS (AR-02)  
**Phase:** 2 — Database + Contracts  
**Purpose:** Define the canonical structure for county narrative content (“What We Heard”) and how it is safely stored, cited, and published.

This contract governs **public-safe** content only.  
**No PII** is permitted in this layer.

---

## 1) Why this contract exists

The “What We Heard” section is the trust engine of this product. If content is captured inconsistently (random docs, random notes, random formats), you cannot:

- compare counties reliably
- generate grounded AI briefs safely
- attach trust markers consistently
- scale the system to other districts later

This contract ensures:

- content is standardized
- provenance is trackable
- community voice is safe and respectful
- AI generation can be RAG-first and citation-backed

---

## 2) Scope

This contract governs the following **public schema** entities:

- `counties`
- `issues`
- `county_issues`
- `blueprint_sections`
- `quotes`
- `assets`
- `source_documents`
- `source_chunks`
- `source_document_links`

It also governs how narrative content is used to generate AI outputs (stored separately in AI tables).

---

## 3) Core concepts

### 3.1 County
A county is the primary geographic and community unit of narrative.  
Every public “What We Heard” page is ultimately county-scoped.

**Canonical fields (public.counties):**
- `name`
- `slug` (URL safe, stable)
- `fips_code` (optional; stable identifier)
- `is_active`

### 3.2 Issue
An issue is a named theme bucket used to organize narrative, quotes, and actions.

**Canonical fields (public.issues):**
- `name`
- `slug`
- `summary` (optional)
- `is_active`

### 3.3 Trust markers (provenance)
“Trust markers” are the public-facing proof of how we know what we claim:
- when/where/how a theme was heard
- which documents support it
- which sessions or sources are attached

Trust markers are stored using:
- `source_documents`
- `source_document_links`
- optional chunking via `source_chunks` for AI grounding

---

## 4) Data objects and requirements

### 4.1 Blueprint Section (public.blueprint_sections)
A blueprint section is a **publishable content block** displayed on county or issue pages.

**Required:**
- `slug` (unique, stable)
- `title`
- `body_md` (markdown)

**Optional scope:**
- `county_id` (if county-specific)
- `issue_id` (if issue-specific)
- `sort_order` (for ordered display)
- `is_pinned` (feature at top)

**Rules:**
- A section may be scoped to county, issue, or both.
- A section may be global (no county/issue) only when explicitly intended (methodology, etc.).
- Any factual claim should either:
  - have a `source_document_link` trust marker, or
  - be generated from a public dataset (Phase 5+).

### 4.2 Quote (public.quotes)
A quote represents community voice. Quotes must be **privacy-aware**.

**Required:**
- `text`
- `county_id`

**Optional:**
- `issue_id`
- `attribution_label` (example: “Listening session attendee”, “Local parent”, “Small business owner”)
- `source_note` (public-safe, non-identifying context)

**Hard privacy rules:**
- No names of private citizens unless you have explicit written permission and it is intentional.
- No phone numbers, emails, addresses, DOBs, employer identifiers, or anything that can identify a person.
- No “unique identifiers” that would enable doxxing (“the only dentist in town”, “the teacher at X school”) unless permission is documented and it is strategically necessary.

**Quote integrity rules:**
- Quotes should be verbatim when possible.
- If paraphrased, label as paraphrase in `source_note`.
- Quotes may be linked to a `source_document` via `source_document_links` to show provenance.

### 4.3 Asset (public.assets)
Assets include photos, documents, and public-safe media.

**Required:**
- `asset_type` (photo/document/audio/video/other)

**Optional:**
- `title`, `caption`, `credit`, `license`
- `url` OR `storage_key`
- `county_id`, `issue_id`

**Rules:**
- Never store sensitive media in public assets.
- Public assets must be publishable and non-PII.

### 4.4 Source Document (public.source_documents)
A source document is a public-safe reference artifact:
- meeting notes (redacted)
- agendas/minutes
- public reports
- public websites
- recordings **only if they are public-safe and intentionally published**

**Required:**
- `title`

**Optional:**
- `url` and/or `storage_key`
- `publisher`
- `published_at`, `captured_at`
- `method_note` (how obtained / why trusted)

**Rules:**
- Source documents should be redacted before entering the public zone if needed.
- Any doc containing PII must NOT be stored here; it belongs in private systems, not this DB.

### 4.5 Source Chunk (public.source_chunks)
Chunks exist to support RAG-first AI grounding.

**Required:**
- `source_document_id`
- `chunk_index`
- `content`
- `content_hash`

**Optional:**
- `locator_json` (page numbers, timestamps, offsets)

**Rules:**
- Chunks should be stable and reproducible from the source document.
- The chunk store is optimized for citations, not for public display.

### 4.6 Source Document Link (public.source_document_links)
This is the trust marker link table. It connects a source to a public entity.

**Required:**
- `source_document_id`

**Optional link targets:**
- `county_id`
- `issue_id`
- `blueprint_section_id`
- `quote_id`
- `asset_id`
- `survey_form_id`

**Rules:**
- Use links to show “why we believe this section/quote exists.”
- Add `note` when helpful (e.g., “White County Listening Session — 2026-01-10”).

---

## 5) Publishing rules

### 5.1 Public pages must be defensible
Any county page claim should be supported by:
- a linked `source_document` (trust marker), OR
- a public dataset (Phase 5), OR
- explicit editorial framing (“We heard many people say…” with linked sessions)

### 5.2 “Community leaders” rule
Community leaders must never be AI-invented. Names can come only from:
- verified elected official sources (Google Civics), or
- user-curated editorial datasets.

---

## 6) How this contract enables AI safely

This structure supports AI generation by allowing:

- retrieval of relevant `source_chunks` linked to counties/issues/sections
- storage of AI outputs with citations (Phase 2 AI tables)
- review before publication (draft/reviewed/published)

**AI may summarize**, but may not invent facts.  
Any data claim must cite chunk/document sources.

---

## 7) Minimal ingestion workflow (v1)

1) Create/confirm counties + issues
2) Attach county↔issue relationships (featured/order)
3) Import narrative sections (markdown)
4) Add quotes (privacy-safe)
5) Upload/link assets (public-safe)
6) Register source docs and links (trust markers)
7) (Later) chunk sources for AI grounding

---

## 8) Validation checklist

Before publishing a county page:
- County exists and slug is correct
- Sections are scoped correctly
- Quotes contain no PII
- Trust markers exist for major claims
- Assets are licensed/credited where needed
- If AI content is used: it is published-only and citation-backed

---

## 9) Contract versioning

This contract may evolve, but only via new modules after Phase 2.  
All changes must be logged in a new ADR if they affect governance or privacy boundaries.
