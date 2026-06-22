#!/usr/bin/env bash
# test_scan_secrets.sh — fixture tests for scan-secrets.sh
#
# fixtures/<pattern-name>.* each contain one fake-but-correctly-shaped match
# for that pattern from patterns.tsv. fixtures/clean.md has no matches.
#
# Some fixtures legitimately trip more than one pattern (e.g.
# aws-secret-access-key.txt also matches generic-credential-assignment) —
# assert_line_present only checks that the expected FINDING is among the
# output, not that it is the only one.

SCRIPT="$SCRIPTS_DIR/scan-secrets.sh"
FIXTURES="$TESTS_DIR/fixtures"

# --- one FINDING per pattern fixture ---
#
# Each fixture is named "<pattern-name>.txt" (indexed array, not associative,
# for bash 3.2 compatibility on macOS).

PATTERN_NAMES=(
  private-key-block
  aws-access-key-id
  aws-secret-access-key
  jwt
  github-token
  github-fine-grained-pat
  slack-token
  slack-webhook-url
  google-api-key
  stripe-live-key
  connection-string-credential
  generic-credential-assignment
)

for pattern in "${PATTERN_NAMES[@]}"; do
  fixture="$FIXTURES/$pattern.txt"
  output=$(bash "$SCRIPT" "$fixture")
  assert_line_present "FINDING $pattern $fixture:" "$output" \
    "scan-secrets: $pattern fixture is detected"
done

# --- clean.md has no matches ---

clean_fixture="$FIXTURES/clean.md"
clean_output=$(bash "$SCRIPT" "$clean_fixture")
clean_exit=$?

assert_line_present "SUMMARY 0" "$clean_output" \
  "scan-secrets: clean.md reports SUMMARY 0"

assert_equal "0" "$clean_exit" \
  "scan-secrets: clean.md exits 0"

# --- directory scan covers every fixture file ---

dir_output=$(bash "$SCRIPT" "$FIXTURES")
dir_exit=$?

assert_line_present "SUMMARY 14" "$dir_output" \
  "scan-secrets: scanning the fixtures directory finds all 14 matches"

assert_equal "1" "$dir_exit" \
  "scan-secrets: scanning a directory with findings exits 1"

# --- redact mode: simple single-line pattern ---

redact_tmpdir=$(mktemp -d)
cp "$FIXTURES/aws-access-key-id.txt" "$redact_tmpdir/aws-access-key-id.txt"

bash "$SCRIPT" --redact "$redact_tmpdir/aws-access-key-id.txt" > /dev/null
redacted_content=$(cat "$redact_tmpdir/aws-access-key-id.txt")

assert_line_present "[REDACTED:aws-access-key-id]" "$redacted_content" \
  "scan-secrets --redact: aws-access-key-id match is replaced with a placeholder"

rescan_output=$(bash "$SCRIPT" "$redact_tmpdir/aws-access-key-id.txt")
assert_line_present "SUMMARY 0" "$rescan_output" \
  "scan-secrets --redact: re-scan of the redacted file is clean"

rm -rf "$redact_tmpdir"

# --- redact mode: private-key-block collapses to a single line ---

pk_tmpdir=$(mktemp -d)
cp "$FIXTURES/private-key-block.txt" "$pk_tmpdir/private-key-block.txt"

bash "$SCRIPT" --redact "$pk_tmpdir/private-key-block.txt" > /dev/null
pk_redacted_content=$(cat "$pk_tmpdir/private-key-block.txt")
pk_line_count=$(wc -l < "$pk_tmpdir/private-key-block.txt" | tr -d ' ')

assert_line_present "[REDACTED:private-key-block]" "$pk_redacted_content" \
  "scan-secrets --redact: private-key-block is replaced with a placeholder"

assert_equal "3" "$pk_line_count" \
  "scan-secrets --redact: the 4-line BEGIN/END block collapses to 1 line (6 -> 3 lines total)"

pk_rescan_output=$(bash "$SCRIPT" "$pk_tmpdir/private-key-block.txt")
assert_line_present "SUMMARY 0" "$pk_rescan_output" \
  "scan-secrets --redact: re-scan of the redacted private key file is clean"

rm -rf "$pk_tmpdir"
