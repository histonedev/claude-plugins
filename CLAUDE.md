# Histone Claude Code plugins

A plugin marketplace (`histone`) published at github.com/histonedev/claude-plugins. The README covers the workflow.

- Every change to a plugin gets a line under `## Unreleased` in `plugins/<name>/CHANGELOG.md`.
- Never edit `version` by hand. Releases go through `scripts/release.sh <name> <patch|minor|major>`, run only when the user asks for a release.
- Versions live only in `plugins/<name>/.claude-plugin/plugin.json`, never in `marketplace.json`.
- Never rename a plugin's `name`; use `displayName`, or a `renames` map in `marketplace.json`.
- Run `scripts/check.sh` before committing.
