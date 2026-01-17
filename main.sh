#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: ./main.sh <path> [--top N]" >&2
  exit 1
fi

top=10
path=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --top)
      top="$2"
      shift 2
      ;;
    *)
      if [[ -z "$path" ]]; then
        path="$1"
      fi
      shift
      ;;
  esac
done

text=$(cat "$path")
lines=0
if [[ -n "$text" ]]; then
  lines=$(printf "%s" "$text" | awk 'END {print NR}')
fi
words=$(printf "%s" "$text" | tr -cs 'A-Za-z0-9' '\n' | sed '/^$/d' | wc -l | awk '{print $1}')
chars=$(printf "%s" "$text" | wc -c | awk '{print $1}')

echo "lines: $lines"
echo "words: $words"
echo "chars: $chars"
echo "top words:"
printf "%s" "$text" | tr -cs 'A-Za-z0-9' '\n' | tr 'A-Z' 'a-z' | sed '/^$/d' | sort | uniq -c | sort -rn | head -n "$top" | awk '{print "  " $2 ": " $1}'
