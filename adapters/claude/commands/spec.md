---
description: Start requirements analysis through devflow-kit
---

Use the devflow-kit skill.

Route to the requirements analysis path. Before executing, ensure:
1. `.specs/进度跟踪.md` exists or is created
2. Brownfield entry detection has run (if applicable)
3. Mode (Fast/Standard/Strict) is confirmed with user

Then read `devflow-kit/flow/prompts/0-confirm.md` if the idea is still vague, otherwise read `devflow-kit/flow/prompts/1-analysis.md`. Use `devflow-kit/agent-skills/skills/spec-driven-development/_SKILL.md` and `devflow-kit/agent-skills/skills/idea-refine/_SKILL.md` when applicable. Save flow artifacts under `.specs/<req-id>/` unless the project specifies another convention.
