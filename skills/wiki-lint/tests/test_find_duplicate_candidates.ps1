#Requires -Version 5.1
# test_find_duplicate_candidates.ps1 — fixture tests for find-duplicate-candidates.ps1
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

$Script = Join-Path $ScriptsDir "find-duplicate-candidates.ps1"

$base = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$wiki = Join-Path $base "audit vault\wiki"
New-Item -ItemType Directory -Path (Join-Path $wiki "resources\concepts") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $wiki "resources\entities") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $wiki "resources\topics") -Force | Out-Null

Set-Content -Path (Join-Path $wiki "resources\concepts\agent-memory.md") -Encoding UTF8 -Value @'
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
'@

Set-Content -Path (Join-Path $wiki "resources\concepts\agent-memory-taxonomy.md") -Encoding UTF8 -Value @'
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
'@

Set-Content -Path (Join-Path $wiki "resources\concepts\model-context.md") -Encoding UTF8 -Value @'
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
'@

Set-Content -Path (Join-Path $wiki "resources\concepts\context-window.md") -Encoding UTF8 -Value @'
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
'@

Set-Content -Path (Join-Path $wiki "resources\concepts\agent-memory-notes.md") -Encoding UTF8 -Value @'
Raw notes, no frontmatter. Not a content page.
'@

Set-Content -Path (Join-Path $wiki "resources\entities\agent-memory.md") -Encoding UTF8 -Value @'
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
'@

Set-Content -Path (Join-Path $wiki "resources\topics\ai-security.md") -Encoding UTF8 -Value @'
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
'@

$output = (& $Script $wiki | Out-String)

Assert-LinePresent "CANDIDATE concept resources/concepts/agent-memory-taxonomy.md resources/concepts/agent-memory.md agent,memory" $output `
  "find-duplicate-candidates: agent-memory.md and agent-memory-taxonomy.md share 2 tokens (agent, memory)"

Assert-LineAbsent "resources/concepts/context-window.md resources/concepts/model-context.md" $output `
  "find-duplicate-candidates: context-window.md and model-context.md share only 1 token (context), not flagged"

Assert-LineAbsent "resources/entities/agent-memory.md" $output `
  "find-duplicate-candidates: a concept and an entity sharing 2+ tokens are not compared (cross-type)"

Assert-LineAbsent "agent-memory-notes.md" $output `
  "find-duplicate-candidates: a file with no frontmatter is excluded entirely"

Assert-LinePresent "SUMMARY 6 1" $output `
  "find-duplicate-candidates: summary counts 6 content pages checked, 1 candidate pair found"

Remove-Item -Recurse -Force $base
