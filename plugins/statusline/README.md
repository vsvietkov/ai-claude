# statusline

A dependency-light Claude Code **status line** and a `/statusline:install`
command to wire it into any project.

The script (`scripts/statusline.sh`) renders three things on one line:

- **Model name** — e.g. `Opus 4.8`.
- **Git branch** — resolved from the session's cwd, shown in cyan `(branch)`.
- **Context-usage bar** — a 10-cell `[####------] 42%` meter that goes
  green → yellow → red as the context window fills.

It depends only on `bash`, `jq`, and `git`, uses integer math only (no `bc`/`seq`),
and **exits `0` on any missing dependency or bad input** — so it degrades to a
partial line (or nothing) rather than ever breaking the session.

## Why an install command

Unlike skills or commands, a status line isn't a native plugin component — Claude
Code reads a single `statusLine` entry from a project's or user's `settings.json`,
and that entry points at a script **by path**. So installing is two steps:
install the plugin once (it gives you `/statusline:install`), then run that
command inside each project to copy the script in and register it in settings.

## Installing

From the published marketplace (once this repo is on GitHub):

```
/plugin marketplace add vsvietkov/ai-claude
/plugin install statusline@vsvietkov-toolkit
```

From a local clone (during development, before pushing):

```
/plugin marketplace add /absolute/path/to/ai-claude
/plugin install statusline@vsvietkov-toolkit
```

## Usage

From inside a target project:

```
/statusline:install           # shared: writes .claude/settings.json
/statusline:install --local   # local-only: writes .claude/settings.local.json
```

The command copies `statusline.sh` into the project's `.claude/scripts/`
(asking before overwriting), makes it executable, and merges a `statusLine`
entry into the chosen settings file:

```json
"statusLine": {
  "type": "command",
  "command": "command -v bash >/dev/null 2>&1 && bash \"${CLAUDE_PROJECT_DIR:-.}/.claude/scripts/statusline.sh\""
}
```

The status line refreshes on the next prompt. The copied script is a starting
point — edit the bar width, colors, or fields to taste.
