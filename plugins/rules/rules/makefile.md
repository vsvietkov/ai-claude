---
paths:
  - "**/Makefile"
  - "**/*.mk"
---

# Makefile Rule

This rule governs all Makefile changes. A Makefile is a project's task index —
keep it self-documenting so `make help` is the one place anyone looks to see
what they can run.

---

## 1. Structure

- Declare every **command** target in `.PHONY` at the top of the file — a target that runs
  something rather than producing a file of its own name (`help`, `lint`, `test`, `run`).
  A target that **does** produce the file it is named after (a built binary, a generated
  artifact) is a real target and must **not** be phony: marking it phony tells Make the
  file is never up to date, so it rebuilds on every invocation and incremental builds stop
  working.
- Group related targets into **sections** delimited by Unicode dividers (§3).
- Define the container/exec invocation once as a variable near the top of the
  file and use it everywhere — never inline `docker exec` / `docker run` (or
  an equivalent tool invocation) directly in a recipe.
- Ship a self-documenting `help` target, driven by the `## ` tail comments
  (§2), and set it as `.DEFAULT_GOAL` so a bare `make` prints the index.

---

## 2. Comments

**Every target carries an inline `## <description>` tail comment** on the target
line. This is the single source of truth for what the target does and is what
`make help` surfaces.

```makefile
migrate: ## run pending database migrations
	$(EXEC) db-migrate up
```

Keep descriptions short (one clause, no trailing punctuation). Use the section
divider's intro block (§3) for shared context.

**Do NOT** add a multi-line comment block immediately above a target. The one
exception: a target that accepts make variables may carry **one** additional line
directly above showing a concrete example. No other pre-target comments are allowed.

```makefile
# Example: make seed-user email=me@example.com password=secret
seed-user: ## create a test user (vars: email, password — both optional)
	$(EXEC) user-create $(if $(email),--email=$(email)) $(if $(password),--password=$(password))
```

---

## 3. Section dividers

Group related targets under a Unicode divider:

```makefile
# ─── Database ────────────────────────────────────────────────────────────
# Targets wrap commands against the {service} container (host-only).
migrate: ## run pending migrations
	...
```

The divider line is mandatory; the explanatory block below it is optional and
should describe shared requirements, prerequisites, or conventions that apply to
**every target in the section** (e.g. "requires the devcontainer CLI",
"host-only"). Per-target context belongs in the inline `##`, not here.

---

## 4. Optional variables

Pass optional make variables to commands using the `$(if ...)` guard so unset
variables do not produce empty flags:

```makefile
$(if $(email),--email=$(email))
```
