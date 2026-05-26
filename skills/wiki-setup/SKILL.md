---
name: wiki-setup
description: >
  Scaffold a new project in the knowledge vault. Triggers when the user says
  "set up a new project", "start a project", "create a project for [topic]",
  "scaffold [project name]", or any variation where they want to start tracking
  a new domain or research effort in the wiki. Also trigger when the vault is
  brand new and nothing exists yet.
  Asks for a project name, goal, and topic, then creates the full project
  folder structure, navigation files, and optional starter topic hub — ready
  for the first ingest.
---

# Wiki Setup — New Project Scaffold

## Before you start

Read `meta/CLAUDE.md` in full. Pay attention to:
- Section 2: vault structure and folder layout
- Section 3: page types and frontmatter schemas (especially 3.4 topic hub and 3.5 project overview)
- Section 1: hard rules (never create Topics without confirmation)

Also read `wiki/INDEX.md` to understand which projects already exist. If the user
named a project that already exists, confirm before proceeding — they may mean to
add to it, not create a duplicate.

---

## The setup workflow

### Step 1 — Gather inputs

Ask the user:

1. **Project name** — what should this project be called? (You'll convert to kebab-case for
   the folder; display the human-readable version in navigation files.)
2. **Goal** — one sentence: what does "done" look like for this project?
3. **Domain / topic** — what is the broad subject area? (This becomes the candidate topic hub.)
4. **Review date** — when should progress be reviewed? (Optional — can be left blank.)

Example prompt to the user:
> "To scaffold your new project I need a few details:
> 1. What's the project name?
> 2. What does done look like — one sentence goal?
> 3. What's the broad topic or domain (e.g. 'retrieval-augmented generation', 'competitive intelligence')?
> 4. Any target review date?"

Wait for their answers before proceeding.

---

### Step 2 — Confirm topic hub

If the user provided a domain/topic, ask whether to create a starter topic hub page for it:

> "Shall I create a topic hub for '[[topic-name]]'? This will be the evolving-thesis page
> for everything you learn in this domain — updated with every ingest."

If yes: create it in Step 4. If no: skip it.

---

### Step 3 — Create project folder structure

Create the following files and directories:

```
wiki/projects/[project-name]/
  _overview.md        ← pre-filled with the goal and today's date
  INDEX.md            ← blank project index (Sources, Concepts, Entities sections)
  QUESTIONS.md        ← blank questions file (Open / Closed sections)
  sources/
    .gitkeep          ← placeholder so the folder exists in git
```

Use the schemas from `meta/CLAUDE.md` Section 3.5 for `_overview.md`.

Fill in what you know from the user's answers:
- `goal:` — from their one-sentence answer
- `created:` and `updated:` — today's date
- `status: active`
- `review-date:` — from their answer, or blank

---

### Step 4 — Create starter topic hub (if confirmed)

Create `wiki/resources/topics/[topic-name].md` using the schema from `meta/CLAUDE.md`
Section 3.4.

Fill in:
- `status: stub`
- `created:` — today's date
- `## Overview` — one or two sentences describing the domain (use your knowledge)
- `## Active projects` — link to the project just created
- All other sections: leave as empty stubs with a comment `*(not yet populated — add on first ingest)*`

---

### Step 5 — Update root INDEX.md

Add a row to the Projects table in `wiki/INDEX.md`:

```
| [[project-name/_overview\|Project Display Name]] | [[project-name/INDEX]] | [one-sentence goal] |
```

If a topic hub was created, add it to the Topics section of Global Resources.

---

### Step 6 — Append to CHANGELOG.md

Prepend a new entry at the top of `CHANGELOG.md`:

```
## YYYY-MM-DD — Setup | [Project Display Name]
- Project folder created: wiki/projects/[project-name]/
- Files created: _overview.md, INDEX.md, QUESTIONS.md, sources/
- Topic hub created: [[topic-name]] (or "none")
- Root INDEX.md updated
```

---

### Step 7 — Confirm

Summarise what was created:
- Project folder path
- Files created
- Topic hub (if created)
- What to do next: drop sources into `inbox/` and run the wiki-ingest skill

---

## Hard rules

- Never create the project folder silently — always confirm the name and goal first.
- Never create a topic hub without the user's explicit confirmation in Step 2.
- The project folder name must be kebab-case: `my-project-name`, not `My Project Name`.
- `_overview.md`, `INDEX.md`, and `QUESTIONS.md` are mandatory. Do not skip any of them.
- CHANGELOG.md must be updated. Do not skip Step 6.

---

## Portability note

This skill reads the vault schema from `meta/CLAUDE.md` at runtime. It does not hardcode
folder paths or frontmatter fields. If the schema changes, this skill adapts automatically.
