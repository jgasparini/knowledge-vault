---
name: wiki-lint
description: >
  Run a lint pass on the wiki. Triggers when the user says "run a lint", "lint pass",
  "lint the wiki", "check the wiki", or "wiki health check". Runs 9 structural checks,
  auto-fixes index drift, missing cross-references, and frontmatter schema violations,
  flags everything else for the user's decision, produces a standard report, and appends
  an entry to CHANGELOG.md.
  Use this after every 10–15 ingests, or whenever the wiki feels like it's drifting.
---

# Wiki Lint

## Before you start

Read `meta/CLAUDE.md` — specifically Section 2 (vault structure) and Section 3 (page types
and status values). Today's date matters for staleness checks.

### Establish lint scope

- **Project-scoped** (default): "lint [project name]" or "run a lint". Checks pages in
  the named project. Scripted checks run globally (they must — inbound links come from
  anywhere), but results are filtered to pages listed in the project INDEX.md.
- **Global**: "full lint" or "lint all projects". No filtering — all pages, all projects.

### Locate the scripts

The lint scripts live at `skills/wiki-lint/scripts/` relative to the vault root.
Determine the bash-accessible path by translating the vault path using the session mount.

---

## Execution order

Checks 1, 5, 8, and 9 are **scripted** — run the shell scripts first (they are fast and
exhaustive). Checks 2, 3, 4, 6, and 7 are **manual** — they require reading page content
and applying judgment.

Do not produce the report until all 9 checks are complete.

---

## Scripted checks (run first)

### Check 1 — Orphans [SCRIPTED]

Run:
```bash
bash skills/wiki-lint/scripts/find-orphans.sh /path/to/wiki
```

output format: `ORPHAN <inbound_count> <relative_path>` per orphan, then `SUMMARY <total> <orphan_count>`.

**If project-scoped:** filter ORPHAN results to only pages listed in the project INDEX.md.

For each orphan in scope, suggest the most natural existing page to add an inbound link from.
Do not add links silently — list orphans and wait for instruction.

---

### Check 5 — Missing pages [SCRIPTED] ⚠️ Highest priority

Run:
```bash
bash skills/wiki-lint/scripts/find-missing-pages.sh /path/to/wiki
```

output format: `MISSING <ref_count> [[link-name]]` per missing page, then `SUMMARY`.

**If project-scoped:** filter MISSING results to links that appear in project pages.

For each missing page: note the link name and reference count. Create a stub immediately —
correct frontmatter, a one-line "What it is", and at least one inbound link. Note each stub
created in CHANGELOG.md. If more than 10 missing pages are found, flag as a structural problem.

---

### Check 8 — Index drift [SCRIPTED]

Run:
```bash
bash skills/wiki-lint/scripts/check-index-drift.sh /path/to/wiki [projects/name]
```

For project-scoped lint, pass the project subdirectory as the second argument.

output format: `NOT_INDEXED <path>` and `BROKEN_ENTRY [[link]] in <index>`, then `SUMMARY`.

Both types are auto-fixes:
- **NOT_INDEXED**: add the page to the correct section of the relevant INDEX.md.
- **BROKEN_ENTRY**: remove the entry from INDEX.md.

Note total corrections in CHANGELOG.md.

---

### Check 9 — Frontmatter schema [SCRIPTED]

Run:
```bash
bash skills/wiki-lint/scripts/check-frontmatter.sh /path/to/wiki
```

output format: `BAD_FRONTMATTER <field> <value> <path>` and `MISSING_FIELD <field> <path>`
per violation, then `SUMMARY <pages_checked> <violation_count>`.

Only pages whose `type:` matches one of the seven Section 3 page types (source, concept,
entity, topic, project, area, person) are checked. Raw source files, web-clip imports with
non-schema frontmatter, and `outputs/` working docs (`type: output`/`type: query`) are out
of scope and never appear in the output.

**If project-scoped:** filter results to pages under the project's folder.

For each violation:
- **MISSING_FIELD**: a required field is absent from frontmatter. If the correct value is
  unambiguous (e.g. an `area:` field that should be `project:`), fix it directly. Otherwise
  ask the user for the value.
