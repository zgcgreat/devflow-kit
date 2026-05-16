# devflow-kit Stage: 4-Dev（开发执行）

> **阶段定位**：在fresh context中执行单个任务
> **前置条件**：03-任务拆分.md 已完成，用户指定task id
> **后置产物**：代码实现 + `*-开发记录.md`

## Skill元信息

```yaml
name: stage-4-dev
version: 1.0.0
description: devflow-kit工作流第4阶段 - 按任务执行开发
author: devflow-kit
dependencies:
  - development-core
  - testing-suite
```

## 输入

- `.specs/<req-id>/03-任务拆分.md`
- 要执行的 task id（用户指定，如 T03）
- `.specs/<req-id>/02-方案设计.md`（必读 `## 0. 技术栈选定` + `## 0.5 既有架构对齐`）
- `.specs/上下文.md`
- `.specs/经验总结.md`

## 输出

- 代码文件（按任务的write_files）
- `.specs/<req-id>/<task-id>-开发记录.md`

## 入口门禁

**必须满足以下条件之一**：

1. **正式流程**：存在 `.specs/<req-id>/03-任务拆分.md`，且包含指定的task
2. **单点调用**：用户提供临时最小TASK（必须包含7字段：id/name/read_files/write_files/action/verify/done）

**前端项目额外检查**：
```markdown
IF task涉及UI文件 (.tsx/.css/.vue等) AND 缺 02a-UI设计.md:
  输出: "规则 R2.7 触发：4-dev 缺少 02a-UI设计.md。本次先回到 2a-ui-design 补齐。"
  STOP
```

**禁止AI自行编造临时TASK**，缺字段必须反问或回到3-task生成正式产物。

## 执行流程

### Step 1: 读取任务

从 03-任务拆分.md 取出对应 `<task>` 块，理解：
- `action` - 要做什么
- `read_files` - 允许读取的文件
- `write_files` - 允许修改的文件边界
- `verify` - 验证命令
- `done` - 完成判定

**如有歧义，停下来反问，不允许凭感觉补全**

### Step 2: 开发前规则检查

根据任务类型加载 `4-dev-rules.md` 对应节：

| 任务类型 | 必读节 |
|----------|--------|
| 所有生产代码 | 1.4（沿用既有抽象grep）+ 1.5（经验总结扫描） |
| UI任务 | + 1.6（UI反模式）+ 1.8（破坏性变更） |
| Schema变更 | + 1.7（Schema规范）+ 1.8 |
| 破坏性变更 | + 1.8 + 引用图grep |

**禁止整读4-dev-rules.md**，只grep需要的节。

### Step 3: TDD优先（默认开启）

按 RED → GREEN → REFACTOR 顺序：

1. **RED**：先写测试（明确输入+期望输出）
2. **GREEN**：写刚好能通过的实现
3. **REFACTOR**：重构不改变语义

**例外**：纯文档/纯配置任务可跳过TDD，但需在开发记录说明理由。

### Step 4: 实现代码

**严格约束**：
- **只修改** write_files 范围内的文件
- **只读取** read_files 范围内的文件
- **禁止**越权修改其他文件

**沿用既有抽象**（1.4规则）：
```bash
# grep项目中已有的类似实现
grep -r "HttpClient" src/lib/
grep -r "useState" src/hooks/
```

优先复用既有抽象，引入新库必须有充分理由。

### Step 5: 执行verify

按任务的 `<verify>` 命令执行，**贴出真实输出**到开发记录。

如果verify有多个步骤（build → test → lint），按顺序跑，每步一行。

**verify未通过禁止标记完成**（R2.4）。

### Step 6: Self-review（生产代码必跑）

#### 6a. brooks-lint（如已安装）

```bash
cd <workspace> && /brooks-review
```

将输出贴到开发记录「6维自查」段。

#### 6b. 内置6维快查（回退方案）

对照6个衰退风险逐一自查：

