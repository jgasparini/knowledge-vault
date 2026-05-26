# Knowledge Vault

A Claude-powered knowledge management system built on Obsidian. Drop sources into an inbox,
run an ingest skill, and Claude maintains a structured, interlinked wiki that compounds with
every source added.

---

## What this is

A second brain framework where Claude acts as the librarian. It reads sources, writes wiki
pages, cross-references contradictions, and builds up an evolving body of knowledge — so
you don't have to start from scratch every time you ask a question.

The design principles:

- **Compile, don't retrieve** — every ingest integrates with what's already there
- **The wiki is the output** — answers get filed, not left in chat
- **You curate; Claude writes** — you direct what matters; Claude does the bookkeeping
- **Contradictions coexist** — tensions are cross-referenced, not flattened

---

## Prerequisites

- [Obsidian](https://obsidian.md) — for navigating the vault (wikilinks, graph view)
- [Claude Cowork](https://anthropic.com) or [Claude Code](https://claude.ai/code) — for
  running the skills

The skills in this repo are written for Claude. They work with Claude Cowork (desktop) or
Claude Code (terminal). You don't need Obsidian to run ingests — it's just the best way to
navigate and read the wiki.

---

## Getting started

### 1. Clone the repo

```bash
git clone https://github.com/your-username/knowledge-vault.git
cd knowledge-vault
```

### 2. Open in Obsidian

Open the `knowledge-vault` folder as a vault in Obsidian. All the wikilinks will resolve
correctly.

### 3. Open in Claude Cowork (or Claude Code)

Point Claude at this folder. In Cowork: connect the folder. In Claude Code: `cd` into it.

### 4. Run the setup skill

Tell Claude:

> "Set up a new project for [your topic]"

Claude will ask for a project name, goal, and domain, then scaffold the folder structure
and navigation files.

### 5. Drop sources into `inbox/`

Any file format Claude can read: PDFs, markdown, text files, web clips. Then tell Claude:

> "Ingest the inbox"

or

> "Ingest [filename]"

### 6. Ask questions

Once sources are ingested, ask anything:

> "What do I know about [topic]?"
> "What's the tension between [concept A] and [concept B]?"
> "What should I read next to fill the gap on [topic]?"

---

## Folder structure

```
knowledge-vault/
  inbox/              ← drop sources here
  wiki/
    projects/         ← one folder per active research project
    areas/            ← ongoing responsibilities (no end date)
    resources/
      concepts/       ← mental models and patterns
      entities/       ← named things: tools, people, companies
      topics/         ← broad topic hubs with evolving theses
    INDEX.md          ← project directory + global resource catalog
    QUESTIONS.md      ← cross-project open threads
  Outputs/            ← query results and reports
  archive/            ← completed or inactive material
  meta/
    CLAUDE.md         ← schema and hard rules (Claude reads this on every operation)
  CHANGELOG.md        ← log of every ingest, lint pass, and restructure
  templates/          ← page templates for manual capture
  skills/
    wiki-setup/       ← scaffold a new project
    wiki-ingest/      ← add a source to the wiki
    wiki-lint/        ← health check: orphans, drift, contradictions
```

---

## Skills

### `wiki-setup`
Scaffolds a new project. Creates the folder structure, navigation files, and optionally a
starter topic hub. Run this before your first ingest on any new research area.

**Trigger:** "Set up a new project for [topic]" / "Create a project called [name]"

### `wiki-ingest`
Ingests a source into the wiki. Surfaces key insights, updates existing pages, creates new
concept and entity pages, moves the source file, and updates all navigation registries.

**Trigger:** "Ingest [filename]" / "Ingest the inbox" / "Add this to the wiki"

### `wiki-lint`
Runs 8 structural checks: orphan pages, missing pages, stale stubs, contradictions without
cross-references, index drift, archive candidates, and QUESTIONS.md hygiene. Produces a
structured report and auto-fixes what it can.

**Trigger:** "Run a lint" / "Lint the wiki" / "Wiki health check"

---

## The schema

Everything Claude needs to know about the vault lives in `meta/CLAUDE.md`. This includes:

- Page types and frontmatter schemas (7 types)
- Folder structure and naming rules
- Hard rules for every operation
- Query workflow
- Lint workflow pointer

The skills read this file at runtime — so if you change the schema, the skills adapt
automatically. You never need to edit the skills directly.

---

## Customising for your domain

The framework is domain-agnostic. To adapt it:

1. **Add a writing style guide** — create `writing-rules.md` in the root. Claude will
   apply it to all wiki prose. Define tone, terminology preferences, things to avoid.

2. **Adjust the schema** — edit `meta/CLAUDE.md` to add page types, change frontmatter
   fields, or add domain-specific hard rules. The skills will pick up the changes.

3. **Add Dataview queries** — if you use Obsidian with the Dataview plugin, add dashboard
   queries to a `_dataview/` folder for status boards, recently updated pages, etc.

---

## How projects work

A project is a bounded research or work effort with a goal and a review date. It gets its
own subfolder in `wiki/projects/` containing:

- `_overview.md` — goal, status, decisions log
- `INDEX.md` — catalog of everything ingested for this project
- `QUESTIONS.md` — open threads and gaps specific to this project
- `sources/` — raw source files + processed source summaries

When a project is complete, it moves to `archive/` and becomes searchable but no longer
maintained.

Concepts and entities created during a project's ingests live in `wiki/resources/` — they
belong to the shared knowledge graph, not the project.

---

## Lint cadence

Run a lint pass after every 10–15 ingests, or when the wiki starts to feel like it's
drifting. The lint skill:

- Flags orphan pages (fewer than 2 inbound links)
- Finds wikilinks pointing to pages that don't exist
- Detects index drift (pages not listed anywhere)
- Identifies stubs ready to expand
- Checks QUESTIONS.md for items that can now be closed

---

## Contributing

Pull requests welcome. If you've adapted the schema for a specific domain (legal research,
competitive intelligence, engineering architecture, etc.), consider sharing it as a branch
or fork.

---

## Licence

MIT
