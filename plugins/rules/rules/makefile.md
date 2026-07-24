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

## Structure

- Declare every target in `.PHONY` at the top of the file.
- Group related targets into **sections** delimited by Unicode dividers (see §Section dividers).
- Route repeated commands through established variables (e.g. `RUN`, `EXEC`, `IMAGE`)
  instead of inlining the same `docker exec` / `docker run` / tool invocation in
  each target.

---

## Comments

**Every target carries an inline `## <description>` tail comment** on the target
line. This is the single source of truth for what the target does and is what
`make help` surfaces.

```makefile
migrate: ## run pending database migrations
	$(EXEC) db-migrate up
```

Keep descriptions short (one clause, no trailing punctuation). Use the section
divider's intro block (§Section dividers) for shared context.

**Do NOT** add a multi-line comment block immediately above a target. The one
exception: a target that accepts make variables may carry **one** additional line
directly above showing a concrete example. No other pre-target comments are allowed.

```makefile
# Example: make seed-user email=me@example.com password=secret
seed-user: ## create a test user (vars: email, password — both optional)
	$(EXEC) user-create $(if $(email),--email=$(email)) $(if $(password),--password=$(password))
```

---

## The `help` target

Ship a `help` target that greps the `## ` descriptions so the file documents
itself. Make it the default goal so a bare `make` prints the index:

```makefile
.DEFAULT_GOAL := help

help: ## list available make targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
```

---

## Section dividers

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

## Optional variables

Pass optional make variables to commands using the `$(if ...)` guard so unset
variables do not produce empty flags:

```makefile
$(if $(email),--email=$(email))
```

---

## Don't duplicate the target list elsewhere

Never enumerate Makefile targets in a README or other doc — they drift the moment
a target is added or renamed. `make help` is the live index; link to it instead.

---

## Red-flag phrasing that signals a violation

- "I'll just inline the `docker run` here" — no: route it through the shared
  `RUN`/`EXEC`/`IMAGE` variable so every target stays consistent.
- "This target does a lot, I'll explain it in a comment block above it" — no: one
  clause in the inline `## ` tail comment; move real explanation into a doc.
- "I'll drop the `##` on this internal target" — no: every target carries one, or
  it vanishes from `make help`.
- "I'll list the available targets in the README so people can find them" — no:
  link `make help`; a hand-maintained list goes stale.
