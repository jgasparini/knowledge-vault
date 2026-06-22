#!/usr/bin/env bash
# helpers.sh — shared assertion helpers for pii-detection script fixture tests
#
# Sourced by run.sh before each test_*.sh file. PASS_COUNT and FAIL_COUNT
# are globals that accumulate across every sourced test file.
#
# Standalone copy: this skill has no dependency on secrets-detection's or
# wiki-lint's helpers.sh, so the .claude/skills/pii-detection/ directory can be
# copied into other repos.

PASS_COUNT=0
FAIL_COUNT=0

# assert_line_present <expected_line> <actual_output> <description>
assert_line_present() {
  local needle="$1"
  local haystack="$2"
  local description="$3"

  if grep -qF -- "$needle" <<< "$haystack"; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "  PASS: $description"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "  FAIL: $description"
    echo "    expected line: $needle"
    echo "    --- actual output ---"
    echo "$haystack" | sed 's/^/    /'
  fi
}

# assert_line_absent <unexpected_substring> <actual_output> <description>
assert_line_absent() {
  local needle="$1"
  local haystack="$2"
  local description="$3"

  if grep -qF -- "$needle" <<< "$haystack"; then
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "  FAIL: $description"
    echo "    unexpected match: $needle"
    echo "    --- actual output ---"
    echo "$haystack" | sed 's/^/    /'
  else
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "  PASS: $description"
  fi
}

# assert_equal <expected> <actual> <description>
assert_equal() {
  local expected="$1"
  local actual="$2"
  local description="$3"

  if [ "$expected" = "$actual" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "  PASS: $description"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "  FAIL: $description"
    echo "    expected: $expected"
    echo "    actual:   $actual"
  fi
}

print_summary() {
  echo ""
  echo "=== $PASS_COUNT passed, $FAIL_COUNT failed ==="
  if [ "$FAIL_COUNT" -gt 0 ]; then
    return 1
  fi
  return 0
}
