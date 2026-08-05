---
name: improve-system
description: Use when the user wants to maintain or improve the knowledge system itself — not ingest content. Triggers on: audit/health-check requests, improving a skill after friction, capturing a story/win/lesson, mining past sessions for missed learnings, or filling in foundational memories about the user (identity, tone, brand, working style).
---

# Improve System

## Overview

Meta-maintenance skill for the knowledge system. Detects one of six modes from context, or asks if unclear.

## Mode Detection

Match the user's message to the best-fit mode:

| Mode | Triggers when… |
|------|----------------|
| **Audit** | "stale notes", "conflicting pages", "duplicates", "wiki health", "drift" |
| **Skill Review** | "improve that skill", after a workflow broke down or repeated corrections |
| **Experience** | "capture this", "remember this win/lesson", user shares a story or outcome |
| **Historical Review** | "mine my sessions", "what have I missed", "review past conversations" |
| **Foundation** | "fill in about me", "tone of voice", "brand", "style guide", "who am I" |
| **Regression Check** | "regression check", "test wiki-ingest", "run the wiki-ingest regression test" |

If ambiguous, show the six options and ask.

---

## Mode 1: Audit

**Goal:** Surface stale, conflicting, or duplicate content in the wiki.

1. Run the wiki-lint scripts from `CLAUDE.md` for a baseline health snapshot.
2. **Stale:** find pages with `updated` > 180 days ago and status `active`.
3. **Duplicates:** find concept or entity pages with similar titles or overlapping summaries.
4. **Contradictions:** find the same claim stated differently on two pages — flag both, quote both, do not resolve silently.
5. Write a report to `outputs/audit-YYYY-MM-DD.md` with three sections:
   - **Stale pages** — title, last-updated, recommended action (update / archive)
   - **Duplicates** — page pair, suggested merge target
   - **Contradictions** — both pages cited with the conflicting claims quoted
6. Confirm the report path. Do not modify any wiki page without an explicit instruction.

---

## Mode 2: Skill Review

**Goal:** Improve a skill based on patterns from the current or recent conversation.

