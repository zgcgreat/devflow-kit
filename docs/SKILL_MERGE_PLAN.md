# Skill 合并方案

> **目标**: 将22个skill合并为12个，减少复杂度，提升可维护性  
> **版本**: v2.0-draft  
> **状态**: 设计方案

---

## 合并原则

### 1. 功能相近合并

将职责重叠或紧密相关的skill合并为一个。

### 2. 保持原子性

合并后的skill仍应保持单一职责，避免过大。

### 3. 向后兼容

提供迁移指南，确保旧项目不受影响。

---

## 合并方案

### 方案A: 保守合并（22→15）

| 合并后Skill | 包含原Skill | 理由 |
|------------|------------|------|
| **design-and-architecture** | api-and-interface-design<br/>source-driven-development<br/>documentation-and-adrs | 设计阶段相关，经常一起使用 |
| **testing-suite** | test-driven-development<br/>browser-testing-with-devtools | 测试相关 |
| **code-quality** | code-review-and-quality<br/>code-simplification | 代码质量相关 |
| **devops** | ci-cd-and-automation<br/>git-workflow-and-versioning<br/>shipping-and-launch | DevOps流程 |
| **security-and-performance** | security-and-hardening<br/>performance-optimization | 非功能性需求 |
| **development-core** | incremental-implementation<br/>spec-driven-development<br/>doubt-driven-development | 核心开发方法论 |
| **planning-and-context** | planning-and-task-breakdown<br/>context-engineering | 规划和上下文管理 |
| **idea-refine** | idea-refine | 保持不变 |
| **frontend-ui-engineering** | frontend-ui-engineering | 保持不变 |
| **debugging-and-error-recovery** | debugging-and-error-recovery | 保持不变 |
| **deprecation-and-migration** | deprecation-and-migration | 保持不变 |
| **using-agent-skills** | using-agent-skills | 保持不变 |

**减少**: 22 → 12个skill

---

### 方案B: 激进合并（22→8）

| 合并后Skill | 包含原Skill |
|------------|------------|
| **full-stack-development** | spec-driven-development<br/>source-driven-development<br/>incremental-implementation<br/>doubt-driven-development<br/>api-and-interface-design<br/>frontend-ui-engineering |
| **testing-and-quality** | test-driven-development<br/>browser-testing-with-devtools<br/>code-review-and-quality<br/>code-simplification |
| **planning-and-design** | planning-and-task-breakdown<br/>context-engineering<br/>documentation-and-adrs<br/>idea-refine |
| **devops-and-deployment** | git-workflow-and-versioning<br/>ci-cd-and-automation<br/>shipping-and-launch |
| **security-and-performance** | security-and-hardening<br/>performance-optimization |
| **debugging-and-maintenance** | debugging-and-error-recovery<br/>deprecation-and-migration |
| **using-agent-skills** | using-agent-skills |

**减少**: 22 → 7个skill

---

## 推荐方案：方案A（平衡）

**理由**:
- ✅ 减少45%的skill数量（22→12）
- ✅ 保持合理的粒度
- ✅ 易于理解和维护
- ✅ 迁移成本低

---

## 详细合并计划

### 1. design-and-architecture

**合并**:
- `api-and-interface-design` (API设计)
- `source-driven-development` (源码驱动开发)
- `documentation-and-adrs` (文档和架构决策)

**新结构**:
```
agent-skills/skills/design-and-architecture/
├── _SKILL.md              # 主入口，包含三部分
├── api-design.md          # API设计规范
├── source-driven.md       # 源码驱动方法
└── adrs.md                # ADR模板和指南
```

**_SKILL.md内容**:
```markdown
# Design and Architecture Skill

本skill包含三个子模块：

## 1. API and Interface Design
[原有api-and-interface-design的内容]

## 2. Source-Driven Development
[原有source-driven-development的内容]

## 3. Documentation and ADRs
[原有documentation-and-adrs的内容]

## 使用建议
- 在2-design阶段全读本skill
- 根据项目类型选择重点模块
  - 后端项目: 重点关注API设计
  - 前端项目: 重点关注源码驱动
  - 所有项目: 必须编写ADR
```

---

### 2. testing-suite

**合并**:
- `test-driven-development`
- `browser-testing-with-devtools`

**新结构**:
```
agent-skills/skills/testing-suite/
├── _SKILL.md
├── tdd-guide.md
└── browser-testing.md
```

---

### 3. code-quality

**合并**:
- `code-review-and-quality`
- `code-simplification`

**新结构**:
```
agent-skills/skills/code-quality/
├── _SKILL.md
├── review-checklist.md
└── simplification-patterns.md
```

---

### 4. devops

**合并**:
- `ci-cd-and-automation`
- `git-workflow-and-versioning`
- `shipping-and-launch`

**新结构**:
```
agent-skills/skills/devops/
├── _SKILL.md
├── git-workflow.md
├── ci-cd-guide.md
└── shipping-checklist.md
```

