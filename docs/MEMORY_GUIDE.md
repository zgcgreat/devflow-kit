# DevFlow Kit 记忆系统使用指南

## 概述

DevFlow Kit 的记忆系统提供**跨会话上下文保持**能力,让 AI 助手能够:
- 记住项目背景和技术栈
- 跟踪当前工作状态
- 记录重要决策和失败模式
- 避免重复沟通和重复错误

## 核心概念

### 什么是记忆?

记忆不是聊天记录,而是**结构化的项目知识**,存储在项目的 `.superpowers-memory/` 目录中:

```
.my-project/
├── .superpowers-memory/
│   ├── PROJECT_CONTEXT.md      # 项目基本信息(稳定)
│   ├── CURRENT_STATE.md        # 当前工作状态(动态)
│   ├── DECISIONS.md            # 重要技术决策
│   ├── KNOWN_FAILURES.md       # 已知失败模式
│   ├── VERIFICATION_BASELINE.md # 验证基线
│   ├── TEAM_PREFERENCES.md     # 团队偏好
│   ├── USER_PROFILE.md         # 用户画像
│   ├── AGENT_NOTES.md          # AI助手笔记
│   └── session-journal/        # 会话日志
│       ├── 2026-05-16-login-feature.md
│       └── 2026-05-17-bugfix-search.md
```

### 记忆 vs 产物

| 维度 | 记忆 (.superpowers-memory/) | 产物 (.specs/<req-id>/) |
|------|---------------------------|------------------------|
| **作用域** | 整个项目生命周期 | 单个需求/功能 |
| **持久性** | 长期保留,跨会话有效 | 需求完成后归档 |
| **更新频率** | 低频(重要变化时) | 高频(每个阶段) |
| **内容类型** | 事实、决策、教训 | 需求、设计、代码 |
| **读者** | 所有后续会话的AI | 当前需求的开发者 |

---

## 快速开始

### 第1步: 初始化记忆系统

在项目根目录运行:

```bash
# Windows PowerShell
cd <devflow-kit所在目录>
.\scripts\init-project.ps1 -ProjectRoot D:\my-project -IncludeMemory

# macOS/Linux
sh ./scripts/init-project.sh --project-root /path/to/my-project --include-memory
```

这会创建 `.superpowers-memory/` 目录和所有模板文件。

### 第2步: 填写基础信息

编辑 `PROJECT_CONTEXT.md`:

```markdown
# Project Context

## 项目基本信息
- **项目名称**: My E-commerce Platform
- **项目用途**: B2C电商平台,支持商品浏览、购物车、订单、支付
- **启动时间**: 2025-01
- **团队规模**: 5人

## 技术栈
- **前端**: Vue 3 + TypeScript + Vite + Pinia
- **后端**: Spring Boot 3 + Java 17
- **数据库**: PostgreSQL 15 + Redis 7
- **部署**: Docker + Kubernetes (AWS EKS)

## 核心模块
- 用户认证 (JWT + OAuth2)
- 商品管理 (SPU/SKU)
- 订单流程 (购物车→下单→支付→发货)
- 支付集成 (支付宝、微信支付、Stripe)

## 关键约束
- P95响应时间 < 200ms
- 支持10万并发用户
- GDPR合规(欧盟用户数据)
- 禁止在代码中硬编码密钥

## 既有抽象
- `ApiClient`: 统一的HTTP客户端(带重试/熔断)
- `validation.ts`: 前端表单验证工具
- `AuthService`: Spring Security封装
```

编辑 `CURRENT_STATE.md`:

```markdown
# Current State

**最后更新**: 2026-05-16

## 当前焦点
正在开发用户登录功能(JWT + Remember Me)

## 最近完成
- ✅ 项目脚手架搭建
- ✅ CI/CD流水线配置
- ✅ 数据库schema设计

## 待解决问题
- JWT过期策略未确定(access token 15min? refresh token 7d?)
- 需要决定是否支持第三方登录(Google/GitHub)

## 下一步
- 完成登录API实现
- 编写单元测试
- 前端登录页面UI
```

### 第3步: 重启AI工具

关闭并重新打开你的AI编程工具(Cursor/Claude Code等),让它读取新的记忆文件。

---

## 记忆读写规则

### AI何时读取记忆?

**会话开始时**(自动):
1. 检查 `.superpowers-memory/` 是否存在
2. 如果存在,按优先级读取:
   - `PROJECT_CONTEXT.md` (必须)
   - `CURRENT_STATE.md` (必须)
   - `DECISIONS.md` (如果存在)
   - `KNOWN_FAILURES.md` (如果存在)
   - 最近3个 session-journal 条目

**阶段执行前**(按需):
- `VERIFICATION_BASELINE.md`: 在测试/验证阶段前
- `TEAM_PREFERENCES.md`: 在做UI/UX决策前
- `KNOWN_FAILURES.md`: 在debugging前

### AI何时写入记忆?

