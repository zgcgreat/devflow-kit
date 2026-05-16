---
description: Conduct a five-axis code review — correctness, readability, architecture, security, performance
---

# /review — 五轴代码审查

## 快速模式

用户可指定审查范围：
- `/review` — 完整五轴审查（默认）
- `/review quick` — 快速模式（仅 Correctness + Security）
- `/review security` — 安全专项
- `/review perf` — 性能专项

## 分步加载策略

**⚠️ 不再一次性加载所有 skill，改为按需加载**：

```
┌─────────────────────────────────────────────────────────────┐
│  📦 加载策略                                                  │
├─────────────────────────────────────────────────────────────┤
│  必须加载（始终）：                                           │
│  └─ code-review-and-quality/_SKILL.md (347 行)              │
│                                                              │
│  按需加载（触发时）：                                         │
│  ├─ security-and-hardening/_SKILL.md (349 行)               │
│  │  └─ 触发：diff 含 auth/login/password/token/session      │
│  └─ performance-optimization/_SKILL.md (350 行)             │
│     └─ 触发：diff 含 query/loop/cache/async/render          │
├─────────────────────────────────────────────────────────────┤
│  默认加载：347 行                                             │
│  最大加载：1046 行（全触发时）                                │
└─────────────────────────────────────────────────────────────┘
```

## 执行流程

```
┌─────────────────────────────────────────────────────────────┐
│  🔍 /review — 五轴代码审查                                    │
├─────────────────────────────────────────────────────────────┤
│  ▶ Correctness  [●●●●●] ✅ 无问题                            │
│  ▶ Readability  [●●●●○] ⚠️ 2 Minor                           │
│  ▶ Architecture [●●●●●] ✅ 无问题                            │
│  ▶ Security     [●●○○○] 🔴 1 Critical                        │
│    └─ 按需加载: security-and-hardening ✅                    │
│  ▶ Performance  [●●●●●] ✅ 无问题                            │
├─────────────────────────────────────────────────────────────┤
│  📊 审查摘要                                                  │
│    ├─ 🔴 Critical: 1 → 需修复                                │
│    ├─ 🟡 Major: 0                                            │
│    └─ 🟢 Minor: 2 → 可选改进                                 │
└─────────────────────────────────────────────────────────────┘
```

## 前置加载（自动）

AI 自动加载核心文件，并在输出开头声明：

```
✅ 已加载: code-review-and-quality (347 行)
⏳ 按需待加载: security-and-hardening, performance-optimization
```

## 输出格式

每条发现按以下格式输出：

```
### 🔴 Critical · Security · SQL Injection
**位置**：`src/api/users.ts:42`
**问题**：用户输入直接拼接到 SQL 查询
**修复**：使用参数化查询
```typescript
// Before
const query = `SELECT * FROM users WHERE id = '${userId}'`;
// After
const query = 'SELECT * FROM users WHERE id = $1';
```
```

## Critical 问题处理（选择题模式）

**💡 设计原则：给选项让用户选，而不是让用户想**

```
┌─────────────────────────────────────────────────────────────┐
│  🔴 发现 2 个 Critical 问题                                   │
├─────────────────────────────────────────────────────────────┤
│  1. [Security] SQL 注入风险 — src/api/users.ts:42            │
│  2. [Correctness] 边界条件未处理 — src/utils/format.ts:15    │
├─────────────────────────────────────────────────────────────┤
│  请选择：                                                     │
│  [1] 修复全部（推荐）                                         │
│  [2] 选择性修复                                               │
│  [3] 查看详情后再决定                                         │
│  [4] 其他...                                                  │
└─────────────────────────────────────────────────────────────┘
```

**快速操作**：回车 = [1]，输入数字 = 对应选项，输入文字 = 自定义

## 严重度

- 🔴 **Critical**：必须修复（安全漏洞、数据损坏、功能缺失）
- 🟡 **Major**：建议修复（设计问题、性能回归）
- 🟢 **Minor**：可选改进（命名、风格）
