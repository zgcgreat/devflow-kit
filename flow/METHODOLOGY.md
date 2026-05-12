# 方法论（flow-kit 骨架 · AI 必读）

> **你是 AI 助手。这是 flow-kit 的方法论全文，每次会话开始 / 清窗恢复时必读一遍。**
> 读完之后你应该知道：当前处于哪个阶段、要产出什么工件、和其他阶段的输入输出关系、哪些核心机制不允许绕过。
> 后续具体执行按各阶段 `prompts/<n>-*.md` 的指令走，本文件只定义骨架。

---

## 标准流程

```
需求确认 → REQUIREMENT → DESIGN → [2a UI-DESIGN]* → TASK → DEV → TEST → REVIEW → INTEGRATION → ARCHIVE
    │          │           │            │            │      │       │         │            │
    │          └─ 上下文.md 跨阶段共享 ┘     前端项目 ┘     └ TDD ─┘         │            │
    │                                                                          │            │
    └─────────────────── 迭代回灌（开启新需求） ←─────────────────────────────┘            │
                                                                                            ↓
                                                                                     SHIP / 归档

* 仅前端项目走 2a；后端 / CLI / lib 跳过
```

**前端项目路径**：`需求确认 → REQUIREMENT → DESIGN → 2a UI-DESIGN → TASK → DEV → TEST → REVIEW (3 轮) → INTEGRATION`
**后端项目路径**：`需求确认 → REQUIREMENT → DESIGN → TASK → DEV → TEST → REVIEW → INTEGRATION`
**MVP 路径**：`REQUIREMENT → TASK → DEV`（只跑这三步，3 个文件起步）

---

## 阶段定义

| 阶段 | 输入 | AI 职责 | 输出文件 | 需人工确认 | 迭代可跳 |
|---|---|---|---|---|---|
| 需求确认 | 一句话想法 / bug | 反问澄清 + 影响面判定 | `00-需求确认.md` | 是 | 否 |
| REQUIREMENT | 需求确认 | 写 AC + 范围切分 + 术语提取 | `01-需求分析.md` + `上下文.md` | 是 | 条件性 |
| DESIGN | 需求确认 + REQUIREMENT + CONTEXT | **技术栈预选**（5~6 卡让用户选）+ 技术决策 + ADR + 数据流 | `02-方案设计.md`（含 `## 0. 技术栈选定`）| 是（栈 + 关键决策）| 条件性 |
| **2a UI-DESIGN** | REQUIREMENT + DESIGN | 美学方向 + design tokens + 反 AI-slop 自检 | `02a-UI设计.md` | 是（关键决策）| 否（前端必跑）/ 是（非前端跳过）|
| TASK | DESIGN（+ UI-DESIGN）| 拆原子任务 + 标 `[P]` 并行 + 依赖图 | `03-任务拆分.md` | 否 | 否 |
| DEV | TASK 中一项 | fresh subagent + TDD + 原子提交 | 代码 + `开发记录.md` | 否 | 否 |
| TEST | 代码 + AC + 非功能需求 | **5 轮金字塔**：功能 / 性能 / 安全 / 兼容 / 可观测（按项目类型裁剪）| `05-测试报告.md` | 否 | 否 |
| REVIEW | diff + SPEC | 四轮审查（spec 合规 + 代码质量 + UI + 补充）| `06-代码审查.md` | 是（仅严重项）| 否 |
| INTEGRATION | 全部已通过 | UAT + 集成 smoke + 失败诊断 | `UAT.md` / fix-plan | 是 | 否 |
| ARCHIVE | 已合并 | 折叠需求进主 spec | `archive/<date>-<name>/` | 否 | — |

---

## 文件体系

所有产物存到：`./.specs/<req-id>/`

