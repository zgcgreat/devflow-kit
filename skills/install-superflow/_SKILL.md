---
name: install-devflow
description: 自动安装和初始化 DevFlow Kit 到当前项目。当用户想要开始使用 DevFlow Kit 时触发。
---

# Install DevFlow Kit

自动将 DevFlow Kit 安装并配置到当前项目中。

## 触发场景

- 用户说“安装 devflow-kit”
- 用户说"初始化工作流系统"
- 用户说"开始使用 superflow"
- 用户首次提到需要使用结构化开发流程

## 执行流程

### Step 1: 检测当前环境

```markdown
🔍 检测当前项目状态

检查项:
- [ ] 是否已存在 flow/GO.md?
- [ ] 是否已存在 .specs/ 目录?
- [ ] 是否已存在 .superpowers-memory/ 目录?
- [ ] AI工具类型 (Cursor/Claude Code/Gemini等)
```

**如果已安装**:
```
✅ DevFlow Kit 已安装

当前状态:
- flow/GO.md: 存在
- .specs/: 存在
- .superpowers-memory/: <存在/不存在>

你可以直接使用:
Use devflow-kit. <你的需求>

需要重新配置吗? [Y/n]
```

**如果未安装**: 继续 Step 2

---

### Step 2: 自动分析项目

**AI自动执行**:

```markdown
🔍 正在分析项目结构...

扫描配置文件:
- ✅ package.json (Node.js项目)
- ✅ tsconfig.json (TypeScript配置)
- ✅ vite.config.ts (Vite构建配置)

检测技术栈:
- ✅ React 18.2.0
- ✅ TypeScript 5.0
- ✅ Vite 4.3
- ✅ React Router 6.11
- ✅ Axios 1.4
- ✅ Zustand 4.3

分析目录结构:
- ✅ src/components/ (15个组件)
- ✅ src/pages/ (8个页面)
- ✅ src/api/ (5个API模块)
- ✅ src/hooks/ (6个自定义Hooks)
- ✅ src/utils/ (10个工具函数)

识别既有抽象:
- ✅ useAuth Hook - 认证逻辑
- ✅ apiClient - HTTP客户端封装
- ✅ ProtectedRoute - 路由守卫

✅ 项目分析完成!
```

**如果无法自动检测**:
```markdown
⚠️ 未能自动识别项目类型

可能原因:
- 非标准项目结构
- 缺少配置文件
- 混合技术栈

建议:
1. 继续安装，稍后手动编辑 PROJECT_CONTEXT.md
2. 或提供项目信息帮助AI更好地理解

继续安装? [Y/n]
```

### Step 3: 询问安装选项

在自动分析项目后，显示选项：

请选择安装模式:

1️⃣ **基础模式** (推荐首次尝试)
   - ✅ 安装完整工作流系统
   - ✅ 支持 Fast/Standard/Strict 三种模式
   - ✅ 自动生成所有产物到 .specs/
   - ❌ 不包含跨会话记忆

2️⃣ **完整模式** (推荐正式使用)
   - ✅ 包含基础模式全部功能
   - ✅ 启用跨会话记忆系统 (.superpowers-memory/)
   - ✅ AI记住项目背景和技术栈
   - ✅ 避免重复沟通

3️⃣ **预览模式** (仅查看)
   - 显示将创建的文件和目录
   - 不实际修改任何文件

请选择 (1/2/3):
```

---

### Step 3: 执行安装

根据用户选择执行对应操作:

#### 选项1: 基础模式

**AI自动执行**:

```markdown
🚀 正在安装 DevFlow Kit (基础模式)...

步骤1: 复制核心文件
- ✅ flow/ → 流程编排系统
- ✅ skills/ → Superpowers核心技能
- ✅ agent-skills/ → 专业工程技能库
- ✅ adapters/ → 工具适配器
- ✅ scripts/ → 安装和维护脚本
- ✅ docs/ → 文档和教程

步骤2: 创建入口文件
- ✅ SKILL.md → 统一入口
- ✅ AGENTS.md → AI助手指令
- ✅ README.md → 使用文档

步骤3: 验证安装
- ✅ 检查关键文件完整性
- ✅ 验证目录结构

✅ 安装完成!

你现在可以开始使用:
Use devflow-kit. <你的需求>

