#!/usr/bin/env bash
# test_find_duplicate_candidates.sh — fixture tests for find-duplicate-candidates.sh
#
# Fixture: wiki/resources/{concepts,entities,topics}/, each scoped independently.
#
# concepts/:
#   agent-memory.md           (type: concept, tokens: agent, memory)
#   agent-memory-taxonomy.md  (type: concept, tokens: agent, memory, taxonomy)
#     -> shares 2 tokens {agent, memory} with agent-memory.md -> CANDIDATE
#   model-context.md          (type: concept, tokens: model, context)
#   context-window.md         (type: concept, tokens: context, window)
#     -> shares 1 token {context} with model-context.md -> no CANDIDATE
#   agent-memory-notes.md     (no frontmatter, raw file -- excluded entirely)
#
# entities/:
#   agent-memory.md (type: entity, tokens: agent, memory)
#     -> shares 2 tokens with concepts/agent-memory*.md, but cross-directory
#        pairs are never compared -> no CANDIDATE
#
# topics/:
#   ai-security.md (type: topic, tokens: ai, security)
#
# Total content pages checked: 4 (concepts) + 1 (entity) + 1 (topic) = 6
# Total candidates: 1
#
# Vault root contains a space (F1 mandatory case).

SCRIPT="$SCRIPTS_DIR/find-duplicate-candidates.sh"

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki/resources/concepts" "$wiki/resources/entities" "$wiki/resources/topics"

cat > "$wiki/resources/concepts/agent-memory.md" <<'EOF'
---
type: concept
status: active
created: 2026-06-01
updated: 2026-06-01
tags: []
sources: []
---

# Agent Memory

## What it is
How agents persist information across steps.
EOF

cat > "$wiki/resources/concepts/agent-memory-taxonomy.md" <<'EOF'
---
type: concept
status: active
created: 2026-06-01
updated: 2026-06-01
tags: []
sources: []
---

# Agent Memory Taxonomy

## What it is
A classification of agent memory types.
EOF

cat > "$wiki/resources/concepts/model-context.md" <<'EOF'
---
type: concept
status: active
created: 2026-06-01
updated: 2026-06-01
tags: []
sources: []
---

# Model Context

## What it is
The information available to a model at inference time.
EOF

cat > "$wiki/resources/concepts/context-window.md" <<'EOF'
---
type: concept
status: active
created: 2026-06-01
updated: 2026-06-01
tags: []
sources: []
---

# Context Window

## What it is
The maximum span of tokens a model can attend to at once.
EOF

cat > "$wiki/resources/concepts/agent-memory-notes.md" <<'EOF'
Raw notes, no frontmatter. Not a content page.
EOF

cat > "$wiki/resources/entities/agent-memory.md" <<'EOF'
---
type: entity
entity-kind: tool
status: active
created: 2026-06-01
updated: 2026-06-01
tags: []
sources: []
---

# Agent Memory

## What it is
A product named Agent Memory, unrelated to the concept of the same name.
EOF

cat > "$wiki/resources/topics/ai-security.md" <<'EOF'
---
type: topic
status: active
created: 2026-06-01
updated: 2026-06-01
tags: []
sources: []
---

# AI Security

## Overview
Security considerations for AI systems.
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "CANDIDATE concept resources/concepts/agent-memory-taxonomy.md resources/concepts/agent-memory.md agent,memory" "$output" \
  "find-duplicate-candidates: agent-memory.md and agent-memory-taxonomy.md share 2 tokens (agent, memory)"

assert_line_absent "resources/concepts/context-window.md resources/concepts/model-context.md" "$output" \
  "find-duplicate-candidates: context-window.md and model-context.md share only 1 token (context), not flagged"

assert_line_absent "resources/entities/agent-memory.md" "$output" \
  "find-duplicate-candidates: a concept and an entity sharing 2+ tokens are not compared (cross-type)"

assert_line_absent "agent-memory-notes.md" "$output" \
  "find-duplicate-candidates: a file with no frontmatter is excluded entirely"

assert_line_present "SUMMARY 6 1" "$output" \
  "find-duplicate-candidates: summary counts 6 content pages checked, 1 candidate pair found"

rm -rf "$base"
