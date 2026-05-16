# DevFlow Kit - AI Assistant Instructions

## Overview

DevFlow Kit is a comprehensive AI-powered development workflow system that combines:
- **Structured Process Orchestration** (from devflow-kit)
- **Engineering Discipline** (from superpowers)  
- **Cross-session Memory** (from team-skills)

## Quick Start

### First Time Setup

To install DevFlow Kit to your current project, say:

```
Use install-superflow.
```

The AI will automatically:
1. Detect current project state
2. Ask for installation mode (Basic/Full/Preview)
3. Copy all necessary files
4. Verify installation integrity
5. Guide you through quick start

**No manual script execution needed!**

### After Installation

When working on this project, you can activate DevFlow Kit by saying:

```
Use devflow-kit. <your requirement>
```

Or reference the main entry point:

```
@devflow-kit/flow/GO.md

<your requirement>
```

## Available Workflows

### 1. Standard Development Flow (Default)
For regular feature development with full process discipline.

### 2. Fast Mode
For small changes (<50 lines, low risk). Direct implementation with minimal validation.

### 3. Strict Mode
For high-risk changes (auth, payments, database schema). Full process with enhanced verification.

## Key Principles

1. **Always read GO.md first** - This is the router and source of truth for all workflows
2. **Follow mode recommendations** - Fast/Standard/Strict based on risk assessment
3. **Use TDD for new behavior** - Write failing tests first, then minimal code
4. **Update memory when significant work completes** - Keep PROJECT_CONTEXT.md and CURRENT_STATE.md current
5. **Verify before claiming completion** - Run fresh verification commands and show evidence

## Memory System

If `.superpowers-memory/` exists in the project root:

### Automatic Memory Updates
- **At session start**: Read PROJECT_CONTEXT.md, CURRENT_STATE.md, DECISIONS.md, KNOWN_FAILURES.md
- **After stage-7-integration**: Automatically trigger memory closeout (see manage-memory Skill)
- **During work**: Update relevant memory files when durable knowledge is created

### Manual Memory Management
Users can manually trigger memory operations:
```bash
Use manage-memory. 初始化记忆系统      # Initialize memory system
Use superpowers-learning workflow       # Update memory after session
Use manage-memory. 验证记忆质量         # Validate memory quality
Use manage-memory. 清理过期记忆         # Clean up old memories
```

### Memory Files
- **PROJECT_CONTEXT.md**: Stable project facts (tech stack, architecture, conventions)
- **CURRENT_STATE.md**: Current work status (updated every session)
- **DECISIONS.md**: Important technical decisions (ADR style)
- **KNOWN_FAILURES.md**: Failure patterns to avoid repeating mistakes
- **session-journal/**: Detailed session logs

## Stage Skills

The workflow consists of these stages (automatically routed by GO.md):

- **stage-0-confirm**: Clarify requirements
- **stage-1-analysis**: Write user stories and acceptance criteria
- **stage-2-design**: Technical design with ADRs
- **stage-2a-ui-design**: UI/UX design decisions (frontend only)
- **stage-3-task**: Break down into executable tasks
- **stage-4-dev**: Implement with TDD
- **stage-5-test**: Risk-driven testing
- **stage-6-review**: Five-axis code review
- **stage-7-integration**: Archive artifacts and close out

## Superpowers Integration

Core engineering skills available:

- **brainstorming**: Socratic design refinement before coding
- **test-driven-development**: RED-GREEN-REFACTOR cycle enforcement
- **subagent-driven-development**: Parallel agent execution with two-stage review
- **systematic-debugging**: Four-phase root cause analysis
- **verification-before-completion**: Evidence-based completion claims

## Tool Adapters

This kit supports multiple AI tools:

- **Claude Code**: Use `/go` command or natural language
- **Cursor**: Reference `@devflow-kit/flow/GO.md`
- **Gemini CLI**: Use slash commands from adapters/gemini/commands/
- **Windsurf**: Use `/go` workflow
- **GitHub Copilot**: Paste flow/SYSTEM.md into copilot-instructions.md

## Documentation

- [Quick Start](docs/QUICKSTART.md)
- [Memory Guide](docs/MEMORY_GUIDE.md)
- [Tutorials](docs/tutorials/)
- [Stage Skills Reference](docs/STAGE_SKILLS_REFERENCE.md)

## License

MIT License
