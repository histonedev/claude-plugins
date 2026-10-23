# Plan doc template

The sections below are the plan doc, in order. Text in `<angle brackets>` is filled per project. The **How to use this document** and **Session protocol** text is the working text: keep its meaning, tune its details (naming, the Done bar, repo rules) and drop rules that don't apply.

Tables show their columns. Every Status cell is a dropdown chip from the enums in SKILL.md.

---

# <Project name> — Plan

<as-of date chip> · <author mention>

<Lead: one sentence on what ships and why, with the key number or date if there is one.>

## How to use this document

This doc is the single source of truth for <project>. Every session reads it first and updates it last, so no session depends on an earlier conversation.

1. **Read before working**: Current state, the Open rows in Notes for Claude, the decisions newer than the bookmark, then only the sections your task touches.
2. **Pick a task**: the one the user names, or the next task in Phases and tasks whose dependencies are Done. Use its ID (for example P1.2) in <branch names, commits and PRs | file names and messages>.
3. **Keep statuses true**: In progress when you start. Done only when <merged with tests passing | the exit check passes>. Blocked with the reason in your Session log row.
4. **Respect decisions**: a Confirmed decision is settled and only the user reopens it. A new decision is asked of the user, then appended as the next D number with its date and reason, and every section it affects is updated so the doc never contradicts the log. A call made without the user is logged as Proposed and listed under Waiting on the user.
5. **Change the plan carefully**: new tasks take the next free ID in their phase, and splits take a letter suffix (P1.4b). Never renumber, reuse or delete an ID. A dropped task is set to Dropped, with the decision that dropped it.
6. **Finish every session here**: rewrite Current state, add a short Session log row (newest first), and add new risks and open questions.

**Your input as the user:** add a row to Notes for Claude, write in any task's Notes cell, add a decision row yourself (Status Confirmed), or comment on any line. The next session applies all of it before starting work and replies to each note.

## Current state

The handover. It is rewritten at the end of every session, and is the first thing the next session reads.

**State**: <where things stand: branches, versions, environments, open PRs; "No work started" at creation>

**Next up**:
1. <next ready task ID and title, plus anything to check first>

**Waiting on the user**: <Proposed decisions to confirm, blocking questions, access needed; "Nothing" if none>

**How we work**: <conventions and environment gotchas learned along the way; empty at creation>

**Follow-ups**: <small loose ends; empty at creation>

**Bookmarks**: Last decision: D<n> · Last note: <Nn | none> · Last session: S<n>

## Notes for Claude

Add a row for anything: a new requirement, a decision, a change to a task, a question. Each session applies the Open rows first and writes a reply.

| # | Date | Note | About | Status | Reply |
| --- | --- | --- | --- | --- | --- |
| N1 | <date> | <example: "Prefer Postgres over MySQL"> | <D/P/R ID or section> | Open | |

(At creation, leave one example row marked Done with the reply "Example. Add your own rows below." or leave the table with just its header row.)

## Overview

<One or two sentences: the goal and the approach.>

| Deliverable | Platform or form | Audience | Notes |
| --- | --- | --- | --- |

**In scope:** <list in one line>
**Out of scope for now:** <list in one line, with "(long-term goal)" where relevant>
**Where the work lives:** <repos, folders, systems>
**Constraints:** <deadline, budget, stack, compliance; leave out if none>

## Requirements

| ID | Requirement | Priority | Source |
| --- | --- | --- | --- |
| R1 | <testable statement> | Must | <user, file, research> |

## Decisions log

Every agreed decision has an ID. Sessions cite it, and nobody reopens it without the user. New decisions are appended with the date they were made.

| ID | Date | Decision | Why | Status |
| --- | --- | --- | --- | --- |
| D1 | <date> | <decision> | <reason; "over Y because…"> | Confirmed |

## Architecture

<Lead sentence: how the parts fit together.>

<Diagram: components and what talks to what.>

<One sentence reading the diagram: the key flow or the failure mode.>

### <Layout | Repo layout | Structure>

<A code block or a short list when useful.>

## <Design section per major part>

<As many as the material supports: each part's responsibilities, data, interfaces, rules, edge cases. Use tables for items × attributes, numbered lists for steps, and diagrams for flows that branch.>

## Phases and tasks

<Lead: the order of work and any gate between tracks. Task IDs are stable: sessions cite them everywhere.>

<Roadmap diagram: phases in order, with gates and exit criteria marked.>

### P0 — <Phase name>

Exit: <one checkable sentence>.

| ID | Task | Depends on | Status | Notes |
| --- | --- | --- | --- | --- |
| P0.1 | <task> | none | Not started | |

(Add a *Where* column after Task when the work spans several repos or systems, and an *Owner* column when several people share the work.)

### P1 — <Phase name>

…

**Later, not scheduled:** <deferred items, one line>

## Session protocol

Every session starts and ends in this doc, so the next session can continue without the previous conversation.

**Start of a session**
1. Read Current state, then the Open rows in Notes for Claude, and the decisions newer than the bookmark.
2. Apply the user's input: each Open note (log a decision, add or change a task, answer it), then set its Status and reply. Also apply any decisions the user added directly, new task Notes, and comments addressed to Claude.
3. Pick the next task whose dependencies are Done, or the one the user names, and set it to In progress. <Work on a branch named <prefix>/<task id>-<slug>; one task per PR where possible.>

**During a session**
- A decision that changes scope, interfaces, data ownership or user-facing behaviour is asked of the user first, then logged as the next D number.
- Never reopen a Confirmed decision without the user. A change is a new decision that supersedes the old one.
- Follow each repo's own rules (<CLAUDE.md, tests, linters>).

**End of a session**
1. Set task statuses (Done only when <the Done bar>; Blocked with the reason).
2. Rewrite Current state: state, next up, waiting on the user, how we work, follow-ups, bookmarks.
3. Add a Session log row with a one-line handover, plus new risks and open questions.
4. Once the log has more than about 10 rows, move the oldest to the Archive tab.

## Session log

Newest first. One row per session; the full handover is in Current state.

| Date | Session | Tasks | Outcome | Links | Handover |
| --- | --- | --- | --- | --- | --- |
| <date> | S0 Plan created | none | Plan built from <sources> | <links> | Start with <first task ID> |

## Risks and open questions

| Risk or question | Impact | Mitigation or next step | Status |
| --- | --- | --- | --- |
| <risk or question> | <what it blocks or breaks> | <mitigation, or "Ask the user"> | Open |
