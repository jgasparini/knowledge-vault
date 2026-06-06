---
name: wiki-consolidate
description: >
  Semantic review of the wiki. Triggers when the user says "consolidate the wiki",
  "run a consolidation", "consolidation pass", "review the wiki for drift", or
  "cleanup pass".
  Runs three checks: deduplication candidates (pages covering the same ground),
  lifecycle promotions (status changes that are overdue), and synthesis opportunities
  (concepts ready for a new hub or cross-reference).
  Produces a proposal report — nothing is changed without explicit user confirmation.
  Complements wiki-lint (structural checks) with semantic review. Run every 30–50
  ingests, or whenever the wiki feels like it's drifting semantically.
---

# Wiki Consolidate

## Before you start

Read `meta/CLAUDE.md` in full. Pay attention to:
- Section 2: vault structure and folder layout
- Section 3: page types and status values (`stub` → `active` → `evergreen` → `archived`)

Today's date is needed for the report header and CHANGELOG entry.

---

## Establish scope

- **Project-scoped** (default): "consolidate [project name]". Check pages within that
  project plus any concepts or entities it references.
- **Global**: "consolidate all" or "full consolidation". All pages across all projects.

---

## Check 1 — Deduplication candidates

Read all concept and entity pages within scope. Compare for substantial overlap: pages
that describe the same tool under two names, two concepts that are really one idea, or
entity pages that cover the same thing from different angles.

For each candidate pair:
1. Name both pages with wikilinks
2. Quote the overlapping claim (one sentence from each page)
3. Propose a merge direction — which page survives, which becomes a redirect stub

Do not merge anything without explicit user confirmation.

---

## Check 2 — Lifecycle promotions

Review all pages within scope against their current `status:` value in frontmatter.
Check the `updated:` and `created:` dates against today's date.

Three types of proposal:

**stub → active:** pages with `status: stub` that now have 2 or more entries in their
`sources:` frontmatter field. These have enough material to warrant expansion.

**active → evergreen:** pages with `status: active` that have not needed updating in
60 or more days and reference 4 or more sources. These are mature and stable.

**Archive candidates:** pages with `status: active` or `status: stub` that have no
source references and have not been updated in 90 or more days. Flag — do not archive
without explicit instruction.

These thresholds are defaults. If `meta/CLAUDE.md` defines lifecycle thresholds explicitly, use those instead.

For each proposal: name the page, state the evidence (source count, days since last
update), propose the status change. Do not touch frontmatter until the user confirms.

---

## Check 3 — Synthesis opportunities

Scan source pages within scope for concepts or entities that appear together across
3 or more sources but have no connecting page or cross-reference between them.

For each opportunity:
1. Name the concepts or entities involved (with wikilinks)
2. List the sources where they appear together
3. Propose one of:
   - A new concept page linking them
   - A topic hub (requires explicit user confirmation per vault rules)
   - A wikilink added between their existing pages

Do not create anything without confirmation. Topic hub creation requires explicit
confirmation regardless of how clear the synthesis seems.

---

## Report format

Always produce the report in this exact format before asking for confirmation:

```
## Consolidation pass — YYYY-MM-DD [scope: project-name or global]

**Deduplication candidates:** [n] found
- [[page-a]] / [[page-b]] — overlap: "..."
  Proposed: [[page-a]] survives, [[page-b]] → redirect stub

**Lifecycle promotions:** [n] proposed
- [[page]] — stub → active (sources: [[s1]], [[s2]])
- [[page]] — active → evergreen (4 sources, stable 65 days)
- [[page]] — archive candidate (no sources, 94 days inactive)

**Synthesis opportunities:** [n] found
- [[concept-a]] + [[entity-b]] — co-appear in [[src-1]], [[src-2]], [[src-3]]
  Proposed: wikilink between existing pages
```

If a category is clean, write `[n] found` with n=0 — do not omit the category.

Present the report, then ask: "Which of these would you like to confirm?"

---

## After confirmation

For each approved item, apply the following:

**Deduplication merge:** fold the content of the retiring page into the surviving page using this approach:
- Merge sections by type: deepen definitions, add complementary examples, preserve both perspectives if claims conflict rather than silently dropping one
- Reconcile frontmatter: merge the `sources:` lists, set `updated:` to today's date, keep the higher status value
- Cross-reference any conflicting claims in both directions (do not resolve them — let them coexist)
Replace the retiring page's body with a one-line redirect (`See [[surviving-page]]`), set its `status: archived`, and update all inbound wikilinks to point to the surviving page.

**Status change:** update the `status:` field in frontmatter and set `updated:` to today's date.

**Synthesis — new concept page:** create using the schema from `meta/CLAUDE.md` Section 3.2.
Ensure the new page has at least two inbound wikilinks before finishing.

**Synthesis — wikilink:** add the link in both pages under the section defined for that page type in `meta/CLAUDE.md` Section 3 (concepts use `## How it connects`, entities use `## Connections`). If the section is missing from a page, create it.

**Registry updates:** After applying any approved changes, update the following files:
- Remove any merged/archived pages from the relevant `INDEX.md` entries, or note them as redirects
- If a new concept page was created, add it to the project `INDEX.md` and root `wiki/INDEX.md` per the ingest rules
- Update `meta/health.md`: set `last-consolidation` to today's date

Append one entry to `CHANGELOG.md` (newest first):

```
## YYYY-MM-DD — Consolidation pass [scope]
- Duplicates merged: [n or "none"]
- Status changes: [list or "none"]
- Synthesis actions: [n or "none"]
```

If all three checks find zero items, still append the CHANGELOG entry with all fields set to "none", and state clearly in the report: "Wiki is semantically clean as of YYYY-MM-DD — no action needed."

---

## Hard rules

- Nothing is changed without explicit user confirmation per proposal.
- Never create a Topic hub without explicit confirmation — this is a vault-wide rule.
- Never archive a page without explicit instruction.
- Consolidate is a recommendation engine, not an auto-fixer.
- This skill does not replace wiki-lint — run lint for structural checks, consolidate
  for semantic review.

---

## Portability note

This skill is pure LLM judgment — it has no shell scripts. All checks require reading page content and applying semantic reasoning. It reads the vault schema from `meta/CLAUDE.md` at runtime and does not hardcode page types, status values, or folder paths. If the schema changes, this skill adapts automatically.