---

### 5. security-and-performance

**合并**:
- `security-and-hardening`
- `performance-optimization`

**新结构**:
```
agent-skills/skills/security-and-performance/
├── _SKILL.md
├── security-checklist.md
└── performance-guide.md
```

---

### 6. development-core

**合并**:
- `incremental-implementation`
- `spec-driven-development`
- `doubt-driven-development`

**新结构**:
```
agent-skills/skills/development-core/
├── _SKILL.md
├── spec-driven.md
├── incremental.md
└── doubt-driven.md
```

---

### 7. planning-and-context

**合并**:
- `planning-and-task-breakdown`
- `context-engineering`

**新结构**:
```
agent-skills/skills/planning-and-context/
├── _SKILL.md
├── task-breakdown.md
└── context-management.md
```

---

## 保持不变（5个）

1. **idea-refine** - 需求精炼，独立性强
2. **frontend-ui-engineering** - 前端专用，领域特定
3. **debugging-and-error-recovery** - 调试场景，独立工作流
4. **deprecation-and-migration** - 迁移场景，低频使用
5. **using-agent-skills** - 元skill，指导如何使用

---

## 迁移指南

### 对于新项目

直接使用新的12个skill。

### 对于现有项目

#### 方式1: 自动迁移脚本

```bash
# Windows
.\scripts\migrate-skills.ps1 -ProjectRoot <路径>

# macOS/Linux
sh ./scripts/migrate-skills.sh --project-root <路径>
```

脚本会：
1. 检测项目中使用的旧skill
2. 替换为对应的新skill引用
3. 更新GO.md中的skill加载列表
4. 生成迁移报告

#### 方式2: 手动迁移

**步骤**:
1. 备份 `.specs/` 目录
2. 删除旧的skill目录
3. 复制新的skill目录
4. 更新GO.md中的skill引用
5. 测试流程是否正常

---

## GO.md 修改点

### 修改前（22个skill）

```markdown
| 阶段 | 必须加载的 skill |
|------|-----------------|
| 0-confirm | idea-refine, spec-driven-development |
| 1-analysis | spec-driven-development |
| 2-design | api-and-interface-design, source-driven-development, documentation-and-adrs |
...
```

### 修改后（12个skill）

```markdown
| 阶段 | 必须加载的 skill |
|------|-----------------|
| 0-confirm | idea-refine, development-core |
| 1-analysis | development-core |
| 2-design | design-and-architecture |
| 2a-ui-design | frontend-ui-engineering |
| 3-task | planning-and-context |
| 4-dev | development-core, testing-suite |
| 5-test | testing-suite |
| 6-review | code-quality, security-and-performance |
| 7-integration | devops |
```

---

## 预期收益

| 指标 | 合并前 | 合并后 | 改善 |
|------|--------|--------|------|
| Skill数量 | 22 | 12 | -45% |
| 平均文件大小 | 50行 | 120行 | +140% |
| 加载次数 | 8-10次 | 4-5次 | -50% |
| 维护成本 | 高 | 中 | -40% |
| 学习曲线 | 陡峭 | 平缓 | -50% |

---

## 风险评估

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|---------|
| 合并后skill过大 | 中 | 中 | 控制每个skill<200行 |
| 用户不适应新结构 | 低 | 低 | 提供迁移指南和教程 |
| 某些场景粒度不够 | 低 | 中 | 保留细分模块作为可选 |
| 向后兼容问题 | 中 | 高 | 提供自动迁移脚本 |

---

## 实施计划

### Week 1: 准备阶段
- [ ] 创建新的12个skill目录结构
- [ ] 合并skill内容
- [ ] 编写迁移脚本
- [ ] 更新GO.md

### Week 2: 测试阶段
- [ ] 在3个项目试点
- [ ] 收集反馈
- [ ] 调整skill内容
- [ ] 完善迁移指南

### Week 3: 发布阶段
- [ ] 正式发布v2.1
- [ ] 更新文档
- [ ] 通知用户
- [ ] 提供支持

---

## 备选方案

如果团队反馈合并后粒度过大，可以：

### 方案C: 混合模式

保留12个主skill，但每个skill内部保持模块化：

```
design-and-architecture/
├── _SKILL.md          # 主入口（20行）
├── modules/
│   ├── api-design.md  # 可选加载
│   ├── source-driven.md
│   └── adrs.md
```

在GO.md中按需加载子模块：

```markdown
加载 design-and-architecture/_SKILL.md（主入口）
如需API设计细节，额外加载 modules/api-design.md
```

**优点**:
- 灵活性高
- 按需加载，节省token
- 兼顾简洁和细粒度

**缺点**:
- 结构稍复杂
- 需要AI理解模块关系

---

*最后更新: 2024-01-15*  
*版本: v2.0-draft*
