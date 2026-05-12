# devflow-kit /go

Use `devflow-kit/SKILL.md` as the entry point. Read `devflow-kit/flow/GO.md` and follow ALL steps in order:
1. Read or create `.specs/进度跟踪.md` (project state)
2. Run brownfield entry detection if applicable
3. Match user intent against the routing table
4. Load required artifacts based on the routed phase
5. Output routing declaration with mode confirmation
6. Execute the routed phase prompt

Do not skip steps. Do not implement before phase gates are satisfied unless this is explicitly a tiny direct edit.
