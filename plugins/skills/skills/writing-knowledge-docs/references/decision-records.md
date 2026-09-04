# Writing a Decision Record

A record is a position taken deliberately, and it is **dated and immutable**. It says what was
chosen and why, at a moment — so it cannot go stale, because it never claimed to be current.
The knowledge doc is the only thing that claims to be current.

`SKILL.md` owns the rules a record shares with a knowledge doc: the two durability tests, the
citation discipline (point at the file, never transcribe it), and how to write the prose. They
apply here unchanged. This file holds only what is specific to a record.

**Supersede, never edit.** A record that no longer holds keeps its text, takes
`status: Superseded`, and gains one line naming what replaced it.

## When a change earns one

Write one when a change **accepts a risk or closes off an alternative that was ours to
reject**. Name the alternative, and name who could have chosen it: a constraint imposed from
outside — an upstream's fixed contract, a platform scheme, a library's API — is a
*requirement*, and complying with it decides nothing. Neither does building a component the
way `.claude/rules/` already prescribes.

## Shape

A record is `docs/decisions/YYYYMMDDHHMMSS-kebab-title.md`, titled with the position rather
than the topic, where the id is the UTC timestamp it was written (`date -u +%Y%m%d%H%M%S`) —
that avoids the collision a sequential "next free number" hits when two branches pick one
independently. Its frontmatter:

```yaml
---
status: Accepted        # Accepted · Open prerequisite · Superseded
date: 2026-09-02        # the day it was written; never changes
---
```

Three headings, in order, and keep it under a page:

| Heading | Holds |
|---|---|
| Decision | What was chosen, in one or two sentences |
| Context | What forced the choice — the constraint, not the history |
| What it costs | The part somebody will want to call a bug |

Where a knowledge doc owns the mechanism, *Context* links it instead of restating it — a
record argues a position, and a mechanism written twice drifts in one of the two copies.

## Checklist

Track a to-do item per step and do them in order.

1. **Confirm it qualifies** — an alternative that was ours to reject, not a requirement.
2. **Locate it.** `docs/decisions/YYYYMMDDHHMMSS-kebab-title.md`, timestamped now in UTC
   (`date -u +%Y%m%d%H%M%S`).
3. **Read the real source** for the constraint you are recording. It is a claim like any
   other, and it is pointed at like one.
4. **Write `status` and `date`**, then the three headings in order.
5. **Add the register row** in `docs/decisions/README.md`.
6. **Link it from the knowledge doc** that covers the mechanism, inline, where the position
   matters. If no doc covers it yet, nothing is owed.
7. **Self-review** — one H1, three headings in order, claims pointed at real paths, links
   resolve.

## Red flags

- "I'll record which scheme this client authenticates with" — no: that is the upstream's
  contract, a requirement we complied with. A record needs an alternative we declined.
- "I'll update the old decision record to match what we do now" — no: supersede it. A record
  is dated, and editing one rewrites history.
- "This 'Not done' section documents what's left" — no: an open prerequisite is a record with
  that status; anything merely planned belongs in the issue tracker.
