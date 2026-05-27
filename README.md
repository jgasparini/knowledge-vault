# Knowledge Vault

Drop sources into an inbox. Tell Claude to ingest them. Get back a structured, interlinked wiki that grows smarter with every source you add.

There's real appeal to using Claude and Obsidian as a long-term memory system — until the vault grows large enough that retrieval slows, context windows fill, and the thing you built to help you think starts working against you. The problem is that most approaches have no mechanism for things to stop mattering. This one uses the PARA method as a built-in lifecycle: projects have goals and end dates, completed work archives, and the active surface stays manageable no matter how long you've been running. Crucially, archiving a project doesn't bury the knowledge it generated — concepts and entities live in a shared graph that every future project draws on.

---

## Prerequisites

- [Obsidian](https://obsidian.md) (free) — for reading and navigating your wiki
- A Claude account — [Claude.ai](https://claude.ai) for the desktop app, or [Claude Code](https://claude.ai/code) for the terminal
- Git — only needed if you use the clone option below; otherwise use Download ZIP

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

### 7. Ask a question

Once you've ingested a few sources, start asking:

> **"What do I know about retrieval-augmented generation?"**
>
> **"What's the tension between GPT-4 and Claude on reasoning tasks?"**
>
> **"What should I read next to fill the gap on AI agents?"**

Claude reads your wiki, synthesises an answer from what's actually in there, and files it in the `outputs/` folder closest to the query's scope:

| Query scope | output lands in |
|-------------|-----------------|
| About a specific project | `wiki/projects/[name]/outputs/` |
| About an area | `wiki/areas/[name]/outputs/` |
| About a concept, entity, or topic | `wiki/resources/outputs/` |
| Cross-cutting or ambiguous | root `outputs/` |

This keeps your query history co-located with the material it draws on, so patterns and compounding insights are easy to spot over time. If the answer is substantial enough to become a permanent wiki page, Claude will ask before promoting it.

### 8. Run a health check *(after 10–15 ingests)*

Tell Claude:

> **"Lint the wiki"**

Claude runs 8 structural checks — orphan pages, missing wikilinks, stale content, index drift, and more. It auto-fixes what it safely can and flags everything else for your decision. The checks run as bash scripts rather than Claude reading files directly: scripts execute in milliseconds with zero token cost, and are deterministic — they won't miss a broken link or vary between runs.

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
    projects/
      [name]/         ← one folder per active research project
        outputs/      ← query results scoped to this project
    areas/
      [name]/         ← ongoing responsibilities (no end date)
        outputs/      ← query results scoped to this area
    resources/
      concepts/       ← mental models and patterns
      entities/       ← tools, companies, models, papers
      topics/         ← broad domain hubs with evolving theses
      outputs/        ← query results scoped to concepts/entities/topics
    INDEX.md          ← project directory + global resource catalog
    QUESTIONS.md      ← cross-project open questions
  outputs/            ← cross-cutting query results and reports
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
