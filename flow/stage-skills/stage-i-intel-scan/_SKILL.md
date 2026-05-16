# devflow-kit Stage: I-Intel-Scan（入场扫描）

> **阶段定位**：新项目或大改动前的代码库扫描，生成上下文
> **前置条件**：无（首次执行或项目结构大变化时执行）
> **后置产物**：`.specs/上下文.md`

## Skill元信息

```yaml
name: stage-i-intel-scan
version: 1.0.0
description: devflow-kit可选命令 - 项目入场扫描与上下文化
author: devflow-kit
dependencies:
  - planning-and-context
```

## 输入

- 项目根目录
- `.git/`（如存在）
- `package.json` / `requirements.txt` / `go.mod` 等依赖文件
- `src/` 或主要源码目录

## 输出

- `.specs/上下文.md`（新建或更新）

## 入口门禁

无（可选命令，随时可执行）

## 执行流程

### Step 1: 检测项目类型

**根据文件判断**：

| 文件 | 项目类型 |
|------|---------|
| package.json | Node.js/前端 |
| requirements.txt / pyproject.toml | Python |
| go.mod | Go |
| pom.xml / build.gradle | Java |
| Cargo.toml | Rust |
| Gemfile | Ruby |

**输出**：
```markdown
检测到项目类型: Node.js + React
技术栈: TypeScript, Next.js, PostgreSQL
```

### Step 2: 扫描目录结构

```bash
# 列出顶层目录
ls -la

# 列出src结构（深度2层）
find src/ -maxdepth 2 -type d

# 统计文件数
find src/ -name "*.ts" -o -name "*.tsx" | wc -l
```

**记录**：
- 目录树（关键部分）
- 文件统计（按类型）
- 配置文件列表

### Step 3: 分析依赖

**读取依赖文件**：

```bash
cat package.json | jq '.dependencies'
cat package.json | jq '.devDependencies'
```

**分类**：
- 核心框架（React, Vue, Spring等）
- 数据库驱动（pg, mysql等）
- 工具库（lodash, moment等）
- 开发工具（eslint, jest等）

**识别架构模式**：
- 是否有ORM（Prisma, TypeORM）→ 数据访问层
- 是否有状态管理（Redux, Zustand）→ 前端架构
- 是否有测试框架（Jest, pytest）→ 测试策略

### Step 4: 提取编码规范

**从配置文件提取**：

```bash
# ESLint配置
cat .eslintrc.json | jq '.rules'

# Prettier配置
cat .prettierrc

# TypeScript配置
cat tsconfig.json | jq '.compilerOptions'
```

**记录**：
- 代码风格规则
- 命名约定
- 导入顺序
- 格式化要求

### Step 5: 扫描既有抽象

**grep关键模式**：

```bash
# 查找Service类
grep -r "class.*Service" src/ --include="*.ts"

# 查找Repository
grep -r "class.*Repository" src/ --include="*.ts"

# 查找Hook（React）
grep -r "export const use" src/ --include="*.ts"

# 查找Utils
ls src/utils/
```

**汇总**：
- 公共Service列表
- Repository模式使用情况
- 自定义Hook列表
- 工具函数分类

### Step 6: 分析测试策略

```bash
# 查找测试文件
find . -name "*.test.ts" -o -name "*.spec.ts" | head -20

# 查看测试配置
cat jest.config.js
# 或
cat vitest.config.ts
```

**记录**：
- 测试框架
- 测试目录结构
- Mock策略
- 覆盖率要求

### Step 7: 检查AI上下文文档

**查找现有文档**：

```bash
# 检查常见AI上下文文件
ls AGENTS.md CLAUDE.md GEMINI.md .cursorrules 2>/dev/null
```

**如存在**：
- 读取内容
- 提取关键规则
- 合并到上下文.md

**如不存在**：
- 提示用户创建
- 提供模板建议

### Step 8: 生成上下文文档

**⚠️ 强制规则**：必须按以下结构生成，不得省略任何章节。

