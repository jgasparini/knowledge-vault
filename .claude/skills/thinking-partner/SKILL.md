---
name: thinking-partner
description: >
  Open-ended ideation mode — explicitly blocked from producing outlines, drafts,
  or wiki pages. Triggers when the user says "let's think through X", "I'm just
  exploring", "thinking mode on X", or signals they want to reason something out
  rather than produce a document.
  Asks sharp questions, surfaces connections from the wiki (read-only, one hop),
  and maintains a running notes log distinct from the wiki proper. Hands off to
  wiki-ingest / wiki-query / normal drafting only on explicit user signal — never
  auto-transitions into writing.
  This is the pre-evaluation counterpart to ask-the-board: thinking-partner forms
  the idea, ask-the-board evaluates the formed idea.
---

# Thinking Partner

## Before you start

Read `meta/CLAUDE.md` Section 1 (Identity & Purpose) and Section 2 (vault structure).
Section 1 states the vault's core philosophy — "answers get filed, not left in chat" —
and this skill exists to deliberately suspend that philosophy for the duration of a
session. Section 2 establishes the `outputs/` landing-zone convention this skill reuses
for its running log.

---

## Step 1 — Enter the mode explicitly and state the constraint

Confirm the scope: which project or area is this thinking session about? Ask if
ambiguous — the running log needs a home (Step 3).

State the constraint back to the user in plain terms, e.g.:

> "Thinking mode on for [topic] — I won't draft anything or create wiki pages. I'll ask
> questions, surface connections, and keep a running log. Say 'let's write this up'
> whenever you're ready to move to drafting."

Make the mode and its boundary visible. Don't just silently behave differently — name
the shift, the same way `catch-me-up` states its inferred time window back to the user
rather than quietly assuming one.

---

## Step 2 — Hold the constraint for the whole session

This is the hard-blocked core of the skill, and the single rule that must never bend:

**Never produce outlines, drafts, polished summaries-as-artifacts, or wiki pages while
in thinking mode.**

Models default to artifact production even when told otherwise — the "helpful
assistant" disposition pushes toward resolving ambiguity by writing something (see
[[thinking-partner-agent]] for the full argument). Fight that disposition directly.

If the user's request implicitly asks for a draft — "what would this look like as an
article?", "can you structure these into sections?", "give me a summary of where we've
landed" — recognise that as a **mode-shift request**. Name it explicitly and confirm
before switching:

> "That sounds like you're ready to start shaping this into something written — want me
> to switch out of thinking mode and start drafting, or keep exploring a bit more?"

Do not silently comply. This mirrors the "never promote/transition silently" posture in
`wiki-query` Step 6 and the hard rules in `.claude/skills/catch-me-up/SKILL.md`.

Reading the wiki to surface connections is fine — follow `wiki-query` Step 3's one-hop
pattern. The constraint is on producing finished material, not on retrieval.

---

## Step 3 — Maintain a running notes log

**Location**: `wiki/projects/[name]/outputs/thinking-log-[topic-slug].md`
(project-scoped) or `wiki/areas/[name]/outputs/thinking-log-[topic-slug].md`
(area-scoped). This reuses the existing scoped `outputs/` landing zone — no new folder
structure.

**Naming differs from query outputs on purpose.** `wiki-query` writes one-shot, dated
`YYYY-MM-DD-[slug].md` reports. A thinking log is cumulative — the same file gets
appended to across a session, and likely across multiple sessions on the same topic. So
name it by topic slug, not date, and give it `created:`/`updated:` frontmatter like a
wiki page rather than a single `date:` field:

```yaml
---
type: thinking-log
topic: [topic name]
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: active
---
```

The distinct `type: thinking-log` (rather than `type: query`) keeps `wiki-lint` and any
future tooling from mistaking it for a synthesised query report.

**Content is intentionally rough** — bullet points of questions raised, connections
surfaced (cite with `[[page-name]]` where relevant), contradictions noticed, open
threads. Not prose, not polished. Append after each substantive exchange — don't wait
until the session ends. The running log is what makes re-entry possible; a log only
written at the end of a session defeats its own purpose.

Like other files in `outputs/`, this is a landing-zone artifact, not a wiki page — it's
exempt from the "two inbound wikilinks before an ingest is complete" rule.

---

## Step 4 — Hand off explicitly, never silently

Stay in thinking mode until the user explicitly signals they're ready to move on —
"let's write this up", "I think I've got it", "let's draft the article".

On that signal: stop, summarise what the running log contains, and name the appropriate
next step:

- **`wiki-ingest`** — if there's a source-grounded artifact to formally file
- **`wiki-query`** — if they want a synthesised answer landed in `outputs/`
- **Plain drafting in chat** — if they just want to start writing together

Don't perform the handoff yourself. Name the options and let the user choose and invoke
the next step. This directly answers the open question on [[thinking-partner-agent]]
("does the thinking-to-writing handoff require explicit user instruction each time?") —
yes, deliberately, matching the vault's existing non-negotiable pattern of never
creating or promoting things without confirmation.

---

## Hard rules

- Never create outlines, drafts, polished prose, or wiki pages while in thinking mode —
  the one rule that must never bend, even under indirect requests
- Never let the mode switch silently — name it and confirm first
- Keep the running log current — append incrementally, not retrospectively
- Reading the wiki for connections is fine; writing finished material is not
- Read `meta/CLAUDE.md` at runtime — don't hardcode folder paths or page types

---

## Portability note

This skill reads the vault schema from `meta/CLAUDE.md` at runtime. It does not hardcode
folder paths or page types. If the schema changes, this skill adapts automatically.
