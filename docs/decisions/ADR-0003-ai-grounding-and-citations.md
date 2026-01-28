# ADR-0003: AI Grounding and Citation Requirements

**Status:** Accepted  
**Date:** 2026-01-27  
**Decision Owner:** BLUEPRINTS Architecture

---

## Context

The BLUEPRINTS platform uses AI to assist in synthesizing large volumes of:
- community listening input
- public datasets
- policy-relevant information

Unconstrained AI generation introduces serious risks:
- factual inaccuracies
- uncitable claims
- loss of trust
- reputational harm to campaigns and candidates

Because BLUEPRINTS content is public-facing and persuasive, AI output must meet a higher standard than informal internal tooling.

---

## Decision

All AI-generated content in BLUEPRINTS SHALL be **grounded, cited, stored, and reviewed** prior to publication.

This decision applies to:
- county briefs
- issue briefs
- data summaries
- talking points
- action recommendations
- glossary drafts

---

## Requirements

### 1) Retrieval-first grounding (RAG)

AI generation must use **retrieval-augmented generation**:

- Input sources must be explicitly attached to each run.
- Allowed sources include:
  - registered public source documents
  - approved public datasets (e.g., Census, BLS)
  - explicitly labeled manual notes
- AI must not rely on unstated general knowledge to fill gaps.

---

### 2) Citation as a first-class artifact

- Citations are stored in the database.
- Citations link:
  - AI output sections
  - to source documents or document chunks
- Every factual or data-based section must have at least one citation.

Citations must be:
- public-safe
- traceable
- inspectable

---

### 3) Stored outputs only

- AI outputs are generated in batch or admin-triggered workflows.
- Outputs are stored in the database.
- Public pages read from stored outputs only.

Live, on-demand AI generation for public users is prohibited.

---

### 4) Review and publication control

- All AI outputs begin in `draft` status.
- Outputs must be reviewed by a human before publication.
- Only `published` outputs may appear on public pages.

Draft or unreviewed content must never be publicly visible by default.

---

### 5) Separation from private data

- AI systems must not consume private voter data for public outputs.
- Private data is never used to infer or describe individual behavior publicly.
- AI outputs must be explainable using public-safe sources only.

---

## Consequences

### Positive
- Higher credibility and trust
- Defensible content under scrutiny
- Reusable, versioned AI artifacts
- Reduced hallucination risk
- Clear governance for AI use

### Trade-offs
- Slower than ad-hoc AI usage
- Requires intentional data preparation
- Requires human review time

These trade-offs are accepted to protect trust and accuracy.

---

## Alternatives considered

### Alternative: Unrestricted AI with disclaimers
Rejected because:
- disclaimers do not prevent misinformation
- hallucinations still harm trust
- content becomes legally and ethically risky

### Alternative: AI only for internal drafts
Rejected because:
- does not scale
- duplicates effort
- prevents reuse of approved outputs

---

## Notes

This decision is foundational.

Any proposal to relax grounding or citation requirements must:
- introduce a new ADR
- document risk acceptance explicitly
- receive approval from system owners

Absent such approval, this decision governs all AI usage.
