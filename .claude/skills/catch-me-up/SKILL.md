---
name: catch-me-up
description: >
  Reconstructs context after an interruption. Triggers when the user asks
  "catch me up", "where did I leave off [on X]", "what have I been doing the
  last N days", or any similar re-entry question — making deep work
  interruptible without losing the thread.
  Runs a lightweight 4-step workflow: detect scope and time window → read
  CHANGELOG.md entries in that window → pull the project's decisions log and
  open questions if scoped → synthesise a short conversational briefing.
  Unlike wiki-query this never writes to outputs/ — it's a transient re-entry
  aid, not a wiki artifact worth filing.
---

# Catch Me Up

## Before you start

Read `meta/CLAUDE.md` Section 2 (vault structure). Note today's date — it anchors the
time window calculation.

---

## Step 1 — Detect scope and time window

**Scope** — infer from the query whether it is:

- **Project-scoped** — the query names a project ("where did I leave off on
  ai-operating-system?")
- **Cross-cutting** — the query is general ("catch me up", "what have I been doing?")

**Time window** — work out the start date, in this priority order:

1. An explicit duration in the query ("last 3 days" → today minus 3 days)
2. For project-scoped queries with no explicit duration: the project's `updated:`
   frontmatter field in `_overview.md`
3. Default: the last 7 days

State the inferred window back to the user as part of the briefing ("Catching you up
since 2026-06-04 — the last entry touching this project") rather than asking first.
Re-entry should be fast; the user can correct the window if it's wrong.

---

## Step 2 — Read CHANGELOG.md entries in the window

`CHANGELOG.md` is newest-first (`## YYYY-MM-DD — [operation type] [scope]`). Scan from
the top and stop at the first entry older than the window's start date.

For project-scoped queries, keep only entries that reference the project — by name, by
scope tag, or via `[[page-name]]` wikilinks pointing into that project's pages.

This changelog scan is the baseline signal and works even when the project has no
`_overview.md` yet (e.g. it's an area, not a project).

---

## Step 3 — Pull project decisions and open threads (project-scoped only)

- Read the project's `_overview.md` — specifically `## Current status` and
  `## Decisions log`
- Read the project's `QUESTIONS.md` `## Open` section
- Skip this step entirely for cross-cutting catch-ups — the changelog window is the
  whole signal there. Optionally glance at root `wiki/QUESTIONS.md` `## Open` for
  threads that span multiple projects.

---

## Step 4 — Synthesise a short conversational briefing

Answer inline in chat. Do not write to `outputs/` — this is the one place this skill
diverges from `wiki-query`'s "answers get filed" pattern, deliberately: a daily re-entry
aid filed as a dated artifact every time would clutter the vault with low-signal noise.

Structure the briefing as two short parts:

- **What happened** — a few sentences on what the changelog window shows: pages created
  or updated, structural changes, contradictions surfaced. Cite with `[[page-name]]`
  where it helps orient the user, but keep it tight.
- **What's still open** — a short bullet list drawn from `## Open actions` and
  `QUESTIONS.md` `## Open` (project-scoped) or root `wiki/QUESTIONS.md` `## Open`
  (cross-cutting).

If the window contains no relevant activity, say so plainly — don't pad the briefing to
look more substantial than the evidence supports.

---

## Hard rules

- Never write the briefing to `outputs/` — deliver it conversationally, every time
- Never invent activity that isn't present in `CHANGELOG.md` or the project's files
- State the inferred time window rather than blocking to ask — speed of re-entry matters
  more than precision here
- Read `meta/CLAUDE.md` at runtime — don't hardcode folder paths or page types

---

## Portability note

This skill reads the vault schema from `meta/CLAUDE.md` at runtime. It does not hardcode
folder paths, page types, or QUESTIONS.md locations. If the schema changes, this skill
adapts automatically.
