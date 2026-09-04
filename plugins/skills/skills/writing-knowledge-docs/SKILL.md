---
name: writing-knowledge-docs
description: Use when creating or updating a knowledge doc under docs/knowledge/ — a durable explanation of how a subsystem or a flow through it behaves — or when writing a decision record (ADR) under docs/decisions/. Enforces the durability test, pointing at files rather than transcribing them, the plain-language opener, the length budget, grounding every claim in code actually read, and keeping the index and the register in sync.
---

# Writing Knowledge Docs

## What a knowledge doc is

`docs/knowledge/` holds durable explanations of **how the running system behaves** — a
subsystem's mechanism, or a flow through it — written for a future engineer or a
non-developer. The repo is the only home; nothing here is mirrored anywhere.

A doc earns its place when the mechanism **spans packages and is not legible from reading any
one of them**, and it is written once that mechanism is actually in place, never alongside
each component that will one day take part in it. Propose one before writing it.

## The two tests

Apply both to every sentence before it goes in.

**Could a reader learn this by opening one file?** If yes, leave it out. The code is the
source of truth for what a function does; the doc is the source of truth for how the pieces
meet.

**Would the sentence survive a rewrite that preserved behavior?** If a rename or a refactor
makes it false, it is a transcript of the implementation rather than knowledge. Raise it to
the level that survives.

Together they replace every question about who the doc is for. Write for whoever needs the
mechanism.

## What belongs elsewhere

Five kinds of writing are not a knowledge doc. Each accumulates easily, because each feels
relevant while the change that prompted it is fresh:

| Not this | Because | Put it |
|---|---|---|
| A trade-off argued at length | It is a position, held at a moment | A decision record |
| How to test the thing | It is a convention, not a mechanism | `.claude/rules/` |
| "It used to be X, now it is Y" | Git is the changelog | Nowhere — state what *is* |
| An inventory of every X the system has | The next X makes the doc wrong | The rule the set follows, plus the file that lists the members |
| How to carry out a task | It is a procedure | A skill under `.claude/skills/` |

The changelog one is easiest to miss. Where an earlier approach's failure is the reason a
reader must not revert to it, keep the warning and drop the history: write *"a token absent
from the session cache is unauthenticated"*, not *"before we read the cache directly, we
verified the signature ourselves, so we…"*.

The inventory rots with nobody touching the doc. A row per upstream client, per option, per
endpoint or per config field is right the day it is written and wrong the day the next one
lands — and nothing fails when it does. Ask of every table and list: *does adding the next one
to the codebase make this wrong?* The `## Components` path table is the exception, because it
maps the doc's own subject and is what a reader needs first.

## Point at the file, never transcribe it

A path is a **pointer**. A symbol is a **claim**. A pointer costs nothing to fix and saves a
reader the search; a claim about implementation is what rots.

- **Point at directories first**, files second, never a line.
  `src/http/middleware/auth/` survives a refactor that `src/http/middleware/auth/gate:74`
  does not.
- **No transcribed source code, fenced or inline.** A pasted struct literal, call expression
  or function body makes the doc a mirror of the source, and a mirror drifts silently. Inline
  backticks are the easy one to miss — `Stacks{Auth: NewGate(deps.Cache)}` mid-sentence is as
  much a code insert as a fenced block, and so is `cache.get("sessions:" + token)` inside a
  diagram. Say what the step does: *"looks the token up in the cache"*.
- **No internal identifier as the subject of a sentence.** Not *"`parseHeader` requires the
  literal prefix"* but *"the gate requires the literal prefix"*. A reader who needs the
  function finds it in the file you pointed at. The same goes for an identifier standing in
  as a noun — *"an absent token"*, not *"`store.ErrNotFound`"*.
- **Contract names stay.** The `Authorization` header format, env var names, status codes,
  HTTP paths, the `sessions:<token>` key layout — these are observable behavior, not the
  implementation of it, and a reader cannot derive them from anywhere else.

