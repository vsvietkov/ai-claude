---
paths:
  - "**/*"
---

# Code Comments Rule

This rule governs source-code comments — doc/header comments and inline comments.
It covers only what belongs in a comment at the point of the code; nothing else.

The guiding split: a comment says **why**, the code says **what**. Keep comments
short, local, and honest about that division.

---

## Doc comments

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

---

## Inline comments are *why*, not *what*

An inline comment explains **why** a line exists — the intent or the non-obvious
reason — ideally in **one line**. It never restates what the code already says.

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

## Runtime narration is *what*; the comment is *why*

Inside a function body there are two complementary tools:

- **A structured/debug log line answers "What are we doing?"** — a runtime-traceable
  narration of a meaningful step. Prefer it for non-obvious or trace-worthy steps;
  it is far more useful than a static "what" comment because it can be turned on to
  follow a live request.
- **A `// comment` answers "Why are we doing this?"** — see the section above.

**Do NOT** require a log line for every step — silence is fine for the obvious; do
not narrate trivia. **Do NOT** write a "what" comment next to a log line that
already says the same thing — that is redundant noise.

---

## Keep the *why* local and short

The *why* in an inline comment is **local**: specific to this line, at this spot. A
sprawling rationale — design trade-offs, why-this-approach-not-that — does not
belong inline. At most leave a one-line note and keep the long-form reasoning out of
the code.

```
// Bad — a design essay inlined into source:
// a hand-written fan-out avoids pulling in a third-party multi-handler dependency,
// which would also drag in two transitive packages we don't want, and anyway the
// loop is only a few lines so the abstraction wouldn't pay for itself here...

// Good — one line; the reasoning stays out of the code:
// hand-written fan-out — avoids a third-party multi-handler dependency.
```

---

## Audit before reporting done

Comments drift over a long task — default habits creep back toward over-explaining
and "what" comments. So a cleanup pass is the gate for "done":

**Every time you are about to report an implementation complete — including any
small follow-up fix — review each comment you added or changed in the diff against
the rules above, and cut or tighten every one that violates them.**

It is fine to leave comments rough while the code is still churning; this pass is
where they get fixed.

---

## Red-flag phrasing that signals a violation

- "I'll add a comment walking through what this function does" — no: the doc
  comment is one line saying what it *is*; the walk-through is just the code.
- "A quick `// increment i` here will help" — no: that restates the code; leave the
  line bare.
- "I'll note next to this log line what we're doing" — no: the log already says the
  "what"; a comment there is noise.
- "I'll explain the whole trade-off behind this approach right here" — no: keep the
  sprawling rationale out of the inline comment; at most a one-line note.
