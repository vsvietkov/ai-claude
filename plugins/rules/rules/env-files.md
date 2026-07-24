---
paths:
  - "**/.env.example"
  - "**/*.env.example"
---

# Environment Files Rule

This rule governs how the project defines, reads, and documents environment
configuration. The committed `*.example` templates are the **documentation** of
every setting the app can read; the real `.env` files hold the values and are
never committed.

---

## What is committed, what is ignored

- Commit the `*.example` templates (`.env.example`, `.test.env.example`, …).
- Gitignore the real files (`.env`, `.test.env`, …) — they hold secrets and
  machine-specific values.

The `.example` file is the single place a newcomer discovers what to set: they
copy it to the real name and fill in values.

---

## Document every variable — not just the non-defaults

The `.example` template lists **every** variable the app can read, even the ones
that fall back to a default. A reader should be able to learn the full surface of
configuration from this one file.

- **File header block** — a one-line `# Copy to <real-file> (gitignored) and adjust`
  instruction, a blank `#` line, then a short prose paragraph on how the file is
  used.
- **Section banners** — group vars under a banner that names the concern and, in
  parentheses, the code that consumes it, e.g.
  `# CORS (http middleware).` Keep related vars together.
- **Per-variable description** — a short comment directly above each var (no blank
  line between), stating its purpose then a marker: `REQUIRED:` (literal),
  `Optional;`, and/or `(default X)`.

```dotenv
# ─── Database ──────────────────────────────────────────────────────────────
# Connection string the app dials on startup.
# REQUIRED
DATABASE_URL=postgres://user:pass@localhost:5432/app

# Max open connections in the pool.
# Optional; (default 25)
#DATABASE_MAX_OPEN_CONNS=25
```

---

## Live-vs-commented rule

A var is written **uncommented with a real value only when it is genuinely live** —
required with no external injection, or a value that also feeds local dev out of
the box. Every other var is **commented out showing its default** (or blank if it
has none), so the file doubles as documentation of the defaults.

---

## The siblings invariant

When there is more than one template (e.g. a dev `.env.example` and a test
`.test.env.example`), they are **siblings**: both document **every** variable the
config loader can bind. A var present in one but missing from the other is a bug.

- Per-variable descriptions live in the primary template (`.env.example`); the
  secondary one (`.test.env.example`) repeats the banners but may skip the prose,
  pointing back to the primary in its header.
- In a test template, a var is **live only when the suite overrides a default**
  (e.g. a smaller pool, a stricter log level); otherwise it stays commented at its
  default. A short rationale comment sits above a non-obvious override.

After adding a setting, grep **both** templates for the new variable name and
confirm it appears (commented or live) in each.

---

## Red-flag phrasing that signals a violation

- "I added the field and wired it up, that's enough" — no: the `.example`
  template(s) must gain the var too, or the next person won't know it exists.
- "It has a sane zero value, so it needs no default" — no: give it an explicit
  default (and document it), or mark it required; don't let a bare zero value leak.
- "I'll list it in `.env.example` but skip `.test.env.example` since the suite
  doesn't set it" — no: the sibling still documents it (commented, at its default).
- "I'll write one comment block listing several vars as bullets" — no: put a
  description directly above each var; use the banner + per-var style.
