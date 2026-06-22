#!/usr/bin/env bash
# run.sh — run all wiki-lint script fixture tests
#
# Usage:
#   bash .claude/skills/wiki-lint/tests/run.sh
#
# NOTE: as of audit T0.1 (issue #28), the check-index-drift.sh tests
# include an intentionally-failing regression case for the F1 bug
# (unquoted $index_files loop drops BROKEN_ENTRY results when the
# vault path contains a space). That case will turn green once the
# separate quoting-fix issue lands. Until then this script exits 1.

set -u

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$(cd "$TESTS_DIR/../scripts" && pwd)"

# shellcheck source=helpers.sh
source "$TESTS_DIR/helpers.sh"

for test_file in "$TESTS_DIR"/test_*.sh; do
  echo "--- $(basename "$test_file") ---"
  source "$test_file"
done

print_summary
exit $?
