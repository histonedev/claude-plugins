"""Changelog helper for plugins/<name>/CHANGELOG.md.

  changelog.py release <file> <version> <date>   turn "## Unreleased" into "## <version> — <date>"
  changelog.py notes <file> <version>            print the body of that version's section
  changelog.py check <file> <version>            fail unless that version has a section
"""
import re
import sys

UNRELEASED = "## Unreleased"


def sections(text):
    """Map each '## ' heading to its body text."""
    parts = re.split(r"^(## .*)$", text, flags=re.M)
    return {parts[i].strip(): parts[i + 1].strip() for i in range(1, len(parts), 2)}


def version_heading(text, version):
    for heading in sections(text):
        if re.match(rf"## {re.escape(version)}(\s|$)", heading):
            return heading
    return None


def fail(message):
    sys.exit(f"changelog: {message}")


def main():
    command, path, *args = sys.argv[1:]
    text = open(path).read()
    if command == "release":
        version, date = args
        if version_heading(text, version):
            fail(f"{path} already has a {version} section")
        if not sections(text).get(UNRELEASED):
            fail(f"add what changed under '{UNRELEASED}' in {path} first")
        text = text.replace(UNRELEASED, f"{UNRELEASED}\n\n## {version} — {date}", 1)
        open(path, "w").write(text)
    elif command == "notes":
        heading = version_heading(text, args[0]) or fail(f"no {args[0]} section in {path}")
        print(sections(text)[heading])
    elif command == "check":
        version_heading(text, args[0]) or fail(f"no {args[0]} section in {path}; release with scripts/release.sh")
    else:
        fail(f"unknown command {command}")


main()