按模板生成 `.specs/上下文.md`：
- **必须包含所有9个章节**（项目概览/目录结构/编码规范/既有抽象/测试策略/AI助手规则/待补充等）
- **所有 `<...>` 占位符必须替换为实际值**
- **必须基于实际扫描结果**（禁止编造）

```markdown
# 项目上下文

## 项目概览

**名称**: <项目名>
**类型**: Node.js + React
**技术栈**:
- 前端: Next.js 14, React 18, TypeScript
- 后端: Next.js API Routes
- 数据库: PostgreSQL 14, Prisma ORM
- 缓存: Redis 7
- 测试: Jest, React Testing Library

## 目录结构

```
src/
├── app/              # Next.js App Router
├── components/       # React组件
│   ├── ui/          # 基础UI组件
│   └── features/    # 业务组件
├── lib/             # 工具库
│   ├── api-client.ts
│   └── utils.ts
├── services/        # 业务逻辑
├── repos/           # 数据访问层
└── hooks/           # 自定义Hook
```

## 编码规范

**代码风格**:
- ESLint: Airbnb + TypeScript
- Prettier: 2空格，单引号
- 导入顺序: React → 第三方 → 内部

**命名约定**:
- 组件: PascalCase
- 函数: camelCase
- 常量: UPPER_SNAKE_CASE
- 文件: kebab-case

## 既有抽象

**Service层**:
- UserService: 用户管理
- NotificationService: 通知管理

**Repository层**:
- UserRepository: 用户数据访问
- NotificationRepository: 通知数据访问

**自定义Hook**:
- useAuth: 认证状态
- useNotifications: 通知管理

**工具函数**:
- src/lib/utils.ts: 通用工具
- src/lib/date.ts: 日期处理

## 测试策略

**框架**: Jest + React Testing Library
**目录**: `__tests__/` 同级的测试文件
**Mock**: `jest.mock()` Mock外部依赖
**覆盖率要求**: ≥80%

## AI助手规则

**必须遵守**:
1. 使用TypeScript严格模式
2. 组件使用函数式+Hooks
3. 数据访问通过Repository
4. 所有公共API必须有类型定义

**禁止**:
1. 直接操作DOM（使用React）
2. 在组件中写业务逻辑（抽到Service）
3. 硬编码配置（使用环境变量）

## 待补充

- [ ] 创建 AGENTS.md 或 CLAUDE.md
- [ ] 补充部署流程说明
- [ ] 补充环境变量清单
```

### Step 9: 用户Review

输出摘要：

```markdown
✅ 入场扫描完成

**项目类型**: Node.js + React
**扫描模块**: 15个
**既有抽象**: 
- Service: 2个
- Repository: 2个
- Hook: 2个
- Utils: 2个

**建议**:
1. 创建 AGENTS.md 固化AI规则
2. 补充部署流程文档

是否保存为 .specs/上下文.md？
1. ✅ 是，保存
2. ✏️ 否，先修改
3. ↩️ 重新扫描
```

### Step 10: 根据用户选择执行

**选项1**：保存
- 写入 `.specs/上下文.md`
- 更新 `.specs/项目状态.md` 的 `ai_context_doc: 上下文.md`

**选项2**：修改
- 展示完整内容
- 等待用户编辑后保存

**选项3**：重扫
- 回到Step 1

## 自检清单

- [ ] **已按模板结构生成**（9个章节完整）
- [ ] 项目类型识别准确
- [ ] 目录结构完整
- [ ] 依赖分析全面
- [ ] 既有抽象已提取
- [ ] 测试策略已记录
- [ ] AI上下文文档已检查
- [ ] **所有占位符已替换**
- [ ] 用户已review并确认

## 约束

- **禁止**编造不存在的文件/模块
- **必须**基于实际扫描结果
- **必须**让用户确认后再保存
- 扫描深度适中（避免过深浪费时间）

## 触发下一步

- 保存成功 → 返回主流程
- 重新扫描 → 重新执行本stage

## 错误处理

- 依赖文件缺失 → 提示用户手动补充
- 扫描超时 → 限制深度，只扫描关键目录
- 上下文冲突 → 提示用户选择保留哪个版本