| 文件 | 用途 | 谁来写 |
|---|---|---|
| `00-需求确认.md` | 一份需求确认书（why / what / 影响面 / 范围排除）| 协作（人起草 + AI 反问补全）|
| `01-需求分析.md` | 需求 + 验收准则（用户故事 / AC / v1·v2·out / 非功能性）| AI 主笔，人确认 |
| `上下文.md` | 域语言 + 默认决策（术语表 / 已锁决策 / 偏好）| 协作 |
| `02-方案设计.md` | 技术设计（架构图 / 数据流 / ADR / 风险）| AI 主笔，人审 |
| `02a-UI设计.md` | UI 美学方向 + design tokens（OKLCH 颜色 / 字体 / 间距 / 动效）+ 反 AI-slop 自检（仅前端项目）| AI 主笔，人审 |
| `03-任务拆分.md` | 任务清单（任务 / 依赖 / `[P]` / verify / done）| AI |
| `05-测试报告.md` | 5 轮测试金字塔报告（功能矩阵 + UAT + 性能 / 安全 / 兼容 / 可观测口供）| AI |
| `06-代码审查.md` | 审查发现（严重度 / 修复决策 / 跨模型分歧）| AI |
| `开发记录.md` | 阶段产物快照（用于截断历史）| AI |
| `<task-id>-开发中断快照.md` | **临时**文件——任务执行中途清窗时写入，含「已排除方案」反重复段。任务完成后删除。详见 RULES R1.5/R1.6/R1.7 | AI |
| `经验总结.md`（`.specs/` 根）| **项目级常驻**——跨需求失败知识库。每个 DEV 任务开工前必扫；INTEGRATION 阶段提名新条目。详见 RULES R1.8 | AI 提名 + 人工筛 |
| `.specs/进度跟踪.md`| 跨会话状态（当前位置 / 中断任务 / 阻塞 / 决策日志）| AI 维护，人可改 |

---

## Agent 角色（同一模型也要扮演不同角色）

| 角色 | 输入 | 输出 | 时机 |
|---|---|---|---|
| **Architect** | 需求确认 / REQUIREMENT | 02-方案设计.md + ADR | DESIGN 阶段 |
| **UI Director** | REQUIREMENT + DESIGN | 02a-UI设计.md（含 design tokens）| 2a UI-DESIGN 阶段（前端项目）|
| **Planner** | DESIGN（+ UI-DESIGN）| 03-任务拆分.md | TASK 阶段 |
| **Dev**（多实例并行）| TASK 中一项 | 代码 + 任务级 SUMMARY | DEV 阶段，每任务一个 fresh context |
| **Reviewer** | diff + SPEC | 06-代码审查.md | REVIEW 阶段（建议四轮：spec 合规 + 代码质量 + UI + 补充）|
| **Verifier** | 构建产物 + AC | UAT.md / fix-plan | INTEGRATION 阶段 |

**红线**：Architect 不写代码，UI Director 不写完整组件，Dev 不改 SPEC / UI-DESIGN，Reviewer 不修代码（只产报告 + 修复 task）。

---

## 7 个核心机制（已内化进各阶段 prompt）

1. **任务拆分** — 拆到 fresh context 跑得完且自带 verify 的最小单元，按文件冲突切而不是按层切
2. **Prompt 组织** — 模板 + 文件引用 + 验证锚点；不靠对话堆叠
3. **上下文控制** — 阶段切换 = 清窗 + 重新载入指定 .md
4. **代码生成策略** — 默认分步（每任务 fresh context），仅小特性允许一次性
5. **测试生成** — 测试从 AC 派生而非从实现派生；bug 修复必伴随回归测试
6. **审查 / Refine 循环** — 至少四轮（spec 合规 + 代码质量 + UI + 补充），至少一轮跨模型 spot-check
7. **自迭代** — 失败自动产 fix-plan 回炉，最多 3 轮，超限人工介入

---

## 自迭代上限

任何阶段（plan / dev / verify）的自动重试次数 **≤ 3 轮**。
超限必须停下来让人决策，禁止死循环。