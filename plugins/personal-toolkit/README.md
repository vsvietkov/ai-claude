# personal-toolkit

Core reusable Claude Code toolkit — shared rules, skills, slash commands,
subagents, hooks, and helper scripts.

## Components

| Type | Path | Included |
| ---- | ---- | -------- |
| Slash command | `commands/` | `example` — template command |
| Subagent | `agents/` | `example-agent` — template agent |
| Skill | `skills/` | `example-skill` — template skill |
| Hook | `hooks/hooks.json` | PostToolUse example wired to a script |
| Script | `scripts/` | `example-hook.sh` — template hook script |

The `example.*` entries are working templates. Copy one, rename it, and replace
the body with your own logic.

## Install

```
/plugin marketplace add vsvietkov/ai-claude
/plugin install personal-toolkit@vsvietkov-toolkit
```

## Conventions

- Reference in-plugin paths with `${CLAUDE_PLUGIN_ROOT}`.
- Keep each component's `description` specific — it drives when Claude loads it.
- See the repo-root [CLAUDE.md](../../CLAUDE.md) for full conventions.
