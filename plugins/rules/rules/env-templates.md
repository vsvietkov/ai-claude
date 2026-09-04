---
paths:
  - "**/.env.example"
  - "**/*.env.example"
---

# Environment Templates Rule

The committed `*.example` templates are the **documentation of every setting the app can
read**, and the only place a newcomer discovers what to set. This file governs what goes in
them and how it is written. What a setting *is* on the code side — the typed field, the
binding, the default, the validation — belongs wherever the project defines its config type,
and that is the half this rule does not own.

**A template is an index, not an explanation.** It carries a var's name, its value, and at most
two comment lines saying what that value names (§3). Everything else a reader might want — the
mechanism behind it, the position behind a default, the procedure for pointing it elsewhere —
has a home at another documentation level and is written there. A template is the level nothing
compiles, tests or type-checks against the code, so prose put here goes false in silence; the
budget in §3 is what keeps that surface small.

**This file holds only what constrains an edit.** How the loader finds a template, overlays it
and validates what it binds is a knowledge doc; don't restate the mechanism in a template or
here.

---

## 1. Adding a var

In order, for every var the config loader can bind:

1. **Put it in the section that owns the concern**, beside the vars it belongs with. A var
   belongs to whatever code consumes it, not to whatever code happens to pass it along. Open a
   new banner (§2) only when the concern itself is new — a var that fits an existing section
   does not get one.
2. **Write its comment lines directly above it**, no blank line between, within the budget §3
   sets.
3. **Decide live or commented** (§4). The default case is commented, showing the default value.
4. **Repeat in the test template** — same section, same position, **no description**. It is
   commented at its default unless the suite overrides that default (§4).
5. **Grep every template for the new `ENV_NAME`** and confirm it appears in each (§5).

A var the orchestrator interpolates but the config loader never binds is not this procedure at
all — it goes to the orchestrator's own template alone (§5).

## 2. File and section structure

- **The header block is three or four lines**: what the file is, how to use it (copy to the
  real name, which is gitignored), one link to the mechanism, and that it is committed so no
  real secret belongs in it. A new template gets one before it gets a var. It states the file's
  role and stops — the loader's behaviour belongs to the knowledge doc, and a header explaining
  it is a copy nothing keeps in sync.
- **A section is opened by a one-line banner** naming the concern and, in parentheses, the code
  that consumes it: `# --- Session cache (config, cache client) ---`. The consuming packages
  are the point — they are how a reader finds what reads a var without grepping for it.
- **A banner is that one line.** Nothing goes beneath it but a blank line and the first var's
  own comment. Something true of every var in the section is either true of each one, in which
  case it belongs to the run of vars it describes (§3), or it is a mechanism, which is not in a
  template at all.
- **The siblings carry the same sections in the same order** (§5), so a reader comparing them
  scans rather than searches.

```dotenv
# ─── Database (config, storage) ───────────────────────────────────────────
# Connection string the app dials on startup.
# REQUIRED: the process exits before serving without it.
DATABASE_URL=postgres://user:pass@localhost:5432/app

# Optional; default 25.
#DATABASE_MAX_OPEN_CONNS=25
```

## 3. The comment budget

**A var — or a run of closely-related vars sharing one explanation, such as a set of timeouts or
a paired minimum and maximum — gets at most two comment lines.** They sit directly above it, and
they are:

- **The marker, on the line touching the var, always present.** `REQUIRED:` (literal) followed by
  what fails without it, or `Optional;` with `default X`, or with what the empty value means
  where that is the interesting case.
- **A usage line above the marker, only where the name and the marker leave the value
  ambiguous.** It says what the value *names or selects*, and nothing else. Omit it rather than
  pad it: a line written to fill the slot is the line that grows into a paragraph later.

**The test for any line you are about to write: can it become false without this var changing?**
If it can, it belongs at another level. Four shapes fail that test, and each has a home:

