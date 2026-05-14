# devflow-kit 快速开始

> **5分钟上手指南** - 无需阅读完整文档

---

## 🚀 第一步：安装（30秒）

### 方式A：复制到项目（推荐）

```bash
# 将 devflow-kit 复制到你的项目根目录
cp -r /path/to/devflow-kit your-project/
cd your-project
```

### 方式B：使用已安装的skill

如果你的AI工具已安装 devflow-kit skill，直接使用即可。

---

## 💡 第二步：首次使用（2分钟）

在AI对话中输入：

```
Use devflow-kit.

我想做一个用户登录功能。
```

AI会自动：
1. ✅ 反问澄清需求
2. ✅ 生成需求确认书
3. ✅ 引导你进入下一阶段

**就这么简单！**

---

## 📖 第三步：理解流程（3分钟）

```
你的想法 → 需求确认 → 分析 → 设计 → 任务 → 开发 → 测试 → 审查 → 完成
   ↓                                                            ↑
   └────────────── 每次只关注当前阶段，不用一次理解全部 ──────────┘
```

### 核心概念

| 概念 | 说明 |
|------|------|
| **Req-ID** | 每个需求自动生成一个短名（如 `add-login`） |
| **.specs/** | 产物存放目录，在项目根目录下自动创建 |
| **Fast模式** | 小改动（<50行）直接改，不跑全套流程 |
| **Standard模式** | 常规功能，走完整7阶段流程 |
| **Strict模式** | 高风险改动，多加确认点 |

---

## 🎯 常见场景

### 场景1：修复小bug

```
Use devflow-kit. Fast模式：修复按钮点击无响应的问题。
```

AI会：直接定位问题 → 修改 → 窄验证 → 总结证据

---

### 场景2：开发新功能

```
Use devflow-kit. 我想加一个商品搜索功能。
```

AI会：反问澄清 → 写需求确认书 → 整理需求和验收准则 → 技术设计 → 拆任务 → 逐任务实现（TDD）→ 风险驱动测试 → Review

---

### 场景3：继续之前的工作

```
Use devflow-kit. 继续
```

AI会：读取 `.specs/项目状态.md`，恢复中断的任务

---

### 场景4：检查项目健康度

```
Use devflow-kit. 帮我看看项目状态
```

AI会：运行 M-health 体检，生成健康报告

---

## 📁 产物在哪？

所有产物存在项目根目录的 `.specs/` 下：

```
你的项目/
├── .specs/
│   ├── 项目状态.md            ← 当前进度（AI自动维护）
│   ├── 上下文.md              ← 项目背景（AI自动积累）
│   ├── 经验总结.md            ← 跨任务失败教训库
│   ├── .memory/               ← v2.0新增：记忆系统
│   │   ├── PROJECT_CONTEXT.md
│   │   ├── CURRENT_STATE.md
│   │   └── session-journal/
│   └── <req-id>/             ← 本次改动的所有产物
│       ├── 00-需求确认.md
│       ├── 01-需求分析.md
│       ├── 02-方案设计.md
│       ├── 03-任务拆分.md
│       ├── 04-开发记录.md
│       ├── 05-测试报告.md
│       └── 06-代码审查.md
└── src/...                    ← 你的代码
```

用任何Markdown编辑器都能打开这些文件。VS Code / Cursor 直接预览。

---

## ⚡ 三种模式

| 模式 | 适合什么 | 一句话 |
|------|---------|--------|
| **Fast** | 改1~2文件、<50行、低风险 | 直接改→窄验证 |
| **Standard** | 普通功能、多文件改动、UI | 完整7阶段流程 |
| **Strict** | 鉴权、支付、数据库、架构 | 完整流程+安全+回滚 |

你可以主动说"Fast模式"或"Strict模式"，不说的话AI按风险自动判断。

---

## 🧠 v2.0 新功能：记忆系统

devflow-kit v2.0 新增了记忆系统，让AI记住项目上下文。

### 快速启用

```bash
# 创建记忆目录
mkdir -p .specs/.memory/session-journal

# 填写项目信息（花5分钟）
# 编辑 .specs/.memory/PROJECT_CONTEXT.md
# 编辑 .specs/.memory/CURRENT_STATE.md
```

**效果**：
- ✅ AI不再重复问项目背景
- ✅ 跨会话保持上下文
- ✅ 自动记录决策和失败经验

详见：[docs/MEMORY_INTEGRATION.md](docs/MEMORY_INTEGRATION.md)

---

## 🔧 高级用法

### 跳过流程

```
Use devflow-kit. 不要走流程，就直接帮我改一下这个typo。
```

### 切换方案

```
换个方案
```

AI会回到设计阶段，生成新的技术方案。

### 架构梳理

```
architect
```

AI会运行架构review，不改变主流程。

### 入场扫描

```
扫描代码
```

AI会生成 `上下文.md`，了解项目结构。

---

## ❓ 常见问题

### Q: 需要安装什么依赖吗？

A: 不需要！devflow-kit 是纯Markdown驱动，不依赖任何运行时。

### Q: 支持哪些AI工具？

A: 
- ✅ Claude Code / Gemini CLI: `Use devflow-kit`
- ✅ Cursor / Windsurf: `@devflow-kit/flow/GO.md`
- ✅ 其他工具: 粘贴 `flow/SYSTEM.md` 作为系统提示

### Q: 产物会污染Git吗？

A: 建议将 `.specs/` 加入 `.gitignore`，或者定期归档旧req。

```bash
# 归档30天前的req
sh ./scripts/archive-reqs.sh --project-root . --days 30
```

### Q: 如何自定义流程？

A: 编辑 `flow/prompts/<n>-*.md` 文件，或添加自己的skill到 `agent-skills/skills/`。

---

## 📚 下一步

- 📖 **完整文档**: [README.md](README.md)
- 🎯 **流程详解**: [flow/METHODOLOGY.md](flow/METHODOLOGY.md)
- 🔧 **高级用法**: [docs/ADVANCED.md](docs/ADVANCED.md)
- 🆕 **v2.0新特性**: [docs/CHANGELOG_v2.0.md](docs/CHANGELOG_v2.0.md)

---

## 💬 获取帮助

- **问题报告**: GitHub Issues
- **讨论**: Discord/Slack频道
- **文档贡献**: PR欢迎

---

*祝你使用愉快！🎉*

*最后更新: 2024-01-15*  
*版本: v2.0*
