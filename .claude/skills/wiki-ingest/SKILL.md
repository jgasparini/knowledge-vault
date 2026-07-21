---
name: wiki-ingest
description: >
  Ingest a source file into the wiki. Triggers when the user says "ingest [filename]",
  "ingest the inbox", "process this file", "add this to the wiki", or drops a file
  and asks it to be added. Also triggers when the user pastes meeting notes, an article,
  or any other content and asks it to be captured.
  Runs the full 10-step ingest workflow: read → surface → structural check → write source
  summary → update existing pages → create new pages → verify links → move source file →
  update registries → confirm.
  Use this skill for every ingest — the final registry updates are non-negotiable and
  this skill enforces them.
---

# Wiki Ingest

## Before you start

Read `meta/CLAUDE.md` in full. It contains:
- The vault's folder structure and file naming rules (Section 2)
- All seven page types and their frontmatter schemas (Section 3)
- The hard rules that govern every ingest (Section 1)

Do not proceed until you have read it. The schema there is the source of truth — not
anything hardcoded in this skill.

### Establish project or area scope

Before reading the source, determine which project or area it belongs to (either from the
user's instruction or from the Step 2 surface). Then read:

1. `wiki/projects/[name]/INDEX.md` or `wiki/areas/[name]/INDEX.md` — understand what pages
   already exist for this project or area
2. `wiki/projects/[name]/QUESTIONS.md` or `wiki/areas/[name]/QUESTIONS.md` — identify open
   questions this source might resolve

Read these two files instead of the full `wiki/INDEX.md`. This keeps context lean regardless
of how many other projects or areas exist in the vault. Only read the root `wiki/INDEX.md` if
you need to check whether a concept or entity already exists across all projects and areas.

---

## The 10-step workflow

Work through these steps in order. Do not skip ahead or compress steps together.

---

### Step 0 — Convert (if needed)

Before reading the file, check its extension. If it is `.docx`, `.pptx`, `.ppt`, `.xlsx`,
`.xls`, `.eml`, or `.msg`, run the conversion script to produce a readable `.md` file:

```bash
python .claude/skills/wiki-ingest/convert.py inbox/<filename>
```

The script prints the path of the output file (e.g. `inbox/filename.md`). Proceed with
that `.md` file in Step 1 instead of the original.

If the script exits with an error about a missing dependency, show the user the install
command it printed and stop. Do not proceed until the dependency is installed.

If the file extension is anything else (`.md`, `.txt`, `.pdf`, images, notebooks), skip
this step entirely.

For `.xlsx`, each sheet converts to a capped sample: column/row counts, the header row, and
the first 20 data rows, with a note when rows were omitted. This is deliberate — the full
sheet stays queryable from the raw file preserved in `sources/` after Step 8; the converted
`.md` is a readable preview, not a full transcription. Mention this in the Step 2 surface so
the user knows the summary is drawn from a sample, not the complete dataset. Legacy `.xls`
files are not supported — the script will tell the user to re-export as `.xlsx`.

---

### Step 0.5 — Secrets scan

Run `bash .claude/skills/secrets-detection/scripts/scan-secrets.sh <file>` (or the
`.ps1` equivalent on Windows) against the file that will be read in Step 1
(the converted `.md` if Step 0 ran, otherwise the original file).

If the scan is clean (`SUMMARY 0`), proceed to Step 1 as normal.

If the scan reports any `FINDING` lines, stop before Step 1 and present the
findings to the user (pattern name, file, line — never the matched value),
then ask them to choose:

- **Stop** — do not ingest this file. Leave it untouched in `inbox/`; nothing
  is written to the wiki. If the trigger was "ingest the inbox" (multiple
  files), continue with the next file rather than aborting the whole run.
- **Redact and continue** — run `scan-secrets.sh --redact <file>` (or
  `-Redact` on Windows), which rewrites the file in place replacing each
  match with `[REDACTED:<pattern-name>]`. Re-run the scan to confirm
  `SUMMARY 0`, then proceed to Step 1 using this redacted file — it is also
  the version that gets moved to `sources/` in the existing "move source
  file" step, so the secret never enters git history.

Like Step 0, this is a pre-step and is not counted in the "10-step ingest
workflow" described in this skill's frontmatter.

---

### Step 0.6 — PII scan

Run `bash .claude/skills/pii-detection/scripts/scan-pii.sh <file>` (or the `.ps1`
equivalent on Windows) against the file that will be read in Step 1 (the
same file Step 0.5 scanned).

If the scan is clean (`SUMMARY 0`), proceed to Step 1 as normal.

If the scan reports any `FINDING` lines, stop before Step 1 and present
the findings to the user (pattern name, file, line — never the matched
value), then ask them to choose:

- **Stop** — do not ingest this file. Leave it untouched in `inbox/`;
  nothing is written to the wiki. If the trigger was "ingest the inbox"
  (multiple files), continue with the next file rather than aborting the
  whole run.
- **Redact and continue** — run `scan-pii.sh --redact <file>` (or
  `-Redact` on Windows), which rewrites the file in place replacing each
  match with `[REDACTED:<pattern-name>]`. Re-run the scan to confirm
  `SUMMARY 0`, then proceed to Step 1 using this redacted file — it is also
  the version that gets moved to `sources/` in the existing "move source
  file" step, so the personal data never enters git history.
- **Continue without redacting** — the user has reviewed the finding(s)
  and judges them false positives or acceptable; proceed to Step 1 using
  the file unchanged.

Like Step 0 and Step 0.5, this is a pre-step and is not counted in the
"10-step ingest workflow" described in this skill's frontmatter. It runs
as a separate step after the secrets scan, rather than being merged into
one combined report, because the two scans offer different action sets
(secrets: stop/redact only; PII: stop/redact/continue).

---

### Step 1 — Read

Read the source file in full. No output yet. If the file is unreadable (corrupt, wrong
format, empty), stop and tell the user.

If "ingest the inbox" was the trigger, list all files in `inbox/` and identify which have
not yet been ingested by checking whether a matching raw source file already exists anywhere
in `wiki/**/sources/`. A file is already ingested if its filename appears in any sources/
folder. Do not use CHANGELOG.md for this check — it grows unbounded and is unreliable for
large vaults. Process one file at a time unless instructed otherwise.

---

### Step 2 — Surface

Present a brief of the source to the user before writing anything:
- One paragraph: what the source argues or covers
- 3–5 bullet points: the most significant insights it contains

This is a conversation, not a filing action. The user may redirect:
- "Focus on X, not Y"
- "That second point is the most important — build around that"
- "Skip the intro, we already have that"

Wait for the user's response before continuing. If the source is low-signal (nothing new,
no connections to existing wiki), say so clearly. The user may choose not to ingest it.

