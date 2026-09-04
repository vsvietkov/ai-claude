#!/usr/bin/env bash
# Claude Code status line: model name, git branch, and context-usage bar.
# Designed to never fail the caller — any missing dependency or bad input
# results in a partial line (or nothing) and a clean exit 0.

# jq is required to parse the JSON payload on stdin. Without it there is
# nothing useful to print, so exit quietly.
command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "Unknown"')
used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

# Resolve git branch from the session's cwd, if git is available.
branch=""
if [ -n "$cwd" ] && command -v git >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
fi

# Colours hold real escape bytes, not printf format fragments: a branch name may
# legally contain `%`, so every value stays an argument, never part of a format.
cyan=$'\033[36m'
red=$'\033[31m'
yellow=$'\033[33m'
green=$'\033[32m'
reset=$'\033[0m'

printf '%s' "$model"

if [ -n "$branch" ]; then
  printf '  %s(%s)%s' "$cyan" "$branch" "$reset"
fi

# Render the usage bar only when we have a numeric percentage.
if printf '%s' "$used" | grep -Eq '^[0-9]+(\.[0-9]+)?$'; then
  # Integer math only — avoids depending on bc/seq.
  pct=${used%.*}
  filled=$(( pct / 10 ))
  [ "$filled" -gt 10 ] && filled=10
  [ "$filled" -lt 0 ] && filled=0
  empty=$(( 10 - filled ))

  bar=""
  i=0
  while [ "$i" -lt "$filled" ]; do bar="${bar}#"; i=$(( i + 1 )); done
  i=0
  while [ "$i" -lt "$empty" ];  do bar="${bar}-"; i=$(( i + 1 )); done

  if   [ "$filled" -ge 8 ]; then color="$red"
  elif [ "$filled" -ge 5 ]; then color="$yellow"
  else                            color="$green"
  fi

  printf '  %s[%s]%s %s%%' "$color" "$bar" "$reset" "$pct"
fi

exit 0
