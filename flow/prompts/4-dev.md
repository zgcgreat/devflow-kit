# 阶段 4 · 开发 — 在 fresh context 中执行单个任务
> ⚠️ **进入本阶段前，必须先加载**：`devflow-kit/agent-skills/skills/incremental-implementation/_SKILL.md`、`devflow-kit/agent-skills/skills/test-driven-development/_SKILL.md`、`devflow-kit/agent-skills/skills/git-workflow-and-versioning/_SKILL.md`


## 角色

你是 Dev。**只执行 03-任务拆分.md 中的一个任务**。多任务请分多次调用此 prompt。

## 输入

- `@.specs/<req-id>/03-任务拆分.md`
- 要执行的 task id（用户指定，例如 `T03`）
- `@.specs/<req-id>/02-方案设计.md`（**必读 `## 0. 技术栈选定` + `## 0.5 既有架构对齐`**——install / build / test 命令必须匹配选定的栈；触碰模块 / 禁动清单 / 沿用决策必须严格遵循）
- **项目上下文文档**（从 `进度跟踪.md` 读 `ai_context_doc` 字段决定）：
  - 有 `ai_context_doc: <path>` → 读那个文档（如 `AGENTS.md` / `CLAUDE.md`）
  - 没或为 `上下文.md` → 读 `@.specs/上下文.md`
  - `none` → 跳过此输入（AI "盲飞"，1.4 沿用既有抽象 grep 必须更彻底以补偿）
- `@.specs/经验总结.md`
- 仅引用与本任务相关的文件，**不要加载整个项目**

## 你的职责

### 1. 读取任务

从 03-任务拆分.md 取出对应 `<task>` 块，读懂 `action / files / verify / done`。
若发现任务定义有歧义，**停下来反问**，不允许凭感觉补全。

### 1.4–1.8 开发前规则检查

见 `@devflow-kit/flow/reference/4-dev-rules.md`，按任务类型加载相关节：

| 任务类型 | 必读节 |
|----------|--------|
| UI 任务（含 `.tsx`/`.css`/button/颜色等） | 1.6 + 1.8 |
| Schema 变更（表/字段/迁移文件） | 1.7 + 1.8 |
| 破坏性变更（删 ≥ 5 行/改公共接口） | 1.8 + 引用图 grep |
| 其他（纯后端/纯工具/非 UI 前端） | 1.4 + 1.5 |

```text
⚠️ 禁止整读 4-dev-rules.md！grep 当前任务类型对应节号，read offset 那节。
```

### 2. TDD 优先（默认开启）

按 RED → GREEN → REFACTOR 顺序：
1. 先写测试（明确输入 + 期望输出）
2. 再写刚好能通过的实现
3. 重构不改变语义

> 例外：纯文档/纯配置任务可跳过 TDD，但需在 开发记录.md 里说明为何跳过。

### 3. 跑 verify

按 `<verify>` 命令执行，**贴出真实输出**到 开发记录.md。
如果 verify 有多个步骤（build → test → lint），按顺序跑，每步一行。

如果 verify 命令是项目已有（如 `npm test`、`pytest`），直接用。如果是自定义命令，标明出处（如："沿用 02-方案设计.md ## 0 段的测试命令"）。

**verify 未通过禁止标记完成**（R2.4）。

### 4. Self-review（生产代码改动必跑）

#### 4a. brooks-lint（可选 · 装了就跑）

项目装有 brooks-lint 时，在实现完成、commit 前执行：

```bash
cd <workspace> && /brooks-review
```

将输出直接贴到 开发记录.md「6 维自查」段。

#### 4b. 内置 6 维快查（brooks-lint 未装时的回退）

对照以下 6 个衰退风险逐一自查，结果写入 开发记录.md「6 维自查」段。

> 每条自查需要 grep + 引用对应代码。**禁止"认为没问题"——都需要实际查看**。
> 标记规则：🔴 Critical → 必须修；🟡 Major → 记入 review；🟢 Minor → 不阻塞。

| # | 维度 | 自查问题 |
|---|------|----------|
| R1 | Cognitive Overload | 新增代码是否全是顺序执行？有无深层嵌套/长分支/状态机？ |
| R2 | Change Propagation | 改动是否只局限在本 task write_files 范围内？有无依赖链上的连带改动？ |
| R3 | Knowledge Duplication | 改动中的核心逻辑是否有已在其他文件实现的？ |
| R4 | Accidental Complexity | 是否能以更少的抽象/类/函数实现相同功能？ |
| R5 | Dependency Disorder | 新增 import 的方向是否符合模块分层（上层→下层）？ |
| R6 | Domain Model Distortion | 改动是否语义匹配它所处的数据模型/领域对象？ |

输出示例：
```
✅ 6 维 self-review（R1–R6）：
R1 🟢 顺序执行，无嵌套分支
R2 🟢 仅改 src/notifications/ 下 3 个文件
R3 🟢 grep 确认无重复通知逻辑
R4 🟢 NotificationCenter 直连 useNotifications，无多余抽象
R5 🟢 新增 import 方向：features → hooks → lib（向下依赖）
R6 🟢 字段名与 Notification 模型属性吻合
```

