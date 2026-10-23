# Histone Claude Code plugins

## Install on a device

In Claude Code:

```
/plugin marketplace add histonedev/claude-plugins
/plugin install project-plan@histone
```

Restart Claude Code, then do two one-time steps per device:

1. **Turn on auto-update**: `/plugin` → Marketplaces → histone → Enable auto-update. New releases then arrive in the background. Without it, run `claude plugin update project-plan@histone`.
2. **No GitHub SSH key on the device?** Set `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1`, or in-session installs and updates fail. Easiest: add `"CLAUDE_CODE_PLUGIN_PREFER_HTTPS": "1"` under `"env"` in `~/.claude/settings.json` (Windows: `%USERPROFILE%\.claude\settings.json`).

## Plugins

| Plugin | What it does |
| --- | --- |
| [project-plan](plugins/project-plan) | Living project plans in Claude Docs for long, multi-session work |

## Develop

1. Edit files under `plugins/<name>/`.
2. Try the working copy without releasing: `claude --plugin-dir plugins/<name>`.
3. Add a line under `## Unreleased` in `plugins/<name>/CHANGELOG.md`.
4. Run `scripts/check.sh`, then commit and push. CI runs the same check.

## Release

```
scripts/release.sh <name> patch      # or minor, major, or an exact X.Y.Z
```

It bumps `version` in the plugin's `plugin.json`, dates the changelog section, validates, commits, pushes, and pushes the tag `<name>--v<version>`. The tag triggers the Release workflow, which publishes a GitHub release with the changelog notes. Devices only receive changes when the version changes, so every user-facing change needs a release.

## Add a plugin

```
scripts/new-plugin.sh <name> "<one-line description>"
```

It creates the plugin with one skill stub and lists it in `.claude-plugin/marketplace.json`.

## Layout

```
.claude-plugin/marketplace.json   catalog (no versions here; they live in plugin.json)
plugins/<name>/                   one plugin: .claude-plugin/plugin.json, skills/, README, CHANGELOG
scripts/check.sh                  validation, used locally and in CI
scripts/release.sh                version bump, changelog, tag, push
scripts/new-plugin.sh             scaffold a plugin
.github/workflows/                CI on push and PR; GitHub release on tag
```

Licensed under MIT.
