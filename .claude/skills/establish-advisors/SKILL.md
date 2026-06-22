---
name: establish-advisors
description: Use when the user asks to add a new advisor, wants to know who should join the board, invokes /establish-advisors, or asks "who else should be on the board". Reads the vault to diagnose gaps, then recommends specific advisors whose published work addresses those gaps.
---

# Establish Advisors

## Overview

Builds and extends the advisory board by reading the vault, diagnosing knowledge gaps, and recommending advisors whose specific body of work closes those gaps. Never recommends based on generic eminence — every recommendation must trace to open questions in the wiki. Ends with ingested sources, an entity page with a voice profile, and `ask-the-board` updated.

---

## Step 1 — Read the vault

Read these files before forming any view:

**Current board:**
- `.claude/skills/ask-the-board/SKILL.md` — who's currently on the board and what lenses they cover

**User context:**
- `wiki/INDEX.md` — project directory and global resources catalog
- `wiki/projects/[name]/_overview.md` for every active project — goals and current status
- `wiki/projects/[name]/QUESTIONS.md` for every active project — open threads reveal where the wiki is thin
- `wiki/QUESTIONS.md` — cross-project threads
- `wiki/areas/` — ongoing responsibilities

**Memory (if available):**
- `~/.claude/projects/.../memory/MEMORY.md` and linked files — role, preferences, context

Do not skip the QUESTIONS.md files. Open questions are the most direct signal of where the board is weak.

---

## Step 2 — Diagnose gaps

From the reading, work out:

1. **What domains does the user operate in?** (from project goals and concept landscape)
2. **What open questions recur most?** (from QUESTIONS.md files — these are the real gaps)
3. **What does the current board already cover well?** (map existing advisor lenses — don't duplicate)
4. **What type of advisor is missing?** Practitioner vs researcher vs operator vs strategist. Domain: measurement, security, organisational design, regulated industries, product, etc.

Hold this diagnosis. It drives everything below.

---

## Step 3 — Surface recommendations

Present 2–3 advisor candidates. For each:

---

**[Full name], [current or most recent role]**

**Why they fit:** 2–3 sentences tying their specific published work to the diagnosed gaps. Name the frameworks, papers, or concepts that are directly relevant to the user's open questions. Do not use generic "thought leader" language.

**Why now:** Which specific open questions in the current QUESTIONS.md files does this advisor directly address? Be explicit.

**5 best pieces to ingest:**
Ordered by signal value. Each must be:
- Publicly accessible (no paywalled books without a specific accessible excerpt or summary)
- Not already in the wiki
- Specific — name the article, paper, talk, or post, not just "their blog"

---

Wait for user confirmation before proceeding. They may add all, some, or none. They may suggest alternatives. Do not write anything to the wiki until confirmed.

---

## Step 4 — For each confirmed advisor

Work through 4a → 4b → 4c in order for each advisor before moving to the next.

### 4a — Ingest the 5 pieces

Follow the `wiki-ingest` skill (Steps 1–9) for each piece. Assign each source to the most relevant existing project. If no project fits, flag it — do not create a new project without explicit user confirmation.

### 4b — Create the entity page

Create `wiki/resources/entities/[advisor-slug].md` using the entity schema from `meta/CLAUDE.md` Section 3.3.

After the standard `## Source references` section, add a `## Board voice profile` section:

```
## Board voice profile

**Lens:** [one short phrase — their single most distinctive intellectual move]

**Core instincts:**
- [3–5 bullet points — the moves they make repeatedly across their work]
- [Each should be specific enough that a reader could predict what they'd say about a new topic]

**How they sound:** [2–3 sentences. What they lead with. The hard question they always ask. One phrase they'd actually say verbatim.]

**Vocabulary:** [10–15 terms, frameworks, and concepts they own — the words that mark their voice]
```

Write this from the ingested sources, not from general knowledge. It must reflect what the wiki actually contains about them.

### 4c — Update ask-the-board

Open `.claude/skills/ask-the-board/SKILL.md` and make two changes:

1. **Overview section:** Add the new advisor (name + lens, one line).
2. **Voice profiles section:** Add a full voice profile section, copied and expanded from the entity page's `## Board voice profile`.

The voice profile in `ask-the-board` is the working copy — write it for a Claude instance that hasn't read the entity page. Make it self-contained.

---

## Step 5 — Update registries

**`CHANGELOG.md`:** Prepend one entry:
```
## YYYY-MM-DD — Board | [Advisor name] added
- Entity page created: [[advisor-slug]]
- Sources ingested: [list]
- ask-the-board updated: yes
```

**`CLAUDE.md`:** Update the `ask-the-board` row in the skills table if the board composition description has changed.

---

## Hard rules

- Recommend only advisors whose specific published work addresses the diagnosed gaps. Being well-known is not a criterion.
- Never duplicate an existing board member's lens. If the gap is already covered, say so.
- The 5 pieces must be specific and accessible. "Their book" is not a piece — a specific chapter, excerpt, or publicly available summary is.
- Do not create a new project during this workflow without explicit user confirmation.
- Do not write to the wiki (Step 4) until the user has confirmed the recommendations (Step 3).
- The `## Board voice profile` section is mandatory on every advisor entity page. `ask-the-board` cannot use an advisor without it.
- If the advisor entity page already exists (partial stub), update it — don't create a duplicate.
