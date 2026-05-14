# devflow-kit 记忆系统集成规范

> **版本**: v2.0  
> **状态**: 实验性  
> **目标**: 在不破坏现有流程的前提下，增加跨会话记忆能力

---

## 设计理念

### 与现有系统的关系

```
上下文.md (现有)          PROJECT_CONTEXT.md (新增)
├─ 域语言术语表            ├─ 项目基本信息
├─ 默认决策偏好            ├─ 技术栈说明
└─ 用户协作风格            ├─ 架构约束
                           └─ 团队约定

CURRENT_STATE.md (新增)    项目状态.md (现有)
├─ 当前焦点任务            ├─ 活跃req追踪
├─ 最近决策                ├─ 阶段进度
├─ 待解决问题              └─ 中断任务
└─ 下一步建议
```

**关键区别:**
- `上下文.md`: 面向单个需求的生命周期
- `.memory/`: 面向整个项目的长期记忆

---

## 文件规范

### 1. PROJECT_CONTEXT.md

**用途**: 存储长期不变的项目事实

**模板:**
```markdown
# Project Context

## 项目概要
- **项目名称**: [填写]
- **核心功能**: [一句话描述]
- **目标用户**: [填写]

## 技术栈
- **前端**: [如 Vue 3 + TypeScript + Vite]
- **后端**: [如 Spring Boot + MySQL]
- **部署**: [如 Docker + K8s]

## 架构说明
- [关键架构决策，如微服务划分]
- [核心模块依赖关系]

## 关键约束
- [性能要求，如API响应<200ms]
- [安全要求，如必须HTTPS]
- [合规要求，如GDPR]

## 团队约定
- [代码规范，如ESLint规则]
- [提交规范，如Conventional Commits]
- [Review流程，如至少1人approve]

---
*最后更新: YYYY-MM-DD*
*更新者: [姓名/AI]*
```

**更新频率**: 低频（项目重大变更时）

---

### 2. CURRENT_STATE.md

**用途**: 存储动态变化的工作状态

**模板:**
```markdown
# Current State

## 当前焦点
- **活跃需求**: [req-id或描述]
- **当前阶段**: [如 4-dev / 5-test]
- **进行中任务**: [T01: 实现搜索组件]

## 最近完成
- [YYYY-MM-DD] 完成了 [req-id]: [简要描述]
- [YYYY-MM-DD] 修复了 [bug描述]

## 关键决策
- [YYYY-MM-DD] 决定采用 [技术方案]，原因：[理由]
- [YYYY-MM-DD] 拒绝了 [备选方案]，原因：[理由]

## 待解决问题
- [ ] [问题1]: [影响范围]
- [ ] [问题2]: [阻塞情况]

## 下一步建议
1. [优先事项1]
2. [优先事项2]

## 风险提示
- ⚠️ [风险1]: [缓解措施]
- ⚠️ [风险2]: [监控指标]

---
*最后更新: YYYY-MM-DD HH:mm*
*更新者: [姓名/AI]*
```

**更新频率**: 高频（每次会话结束时）

---

### 3. DECISIONS.md

**用途**: 记录重要设计/技术决策

**模板:**
```markdown
# Decisions Log

## [DEC-001] 采用PostgreSQL而非MySQL

**日期**: 2024-01-15  
**决策者**: 张三 + AI助手  
**状态**: ✅ 已实施

### 背景
项目需要JSONB支持和全文检索，MySQL 5.7支持有限。

### 选项对比
| 方案 | 优势 | 劣势 |
|------|------|------|
| PostgreSQL | JSONB原生支持、GIS扩展 | 学习成本略高 |
| MySQL 8.0 | 团队熟悉 | JSON支持较弱 |

### 决策理由
1. JSONB查询性能优于MySQL的JSON类型
2. PostGIS满足未来地图功能需求
3. 迁移成本可控（仅2张表有数据）

### 影响范围
- 数据库连接配置
- ORM选型（TypeORM → Prisma）
- CI/CD中的数据库初始化脚本

### 回顾日期
2024-07-15（实施6个月后评估）

---

## [DEC-002] API采用GraphQL而非REST

**日期**: 2024-02-20  
**决策者**: 李四 + AI助手  
**状态**: 🔄 实施中

### 背景
前端需要灵活的数据获取，避免over-fetching。

[...类似结构...]
```

**更新触发条件:**
- 技术栈变更
- 架构调整
- 重要依赖升级
- 业务流程改变

