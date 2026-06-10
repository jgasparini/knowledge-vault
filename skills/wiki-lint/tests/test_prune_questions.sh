#!/usr/bin/env bash
# test_prune_questions.sh — fixture tests for prune-questions.sh
#
# Fixture: two QUESTIONS.md files.
#   projects/fresh/QUESTIONS.md — 2 open, 1 closed, closed item raised
#     today (0 days old) -> not flagged at all.
#   projects/old/QUESTIONS.md   — 1 open, 3 closed (overcrowded), all 3
#     closed items raised 2000-01-01 (always >30 days old) -> OVERCROWDED
#     and OLD_CLOSED.
#
# Dates are computed at test-run time so this stays correct regardless
# of when the suite runs. Vault root contains a space (F1 mandatory
# case) — this script quotes "$WIKI" and "$file" correctly throughout,
# so this is expected to PASS.

SCRIPT="$SCRIPTS_DIR/prune-questions.sh"

base=$(mktemp -d)
wiki="$base/audit vault/wiki"
mkdir -p "$wiki/projects/fresh" "$wiki/projects/old"

today=$(date +%Y-%m-%d)
old_date="2000-01-01"

cat > "$wiki/projects/fresh/QUESTIONS.md" <<EOF
# Questions

- [ ] Open question one *raised $today*
- [ ] Open question two *raised $today*
- [x] Closed question *raised $today*
EOF

cat > "$wiki/projects/old/QUESTIONS.md" <<EOF
# Questions

- [ ] Open question *raised $today*
- [x] Closed question one *raised $old_date*
- [x] Closed question two *raised $old_date*
- [x] Closed question three *raised $old_date*
EOF

output=$(bash "$SCRIPT" "$wiki")

assert_line_present "OVERCROWDED 3 1 projects/old/QUESTIONS.md" "$output" \
  "prune-questions: flags a file with more closed than open items"

assert_line_present "OLD_CLOSED 3 projects/old/QUESTIONS.md" "$output" \
  "prune-questions: flags closed items raised more than 30 days ago"

assert_line_absent "projects/fresh/QUESTIONS.md" "$output" \
  "prune-questions: does not flag a file with fresh items and more open than closed"

assert_line_present "SUMMARY 2 1" "$output" \
  "prune-questions: summary counts 2 files checked, 1 flagged (vault path contains a space)"

rm -rf "$base"
