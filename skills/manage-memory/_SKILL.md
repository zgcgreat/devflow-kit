---
name: manage-memory
description: 管理 DevFlow Kit 的记忆系统。用于初始化、更新、验证和清理 .devflow-kit/memory/ 目录中的记忆文件。
---

# Manage DevFlow Memory

管理项目的跨会话记忆系统，确保AI能够持续学习和保持上下文。

## 触发场景

- "初始化记忆系统"
- "运行学习工作流" (Use superpowers-learning workflow)
- "更新项目记忆"
- "会话收尾检查"
- "验证记忆质量"
- "清理过期记忆"

## 执行流程

### Step 1: 检测记忆系统状态

```markdown
🔍 检测记忆系统状态

检查项:
- [ ] .devflow-kit/memory/ 目录是否存在?
- [ ] PROJECT_CONTEXT.md 是否存在?
- [ ] CURRENT_STATE.md 是否存在?
- [ ] DECISIONS.md 是否存在?
- [ ] KNOWN_FAILURES.md 是否存在?
- [ ] journals/ 目录是否存在?
```

**如果不存在**:
```markdown
⚠️ 记忆系统未初始化

是否要初始化记忆系统? [Y/n]

初始化将创建:
- .devflow-kit/memory/
  ├── PROJECT_CONTEXT.md (项目背景)
  ├── DECISIONS.md (技术决策)
  ├── KNOWN_FAILURES.md (失败模式)
  ├── CURRENT_STATE.md (当前状态)
  ├── VERIFICATION_BASELINE.md (验证基线)
  ├── TEAM_PREFERENCES.md (团队偏好)
  ├── USER_PROFILE.md (用户画像)
  ├── AGENT_NOTES.md (AI笔记)
  ├── LEARNING_BACKLOG.md (学习待办)
  ├── SESSION_CLOSE_CHECKLIST.md (会话收尾清单)
  ├── memory-index.yaml (记忆健康索引)
  └── journals/ (会话日志)
```

---

### Step 2: 根据用户意图执行操作

#### 场景A: 初始化记忆系统

**用户**: "初始化记忆系统"

**AI执行**:

```markdown
🚀 初始化记忆系统...

步骤1: 创建目录结构
- ✅ .devflow-kit/memory/
- ✅ .devflow-kit/memory/journals/

步骤2: 从 templates/memory/ 复制模板文件
- ✅ PROJECT_CONTEXT.md (项目背景)
- ✅ DECISIONS.md (技术决策)
- ✅ KNOWN_FAILURES.md (已知失败模式)
- ✅ CURRENT_STATE.md (当前状态)
- ✅ VERIFICATION_BASELINE.md (验证基线)
- ✅ TEAM_PREFERENCES.md (团队偏好)
- ✅ USER_PROFILE.md (用户画像)
- ✅ AGENT_NOTES.md (AI助手笔记)
- ✅ LEARNING_BACKLOG.md (学习待办)
- ✅ SESSION_CLOSE_CHECKLIST.md (会话收尾清单)
- ✅ memory-index.yaml (记忆健康索引)

步骤3: 自动填充项目信息

正在分析项目...
📊 提取的信息:

PROJECT_CONTEXT.md 已自动填充:

# Project Context

## 项目基本信息
- **项目名称**: <从package.json/pom.xml等提取>
- **项目类型**: <前端/后端/全栈>
- **检测到时间**: <当前日期>

## 技术栈
- <自动识别的框架和依赖>

## 项目结构
- <扫描的目录结构>

## 既有抽象
- <识别的既有封装>

✅ 记忆系统初始化完成!

💡 提示:
- 你可以编辑 .devflow-kit/memory/PROJECT_CONTEXT.md 补充更多信息
- 每次会话结束时，说 "Use superpowers-learning workflow" 更新记忆
```

---

#### 场景B: 更新记忆 (会话收尾)

**用户**: "Use superpowers-learning workflow" 或 "更新项目记忆"

**AI执行**:

```markdown
🧠 记忆系统学习工作流

步骤1: 回顾本次会话的工作内容
- 分析了哪些文件?
- 做了哪些修改?
- 遇到了什么问题?
- 做出了哪些决策?
- 验证了什么?

步骤2: 将学习内容分类为四类
- 📌 持久化项目事实 (durable project facts)
- 🔄 当前工作状态 (current working state)
- 📝 会话结果 (session outcome)
- ♻️ 可复用方法或重复陷阱 (reusable method or repeated pitfall)

步骤3: 检查并更新所有相关的记忆文件
```

