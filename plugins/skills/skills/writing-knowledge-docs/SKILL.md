---
name: writing-knowledge-docs
description: Use when creating or updating a knowledge-base doc — a durable, plain-prose explanation of how a subsystem or feature actually works, written for a future engineer or a non-developer. Enforces frontmatter, the technical/non-technical split, portable markdown, grounding every claim in code you have actually read, and keeping the docs index and any README/CLAUDE pointers in sync.
---

# Writing Knowledge Docs

## Overview

A knowledge base holds durable explanations of **how the running system
behaves** — the why and how behind a subsystem or feature, written for a future
engineer or a non-developer. The repository is the **source of truth**; any wiki
or portal only mirrors it.

These docs are for **architectural and sequence understanding** — the shape of a
subsystem and how its pieces flow — not a line-by-line account of the logic.
Pitch them at that altitude: explain the structure and the flow, and let the
specifics live in the code.

This is distinct from:

- **Code-writing rules/conventions** — how to *write code* in this repo.
- **Source-code comments** — also for developers, but tied to the **specific
  logic** at that spot in the code; a knowledge doc stays at the
  architecture/flow level.
- **`README.md` / `CLAUDE.md`** — kept brief; they *link here* for detail.

A knowledge doc is the place for narrative detail you would otherwise be tempted
to inline into a README: lifecycles, trade-offs, bottlenecks, non-obvious
gotchas.

## When to use

- Creating a new knowledge doc, or
- Updating an existing one (behavior changed, or the doc drifted from the code).

## Hard rules

- **Ground every claim in real code.** Read the actual files before writing —
  never describe behavior from memory or assumption. The whole value of the base
  is that it is accurate and current. Cite file paths so a reader can verify.
- **Keep the index and pointers in sync** in the same change — a new doc is not
  done until its index row and the scoped pointer(s) exist.
- **Don't publish to an external system as part of this skill.** Writing the
  repo doc and mirroring it to a wiki/portal are separate steps; leave any
  external-page-id frontmatter blank.

## Checklist

Track a to-do item per step and do them in order.

1. **Locate the doc.** Use the project's existing docs home if it has one;
   otherwise `docs/knowledge/<scope>/<topic>.md` is a good default, where
   `<scope>` is the domain (e.g. `backend`, `frontend`, or a cross-cutting name)
   and the filename is the topic in kebab-case (`authorization.md`). For an
   update, open the existing file.
2. **Decide `technical`.** Ask: *does this doc carry value for non-developers*
   (PMs, stakeholders, operators, end users)? If yes → `technical: false`. If it
   is purely engineering interest → `technical: true`.
3. **Research the code.** Read the real source for everything you will claim.
   Collect the file paths you will cite. Do not proceed on assumptions; if
   something is unclear, read more or ask.
4. **Write the frontmatter** (see below).
5. **Write the body** in the required structure for the `technical` value
   (below), in portable markdown (below).
6. **Update the index** — add or edit the doc's row in the docs index (e.g.
   `docs/knowledge/README.md`).
7. **Add/refresh the scoped pointer(s)** — a brief reference in the relevant
   scope's `CLAUDE.md` and/or `README.md` linking to the doc. **No more than two
   sentences** per reference: name the feature and defer detail to the doc —
   never summarize it. If a reference has grown longer than that, trim it back to
   the link.
8. **Self-review** — frontmatter present, exactly one H1, the two-block rule
   honored if non-technical, no raw HTML, every non-trivial claim traceable to a
   cited path, links resolve.

## Frontmatter

```yaml
---
technical: false        # false → also carries non-dev value → two blocks required
---
```

Keep frontmatter minimal. If the project mirrors docs to an external system,
carry a **stable** page identifier here (one that survives moves and retitles,
unlike a pretty URL) and leave it blank until first published.

## Required structure

**One `# H1`** — the page title.

- **`technical: false`** — the body MUST be exactly two top-level blocks, in
  order, separated by a `---` horizontal rule:
  - `## Overview` — for the **person who uses the system** (opens the app, calls
    the API, operates the service), not for an engineer. State **this feature's
    actual behavior and settings** in concrete terms: the real roles and what
    each can do, the real limits/lifetimes/defaults, the observable rules. Do
    **not** explain general concepts ("what is authentication?", "what is a
    cache?") — assume the reader knows them; the doc is about *this* feature, not
    the topic in the abstract. No code paths, type names, or file references.
    Prefer concrete facts and small tables over prose; an example beats a
    definition ("sign in → 24h session; 8h idle signs you out; any request
    resets the idle clock").
  - `## Technical details` — for a **developer with codebase access**:
    components (a path table helps), data/request flow, configuration (env
    vars/settings), bottlenecks, non-obvious gotchas.
- **`technical: true`** — engineers-only; structure freely. Still lead with a
  short framing paragraph before diving in.

## Portable markdown

Keep to portable markdown so the doc renders cleanly wherever it is viewed or
mirrored (GitHub, a wiki, an internal portal):

- ATX headings only (`#`, `##`, `###`); **exactly one H1**.
- GFM pipe tables; no nested tables.
- Fenced code blocks with a language tag.
- **No raw HTML** — many importers/renderers mangle it.
- **Prefer ASCII diagrams** inside a fenced block over Mermaid or images (see
  [Diagrams](#diagrams) below).
- Links to other docs are relative repo paths; external links are absolute.

## Diagrams

Because these docs live at the **architecture/flow altitude**, a diagram is
often the clearest way to show a sequence or a component graph. **Prefer a
hand-drawn ASCII diagram** in a plain fenced block:

- It renders identically everywhere (repo, terminal, wiki, PR) — no plugin,
  extension, or JS renderer required, unlike Mermaid.
- It diffs as text, so a reviewer sees exactly what changed.
- It reads inline without clicking through, unlike an exported image.

Draw the flow **top-to-bottom** with `│` / `▼` for the main path, `├─` / `└─`
for branches, and trailing text to annotate each step. Keep it to the shape and
the flow — the diagram complements the prose, it doesn't replace reading the
code. For example:

```
HTTP request
  │
  ▼
session middleware ──── loads the session; slides the idle expiry on the way out
  │
  ▼
authorization gate ──── per guarded field:
  │      ├─ role allowed        → continue
  │      └─ no/insufficient role → 401 / 403
  ▼
resolver → repository → database
```

Reach for Mermaid or an image only when the target definitely renders it *and*
ASCII genuinely can't carry the shape (e.g. a dense graph); otherwise ASCII
wins.

## Red flags

- "I'll open the Overview by explaining what authentication/caching/etc. *is*" —
  no: that is an encyclopedia article. State *this* feature's concrete behavior
  and settings for someone using it; assume the general concept is understood.
- "I'll describe how it works from what I remember" — no: read the code first.
- "It's technical, so I'll skip the Overview block" — only if `technical: true`;
  a `technical: false` doc MUST have both blocks.
- "I'll inline the full detail in the README too" — no: the README gets one
  brief pointer line; detail lives only in the knowledge doc.
- "I'll add a `<details>`/HTML block for collapsing" — no: raw HTML breaks many
  importers.
- "I'll draw the flow as a Mermaid diagram / paste a screenshot" — prefer an
  ASCII diagram; it renders everywhere and diffs as text. Reach for Mermaid or
  an image only when ASCII genuinely can't carry the shape.
