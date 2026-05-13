---
description: Run integration and launch readiness checks through devflow-kit
---

Use the devflow-kit skill.

Route to `devflow-kit/flow/prompts/7-integration.md`. Before executing, ensure:
1. `.specs/项目状态.md` exists and reflects current state
2. Required artifacts exist (`06-代码审查.md`)
3. Phase gates are satisfied (all Critical issues resolved)

Use `devflow-kit/agent-skills/skills/shipping-and-launch/_SKILL.md`, `devflow-kit/agent-skills/skills/ci-cd-and-automation/_SKILL.md`, and migration/deprecation skills as relevant. If specialist agents are available and the change is non-trivial, fan out to code-reviewer, security-auditor, and test-engineer, then synthesize a go/no-go decision with rollback plan.
