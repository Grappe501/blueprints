# AI Output Contract (Governed, Grounded Content)

**Project:** BLUEPRINTS (AR-02)  
**Phase:** 2 — Database + Contracts  
**Purpose:** Define how AI-generated content is created, grounded, reviewed, stored, cited, and published as first-class public artifacts.

This contract ensures AI output is **defensible, auditable, and reusable** — not ephemeral chatbot text.

---

## 1) Core principles

1. **AI never publishes directly**
   - AI generates drafts only.
   - Humans approve publication.

2. **No uncited claims**
   - Any factual or data-based claim must cite a source document or dataset.

3. **Grounded by design**
   - AI outputs are generated using retrieval (RAG) from approved sources only.

4. **Stored, not streamed**
   - All AI outputs are persisted in the database.
   - Public pages read from the database, never directly from a model.

5. **Versioned and traceable**
   - Prompts, runs, and outputs are versioned and linked.

---

## 2) AI output lifecycle

### 2.1 Prompt definition (`ai_prompts`)
Prompts define *what kind* of output can be generated.

**Required fields:**
- `prompt_key` (stable identifier, e.g. `county_brief_v1`)
- `version` (integer)
- `name`
- `template` (prompt text)

**Rules:**
- Prompts are immutable once used in production.
- Changes require a new version number.
- Prompt intent must match output type (see section 3).

---

### 2.2 Run execution (`ai_runs`)
A run represents a single execution of a prompt.

**Tracks:**
- model name/version
- parameters
- status (`queued`, `running`, `succeeded`, `failed`)
- timestamps
- error text (if failed)
- input summary (human-readable)

**Rules:**
- Runs are append-only.
- Failed runs are never deleted.
- Runs must link to one or more input sources.

---

### 2.3 Input sources (`ai_run_input_sources`)
Each run records exactly *what information* it was allowed to use.

**Allowed input kinds:**
- `source_document`
- `dataset`
- `manual_note`
- `other` (explicitly labeled)

**Rules:**
- AI must not use unregistered sources.
- If a source is removed or corrected later, outputs can be re-reviewed or regenerated.

---

## 3) AI outputs (`ai_outputs`)

An AI output is a **publishable artifact**, not raw text.

**Required:**
- `run_id`
- `output_type`
- `content_md`
- `status` (`draft`, `reviewed`, `published`)

**Optional:**
- `title`
- `summary`
- `reviewed_at`
- `published_at`

**Rules:**
- All outputs start as `draft`.
- Only `published` outputs may appear on public pages.
- Outputs can be un-published (status reverted) without deleting history.

---

## 4) Structured outputs (`ai_output_sections`)

Long outputs should be broken into sections.

**Examples:**
- “What we heard”
- “Why this matters”
- “What changed recently”
- “Local implications”

**Rules:**
- Each section has a stable `section_key`.
- Sections can be reordered without regenerating content.
- Citations attach to sections, not entire outputs.

---

## 5) Scoping (`ai_output_scopes`)

Every AI output must declare *where it applies*.

**Allowed scope types:**
- `county`
- `issue`
- `zip`
- `district`
- `statewide`
- `custom`

**Rules:**
- Scopes control where outputs appear.
- An output may have multiple scopes (e.g., county + issue).
- Scoping is explicit — no “global by accident.”

---

## 6) Citations (`citations`)

Citations are the backbone of credibility.

**Required:**
- Link to an `ai_output_section`
- Link to either:
  - a `source_chunk`, or
  - a `source_document`

**Optional:**
- `label` (human-readable citation label)
- `locator_json` (page numbers, timestamps)

**Rules:**
- Every factual section should have at least one citation.
- Citations are visible or discoverable on public pages.
- Citations must resolve to public-safe sources.

---

## 7) Publishing rules

### 7.1 Review process (v1)
1. AI output is generated → `draft`
2. Human reviews content
3. If acceptable:
   - mark `reviewed`
   - then mark `published`
4. If unacceptable:
   - revise manually, or
   - regenerate with a new run

### 7.2 Corrections
- Published AI outputs may be corrected by:
  - editing sections (logged via updated_at), or
  - unpublishing and regenerating
- Corrections should preserve auditability.

---

## 8) Prohibited behaviors

AI outputs MUST NOT:
- invent community leaders
- invent statistics
- invent policy positions
- infer private voter behavior
- mix public and private data

Private voter data is **never** an AI input for public content.

---

## 9) Reuse and regeneration

AI outputs are reusable:
- across multiple pages
- across time (until data changes)
- across formats (page, PDF, briefing)

When underlying data updates:
- regenerate using a new run
- keep old outputs for historical comparison

---

## 10) Validation checklist (before publish)

Before publishing an AI output:
- Prompt version is correct
- Input sources are attached
- Claims have citations
- Scope is set correctly
- Status is `published`
- Output does not reference private data

---

## 11) Contract governance

This contract is binding for all AI-related work.

Changes require:
- a new ADR
- explicit acknowledgment of risk implications
- versioned prompt updates where applicable
