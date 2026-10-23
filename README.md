# Histone Claude Code plugins

## Install

```
/plugin marketplace add histonedev/claude-plugins
/plugin install project-plan@histone
```

Then restart Claude Code. To update later: `/plugin marketplace update histone`, then `/plugin update project-plan@histone`.

## Plugins

| Plugin | What it does |
| --- | --- |
| [project-plan](plugins/project-plan) | Living project plans in Claude Docs for long, multi-session work |

## Releasing a change

Edit the plugin, bump `version` in both `plugins/<name>/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`, run `claude plugin validate .`, then commit and push.
