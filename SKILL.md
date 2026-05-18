---
name: devflow-kit
description: |
  AI-powered software development workflow system with structured processes, 
  engineering discipline, and cross-session memory.
  Now fused with spec-kit SDD (Specification-Driven Development):
  - 9-Article Project Constitution with automatic gate enforcement
  - [NEEDS CLARIFICATION] ambiguity markers for precise requirements
  - Constitution Gate at design phase with complexity tracking
  - SDD command integration (/speckit.specify, /speckit.plan, /speckit.tasks)
  Use when: (1) Starting a new development project or feature, 
  (2) Need structured workflow (requirement → design → dev → test → review), 
  (3) Need staged execution with gate checks, 
  (4) Need cross-session memory for long-running projects,
  (5) User explicitly requests "devflow", "structured workflow", or "staged development".
dependencies:
  - brainstorming
  - writing-plans
  - systematic-debugging
  - verification-before-completion
---

# DevFlow Kit

Structured AI programming workflow system with cross-session memory.

## Quick Start

### Step 1: Read Project State

1. Try to read `.devflow-kit/STATE.md`. If not exists → create from template
2. Check field: `活跃 req` / `当前阶段` / `中断任务`
3. If `中断任务` is not empty → **highest priority**, go to recovery branch
4. **Initialize memory system** (first use must run):
   - Check if `.devflow-kit/memory/` exists
   - If NOT exists → create directory and initialize from templates in `templates/memory/`:
     ```
     .devflow-kit/memory/
     ├── PROJECT_CONTEXT.md           # Project background
     ├── DECISIONS.md                 # Historical decisions
     ├── KNOWN_FAILURES.md            # Known failures
     ├── CURRENT_STATE.md             # Current working state
     ├── VERIFICATION_BASELINE.md     # Verification standards
     ├── TEAM_PREFERENCES.md          # Team preferences
     ├── USER_PROFILE.md              # User preferences
     ├── AGENT_NOTES.md               # AI assistant notes
     ├── LEARNING_BACKLOG.md          # Learning candidates
     ├── SESSION_CLOSE_CHECKLIST.md   # Session close checklist
     ├── memory-index.yaml            # Memory health index
     └── journals/                    # Session log directory
     ```
   - Template source: `templates/memory/`
   - If EXISTS → load PROJECT_CONTEXT.md, DECISIONS.md, KNOWN_FAILURES.md, CURRENT_STATE.md
   
   **Memory update trigger**: After completing a requirement or meaningful session, say:
   - "运行学习工作流" (Run learning workflow) - to update all memory files
   - "验证记忆质量" (Validate memory quality) - to check memory health
   - "清理过期记忆" (Clean expired memory) - to archive old journals

---

### Step 2: Entry Detection (Mandatory)

**⚠️ Mandatory rule**: Must use `read_file` tool to read `references/entry-check.md` and execute according to its decision tree.

**Detection steps** (execute in order, stop when hit):
1. Check if there's `ai_context_doc` field → Case A
2. Check if CONTEXT.md exists + scan time → Case B/C
3. Check other AI context docs → Case D (**⚠️ STOP AND WAIT for user confirmation**)
4. Check if greenfield → Case F (skip) or E (**⚠️ STOP AND WAIT for user confirmation**)

**Must output detection result box**:
```
┌─────────────────────────────────────────────┐
│  🔍 Entry Detection                        │
├─────────────────────────────────────────────┤
│  Detection result: <Case A/B/C/D/E/F>     │
│  Project type: <brownfield / greenfield>   │
│  Context document: <path or "none">        │
└─────────────────────────────────────────────┘
```

**⚠️ Key constraint**: Case B/C/D/E **MUST wait for user reply**, do not auto-continue.

---

### Step 3: Routing Table

Load the appropriate stage skill based on user intent:

| User says | Requirement status | Stage Skill | Dependencies |
|---|---|---|---|
| Have new idea for a project | No active req | `stage-0-confirm` | brainstorming, writing-plans |
| Resume interrupted task | Has interrupted task | Restart per R1.5 | - |
| Don't enter flow-kit | - | Direct execution, skip | - |
| Health check | - | `stage-m-health` | systematic-debugging, verification-before-completion |
| evolve/architect | - | `stage-a-evolve` or `stage-a-architect` | — |
| Pure technical question | - | Direct answer | - |
| Upload doc/PRD | - | Doc parsing mode → 00-requirements | writing-plans |
| intel-scan / scan project | - | `stage-i-intel-scan` | planning-and-context |

