# project-plan

A Claude Code plugin that creates and runs a living project plan in Claude Docs, for work that spans many phases and many sessions. The plan is the single source of truth: every session reads it first and updates it last. A new session can pick up where the last one stopped without the earlier conversation.

## What the plan contains

| Section | What it holds | Who writes it |
| --- | --- | --- |
| How to use this document | The working rules every session follows | Claude, at creation |
| Current state | The handover: state, next tasks, what's waiting on you, conventions, follow-ups | Claude, rewritten each session |
| Notes for Claude | Your inbox: requirements, decisions, changes, questions | You add rows; Claude replies |
| Overview | Goal, deliverables, scope, where the work lives, constraints | Claude, at creation |
| Requirements | `R1…` testable requirements with priority and source | Both |
| Decisions log | `D1…` dated decisions with reasons, marked Confirmed, Proposed or Superseded | Both |
| Architecture and design sections | Diagrams, components, rules, layouts | Claude |
| Phases and tasks | Roadmap, `P0…` phases with exit criteria, `P1.2`-style tasks with dependencies, a status and a Notes column | Both |
| Session protocol | What every session does at start, during and end | Claude, at creation |
| Session log | One short row per session, newest first | Claude |
| Risks and open questions | Each with impact, mitigation and status | Both |
| Archive tab | Old session rows and finished phases | Claude |

IDs never change, so you can cite them anywhere: commits, branch names, PRs, chat.

## Install

### Requirements

- Claude Code, signed in with your claude.ai account.
- The **Claude Docs** connector on that claude.ai account. Check with `/mcp` in Claude Code: you should see `claude.ai Claude Docs`. Without it, the plugin writes the same plan to `docs/PLAN.md` in your project.

### Steps (once per device)

1. In Claude Code, add the marketplace and install the plugin:
   ```
   /plugin marketplace add histonedev/claude-plugins
   /plugin install project-plan@histone
   ```
   Or from a shell: `claude plugin marketplace add histonedev/claude-plugins && claude plugin install project-plan@histone`.
2. **No GitHub SSH key on this device?** Most devices without git setup don't have one. Add this to `~/.claude/settings.json` (Windows: `%USERPROFILE%\.claude\settings.json`), merged into any `env` block that's already there:
   ```json
   "env": { "CLAUDE_CODE_PLUGIN_PREFER_HTTPS": "1" }
   ```
   Without it, installs and updates run from inside a session fail.
3. **Turn on auto-update**: `/plugin` → Marketplaces → histone → Enable auto-update.
4. Restart Claude Code.
5. Check it loaded: `claude plugin list` shows `project-plan@histone` as enabled, and typing `/project-plan` in a session shows `/project-plan:project-plan`.

### Update, disable, remove

| Do this | Command |
| --- | --- |
| Update now (without auto-update) | `claude plugin marketplace update histone` then `claude plugin update project-plan@histone`, then restart |
| See the installed version | `claude plugin list` |
| Disable for a while | `claude plugin disable project-plan@histone` |
| Uninstall | `claude plugin uninstall project-plan@histone` |

Release notes: [GitHub releases](https://github.com/histonedev/claude-plugins/releases) or [CHANGELOG.md](CHANGELOG.md).

## Use

Commands take a mode: `create`, `start` or `end`.

```
/project-plan:project-plan create [file path or doc link]
/project-plan:project-plan start
/project-plan:project-plan end
```

You can also just ask in plain words, for example "create a project plan from this", "start a session on the plan" or "wrap up and write the handover".

### 1. Create a plan

Pick whichever fits:

- **From the conversation**: research, discuss and agree on requirements with Claude first, then run `/project-plan:project-plan create`. Agreements become decisions, findings go into the design sections, and the work becomes phases and tasks.
- **From an existing plan in any format**: `/project-plan:project-plan create docs/notes.md`, a PRD, a ticket export, or a Claude Doc link. Nothing in it is dropped; it's restructured into the plan.
- **From scratch**: `/project-plan:project-plan create` with a short brief. Claude asks at most one round of questions (name, where the work lives, anything that changes the phases).

What happens:
1. The doc opens with its outline, then fills one section at a time while you watch.
2. Anything Claude doesn't know goes into Risks and open questions. Nothing is invented.
3. Decisions you made are logged as Confirmed. Decisions Claude inferred are logged as Proposed and listed under Waiting on the user, for you to confirm.
4. Claude offers to add the plan link to your project's `CLAUDE.md`. Say yes, so every future session in that project finds the plan by itself.

### 2. Work in sessions

Start each session with:

```
/project-plan:project-plan start
```

Claude reads Current state, your Open notes and any decisions added since the last session. It applies your input, replies to each note, and picks the next task whose dependencies are done (or the one you name). It then reports in a few lines and gets to work. To choose the task yourself: `/project-plan:project-plan start P2.4`.

During the session, Claude asks you before any decision that changes scope, interfaces, data ownership or user-facing behaviour, then logs it. It never reopens a Confirmed decision without you.

End each session with:

```
/project-plan:project-plan end
```

Claude sets task statuses, rewrites Current state, adds a short Session log row, and records new risks. Ending the session this way is how the next one knows where things stand. If a session is cut off before it ends, start the next one with `start`; it picks up from the last handover.

### 3. Add your own input

You can change the plan directly in the doc at any time. The next `start` applies it.

| You want to | Do this in the doc |
| --- | --- |
| Give a note, requirement, change or question | Add a row to **Notes for Claude** with status Open. Fill *About* with an ID or section if it applies |
| Note something about one task | Write in that task's **Notes** cell |
| Make a decision yourself | Add a row to the **Decisions log** with the next D number, today's date, the reason, and status Confirmed |
| Confirm or reject something Claude proposed | Change a Proposed decision to Confirmed, or add a note saying what to do instead |
| Change priorities or order | Add a note ("do P3 before P2"), or edit the Depends on cells |
| Ask about a specific line | Comment on it. Comments sent to Claude are answered in their thread |

Each note gets a reply that says what changed, for example `→ D41, P2.9 added`. It's then marked Done, or Declined with the reason.

### Statuses

| Column | Values |
| --- | --- |
| Task | Not started, In progress, Blocked, Done, Dropped |
| Decision | Confirmed, Proposed, Superseded |
| Note | Open, Done, Declined |
| Risk | Open, Resolved |

A task is Done only when it meets the plan's "Done means" bar, for example "merged with tests passing". A dropped task stays in the table as Dropped, with the decision that dropped it. A changed decision is a new decision that supersedes the old one, so the history stays readable.

## Tips

- One plan per project. Keep the plan link in the project's `CLAUDE.md`.
- Keep tasks to about one session or one PR. Ask Claude to split a big one; it gets letter IDs (`P1.4b`), and other IDs stay as they are.
- Read **Waiting on the user** in Current state after each session. That's where Claude parks what it needs from you.
- For long runs with several agents, add your working conventions (locks, test order, environment quirks) to the notes. Claude keeps them under **How we work**, so every session follows them.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| `/project-plan` doesn't show up | Restart Claude Code; check `claude plugin list` shows it enabled |
| Install or update fails inside a session | Set `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` (Install, step 2), or run the shell command instead |
| Still on an old version | `claude plugin marketplace update histone`, then `claude plugin update project-plan@histone`, then restart |
| The plan went to `docs/PLAN.md` instead of Claude Docs | The Claude Docs connector isn't available in this session. Check `/mcp` and your claude.ai connectors |
| A new session doesn't know about the plan | Give it the link, or add the `CLAUDE.md` pointer (Create, step 4) |

## License

MIT. See [LICENSE](../../LICENSE).