示例:
Use devflow-kit. 做个登录功能
```

**实际操作** (AI通过文件系统操作):
```python
# AI 应该执行的操作(伪代码)
copy_directory("E:/LLM/skills/devflow-kit/flow", "./flow")
copy_directory("E:/LLM/skills/devflow-kit/skills", "./skills")
copy_directory("E:/LLM/skills/devflow-kit/agent-skills", "./agent-skills")
copy_directory("E:/LLM/skills/devflow-kit/adapters", "./adapters")
copy_directory("E:/LLM/skills/devflow-kit/scripts", "./scripts")
copy_directory("E:/LLM/skills/devflow-kit/docs", "./docs")
copy_file("E:/LLM/skills/devflow-kit/SKILL.md", "./SKILL.md")
copy_file("E:/LLM/skills/devflow-kit/AGENTS.md", "./AGENTS.md")
copy_file("E:/LLM/skills/devflow-kit/README.md", "./README.md")
copy_file("E:/LLM/skills/devflow-kit/LICENSE", "./LICENSE")
```

---

#### 选项2: 完整模式

**AI自动执行**:

```markdown
🚀 正在安装 SuperFlow Kit (完整模式)...

步骤1-3: 同基础模式

步骤4: 初始化记忆系统
- ✅ 创建 .superpowers-memory/ 目录
- ✅ 生成 PROJECT_CONTEXT.md (已自动填充)
- ✅ 生成 CURRENT_STATE.md 模板
- ✅ 生成 DECISIONS.md 模板
- ✅ 生成 KNOWN_FAILURES.md 模板
- ✅ 创建 session-journal/ 目录

步骤5: 展示自动提取的信息

📊 AI已自动分析你的项目:

PROJECT_CONTEXT.md 已自动填充:

# Project Context

## 项目基本信息
- **项目名称**: my-react-app (从 package.json)
- **项目类型**: 前端单页应用
- **检测到时间**: 2026-05-16

## 技术栈
- **前端框架**: React 18.2.0
- **语言**: TypeScript 5.0
- **构建工具**: Vite 4.3
- **状态管理**: Zustand 4.3
- **路由**: React Router 6.11
- **HTTP客户端**: Axios 1.4

## 项目结构
- src/components/ - React组件 (15个)
- src/pages/ - 页面组件 (8个)
- src/api/ - API调用 (5个模块)
- src/hooks/ - 自定义Hooks (6个)
- src/utils/ - 工具函数 (10个)

## 既有抽象
- useAuth Hook - 认证逻辑
- apiClient - HTTP客户端封装
- ProtectedRoute - 路由守卫组件

---

✅ 记忆系统初始化完成!

AI已经了解你的项目，可以直接开始工作。

💡 提示: 
- 你可以随时编辑 .superpowers-memory/PROJECT_CONTEXT.md 
  补充更多项目特定的信息（如业务领域、特殊约束等）
- 但大多数情况下，AI自动提取的信息已经足够
```

**实际操作**:
```python
# 在基础模式基础上,额外执行:
create_directory("./.superpowers-memory")
create_directory("./.superpowers-memory/session-journal")
copy_template("PROJECT_CONTEXT.md")
copy_template("CURRENT_STATE.md")
copy_template("DECISIONS.md")
copy_template("KNOWN_FAILURES.md")
```

---

#### 选项3: 预览模式

```markdown
👀 预览模式 - 将创建以下文件:

📁 核心目录:
  flow/                    # 流程编排系统
    ├── GO.md              # 统一路由器
    ├── RULES.md           # 全局红线
    ├── mode-rules.md      # 模式判定
    ├── stage-skills/      # 17个Stage Skills
    ├── prompts/           # Prompt后备
    ├── templates/         # 产物模板
    └── reference/         # 参考资料
  
  skills/                  # Superpowers核心(14个)
  agent-skills/            # 专业工程技能(20个)
  adapters/                # 工具适配器
  scripts/                 # 安装脚本
  docs/                    # 文档

📄 入口文件:
  SKILL.md                 # 统一入口
  AGENTS.md                # AI助手指令
  README.md                # 使用文档
  LICENSE                  # MIT许可证

📁 记忆系统 (完整模式):
  .superpowers-memory/
    ├── PROJECT_CONTEXT.md
    ├── CURRENT_STATE.md
    ├── DECISIONS.md
    ├── KNOWN_FAILURES.md
    └── session-journal/

总计: ~265个文件, ~103个目录, ~2.6MB

