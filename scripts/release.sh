#!/usr/bin/env bash
# Release a plugin: bump its version, date its changelog, validate, commit, tag and push.
# The pushed tag triggers the Release workflow, which publishes a GitHub release.
# Usage: scripts/release.sh <plugin> <patch|minor|major|X.Y.Z>
set -euo pipefail
cd "$(dirname "$0")/.."

die() { echo "release: $1" >&2; exit 1; }

plugin=${1:-}
bump=${2:-}
[[ -n $plugin && -n $bump ]] || die "usage: scripts/release.sh <plugin> <patch|minor|major|X.Y.Z>"
dir=plugins/$plugin
manifest=$dir/.claude-plugin/plugin.json
[[ -f $manifest ]] || die "no plugin at $dir"
[[ -z $(git status --porcelain) ]] || die "commit or stash your changes first"
[[ $(git branch --show-current) == main ]] || die "release from main"
git fetch -q origin main
[[ $(git rev-parse HEAD) == $(git rev-parse origin/main) ]] || die "main is not in sync with origin/main; pull or push first"

current=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$manifest")
version=$(python3 - "$current" "$bump" <<'PY'
import re, sys
current, bump = sys.argv[1:]
major, minor, patch = map(int, current.split("."))
if bump == "major":
    print(f"{major + 1}.0.0")
elif bump == "minor":
    print(f"{major}.{minor + 1}.0")
elif bump == "patch":
    print(f"{major}.{minor}.{patch + 1}")
elif re.fullmatch(r"\d+\.\d+\.\d+", bump):
    if tuple(map(int, bump.split("."))) <= (major, minor, patch):
        sys.exit(f"release: {bump} is not above {current}")
    print(bump)
else:
    sys.exit("release: bump must be patch, minor, major or X.Y.Z")
PY
)

python3 scripts/lib/changelog.py release "$dir/CHANGELOG.md" "$version" "$(date +%F)"
python3 - "$manifest" "$version" <<'PY'
import json, sys
path, version = sys.argv[1:]
manifest = json.load(open(path))
manifest["version"] = version
open(path, "w").write(json.dumps(manifest, indent=2) + "\n")
PY

scripts/check.sh
git commit -qam "Release $plugin v$version"
git push -q origin main
claude plugin tag "$dir" --push -m "$plugin v%s"
echo "Released $plugin v$version. Devices get it on auto-update, or with: claude plugin update $plugin@histone"