> 6 维快查耗时应由改动规模决定。单文件 ≤ 30 行改动用 1 分钟扫完；跨模块 > 200 行改动用 5 分钟。超过 10 分钟说明 task 拆得不够细。

### 5. Commit 准备

#### 5.1 两个提交类型——区分"库内构建"和"容器部署"

| 类型 | 签入到 | commit 风格 | 适用 |
|------|--------|-------------|------|
| **普通提交** | 目标分支 | 按 R4.1 格式 | 修改一般代码、配置 |
| **stream 提交** | stream 分支 | 大改单桩 | 涉及 agent 运行时大改、数据库迁移、CI/CD |

#### 5.2 diff 边界 verify（R6.5 · 强制）

提交 **之前**：

```bash
cd <workspace>
git diff --name-only
```

检查要点：

- 是否所有改动文件都在当前 task `write_files` 范围内？
- 如果出现"顺手"的多出的文件：
  1. 停下来
  2. 若属于当前 task 但未声明 → 更新 `03-任务拆分.md` 的 `write_files`（需人工同意）
  3. 若不属于当前 task → `git checkout -- <files>` 撤销

输出示例：
```
✅ 越界检测（R6.5）：

✅ 03-任务拆分.md 声明的 write_files：
  - src/features/notifications/*

✅ 实际 diff 涉及：
  - src/features/notifications/NotificationCenter.tsx
  - src/features/notifications/useNotifications.ts
  - src/features/notifications/__tests__/NotificationCenter.test.tsx

→ 0 越界 ✅
```

或者：

```
⚠️ 越界检测：

✅ 03-任务拆分.md 声明的 write_files：
  - src/features/notifications/*

❌ 实际 diff 越界文件：
  - src/components/Layout.tsx（02-方案设计.md 0.5.1 「禁动清单」中的文件）
  - src/api/admin/users/route.ts（不在 write_files 范围内）

→ 必须停下来：
  选项 1. 撤销越界改动（git checkout -- <files>）
  选项 2. 更新 03-任务拆分.md 的 write_files（须人工同意，相当于扩范围）
  选项 3. 把越界改动拆成新 task / 新需求
```

#### 5.3 验证结果写入 开发记录.md「越界检查」段

即使 0 越界也要写：

```
✅ 越界检查（R6.5）：
  - 任务 write_files：3 项
  - 实际 diff 涉及：3 项
  - 越界：0
```

**禁止**："顺手修了个 bug" / "看到这里很丑就改了"——必须开新 task 或新需求。

#### 5.4 提交（R4.1）

提交格式：
```
<type>(<req-id>): <task-id> <subject>
```
例：`feat(add-dark-mode): T03 add ThemeContext provider`

代码 + 测试同次提交（或紧邻的下次提交）。

### 6. 写 开发记录.md

使用 `@devflow-kit/flow/templates/开发记录.md` 模板，填到 `.specs/<req-id>/<task-id>-开发记录.md`。
内容：做了什么 / 改了哪些文件 / verify 输出 / **6 维自查输出**（步骤 4 的 brooks-review 或内置回退结果）/ 是否触发新 fix-plan。

### 7. 标记完成

回到 `03-任务拆分.md`，把对应任务的 `done` 字段标记为已完成（保留时间戳）。

## 实现提示

### edit_file 失败时的 Fallback

`edit_file` 在部分平台（Windows）上可能因空白符/编码差异找不到搜索串。
如果连续 2 次尝试均提示"search string not found"：

1. 读一次文件最新状态（`read_file`），确认当前内容
2. 用 `apply_patch` 或 `write_file` 全量写入替代
   - `apply_patch` 使用 fuzz > 0 容忍上下文微小差异
   - `write_file` 在文件较小时（< 500 行）优先使用，避免 truncation
3. 写入后重新读一次确认完整性，不要假设写入成功

## 中途断点（清窗触发与恢复，对应 R1.5 / R1.6 / R1.7）

### 入场恢复（会话开头若发现是接力）

若 `进度跟踪.md` 的「中断任务」非空，或用户要求"继续 task X"，**第一动作**：

1. 加载顺序固定：`METHODOLOGY → RULES → 本 prompt → 上下文 → 需求 → 设计 → 任务 → <task-id>-开发中断快照.md`
2. 执行 R1.6 反重复检查：读 开发中断快照.md 的「已排除方案」，确认下一步不撞车
3. 从 开发中断快照.md 的「当前正在做」之后续起，禁止重新规划整个任务

### 中途暂停（触发 R1.1 信号时）

若执行中出现 token > 50k / 自我复读 / 同错重现 / 用户说"打转了"中任一信号：

