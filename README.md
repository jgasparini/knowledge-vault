# Knowledge Vault

Drop sources into an inbox. Tell Claude to ingest them. Get back a structured, interlinked wiki that grows smarter with every source you add.

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
