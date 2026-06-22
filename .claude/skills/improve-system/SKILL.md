---
name: improve-system
description: Use when the user wants to maintain or improve the knowledge system itself — not ingest content. Triggers on: audit/health-check requests, improving a skill after friction, capturing a story/win/lesson, mining past sessions for missed learnings, or filling in foundational memories about the user (identity, tone, brand, working style).
---

# Improve System

## Overview

Meta-maintenance skill for the knowledge system. Detects one of five modes from context, or asks if unclear.

## Mode Detection

Match the user's message to the best-fit mode:

| Mode | Triggers when… |
|------|----------------|
| **Audit** | "stale notes", "conflicting pages", "duplicates", "wiki health", "drift" |
| **Skill Review** | "improve that skill", after a workflow broke down or repeated corrections |
| **Experience** | "capture this", "remember this win/lesson", user shares a story or outcome |
| **Historical Review** | "mine my sessions", "what have I missed", "review past conversations" |
| **Foundation** | "fill in about me", "tone of voice", "brand", "style guide", "who am I" |

If ambiguous, show the five options and ask.

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
