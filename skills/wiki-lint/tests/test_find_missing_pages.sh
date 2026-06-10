#!/usr/bin/env bash
# test_find_missing_pages.sh — fixture tests for find-missing-pages.sh
#
# Fixture: two pages each link to [[existing-page]] (which exists) and
# [[ghost-page]] (which doesn't). Both links are referenced twice, so
# both clear the >=2 references threshold; only ghost-page is MISSING.
# Vault root contains a space (F1 mandatory case) — this script quotes
# "$WIKI" correctly throughout, so this is expected to PASS.

SCRIPT="$SCRIPTS_DIR/find-missing-pages.sh"

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki"

cat > "$wiki/page-a.md" <<'EOF'
# Page A

See [[existing-page]] and [[ghost-page]].
EOF

cat > "$wiki/page-b.md" <<'EOF'
# Page B

Also [[existing-page]] and [[ghost-page]] again.
EOF

cat > "$wiki/existing-page.md" <<'EOF'
# Existing Page
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "MISSING 2 [[ghost-page]]" "$output" \
  "find-missing-pages: flags a link referenced twice with no matching file"

assert_line_absent "[[existing-page]]" "$output" \
  "find-missing-pages: does not flag a link that has a matching file"

assert_line_present "SUMMARY 2 1" "$output" \
  "find-missing-pages: summary counts 2 unique links, 1 missing (vault path contains a space)"

rm -rf "$base"
