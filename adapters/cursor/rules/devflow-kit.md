# devflow-kit Cursor rule

For non-trivial software tasks, use `devflow-kit/SKILL.md` as the entry point. Read `devflow-kit/flow/GO.md` and follow ALL steps in order:
1. Read or create `.specs/项目状态.md` (project state)
2. Run brownfield entry detection if applicable
3. Match user intent against the routing table
4. Load required artifacts based on the routed phase
5. Output routing declaration with mode confirmation
6. Execute the routed phase prompt

Use `.specs/<req-id>/` artifacts for durable decisions and verification evidence. Do not implement before requirements and tasks exist unless the change is explicitly tiny and self-contained.

## Document Parsing Mode

When user uploads a document (PRD, design file, technical spec), trigger the document parsing mode defined in GO.md Section D. Parse the document, evaluate quality, and route accordingly.
