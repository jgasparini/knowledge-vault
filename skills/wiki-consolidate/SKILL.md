---
name: wiki-consolidate
description: >
  Semantic review of the wiki. Triggers when the user says "consolidate the wiki",
  "run a consolidation", "consolidation pass", "review the wiki for drift",
  "cleanup pass", "cross-area synthesis", or "consolidate across areas".
  Runs four checks: deduplication candidates (pages covering the same ground),
  lifecycle promotions (status changes that are overdue), synthesis opportunities
  (concepts ready for a new hub or cross-reference), and cross-area concept overlaps
  (concepts or entities that span two or more areas without a connecting wikilink).
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
- **Global**: "consolidate all" or "full consolidation". All pages across all projects
  — also runs the cross-area check (Check 4) automatically, since a full pass should
  surface area silos for free.
- **Cross-area**: "cross-area synthesis" or "consolidate across areas". Runs Check 4
  only — scans all concept and entity pages plus all area overview pages
  (`wiki/areas/*/[area-name].md`). Does not require project scoping.

---

## Check 1 — Deduplication candidates

Read all concept and entity pages within scope. Compare for substantial overlap: pages
that describe the same tool under two names, two concepts that are really one idea, or
entity pages that cover the same thing from different angles.

For each candidate pair:
1. Name both pages with wikilinks
2. Quote the overlapping claim (one sentence from each page)
3. Note the `reliability:` value of each page's source(s) — this gives the user a basis for deciding which framing to preserve in the merged page
4. Propose a merge direction — which page survives, which becomes a redirect stub

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

## Check 4 — Cross-area concept overlaps

Concept and entity pages have no `area:` frontmatter field — they're global resources —
so this check can't be pure frontmatter-matching. It needs the same two-layer approach
as Check 3: a cheap mechanical shortlist, then semantic judgment to confirm the overlap
is real.

**Layer 1 — mechanical shortlist** (cheap, catches the obvious cases):
1. List `wiki/areas/*/sources/` for every area to build a `source filename → area` map
   (do this for all areas, including any that lack an `INDEX.md`).
2. For every page in `wiki/resources/concepts/` and `wiki/resources/entities/`, resolve
   its `sources:` entries against the map and note the distinct areas its sources come
   from, and separately note which areas already link to it from their `## Key
   resources`. Either signal spanning 2+ areas earns a place on the shortlist.

**Layer 2 — semantic confirmation** (judgment, catches the cases Layer 1 misses):
A concept's *sources* can all sit in one area's folder while its *subject matter* is
clearly relevant to another — e.g. a concept about oversight and containment whose
sources were filed under `ai-native-engineering` is still substantively relevant to
`ai-security`. So beyond the shortlist, read each area's `## What this covers` /
`## Current focus` and skim its source corpus, and ask: does this concept's theme
recur in an area that doesn't yet link to it? Promote it to a candidate if so — name
the specific source(s) or passages that show the thematic fit, the same way Check 3
cites co-occurrence evidence.

Either path lands a page on the candidate list; only flag pages that span **2 or more**
areas.

For each candidate:
1. Name the concept or entity (wikilink) and the areas it spans (wikilink to each
   area's overview page, e.g. `[[ai-security/ai-security]]`)
2. Check whether a wikilink already exists in each area's `## Key resources` section
   and in the page's own `## Connections`/`## How it connects` section — note whether
   it's missing in both areas, missing in one, or present but not reciprocated
3. Propose one of:
   - Add the wikilink to the area overview(s) missing it, and/or to the concept's
     `## Connections`/`## How it connects` section
   - If no existing page captures the shared idea, propose a new concept page
     (subject to the same two-inbound-wikilinks rule as Check 3)
   - A topic hub, if the overlap is broad enough to warrant one — requires explicit
     user confirmation regardless of how clear the synthesis seems

Do not add links or create anything without confirmation.

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

**Cross-area concept overlaps:** [n] found
- [[concept]] — referenced by [[area-a]] and [[area-b]]; proposed: add link in both area overview pages
```

If a category is clean, write `[n] found` with n=0 — do not omit the category.

Present the report, then ask: "Which of these would you like to confirm?"

---

## After confirmation

For each approved item, apply the following:

**Deduplication merge:** fold the content of the retiring page into the surviving page using this approach:
- Merge sections by type: deepen definitions, add complementary examples, preserve both perspectives if claims conflict rather than silently dropping one
- Reconcile frontmatter: merge the `sources:` lists, set `updated:` to today's date, keep the higher status value
- Cross-reference any conflicting claims in both directions (do not resolve them — let them coexist). When cross-referencing, note the `reliability:` value of each source so the reader can weigh the tension appropriately
Replace the retiring page's body with a one-line redirect (`See [[surviving-page]]`), set its `status: archived`, and update all inbound wikilinks to point to the surviving page.

**Status change:** update the `status:` field in frontmatter and set `updated:` to today's date.

**Synthesis — new concept page:** create using the schema from `meta/CLAUDE.md` Section 3.2.
Ensure the new page has at least two inbound wikilinks before finishing.

**Synthesis — wikilink:** add the link in both pages under the section defined for that page type in `meta/CLAUDE.md` Section 3 (concepts use `## How it connects`, entities use `## Connections`). If the section is missing from a page, create it.

**Cross-area wikilink:** add the link to the named area overview's `## Key resources`
section, and to the concept or entity page's `## Connections`/`## How it connects`
section (creating either section if missing — same pattern as the synthesis wikilink
above). A cross-area overlap that warrants a new concept page follows the
**Synthesis — new concept page** procedure verbatim.

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

For a `[cross-area]` pass, add a fourth line:

```
## YYYY-MM-DD — Consolidation pass [cross-area]
- Duplicates merged: none
- Status changes: none
- Synthesis actions: none
- Cross-area links added: [n or "none"]
```

(Duplicates/status/synthesis stay "none" for a cross-area-only run since Checks 1–3
don't execute in that scope.) For a `[global]` pass that includes Check 4, fold its
count into the existing **Synthesis actions** line rather than adding a new field —
keep the established `[global]` format intact.

If all checks that ran for the chosen scope find zero items, still append the CHANGELOG entry with all fields set to "none", and state clearly in the report: "Wiki is semantically clean as of YYYY-MM-DD — no action needed."

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