---

### 4. KNOWN_FAILURES.md

**用途**: 积累失败模式和避坑指南

**模板:**
```markdown
# Known Failures & Pitfalls

## [FAIL-001] MySQL连接池泄漏

**发现日期**: 2024-01-10  
**严重度**: 🔴 高  
**状态**: ✅ 已解决

### 症状
- 运行2小时后API超时
- 数据库连接数持续增长
- 重启服务后恢复正常

### 根本原因
TypeORM的`createConnection()`在每次请求时被调用，但未正确关闭。

### 解决方案
```typescript
// ❌ 错误写法
app.post('/api/data', async (req, res) => {
  const conn = await createConnection();
  // ...
});

// ✅ 正确写法
const conn = await createConnection(); // 应用启动时创建一次
app.post('/api/data', async (req, res) => {
  // 复用conn
});
```

### 预防措施
- Code Review时检查数据库连接创建位置
- 添加连接数监控告警（阈值：>80%）

### 相关文档
- [DEC-003] 数据库连接管理规范

---

## [FAIL-002] Vite生产构建内存溢出

**发现日期**: 2024-03-05  
**严重度**: 🟡 中  
**状态**: ✅ 已解决

[...类似结构...]
```

**更新触发条件:**
- 遇到重复出现的bug
- 排查耗时>2小时的问题
- 团队成员踩过的坑

---

### 5. session-journal/

**用途**: 记录每次有意义会话的摘要

**命名规范:**
```
YYYY-MM-DD-HHMM-<简短描述>.md
例: 2024-01-15-1430-add-search-feature.md
```

**模板:**
```markdown
# Session Journal: 2024-01-15 14:30

## 会话目标
实现商品搜索功能（req-id: add-search-box）

## 关键活动
1. [14:30-14:45] 需求澄清：确定搜索字段和排序规则
2. [14:45-15:30] 技术方案：选择Elasticsearch而非DB LIKE
3. [15:30-16:30] 实现搜索API和前端组件
4. [16:30-17:00] 编写单元测试和集成测试

## 产出物
- `.specs/add-search-box/00-需求确认.md`
- `.specs/add-search-box/02-方案设计.md`
- `src/components/SearchBox.vue`
- `src/api/search.ts`
- `tests/search.spec.ts`

## 关键决策
- 采用Elasticsearch（理由：支持模糊搜索和分词）
- 前端使用debounce 300ms（平衡响应速度和服务器负载）

## 遇到的问题
- ES索引映射配置错误，导致中文分词失败
  - 解决：改用ik_max_word analyzer
  - 教训：先写测试再实现

## 验证结果
- ✅ 单元测试通过率: 100% (12/12)
- ✅ 集成测试: 搜索响应时间 < 100ms (P95)
- ✅ 手动测试: 中文/英文/混合搜索均正常

## 下一步
- [ ] 添加搜索历史记录功能
- [ ] 优化热门搜索推荐算法

## 经验提炼
> **可复用模式**: Elasticsearch中文搜索配置模板
> **应避免**: 在生产环境直接修改索引映射（应通过migration脚本）

---
*会话时长: 2.5小时*
*AI助手: devflow-kit v1.0*
```

**创建触发条件:**
- 完成一个完整的req
- 解决了一个复杂bug
- 做出了重要技术决策
- 会话时长 > 1小时

---

## 集成到现有流程

### GO.md 修改点

#### 第一步：读取记忆（新增）

```markdown
## 第一步 · 读取项目状态和记忆（必须）

1. 尝试读 `.specs/项目状态.md`。不存在 → 用模板创建
2. **新增**: 尝试读 `.specs/.memory/PROJECT_CONTEXT.md`
   - 存在 → 加载到上下文
   - 不存在 → 跳过（greenfield项目首次会话）
3. **新增**: 尝试读 `.specs/.memory/CURRENT_STATE.md`
   - 存在 → 了解当前工作重点
   - 不存在 → 跳过
4. 检查是否有「中断任务」→ 有则直接走恢复分支
```

#### 第二步：入场检测增强

```markdown
## 第二步 · 老项目入场检测（增强版）

### 新增检查项：记忆系统健康度

在输出检测结果框前，额外检查：

```
步骤 2.5：检查 .specs/.memory/ 是否存在
         ├─ 存在 → 检查文件完整性
         │         ├─ PROJECT_CONTEXT.md 缺失 → 提醒创建
         │         └─ CURRENT_STATE.md 超过7天未更新 → 提醒更新
         └─ 不存在 → 提示可选安装
