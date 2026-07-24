---
description: Install this plugin's status line into the current project — copy the script into .claude/scripts/ and wire up the statusLine setting in .claude/settings.json.
argument-hint: [--local]
---

# Install the status line

The status line is a **settings-level** feature, not a native plugin component:
Claude Code reads a single `statusLine` command from a project's (or the user's)
`settings.json`, and that command must point at a script by path. So installing
is two steps — **copy the script in**, then **register it in settings** — done
against the **current project**, not the plugin.

The script ships at `${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh`. It prints the
model name, the git branch of the session's cwd, and a color-coded context-usage
bar. It depends only on `bash`, `jq`, and `git`, and exits `0` on any missing
dependency so it can never break the session.

## Task

Requested flags: `$ARGUMENTS`

1. **Pick the target settings file.**
   - Default: the project file `.claude/settings.json` (shared, committed).
   - If `$ARGUMENTS` contains `--local`: the project-local file
     `.claude/settings.local.json` (gitignored, not shared).
   Create `.claude/` and `.claude/scripts/` at the project root if missing. This
   is the consuming project, not the plugin.

2. **Copy the script** from `${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh` to
   `.claude/scripts/statusline.sh`, then make it executable (`chmod +x`). If the
   destination already exists, show the diff and **ask before overwriting** — the
   user may have customized it.

3. **Register the status line** in the chosen settings file. Read the existing
   JSON (treat a missing file as `{}`), then set the `statusLine` key — merging
   into the existing object, never clobbering unrelated keys:

   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "command -v bash >/dev/null 2>&1 && bash \"${CLAUDE_PROJECT_DIR:-.}/.claude/scripts/statusline.sh\""
     }
   }
   ```

   If a `statusLine` already exists and differs, show it and **ask before
   replacing** it.

4. **Report** what was copied and what was written/skipped, and note that the
   status line refreshes on the next prompt (or after `/config` reload).

5. Do **not** commit — leave the changes in the working tree for review.