Grounding is non-negotiable: **read the real source before you write.** A pointer you did not
open is worse than no pointer. Fenced blocks are still right for what a *caller* sees — a
header line, a request body, a flow diagram.

## Shape

- Path is `docs/knowledge/<scope>/<topic>.md` — `<scope>` is the domain (`backend`,
  `frontend`, or a cross-cutting name), the filename the topic in kebab-case.
- **No frontmatter.** Exactly one `# H1`, which is the page title.
- **Open in plain language.** The first section says what the thing does, what a caller
  observes, and the concrete rules — the real limits, defaults and statuses. Do not explain
  the general concept ("what is a cache?"); the doc is about this system, not the topic in the
  abstract. Prefer concrete facts and small tables to prose.
- Engineering detail follows, under as many headings as the subject needs. A `## Components`
  path table is the usual opener for it.
- **About 120 lines. Past 160, split the doc** — one that long is covering two subjects.
- **Portable markdown**: ATX headings only, GFM pipe tables, fenced blocks with a language
  tag, no raw HTML. Links to other docs are relative repo paths; external links absolute. It
  then reads the same in the repo, a terminal and a PR.
- Name headings in parallel form: a noun phrase for a reference section (`Components`,
  `Gotchas`), a `How …` clause for a flow.
- A `Gotchas` section holds **runtime surprises a reader will actually meet** — not test tips,
  not history, not open work. It becomes a catch-all if you let it.

## How to write the prose

- **Active voice, concrete subject.** Name the thing that acts: "the gate rejects the
  request", not "the request is rejected".
- **Positive form.** "An absent token is unauthenticated" beats "a token is not treated as
  valid if it is not present".
- **Definite and specific.** "A 24-hour session, 8 hours idle" beats "a reasonable lifetime".
- **Omit needless words.** Cut *it should be noted that*, *in order to*, *serves to*.
- **One topic per paragraph, topic sentence first.**
- **Emphatic word last.** End the sentence on what matters, not on a qualifier.
- **Parallel form for co-ordinate ideas**, in prose and in headings alike.

Never: puffery (*crucial*, *pivotal*, *vital*, *testament*), empty `-ing` clauses (*ensuring
reliability*, *providing flexibility*), promotional adjectives (*seamless*, *robust*,
*powerful*, *cutting-edge*), *delve* / *leverage* / *realm* / *multifaceted*, bold on every
other phrase, emoji.

Two rewrites, each fixing both a prose fault and a citation fault:

> It should be noted that requests which do not carry a valid token are not permitted to
> proceed and will be rejected by the middleware.

> The gate rejects a request whose token the cache does not hold.

> `parseHeader` in the auth middleware requires the literal `SessionKey ` prefix and
> `Type=Session`, then reads `Token` and `TenantId` by name.

> The gate requires the literal `SessionKey ` prefix and `Type=Session`, then reads `Token`
> and `TenantId` by name, so the parameters may arrive in any order
> (`src/http/middleware/auth/`).

## Diagrams

Draw one when sequencing or branching is hard to follow in prose. Not every doc needs one — a
diagram of a single invariant is decoration.

Prefer ASCII in a plain fenced block. It renders identically in the repo, a terminal and a PR,
and it diffs as text, so a reviewer sees exactly what changed. Draw top-to-bottom with
`│` / `▼` for the main path, `├─` / `└─` for branches, and trailing text annotating each step:

```text
HTTP request
  │
  ▼
request logging ─────── assigns the request id
  │
  ▼
auth gate ───────────── looks the session token up in the cache:
  │      ├─ absent from the cache      → 401
  │      ├─ tenant mismatch            → 403
  │      └─ present and matching       → continue
  ▼
handler → service → data store
```

Reach for Mermaid or an image only when ASCII genuinely cannot carry the shape.

## How a claim goes wrong