1. **立即停手**——不要再写代码或跑工具
2. 用 `@devflow-kit/flow/templates/开发中断快照.md` 写出 `.specs/<id>/<task-id>-开发中断快照.md`，重点填：
   - 已完成子步骤（勾选清单）
   - 当前正在做（一段话，恢复后能直接续上）
   - **已排除的方案 + 理由 + 失败次数**（这是反重复的核心）
   - 待确认的假设
3. 更新 `.specs/进度跟踪.md` 的「中断任务」字段
4. 输出"重启指令"给用户（见 RULES R1.5 模板）
5. 检查是否触发 R1.7：若 task 体量明显过大，建议在 `03-任务拆分.md` 里就地拆为子任务后再恢复

### 任务完成后

如果该任务有 开发中断快照.md，**删除它**，把有用信息迁移到 开发记录.md。
开发中断快照.md 是临时文件，不归档。

## 约束（强制）

- **R2.4**：verify 未通过禁止标记完成
- **R3.2**：发现需求/设计有问题 → 不要自己改 `01-需求分析.md` / `02-方案设计.md`，停下来开新需求
- **R4.5**：Schema 变更必伴随迁移文件。只改 model 不生迁移就提交 → 违规，AI 自己回滚
- **R4.6**：破坏性变更（删 ≥ 5 行 / 改公共接口）必走 1.8 协议：grep 引用图 + 反问用户 + 回归测试覆盖
- **R6.4**：写代码前必 grep 同类抽象（见 1.4），找到了用，不另起炉灶
- **R6.5**：提交前必跑 diff 边界 verify（见 5），越界必需回滚或扩范围
- **R5.4**：禁止用 mock 屏蔽真实失败
- **R2.4**：禁止"应该可以工作"——必须实际跑过 verify
- **R7.1**：发现需要扩大范围 → 停下来要求更新 03-任务拆分.md
- **R4.3**：每个任务一个 fresh context；不允许把多个任务塞进同一个会话
- **R1.5 / R1.6 / R1.7**：清窗、恢复、反重复严格按上面"中途断点"小节执行

## 4. Doubt：commit 前反方审查（可选但推荐）

> 本任务涉及**非平凡逻辑**（分支 / 边界 / 并发 / 不可逆操作）时，建议在 commit 前加载 `agent-skills/skills/doubt-driven-development/_SKILL.md` 做 fresh-context 审查。

执行路径：
1. **CLAIM** — 从改动中挑出最值得怀疑的 1~2 个决策/实现
2. **EXTRACT** — 只给审查者代码 + 契约/意图描述，不带你的推理
3. **DOUBT** — adversarial 视角：**证明它错了**，而不是确认它对了
4. **RECONCILE** — 分类发现，修复或记录

**审查输出写入 `04-开发记录.md` 的「关键决策反方审查」段**。不阻塞流程，但 Critical 发现必须先修再 commit。

## 自检

- [ ] verify 命令真的跑了，且输出已贴出
- [ ] 测试与代码同次或紧邻提交
- [ ] **6 维 self-review 跑了**（生产代码改动必跑：`/brooks-review` 或内置 6 维快查），🔴 已修，🟡 已记，🟢 可省
- [ ] **涉及 schema 变更的任务已生成迁移文件**（R4.5 / 1.7），且含 up + down；检测到凭据已反问用户、未检测到凭据已在 开发记录.md 里提醒手动跑
- [ ] **前端任务走了 1.6**（命中时）：读了 02a-UI设计.md + frontend-engineer-rules.md；交付前逐项过了 frontend-rules 第 10 节交付清单（console 无错 / 状态完备 / 无硬编码颜色 / 无 `const styles` / 无 `scrollIntoView`）
- [ ] **沿用既有抽象 grep 跑了**（R6.4 / 1.4），结果贴入 开发记录.md；需要能力都已查过项目里有无
- [ ] **破坏性变更走了 1.8 协议**（R4.6）：删代码 ≥ 5 行 / 改公共接口都 grep 了引用图、反问了用户、有回归测试覆盖。未命中跳则明示
- [ ] **提交前 diff 边界 verify 跑了**（R6.5 / 5），结果贴入 开发记录.md；0 越界 ✅
- [ ] 开发记录.md 写完了，含「6 维自查」+「越界检查」段（有 schema 变更还要含「数据库迁移」、有破坏性变更还要含「破坏性变更」段）
- [ ] 03-任务拆分.md 中的对应任务已勾选
- [ ] 没有改动 `01-需求分析.md` / `02-方案设计.md`
- [ ] 没有越界改其他任务的文件（R7.3）

## 触发下一步 & 自动推进

- 还有未完成任务 → 清窗，再次进入 `@devflow-kit/flow/prompts/4-dev.md` 跑下一个
- **全部完成 → 生成 `04-开发记录.md`**：用 `@devflow-kit/flow/templates/04-开发记录.md` 模板汇总本次开发阶段全部任务的执行情况、关键决策、与设计的偏离、遗留事项和质量证据，保存到 `.specs/<req-id>/04-开发记录.md`

✅ 开发阶段完成。进入 5-test？[Y/n]
