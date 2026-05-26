# README Rewrite — Design Spec

**Date:** 2026-05-26
**Goal:** Make the README easy for general (non-developer) users to set up and use Knowledge Vault.

---

## Context

The current README is written for users who already know Claude Code. It leads with abstract philosophy and folder structure before the reader has done anything. General users need a quick win first.

---

## Decisions

- **Structure:** Tutorial-first, reference-second (Option A)
- **Example domain:** "You want to start researching AI tools"
- **Target reader:** General users; no assumption of git expertise or CLI familiarity

---

## Structure

```
1. One-liner hook
2. Prerequisites (short checklist)
3. Tutorial: "Let's research AI tools"
   a. Get the vault
   b. Open in Obsidian
   c. Connect Claude
   d. Set up your first project
   e. Add a source
   f. Ingest it
   g. Ask a question
   h. Run a health check (optional)
4. Reference
   - Folder structure
   - Skills & trigger phrases
   - Customising for your domain
   - Lint cadence
   - Contributing / Licence
```

---

## Tutorial Step Detail

Each step follows the same three-part rhythm:
**what you do → exactly what to say to Claude → what happens**

### a. Get the vault
Two paths: `git clone` for developers, Download ZIP for everyone else.

### b. Open in Obsidian
One sentence on what Obsidian is for. Step: File → Open folder as vault → select `knowledge-vault`.

### c. Connect Claude
Two paths side by side:
- Claude Cowork (desktop): connect the folder
- Claude Code (terminal): `cd` into it

### d. Set up your first project
Exact phrase: *"Set up a new project for AI tools research"*
Show example answers to Claude's questions (name, goal, domain, review date).
Show what gets created.

### e. Add a source
Drop any readable file into `inbox/`. Examples: saved article about GPT-4, PDF of an AI paper, personal notes.

### f. Ingest it
Exact phrase: *"Ingest the inbox"*
Brief description of what Claude does. Show what lands in the wiki.

### g. Ask a question
Three examples:
- *"What do I know about retrieval-augmented generation?"*
- *"What's the tension between GPT-4 and Claude on reasoning tasks?"*
- *"What should I read next to fill the gap on AI agents?"*

Show that answers land in `Outputs/` and Claude offers to promote to a wiki page.

### h. Run a health check (optional)
After 10–15 ingests, say *"Lint the wiki"*. One line on what it does.

---

## Reference Section

Carries over from the current README but trimmed:
- Folder structure diagram
- Skills table (name, trigger phrase, what it does)
- Customising (writing-rules.md, schema changes)
- Lint cadence
- Contributing / Licence
