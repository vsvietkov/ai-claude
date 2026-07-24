# skills

Reusable, **language-neutral, project-neutral** skills extracted from real
projects and adapted for reuse. Each skill lives in
`skills/<name>/SKILL.md` and loads on demand when its `description` matches the
task at hand.

## Skills

| Skill | Loads when | Does |
| ----- | ---------- | ---- |
| `writing-knowledge-docs` | You're creating or updating a knowledge-base doc that explains how a subsystem or feature works. | Enforces frontmatter, the technical/non-technical two-block split, portable markdown, grounding every claim in code you've actually read, and keeping the docs index and README/CLAUDE pointers in sync. |

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
command needed. Just start writing or updating a knowledge doc and Claude picks
it up.

The skill is a starting point — its default doc location (`docs/knowledge/`) and
frontmatter are conventions you can adapt to a project's existing docs home.
