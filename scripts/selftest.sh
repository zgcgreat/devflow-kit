#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
failures=0

check_file() {
  local path="$1"
  if [[ ! -f "$ROOT/$path" ]]; then
    echo "MISSING file: $path" >&2
    failures=$((failures+1))
  fi
}

check_dir() {
  local path="$1"
  if [[ ! -d "$ROOT/$path" ]]; then
    echo "MISSING dir: $path" >&2
    failures=$((failures+1))
  fi
}

check_file "SKILL.md"
check_file "README.md"
check_file "AGENTS.md"
check_file "flow/GO.md"
check_file "flow/SYSTEM.md"
check_file "flow/METHODOLOGY.md"
check_file "flow/RULES.md"
check_file "flow/prompts/0-confirm.md"
check_file "flow/prompts/3-task.md"
check_file "flow/prompts/4-dev.md"
check_file "flow/prompts/6-review.md"
check_file "flow/prompts/7-integration.md"
check_file "skills/spec-driven-development/_SKILL.md"
check_file "skills/planning-and-task-breakdown/_SKILL.md"
check_file "skills/incremental-implementation/_SKILL.md"
check_file "skills/test-driven-development/_SKILL.md"
check_file "skills/code-review-and-quality/_SKILL.md"
check_file "adapters/claude/commands/go.md"
check_file "adapters/gemini/commands/go.toml"
check_file ".claude-plugin/plugin.json"
check_dir "flow/templates"
check_dir "flow/reference"
check_dir "skills"
check_dir "agents"

if [[ -f "$ROOT/SKILL.md" ]]; then
  if ! head -n 5 "$ROOT/SKILL.md" | grep -q '^name: devflow-kit$'; then
    echo "INVALID SKILL.md frontmatter: missing name: devflow-kit" >&2
    failures=$((failures+1))
  fi
  if ! head -n 5 "$ROOT/SKILL.md" | grep -q '^description: '; then
    echo "INVALID SKILL.md frontmatter: missing description" >&2
    failures=$((failures+1))
  fi
fi

if command -v python3 >/dev/null 2>&1; then
  python3 - "$ROOT" <<'PY'
import json, pathlib, sys
root = pathlib.Path(sys.argv[1])
for rel in ['.claude-plugin/plugin.json', '.claude-plugin/marketplace.json']:
    p = root / rel
    if p.exists():
        json.loads(p.read_text(encoding='utf-8'))
PY
else
  echo "WARN: python3 not found; skipping JSON validation" >&2
fi

legacy_hits=$(grep -RI --include='*.md' 'flow-kit' "$ROOT" | grep -v 'devflow-kit' || true)
if [[ -n "$legacy_hits" ]]; then
  echo "LEGACY path references found:" >&2
  echo "$legacy_hits" >&2
  failures=$((failures+1))
fi

# Template reference validation: check @devflow-kit/flow/templates/ references exist
if command -v python3 >/dev/null 2>&1; then
  python3 - "$ROOT" <<'PY' || true
import pathlib, sys, re
root = pathlib.Path(sys.argv[1])
pattern = re.compile(r'@devflow-kit/flow/templates/([^\s\)"`>]+)')
failures_found = 0
for md_file in root.rglob('*.md'):
    content = md_file.read_text(encoding='utf-8', errors='ignore')
    for m in pattern.finditer(content):
        ref = m.group(1)
        target = root / 'flow/templates' / ref
        if not target.exists():
            rel_path = md_file.relative_to(root)
            print(f"MISSING template reference: {rel_path} -> {ref}", file=sys.stderr)
            failures_found += 1
if failures_found > 0:
    sys.exit(1)
PY
  if [[ $? -eq 1 ]]; then
    failures=$((failures+1))
  fi
else
  echo "WARN: python3 not found; skipping template reference validation" >&2
fi

skill_count=$(find "$ROOT/skills" -mindepth 2 -maxdepth 2 -name _SKILL.md 2>/dev/null | wc -l | tr -d ' ')
prompt_count=$(find "$ROOT/flow/prompts" -maxdepth 1 -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
echo "skill_count=$skill_count"
echo "flow_prompt_count=$prompt_count"

if [[ "$skill_count" -lt 10 ]]; then
  echo "Too few skill files detected" >&2
  failures=$((failures+1))
fi
if [[ "$prompt_count" -lt 8 ]]; then
  echo "Too few flow prompt files detected" >&2
  failures=$((failures+1))
fi

if [[ "$failures" -ne 0 ]]; then
  echo "SELFTEST FAILED: $failures issue(s)" >&2
  exit 1
fi

echo "SELFTEST OK"
