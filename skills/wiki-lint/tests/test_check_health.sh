#!/usr/bin/env bash
# test_check_health.sh — fixture tests for check-health.sh
#
# meta/health.md lives alongside wiki/ (i.e. at "$(dirname "$WIKI")/meta/health.md").
# Three cases:
#   1. Valid health.md (non-empty last-lint, integer ingest-count) -> SUMMARY 0
#   2. Missing health.md -> BAD_HEALTH meta/health.md not found, SUMMARY 1
#   3. Empty last-lint and non-integer ingest-count -> two BAD_HEALTH lines, SUMMARY 2
#
# Vault root contains a space (F1 mandatory case) for all three fixtures.

SCRIPT="$SCRIPTS_DIR/check-health.sh"

# --- Case 1: valid health.md -----------------------------------------------

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki" "$base/audit vault/meta"

cat > "$base/audit vault/meta/health.md" <<'EOF'
# Wiki Health

Tracking state for lint cadence and maintenance.

---

ingest-count: 0
last-lint: 2026-06-10
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "SUMMARY 0" "$output" \
  "check-health: a valid health.md (integer ingest-count, non-empty last-lint) passes clean"

rm -rf "$base"

# --- Case 2: missing health.md ----------------------------------------------

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki" "$base/audit vault/meta"

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "BAD_HEALTH meta/health.md not found" "$output" \
  "check-health: flags a missing meta/health.md"

assert_line_present "SUMMARY 1" "$output" \
  "check-health: summary counts the missing-file issue"

rm -rf "$base"

# --- Case 3: empty last-lint and non-integer ingest-count -------------------

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki" "$base/audit vault/meta"

cat > "$base/audit vault/meta/health.md" <<'EOF'
# Wiki Health

Tracking state for lint cadence and maintenance.

---

ingest-count: many
last-lint:
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "BAD_HEALTH ingest-count is not a non-negative integer: 'many'" "$output" \
  "check-health: flags a non-integer ingest-count"

assert_line_present "BAD_HEALTH last-lint is empty" "$output" \
  "check-health: flags an empty last-lint"

assert_line_present "SUMMARY 2" "$output" \
  "check-health: summary counts both issues (vault path contains a space)"

rm -rf "$base"
