# skills

Reusable, **language-neutral, project-neutral** skills extracted from real
projects and adapted for reuse. Each skill lives in `skills/<name>/SKILL.md` and
loads on demand when its `description` matches the task at hand; a skill may
bundle supporting files beside it, which it reads only when they apply.

## Skills

| Skill | Loads when | Does |
| ----- | ---------- | ---- |
| `writing-knowledge-docs` | You're creating or updating a knowledge doc under `docs/knowledge/`, or writing a decision record under `docs/decisions/`. | Enforces the durability tests, pointing at files instead of transcribing them, the plain-language opener, the length budget, grounding every claim in code you've actually read, and keeping the index and the register in sync. Bundles `references/decision-records.md`, which it loads on demand for records. |

## Installing

Skills ship with the plugin — there's no per-skill copy step. Install the
plugin once and its skills are auto-discovered; each loads on its own when a
task matches its `description`.

From the published marketplace (once this repo is on GitHub):

```
/plugin marketplace add vsvietkov/ai-claude
/plugin install skills@vsvietkov-toolkit
```

From a local clone (during development, before pushing):

```
/plugin marketplace add /absolute/path/to/ai-claude
/plugin install skills@vsvietkov-toolkit
```

The plugin installs at the **user level**, so it's available across all your
projects; enable or disable it per project with `/plugin`. After editing a skill
in a local clone, run `/plugin marketplace update vsvietkov-toolkit` to pick up
the change.

## Usage

The skill loads automatically when a task matches its `description` — no slash
command needed. Just start writing or updating a knowledge doc, or ask for a
decision record, and Claude picks it up.

`writing-knowledge-docs` prescribes the layout it enforces rather than adapting
to an existing one: knowledge docs at `docs/knowledge/<scope>/<topic>.md` indexed
by `docs/knowledge/README.md`, decision records at
`docs/decisions/YYYYMMDDHHMMSS-kebab-title.md` registered in
`docs/decisions/README.md`. Test conventions and other rules it routes away from
a doc land in `.claude/rules/`, which is where the sibling
[`rules`](../rules) plugin installs.