- **The application's current state** — what does not exist yet, what is inert, why something is
  left commented. Nothing brings you back here when it stops being true, so say nothing.
- **How the consuming code uses or validates the value** — that a zero reaches a library as its
  own default, that one duration is validated below another. The config code and its validation
  are the copy that cannot go stale; write it there.
- **Why the default is what it is** — a position, so a decision record.
- **A procedure** — how to point the var somewhere else, how to obtain a value. That is setup,
  which the project's setup docs own.

Two constraints on what survives:

- **Cite a position, never re-argue it.** Where the *why* matters, a bare pointer to the record
  or the doc goes *inside* one of the two lines. A citation buys no third line, and a paraphrase
  is a second copy that nothing keeps in sync.
- **A value naming another service's instance says which instance**, in its usage line, because
  a reachable-but-wrong address passes the startup probe and then fails as authorization errors
  — which reads as a broken credential rather than a broken address.

## 4. Live or commented

**A var is uncommented with a real value only when it is genuinely live** — required with no
external injection, or a value that feeds local development out of the box. **Every other var is
commented out showing its default**, which is what makes the file document the defaults rather
than merely list the names.

In a test template the test is narrower: **a var is live only where the suite overrides a
production default.** A var left at its default stays commented, and a non-obvious override
carries **one** line saying what the override buys, held to §3's test like any other line.

**No real secret in any template** — they are committed. A secret-shaped var is present but
blank or an obvious placeholder.

## 5. The siblings invariant, and what is not a sibling

The primary template and the test template are **siblings**: both document **every** var the
config loader can bind, not only the ones carrying a non-default value. **A var missing from
either is a bug**, so a change to one is incomplete without the matching change to the other.

**The committed templates end in `.example`** (`.env.example`, `.test.env.example`); **the
runtime files they template use the leading-dot form** (`.env`, `.test.env`) — that is the
literal name the loader and any test-harness write both use. Don't "correct" a runtime filename
by stripping the leading dot.

**A template for what only the orchestrator reads is not one of them.** Where a container or
deployment tool interpolates vars the process never sees, they belong in that tool's own
template rather than a section of the app's: nothing in it gets a typed field, a binding, or a
test-template entry, and nothing in it is a config value.

## Red-flag phrasing that signals a violation

- "I added the field and wired it up, that's enough" — no: the template must gain the var too,
  or the next person never learns it exists.
- "I'll list the var in the primary template but skip the test one since the suite doesn't set
  it" — no: the sibling still documents it, commented, at its default.
- "This var is unrelated to the others, I'll start a new banner for it" — only if the *concern*
  is new; otherwise it belongs in the section that owns it, however few vars that section has.
- "Two lines isn't enough — this one is genuinely subtle" — the subtlety is the signal that it
  belongs at another level, not that the budget is wrong. Write it where it will be read against
  the code, and leave the template naming the value.
- "The template is where someone will actually read this warning" — it is also where nothing
  checks it, so it is where the warning goes false unseen. A gotcha belongs in the knowledge doc
  that owns the mechanism.
- "This is only true today, but it's useful context" — no: that is a snapshot in a file no diff
  brings you back to, and the reader it misleads is the one who trusted it.
- "The whole section shares one explanation, so it goes under the banner" — no: a banner is one
  line. If it is true of each var it belongs to the run of vars it describes; if it is a
  mechanism it is not in a template.
- "The host just needs a value, the usage line can say `the cache host`" — no: where it points
  at another service's instance, say which one; a reachable wrong address starts cleanly and
  then rejects every request.
- "It has a default, so I'll write it live to show the value" — no: commented **showing** the
  default is how the file documents defaults; live means genuinely live.
- "The container reads this var, so it belongs in `.env.example`" — no: where the orchestrator
  interpolates it and the config loader never binds it, it belongs in the orchestrator's
  template alone. Adding a config field for it would be the actual bug.
