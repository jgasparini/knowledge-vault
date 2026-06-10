#!/usr/bin/env bash
# test_check_index_drift.sh — fixture tests for check-index-drift.sh
#
# Fixture:
#   wiki/INDEX.md links to:
#     - [[projects/demo/_overview]]        (exists -> not broken)
#     - [[resources/concepts/page-good]]   (exists -> not broken)
#     - [[resources/concepts/page-missing]] (does not exist -> BROKEN_ENTRY)
#   wiki/resources/concepts/page-orphan.md (type: frontmatter) exists but is
#   referenced by no INDEX.md -> NOT_INDEXED
#   wiki/resources/concepts/"page extra.md" is a space-named content page
#   (type: frontmatter), referenced by no INDEX.md -> NOT_INDEXED, flagged
#   not skipped for having a space in its filename (#38)
#   wiki/projects/demo/sources/ contains two raw sources (no frontmatter), one
#   kebab-named and one space-named -> excluded from Check 1 entirely (#38)
#
# Vault root contains a space (F1, audit finding, fixed by #31). All checks
# below — including BROKEN_ENTRY and SUMMARY — must pass with a
# space-containing vault path.

SCRIPT="$SCRIPTS_DIR/check-index-drift.sh"

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki/resources/concepts" "$wiki/projects/demo/sources"

cat > "$wiki/INDEX.md" <<'EOF'
# Index

- [[projects/demo/_overview]]
- [[resources/concepts/page-good]]
- [[resources/concepts/page-missing]]
EOF

cat > "$wiki/resources/concepts/page-good.md" <<'EOF'
---
type: concept
---

# Page Good

Content.
EOF

cat > "$wiki/resources/concepts/page-orphan.md" <<'EOF'
---
type: concept
---

# Page Orphan

Not referenced from any INDEX.md.
EOF

cat > "$wiki/resources/concepts/page extra.md" <<'EOF'
---
type: concept
---

# Page Extra

A misnamed (space-containing) content page, not referenced from any INDEX.md.
EOF

cat > "$wiki/projects/demo/_overview.md" <<'EOF'
---
type: project
---

# Demo Project

Overview content.
EOF

cat > "$wiki/projects/demo/sources/raw-transcript.md" <<'EOF'
Raw transcript text, no frontmatter. Not a content page.
EOF

cat > "$wiki/projects/demo/sources/raw transcript.md" <<'EOF'
Raw transcript text with a space in its filename, no frontmatter. Not a content page.
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "NOT_INDEXED resources/concepts/page-orphan.md" "$output" \
  "check-index-drift: flags a content page not referenced by any INDEX.md"

assert_line_present "NOT_INDEXED resources/concepts/page extra.md" "$output" \
  "check-index-drift: a space-named content page with type: frontmatter is flagged, not skipped (#38)"

assert_line_absent "raw-transcript" "$output" \
  "check-index-drift: a kebab-named raw source with no frontmatter is excluded entirely (#38)"

assert_line_absent "raw transcript" "$output" \
  "check-index-drift: a space-named raw source with no frontmatter is excluded entirely (#38)"

assert_line_present "BROKEN_ENTRY [[resources/concepts/page-missing]] in INDEX.md" "$output" \
  "check-index-drift: flags an INDEX.md entry with no matching file (vault path contains a space)"

assert_line_present "SUMMARY 2 1" "$output" \
  "check-index-drift: summary counts both NOT_INDEXED findings and the BROKEN_ENTRY (vault path contains a space)"

rm -rf "$base"