---

### Step 3 — Structural check

Scan the source against the existing wiki. Before writing any pages, flag:

- **New Project** — does this source suggest work with a goal and owner that doesn't map
  to an existing project?
- **New Topic hub** — does this source introduce a domain broad enough to warrant its own
  hub? Per `meta/CLAUDE.md` Section 3.4, prefer broadening an existing hub's scope over
  creating a new narrow one — check whether an existing hub could reasonably absorb this
  material before proposing a new one.
- **New Area** — does this source relate to an ongoing responsibility not yet captured?

If any of these apply, name them explicitly and ask the user to confirm before proceeding.
Do not create Projects, Areas, or Topic hubs silently.

Example:
> "This source suggests a new Topic hub might be warranted: *Retrieval-Augmented Generation*.
> Shall I create it, or file this under an existing topic?"

If none apply, state that and move on.

---

### Step 4 — Write source summary page

Create one source summary page in `wiki/projects/[name]/sources/` using the schema from
`meta/CLAUDE.md` Section 3.1.

Filename: descriptive kebab-case slug from the source title.
Example: `my-source-title-2025.md`

The page must include:
- Frontmatter with `type: source`, `status: processed`, today's date, `origin:` (URL or
  inbox filename), `project:` field, `source-type:` set to the genre of the original
  work per `meta/CLAUDE.md` Section 3.1 (e.g. `article`, `paper`, `report`,
  `book-chapter`, `meeting`, `email`, `letter`, `video`), and `reliability:` set
  according to source credibility (see Section 3.1 for the four values and decision
  rules). `source-type` is a closed enum — if no value fits, stop and propose a new
  one to the user rather than coining a value silently.
- Summary (one paragraph)
- Key insights (3–7 bullets, distilled signal not paraphrase)
- Contradictions or tensions (cross-reference any conflicts with existing wiki pages — in
  both directions)
- Pages updated (list, filled in after Steps 5–6)
- Raw source (wikilink to file path in project sources/)

---

### Step 5 — Update existing wiki pages

Before writing, list every wiki page you intend to update and why. The user can redirect
at this point.

Then update:
- **Concept pages** — deepen definitions, add examples from this source, update open
  questions, cross-reference any contradictions
