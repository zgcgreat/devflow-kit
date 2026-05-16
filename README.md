# DevFlow Kit

> **结构化 AI 开发工作流** - 为专业团队设计的工程化编程系统

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.3.0-green.svg)](CHANGELOG.md)
[![Stage Skills](https://img.shields.io/badge/stages-15-orange.svg)](flow/stage-skills/)

---

## 🚀 快速开始

### 安装（AI 自动完成，无需手动执行）

在你的 AI 编程工具（Cursor、Claude Code、Gemini CLI 等）中说：

```
Use install-devflow.
```

AI 会自动：
1. **扫描项目** - 识别技术栈、框架、目录结构
2. **提取信息** - 自动填充 `.devflow-kit/CONTEXT.md`
3. **询问模式** - 选择基础/完整/预览
4. **复制文件** - 安装所有必要组件
5. **验证完整性** - 确保一切正常
6. **引导开始** - 提供使用示例

**就这么简单！AI 自动分析你的项目，无需手动填写任何信息。**

### 使用

在 AI 编程工具中：

```
Use devflow-kit.

我要做一个用户登录功能，支持邮箱密码和 JWT 认证
```

AI 会自动：
1. 读取 `flow/GO.md` 路由器
2. 判定模式（Standard/Strict）
3. 启动需求澄清 → 设计 → TDD 开发 → 测试 → 审查流程
4. 生成所有产物到 `.devflow-kit/<req-id>/`

---

## ✨ 核心特性

### 1. 智能流程编排

- **三档模式**: Fast（小改动）/ Standard（常规功能）/ Strict（高风险）
- **风险评估矩阵**: 自动根据技术复杂度、业务影响、数据敏感性评分
- **Stage Skill 架构**: 15 个阶段技能，按需加载，依赖管理
- **前置产物全量读取**: 智能降级策略，容错性强

### 2. 模板驱动开发

- **严格模板**: 所有产物必须按模板生成（R13.9 强制规则）
- **生成后核对**: 每个 Stage 都有逐项检查清单
- **弱 AI 友好**: 明确的强制执行点（⚠️ 强制规则）
- **中文输出**: 全文统一中文，技术术语保留英文原名

### 3. 工程纪律保障

- **Brainstorming**: 苏格拉底式需求澄清，避免盲目编码
- **TDD 硬约束**: RED-GREEN-REFACTOR 循环，先写失败测试
- **Subagent 驱动**: 并行子代理执行，两阶段审查（spec 合规 + 代码质量）
- **系统化调试**: 四阶段根因追溯，防御性编程

### 4. 跨会话记忆（可选）

**自动记忆**:
- ✅ 会话开始时自动读取项目背景（`.devflow-kit/memory/`）
- ✅ 需求完成后自动更新记忆
- ✅ AI 自动记录重要决策和失败模式

**手动管理**:
```
Use manage-memory. 初始化记忆系统
Use devflow-learning workflow
```

- **持久化上下文**: `.devflow-kit/memory/` 存储项目知识
- **决策追踪**: ADR 风格记录重要技术决策
- **失败模式库**: 避免重复踩坑
- **会话日志**: 形成完整工作历史轨迹

### 5. 工具无关部署

**原生适配器**（4 套）:
- ✅ Cursor (`adapters/cursor/rules/`)
- ✅ Claude Code (`adapters/claude/commands/`)
- ✅ Gemini CLI (`adapters/gemini/commands/`)
- ✅ Windsurf (`adapters/windsurf/workflows/`)

**通用支持**（通过 AGENTS.md + flow/GO.md）:
- ✅ GitHub Copilot
- ✅ 通义灵码
- ✅ CodeWhisperer
- ✅ 任何能读取 Markdown 文件的 AI 工具

---

## 📦 产物目录结构

```
.devflow-kit/
├── STATE.md                    # 项目状态跟踪器
├── CONTEXT.md                  # 共享上下文（技术栈、规范）
├── memory/                     # 跨会话记忆
│   ├── PROJECT_CONTEXT.md      # 项目背景
│   ├── DECISIONS.md            # 历史决策
│   ├── KNOWN_FAILURES.md       # 已知失败
│   └── journals/               # 会话日志
├── <req-id>/                   # 每个需求的产物
│   ├── 00-requirements.md      # 需求确认
│   ├── 01-analysis.md          # 需求分析
│   ├── 02-design.md            # 方案设计
│   ├── 03-tasks.md             # 任务拆分
│   ├── *-dev-log.md            # 开发记录
│   ├── 05-test-report.md       # 测试报告
│   └── 06-code-review.md       # 代码审查
└── archive/                    # 归档（可选）
    └── CONTEXT-history.md
```

**设计理念**:
- **单一事实来源**: 所有状态、记忆、产物统一管理在 `.devflow-kit/`
- **渐进式披露**: GO.md 保持精简（<300 行），详细规则按需加载
- **国际化标准**: 文件名英文，内容中文，兼容全球团队

---

## 🎯 使用场景

### 场景 1: 开发新功能

```
Use devflow-kit.

在账号设置页增加已保存支付方式管理，支持信用卡和 PayPal
```

AI 会走完整流程: 需求澄清 → 设计 → TDD 开发 → 测试 → 审查

### 场景 2: 快速修复 Bug

```
Use devflow-kit. Fast 模式: 修复 settings 页面按钮文案 typo
```

AI 直接修改文件 → 窄验证 → 完成（跳过设计/测试报告）

### 场景 3: 恢复中断任务

```
Use devflow-kit. 继续
```

AI 读取 `.devflow-kit/STATE.md` → 找到中断任务 → 从断点继续

---

## 📖 文档

- [快速上手指南](docs/getting-started.md)
- [工作流详解](docs/workflow.md)
- [模式系统](docs/modes.md)
- [模板参考](docs/templates.md)
- [常见问题](docs/faq.md)
- [贡献指南](CONTRIBUTING.md)

---

## 🏗️ 架构设计

### Stage Skill 架构

```
GO.md (路由器)
  ↓
入场检测 (entry-check.md)
  ↓
模式判定 (mode-rules.md)
  ↓
加载 Stage Skill (按需)
  ├─ stage-0-confirm → 需求确认
  ├─ stage-1-analysis → 需求分析
  ├─ stage-2-design → 方案设计
  ├─ stage-3-task → 任务拆分
  ├─ stage-4-dev → 开发执行
  ├─ stage-5-test → 测试验证
  └─ stage-6-review → 代码审查
```

**关键原则**:
1. **只加载当前需要的 Stage**，不加载全部（渐进式披露）
2. **每个 Stage 独立**，有明确的输入/输出/门禁
3. **依赖显式声明**，先加载依赖再加载 Stage

---

## 🤝 贡献

我们欢迎贡献！详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

**如何贡献**:
1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 🙏 致谢

DevFlow Kit 整合了以下优秀项目的理念：

- **[devflow-kit](https://github.com/devflow-kit)** - 结构化流程编排
- **[superpowers](https://github.com/superpowers-ai)** - 工程纪律方法论
- **[OpenSpec](https://github.com/openspec-org)** - 规范驱动开发
- **[team-skills](https://github.com/team-skills)** - 跨会话记忆系统

感谢所有贡献者和使用者！
