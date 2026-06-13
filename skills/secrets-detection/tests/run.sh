#!/usr/bin/env bash
# run.sh — run all secrets-detection script fixture tests
#
# Usage:
#   bash skills/secrets-detection/tests/run.sh

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