| # | 维度 | 自查问题 |
|---|------|----------|
| R1 | Cognitive Overload | 新增代码是否全是顺序执行？有无深层嵌套？ |
| R2 | Change Propagation | 改动是否局限在write_files范围内？ |
| R3 | Knowledge Duplication | 核心逻辑是否有已在其他文件实现的？ |
| R4 | Accidental Complexity | 能否以更少的抽象实现相同功能？ |
| R5 | Dependency Disorder | 新增import方向是否符合模块分层？ |
| R6 | Domain Model Distortion | 改动是否语义匹配数据模型？ |

**标记规则**：🔴 Critical→必须修；🟡 Major→记入review；🟢 Minor→不阻塞

**每条自查需要grep+引用代码，禁止"认为没问题"**

### Step 7: Diff边界验证（R6.5强制）

```bash
cd <workspace>
git diff --name-only
```

**检查要点**：
- 所有改动文件都在当前task write_files范围内？
- 如果出现"顺手"多出的文件：
  1. 停下来
  2. 若属于当前task但未声明 → 更新03-任务拆分.md的write_files（需人工同意）
  3. 若不属于当前task → `git checkout -- <files>` 撤销

**输出示例**：
```markdown
✅ 越界检测（R6.5）：

✅ 03-任务拆分.md 声明的 write_files：
  - src/features/notifications/*

✅ 实际 diff 涉及：
  - src/features/notifications/NotificationCenter.tsx
  - src/features/notifications/useNotifications.ts

→ 0 越界 ✅
```

### Step 8: 生成开发记录

**⚠️ 强制规则**：如存在模板文件 `flow/templates/XX-开发记录.md`，必须先读取。

创建 `.specs/<req-id>/<task-id>-开发记录.md`，必须包含以下所有章节：
- **必须包含所有6个章节**（不得省略）
- **所有占位符必须替换为实际值**
- Verify输出必须是真实执行结果

```markdown
# Task <id>: <name>

## 1. 任务定义
- read_files: ...
- write_files: ...
- action: ...
- verify: ...

## 2. 实施过程
- 步骤1: ...
- 步骤2: ...

## 3. Verify输出
```
<真实输出>
```

## 4. 6维自查
R1 🟢 ...
R2 🟢 ...
...

## 5. Diff边界验证
- 声明范围: ...
- 实际diff: ...
- 越界文件: 无 / 有（已处理）

## 6. 建议Commit Message
feat: <简短描述>

<body>
<详细说明>
```

### Step 9: 更新项目状态（可选）

如果这是最后一个任务：
```markdown
当前阶段: dev
阶段状态: completed
上次完成阶段: dev
下一阶段: test
```

## 自检清单

完成后逐项检查：

- [ ] **已读取模板文件**（如存在）
- [ ] 只修改了write_files范围内的文件
- [ ] verify命令执行通过
- [ ] 6维自查全部完成（至少🟢）
- [ ] Diff边界验证通过（0越界）
- [ ] **开发记录包含所有6个章节**
- [ ] **所有占位符已替换**
- [ ] 开发记录已生成
- [ ] 建议commit message已提供

## 约束

- **R2.4**：verify未通过禁止标记完成
- **R6.5**：越界文件必须撤销或更新任务定义
- **只执行一个任务**，多任务分多次调用此stage
- **禁止**一次性执行多个任务
- **禁止**跳过self-review

## 触发下一步

- 还有未执行的任务 → 等待用户指定下一个task id
- 所有任务完成 → 加载 `flow/stage-skills/stage-5-test/_SKILL.md`

## 错误处理

- **verify失败** → 分析原因（代码bug/测试错误/环境问题），修复后重新执行
- **任务定义有误** → 暂停，回到3-task修正任务定义
- **越界文件** → 立即撤销（git checkout），不得提交
- **6维自查发现🔴** → 必须修复后才能继续
- **依赖skill缺失** → 提示用户安装或跳过
- **缺必需输入** → 反问用户补充
