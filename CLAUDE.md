# CLAUDE.md

Guidance for Claude Code when working **in this repository**.

## What this repo is

This is a **Claude Code plugin marketplace** — a curated, reusable collection
of Claude Code extensions meant to be installed into other projects. It is not
an application; there is no build or runtime. The "product" is the set of
plugin components (commands, agents, skills, hooks, scripts) and their
manifests.

## Structure & where things go

- `.claude-plugin/marketplace.json` — the marketplace manifest. Every plugin
  must be registered here with a `name` and `source` path.
- `plugins/<plugin-name>/.claude-plugin/plugin.json` — each plugin's manifest.
- Plugin components live under `plugins/<plugin-name>/`:
  - `commands/*.md` — slash commands (frontmatter: `description`, optional
    `argument-hint`; body is the prompt; `$ARGUMENTS` holds user input).
  - `agents/*.md` — subagents (frontmatter: `name`, `description`, optional
    `tools`, `model`; body is the system prompt).
  - `skills/<name>/SKILL.md` — skills (frontmatter: `name`, `description`; the
    `description` is the sole trigger signal, so make it specific and
    keyword-rich). Bundle supporting files beside `SKILL.md`.
  - `hooks/hooks.json` — event hooks. Reference scripts via
    `${CLAUDE_PLUGIN_ROOT}` so paths resolve regardless of install location.
  - `scripts/*` — helper executables (keep them `chmod +x`).

## Conventions

- Prefer many small, single-purpose components over large monolithic ones.
- Keep every `description` field concrete and action-oriented — it is what
  Claude reads to decide whether to load the component.
- Use `${CLAUDE_PLUGIN_ROOT}` for any in-plugin path; never hardcode absolute
  paths.
- Never commit secrets. `.env*` and `secrets/` are gitignored.
- Bump `version` in both `marketplace.json` and the affected `plugin.json`
  when you change a plugin.

## Adding a new plugin

1. Create `plugins/<new-plugin>/.claude-plugin/plugin.json`.
2. Add its components under `plugins/<new-plugin>/`.
3. Register it in `.claude-plugin/marketplace.json` under `plugins`.
4. Document it in the root `README.md` table.

## Validation

After editing manifests, sanity-check that the JSON parses and paths exist:

```
# All JSON manifests parse
find . -name '*.json' -path '*.claude-plugin*' -exec sh -c 'jq empty "$1"' _ {} \;

# Every plugin source in the marketplace resolves to a real directory
jq -r '.plugins[].source' .claude-plugin/marketplace.json
```

Test changes live by adding this repo as a local marketplace
(`/plugin marketplace add <path>`) and installing the plugin.