- **Entity pages** — add or revise facts, update source references
- **Topic hubs** — update the evolving thesis to reflect what this source adds, changes,
  or challenges. The evolving thesis is the most valuable part of a topic hub — update it
  with a genuine point of view, not a summary
- **Project overviews** — if the source is scoped to an active project, update current
  status or decisions log

Every new wiki page created in Step 6 must have at least two inbound links from existing
pages before the ingest is complete. Create those links during this step.

---

### Step 6 — Create new pages if needed

For each new concept, entity, or (confirmed) topic hub or project: create the page using
the appropriate schema from `meta/CLAUDE.md` Section 3.

Stubs are acceptable — a thin page with two inbound links is better than no page.
Mark new pages with `status: stub` unless the source provides enough to go active.

---

### Step 7 — Verify inbound links

Check that every page created in Step 6 has at least two inbound wikilinks from existing
pages. If any page is short, add the missing links now (to the most natural existing pages).
Note any pages you couldn't link naturally — these are orphan candidates for the next lint
pass.

---

### Step 8 — Move source file ⚠️ Non-negotiable

Move the raw source file from `inbox/` to `wiki/projects/[name]/sources/` (same folder as
the processed summary). Then update the **Raw source** section of the summary page to
reflect the new path.

If the source was provided inline (pasted text, meeting notes not saved as a file), note
this in the Raw source section — no file to move.

---

### Step 9 — Update registries ⚠️ Non-negotiable

Five files must be updated after every ingest, no exceptions.

**`wiki/projects/[name]/INDEX.md` or `wiki/areas/[name]/INDEX.md`**
Add a row for every new source, concept, or entity created. Add to the correct section.

**`wiki/projects/[name]/QUESTIONS.md` or `wiki/areas/[name]/QUESTIONS.md`**
Close any items resolved by this ingest (`- [ ]` → `- [x]` with a page reference).
Add any new questions or gaps surfaced during ingestion.

**`wiki/INDEX.md`**
Add any new concepts or entities to the Global Resources section. Add the project or area
row if this is the first ingest for a new project or area.

**`CHANGELOG.md`**
Prepend one new entry at the top (newest first):

```
## YYYY-MM-DD — Ingest | [Source title]
- Pages created: [list, or "none"]
- Pages updated: [list]
- Structural suggestions: [none, or brief note]
- Contradictions cross-referenced: [none, or brief note]
- Note: [source provided inline / file moved from inbox/]
```

**`meta/health.md`**
Read the file. Increment both `ingest-count` and `consolidation-count` by 1 and write the
updated values back.

Then check thresholds, in this priority order, and emit at most one nudge at the end of
Step 9 before continuing to Step 10:

1. If `ingest-count` is now 15 or more, emit:

   > ⚠️ *`ingest-count` ingests since last lint — consider running `wiki-lint` before the next ingest.*

2. Otherwise, if `consolidation-count` is now 30 or more, emit:

   > ⚠️ *`consolidation-count` ingests since last consolidation — consider running `wiki-consolidate`.*

The lint nudge always wins when both thresholds are crossed at once — do not emit both.
Lint is the cheaper, faster pass and a natural prerequisite for a clean consolidation, and
because the consolidation threshold (30) is roughly double the lint threshold (15), by the
time consolidation is due the lint counter will already be significantly overdue. This
ordering is deliberate; do not reintroduce a double-nudge.

If you reach the end of the workflow and have not updated all five files, go back and do
it before confirming. Do not confirm without completing this step.

---

### Step 10 — Confirm

Provide a one-paragraph completion summary:
- What was ingested
- Pages created and updated
- Any open structural suggestions (from Step 3)
- Any contradictions cross-referenced
- Any orphan risks (pages that only got one inbound link)

---

## Hard rules

- Never write wiki pages before Step 2 is complete and the user has had a chance to redirect.
- Never create a Project, Area, or Topic hub without explicit confirmation in Step 3.
- Every source must produce at minimum: one source summary page, two updated or created wiki
  pages, the raw file moved (or noted as inline), and registry entries in all five files.
- When a source contradicts an existing wiki page, cross-reference the tension in both pages.
  Do not resolve contradictions silently. Let them coexist.
- Step 9 (registries) is always the penultimate step. Confirm (Step 10) only after all
  registries are updated and the source file has been moved.

---

## Portability note

This skill reads the vault schema from `meta/CLAUDE.md` at runtime. It does not hardcode
page types, folder paths, or frontmatter fields. If the vault schema changes, this skill
adapts automatically.
