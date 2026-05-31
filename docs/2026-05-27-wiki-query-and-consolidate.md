# Wiki Query and Consolidate Skills — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create two new wiki skills — `wiki-query` (enforced query workflow with scoped reading) and `wiki-consolidate` (semantic review with deduplication, lifecycle, and synthesis checks) — and register them in `meta/CLAUDE.md`.

**Architecture:** Each skill is a single `SKILL.md` file following the established pattern in `skills/wiki-ingest/SKILL.md` and `skills/wiki-lint/SKILL.md`: YAML frontmatter with trigger description, numbered steps, hard rules section, portability note. No code. The skills read `meta/CLAUDE.md` at runtime for schema details.

**Tech Stack:** Markdown only. No scripts, no dependencies.

---

## Task 1: Create `skills/wiki-query/SKILL.md`

**Files:**
- Create: `skills/wiki-query/SKILL.md`

- [ ] **Step 1: Create the directory**

```bash
mkdir -p skills/wiki-query
```

- [ ] **Step 2: Write the skill file**

Create `skills/wiki-query/SKILL.md` with the following exact content:

````markdown
---
name: wiki-query
description: >
  Query the wiki for accumulated knowledge on a topic. Triggers when the user asks
  "query the wiki about X", "what does the wiki say about X", "ask the wiki X",
  "search the wiki for X", or any question clearly directed at accumulated wiki
  knowledge rather than general knowledge.
  Runs a 6-step workflow: detect scope → read scoped index → read targeted pages →
  synthesise and cite → write to scoped Outputs/ → gap analysis and promotion proposal.
  Use this skill for every wiki query — it keeps context lean by reading only the
  relevant index, ensures answers land in Outputs/, and routes gaps back to QUESTIONS.md.
---

# Wiki Query

## Before you start

Read `meta/CLAUDE.md` — specifically Section 2 (vault structure), Section 3 (page types),
and Section 4 (query workflow). Today's date is needed for the output filename.

---

## Step 1 — Detect scope

Infer from the query whether it is:

- **Project-scoped** — the query names a project or is clearly about work within one
- **Area-scoped** — the query is about an ongoing responsibility (a person, a team, an area)
- **Resource-scoped** — the query is about a concept, entity, or topic in the resources folder
- **Cross-cutting** — the query spans multiple projects or areas, or scope is ambiguous

When scope is ambiguous, ask rather than guess. One clarifying question is better than
reading the wrong index.

---

## Step 2 — Read scoped index first

Read only the index that matches the detected scope:

| Scope | Index to read |
|-------|--------------|
| Project | `wiki/projects/[name]/INDEX.md` |
| Area | `wiki/areas/[name]/` index page |
| Resource (concept/entity/topic) | Relevant section of `wiki/INDEX.md` |
| Cross-cutting | Full `wiki/INDEX.md` |

Do not read the full root `wiki/INDEX.md` when a scoped index suffices. This keeps
token cost flat regardless of how large the vault grows.

---

## Step 3 — Read targeted pages

From the index, identify the 3–6 pages most likely to answer the query. Read them in full.

If any of those pages link to adjacent concepts or entities that seem directly relevant
to the query, follow those links — but one hop only. Do not read broadly.

---

## Step 4 — Synthesise and cite

Answer the query using the wiki as source of truth:

- Cite every claim with `[[page-name]]`
- When drawing on general knowledge instead of wiki content, flag it explicitly:
  > *Note: the following draws on general knowledge, not wiki sources.*
- Do not blend wiki knowledge and general knowledge without distinguishing them

---

## Step 5 — Write to scoped Outputs/

Write the answer as a dated markdown file in the closest scoped folder:

| Query scope | Output folder |
|-------------|--------------|
| Project | `wiki/projects/[name]/Outputs/` |
| Area | `wiki/areas/[name]/Outputs/` |
| Resource | `wiki/resources/Outputs/` |
| Cross-cutting | root `Outputs/` |

Filename: `YYYY-MM-DD-[brief-slug].md`

Create the `Outputs/` subfolder if it does not exist.

Never answer a query inline without writing to `Outputs/`.

---

## Step 6 — Gap analysis and promotion

Two closing actions, both required:

**Gap analysis:** identify questions the query raised that the wiki could not answer from
its own pages. File each as a new item in the relevant `QUESTIONS.md`:

