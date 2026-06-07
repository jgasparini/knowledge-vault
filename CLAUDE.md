# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude-powered knowledge management system. You act as the librarian: reading sources, writing wiki pages, cross-referencing contradictions, and maintaining a structured, interlinked second brain. The wiki is the output — answers get filed, not left in chat.

The authoritative schema lives in `meta/CLAUDE.md`. Read it before any operation. Skills read it at runtime, so schema changes there propagate automatically.

## Skills

Nine skills handle all workflows. Trigger them by invoking the `Skill` tool with the appropriate name:

| Skill | Trigger phrases | What it does |
|-------|----------------|--------------|
| `wiki-setup` | "set up a new project for [topic]" | Scaffolds project folder, `_overview.md`, `INDEX.md`, `QUESTIONS.md`, optional topic hub |
| `wiki-ingest` | "ingest [filename]", "ingest the inbox", "add this to the wiki" | Full 10-step ingest: read → surface → structural check → write → update → create → verify links → move file → update registries → confirm |
| `wiki-query` | "query the wiki", "what does the wiki say about X", "ask the wiki X" | 6-step query: detect scope → read scoped index → read targeted pages → synthesise and cite → write to Outputs/ → gap analysis |
| `wiki-consolidate` | "consolidate the wiki", "run a consolidation", "review the wiki for drift" | Semantic review: deduplication candidates, lifecycle promotions, synthesis opportunities — produces a proposal report, nothing changed without confirmation |
| `wiki-lint` | "run a lint", "lint the wiki", "wiki health check" | 8-check health pass using bash scripts in `skills/wiki-lint/scripts/` |
| `improve-system` | "improve-system", "audit notes", "improve that skill", "capture this experience", "mine sessions", "fill in about me" | 5-mode meta-maintenance: Audit / Skill Review / Experience / Historical Review / Foundation — detects mode from context |
| `ask-the-board` | "/ask-the-board [decision]", "what would the board say about X", "ask Nicole and Phil" | Surfaces Nicole Forsgren's and Phil Venables's perspectives on a decision in their own voice, with explicit agreements and divergences |
| `establish-advisors` | "/establish-advisors", "add a new advisor", "who else should be on the board", "who should join the board" | Reads the vault to diagnose knowledge gaps, recommends advisors whose published work addresses those gaps, ingests their 5 best pieces, and updates `ask-the-board` |
| `thinking-partner` | "let's think through X", "I'm just exploring", "thinking mode on X" | Open-ended ideation mode — hard-blocked from outlines, drafts, or wiki pages; asks sharp questions, surfaces wiki connections, and keeps a running notes log; hands off to `wiki-ingest`/`wiki-query`/drafting only on explicit signal |

## Lint scripts

**macOS / Linux** — run from the vault root:

```bash
bash skills/wiki-lint/scripts/find-orphans.sh /path/to/wiki
bash skills/wiki-lint/scripts/find-missing-pages.sh /path/to/wiki
bash skills/wiki-lint/scripts/check-index-drift.sh /path/to/wiki [projects/name]
bash skills/wiki-lint/scripts/prune-questions.sh /path/to/wiki [days_threshold]
```

**Windows 11** — PowerShell equivalents (require PowerShell 5.1+):

```powershell
powershell -File skills\wiki-lint\scripts\find-orphans.ps1 C:\path\to\wiki
powershell -File skills\wiki-lint\scripts\find-missing-pages.ps1 C:\path\to\wiki
powershell -File skills\wiki-lint\scripts\check-index-drift.ps1 C:\path\to\wiki [projects/name]
powershell -File skills\wiki-lint\scripts\prune-questions.ps1 C:\path\to\wiki [days_threshold]
```

## Folder structure

```
inbox/              ← drop sources here; moved to project sources/ after ingest
wiki/
  projects/[name]/
    _overview.md    ← goal, status, decisions log
    INDEX.md        ← scoped catalog for this project
    QUESTIONS.md    ← open threads for this project
    sources/        ← raw files + processed summary pages
  areas/            ← ongoing responsibilities (no end date)
    people/         ← one page per tracked person
  resources/
    concepts/       ← mental models and patterns
    entities/       ← named things: tools, companies, models, papers
    topics/         ← broad domain hubs with evolving theses
  INDEX.md          ← project directory + global resources catalog
  QUESTIONS.md      ← cross-project open threads
outputs/            ← query results and reports
archive/            ← completed / inactive material (searchable, never deleted)
meta/CLAUDE.md      ← schema and hard rules (read this before any operation)
CHANGELOG.md        ← running log of all operations, newest first
templates/          ← page templates for manual capture
```

## Seven page types

Defined in `meta/CLAUDE.md` Section 3. Each has required frontmatter and a fixed section structure:

1. **source** — `wiki/projects/[name]/sources/` — one per ingested source
2. **concept** — `wiki/resources/concepts/` — abstract ideas and mental models
3. **entity** — `wiki/resources/entities/` — named things (tool, company, model, paper…)
4. **topic** — `wiki/resources/topics/` — domain hub with an evolving thesis; requires explicit confirmation to create
5. **project** — `wiki/projects/[name]/_overview.md`
6. **area** — `wiki/areas/[name]/`
7. **person** — `wiki/areas/people/`

Status values: `stub` → `active` → `evergreen` → `archived`.

## Non-negotiable rules

- Every ingest must update four files: project `INDEX.md`, project `QUESTIONS.md`, root `wiki/INDEX.md`, and `CHANGELOG.md`.
- Move the raw source file from `inbox/` to `wiki/projects/[name]/sources/` after ingest.
- Every new wiki page needs at least two inbound wikilinks before an ingest is complete.
- Never create a Project, Area, or Topic hub without explicit user confirmation.
- Never delete a wiki page without explicit instruction.
- Cross-reference contradictions in both directions — do not resolve them silently.
- File naming: lowercase, hyphens (`my-concept-name.md`). No dates in filenames.
- Wikilinks use Obsidian syntax: `[[page-name]]`.

## Customisation

- **Writing style:** create `writing-rules.md` in the vault root. Claude applies it to all wiki prose (not frontmatter, navigation files, or verbatim quotes).
- **Schema changes:** edit `meta/CLAUDE.md`. Skills adapt at runtime — no skill edits needed.
- **Lint cadence:** run after every 10–15 ingests, or when the wiki feels like it's drifting.
