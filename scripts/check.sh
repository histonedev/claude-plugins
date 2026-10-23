#!/usr/bin/env bash
# Validate the marketplace and every plugin. Runs locally and in CI.
set -euo pipefail
cd "$(dirname "$0")/.."

notice() { if [[ -n ${GITHUB_ACTIONS:-} ]]; then echo "::notice::$1"; else echo "note: $1"; fi; }

claude plugin validate . >/dev/null || claude plugin validate .

python3 - <<'PY'
import json, os, sys
market = json.load(open(".claude-plugin/marketplace.json"))
entries = {p["name"]: p for p in market["plugins"]}
dirs = sorted(d for d in os.listdir("plugins") if os.path.isdir(f"plugins/{d}"))
errors = []
for name, entry in entries.items():
    if entry.get("source") != f"./plugins/{name}":
        errors.append(f"{name}: source should be ./plugins/{name}")
    if "version" in entry:
        errors.append(f"{name}: keep version in plugin.json only, not in marketplace.json")
for d in dirs:
    if d not in entries:
        errors.append(f"plugins/{d} has no entry in marketplace.json")
        continue
    manifest = json.load(open(f"plugins/{d}/.claude-plugin/plugin.json"))
    if manifest.get("name") != d:
        errors.append(f"plugins/{d}: plugin.json name must be {d}")
    if not manifest.get("version"):
        errors.append(f"plugins/{d}: plugin.json needs a version, or users never get updates")
if errors:
    sys.exit("\n".join(errors))
PY

for dir in plugins/*/; do
  dir=${dir%/}
  name=$(basename "$dir")
  claude plugin validate "$dir" --strict >/dev/null || claude plugin validate "$dir" --strict
  version=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$dir/.claude-plugin/plugin.json")
  python3 scripts/lib/changelog.py check "$dir/CHANGELOG.md" "$version"
  tag="$name--v$version"
  if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
    if ! git diff --quiet "$tag" HEAD -- "$dir" ':!*/README.md' ':!*/CHANGELOG.md'; then
      notice "$name has changes since $tag that users won't get until scripts/release.sh $name"
    fi
  else
    notice "$name v$version is not tagged yet"
  fi
  echo "ok  $name v$version"
done
