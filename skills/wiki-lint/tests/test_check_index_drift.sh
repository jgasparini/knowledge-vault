#!/usr/bin/env bash
# test_check_index_drift.sh — fixture tests for check-index-drift.sh
#
# Fixture:
#   wiki/INDEX.md links to:
#     - [[projects/demo/_overview]]        (exists -> not broken)
#     - [[resources/concepts/page-good]]   (exists -> not broken)
#     - [[resources/concepts/page-missing]] (does not exist -> BROKEN_ENTRY)
#   wiki/resources/concepts/page-orphan.md exists but is referenced by
#   no INDEX.md -> NOT_INDEXED
#
# Vault root contains a space (F1, audit finding). The NOT_INDEXED check
# is unaffected by F1 and is expected to PASS. The BROKEN_ENTRY check and
# the SUMMARY line ARE affected by F1 (see check-index-drift.sh:46-52,
# unquoted $index_files loop) and are EXPECTED TO FAIL until the separate
# quoting-fix issue lands. Do not "fix" this test by changing the
# expectations — the failure is the point.

SCRIPT="$SCRIPTS_DIR/check-index-drift.sh"

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki/resources/concepts" "$wiki/projects/demo"

cat > "$wiki/INDEX.md" <<'EOF'
# Index

- [[projects/demo/_overview]]
- [[resources/concepts/page-good]]
- [[resources/concepts/page-missing]]
EOF

cat > "$wiki/resources/concepts/page-good.md" <<'EOF'
# Page Good

Content.
EOF

cat > "$wiki/resources/concepts/page-orphan.md" <<'EOF'
# Page Orphan

Not referenced from any INDEX.md.
EOF

cat > "$wiki/projects/demo/_overview.md" <<'EOF'
# Demo Project

Overview content.
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "NOT_INDEXED resources/concepts/page-orphan.md" "$output" \
  "check-index-drift: flags a content page not referenced by any INDEX.md"

assert_line_present "BROKEN_ENTRY [[resources/concepts/page-missing]] in INDEX.md" "$output" \
  "check-index-drift: flags an INDEX.md entry with no matching file (F1 regression: EXPECTED TO FAIL until quoting fix lands)"

assert_line_present "SUMMARY 1 1" "$output" \
  "check-index-drift: summary counts both findings (F1 regression: EXPECTED TO FAIL until quoting fix lands)"

rm -rf "$base"