```

### 检测结果框增强

```
┌─────────────────────────────────────────────────────────────┐
│  🔍 入场检测（第二步 · 必须）                                  │
├─────────────────────────────────────────────────────────────┤
│  检测结果：<情况 A/B/C/D/E/F>                                 │
│  项目类型：<brownfield / greenfield>                         │
│  上下文文档：<路径 或 "无">                                   │
│  入场扫描状态：<已完成 / 已跳过 / 待用户确认>                  │
│  记忆系统状态：<✅ 正常 / ⚠️ 需完善 / ❌ 未安装>              │
└─────────────────────────────────────────────────────────────┘
```
```

#### 第七步：会话结束更新记忆（新增）

```markdown
## 第七步 · 会话收尾（新增）

在完成阶段prompt执行后，如果是以下情况之一，必须更新记忆：

**触发条件:**
1. 完成了完整的req（到达7-integration阶段）
2. 做出了重要技术决策（写入ADR）
3. 遇到了新的失败模式（排查耗时>1小时）
4. 会话时长 > 1小时

**执行步骤:**

### 7.1 更新 CURRENT_STATE.md

```markdown
# 自动更新逻辑

IF 完成了req:
  - 在"最近完成"中添加条目
  - 清空"当前焦点"
  - 根据项目 backlog 建议"下一步"

IF 做出了决策:
  - 在"关键决策"中添加条目
  - 同步到 DECISIONS.md

IF 遇到了问题:
  - 在"待解决问题"中标记
  - 评估是否需要写入 KNOWN_FAILURES.md
```

### 7.2 创建 session journal（如触发）

```bash
# 自动生成文件名
filename="session-journal/$(date +%Y-%m-%d-%H%M)-<简短描述>.md"

# 填充模板
# - 会话目标：从路由声明中提取
# - 关键活动：从对话历史中总结
# - 产出物：列出创建的 .specs/<req-id>/ 文件
# - 经验提炼：从对话中提取可复用模式
```

### 7.3 提醒用户

```
📝 记忆更新完成

已更新:
- .specs/.memory/CURRENT_STATE.md
- .specs/.memory/session-journal/YYYY-MM-DD-HHMM-xxx.md

建议操作:
1. 检查 CURRENT_STATE.md 是否准确
2. 如有重要决策，补充到 DECISIONS.md
3. 如遇到新问题，考虑添加到 KNOWN_FAILURES.md
```
```

---

## 初始化脚本

### install-memory.ps1 (Windows)

