---
paths:
  - ".claude/rules/**/*.md"
  - "CLAUDE.md"
---

# Writing Rules Rule

How to write a rule under `.claude/rules/`, and what belongs in `CLAUDE.md` above them (§11).

A rule answers *how do we do things here* — the conventions that constrain an edit — and it is
the only project documentation injected into a session automatically, on a `paths:` match. That
is what makes its accuracy load-bearing: a stale rule misinforms every edit to the files it
governs, and anything generated from these files (a review bot's config, contributor docs)
inherits the error. Everything else has a different home — how a subsystem works is a knowledge
doc, what was chosen and what it cost is a decision record, why this line exists is a comment.

Writing one from cold is §12, which orders the constraints below into a sequence and shows the
shape they produce. This rule is one audience — whoever is writing a rule — and all constraints,
so its length is correct and stays (§10).

---

## 1. The staleness test

**Ask of every sentence: can this become false without anyone editing this file?** If so it
belongs elsewhere — a knowledge doc for a mechanism, a decision record for a position, or
nowhere, because the code already says it. A rule that describes the current wiring goes stale
on a diff that never touches it, and nothing will tell you.

## 2. Write constraints, not descriptions

- **State every constraint as an imperative or a prohibition**, with its reason attached as a
  subordinate clause: *"X, because Y."* The reason is what keeps a constraint from being
  rationalized around at an edge case it never expected. Standalone descriptions of a
  mechanism belong in a knowledge doc, not a rule.
- **Open with the boundary** — one short paragraph naming what this file holds and where the
  mechanism lives. It is what stops the next editor re-adding the narration you removed.
- **Prefer the general constraint to the specific instance.** *"Middleware that must answer
  before routing cannot live in a route stack"* governs a middleware nobody has written yet;
  the same rule written about one existing middleware needs rewriting when a second arrives.

## 3. State where the rule does not apply

**Where a constraint has a legitimate exception, name it — as a test, not as a list of
blessed cases.** An unbounded *always* gets applied at the edge it never anticipated, and the
reader who watches it produce a bad result there stops trusting it everywhere; a stated
boundary is what keeps the constraint enforceable in the cases it does own.

Write the exception as the question that decides it (*"is this a shared or delegated sub-step,
or is it the whole operation?"*), so it settles a case nobody has met yet. A boundary drawn by
enumerating the exceptions that exist is §4's failure in another shape.

**Don't add a clause disclaiming an exception when none applies** — settling on "no exception"
ends the search. The failure to guard against is inventing a plausible-sounding exception that
was never decided, not staying silent on a constraint that plainly has none.

## 4. Never write a list that must be complete to be correct

**A list goes stale by missing its newest item, and no diff tells you.** Don't enumerate the
packages under a tree, the fields on a struct, the members of a chain or the files in a
directory — **point at the code that is the list**, and keep only what reading it cannot tell
you: the ordering constraint, the reason a member sits where it does.

One exception: a **closed set the rule itself instructs you to update in the same change**, as
an enum whose extension is a reviewed decision. The list is safe because the instruction to
maintain it sits beside it.

## 5. Verify every claim you make

**Confirm a package, type, function, field, file, script or build target exists before naming
it.** A rule can describe a subsystem in full, authoritative detail while it exists nowhere in
the repo, and the prose gives no sign — unverified reads exactly like verified. A named symbol
is a claim; check it like one.

**A constraint asserting where something happens gets a mechanism, named in the rule.** Prose
saying a step lives in exactly one place, or never appears in a tree, is a claim the code can
contradict silently — and a rule arrives on a `paths:` match, so a false one misinforms every
edit it reaches rather than merely failing to inform. Pair it with a lint rule or a named test,
and cite that enforcer here so the claim and its proof travel together. What decides whether
one is owed: **could a reviewer disprove the sentence by pointing at a file?** Then something
should fail when they can.

**Where this does not apply:** a constraint about judgement — which layer a step belongs to,
how to name a thing, what a comment may hold — has nothing to fail on, and inventing a check
for it buys a false sense of coverage. The test above is the boundary: only a claim a reviewer
could disprove from a file is one a mechanism can hold.

## 6. One exemplar, never an inventory

A constraint stated in the abstract leaves *"what does compliance look like here"* unanswered,
and the reader fills that gap by guessing. So a rule may anchor itself in real code, under two
limits:

- **One designated reference implementation per rule — or per distinct pattern within it, when
  the rule genuinely governs more than one shape**, named as such in the opening boundary —
  *"`<pkg>` is the reference handler"*. A second exemplar is only for a pattern the first
  doesn't cover, never a second instance of the same one.
- **At most one named instance per constraint, and only where the constraint alone is
  ambiguous.** The test is whether the constraint still stands when the instance is deleted:
  if it does, the name is calibration and may stay; if the rule collapses without it, the
  constraint was never written and the name is doing its job.

What stays banned is the **inventory** — *"the ones that exist, and why"*, a count, a table of
every current case. That is §4 wearing an example's clothes: it rots by omission, and the next
case added is the one the rule then silently excludes. An invented name is still the right
default for a code block, where the point is the shape and a real path adds nothing.

## 7. No tense markers

**Never write "today", "currently", "not yet", "so far" or "when that lands".** A sentence
needing one is a snapshot: either it is an invariant, so drop the marker and confirm it still
holds, or it belongs in a decision record — the one layer allowed to be a dated position.

## 8. One fact, one home — number the sections and link to them

**Name the rule that owns a constraint and link to it; never restate it.** Two copies disagree
eventually and the reader cannot tell which is current. Where two rules genuinely need the same
fact, the one whose `paths:` are narrower owns it.

**Number every `##` heading, and point a cross-reference at the section: `errors.md` §2, never
`errors.md` alone.** A file-level pointer bills the reader for the whole file, which is exactly
what makes restating the fact locally look like the cheaper move — so section precision is what
keeps this rule affordable rather than aspirational.

**Leave the closing `## Red-flag phrasing that signals a violation` heading unnumbered** —
numbering exists to make a cross-reference precise, and nothing ever points at a red-flag
section by number, so there is no reader for that pointer to serve.

The exception is a pointer that defers no fact — naming another rule as a whole (*"the
integration suite has its own rule"*), which is a signpost and takes no section.

Repo facts do belong here in one case: when **several places must move together** and the file
being edited gives no hint of the others. That checklist is the most valuable thing a rule can
carry. An inventory of what those places currently contain is not.

## 9. Scope `paths:` to what the rule constrains

**What reaches a session is not this file — it is the sum of every rule whose `paths:` match
the file being edited.** A rule that fires on a file it has nothing to say about spends another
rule's attention budget. Two numbers, at two scopes: §10's ~200 lines diagnoses a single
rule; the ~600 below diagnoses what one file's edit loads in total.

- **Give a rule the narrowest `paths:` that still catches every edit it constrains.** Reach for
  `**/*.<ext>` only when the rule genuinely governs every one of them.
- **A rule with two audiences is two rules.** When half of a file constrains the composition
  root and half constrains every call site, the blanket glob the union needs makes the
  call-site half pay for the other — split it and give each its own `paths:`.
- **Measure before adding a glob**: `wc -l` every rule whose `paths:` match a representative
  file in each tree, and sum them. Most of that total is the floor — the handful of rules that
  legitimately govern every file of a language — so the number to watch is what a *domain* rule
  adds on top of it. Treat a file loading more than roughly 600 lines as a signal to look for a
  rule with two audiences, not as a licence to trim a rule that is already all constraint.

## 10. Red flags earn their place, and length is a diagnostic

A *red-flag phrasing* bullet is for a **tempting wrong instinct the constraint above does not
already make obvious** — never a second copy of the rule in another voice. Two shapes earn a
bullet: a **rationalization the prose never voices** (*"the clients are ours"*, *"so it's there
if we need it"*, *"it's one less function"*), and a **wrong inference from another rule or from
general convention**, which the constraint above cannot pre-empt because it is not the rule
being misread. **The test is deletion: if the bullet's justification and consequence both
already appear in the prose above, it is the same rule in a second voice** — and a bullet that
restates makes the section longer, which is what stops the section being read at all.

**Length is a symptom to diagnose, never a ceiling to obey.** A rule that is all constraint,
for one audience, is allowed to be long: some patterns genuinely take that many constraints to
pin down, and truncating one to hit a number just moves the missing constraint into a diff
nobody catches. When a rule passes roughly 200 lines, that is the point to ask which of three
things is true — in this order, because only the third is about length at all:

1. **Mechanism has accumulated** — narration of how the subsystem works rather than what an
   edit must do. That belongs in a knowledge doc (§1), and removing it is a straight win.
2. **The rule has two audiences** — then it is two rules, and the split cuts what every load
   pays rather than what the rule says (§9).
3. **Neither** — it is one audience and all constraint. Then the length is correct and stays.
   Say so in the opening boundary, so the next reader does not "fix" it by cutting constraints.

**Where this does not apply:** the number is still worth watching for the first two diagnoses,
which is its whole job. What it is not is a budget that a legitimate constraint has to fit
inside — and a rule may not drop a constraint, soften it into a suggestion, or push it into a
red-flag bullet to come in under it.

## 11. What `CLAUDE.md` holds

`CLAUDE.md` is the **index above the rules**, not a rule itself: it is what a reader consults
to find where something is written down. Every constraint in this file applies to it unchanged
— the staleness test (§1), the ban on lists that must be complete (§4), one fact one home (§8).

- **An entry is a purpose and a pointer.** Name what a path is for in a line or two, then name
  the knowledge doc that explains its mechanism — never the rule that governs it, which loads
  itself on a `paths:` match and needs no pointer. When an entry starts explaining *how*
  something works or *what the convention is*, it has become a copy of the thing it points at,
  and the copy is the one that goes stale.
- **A fact a rule or knowledge doc already states appears here only as a link.** This file is
  read by everyone and edited by whoever touched the area last, which is exactly the shape that
  drifts.
- **The directory map is a map, not an inventory.** Name the trees and what each is for; never
  enumerate the packages inside one, the members of a chain, or the middleware in the stack —
  those grow, and nothing here will tell you.
- **What genuinely belongs**: what the project is, its vocabulary, the architectural absences a
  change must not quietly undo, the checklists of several places that must move together (§8),
  and the session-behaviour and definition-of-done gates. Each of those has no other home.

## 12. Writing one: the order of work

The constraints above are acceptance criteria — they say what a finished rule must be true of,
not how to arrive at one. **Work in this order, because each step's output is the next one's
input**: you cannot scope `paths:` before you know the audience, and you cannot diagnose length
(§10) while narration is still in the draft inflating it.

1. **Decide it is a rule at all** — apply the staleness test (§1) to the thing you are about to
   write down. A mechanism is a knowledge doc, a position is a decision record, local intent is
   a comment, and what the code already says is nothing.
2. **Name the audience, then scope `paths:` to it** (§9). One audience per rule; if you cannot
   name it in a phrase, you have two rules. Measure what already loads on those files before
   widening a glob.
3. **Draft the boundary paragraph first** (§2) — what this file holds, where the mechanism
   lives instead, and the reference implementation if the rule has one (§6). Writing it first
   is what keeps narration out of the sections; writing it last turns it into a summary.
4. **Write each constraint as an imperative with its reason** — *"X, because Y"* (§2) —
   preferring the general shape to the instance you have in hand. Where a constraint has a real
   exception, write the question that decides it (§3); where it has none, say nothing.
5. **Verify every claim you made** (§5). Open or grep every symbol you named and delete what
   you cannot confirm — an unverified name reads exactly like a verified one, so nothing later
   catches it — then give every structural assertion an enforcer and cite it.
6. **Cut what rots** — inventories and lists that must be complete to be correct (§4, §6), and
   every tense marker (§7).
7. **Wire the cross-references** (§8) — number the `##` headings, point at sections rather than
   files, and delete anything you restated from a rule that already owns it.
8. **Diagnose the length last** (§10), once the narration is gone: mechanism moves to a
   knowledge doc, two audiences split into two rules, and anything else is the right length.

The shape those steps produce:

```markdown
---
paths:
  - "<narrowest glob catching every edit this rule constrains>"
---

# <Subject> Rule

<One paragraph: what this file holds, where the mechanism lives instead, and — if the
rule has one — the reference implementation, named here: "`widgetstore` is the reference
store". If the rule is long because it is all constraint for one audience, say so here.>

---

## 1. <The constraint, as an imperative>

**<Do this>**, because <reason>. <Where a real exception exists, the question that decides
it — not the cases that have come up.>

## 2. <Next constraint>

...

## Red-flag phrasing that signals a violation

- "<a rationalization the prose above never voices>" — no: <what it costs>.
```

## Red-flag phrasing that signals a violation

- "A tree here would help the reader see the layout" — no: that is an inventory that goes stale
  silently. The layout is `ls`; the rule says what must go where.
- "This matters, so I'll state it in both rules" — no: one owner, and a link from the other.
- "I'll point at the other rule by filename, the reader can find the part" — no: name the
  section, or restating it locally will keep looking cheaper than linking.
- "The rule is clear enough, the exception is obvious" — if it were, it would not keep being
  asked; write the test that decides it.
- "This applies to every source file of that language, so `**/*.<ext>`" — check what else
  already matches those files first; a rule loading where it has nothing to say spends another
  rule's budget.
- "I'll add a red flag for that too, to be safe" — no: a bullet restating the constraint above
  it makes the rule longer and less likely to be followed.
- "This rule is over 200 lines, I'll cut a constraint to bring it down" — no: diagnose first
  (§10). If it is one audience and all constraint, the length is correct; dropping a constraint
  to hit a number is how the constraint comes back as a bug.
- "I'm fairly sure that helper is called that" — no: check before naming it. An unverified
  symbol reads exactly like a verified one.
- "I'll explain this properly in `CLAUDE.md` so a reader gets it without opening the rule" —
  no: that is the copy that goes stale. Name the rule and stop.
- "I know what a good rule looks like, I'll just write it and tidy after" — the tidy pass is
  where a symbol goes unverified (§5) and narration survives as a section; run §12 in order.
- "I'll write the boundary paragraph once the sections are done" — no: it is the step that
  keeps mechanism out of them (§12), so writing it last leaves nothing for it to do.
