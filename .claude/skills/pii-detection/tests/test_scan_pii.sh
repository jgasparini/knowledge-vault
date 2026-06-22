#!/usr/bin/env bash
# test_scan_pii.sh — fixture tests for scan-pii.sh
#
# fixtures/<pattern-name>.txt each contain one fake-but-correctly-shaped
# match for that pattern from patterns.tsv. fixtures/clean.md has no
# matches.
#
# iban.txt legitimately trips more than one pattern (it also matches
# uk-nhs-number) — assert_line_present only checks that the expected
# FINDING is among the output, not that it is the only one.

SCRIPT="$SCRIPTS_DIR/scan-pii.sh"
FIXTURES="$TESTS_DIR/fixtures"

# --- one FINDING per pattern fixture ---
#
# Each fixture is named "<pattern-name>.txt" (indexed array, not associative,
# for bash 3.2 compatibility on macOS).

PATTERN_NAMES=(
  uk-ni-number
  us-ssn
  credit-card-number
  uk-sort-code-account
  iban
  uk-nhs-number
  passport-number
)

for pattern in "${PATTERN_NAMES[@]}"; do
  fixture="$FIXTURES/$pattern.txt"
  output=$(bash "$SCRIPT" "$fixture")
  assert_line_present "FINDING $pattern $fixture:" "$output" \
    "scan-pii: $pattern fixture is detected"
done

# --- clean.md has no matches ---

clean_fixture="$FIXTURES/clean.md"
clean_output=$(bash "$SCRIPT" "$clean_fixture")
clean_exit=$?

assert_line_present "SUMMARY 0" "$clean_output" \
  "scan-pii: clean.md reports SUMMARY 0"

assert_equal "0" "$clean_exit" \
  "scan-pii: clean.md exits 0"

# --- directory scan covers every fixture file ---

dir_output=$(bash "$SCRIPT" "$FIXTURES")
dir_exit=$?

assert_line_present "SUMMARY 8" "$dir_output" \
  "scan-pii: scanning the fixtures directory finds all 8 matches"

assert_equal "1" "$dir_exit" \
  "scan-pii: scanning a directory with findings exits 1"

# --- redact mode: uk-ni-number fixture ---

redact_tmpdir=$(mktemp -d)
cp "$FIXTURES/uk-ni-number.txt" "$redact_tmpdir/uk-ni-number.txt"

bash "$SCRIPT" --redact "$redact_tmpdir/uk-ni-number.txt" > /dev/null
redacted_content=$(cat "$redact_tmpdir/uk-ni-number.txt")

assert_line_present "[REDACTED:uk-ni-number]" "$redacted_content" \
  "scan-pii --redact: uk-ni-number match is replaced with a placeholder"

rescan_output=$(bash "$SCRIPT" "$redact_tmpdir/uk-ni-number.txt")
assert_line_present "SUMMARY 0" "$rescan_output" \
  "scan-pii --redact: re-scan of the redacted file is clean"

rm -rf "$redact_tmpdir"