```powershell
# devflow-kit 记忆系统初始化脚本

param(
    [string]$ProjectRoot
)

$ErrorActionPreference = "Stop"

if (-not $ProjectRoot) {
    Write-Host "用法: .\install-memory.ps1 -ProjectRoot <路径>" -ForegroundColor Red
    exit 1
}

$MemoryDir = Join-Path $ProjectRoot ".specs\.memory"
$SessionJournalDir = Join-Path $MemoryDir "session-journal"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "devflow-kit 记忆系统初始化" -ForegroundColor Cyan
Write-Host "目标项目: $ProjectRoot" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 创建目录结构
if (-not (Test-Path $MemoryDir)) {
    New-Item -ItemType Directory -Path $MemoryDir -Force | Out-Null
    New-Item -ItemType Directory -Path $SessionJournalDir -Force | Out-Null
    Write-Host "✓ 创建记忆系统目录" -ForegroundColor Green
} else {
    Write-Host "⚠ 记忆系统已存在" -ForegroundColor Yellow
}

# 创建模板文件
$Templates = @{
    "PROJECT_CONTEXT.md" = @"
# Project Context

## 项目概要
- **项目名称**: [填写]
- **核心功能**: [一句话描述]
- **目标用户**: [填写]

## 技术栈
- **前端**: [如 Vue 3 + TypeScript + Vite]
- **后端**: [如 Spring Boot + MySQL]
- **部署**: [如 Docker + K8s]

## 架构说明
- [关键架构决策]
- [核心模块依赖关系]

## 关键约束
- [性能要求]
- [安全要求]
- [合规要求]

## 团队约定
- [代码规范]
- [提交规范]
- [Review流程]

---
*最后更新: $(Get-Date -Format 'yyyy-MM-dd')*
"@

    "CURRENT_STATE.md" = @"
# Current State

## 当前焦点
- **活跃需求**: [填写或留空]
- **当前阶段**: [如 4-dev / 5-test]
- **进行中任务**: [填写]

## 最近完成
- [日期] 完成了 [描述]

## 关键决策
- [日期] 决定采用 [方案]，原因：[理由]

## 待解决问题
- [ ] [问题描述]

## 下一步建议
1. [优先事项]

## 风险提示
- ⚠️ [风险描述]

---
*最后更新: $(Get-Date -Format 'yyyy-MM-dd HH:mm')*
"@

    "DECISIONS.md" = @"
# Decisions Log

## 如何添加新决策

复制以下模板并填充：

``markdown
## [DEC-XXX] 决策标题

**日期**: YYYY-MM-DD  
**决策者**: [姓名]  
**状态**: 🔄 进行中 / ✅ 已实施 / ❌ 已废弃

### 背景
[为什么需要做这个决策]

### 选项对比
| 方案 | 优势 | 劣势 |
|------|------|------|
| 方案A | ... | ... |
| 方案B | ... | ... |

### 决策理由
1. [理由1]
2. [理由2]

### 影响范围
- [影响的模块/流程]

### 回顾日期
YYYY-MM-DD（实施后评估）
``

---

*暂无决策记录*
"@

    "KNOWN_FAILURES.md" = @"
# Known Failures & Pitfalls

## 如何添加新问题

复制以下模板并填充：

``markdown
## [FAIL-XXX] 问题简述

**发现日期**: YYYY-MM-DD  
**严重度**: 🔴 高 / 🟡 中 / 🟢 低  
**状态**: 🔍 调查中 / ✅ 已解决 / ⚠️ 监控中

### 症状
- [现象1]
- [现象2]

### 根本原因
[原因分析]

### 解决方案
[解决步骤或代码示例]

### 预防措施
[如何避免再次发生]

### 相关文档
- [相关链接]
``

---

*暂无失败记录*
"@
}

foreach ($file in $Templates.Keys) {
    $filePath = Join-Path $MemoryDir $file
    if (-not (Test-Path $filePath)) {
        $Templates[$file] | Set-Content $filePath -Encoding UTF8
        Write-Host "✓ 创建 $file" -ForegroundColor Green
    } else {
        Write-Host "⚠ $file 已存在，跳过" -ForegroundColor Yellow
    }
}

# 创建 README
$ReadmeContent = @"
# Memory System

本目录存储项目的长期记忆，帮助AI助手在跨会话时保持上下文。

## 文件说明

- **PROJECT_CONTEXT.md**: 稳定的项目事实（技术栈、架构、约束）
- **CURRENT_STATE.md**: 动态的工作状态（当前任务、最近决策）
- **DECISIONS.md**: 重要决策记录（技术选型、架构调整）
- **KNOWN_FAILURES.md**: 失败模式库（常见bug、避坑指南）
- **session-journal/**: 会话日志（每次有意义会话的摘要）

## 使用建议

1. **首次设置**: 花10分钟填写 PROJECT_CONTEXT.md
2. **日常维护**: 每次会话结束后检查 CURRENT_STATE.md
3. **重要决策**: 立即记录到 DECISIONS.md
4. **遇到问题**: 解决后总结到 KNOWN_FAILURES.md
5. **长会话**: 自动生成 session journal

## 自动化

devflow-kit 会在以下情况自动更新记忆：
- 完成完整的需求流程
- 做出重要技术决策
- 遇到新的失败模式
- 会话时长 > 1小时

你也可以手动触发更新：
```
使用 devflow-kit 更新项目记忆
```

---
*由 install-memory.ps1 创建于 $(Get-Date -Format 'yyyy-MM-dd')*
"@

$ReadmePath = Join-Path $MemoryDir "README.md"
$ReadmeContent | Set-Content $ReadmePath -Encoding UTF8
Write-Host "✓ 创建 README.md" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "初始化完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "  1. 编辑 .specs\.memory\PROJECT_CONTEXT.md 添加项目信息" -ForegroundColor White
Write-Host "  2. 编辑 .specs\.memory\CURRENT_STATE.md 添加当前状态" -ForegroundColor White
Write-Host "  3. 将 .specs\.memory\ 加入 .gitignore (可选)" -ForegroundColor White
Write-Host ""