**阶段结束时**(自动触发):
- 当检测到**显著变化**时更新 `CURRENT_STATE.md`
- 当做出**重要决策**时追加到 `DECISIONS.md`
- 当发现**失败模式**时追加到 `KNOWN_FAILURES.md`

**会话结束时**(手动触发):
- 运行 `superpowers-learning` workflow
- 或执行 `memory/scripts/run-superpowers-memory-closeout.ps1`

### 什么算"显著变化"?

✅ **应该更新记忆**:
- 完成了重要功能(登录、支付、搜索)
- 改变了技术选型(换数据库、换UI框架)
- 发现了系统性问题(性能瓶颈、安全漏洞)
- 做出了架构决策(微服务拆分、缓存策略)

❌ **不应更新记忆**:
- 修复typo或小bug
- 临时实验性代码
- 未经验证的假设
- 会话中间状态

---

## 记忆文件详解

### 1. PROJECT_CONTEXT.md

**用途**: 存储稳定的项目事实,很少变化

**更新频率**: 每月或重大变更时

**示例内容**:
```markdown
# Project Context

## 技术栈
- 前端: React 18 + Next.js 14
- 后端: Node.js 20 + Express
- 数据库: MongoDB 7

## 命名约定
- API路径: `/api/v1/resource`
- 组件命名: PascalCase (`UserProfile.tsx`)
- 工具函数: camelCase (`formatDate.ts`)

## 禁动清单
- ❌ 不要修改 `src/core/auth/` (由安全团队维护)
- ❌ 不要删除 `legacy/` 目录(等待迁移完成)
```

### 2. CURRENT_STATE.md

**用途**: 跟踪当前工作重点,频繁更新

**更新频率**: 每次会话结束或工作重点变化时

**示例内容**:
```markdown
# Current State

**最后更新**: 2026-05-16 15:30

## 当前焦点
实现商品搜索功能(Elasticsearch集成)

## 本周进度
- ✅ 完成ES schema设计
- ✅ 实现索引同步逻辑
- 🔄 正在开发搜索API (60%)
- ⏸️ 待做: 前端搜索UI

## 阻塞问题
- ES集群连接超时(已提工单给运维)
- 需要确认分词器配置(中文ik插件)

## 下一步
- 完成搜索API的单元测试
- 与前端对齐搜索结果格式
```

### 3. DECISIONS.md

**用途**: 记录重要技术决策及其理由(ADR风格)

**格式**:
```markdown
# Decisions Log

## 2026-05-16: 选择Elasticsearch而非PostgreSQL全文搜索

**决策者**: @alice, @bob  
**影响范围**: 搜索模块

**背景**:  
需要支持中文分词、模糊匹配、相关性排序

**选项对比**:
1. PostgreSQL tsvector
   - ✅ 无需额外依赖
   - ❌ 中文分词支持弱
2. Elasticsearch
   - ✅ ik分词器成熟
   - ✅ 相关性算法完善
   - ❌ 增加运维复杂度

**决策**: 选择Elasticsearch

**理由**:
- 中文搜索质量是首要考虑
- 团队已有ES运维经验
- 未来可能扩展推荐系统

**后果**:
- 需维护ES集群
- 需实现数据同步机制
```

### 4. KNOWN_FAILURES.md

**用途**: 记录已知失败模式和解决方案,避免重复踩坑

**格式**:
```markdown
# Known Failures

## 2026-05-15: JWT secret轮换导致全站登出

**症状**:  
用户突然全部被踢出,需要重新登录

**根因**:  
Kubernetes滚动更新时,新pod生成了新的JWT secret,旧token无法验证

**解决方案**:  
将JWT secret存储在K8s Secret中,所有pod共享同一secret

**预防措施**:  
- 在 `deployment.yaml` 中挂载secret
- 添加健康检查: 验证JWT签名一致性

**相关代码**:  
`src/config/jwt.ts` line 12-18
```

### 5. session-journal/

**用途**: 记录每次会话的摘要,形成历史轨迹

**命名**: `YYYY-MM-DD-<简短描述>.md`

**示例**:
```markdown
# Session Journal: 2026-05-16 Login Feature

**会话时长**: 2小时  
**工作流**: superpowers-feature-workflow  
**模式**: Strict

## 完成的工作
- ✅ 实现POST /api/auth/login端点
- ✅ 编写12个单元测试(覆盖率95%)
- ✅ 生成JWT access token + refresh token
- ✅ 实现Remember Me功能(30天有效期)

## 关键决策
- Access token有效期: 15分钟
- Refresh token有效期: 7天,可续期
- 使用Redis存储refresh token黑名单

## 遇到的问题
1. bcrypt哈希太慢(10轮 → 改为12轮)
2. TypeScript类型推断错误(已修复)

## 学到的教训
- Spring Security的filter链顺序很重要
- 需要在测试中mock Redis连接

## 下次继续
- 前端登录页面UI
- 集成测试(完整登录流程)
```

---

## 记忆维护最佳实践

