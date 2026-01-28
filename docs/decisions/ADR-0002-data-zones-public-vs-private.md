# ADR-0002: Public vs Private Data Zones

**Status:** Accepted  
**Date:** 2026-01-27  
**Decision Owner:** BLUEPRINTS Architecture

---

## Context

The BLUEPRINTS platform handles two fundamentally different classes of data:

1. **Public narrative and educational content**
   - County stories
   - Community themes
   - Quotes (privacy-safe)
   - Public datasets (Census, BLS, elections)
   - AI-generated summaries and briefs

2. **Private campaign data**
   - Voter registration records
   - Vote history
   - Segmentation and targeting
   - Import metadata
   - Audit logs

These data classes carry radically different legal, ethical, and operational risk profiles.

Mixing them within a single unrestricted data layer increases the probability of:
- accidental exposure
- unauthorized inference
- AI misuse
- regulatory or reputational harm

---

## Decision

The system SHALL enforce a **hard separation** between public and private data using **database-level boundaries**, not application convention.

### 1) Two-zone architecture

- All public-safe content and aggregates live in the `public` schema.
- All PII and voter-related data live in the `private` schema.

No table containing PII exists in the `public` schema.

---

### 2) Database-enforced isolation

- Row Level Security (RLS) is enabled and **forced** on all `private.*` tables.
- Default policy for private tables is **deny all access**.
- Access is granted only when a session explicitly declares itself as a trusted service context.

This ensures that:
- application bugs cannot bypass the boundary
- accidental queries return zero rows
- schema ownership alone is insufficient to bypass restrictions

---

### 3) AI isolation rules

- AI systems may consume data only from the `public` schema.
- Private voter data is **never** used as an AI input for public-facing content.
- AI outputs are stored in public tables but must cite public-safe sources only.

---

### 4) Deployment model alignment

Each campaign deployment (e.g., AR-02, AR-01, Senate) is a **standalone application instance** with:
- its own database
- its own environment variables
- its own access credentials

There is no cross-campaign data sharing.

---

## Consequences

### Positive
- Strong security guarantees
- Clear privacy boundaries
- Easier compliance and auditability
- Safer AI usage
- Clean sales story: “your data never mixes”

### Trade-offs
- Slightly more upfront schema complexity
- Requires intentional workflows when using private data (admin-only)
- Analytics must be explicitly designed to use public-safe aggregates

These trade-offs are accepted in favor of safety and trust.

---

## Alternatives considered

### Alternative: Application-only separation
Rejected because:
- relies on developer discipline
- fails under pressure or deadlines
- does not protect against misconfiguration

### Alternative: Mixed schema with column-level flags
Rejected because:
- complex to reason about
- easy to misuse
- hard to enforce consistently

---

## Notes

This decision is foundational and must not be bypassed.

Any future feature that proposes mixing public and private data must:
- introduce a new ADR
- undergo explicit review
- justify why existing protections are insufficient

Absent such approval, this decision governs all data handling.
