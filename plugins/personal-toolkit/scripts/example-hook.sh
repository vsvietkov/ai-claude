#!/usr/bin/env bash
#
# Example hook script shipped by personal-toolkit.
#
# Hook input is delivered as JSON on stdin. Read it, do your work, and exit 0.
# A non-zero exit (or JSON with "decision":"block") signals the harness to
# block the action and feed your message back to Claude.
#
# Replace this with your own logic — e.g. run a formatter or linter on the
# file that was just edited.

set -euo pipefail

# Read the JSON payload from stdin (empty string if none).
input="$(cat || true)"

# Example: extract the edited file path with jq, if available.
if command -v jq >/dev/null 2>&1; then
  file_path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"
  if [ -n "$file_path" ]; then
    echo "personal-toolkit: file changed -> $file_path" >&2
  fi
fi

exit 0
