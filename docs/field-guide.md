# Field guide — frontmatter reference

All permitted values for every frontmatter field across the three note types.

---

## Shared fields (all note types)

| Field | Description | Values |
|-------|-------------|--------|
| `date` | Creation date | YYYY-MM-DD — auto-populated by Templater |
| `type` | Note type | See type values below |
| `status` | Processing state | See status values below |
| `tags` | Searchable topics | Array of strings — see tagging rules below |
| `para` | PARA destination | `projects` / `areas` / `resources` / `archive` |
| `project` | Project name | Free text — only populate if `para: projects` |
| `source` | Origin of the note | URL, book title, person name, meeting name |

---

## type values

| Value | Use for |
|-------|---------|
| `note` | General notes that do not fit another type |
| `meeting` | Notes from a meeting or call |
| `article` | Web article or blog post |
| `book` | Book notes or highlights |
| `idea` | Your own thinking — not sourced from elsewhere |
| `reference` | Technical or factual reference material |
| `person` | Contact or person note |
| `project` | Project index note |

---

## status values

| Value | Meaning |
|-------|---------|
| `inbox` | Captured but not yet processed — Claude has not seen it |
| `processed` | Claude has filed it — frontmatter is complete |
| `evergreen` | High-value note — reviewed and refined, worth revisiting |
| `archived` | No longer active — moved to 04-archive |

---

## para values and decision rules

| Value | Use when |
|-------|----------|
| `projects` | Active work with a clear goal, deadline, and owner |
| `areas` | Ongoing responsibility with no end date (a domain, a relationship, a habit) |
| `resources` | Reference material you may want to retrieve later, regardless of project |
| `archive` | Completed, inactive, or low-signal — keep but do not maintain |

**Decision rule when in doubt:**
- Projects vs Areas → does it have a deadline? Projects. No deadline? Areas.
- Areas vs Resources → are you responsible for maintaining it? Areas. Just want it findable? Resources.
- Anything vs Archive → has it been inactive for 90+ days with no likely future use? Archive.

---

## Person note fields

| Field | Description | Values |
|-------|-------------|--------|
| `organisation` | Where they work | Free text |
| `role` | Their title or function | Free text |
| `relationship` | Nature of the relationship | `colleague` / `stakeholder` / `external` / `vendor` / `peer` |
| `last-contact` | Date of last meaningful interaction | YYYY-MM-DD — update manually |

---

## Project note fields

| Field | Description | Values |
|-------|-------------|--------|
| `goal` | One-sentence definition of done | Free text |
| `deadline` | Hard deadline | YYYY-MM-DD |
| `stakeholders` | Array of people involved | Array of strings |
| `review-date` | When to next review this project | YYYY-MM-DD — set 14 days out |

---

## Tagging rules

- Use lowercase, hyphenated tags: `#data-platform` not `#DataPlatform`
- Prefer specific over generic: `#sla` not `#work`
- Aim for 3–6 tags per note
- Claude will suggest tags at triage — accept or override, but be consistent
- Review your tag list quarterly and merge near-duplicates
- Do not tag by PARA folder — that is what the `para` field is for
