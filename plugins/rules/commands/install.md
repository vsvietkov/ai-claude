---
description: Copy the reusable convention rule files (Makefile, env templates, comments, writing-rules) into this project's .claude/rules/ so they auto-load on matching files.
argument-hint: [makefile|env-templates|comments|writing-rules|all]
---

# Install convention rules

Copy one or more of this plugin's convention rule files into the **current
project's** `.claude/rules/` directory. Each rule carries `paths:` frontmatter, so
once copied it auto-loads whenever a matching file is edited — no registration
needed.

The rule files ship under `${CLAUDE_PLUGIN_ROOT}/rules/`:

| Name | File | Governs (`paths:`) |
| ---- | ---- | ------------------ |
| `makefile` | `makefile.md` | `**/Makefile`, `**/*.mk` |
| `env-templates` | `env-templates.md` | `**/.env.example`, `**/*.env.example` |
| `comments` | `comments.md` | source extensions (`**/*.go`, `**/*.ts`, `**/*.py`, …) |
| `writing-rules` | `writing-rules.md` | `.claude/rules/**/*.md`, `CLAUDE.md` |

## Task

Requested rules: `$ARGUMENTS`

1. **Resolve the selection.** If `$ARGUMENTS` is empty or `all`, select all
   rules. Otherwise select the named ones (accept space- or comma-separated names);
   if a name doesn't match the table above, list the valid names and stop.

2. **Prepare the destination.** Ensure `.claude/rules/` exists at the project root
   (create it if missing). This is the consuming project, not the plugin.

3. **Copy each selected file** from `${CLAUDE_PLUGIN_ROOT}/rules/<name>.md` to
   `.claude/rules/<name>.md`. If a destination file already exists, show the diff
   and **ask before overwriting** — the user may have customized it.

4. **Report** what was copied and skipped (already present / declined overwrite).

5. **Remind the user** these are starting-point conventions — trim them to fit the
   project. Do **not** commit; leave the changes in the working tree for review.
