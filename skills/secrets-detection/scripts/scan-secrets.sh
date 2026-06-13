#!/usr/bin/env bash
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
  echo "scan-secrets: $TARGET: no such file or directory" >&2
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

# NOTE: redaction is not atomic across patterns. If pattern N of N fails
# partway through, patterns 1..N-1 have already been applied to the file
# in place, leaving it partially redacted even though this function
# returns 1. Callers should treat a failure as "file may be modified" and
# re-scan rather than assuming the original content is intact.
redact_file() {
  local file="$1"
  local i name regex end_regex
  for i in "${!PATTERN_NAMES[@]}"; do
    name="${PATTERN_NAMES[$i]}"
    regex="${PATTERN_REGEXES[$i]}"
    if [ "$name" = "private-key-block" ]; then
      end_regex="${regex/BEGIN/END}"
      if ! awk -v begin="$regex" -v end="$end_regex" -v repl="[REDACTED:${name}]" '
        BEGIN { in_block=0 }
        { if (!in_block && $0 ~ begin) { print repl; in_block=1; next }
          if (in_block) { if ($0 ~ end) { in_block=0 }; next }
          print }
      ' "$file" > "$file.secrets-tmp"; then
        rm -f "$file.secrets-tmp"
        return 1
      fi
      mv "$file.secrets-tmp" "$file" || return 1
    else
      if ! sed -E -i.secrets-bak "s#${regex}#[REDACTED:${name}]#g" "$file"; then
        rm -f "$file.secrets-bak"
        return 1
      fi
      rm -f "$file.secrets-bak"
    fi
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
