# README Rewrite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite README.md as a tutorial-first document that takes a general (non-developer) user from zero to their first ingested source, using "researching AI tools" as the worked example.

**Architecture:** Replace the current README.md in full. Structure is: one-liner hook → prerequisites → 8-step tutorial → reference section. Each tutorial step follows the rhythm: what you do → exact phrase to say to Claude → what happens.

**Tech Stack:** Markdown only. No code changes. No dependencies.

---

## File Map

| Action | File |
|--------|------|
| Overwrite | `README.md` |

---

## Task 1: Hook and prerequisites

**Files:**
- Modify: `README.md` (replace entire file, starting fresh)

- [ ] **Step 1: Write the hook and prerequisites block**

Replace the entire contents of `README.md` with:

```markdown
# Knowledge Vault

Drop sources into an inbox. Tell Claude to ingest them. Get back a structured, interlinked wiki that grows smarter with every source you add.

---

## Prerequisites

- [Obsidian](https://obsidian.md) (free) — for reading and navigating your wiki
- A Claude account — [Claude.ai](https://claude.ai) for the desktop app, or [Claude Code](https://claude.ai/code) for the terminal
- Git — only needed if you use the clone option below; otherwise use Download ZIP
```

- [ ] **Step 2: Gut-check**

Read the hook aloud. Ask: would a non-technical person understand what this tool does from those two sentences? If not, rewrite until the answer is yes.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: rewrite README — hook and prerequisites"
```

---

## Task 2: Tutorial steps 1–3 (get the vault, open Obsidian, connect Claude)

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Append the tutorial header and steps 1–3**

Append to `README.md`:

```markdown
---

## Walkthrough: researching AI tools

Let's say you want to build a knowledge base about AI tools, models, and techniques. Here's how to go from zero to your first ingested source.

### 1. Get the vault

**Option A — Download (no git required):**
Go to the repository page → click **Code** → **Download ZIP** → unzip it somewhere you'll remember.

**Option B — Clone:**
```bash
git clone https://github.com/your-username/knowledge-vault.git
```

### 2. Open in Obsidian

