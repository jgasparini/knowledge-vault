---
name: wiki-query
description: >
  Query the wiki for accumulated knowledge on a topic. Triggers when the user asks
  "query the wiki", "what does the wiki say about X", "ask the wiki X",
  "search the wiki for X", or any question clearly directed at accumulated wiki
  knowledge rather than general knowledge.
  Runs a 6-step workflow: detect scope → read scoped index → read targeted pages →
  synthesise and cite → write to scoped Outputs/ → gap analysis and promotion proposal.
  Use this skill for every wiki query — it keeps context lean by reading only the
  relevant index, ensures answers land in Outputs/, and routes gaps back to QUESTIONS.md.
---

# Wiki Query

## Before you start

Read `meta/CLAUDE.md` — specifically Section 2 (vault structure) and Section 3 (page types).
Today's date is needed for the output filename.

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
| Area | The area's main page at `wiki/areas/[name].md` or `wiki/areas/[name]/_overview.md` if one exists |
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

The output file must include:
- Frontmatter: `type: query`, `date: YYYY-MM-DD`, `query:` (the user's question), `scope:` (project/area/resource/cross-cutting)
- `## Answer` — the synthesised response with citations
- `## Gaps` — questions the wiki could not answer (or "None" if none)

Create the `Outputs/` subfolder if it does not exist.

Never answer a query inline without writing to `Outputs/`.

---

## Step 6 — Gap analysis and promotion

Two closing actions, both required:

**Gap analysis:** identify questions the query raised that the wiki could not answer from
its own pages. File each as a new item in the relevant `QUESTIONS.md`:

- Project-scoped query → `wiki/projects/[name]/QUESTIONS.md`
- Area-scoped query → root `wiki/QUESTIONS.md`
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
