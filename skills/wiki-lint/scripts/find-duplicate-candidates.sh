#!/usr/bin/env bash
# find-duplicate-candidates.sh — find same-type concept/entity/topic pages
# whose filenames share 2 or more `-`-separated tokens
#
# Usage:
#   bash find-duplicate-candidates.sh /path/to/vault/wiki
#
# For each of wiki/resources/{concepts,entities,topics} independently: list
# content pages whose frontmatter `type:` matches the directory's expected
# type (concept/entity/topic respectively), tokenize each filename (minus
# .md) on `-`, and for every pair within that directory whose token-set
# intersection has 2 or more members, emit a CANDIDATE line. Cross-type and
# cross-directory pairs are never compared.
#
# output (one line per candidate pair):
#   CANDIDATE <type> <path-a> <path-b> <shared-tokens-comma-separated>
# <path-a> and <path-b> are paths relative to $WIKI, in sorted order.
# <shared-tokens-comma-separated> lists the intersection in the order tokens
# appear in <path-a>'s filename.
# Final line:
#   SUMMARY pages_checked candidate_count

WIKI="${1:?Usage: $0 /path/to/vault/wiki}"

# page_type <file> — print the value of the frontmatter `type:` field, or
# nothing if the file has no frontmatter or no `type:` field.
page_type() {
  awk '
    NR==1 { if ($0 != "---") exit; next }
    /^---$/ { exit }
    /^type:/ {
      sub("^type:[[:space:]]*", "")
      sub("[[:space:]]*$", "")
      sub(/^["'"'"']/, "")
      sub(/["'"'"']$/, "")
      print
      exit
    }
  ' "$1"
}

tmpout=$(mktemp)
total=0
candidates=0

dirs=(concepts entities topics)
types=(concept entity topic)

for idx in "${!dirs[@]}"; do
  dir="${dirs[$idx]}"
  type="${types[$idx]}"
  d="$WIKI/resources/$dir"
  [ -d "$d" ] || continue

  files=()
  while IFS= read -r f; do
    [ "$(page_type "$f")" = "$type" ] && files+=("$f")
  done < <(find "$d" -name "*.md" | sort)

  total=$((total + ${#files[@]}))

  n=${#files[@]}
  for ((i = 0; i < n; i++)); do
    for ((j = i + 1; j < n; j++)); do
      relpath_a="${files[$i]#"$WIKI/"}"
      relpath_b="${files[$j]#"$WIKI/"}"

      if [[ "$relpath_a" > "$relpath_b" ]]; then
        tmp_path="$relpath_a"
        relpath_a="$relpath_b"
        relpath_b="$tmp_path"
      fi

      IFS='-' read -ra tokens_a <<< "$(basename "$relpath_a" .md)"
      IFS='-' read -ra tokens_b <<< "$(basename "$relpath_b" .md)"

      shared=()
      for t in "${tokens_a[@]}"; do
        [ -n "$t" ] || continue
        for t2 in "${tokens_b[@]}"; do
          if [ "$t" = "$t2" ]; then
            shared+=("$t")
            break
          fi
        done
      done

      if [ "${#shared[@]}" -ge 2 ]; then
        shared_str=$(IFS=,; echo "${shared[*]}")
        echo "CANDIDATE $type $relpath_a $relpath_b $shared_str" >> "$tmpout"
        candidates=$((candidates + 1))
      fi
    done
  done
done

cat "$tmpout"
rm -f "$tmpout"

echo "SUMMARY $total $candidates"
