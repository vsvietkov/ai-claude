# rules

Reusable, **language-neutral, project-neutral** convention rules extracted from
real projects and adapted for reuse. Each rule is a scoped `.claude/rules/*.md`
file; the `/install-rules` command drops the ones you want into any project.

## Rules

| Rule | Scope (`paths:`) | Governs |
| ---- | ---------------- | ------- |
| `makefile.md` | `**/Makefile`, `**/*.mk` | `.PHONY`, self-documenting `## ` target comments, the `make help` target, Unicode section dividers, `$(if …)` optional-var guards, shared `RUN`/`EXEC`/`IMAGE` vars. |
| `env-files.md` | `**/.env.example` | Commit `*.example` / gitignore real env, document every variable, live-vs-commented rule, dev/test sibling invariant. |
| `comments.md` | `**/*` | Doc comment = one-line "what it is"; inline = one-line "why"; runtime "what" → logs; keep the *why* local and short; end-of-task audit gate. |

Each rule is **independent and self-contained** — install only the ones a project
needs.

## Usage

Install the plugin, then from inside a target project run:

```
/install-rules              # install all
/install-rules makefile     # install just one
/install-rules comments env-files
```

The command copies the selected rule files into the project's `.claude/rules/`
(asking before overwriting an existing file). Each rule's `paths:` frontmatter
makes it auto-load whenever a matching file is edited — no further wiring needed.

The installed files are starting points — trim them to fit the project.