### 个人开发者

1. **首次设置花5分钟**: 认真填写 `PROJECT_CONTEXT.md`,后续节省大量时间
2. **养成记忆习惯**: 每次重要工作后用 learning workflow 记录
3. **保持记忆精炼**: 避免冗长,只保留关键信息
4. **定期清理**: 删除过时的session-journal(保留最近10-20个)

### 团队协作

1. **统一版本**: 确保团队成员使用相同版本的记忆模板
2. **Git管理**: 将 `.superpowers-memory/` 纳入版本控制(排除敏感信息)
3. **定期同步**: 当记忆模板更新时,通知团队重新初始化
4. **共享记忆**: 团队成员共享记忆,但注意排除密码/密钥

### 记忆质量控制

运行验证脚本:

```bash
# Windows
.\memory\scripts\validate-superpowers-memory.ps1 -ProjectRoot D:\my-project

# macOS/Linux
sh ./memory/scripts/validate-superpowers-memory.sh --project-root /path/to/my-project
```

检查项:
- [ ] `PROJECT_CONTEXT.md` 非空且有技术栈信息
- [ ] `CURRENT_STATE.md` 在最近7天内更新
- [ ] `DECISIONS.md` 格式正确(有日期/决策者/理由)
- [ ] `KNOWN_FAILURES.md` 包含根因和解决方案
- [ ] session-journal 命名规范

---

## 常见问题

### Q1: 记忆系统会影响性能吗?

**A**: 不会。记忆文件很小(<100KB),AI只在会话开始时读取一次,不影响日常对话速度。

### Q2: 记忆会泄露敏感信息吗?

**A**: 需要注意:
- ❌ **不要**在记忆中存储密码、API密钥、私钥
- ✅ **可以**存储技术栈、架构决策、失败模式
- 建议在 `.gitignore` 中添加:
  ```
  .superpowers-memory/USER_PROFILE.md
  .superpowers-memory/AGENT_NOTES.md
  ```

### Q3: 记忆文件太多怎么办?

**A**: 
- `PROJECT_CONTEXT.md` 和 `DECISIONS.md` 应长期保留
- `session-journal/` 可定期归档(如每月打包压缩)
- 运行清理脚本:
  ```bash
  # 保留最近30天的session-journal
  find .superpowers-memory/session-journal/ -mtime +30 -delete
  ```

### Q4: AI不读取记忆怎么办?

**A**: 检查:
1. `.superpowers-memory/` 目录是否在**项目根目录**
2. 记忆文件是否有**实际内容**(不能为空)
3. AI工具是否已**重启**以刷新文件索引
4. 在对话中明确提到:"请读取项目记忆"

### Q5: 如何从旧项目迁移记忆?

**A**: 
1. 在新项目中初始化记忆系统
2. 从旧项目的文档中提取关键信息:
   - README.md → `PROJECT_CONTEXT.md`
   - 会议纪要 → `DECISIONS.md`
   - Bug报告 → `KNOWN_FAILURES.md`
3. 手动填充到对应记忆文件

---

## 进阶用法

### 自定义记忆字段

根据项目需求,可以在记忆文件中添加自定义段落:

```markdown
# PROJECT_CONTEXT.md

## 自定义: 合规要求
- SOC2 Type II认证(2026-Q3目标)
- HIPAA合规(医疗数据处理)
- PCI-DSS Level 1(支付卡行业)

## 自定义: 性能指标
- API P95 < 200ms
- 页面加载 < 2s
- 构建时间 < 5min
```

### 记忆与OpenSpec集成

如果使用OpenSpec工作流,记忆系统会自动关联:

```markdown
# DECISIONS.md

## 2026-05-16: 采用OpenSpec管理变更

**相关OpenSpec变更**: 
- `openspec/changes/add-login-feature/proposal.md`
- `openspec/changes/add-login-feature/design.md`

**决策**: 所有新功能必须先创建OpenSpec proposal

**理由**: 
- 提高需求澄清质量
- 便于追溯决策历史
- 支持多团队协作文档化
```

### 记忆查询技巧

在对话中主动引用记忆:

```
基于 PROJECT_CONTEXT.md 中的技术栈,这个方案可行吗?

参考 KNOWN_FAILURES.md 中的JWT问题,我们该如何避免?

查看最近的 session-journal,上次登录功能做到哪了?
```

---

## 总结

记忆系统的核心价值:

✅ **减少重复沟通** - AI记得项目背景,不用每次都解释  
✅ **避免重复错误** - 已知失败模式会被主动提醒  
✅ **保持上下文连贯** - 跨会话无缝继续工作  
✅ **沉淀团队知识** - 决策和教训永久保存  
✅ **提升开发效率** - 新成员快速上手  

**三步开始**:
1. 运行初始化脚本
2. 填写 PROJECT_CONTEXT.md 和 CURRENT_STATE.md
3. 在对话中使用 `superpowers-learning` workflow 更新记忆

开始使用吧! 🚀
