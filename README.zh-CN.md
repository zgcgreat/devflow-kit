# DevFlow Kit

[English](./README.md) | [中文](./README.zh-CN.md)

DevFlow Kit（原名 DevFlow / SuperFlow）是一套 AI 驱动的软件开发工作流系统，提供**结构化流程**、**工程规范**和**跨会话记忆**，用于 AI 辅助的软件开发项目。

## 什么是 DevFlow Kit？

DevFlow Kit 是一套全面的工作流框架，旨在为 AI 辅助的软件开发提供结构化指导。它包含：

- **结构化阶段**：从需求到部署（0→1→2→3→4→5→6→7）
- **阶段门控**：每个阶段都有质量检查点
- **跨会话记忆**：在多个会话中保持项目状态和上下文
- **工程规范**：在整个开发过程中强制执行最佳实践

## 项目阶段

```
┌─────────────────────────────────────────────────────────────────────┐
│                 DevFlow 工作流                           │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─→ 0-确认 ─→ 1-分析 ─→ 2-设计 ─┐  │
│  │                      ↓                   │  │
│  │                 2a-UI设计              │  │
│  │                      ↓                   │  │
│  │              3-任务 ─→ 3a-计划        │  │
│  │                 ↓                       │  │
│  │               4-开发                   │  │
│  │                 ↓                       │  │
│  │               5-测试                 │  │
│  │                 ↓                       │  │
│  │               6-审查                 │  │
│  │                 ↓                       │  │
│  │           7-集成 ──→✓                │  │
│  └────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

| 阶段 | 名称 | 说明 |
|---|---|---|
| 0 | 确认 | 需求确认与澄清 |
| 1 | 分析 | 需求分析与规格创建 |
| 2 | 设计 | 技术架构与设计 |
| 2a | UI设计 | 用户界面设计（可选） |
| 3 | 任务 | 任务分解与规划 |
| 3a | 实现计划 | 详细实现计划 |
| 4 | 开发 | 代码实现 |
| 5 | 测试 | 测试编写与验证 |
| 6 | 审查 | 代码审查与质量检查 |
| 7 | 集成 | 集成与发布 |

## 功能特性

### 🧠 跨会话记忆
- 在多个会话中记住项目上下文、决策和失败
- 使用 `.devflow-kit/STATE.md` 自动跟踪状态
- 会话日志用于审计

### 🚪 阶段门控
- 每个阶段转换时进行验证
- 进入新阶段前检查前置条件
- 质量门控防止捷径

### 🔄 模式系统
- **快速模式**：快速迭代用于原型
- **标准模式**：完整工作流含所有检查
- **严格模式**：企业级严格规范

### 🛠️ 内置技能

- **brainstorming** - 创意提炼与需求收集
- **planning-and-context** - 项目规划与上下文管理
- **writing-plans** - 文档和计划编写
- **verification-before-completion** - 发布前验证
- **systematic-debugging** - 系统化调试方法论
- **test-driven-development** - TDD 实践
- **using-git-worktrees** - Git worktree 管理

## 快速开始

### 前置条件
- Claude Code / Cursor / OpenCode / Gemini CLI
- Node.js 18+（���分技能需要）
- Git

### 安装

```bash
# 克隆仓库
git clone https://github.com/zgcgreat/devflow-kit.git

# 进入目录
cd devflow-kit

# 复制到你的项目
# （或作为 AI 编码工具的参考）
```

### 基本用法

1. **开始新项目**：
   ```
   用户：我想开发一个新的 Web 应用
   ```

2. **DevFlow** 自动：
   - 读取项目状态
   - 检测入口点（新项目或现有项目）
   - 路由到适当的阶段
   - 引导完成工作流

3. **恢复中断的工作**：
   ```
   用户：继续我们之前停下的地方
   ```
   DevFlow 检测到中断状态并从正确的位置继续。

## 项目结构

```
devflow-kit/
├── SKILL.md                    # 主 DevFlow 技能
├── references/                 # 参考文档
│   ├── GO.md                  # 完整工作流详情
│   ├── RULES.md              # 全局规则
│   ├── gate-rules.md         # 阶段门控规则
│   ├── mode-rules.md         # 模式确定规则
│   ├── token-budget.md       # Token 预算管理
│   ├── prompts/             # 阶段执行提示
│   │   ├── 0-confirm.md
│   │   ├── 1-analysis.md
│   │   ├── 2-design.md
│   │   ├── ...
│   │   └── 7-integration.md
│   └── reference/            # 额外参考资料
├── skills/                   # 可复用技能
│   ├── brainstorming/
│   ├── stage-skills/       # 阶段特定技能
│   │   ├── stage-0-confirm/
│   │   ├── stage-1-analysis/
│   │   ├── ...
│   │   └── stage-7-integration/
│   └── ...
└── templates/                # 输出模板
    ├── 00-requirements.md
    ├── 01-analysis.md
    ├── 02-design.md
    └── ...
```

## 文档

- [完整工作流 (GO.md)](./references/GO.md) - 完整工作流详情
- [全局规则](./references/RULES.md) - 核心规则与原则
- [阶段门控规则](./references/gate-rules.md) - 阶段验证规则
- [模式规则](./references/mode-rules.md) - 快速/标准/严格模式

## 示例

See the `skills/` directory for example implementations and best practices.

## 贡献

欢迎贡献！请阅读 [CONTRIBUTING.md](./CONTRIBUTING.md) 了解更多。

## 许可证

MIT 许可证 - 可自由用于你自己的项目。

---

**注意**：此项目原名 DevFlow / SuperFlow。更名为 DevFlow Kit 以更好地反映其作为 AI 驱动开发"工具包"的 purpose。