**具体操作**:

1. **读取 SESSION_CLOSE_CHECKLIST.md 并逐项确认**
   
   按照以下清单检查本次会话：
   - [ ] CURRENT_STATE.md 是否已更新到最新状态？
   - [ ] 是否需要创建新的 journal 条目？（判断标准：修改超过5个文件 OR 做出重要决策 OR 遇到系统性问题）
   - [ ] 是否有持久化事实、决策、失败模式、验证规则、团队偏好变化？
   - [ ] 所有新增条目是否包含完整元数据（id, status, confidence, source, last_updated, review_after）？
   - [ ] 如果有 confidence=verified 的条目，source 是否为空？（禁止！）
   - [ ] 是否有旧条目被替换？如有，是否标记为 status: superseded？
   - [ ] LEARNING_BACKLOG 中是否有 ready_for_promotion 的候选？证据是否充足？

3. **判断是否需要更新每个记忆文件**（快速决策指南）

   **决策树**: 本次会话做了什么？
   ```
   ├─ 修改了技术栈/架构 → 更新 PROJECT_CONTEXT.md
   ├─ 做出了技术决策 → 追加 DECISIONS.md
   ├─ 遇到了系统性问题 → 追加 KNOWN_FAILURES.md
   ├─ 建立了新验证标准 → 追加 VERIFICATION_BASELINE.md
   ├─ 团队约定变化 → 更新 TEAM_PREFERENCES.md
   ├─ 用户偏好调整 → 更新 USER_PROFILE.md
   ├─ AI执行提醒变化 → 更新 AGENT_NOTES.md
   ├─ 发现可复用模式 → 追加 LEARNING_BACKLOG.md
   └─ 只是开发功能 → 只更新 CURRENT_STATE.md + journals/
   ```

   **必须更新的文件**:
   
   ✅ **CURRENT_STATE.md** - 每次会话结束都必须更新
   ```markdown
   # Current State
   
   **最后更新**: YYYY-MM-DD HH:mm:ss
   
   ## 当前焦点
   <下一个待开发的需求 或 "无">
   
   ## 最近完成
   - ✅ <本次需求名称> (<req-id>) - YYYY-MM-DD
     - 主要功能：<简要描述>
     - 关键决策：<如有>
   
   ## 待解决问题
   - <从06-code-review.md提取的遗留问题>
   
   ## 下一步
   - <建议的下一个需求>
   ```
   
   ✅ **journals/** - 每次有意义的会话都创建日志
   
   **判断标准**（满足任一即创建）:
   - 修改超过 5 个文件
   - 做出了重要技术决策
   - 遇到了系统性问题或失败模式
   - 完成了重要功能模块
   - 学到了可复用的经验
   
   - 文件名格式：`YYYY-MM-DD-<req-id>.md`
   - 记录：工作内容、决策、问题、经验、下一步

   **条件更新的文件** (根据会话内容判断):
   
   🔹 **PROJECT_CONTEXT.md** - 当持久化项目事实变化时
   - 技术栈变更
   - 架构重大调整
   - 新的核心模块
   - 重要约束条件变化
   
   🔹 **DECISIONS.md** - 当做出重要技术决策时
   - 技术选型决策
   - 架构设计决策
   - ADR记录
   - 使用标准条目模板（包含id, status, confidence, source, last_updated, review_after）
   
   🔹 **KNOWN_FAILURES.md** - 当发现重复失败模式时
   - 系统性问题
   - 环境陷阱
   - 流程坑点
   - 使用标准条目模板
   
   🔹 **VERIFICATION_BASELINE.md** - 当确认新的验证规则时
   - 新的验证命令
   - 验证标准变更
   - 盲点记录
   - 使用标准条目模板
   
   🔹 **TEAM_PREFERENCES.md** - 当团队约定变化时
   - 协作偏好变更
   - 沟通边界调整
   - 工作约定更新
   - 使用标准条目模板
   
   🔹 **USER_PROFILE.md** - 当用户偏好变化时
   - 沟通风格偏好
   - 工具使用偏好
   - 输出习惯调整
   - 使用标准条目模板
   
   🔹 **AGENT_NOTES.md** - 当AI执行提醒变化时
   - 仓库特定处理提醒
   - 重复操作陷阱
   - 质量提醒
   - 使用标准条目模板
   
   🔹 **LEARNING_BACKLOG.md** - 当发现可复用经验时
   - checklist模式
   - 兼容性经验
   - 实现套路
   - 使用候选格式（包含candidate_id, type, status, evidence_count, repeated_times等）
   - 评估是否达到晋升条件（evidence_count >= 2, repeated_times >= 2）

3. **添加必需的元数据**

   对于所有持久化条目（DECISIONS, KNOWN_FAILURES, VERIFICATION_BASELINE, TEAM_PREFERENCES, USER_PROFILE, AGENT_NOTES），必须包含：
   - `id`: 唯一标识符（格式：type-YYYY-MM-DD-slug）
   - `status`: active / superseded
   - `confidence`: verified / inferred
   - `source`: 指向真实证据（代码、文档、测试、会话笔记）
   - `last_updated`: YYYY-MM-DD
   - `review_after`: YYYY-MM-DD
   
   ⚠️ **禁止**：如果 `source` 为空，不得标记为 `confidence: verified`

4. **检查 LEARNING_BACKLOG 晋升候选**

   如果有条目满足以下条件，建议晋升：
   - `evidence_count >= 2`
   - `repeated_times >= 2`
   - 有明确的 `source`
   - 有 `review_after`
   - 有链接的支持条目
   
   晋升目标可以是：
   - checklist
   - 项目规则
   - workflow step
   - script
   - skill draft

5. **内置验证逻辑**（如果记忆文件被更新）

   执行以下检查并输出结果：

   **完整性检查**:
   - [ ] PROJECT_CONTEXT.md 是否存在且有内容？
   - [ ] CURRENT_STATE.md 是否包含最后更新日期？
   - [ ] DECISIONS.md 是否存在（可选）？
   - [ ] KNOWN_FAILURES.md 是否存在（可选）？
   - [ ] journals/ 目录是否存在？

   **格式检查**:
   - [ ] DECISIONS.md 条目是否包含 id, status, confidence, source, last_updated, review_after？
   - [ ] KNOWN_FAILURES.md 条目是否包含完整元数据？
   - [ ] VERIFICATION_BASELINE.md 条目是否包含完整元数据？
   - [ ] TEAM_PREFERENCES.md 条目是否包含完整元数据？
   - [ ] USER_PROFILE.md 条目是否包含完整元数据？
   - [ ] AGENT_NOTES.md 条目是否包含完整元数据？

   ** freshness 检查**:
   - [ ] CURRENT_STATE.md 的最后更新日期是否在今天或昨天？
   - [ ] journals/ 中是否有今天的日志文件？

   **LEARNING_BACKLOG 晋升检查**:
   - [ ] 扫描 LEARNING_BACKLOG.md 中 status=ready_for_promotion 的条目
   - [ ] 检查是否满足：evidence_count >= 2 AND repeated_times >= 2
   - [ ] 列出可晋升的候选及其建议目标（checklist/rule/workflow/script/skill）

   **输出验证报告**:
   ```markdown
   📋 记忆验证报告
   
   完整性: ✅ 所有必需文件存在 / ⚠️ 缺少 X 个文件
   格式: ✅ 所有条目格式正确 / ⚠️ Y 个条目缺少元数据
   Freshness: ✅ CURRENT_STATE 最新 / ⚠️ 已过期 Z 天
   Journals: ✅ 今日日志已创建 / ⚠️ 缺失今日日志
   Backlog: ✅ N 个候选待审查 / ℹ️ 无待晋升候选
   
   需要修复的问题:
   - <如有>
   ```

6. **输出总结**

```markdown
✅ 记忆学习工作流完成

已更新的文件:
- CURRENT_STATE.md: 更新了当前状态
- journals/YYYY-MM-DD-<req-id>.md: 创建了会话日志
- DECISIONS.md: 追加了 X 个新决策（如有）
- KNOWN_FAILURES.md: 追加了 Y 个新失败模式（如有）
- VERIFICATION_BASELINE.md: 追加了 Z 个新验证规则（如有）
- TEAM_PREFERENCES.md: 更新了团队偏好（如有）
- USER_PROFILE.md: 更新了用户偏好（如有）
- AGENT_NOTES.md: 更新了AI笔记（如有）
- LEARNING_BACKLOG.md: 追加了 N 个学习候选（如有）

验证结果:
- ✅ 所有必需文件存在
- ✅ 条目格式正确
- ⚠️ 发现 M 个过期条目需要审查
- memory-index.yaml 已刷新

💡 下次会话时，AI会自动读取这些记忆，无需重复沟通。
```

---

#### 场景C: 验证记忆质量

**用户**: "验证记忆质量"

**AI执行**:

```markdown
🔍 验证记忆质量

检查项:

1. **完整性检查**
   - [x] PROJECT_CONTEXT.md 是否有内容?
   - [x] CURRENT_STATE.md 是否最新?
   - [x] DECISIONS.md 是否有记录?
   - [x] KNOWN_FAILURES.md 是否有内容?

2. **一致性检查**
   - [x] CURRENT_STATE.md 的日期是否合理?
   - [x] DECISIONS.md 的格式是否统一?
   - [x] KNOWN_FAILURES.md 是否有解决方案?

3. **实用性检查**
   - [x] PROJECT_CONTEXT.md 是否包含足够的技术背景?
   - [x] CURRENT_STATE.md 是否能帮助恢复工作?
   - [x] KNOWN_FAILURES.md 是否能避免重复踩坑?

---

✅ 验证结果:

**评分**: <X>/10

**优点**:
- <优点1>
- <优点2>

**改进建议**:
- <建议1>
- <建议2>

需要我帮你优化记忆吗? [Y/n]
```

---

#### 场景D: 清理过期记忆

**用户**: "清理过期记忆"

**AI执行**:

```markdown
🗑️ 清理过期记忆

分析记忆文件...

**PROJECT_CONTEXT.md**:
- 状态: ✅ 稳定，无需清理

**CURRENT_STATE.md**:
- 状态: ⚠️ 有过时的任务状态
- 建议: 更新为当前实际状态

**DECISIONS.md**:
- 状态: ✅ 所有决策仍然有效

**KNOWN_FAILURES.md**:
- 状态: ✅ 所有失败模式仍然相关

**session-journal/**:
- 状态: ⚠️ 有15个旧会话日志
- 建议: 保留最近10个，归档更早的

---

建议操作:
1. 更新 CURRENT_STATE.md
2. 归档旧的 session-journal (保留最近10个)

执行清理? [Y/n]
```

---

### Step 3: 输出总结

```markdown
✅ 记忆管理完成

当前状态:
- 记忆文件: <数量>个
- 会话日志: <数量>条
- 最后更新: <日期>

下次会话时，AI会自动读取这些记忆。

💡 提示:
- 每完成一个重要功能后，说 "运行学习工作流"
- 定期(每月)说 "验证记忆质量" 确保记忆有效性
- 项目重大变更时，手动更新 PROJECT_CONTEXT.md
```

---

## 测试用例

### 测试1: 初始化空项目
**输入**: "初始化记忆系统"
**预期结果**:
- 创建 `.devflow-kit/memory/` 目录
- 创建 11 个模板文件
- 创建 `journals/` 子目录
- PROJECT_CONTEXT.md 自动填充项目基本信息

### 测试2: 完整会话收尾
**输入**: "运行学习工作流"（假设已完成需求 req-001，修改了8个文件，做出了1个技术决策）
**预期结果**:
- CURRENT_STATE.md 更新，包含 req-001 信息
- journals/YYYY-MM-DD-req-001.md 已创建
- DECISIONS.md 追加1个新决策（含完整元数据）
- 输出验证报告，显示完整性✅、格式✅、Freshness✅

### 测试3: 验证记忆质量
**输入**: "验证记忆质量"
**预期结果**:
- 检查所有必需文件存在性
- 检查条目元数据完整性
- 检查 CURRENT_STATE.md 新鲜度
- 输出评分和改进建议

### 测试4: 清理过期记忆
**输入**: "清理过期记忆"
**预期结果**:
- 分析各文件状态
- 识别过时的 CURRENT_STATE 条目
- 建议归档旧的 journals（保留最近10个）
- 等待用户确认后执行

---

## 记忆文件详解

### PROJECT_CONTEXT.md (项目背景)
**用途**: 存储稳定的项目事实，很少变化  
**更新频率**: 每月或重大变更时  
**内容**: 技术栈、架构、编码规范、禁动清单

### CURRENT_STATE.md (当前状态)
**用途**: 跟踪当前工作状态，动态变化  
**更新频率**: 每次会话结束时  
**内容**: 当前焦点、最近完成、待解决问题、下一步

### DECISIONS.md (技术决策)
**用途**: 记录重要技术决策(ADR风格)  
**更新频率**: 做出重要决策时  
**内容**: 决策背景、选项、最终选择、理由、影响

### KNOWN_FAILURES.md (已知失败模式)
**用途**: 避免重复踩坑  
**更新频率**: 发现失败模式时  
**内容**: 现象、根因、解决方案、预防措施

### VERIFICATION_BASELINE.md (验证基线)
**用途**: 记录验证标准和基线  
**更新频率**: 建立新验证标准时  
**内容**: 性能指标、测试覆盖率、安全要求

### TEAM_PREFERENCES.md (团队偏好)
**用途**: 团队偏好和约定  
**更新频率**: 团队达成共识时  
**内容**: UI偏好、命名约定、工作流程

### USER_PROFILE.md (用户画像)
**用途**: 用户个人偏好  
**更新频率**: 用户提供反馈时  
**内容**: 沟通风格、工具偏好、学习进度

### AGENT_NOTES.md (AI助手笔记)
**用途**: AI助手的观察和建议  
**更新频率**: AI发现模式时  
**内容**: 代码模式、潜在问题、优化建议

### session-journal/
**用途**: 每次会话的详细记录  
**更新频率**: 每次会话结束时  
**内容**: 工作内容、决策、问题、经验、下一步

---

## 最佳实践

### 何时更新记忆?

✅ **应该更新**:
- 完成了重要功能(登录、支付、搜索)
- 改变了技术选型(换数据库、换UI框架)
- 发现了系统性问题(性能瓶颈、安全漏洞)
- 做出了架构决策(微服务拆分、缓存策略)
- 学到了新的最佳实践

❌ **不应更新**:
- 修复typo或小bug
- 临时实验性代码
- 未经验证的假设
- 会话中间状态

### 记忆 vs 产物

| 维度 | 记忆 (.devflow-kit/memory/) | 产物 (.devflow-kit/<req-id>/) |
|---|---------------------------|---|
| **作用域** | 整个项目生命周期 | 单个需求/功能 |
| **持久性** | 长期保留,跨会话有效 | 需求完成后归档 |
| **更新频率** | 低频(重要变化时) | 高频(每个阶段) |
| **内容类型** | 事实、决策、教训 | 需求、设计、代码 |
| **读者** | 所有后续会话的AI | 当前需求的开发者 |

### 维护建议

1. **每次会话结束**: 运行 "Use superpowers-learning workflow"
2. **每周**: 检查 CURRENT_STATE.md 是否准确
3. **每月**: 运行 "验证记忆质量"
4. **每季度**: 清理过期的 session-journal
5. **项目重大变更**: 更新 PROJECT_CONTEXT.md

---

## 常见问题

### Q1: 记忆系统会影响性能吗?

**A**: 不会。记忆文件很小(<1MB)，AI只在会话开始时读取必要的文件。

### Q2: 记忆太多会混乱吗?

**A**: 不会。每个文件有明确的职责，AI会根据需要读取相关文件。

### Q3: 可以不使用记忆系统吗?

**A**: 可以。记忆系统是可选的，但强烈建议使用，它能显著提升AI的理解能力。

### Q4: 记忆会被共享到其他项目吗?

**A**: 不会。记忆存储在项目的 `.devflow-kit/memory/` 目录中，只在当前项目内有效。

### Q5: 如何备份记忆?

**A**: 直接复制 `.devflow-kit/memory/` 目录即可。建议纳入Git版本控制(但不包括journals/)。

---

## 与其他Skill的关系

- **stage-7-integration**: 集成阶段会触发记忆更新
- **brainstorming**: 设计澄清时会参考 PROJECT_CONTEXT.md
- **systematic-debugging**: 调试时会查询 KNOWN_FAILURES.md

---

**记忆系统是DevFlow Kit的核心价值之一，它让AI真正"记住"你的项目！** 🧠✨
