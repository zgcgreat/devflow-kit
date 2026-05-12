---
description: Route any engineering task through devflow-kit
---

Use the devflow-kit skill.

Read `devflow-kit/flow/GO.md` and follow ALL steps in order:
1. **Step 1**: Read or create `.specs/进度跟踪.md` (project state)
2. **Step 2**: Run brownfield entry detection if applicable (check for 上下文.md / AI context docs)
3. **Step 3**: Match user intent against the routing table
4. **Step 4**: Load required artifacts based on the routed phase
5. **Step 5**: Output routing declaration with mode confirmation
6. **Step 6**: Execute the routed phase prompt

Do not skip steps. Do not implement before phase gates are satisfied unless this is explicitly a tiny direct edit (Fast mode).

## Document Parsing Mode

When user uploads or pastes a document (PRD, design file, technical spec), trigger the document parsing mode defined in GO.md Section D:
- Parse the document content
- Evaluate document quality (high/medium/low)
- Output parsing results with clarification questions
- Confirm mode (Fast/Standard/Strict) with user
- Generate artifacts based on quality level