[Download Obsidian](https://obsidian.md) if you don't have it. It's free.

Open Obsidian → **Open folder as vault** → select the `knowledge-vault` folder.

You'll see the folder structure in the left sidebar. You don't need to understand it yet — Claude maintains it for you.

### 3. Connect Claude

**Using Claude.ai (desktop):**
Open [claude.ai](https://claude.ai), start a new conversation, and connect the `knowledge-vault` folder when prompted.

**Using Claude Code (terminal):**
```bash
cd path/to/knowledge-vault
claude
```
```

- [ ] **Step 2: Gut-check**

Read steps 1–3 as if you've never used Claude or Obsidian. Is every click or command specified? If a step assumes knowledge a general user might not have, add one clarifying sentence.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add tutorial steps 1-3 (setup)"
```

---

## Task 3: Tutorial steps 4–6 (set up project, add source, ingest)

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Append tutorial steps 4–6**

Append to `README.md`:

```markdown
### 4. Set up your project

Tell Claude:

> **"Set up a new project for AI tools research"**

Claude will ask you four questions:

| Question | Example answer |
|----------|----------------|
| Project name | `ai-tools-research` |
| Goal (one sentence) | Build a working knowledge base of AI tools, models, and techniques |
| Domain / topic | artificial intelligence |
| Review date | *(leave blank, or pick a date)* |

When you're done, Claude creates `wiki/projects/ai-tools-research/` with everything it needs to start tracking your research.

### 5. Add a source

Drop any file into the `inbox/` folder. It can be:

- A PDF paper you downloaded
- A saved article (as Markdown or plain text)
- Notes you've already written
- A web clip saved as a file

Claude can read PDF, Markdown, and plain text files.

### 6. Ingest it

Tell Claude:

> **"Ingest the inbox"**

Claude reads the source, pulls out the key insights, creates a source summary page, updates any related concept and entity pages, files everything in the right place, and updates the index and changelog. You don't need to do anything.

When it's done, you'll see a new page in `wiki/projects/ai-tools-research/sources/` and a fresh entry in `CHANGELOG.md`.
```

- [ ] **Step 2: Gut-check**

Check that step 4 makes clear that Claude asks the questions interactively — the user doesn't fill in a config file. Check that steps 5 and 6 together make it obvious: drop file → say phrase → wiki is updated.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add tutorial steps 4-6 (first ingest)"
```

---

## Task 4: Tutorial steps 7–8 (ask a question, health check)

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Append tutorial steps 7–8**

Append to `README.md`:

```markdown
### 7. Ask a question

Once you've ingested a few sources, start asking:

> **"What do I know about retrieval-augmented generation?"**
> **"What's the tension between GPT-4 and Claude on reasoning tasks?"**
> **"What should I read next to fill the gap on AI agents?"**

Claude reads your wiki, synthesises an answer from what's actually in there, and files it in `Outputs/`. If the answer is substantial enough to become a permanent wiki page, Claude will ask before promoting it.

### 8. Run a health check *(after 10–15 ingests)*

Tell Claude:

> **"Lint the wiki"**

Claude runs 8 structural checks — orphan pages, missing wikilinks, stale content, index drift, and more. It auto-fixes what it safely can and flags everything else for your decision.
```

- [ ] **Step 2: Gut-check**

Read steps 7–8 cold. Is it clear that step 7 answers come from the wiki (not Claude's training data)? Is it clear that step 8 is optional and periodic, not something to do every time?

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add tutorial steps 7-8 (queries and lint)"
```

---

## Task 5: Reference section

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Append the reference section**

Append to `README.md`:

```markdown
---

## Reference

### Skills

These are the phrases that trigger Claude's built-in workflows:

| Skill | What to say | What it does |
|-------|-------------|--------------|
| `wiki-setup` | "Set up a new project for [topic]" | Scaffolds the project folder, index, and navigation files |
| `wiki-ingest` | "Ingest the inbox" or "Ingest [filename]" | Full 10-step ingest: read → extract insights → write pages → update registries |
| `wiki-lint` | "Lint the wiki" or "Wiki health check" | 8-check structural health pass with auto-fixes |
| `writing-rules` | *(applied automatically)* | House style guide — applied to all wiki prose |

### Folder structure

```
knowledge-vault/
  inbox/              ← drop sources here
  wiki/
    projects/         ← one folder per active research project
    areas/            ← ongoing responsibilities (no end date)
    resources/
      concepts/       ← mental models and patterns
      entities/       ← tools, companies, models, papers
      topics/         ← broad domain hubs with evolving theses
    INDEX.md          ← project directory + global resource catalog
    QUESTIONS.md      ← cross-project open questions
  Outputs/            ← query results and reports
  archive/            ← completed or inactive material
  meta/
    CLAUDE.md         ← schema and rules (Claude reads this on every operation)
  CHANGELOG.md        ← log of every ingest, lint pass, and restructure
  templates/          ← page templates for manual capture
```

### Customising for your domain

**Writing style:** create a `writing-rules.md` file in the vault root. Claude applies it to all wiki prose, layered on top of the built-in style guide in `skills/writing-rules/`.

**Schema changes:** edit `meta/CLAUDE.md`. The skills read it at runtime — if the schema changes there, the skills adapt automatically. You never need to edit the skills directly.

---

## Contributing

Pull requests welcome. If you've adapted the schema for a specific domain (legal research, competitive intelligence, engineering architecture), consider sharing it as a branch or fork.

## Licence

MIT
```

- [ ] **Step 2: Gut-check**

Check the skills table includes all four skills (wiki-setup, wiki-ingest, wiki-lint, writing-rules). Check the folder structure matches the actual repo layout. Check the customisation note correctly describes both writing-rules.md (root, domain-specific) and skills/writing-rules/ (built-in default).

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add reference section — skills, folder structure, customisation"
```

---

## Task 6: Final proofread

**Files:**
- Modify: `README.md` (fixes only)

- [ ] **Step 1: Read the full README top to bottom**

Open `README.md` and read it as a first-time user. Check for:
- Any section that assumes knowledge introduced later
- Any step that says what to do without saying how
- Any exact Claude phrase missing its quote block
- Tone: does it sound like a person wrote it, or like documentation?

- [ ] **Step 2: Fix any issues found**

Make targeted edits only. Do not restructure unless a section is genuinely broken.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: proofread README — final fixes"
```
