# devflow-kit Stage: 3-Task（任务拆分）

> **阶段定位**：将设计拆分为可并行的原子任务
> **前置条件**：02-方案设计.md 已完成
> **后置产物**：`.specs/<req-id>/03-任务拆分.md`

## Skill元信息

```yaml
name: stage-3-task
version: 1.0.0
description: devflow-kit工作流第3阶段 - 任务拆分与并行规划
author: devflow-kit
dependencies:
  - planning-and-context
```

## 输入

- `.specs/<req-id>/01-需求分析.md`
- `.specs/<req-id>/02-方案设计.md`（必读 `## 0. 技术栈选定` + `## 0.5.1 触碰模块`）
- `.specs/上下文.md`

## 输出

- `.specs/<req-id>/03-任务拆分.md`
- 更新 `.specs/项目状态.md`

## 入口门禁

**必须检查以下产物，缺任何一项都停止**：

```markdown
IF 缺 01-需求分析.md:
  输出: "规则 R2.7 触发：3-task 缺少 01-需求分析.md。本次先回到 1-analysis 补齐。"
  STOP

IF 缺 02-方案设计.md:
  输出: "规则 R2.7 触发：3-task 缺少 02-方案设计.md。本次先回到 2-design 补齐。"
  STOP

IF 前端项目 AND 缺 02a-UI设计.md:
  输出: "规则 R2.7 触发：3-task 缺少 02a-UI设计.md。本次先回到 2a-ui-design 补齐。"
  STOP
```

## 执行流程

### Step 1: 读取设计文档

重点读取：
- `## 0. 技术栈选定` - 决定任务的verify命令格式
- `## 0.5.1 触碰模块` - 决定任务的write_files范围
  - 新增模块 → 加入write_files
  - 已有·复用 → 加入read_files
  - 禁动清单 → **严禁**加入任何任务的write_files

### Step 2: 拆解原则

按以下原则拆分任务：

1. **大小**：一个任务在 fresh context 下 2~10 分钟可完成
2. **粒度**：按文件冲突切，不按层切。优先「垂直切片」而非「水平层」
3. **并行标记 [P]**：只有 write_files 无交集、依赖无冲突时才标 [P]
4. **依赖**：每个任务显式声明 `depends_on: <task-id>`

### Step 3: 生成任务XML

每个任务必须包含7个字段：

```xml
<task id="T01" parallel="true">
  <name>一句话描述</name>
  <read_files>
    src/xxx/*
    src/utils/yyy.ts
  </read_files>
  <write_files>
    src/features/zzz.ts
    src/features/__tests__/zzz.test.ts
  </write_files>
  <action>要做什么（不写代码，写意图）</action>
  <verify>npm test -- zzz.test.ts</verify>
  <done>完成判定（对应AC的某个子项）</done>
  <depends_on></depends_on>
</task>
```

**关键约束**：
- `read_files` = write_files 超集 + 需要import的既有模块
- `write_files` 严格在"触碰模块+新增模块"范围内
- **禁止**任何任务的write_files包含禁动清单文件
- `verify` 必须是可执行命令

### Step 4: 规划执行顺序

按依赖关系分层：

```markdown
第一批（可并行）: T01[P], T02[P]
第二批（可并行）: T03[P], T04[P]（依赖 T01）
第三批:           T05（依赖 T03, T04）
```

### Step 5: 生成产物

**⚠️ 强制规则**：输出前必须先读取模板文件 `flow/templates/03-任务拆分.md`。

按模板生成 `.specs/<req-id>/03-任务拆分.md`，包含：
- **必须包含模板所有段落**（不得省略或改写）
- **所有 `<...>` 占位符必须替换为实际值**
- 所有任务的XML块
- 执行顺序说明
- 任务统计（总数、可并行数）

**自检**：输出前逐项核对模板强制规则（R13.9 / R13.10）

### Step 6: 更新项目状态

```markdown
当前阶段: task
阶段状态: completed
上次完成阶段: task
下一阶段: dev（或 3a-plan）
```

### Step 7: 询问是否生成实施计划

**Standard/Strict 模式**：
```markdown
是否生成详细实施计划（03a-实施计划.md）？
- 是 → 路由到 3a-plan stage
- 否 → 直接进入 4-dev stage
```

**Fast 模式**：直接进入 4-dev

## 约束

- **R2.3**：每个任务必须有可执行的verify，否则不允许进入DEV
- 任务粒度太大必须再拆
- 不允许「重构X模块」这种没有边界的任务
- 禁止Planner自己脑补技术栈、触碰模块、禁动清单

## 自检清单

- [ ] **已读取模板文件** `flow/templates/03-任务拆分.md`
- [ ] 已读取02-方案设计的技术栈和既有架构对齐
- [ ] 任务数合理（Fast: 1-3个, Standard: 3-8个, Strict: 8+个）
- [ ] 每个任务有完整的7字段（id/name/read_files/write_files/action/verify/done）
- [ ] write_files不重叠或重叠部分明确说明
- [ ] verify命令可执行且有意义
- [ ] 任务间依赖关系清晰
- [ ] 并行任务已标注
- [ ] **产物包含模板所有段落**
- [ ] **所有占位符已替换**
- [ ] 03-任务拆分.md已生成
- [ ] 项目状态.md已更新

## 触发下一步

**输出任务列表后，必须等待用户确认**：

```markdown
任务拆分完成，共X个任务。

请确认或选择：
1. ✅ 开始执行（进入4-dev）
2. 📋 生成实施计划（进入3a-plan）
3. ✏️ 修改任务（说明需要调整的部分）
```

- Fast模式 / 用户确认直接进入 → 加载 `flow/stage-skills/stage-4-dev/_SKILL.md`
- 用户要求生成实施计划 → 加载 `flow/stage-skills/stage-3a-plan/_SKILL.md`

## 错误处理

- 任务定义有歧义 → 反问用户澄清
- write_files超出范围 → 重新调整任务边界
- verify命令不可执行 → 修正为正确命令