1. Identify the skill under review (from the user's message or recent friction: repeated corrections, skipped steps, a workflow that broke down).
2. Read the full current `SKILL.md` for that skill.
3. Extract concrete improvement signals:
   - Explicit corrections ("no, do X not Y")
   - Steps skipped or done out of order
   - Missing guidance that caused confusion
4. Propose targeted edits (old → new). Do not rewrite wholesale.
5. Apply only after the user confirms.
6. Save a `feedback` memory summarising what changed and why.

---

## Mode 3: Experience

**Goal:** Capture a story, win, or lesson as a durable memory.

1. Listen to what the user shared. Ask one clarifying question if the key insight is unclear.
2. Pick the memory type:
   - **feedback** — lesson about how to work together
   - **project** — decision, outcome, or milestone in ongoing work
   - **user** — reveals something about role, expertise, or preferences
3. Draft the memory: lead with the fact/rule, then **Why:** and **How to apply:** lines.
4. Show the draft. Write it only after the user confirms.
5. Update `MEMORY.md` index.

Memory directory: `/Users/jgasparini/.claude/projects/-Users-jgasparini-Library-Mobile-Documents-iCloud-md-obsidian-Documents-knowledge-vault/memory/`

---

## Mode 4: Historical Review

**Goal:** Mine recent Claude Code sessions for patterns and missed learnings.

1. List recent project conversations:
   ```bash
   ls -lt ~/.claude/projects/*knowledge-vault*/conversations/ 2>/dev/null | head -20
   ```
2. Read the 3–5 most recent conversations (by mtime).
3. Extract per session:
   - Corrections the user gave Claude
   - Workflows that worked well (confirmed, no pushback)
   - Repeated questions suggesting a missing memory or skill gap
4. Cluster findings into candidate memories or skill improvements.
5. Present a ranked list (highest-signal first) with a proposed action per finding.
6. Write only what the user approves. Do not batch-write without confirmation.

---

## Mode 5: Foundation

**Goal:** Fill in missing foundational content — identity, style, voice, brand.

1. Read all existing `user`-type memories from the memory directory.
2. Check for gaps across:
   - **Identity** — role, background, expertise areas
   - **Communication style** — tone, formality, writing preferences
   - **Brand / aesthetic** — visual preferences, project names, identities
   - **Working style** — how they like to collaborate with Claude
3. Ask focused questions to fill gaps (max 3 at a time).
4. Draft memories from the answers — show drafts before writing.
5. Write confirmed memories and update `MEMORY.md`.

---

## Mode 6: Regression Check

**Goal:** Catch unintended behavior drift in `wiki-ingest` after a `SKILL.md` edit, by re-running a known fixture source through the skill in an isolated sandbox and diffing the result against the last-approved output.

1. **Resolve the fixture** — default to `article-basic` if the user doesn't name one. If `.claude/skills/wiki-ingest/tests/regression/fixtures/<fixture>/` doesn't exist, list the available fixtures under that directory and stop.
2. **Build the sandbox** — create an isolated copy of only what `wiki-ingest` reads:
   ```bash
   SANDBOX=$(mktemp -d)
   mkdir -p "$SANDBOX/meta" "$SANDBOX/wiki/projects" "$SANDBOX/inbox"
   cp meta/CLAUDE.md "$SANDBOX/meta/CLAUDE.md"
   cp meta/health.md "$SANDBOX/meta/health.md"
   cp CHANGELOG.md "$SANDBOX/CHANGELOG.md"
   cp wiki/INDEX.md "$SANDBOX/wiki/INDEX.md"
   cp wiki/QUESTIONS.md "$SANDBOX/wiki/QUESTIONS.md"
   cp -r ".claude/skills/wiki-ingest/tests/regression/fixtures/<fixture>/scratch-project" "$SANDBOX/wiki/projects/regression-fixture"
   cp ".claude/skills/wiki-ingest/tests/regression/fixtures/<fixture>/source.md" "$SANDBOX/inbox/source.md"
   ```
   Do not `cd` into `$SANDBOX` — the working directory stays at the repo root for the rest of this mode. Build every path explicitly: vault-data paths (`inbox/`, `wiki/`, `meta/CLAUDE.md`, `meta/health.md`, `CHANGELOG.md`) get the `$SANDBOX/` prefix; skill-code paths (`.claude/skills/*/scripts/...`, `.claude/skills/wiki-ingest/convert.py`) stay repo-relative, since those are code, not vault content, and take the sandboxed file as an argument regardless of where they're invoked from.
3. **Run the ingest** — follow `.claude/skills/wiki-ingest/SKILL.md`'s 10-step workflow exactly, unmodified, with `$SANDBOX/inbox/source.md` as the file being ingested and `regression-fixture` (at `$SANDBOX/wiki/projects/regression-fixture/`) as the target project. Every vault-data path the skill references resolves under `$SANDBOX/` per step 2; every skill-code path stays repo-relative. If `wiki-ingest` errors partway through (unreadable file, a script dependency missing, an unresolvable structural question), stop, report the error to the user, skip straight to step 7 (clean up), and leave `golden/<fixture>/` untouched — do not partially update the baseline.
4. **Diff against the golden snapshot** — compare, against `.claude/skills/wiki-ingest/tests/regression/golden/<fixture>/`:
   - the whole `$SANDBOX/wiki/projects/regression-fixture/` subtree (`_overview.md`, `INDEX.md`, `QUESTIONS.md`, `sources/`)
   - any new files under `$SANDBOX/wiki/resources/concepts/` or `$SANDBOX/wiki/resources/entities/`
   - only the new row(s) appended to root `wiki/INDEX.md`'s Global Resources section — never the whole file, since it holds real, unrelated project and area data that must not end up in a git-tracked fixture. Extract the new row(s) and compare against `golden/<fixture>/root-index-delta.md`.

   If `golden/<fixture>/` doesn't exist yet, this run becomes the baseline — skip to step 6.
5. **Present the diff** — additions/changes/removals, frontmatter deltas, prose deltas, plainly. Ask: same behavior, intentional improvement, or regression?
6. **On approval (or first-run bootstrap)** — overwrite `golden/<fixture>/` with the new `wiki/projects/regression-fixture/` subtree, any new concept/entity pages, and the extracted `root-index-delta.md`. Append one line to `golden/<fixture>/HISTORY.md`: `YYYY-MM-DD — <one-sentence reason>`.
7. **Clean up** — `rm -rf "$SANDBOX"` in every case: success, rejected diff, or error.

No real-vault file (`wiki/`, `inbox/`, `CHANGELOG.md`, `meta/health.md`) is written to at any point — every ingest action happens inside `$SANDBOX`.