- **BAD_FRONTMATTER**: the field's value is not in its Section 3 enum. Propose the correct
  value. If the value represents a genuine new case, follow the closed-enum proposal-gate
  rules in `meta/CLAUDE.md` (Sections 3.1 and 3.3) before extending the enum.

Note all corrections in CHANGELOG.md.

---

## Manual checks (read content)

### Check 2 — Stubs ready to expand

Pages with `status: stub` that now have 2+ source pages referencing them. List each with
the sources that could support expansion. Do not expand silently — flag for the user's decision.

To formally propose and apply status changes, run `wiki-consolidate` after this lint pass.

---

### Check 3 — Stale active pages

Pages with `status: active` not updated since the domain-appropriate threshold has elapsed,
where a relevant source has been ingested since. The threshold is no longer flat — it depends
on how fast the page's domain moves (see `decay-rate` in `meta/CLAUDE.md` Section 3.4):

- **Topic hubs:** use the hub's own `decay-rate` — `fast` → 45 days, `slow` → 90 days,
  `stable` → 180 days. No `decay-rate` field → 30-day default.
- **Concepts and entities:** find the parent topic hub by searching `wiki/resources/topics/*.md`
  for a "Key concepts" / "Key entities" entry that links to this page (`[[page-name]]`). If
  exactly one hub links to it, use that hub's `decay-rate` (mapped as above). If no hub links
  to it, or more than one does (no clear parent), fall back to the 30-day default.
- **Everything else** (sources, projects, areas, people): 30-day default.