**Stage gate validation** (read `references/gate-rules.md`):
- Missing prerequisite artifacts → not allowed to enter directly, must complete missing stage first
- **Stage dependency**: `0→1→2→[2a]→3→[3a]→4→5→6→7`

---

### Step 4: Load Stage Skill (Progressive Disclosure)

**⚠️ Load only the currently matched Stage Skill, do NOT load all.**

**Loading rules**:
1. Determine target Stage according to Step 3 routing table
2. **Output loading declaration** (must include following info):
   ```markdown
   📦 Loading Stage Skill: <stage-name>
   - Skill path: skills/stage-skills/<stage-name>/_SKILL.md
   - Dependencies: <dependency-list or "none">
   - Stage goal: <brief description>
   ```
3. Only load that Stage's `_SKILL.md` (do NOT load other Stages)
4. If dependencies declared, load dependency Skills first
5. If Stage Skill unavailable, degrade to Prompt file

---

### Step 5: Mode Confirmation (Mandatory Stop & Wait)

**⚠️ Mandatory rule**: Must use `read_file` tool to read `references/mode-rules.md`.

**Must output** (adopt optimized format from stage-0-confirm):
```markdown
🎯 Suggested mode: <Standard / Strict>
   Reason: <brief explanation why this mode>

📋 <mode> complete workflow:
<workflow steps summary>

Artifacts: <key artifacts list>

Other optional modes:
• Fast — ≤2 files, <50 lines, low risk
• Strict — high risk/production sensitive/architecture or data impact

Please confirm or select other mode:
1. ✅ <suggested mode> (recommended)
2. Fast
3. Strict
```

**⚠️ Mandatory stop & wait**: After outputting, **MUST wait for user confirmation** before entering Step 6.

---

### Step 6: Output Routing Declaration

**Template**:
```markdown
🚀 Routing Declaration

Stage: <stage-name>
Mode: <Fast/Standard/Strict>
Stage Skill: <path>
Entry gate: Passed
Self-check list: To be executed
```

**Self-check list**:
- ⏳ Read STATE.md
- ⏳ **Read references/entry-check.md**
- ⏳ Entry detection executed per decision tree (Case D/E/C waited for user confirmation)
- ⏳ Routing matched correctly
- ⏳ Stage Skill loaded
- ⏳ Mode confirmed
- ⏳ Routing declaration outputted

---

### Step 7: Execute Stage Skill

Stage Skill executes according to **its internally defined Step workflow** (not GO.md's 7 steps):
1. Entry gate check
2. Execute Step 1-N (see stage skill's `## Execution Workflow` section)
3. Read template before artifact output
4. Execute self-check list
5. Update STATE.md
6. Route to next stage

---

## Core Reference Documents

Load these files as needed (all in `references/` directory):

| File | Purpose |
|---|---|
| `references/GO.md` | **Complete workflow details** (if need more than this SKILL.md) |
| `references/RULES.md` | Global red lines and state discipline |
| `references/gate-rules.md` | Stage gate validation rules |
| `references/mode-rules.md` | Mode determination rules (Fast/Standard/Strict) |
| `references/token-budget.md` | Token budget management |
| `references/templates/` | Stage artifact templates (load before output) |
| `references/prompts/` | Stage execution prompts (fallback) |
| `references/reference/` | Additional reference material (load as needed) |
| `skills/` | Stage Skills (load on demand per Step 4) |

---

## Template Enforcement Rules

> **⚠️ All artifacts MUST be output strictly according to templates**:
> - Must read corresponding template file before output (`references/templates/*.md`)
> - Artifacts MUST include all sections from template, do not omit or rewrite
> - Placeholders (e.g., `<req-id>`) MUST be replaced with actual values
> - See `references/RULES.md` R13.9 / R13.10 for details

---

## Multi-Project Support

DevFlow Kit **supports parallel multi-project**, each project has independent `.devflow-kit/` directory:
- Memory system isolated per project, will not share across projects
- To switch projects, just switch to the corresponding project root directory

---

## Version

v2.4.1 - Refactored for skill-creator compliance
- Flattened directory structure (references/ instead of flow/)
- Improved description with trigger conditions
- Core workflow in SKILL.md, details in references/GO.md
- Progressive disclosure: only load needed stage skills
