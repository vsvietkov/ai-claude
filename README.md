# ai-claude — Vitalii's Claude Code Toolkit

A personal, reusable collection of Claude Code extensions — **rules, skills,
slash commands, subagents, hooks, and scripts** — packaged as a
[Claude Code plugin marketplace](https://docs.claude.com/en/docs/claude-code/plugins)
so it can be installed into any project with a single command.

## What's inside

This repository is a **marketplace** ([`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json))
that publishes one or more plugins.

| Plugin | Description |
| ------ | ----------- |
| [`rules`](plugins/rules) | Language-neutral convention rules (Makefile, `.env`, comments) plus `/install-rules` to drop them into any project's `.claude/rules/`. |

Each plugin can contribute any of the following components:

| Component | Location (per plugin) | Purpose |
| --------- | --------------------- | ------- |
| Slash commands | `commands/*.md` | Reusable `/commands`. |
| Subagents | `agents/*.md` | Specialized agents Claude can delegate to. |
| Skills | `skills/<name>/SKILL.md` | On-demand capabilities loaded when relevant. |
| Hooks | `hooks/hooks.json` | Automated behavior on lifecycle events. |
| Scripts | `scripts/*` | Helper executables used by hooks/commands. |
| MCP servers | `.mcp.json` | External tool/data integrations (optional). |

## Install

Add this marketplace, then install the plugin(s):

```
# In Claude Code
/plugin marketplace add vsvietkov/ai-claude
/plugin install rules@vsvietkov-toolkit
```

Or add it from a local clone during development:

```
/plugin marketplace add /absolute/path/to/ai-claude
```

Then use `/plugin` to browse, enable, or disable installed plugins.

## Develop

1. Clone this repo.
2. Add it as a local marketplace: `/plugin marketplace add <path-to-repo>`.
3. Edit or add components under `plugins/<plugin>/`.
4. Run `/plugin marketplace update vsvietkov-toolkit` to pick up changes, and
   reload the plugin to test.

New to the layout? The [`rules`](plugins/rules) plugin is a worked example of the
structure. See [CLAUDE.md](CLAUDE.md) for component conventions and validation.

## Repository layout

```
.
├── .claude-plugin/
│   └── marketplace.json          # Marketplace manifest (lists all plugins)
├── plugins/
│   └── rules/
│       ├── .claude-plugin/
│       │   └── plugin.json        # Plugin manifest
│       ├── commands/              # /install-rules
│       ├── rules/                 # Convention rule files (payload)
│       └── README.md
├── CLAUDE.md                       # Conventions for working in this repo
├── LICENSE                         # MIT
└── README.md
```

## License

[MIT](LICENSE) © Vitalii Svietkov
