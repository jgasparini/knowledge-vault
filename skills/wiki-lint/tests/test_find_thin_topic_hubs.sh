#!/usr/bin/env bash
# test_find_thin_topic_hubs.sh — fixture tests for find-thin-topic-hubs.sh
#
# Fixture: wiki/resources/topics/, four hubs covering each criterion:
#
#   thin-hub.md           status: stub, sources: [] (0 < 3), created 60 days
#                          ago -> THIN_HUB (all three thin-hub criteria met)
#   well-sourced-stub.md  status: stub, sources: 3 entries, created 60 days
#                          ago -> not flagged (sources count not < 3)
#   young-stub.md         status: stub, sources: [], created today
#                          -> not flagged (not yet 30 days old)
#   active-hub.md         status: active, sources: [], created 60 days ago
#                          -> not flagged (not status: stub)
#
# Total topic hubs checked: 4. Total thin: 1.
#
# A second fixture (no wiki/resources/topics/ directory at all) confirms
# SUMMARY 0 0.
#
# Vault root contains a space (F1 mandatory case).

SCRIPT="$SCRIPTS_DIR/find-thin-topic-hubs.sh"

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki/resources/topics"

today=$(date +%Y-%m-%d)
sixty_days_ago=$(date -v-60d +%Y-%m-%d 2>/dev/null || date -d "60 days ago" +%Y-%m-%d)

cat > "$wiki/resources/topics/thin-hub.md" <<EOF
---
type: topic
status: stub
created: $sixty_days_ago
updated: $sixty_days_ago
tags: []
sources: []
---

# Thin Hub

## Overview
A narrow hub that hasn't gained traction.
EOF

cat > "$wiki/resources/topics/well-sourced-stub.md" <<EOF
---
type: topic
status: stub
created: $sixty_days_ago
updated: $sixty_days_ago
tags: []
sources:
  - "[[source-a]]"
  - "[[source-b]]"
  - "[[source-c]]"
---

# Well Sourced Stub

## Overview
A stub with enough material to be worth expanding, not merging.
EOF

cat > "$wiki/resources/topics/young-stub.md" <<EOF
---
type: topic
status: stub
created: $today
updated: $today
tags: []
sources: []
---

# Young Stub

## Overview
A brand-new hub that hasn't had time to gain sources yet.
EOF

cat > "$wiki/resources/topics/active-hub.md" <<EOF
---
type: topic
status: active
created: $sixty_days_ago
updated: $sixty_days_ago
tags: []
sources: []
---

# Active Hub

## Overview
An established hub, regardless of its current source count.
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "THIN_HUB 0 60 resources/topics/thin-hub.md" "$output" \
  "find-thin-topic-hubs: flags a stub hub with <3 sources created 60 days ago"

assert_line_absent "well-sourced-stub.md" "$output" \
  "find-thin-topic-hubs: does not flag a stub hub with 3+ sources"

assert_line_absent "young-stub.md" "$output" \
  "find-thin-topic-hubs: does not flag a stub hub created less than 30 days ago"

assert_line_absent "active-hub.md" "$output" \
  "find-thin-topic-hubs: does not flag a non-stub hub regardless of sources/age"

assert_line_present "SUMMARY 4 1" "$output" \
  "find-thin-topic-hubs: summary counts 4 topic hubs checked, 1 thin (vault path contains a space)"

rm -rf "$base"

# Second fixture: no wiki/resources/topics/ directory at all.
base2=$(mktemp -d)
wiki2="$base2/wiki"
mkdir -p "$wiki2/resources/concepts"

output2=$(bash "$SCRIPT" "$wiki2")

assert_line_present "SUMMARY 0 0" "$output2" \
  "find-thin-topic-hubs: missing wiki/resources/topics/ directory yields SUMMARY 0 0"

rm -rf "$base2"
