---
paths:
  - "**/*.go"
  - "**/*.rs"
  - "**/*.py"
  - "**/*.rb"
  - "**/*.php"
  - "**/*.java"
  - "**/*.kt"
  - "**/*.kts"
  - "**/*.scala"
  - "**/*.swift"
  - "**/*.cs"
  - "**/*.c"
  - "**/*.h"
  - "**/*.cc"
  - "**/*.cpp"
  - "**/*.hpp"
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
  - "**/*.mjs"
  - "**/*.cjs"
  - "**/*.ex"
  - "**/*.exs"
  - "**/*.dart"
  - "**/*.lua"
  - "**/*.sh"
  - "**/*.bash"
  - "**/*.sql"
---

# Code Comments Rule

This rule governs source-code comments — doc/header comments and inline comments.
It covers only what belongs in a comment at the point of the code; nothing else.

**The `paths:` list above is a closed set you maintain by hand: adding a language
to the project means adding its source extension there, in the same change.** A
missing extension does not fail anything — the rule is simply absent from that
language's files, and nothing says so. The list stays source-only; a rule about
doc and inline comments has nothing to say to config, data, or prose files.

The guiding split: a comment says **why**, the code says **what**. How a subsystem
works belongs in design documentation, and a trade-off deliberately accepted
belongs in a decision log (if the project keeps one) — when a comment starts
becoming either of those, leave at most a one-line pointer and write the rest
where it belongs.

---

## 1. Doc comments

A doc/header comment (above a function, type, class, or method) is **one short,
high-level line saying what the thing is** — not how it works. Follow your
language's doc convention. Mechanics, edge cases, and rationale move into the body.

**Do NOT** write a multi-line paragraph that walks through the implementation.

```
// Before — explains the mechanics, line by line:
// adapt turns a Handler into an HTTP handler. Every response is JSON: on success
// the payload is encoded with 200; on a known app error its status and message
// are returned, and server faults (>= 500) are logged once; client errors (4xx)
// are expected and not logged. Any other error is logged and reported as a
// generic 500 so internal detail is not leaked to the client.

// After — high-level "what it is"; the details live in the body:
// adapt turns a Handler into an HTTP handler, encoding every response as JSON.
```

**Leave a member undocumented when a pattern already says what it is.** Where a
package, module, or class is built from a fixed shape — the injected-dependency
struct, its constructor, the input and result types — a doc comment on that member
restates the pattern rather than the instance, once per instance. The question that
decides it: **would the sentence read identically if copied into the next instance
built from the same pattern?** If it would, delete it; if it says something only
this instance can say — what a field means, what a value must satisfy — write it.

**Do NOT** add one back because a member is exported. Whether a doc comment is
*present* is a convention question this rule answers; a linter that checks doc
comments generally checks their *form*.

---

## 2. Inline comments are *why*, not *what*

An inline comment explains **why** a line exists — the intent or the non-obvious
reason — in **one line**. It never restates what the code already says.

**Draft the one line first.** Do not write a fuller explanation and shrink it
afterward — if a first draft needs trimming to fit, too much went into it to
begin with. A comment that still runs past one line once trimmed is a sign the
*why* belongs in design documentation or a decision log (§4), not that it needs
a second line to fit.

```
// Good — explains a non-obvious choice:
// Put the panic value first and the (large) stack trace last, so the useful
// fields stay near the top of the line instead of after the stack.

// Bad — restates the code, adds nothing:
// increment the counter
counter++
```

**Do NOT** narrate mechanics a reader can see. If a line needs no *why*, leave it
bare.

---

## 3. Runtime narration is *what*; the comment is *why*

Inside a function body there are two complementary tools:

- **A structured/debug log line answers "What are we doing?"** — a runtime-traceable
  narration of a meaningful step. Prefer it for non-obvious or trace-worthy steps;
  it is far more useful than a static "what" comment because it can be turned on to
  follow a live request.
- **A `// comment` answers "Why are we doing this?"** — see §2.

**Do NOT** require a log line for every step — silence is fine for the obvious; do
not narrate trivia. **Do NOT** write a "what" comment next to a log line that
already says the same thing — that is redundant noise.

---

## 4. Local *why* vs. architectural *why*

The *why* that stays inline is **local**: specific to this line, at this spot.
Cross-cutting rationale has its own home — how a subsystem works belongs in
design documentation, and a trade-off deliberately accepted — why this approach,
why not the alternative — belongs in a decision log (if the project keeps one).

```
// Bad — a design essay inlined into source:
// a hand-written fan-out avoids pulling in a third-party multi-handler dependency,
// which would also drag in two transitive packages we don't want, and anyway the
// loop is only a few lines so the abstraction wouldn't pay for itself here...

// Good — terse pointer; the trade-off lives in the decision log:
// hand-written fan-out — avoids a third-party dependency (see the decision log).
```

**Do NOT** inline a design essay. Where it explains how the subsystem works, write
it in design documentation; where it is a trade-off you accepted, write a decision
record. Either way, leave only the pointer here.

---

## Red-flag phrasing that signals a violation

- "I'll write the full explanation now and shorten it in review" — no: draft the
  one-line version first; needing to trim a first draft means too much went into
  it.
- "It's one thought, so two lines is fine" — no: a *why* that takes more than one
  line is design-doc or decision-log material — leave a pointer instead.
- "This function needs two lines to fully describe" — no: name what it is in one
  line; the rest belongs in the body, not the header.
- "A short paragraph reads better than a terse pointer" — no: this rule owns local
  *why*, not *how it works* or *what we chose* — a fuller explanation belongs in
  design documentation or a decision log.
- "Convention says every exported type gets a doc comment" — no: a sentence that
  would read identically in the next instance built from the same pattern documents
  the pattern, not the code.
- "I'll add a comment next to this log line restating what it logs" — no: the log
  line already answers "what"; a comment there is noise.
- "`**/*` would save maintaining this list" — no: the rule would then load on
  every JSON, lock-file and Markdown edit, spending the attention budget of the
  rules that do govern those files. Maintaining the list is the cheaper cost.
