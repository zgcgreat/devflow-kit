# GO — devflow-kit 统一路由器（精简版 v2.3）

> **AI指令**：
> 1. 本文件是路由入口，读完后按第三步路由表匹配用户意图
> 2. **第一条回复必须输出路由声明**（含选定的模式 Fast/Standard/Strict + 理由）
> 3. **所有产物必须保存到 `.specs/<req-id>/` 下**
> 4. **⚠️ 所有产物必须严格按模板输出**（见 RULES.md R13.9）
>
> 用户使用方式：`Use superflow-kit` 或 `@superflow-kit/flow/GO.md` + 一句话需求

---

## ⚡ 执行顺序清单（简化版）

```
第一步：读取项目状态 (.specs/项目状态.md)
第二步：入场检测（brownfield必跑，见 entry-check.md）
第三步：路由匹配 → 确定目标 stage skill
第四步：加载 Stage Skill（全读 _SKILL.md）
第五步：模式确认（Fast/Standard/Strict）
第六步：输出路由声明
第七步：执行 stage skill（按内部Step流程）
```

**关键检查点**：
- 第二步未输出检测结果框 → **禁止进入第三步**
- 情况 D/E 未等用户确认 → **禁止继续**（必须等待用户回复）
- 第四步 stage skill 未加载 → **禁止输出路由声明**
- 第五步模式推荐后 → **强制停等用户确认**（不得自动进入第六步）
- 第七步未读模板 → **禁止输出产物**

---

## 模式与风险分级

详见 `mode-rules.md`。核心要点：

| 模式 | 适用 | 是否停等用户 |
|------|------|--------------|
| **Fast** | 1~2文件、<50行、低风险 | 默认不必 |
| **Standard** | 常规feature/bugfix | 建议停等 |
| **Strict** | 高风险/生产敏感 | 必须停等 |

**高风险自动升级Strict**：鉴权、支付、schema/migration、公共API、infra等。

---

## Token预算

详见 `token-budget.md`。核心规则：基础预算200行/轮，必须产物豁免。

---

## 第一步 · 读取项目状态

1. 尝试读 `.specs/项目状态.md`。不存在 → 用模板创建
2. 关注字段：`活跃 req` / `当前阶段` / `中断任务`
3. 如存在 `中断任务` 非空 → **优先级最高**，直接走恢复分支
4. **检查记忆系统** (可选):
   - 如果 `.superpowers-memory/` 存在 → 加载记忆文件
   - 读取顺序: PROJECT_CONTEXT.md → CURRENT_STATE.md → DECISIONS.md → KNOWN_FAILURES.md
   - 最近3个 session-journal 条目

---

## 第二步 · 入场检测

详见 `entry-check.md`。核心要点：

**强制门控**：未完成检测前，**禁止**进入任何需求相关阶段。

**检测步骤**：
1. 检查是否有 ai_context_doc 字段 → 情况A
2. 检查 上下文.md 是否存在 + 扫描时间 → 情况B/C
3. 检查其他AI上下文文档 → 情况D（**⚠️ 停等用户确认**）
4. 检查是否greenfield → 情况F（跳过）或E（**⚠️ 停等用户确认**）

**必须输出检测结果框**：
```
┌─────────────────────────────────────────────┐
│  🔍 入场检测                                  │
├─────────────────────────────────────────────┤
│  检测结果：<情况 A/B/C/D/E/F>                 │
│  项目类型：<brownfield / greenfield>         │
│  上下文文档：<路径 或 "无">                   │
└─────────────────────────────────────────────┘
```

---

## 第三步 · 路由表

### A. 用户意图路由

| 用户说 | 需求状态 | Stage Skill | 依赖 Skills |
|---|---|---|---|
| 有新想法想做件事 | 无活跃req | `stage-0-confirm` | idea-refine, development-core |
| 恢复中断任务 | 有中断任务 | 按R1.5重启 | - |
| 不要进入flow-kit | - | 直接做，跳过 | - |
| 健康检查 | - | `stage-m-health` | code-quality |
| evolve/architect | - | `stage-a-evolve` 或 `stage-a-architect` | design-and-architecture |
| 纯技术问题 | - | 直接回答 | - |
| 上传文档/PRD | - | 文档解析模式 → 00-需求确认 | development-core |

### B. 可选命令

| 用户说 | Stage Skill | 说明 |
|---|---|---|
| "换个方案" | `stage-2-design` | 触发新ADR |
| "architect" | `stage-a-architect` | 架构梳理 |
| "扫描代码" | `stage-i-intel-scan` | 入场扫描 |
| "我的需求变了" | `stage-0-confirm` | 归档旧req，重新确认 |
| "继续" | 下一阶段stage skill | 按R1.5执行 |

### C. 阶段门验证

详见 `gate-rules.md`。核心规则：缺前置产物 → 不允许直接进入，必须先补跑缺失阶段。