Each of these produced a false sentence in a doc that had been researched and believed. They
are worth checking by name, because each feels like grounded work while you do it:

- **A comment or an env template is not evidence.** It states an intent; the code states the
  behavior. Where `.env.example` says *"tests never load real credentials"*, open the loader
  and read what happens to a variable the file leaves unset.
- **Name the layer that performs the effect.** A constructor that returns an error does not
  stop a process; the composition root that receives it does. A claim crossing a layer is
  researched only once you have read the caller too.
- **Prose you carry over in an edit becomes your claim.** Trimming a passage adopts every
  sentence you keep. Verify those exactly like the ones you write.
- **Absolutes are where a doc turns false.** *every*, *never*, *cannot* — scope each to the
  mechanism that enforces it, or drop it.
- **Read the sibling doc that owns the neighbouring mechanism** before describing it yourself,
  then link it rather than restate it. It is both the fastest check and the right home.

## Decision records

A decision record under `docs/decisions/` is a position taken deliberately — what was chosen
and why, at a moment — and it is dated and immutable, so it cannot go stale. The knowledge doc
is the only thing that claims to be current.

**A knowledge doc links a record inline**, in the sentence where the position matters, and
only where a reader would otherwise mistake it for an oversight and "fix" it. There is no
section for them.

To write or supersede a record, read
[`references/decision-records.md`](references/decision-records.md) — it holds the test for
whether a change earns one, the filename and frontmatter, the three headings and the checklist.

## Checklist — knowledge doc

Track a to-do item per step and do them in order.

1. **Locate it.** `docs/knowledge/<scope>/<topic>.md`. For an update, open the existing file.
2. **Read the real source** for everything you will claim, plus the sibling docs that own the
   neighbouring mechanisms. Collect the paths you will point at. Do not proceed on
   assumptions; if something is unclear, read more or ask.
3. **Write it** — one H1, the plain-language opener, then the engineering detail. No
   frontmatter.
4. **Cut what belongs elsewhere.** Re-read against the table above: a trade-off becomes a
   decision record and an inline link, test guidance moves to `.claude/rules/`, changelog
   narration is cut to a present-tense warning or deleted, an inventory becomes the rule plus
   a pointer. Do this before the index step, because it changes what the summary says.
5. **Update the index** — add or edit the doc's row in `docs/knowledge/README.md`.
6. **Add or refresh the pointer** in the root `CLAUDE.md` and/or `README.md` — **at most two
   sentences**, naming the subject and deferring the detail. A doc's arrival is when an
   existing passage gets **cut**, not extended.
7. **Self-review** — both tests applied to every sentence; no fenced source code, no internal
   identifier as a subject, no unscoped absolute; within the length budget; links resolve; and
   the prose read once for its own sake against the section above.

## Red flags

- "I'll paste the struct literal so the reader sees the wiring" — no: that is a code insert.
  Point at the file that holds it.
- "I'll name the function so the sentence is concrete" — no: say what the component does. The
  function is in the file you pointed at.
- "I'll describe how it works from what I remember" — no: read the code first.
- "I'll open by explaining what authentication/caching *is*" — no: that is an encyclopedia
  article. State this system's concrete behavior for someone using it.
- "I'll inline the full detail in the README too" — no: the README gets a pointer; the detail
  lives in the doc.
- "I'll explain here why we accepted this risk, since the context is fresh" — no: that is a
  decision record, named in one sentence and linked.
- "I'll note how to test this while I'm describing it" — no: test conventions live in
  `.claude/rules/`. Naming a specific test method in a knowledge doc is the clearest form of
  this mistake.
- "A table of every client and the mock beneath it shows the reader the whole set" — no: the
  next client makes it wrong, and nothing fails when it does. Give the rule the set follows
  and cite the file that holds the members.
- "I'll explain what this replaced, so the reader understands why it changed" — no: git is the
  changelog. Keep the warning in the present tense and drop the before-and-after.