- Project-scoped query → `wiki/projects/[name]/QUESTIONS.md`
- Area-scoped query → area QUESTIONS.md or root `wiki/QUESTIONS.md`
- Resource or cross-cutting → root `wiki/QUESTIONS.md`

If there are no gaps, note that explicitly in the output file.

**Promotion proposal:** if the answer synthesises content from 3 or more pages, or
surfaces a connection between pages not previously captured, propose promoting the
output to a wiki page:

> "This answer draws on [[page-a]], [[page-b]], and [[page-c]] and surfaces a connection
> not previously captured. Shall I promote it to a wiki page?"

Never promote silently. If the answer does not meet the threshold, do not propose.

---

## Hard rules

- Never answer a query inline without writing to `Outputs/`.
- Never read the full root index when a scoped index suffices.
- Always flag explicitly when drawing on general knowledge.
- Never promote an output to a wiki page without explicit user confirmation.
- When scope is ambiguous, ask — do not guess and proceed.

---

## Portability note

This skill reads the vault schema from `meta/CLAUDE.md` at runtime. It does not hardcode
folder paths, page types, or QUESTIONS.md locations. If the schema changes, this skill
adapts automatically.
````

- [ ] **Step 3: Verify against spec**

Open `docs/superpowers/specs/2026-05-27-wiki-skills-design.md` and confirm each requirement is covered:

- [ ] Trigger phrases match spec ("query the wiki", "what does the wiki say about X", "ask the wiki X", "search the wiki for X")
- [ ] Scope detection with 4 categories (project, area, resource, cross-cutting) — ask when ambiguous
- [ ] Scoped index table present with correct paths per scope
- [ ] One-hop limit on adjacent pages
- [ ] Citation with `[[page-name]]`, general knowledge flagged explicitly
- [ ] Output written to scoped `Outputs/` with dated filename
- [ ] Gap analysis routes to correct `QUESTIONS.md` per scope
- [ ] Promotion proposal threshold (3+ pages or new connection), never silent
- [ ] All 5 hard rules present

- [ ] **Step 4: Commit**

```bash
git add skills/wiki-query/SKILL.md
git commit -m "feat: add wiki-query skill"
```

---

## Task 2: Create `skills/wiki-consolidate/SKILL.md`

**Files:**
- Create: `skills/wiki-consolidate/SKILL.md`

- [ ] **Step 1: Create the directory**

```bash
mkdir -p skills/wiki-consolidate
```

- [ ] **Step 2: Write the skill file**

Create `skills/wiki-consolidate/SKILL.md` with the following exact content:

````markdown
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

### Establish scope

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

Present the report, then ask: "Which of these would you like to action?"

---

## After confirmation

For each approved item, apply the following:

**Deduplication merge:** fold the content of the retiring page into the surviving page.
Replace the retiring page's body with a one-line redirect (`See [[surviving-page]]`),
set its `status: archived`, and update all inbound wikilinks to point to the surviving page.

**Status change:** update the `status:` field in frontmatter and set `updated:` to today's date.

**Synthesis — new concept page:** create using the schema from `meta/CLAUDE.md` Section 3.2.
Ensure the new page has at least two inbound wikilinks before finishing.

**Synthesis — wikilink:** add the link in both pages under their `## How it connects`
or `## Connections` section as appropriate.

Append one entry to `CHANGELOG.md` (newest first):

```
## YYYY-MM-DD — Consolidation pass [scope]
- Duplicates merged: [n or "none"]
- Status changes: [list or "none"]
- Synthesis actions: [n or "none"]
```

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

This skill reads the vault schema from `meta/CLAUDE.md` at runtime. It does not hardcode
page types, status values, or folder paths. If the schema changes, this skill adapts
automatically.
````

- [ ] **Step 3: Verify against spec**

Open `docs/superpowers/specs/2026-05-27-wiki-skills-design.md` and confirm each requirement is covered:

- [ ] Trigger phrases match spec ("consolidate the wiki", "run a consolidation", "consolidation pass", "review the wiki for drift", "cleanup pass")
- [ ] Scope detection: project-scoped default, global option
- [ ] Check 1: reads all concept/entity pages, quotes overlap, proposes merge direction, no action without confirmation
- [ ] Check 2: three proposal types (stub→active at 2+ sources, active→evergreen at 60+ days + 4+ sources, archive at 90+ days no sources)
- [ ] Check 3: 3+ source co-appearances, three proposal types (concept page, topic hub, wikilink)
- [ ] Report format matches spec exactly (all three sections, `[0] found` when clean)
- [ ] Confirmation gate: report first, then ask which to action
- [ ] After-confirmation steps cover all three action types
- [ ] CHANGELOG.md update with correct format
- [ ] All hard rules present (no silent changes, no topic hub without confirmation, not a lint replacement)

