#!/usr/bin/env bash
# scan-pii.sh — pattern-based PII scanner (macOS/Linux)
#
# Usage:
#   bash scan-pii.sh <path>
#   bash scan-pii.sh --redact <path>
#
# <path> may be a file or a directory. Emits "FINDING <pattern-name>
# <file>:<line>" per match, never the matched value, then "SUMMARY <count>".
# Exit 0 if count is 0 (scan mode) or the redact rewrite succeeded (redact
# mode); exit 1 otherwise.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATTERNS_FILE="$SCRIPT_DIR/patterns.tsv"

REDACT=0
if [ "${1:-}" = "--redact" ]; then
  REDACT=1
  shift
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 [--redact] <path>" >&2
  exit 1
fi
TARGET="$1"

if [ -f "$TARGET" ]; then
  FILES=("$TARGET")
elif [ -d "$TARGET" ]; then
  FILES=()
  while IFS= read -r -d '' f; do
    FILES+=("$f")
  done < <(find "$TARGET" -type f -not -path '*/.git/*' -not -path '*/node_modules/*' -print0)
else
  echo "scan-pii: $TARGET: no such file or directory" >&2
  exit 1
fi

PATTERN_NAMES=()
PATTERN_REGEXES=()
while IFS=$'\t' read -r name regex _; do
  [ -z "$name" ] && continue
  case "$name" in \#*) continue ;; esac
  PATTERN_NAMES+=("$name")
  PATTERN_REGEXES+=("$regex")
done < "$PATTERNS_FILE"

# Every pattern in patterns.tsv is single-line, so redaction is a plain
# per-pattern sed substitution — no multi-line block handling needed (unlike
# secrets-detection's private-key-block).
redact_file() {
  local file="$1"
  local i name regex
  for i in "${!PATTERN_NAMES[@]}"; do
    name="${PATTERN_NAMES[$i]}"
    regex="${PATTERN_REGEXES[$i]}"
    if ! sed -E -i.pii-bak "s#${regex}#[REDACTED:${name}]#g" "$file"; then
      rm -f "$file.pii-bak"
      return 1
    fi
    rm -f "$file.pii-bak"
  done
  return 0
}

FINDINGS_COUNT=0
for file in "${FILES[@]}"; do
  for i in "${!PATTERN_NAMES[@]}"; do
    name="${PATTERN_NAMES[$i]}"
    regex="${PATTERN_REGEXES[$i]}"
    while IFS=: read -r line_no _; do
      [ -z "$line_no" ] && continue
      echo "FINDING $name $file:$line_no"
      FINDINGS_COUNT=$((FINDINGS_COUNT + 1))
    done < <(grep -nIE -- "$regex" "$file" 2>/dev/null | cut -d: -f1)
  done
done

REDACT_ERROR=0
if [ "$REDACT" -eq 1 ] && [ "$FINDINGS_COUNT" -gt 0 ]; then
  for file in "${FILES[@]}"; do
    redact_file "$file" || REDACT_ERROR=1
  done
fi

echo "SUMMARY $FINDINGS_COUNT"

if [ "$REDACT" -eq 1 ]; then
  [ "$REDACT_ERROR" -eq 0 ] && exit 0 || exit 1
fi

[ "$FINDINGS_COUNT" -gt 0 ] && exit 1
exit 0