Check the `updated:` field in frontmatter against today's date using the resolved threshold,
then cross-reference CHANGELOG.md for relevant ingests. List which ingests were missed, and
note which threshold was applied and why (e.g. "45 days via [[ai-security]]" or "30-day
default — no parent hub found").

To formally propose and apply status changes, run `wiki-consolidate` after this lint pass.

---

### Check 4 — Contradictions without cross-references

Conflicting claims across pages that haven't been cross-referenced. This is a judgment call.
Auto-fix: add the cross-reference in both pages. Do not resolve the contradiction — just make
the tension visible. Note each fix in CHANGELOG.md.

---

### Check 6 — Archive candidates

**Projects:** pages in `wiki/projects/` with `status: complete`. Flag — do not move without
explicit instruction.

**Resources/areas:** pages with `status: active` or `status: stub` not referenced in 90+ days.
Flag with a one-sentence reason.

---

### Check 7 — QUESTIONS.md hygiene

For project-scoped lint: read `wiki/projects/[name]/QUESTIONS.md`.
For global lint: read both the project and root QUESTIONS.md files.

**Step A — Close resolved items (manual):** For each open item (`- [ ]`): check whether a wiki
page now resolves it. If yes, close it (`- [x]`) with a page reference. If it has been open
60+ days without progress, flag as stale. Note closures in CHANGELOG.md.

**Step B — Prune old closed items (scripted):** Run:

```bash
bash skills/wiki-lint/scripts/prune-questions.sh /path/to/wiki
```

Output format:
- `OVERCROWDED <closed_count> <open_count> <relpath>` — closed items outnumber open ones
- `OLD_CLOSED <count> <relpath>` — closed items with a `*raised YYYY-MM-DD*` date ≥ 30 days old

**If project-scoped:** filter results to the project QUESTIONS.md only.

For each flagged file, move all `[x]` items that triggered the flag to a `## Archive` section
at the very bottom of the file. Create the section if it doesn't exist:

```markdown
## Archive

*Resolved questions pruned from the active view.*

- [x] ...
```

Log each prune in CHANGELOG.md: `- Pruned N closed questions from [path] to Archive`.

---

## Report format

Always produce the report in this exact format:

```
## Lint pass — YYYY-MM-DD [scope: project-name or global]

**Orphans:** [n] found
- [[page]] — suggested connection: [[page]]

**Stubs ready to expand:** [n] found
- [[page]] — sources available: [[source]], [[source]]

**Stale active pages:** [n] found
- [[page]] — last updated [date], missed sources: [[source]]

**Contradictions without cross-references:** [n] found / [n] auto-fixed

**Missing pages:** [n] found — [n] stubs created
- [[link-name]] — [n] references

**Archive candidates:** [n] found
- [[page]] — reason: [one sentence]

**QUESTIONS.md hygiene:** [n] items closed, [n] stale items flagged, [n] items archived

**Index drift:** [n] entries added, [n] entries removed

**Frontmatter schema:** [n] violations found / [n] fixed
- <field> <value> in [[page]] — fix or proposal
```

If a category is clean, write `[0] found` — do not omit the category.

---

## After the report

Append one entry to `CHANGELOG.md` (newest first):

```
## YYYY-MM-DD — Lint pass [scope]
- Missing pages: [n]
- Orphans: [details or "none"]
- Stubs promoted: [details or "none"]
- QUESTIONS hygiene: [n closed, n stale, n archived — or "none"]
- Index drift: [n entries added, n removed]
- Frontmatter schema: [n violations fixed — or "none"]
```

---

Update `meta/health.md`: reset `ingest-count` to 0 and set `last-lint` to today's date.

**Trim CHANGELOG.md (archive entries older than 90 days):**

Scan `CHANGELOG.md` for entries whose date header (`## YYYY-MM-DD — …`) is more than 90
days before today. If any are found:

1. Group them by year. For each year, append those entries to
   `archive/CHANGELOG-[year].md` (create the file if it doesn't exist, with a
   `# CHANGELOG Archive — [year]` heading).
2. Remove the archived entries from `CHANGELOG.md`, preserving the header and all
   entries within the 90-day window.
3. Note the trim in the lint CHANGELOG entry already written: append
   `- CHANGELOG trimmed: [n] entries archived to archive/CHANGELOG-[year].md`

If no entries are older than 90 days, skip this step silently.

---

## Lint rules

- Run scripted checks first (1, 5, 8, 9), then manual checks (2, 3, 4, 6, 7). Report only after all 9.
- Missing pages (Check 5) are highest priority. Create stubs immediately.
- Auto-fixes (Check 4 cross-references, Check 7 QUESTIONS closures, Check 8 index drift,
  Check 9 unambiguous frontmatter fixes) are applied and noted in CHANGELOG.md.
- Everything else is flagged for the user's decision.
- If any category exceeds 10 items, flag it as a structural problem.
- The lint report is the output. Do not pad it with commentary.

---

## Portability note

Scripts live in `skills/wiki-lint/scripts/`. The vault path must be translated to the
shell-accessible mount path for the current session. The skill reads `meta/CLAUDE.md` at
runtime for schema details — if the schema changes, re-read before running checks.

**macOS / Linux:** use the `.sh` scripts via `bash`:
```bash
bash skills/wiki-lint/scripts/find-orphans.sh /path/to/wiki
bash skills/wiki-lint/scripts/find-missing-pages.sh /path/to/wiki
bash skills/wiki-lint/scripts/check-index-drift.sh /path/to/wiki [projects/name]
bash skills/wiki-lint/scripts/prune-questions.sh /path/to/wiki [days_threshold]
bash skills/wiki-lint/scripts/check-frontmatter.sh /path/to/wiki
```

**Windows 11:** use the `.ps1` equivalents via PowerShell (5.1+):
```powershell
powershell -File skills\wiki-lint\scripts\find-orphans.ps1 C:\path\to\wiki
powershell -File skills\wiki-lint\scripts\find-missing-pages.ps1 C:\path\to\wiki
powershell -File skills\wiki-lint\scripts\check-index-drift.ps1 C:\path\to\wiki projects/ai-native-engineering
powershell -File skills\wiki-lint\scripts\prune-questions.ps1 C:\path\to\wiki [days_threshold]
powershell -File skills\wiki-lint\scripts\check-frontmatter.ps1 C:\path\to\wiki
```
output format is identical — `ORPHAN`, `MISSING`, `NOT_INDEXED`, `BROKEN_ENTRY`, `BAD_FRONTMATTER`,
`MISSING_FIELD`, and `SUMMARY` lines — so the rest of the skill works unchanged on both platforms.