确认安装? [Y/n]
```

---

### Step 4: 验证安装

安装完成后,AI自动验证:

```markdown
✅ 安装验证

检查项:
- [x] flow/GO.md 存在
- [x] flow/stage-skills/ 存在 (17个)
- [x] skills/ 存在 (14个)
- [x] agent-skills/skills/ 存在 (20个)
- [x] SKILL.md 存在
- [x] AGENTS.md 存在
- [x] README.md 存在
- [x] .specs/ 目录已创建
- [x] .superpowers-memory/ 存在 (完整模式)

✅ 所有检查通过!
```

如有问题:
```markdown
❌ 安装验证失败

问题:
- flow/GO.md 缺失

建议:
1. 重新运行安装
2. 检查文件权限
3. 手动复制缺失文件

需要帮助吗? [Y/n]
```

---

### Step 5: 快速上手引导

```markdown
🎉 SuperFlow Kit 已就绪!

快速开始:

1️⃣ **第一个需求**
   Use superflow-kit.
   
   做个简单的TODO列表功能

2️⃣ **查看文档**
   阅读 README.md 了解完整功能

3️⃣ **配置记忆** (完整模式)
   编辑 .superpowers-memory/PROJECT_CONTEXT.md
   填写项目信息让AI更懂你

💡 提示: AI会自动读取 flow/GO.md 并遵循工作流
```

---

## 后续使用

安装完成后,用户只需:

```
Use superflow-kit. <需求>
```

AI会:
1. 自动读取 `flow/GO.md`
2. 执行完整工作流程
3. 生成产物到 `.specs/<req-id>/`
4. 更新记忆系统(如果启用)

**无需再运行任何脚本!**

---

## 故障排查

### 问题1: AI不识别 superflow-kit

**解决**:
```
检查:
1. SKILL.md 是否存在于项目根目录
2. 文件名是否正确 (大小写敏感)
3. AI工具是否已重启

修复:
重新运行: Use install-superflow
```

### 问题2: 找不到 flow/GO.md

**解决**:
```
检查:
1. flow/ 目录是否存在
2. GO.md 文件是否在 flow/ 下

修复:
手动复制: E:/LLM/skills/superflow-kit/flow/ → ./flow/
```

### 问题3: 记忆系统未生效

**解决**:
```
检查:
1. .superpowers-memory/ 是否存在
2. PROJECT_CONTEXT.md 是否有内容
3. 是否开启了新会话

修复:
1. 编辑 PROJECT_CONTEXT.md 填写项目信息
2. 重启AI工具
3. 开启新会话
```

---

## 高级用法

### 单独安装某个组件

```
只安装记忆系统
```

AI会:
```markdown
📦 仅安装记忆系统

创建:
- .superpowers-memory/
  ├── PROJECT_CONTEXT.md
  ├── CURRENT_STATE.md
  └── ...

确认? [Y/n]
```

---

### 更新SuperFlow Kit

```
更新 superflow-kit 到最新版本
```

AI会:
```markdown
🔄 更新 SuperFlow Kit

备份现有文件...
下载最新版本...
合并配置...
验证更新...

✅ 更新完成!
```

---

### 卸载

```
卸载 superflow-kit
```

AI会:
```markdown
🗑️ 卸载 SuperFlow Kit

将删除:
- flow/
- skills/
- agent-skills/
- adapters/
- scripts/
- docs/
- SKILL.md
- AGENTS.md
- .specs/ (可选)
- .superpowers-memory/ (可选)

⚠️ 此操作不可逆!

确认卸载? [Y/n]
```

---

## 设计原则

1. **零手动操作** - 用户无需执行任何脚本
2. **AI自动化** - 所有安装步骤由AI自动完成
3. **交互式引导** - 清晰的选项和提示
4. **安全验证** - 安装后自动验证完整性
5. **友好错误处理** - 清晰的问题诊断和修复建议

---

## 实现说明

此Skill依赖AI的文件操作能力:
- 读取源文件 (从 E:/LLM/skills/superflow-kit/)
- 复制到目标项目
- 创建目录和文件
- 验证文件存在性

如果AI无法直接操作文件系统,可以提供:
1. PowerShell/Bash命令让用户复制粘贴
2. 或者创建一个简化的 `install.ps1/sh` 脚本供用户一键执行

但优先尝试AI自动完成,保持"零脚本"体验。