- [ ] **Step 4: Commit**

```bash
git add skills/wiki-consolidate/SKILL.md
git commit -m "feat: add wiki-consolidate skill"
```

---

## Task 3: Update `meta/CLAUDE.md` — register new skills

**Files:**
- Modify: `meta/CLAUDE.md` (Skills section, lines ~70–76)

- [ ] **Step 1: Open meta/CLAUDE.md and locate the Skills section**

Find the block that reads:

```markdown
### Skills

Workflows are defined as skills in `skills/`:

- `skills/wiki-setup/SKILL.md` — interactive scaffold for a new project
- `skills/wiki-ingest/SKILL.md` — full 10-step ingest workflow
- `skills/wiki-lint/SKILL.md` — 8-check lint workflow with scripts
- `skills/writing-rules/SKILL.md` — house style guide; read before writing any wiki prose
```

- [ ] **Step 2: Add the two new skills to the list**

Replace that block with:

```markdown
### Skills

Workflows are defined as skills in `skills/`:

- `skills/wiki-setup/SKILL.md` — interactive scaffold for a new project
- `skills/wiki-ingest/SKILL.md` — full 10-step ingest workflow
- `skills/wiki-query/SKILL.md` — 6-step query workflow: scoped index-first reading, Outputs/ landing, gap analysis
- `skills/wiki-lint/SKILL.md` — 8-check lint workflow with scripts
- `skills/wiki-consolidate/SKILL.md` — semantic review: deduplication, lifecycle promotions, synthesis opportunities
- `skills/writing-rules/SKILL.md` — house style guide; read before writing any wiki prose
```

- [ ] **Step 3: Update Section 4 header to reference the skill**

Find the line that reads:

```markdown
## Section 4: Query Workflow
```

Add one line immediately after the opening paragraph of Section 4 (after "A good answer is a wiki page waiting to happen."):

```markdown
See `skills/wiki-query/SKILL.md` for the full query workflow. The steps below are a summary.
```

- [ ] **Step 4: Verify**

- [ ] Six skills listed in the Skills section (setup, ingest, query, lint, consolidate, writing-rules)
- [ ] wiki-query listed between ingest and lint (logical reading order)
- [ ] wiki-consolidate listed between lint and writing-rules
- [ ] Section 4 references the skill file

- [ ] **Step 5: Commit**

```bash
git add meta/CLAUDE.md
git commit -m "docs: register wiki-query and wiki-consolidate in meta/CLAUDE.md"
```

---

## Self-review

**Spec coverage check** against `docs/superpowers/specs/2026-05-27-wiki-skills-design.md`:

- wiki-query scope detection with 4 categories → Task 1 Step 1
- wiki-query scoped index table → Task 1 Step 2
- wiki-query one-hop limit → Task 1 Step 3
- wiki-query citation + general knowledge flag → Task 1 Step 4
- wiki-query scoped Outputs/ with dated filename → Task 1 Step 5
- wiki-query gap analysis routed to correct QUESTIONS.md → Task 1 Step 6
- wiki-query promotion proposal (3+ pages threshold) → Task 1 Step 6
- wiki-query hard rules (5 rules) → Task 1 Step 2
- wiki-consolidate Check 1 deduplication → Task 2 Check 1
- wiki-consolidate Check 2 lifecycle (3 proposal types, specific thresholds) → Task 2 Check 2
- wiki-consolidate Check 3 synthesis (3+ sources, 3 proposal types) → Task 2 Check 3
- wiki-consolidate report format (exact format, `[0] found` when clean) → Task 2 Report format
- wiki-consolidate confirmation gate → Task 2 Report format + After confirmation
- wiki-consolidate CHANGELOG entry → Task 2 After confirmation
- wiki-consolidate hard rules → Task 2 Hard rules
- meta/CLAUDE.md registration → Task 3

All spec requirements covered. No placeholders. Thresholds are specific (2+ sources, 60 days, 4+ sources, 90 days, 3+ co-appearances). Section names match the schemas in meta/CLAUDE.md (`## How it connects`, `## Connections`).
