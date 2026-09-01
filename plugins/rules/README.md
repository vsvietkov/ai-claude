# rules

Reusable, **language-neutral, project-neutral** convention rules extracted from
real projects and adapted for reuse. Each rule is a scoped `.claude/rules/*.md`
file; the `/rules:install` command drops the ones you want into any project.

## Rules

| Rule | Scope (`paths:`) | Governs |
| ---- | ---------------- | ------- |
| `makefile.md` | `**/Makefile`, `**/*.mk` | `.PHONY`, self-documenting `## ` target comments, the `make help` target, Unicode section dividers, `$(if …)` optional-var guards, shared `RUN`/`EXEC`/`IMAGE` vars. |
| `env-files.md` | `**/.env.example` | Commit `*.example` / gitignore real env, document every variable, live-vs-commented rule, dev/test sibling invariant. |
| `comments.md` | `**/*` | Doc comment = one-line "what it is"; inline = one-line "why"; runtime "what" → logs; keep the *why* local and short; end-of-task audit gate. |
| `writing-rules.md` | `.claude/rules/**/*.md`, `CLAUDE.md` | How to write a rule: the staleness test, constraints not descriptions, no lists that must be complete, verify every symbol named, one exemplar never an inventory, `paths:` scoping and the per-load attention budget, and what belongs in `CLAUDE.md` above the rules. |

Each rule is **independent and self-contained** — install only the ones a project
needs.

## Installing

Unlike skills, rules aren't a native plugin component — they live in a project's
`.claude/rules/`. So installing is **two steps**: install the plugin once (it
gives you the `/rules:install` command), then run that command inside each
project to copy the rule files in.

From the published marketplace (once this repo is on GitHub):

```
/plugin marketplace add vsvietkov/ai-claude
/plugin install rules@vsvietkov-toolkit
```

From a local clone (during development, before pushing):

```
/plugin marketplace add /absolute/path/to/ai-claude
/plugin install rules@vsvietkov-toolkit
```

The plugin installs at the **user level**, so `/rules:install` is available in
all your projects; enable or disable it per project with `/plugin`. After
editing a rule in a local clone, run `/plugin marketplace update
vsvietkov-toolkit` to pick up the change.

## Usage

From inside a target project, run the command to copy rule files into that
project's `.claude/rules/`:

```
/rules:install              # install all
/rules:install makefile     # install just one
/rules:install comments env-files
/rules:install writing-rules  # the meta-rule: how to write the others
```

The command copies the selected rule files into the project's `.claude/rules/`
(asking before overwriting an existing file). Each rule's `paths:` frontmatter
makes it auto-load whenever a matching file is edited — no further wiring needed.

The installed files are starting points — trim them to fit the project.
