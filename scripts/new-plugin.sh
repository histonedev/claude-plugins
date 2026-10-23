#!/usr/bin/env bash
# Scaffold a plugin with one skill and list it in the marketplace.
# Usage: scripts/new-plugin.sh <name> "<one-line description>"
set -euo pipefail
cd "$(dirname "$0")/.."

name=${1:-}
description=${2:-}
[[ $name =~ ^[a-z0-9]+(-[a-z0-9]+)*$ && -n $description ]] || { echo 'usage: scripts/new-plugin.sh <kebab-name> "<description>"' >&2; exit 1; }
dir=plugins/$name
[[ ! -e $dir ]] || { echo "$dir already exists" >&2; exit 1; }

mkdir -p "$dir/.claude-plugin" "$dir/skills/$name"
python3 - "$name" "$description" <<'PY'
import json, sys
name, description = sys.argv[1:]
manifest = {"name": name, "version": "0.1.0", "description": description,
            "author": {"name": "Histone"}, "license": "MIT"}
open(f"plugins/{name}/.claude-plugin/plugin.json", "w").write(json.dumps(manifest, indent=2) + "\n")
path = ".claude-plugin/marketplace.json"
market = json.load(open(path))
market["plugins"].append({"name": name, "source": f"./plugins/{name}", "description": description})
open(path, "w").write(json.dumps(market, indent=2) + "\n")
PY
cat > "$dir/skills/$name/SKILL.md" <<MD
---
name: $name
description: $description Use when <the requests that should trigger this skill>.
---

# $name

<What the skill does and the steps Claude follows.>
MD
cat > "$dir/README.md" <<MD
# $name

$description

## Install

\`\`\`
/plugin install $name --marketplace histonedev/claude-plugins
\`\`\`
MD
cat > "$dir/CHANGELOG.md" <<MD
# Changelog

## Unreleased

## 0.1.0 — $(date +%F)

- First release.
MD
echo "Created $dir. Write the skill, add it to the plugin table in README.md, commit and push, then tag the first release: claude plugin tag $dir --push"
