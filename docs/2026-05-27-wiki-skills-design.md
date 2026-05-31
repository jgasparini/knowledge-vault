# Wiki Skills Design — wiki-query and wiki-consolidate

**Date:** 2026-05-27  
**Status:** Approved  
**Scope:** Two new skills for the knowledge-vault wiki system

---

## Background

The vault has three existing skills: `wiki-setup`, `wiki-ingest`, and `wiki-lint`. Two gaps identified:

1. **No enforced query workflow.** The 5-step query process exists in `meta/CLAUDE.md` Section 4 but is not a skill, so it gets skipped. Queries are answered inline, nothing lands in `Outputs/`, and the token cost scales with vault size because there's no scoped-index-first step.

2. **No semantic review.** `wiki-lint` checks structural integrity (orphans, broken links, index drift) but can't detect duplicate pages, stale lifecycle status, or concepts that have grown rich enough to deserve a hub. That layer of review has no home.

---

## Skill 1: `wiki-query`

### Purpose

Enforce the query workflow so that every query: reads the minimum necessary context, lands in `Outputs/`, and feeds back into the wiki via gap analysis.

### Trigger phrases

"query the wiki", "what does the wiki say about X", "ask the wiki X", "search the wiki for X", or any question clearly directed at accumulated wiki knowledge rather than general knowledge.

### Steps

**Step 1 — Detect scope**  
Infer from the query whether it is project-scoped, area-scoped, resource-scoped, or cross-cutting. When ambiguous, ask rather than guess.

**Step 2 — Read scoped index first**  
- Project query → `wiki/projects/[name]/INDEX.md`  
- Area query → area index  
- Resource query → relevant section of `wiki/INDEX.md`  
- Cross-cutting → full `wiki/INDEX.md`  

Never read the full root index when a scoped index suffices.

**Step 3 — Read targeted pages**  
From the index, identify the 3–6 most relevant pages and read in full. Follow one hop to adjacent concepts if directly relevant. No broader reads.

**Step 4 — Synthesise and cite**  
Answer using the wiki as source of truth. Cite with `[[page-name]]`. Flag explicitly when drawing on general knowledge instead of wiki content.

**Step 5 — Write to scoped `Outputs/`**  
Dated markdown file in the closest scoped folder:
- Project query → `wiki/projects/[name]/Outputs/`
- Area query → `wiki/areas/[name]/Outputs/`
- Resource query → `wiki/resources/Outputs/`
- Cross-cutting → root `Outputs/`

Create the folder if it doesn't exist.

**Step 6 — Gap analysis + promotion**  
Two closing actions:
- **Gap analysis:** file any questions the wiki couldn't answer from its own pages to the relevant `QUESTIONS.md` (project, area, or root depending on scope).
- **Promotion proposal:** if the answer synthesises 3+ pages or surfaces a connection not previously captured, propose promoting the output to a wiki page. Never promote silently.

### Hard rules

- Never answer a query inline without writing to `Outputs/`.
- Never read the full root index when a scoped index suffices.
- Always flag explicitly when drawing on general knowledge.
- Never promote an output to a wiki page without explicit user confirmation.

---

## Skill 2: `wiki-consolidate`

### Purpose

Semantic review of the wiki: find duplicate pages, drive pages through their lifecycle, and surface concepts ready for a new hub or cross-reference. Produces a proposal report — nothing is changed without explicit user confirmation.

### Trigger phrases

"consolidate the wiki", "run a consolidation", "consolidation pass", "review the wiki for drift", "cleanup pass".

### Scope

Project-scoped by default ("consolidate [project name]"). Global with "consolidate all" or "full consolidation".

### Steps

**Before starting:** Read `meta/CLAUDE.md` for page types and status values.

**Check 1 — Deduplication candidates**  
Read all concept and entity pages within scope. Flag pairs that cover substantially the same ground — same tool under two names, two concepts that are really one idea. For each candidate pair:
- Name both pages
- Quote the overlapping claim
- Propose merge direction (which page survives, which becomes a redirect stub)

Nothing merged without explicit confirmation.

**Check 2 — Lifecycle promotions**  
Review all pages within scope against their current status:
- `stub` → `active`: pages with 2+ source references not yet promoted
- `active` → `evergreen`: pages not updated in 60+ days with 4+ sources (mature, stable)
- `active`/`stub` → archive candidate: no source references, not updated in 90+ days

For each proposal: name the page, state the evidence, propose the status change. User confirms before any frontmatter is touched.

**Check 3 — Synthesis opportunities**  
Scan for concepts or entities that appear together across 3+ sources but have no connecting topic hub, concept page, or cross-reference between them. Flag as candidates for:
- A new concept page
- A topic hub (requires explicit confirmation per vault rules)
- A missing wikilink

Propose only — do not create.

### Report format

```
## Consolidation pass — YYYY-MM-DD [scope: project-name or global]

**Deduplication candidates:** [n] found
- [[page-a]] / [[page-b]] — overlapping claim: "..."
  Proposed merge: [[page-a]] survives, [[page-b]] becomes stub

**Lifecycle promotions:** [n] proposed
- [[page]] — stub → active (sources: [[s1]], [[s2]])
- [[page]] — active → evergreen (4 sources, stable 65 days)
- [[page]] — archive candidate (no sources, 94 days inactive)

**Synthesis opportunities:** [n] found
- [[concept-a]] + [[entity-b]] appear in 4 sources — no connecting page
  Proposed: new concept page or wikilink
```

If a category is clean, write `[0] found` — do not omit the category.

### After confirmation

Apply all approved changes. Update frontmatter status fields. Append one entry to `CHANGELOG.md`:

```
## YYYY-MM-DD — Consolidation pass [scope]
- Duplicates merged: [n or "none"]
- Status changes: [list or "none"]
- Synthesis proposals accepted: [n or "none"]
```

### Hard rules

- Nothing is changed without explicit user confirmation per proposal.
- Never create a Topic hub without explicit confirmation (vault-wide rule).
- Consolidate is a recommendation engine, not an auto-fixer.
- Run scripted lint checks separately — consolidate does not replace lint.

---

## Relationship between lint and consolidate

| | `wiki-lint` | `wiki-consolidate` |
|---|---|---|
| **What it checks** | Structural integrity | Semantic coherence |
| **Method** | Bash scripts + page reads | Page reads + content comparison |
| **Output** | Pass/fail per check | Proposals requiring judgment |
| **Auto-fixes** | Yes (index drift, cross-refs, QUESTIONS closures) | No — all changes need confirmation |
| **Cadence** | Every 10–15 ingests | Every 30–50 ingests, or when drift is felt |

---

## Out of scope

- `wiki-batch-ingest` — deferred. Sequential ingest with shared context is the current model.
- Query relevance scoring / multi-pass reading — premature at current vault size.
- Integrating consolidate into lint as a `--deep` flag — keeps two distinct jobs separate.
