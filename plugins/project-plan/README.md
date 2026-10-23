# project-plan

A Claude Code skill that creates and runs a living project plan in Claude Docs. The plan is the single source of truth that every session reads first and updates last.

The plan holds the rules of work, the current state (handover), a notes inbox for you, requirements, a decisions log, the architecture, phased tasks with stable IDs, the session protocol, a session log, and risks.

## Install

```
/plugin install project-plan --marketplace histonedev/claude-plugins
```

## Use

Run `/project-plan:project-plan create`, `start` or `end`, or just ask: "create a project plan from this", "start a session on the plan", "wrap up the session".

## Modes

- `create`: build a plan from the conversation, or from a plan file or doc you pass in.
- `start`: read the plan, apply your notes and new decisions, pick the next ready task.
- `end`: update statuses, rewrite Current state, add a session log row.

## Requirements

The Claude Docs connector. Without it, the skill writes `docs/PLAN.md` instead.
