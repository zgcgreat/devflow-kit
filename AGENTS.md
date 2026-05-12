# AGENTS.md

This repository is a unified skill package for AI coding agents. It merges a flow-oriented project workflow with a library of specialized engineering skills.

## Core Model

There are three layers:

- `SKILL.md` is the public entry point. Load it first when the host supports skills.
- `flow/` is the orchestration layer. It decides the phase, manages `.specs/<req-id>/` artifacts, and enforces phase gates.
- `agent-skills/` is the capability layer. It provides focused practices for spec, planning, implementation, TDD, review, security, performance, and shipping. (Sourced from upstream `agent-skills` project.)

Do not treat every file as startup context. Use progressive disclosure: load the entry point, then only the phase prompt, artifacts, and specialized skills needed for the current user request.

## Intent Routing

For broad requests, read `flow/GO.md` and follow its routing rules.

For explicit lifecycle requests:

- New idea / vague feature: `flow/prompts/0-confirm.md` plus `agent-skills/skills/idea-refine` and `agent-skills/skills/spec-driven-development`.
- Requirements / spec: `flow/prompts/1-analysis.md` plus `agent-skills/skills/spec-driven-development`.
- Design / API / architecture: `flow/prompts/2-design.md` plus API, source-driven, ADR, security, or performance skills as relevant.
- UI / visual design: `flow/prompts/2a-ui-design.md` plus `agent-skills/skills/frontend-ui-engineering`.
- Task breakdown: `flow/prompts/3-task.md` plus `agent-skills/skills/planning-and-task-breakdown`.
- Implementation: `flow/prompts/4-dev.md` plus incremental implementation, TDD, and git workflow skills.
- Test / debug: `flow/prompts/5-test.md` plus TDD, debugging, and browser testing skills as relevant.
- Review: `flow/prompts/6-review.md` plus code quality, security, and performance skills.
- Ship / integration: `flow/prompts/7-integration.md` plus shipping, CI/CD, migration, and deprecation skills.
- Brownfield scan: `flow/prompts/I-intel-scan.md` plus context engineering.
- Architecture inventory: `flow/prompts/A-architect.md`; architecture update: `flow/prompts/A-evolve.md`.
- Health scan: `flow/prompts/M-health.md` plus simplification, review, performance, and security skills.

## Rules for Agents

Do not implement a non-trivial change before requirements and tasks exist, unless the user has explicitly chosen a small direct-edit path.

Do not claim a task is complete without verification evidence.

Do not silently broaden scope. Record follow-ups instead.

When a specialized skill applies, use it. If the host has a skill invocation mechanism, invoke the skill. If not, read the relevant `agent-skills/skills/<name>/_SKILL.md` file and follow it manually.

Specialist personas in `agent-skills/agents/` may be used for independent review. They should not call each other. The main agent is responsible for synthesizing their outputs.