**阶段依赖**：`0→1→2→[2a]→3→[3a]→4→5→6→7`

**可选阶段说明**:
- **[2a] UI设计**: 仅前端/UI项目需要。纯后端/CLI/lib可跳过。
  - 触发条件: task涉及UI文件(.tsx/.css/.vue等)
  - 规则依据: RULES.md R2.10
- **[3a] 实施计划**: 复杂项目建议使用，简单项目可跳过
  - 适用场景: 多任务并行、需要详细时间规划的项目

---

## 第四步 · 加载Stage Skill

### Stage Skill映射表

| 阶段 | Stage Skill | Prompt文件（后备） |
|------|-------------|-------------------|
| **0-confirm** | `flow/stage-skills/stage-0-confirm/_SKILL.md` | `flow/prompts/0-confirm.md` |
| **1-analysis** | `flow/stage-skills/stage-1-analysis/_SKILL.md` | `flow/prompts/1-analysis.md` |
| **2-design** | `flow/stage-skills/stage-2-design/_SKILL.md` | `flow/prompts/2-design.md` |
| **2a-ui-design** | `flow/stage-skills/stage-2a-ui-design/_SKILL.md` | `flow/prompts/2a-ui-design.md` |
| **3-task** | `flow/stage-skills/stage-3-task/_SKILL.md` | `flow/prompts/3-task.md` |
| **3a-plan** | `flow/stage-skills/stage-3a-plan/_SKILL.md` | `flow/prompts/3a-plan.md` |
| **4-dev** | `flow/stage-skills/stage-4-dev/_SKILL.md` | `flow/prompts/4-dev.md` |
| **5-test** | `flow/stage-skills/stage-5-test/_SKILL.md` | `flow/prompts/5-test.md` |
| **6-review** | `flow/stage-skills/stage-6-review/_SKILL.md` | `flow/prompts/6-review.md` |
| **7-integration** | `flow/stage-skills/stage-7-integration/_SKILL.md` | `flow/prompts/7-integration.md` |

> **注**：Prompt文件仅保留元信息和快速参考，执行逻辑以Stage Skill为准。

**可选命令**：
| 命令 | Stage Skill |
|------|-------------|
| A-architect | `flow/stage-skills/stage-a-architect/_SKILL.md` |
| A-evolve | `flow/stage-skills/stage-a-evolve/_SKILL.md` |
| M-health | `flow/stage-skills/stage-m-health/_SKILL.md` |
| I-intel-scan | `flow/stage-skills/stage-i-intel-scan/_SKILL.md` |

**加载方式**：
1. 优先加载 Stage Skill（全读 `_SKILL.md`）
2. 如 Stage Skill 声明了 `dependencies`，先加载依赖：
   ```
   示例：stage-0-confirm 声明 dependencies: [idea-refine, development-core]
   → 先加载 agent-skills/skills/idea-refine/_SKILL.md
   → 再加载 agent-skills/skills/development-core/_SKILL.md
   → 最后加载 flow/stage-skills/stage-0-confirm/_SKILL.md
   ```
3. 如 Stage Skill 不可用，降级到 Prompt 文件

---

## 第五步 · 模式确认

详见 `mode-rules.md`。

**必须输出**：
```markdown
🎯 模式推荐：<模式>（置信度 XX%）

评分详情:
- Fast: XX%
- Standard: XX%
- Strict: XX%

请确认或选择其他模式：
1. ✅ <推荐模式>
2. <备选1>
3. <备选2>
```

**⚠️ 强制停等**：输出模式推荐后，**必须等待用户确认**才能进入第六步。

---

## 第六步 · 输出路由声明

**模板**：
```markdown
🚀 路由声明

阶段: <stage-name>
Mode: <Fast/Standard/Strict>
Stage Skill: <path>
入口门禁: 通过
自检清单: 待执行
```

**自检清单**（第一~第六门控）：
- [ ] 已读项目状态
- [ ] 入场检测完成
- [ ] 路由匹配正确
- [ ] Stage Skill已加载
- [ ] 模式已确认
- [ ] 路由声明已输出

---

## 第七步 · 执行Stage Skill

Stage Skill按**其内部定义的Step流程**执行（非GO.md的7步）：
1. 入口门禁检查（见stage skill的「## 入口门禁」章节）
2. 执行Step 1-N（见stage skill的「## 执行流程」章节）
3. 产物输出前读模板
4. 执行自检清单（见stage skill的「## 自检清单」章节）
5. 更新项目状态
6. 路由到下一阶段（见stage skill的「## 触发下一步」章节）

---

## 详细规则参考

- **模式判定**: `mode-rules.md`
- **入场检测**: `entry-check.md`
- **阶段门**: `gate-rules.md`
- **Token预算**: `token-budget.md`
- **全局红线**: `RULES.md`

---

## 版本

v2.3 - Stage Skill架构（精简版，约200行）
