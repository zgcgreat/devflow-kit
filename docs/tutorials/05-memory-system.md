# 教程 05: 记忆系统

> **学习目标**: 掌握记忆系统的配置、使用和最佳实践  
> **预计时间**: 20分钟  
> **前置知识**: 已完成教程01-04

---

## 目录

1. [什么是记忆系统](#1-什么是记忆系统)
2. [如何启用](#2-如何启用)
3. [核心文件详解](#3-核心文件详解)
4. [日常维护](#4-日常维护)
5. [跨会话实战](#5-跨会话实战)
6. [常见问题](#6-常见问题)

---

## 1. 什么是记忆系统

### 问题背景

**没有记忆系统时**:

```
会话1 (周一):
你: 我的项目用Vue 3 + TypeScript
AI: 好的，了解了。

会话2 (周二):
你: 帮我加个搜索功能
AI: 你的项目用什么技术栈？
你: 😤 Vue 3 + TypeScript啊，昨天不是说了吗？
```

**问题**: AI每次会话从零开始，重复问相同问题。

---

### 解决方案

**有记忆系统时**:

```
会话1 (周一):
你: 我的项目用Vue 3 + TypeScript
AI: ✅ 已记录到 PROJECT_CONTEXT.md

会话2 (周二):
你: 帮我加个搜索功能
AI: ✅ 读取记忆：Vue 3 + TypeScript项目
    好的，我来设计搜索组件...
```

**效果**: AI记住项目背景，效率提升40%。

---

### 记忆系统架构

```
.specs/.memory/
├── PROJECT_CONTEXT.md      # 稳定事实（很少变）
├── CURRENT_STATE.md        # 动态状态（经常变）
├── DECISIONS.md            # 关键决策
├── KNOWN_FAILURES.md       # 失败教训
└── session-journal/        # 会话日志
    ├── 2024-01-15-1430-xxx.md
    └── 2024-01-16-0900-yyy.md
```

---

## 2. 如何启用

### 方法1: 自动初始化脚本（推荐）

**Windows**:
```powershell
.\scripts\install-memory.ps1 -ProjectRoot .
```

**macOS/Linux**:
```bash
sh ./scripts/install-memory.sh --project-root .
```

**输出**:
```
✅ 创建 .specs/.memory/ 目录
✅ 生成 PROJECT_CONTEXT.md 模板
✅ 生成 CURRENT_STATE.md 模板
✅ 生成 DECISIONS.md 模板
✅ 生成 KNOWN_FAILURES.md 模板
✅ 创建 session-journal/ 目录

记忆系统已安装！请填写 PROJECT_CONTEXT.md 后开始使用。
```

---

### 方法2: 手动创建

```bash
# 创建目录结构
mkdir -p .specs/.memory/session-journal

# 复制模板
cp templates/memory/* .specs/.memory/
```

---

### 填写PROJECT_CONTEXT.md

这是最重要的文件，AI每次会话都会读取。

**示例**:

```markdown
# 项目上下文

## 基本信息
- 项目名称: E-commerce Platform
- 主要语言: TypeScript
- 创建时间: 2023-06

## 技术栈

### 前端
- 框架: Vue 3.3 + Composition API
- 构建工具: Vite 4.5
- UI库: Element Plus 2.4
- 状态管理: Pinia 2.1
- HTTP客户端: Axios 1.6

### 后端
- 框架: Spring Boot 3.1
- 数据库: MySQL 8.0
- ORM: MyBatis Plus 3.5
- 缓存: Redis 7.0

### 部署
- 容器化: Docker
- 编排: Kubernetes
- CI/CD: GitHub Actions

## 架构说明

### 整体架构
- 前后端分离
- RESTful API
- JWT认证
- 微服务架构（用户服务、商品服务、订单服务）

### 目录结构
```
src/
├── components/    # 通用组件
├── views/         # 页面组件
├── api/           # API调用
├── stores/        # Pinia stores
└── utils/         # 工具函数
```

## 代码规范

### 命名约定
- 组件: PascalCase (UserProfile.vue)
- 文件: kebab-case (user-profile.ts)
- 变量: camelCase (userName)
- 常量: UPPER_SNAKE_CASE (MAX_RETRY)

### Git提交规范
```
type(scope): subject

feat(auth): add login page
fix(cart): fix quantity validation
```

## 约束条件

### 性能要求
- 首屏加载 < 2s
- API响应 < 200ms (P95)
- 支持1000并发用户

### 安全要求
- 所有API必须鉴权
- 敏感数据加密存储
- SQL注入防护
- XSS防护

### 兼容性
- Chrome/Firefox/Safari 最新2个版本
- 移动端 iOS 15+ / Android 10+
```

**关键点**:
- 越详细越好
- 包含技术栈、架构、规范
- 这些信息AI会一直记住

---

## 3. 核心文件详解

### 3.1 PROJECT_CONTEXT.md

**用途**: 存储稳定的项目事实  
**更新频率**: 低（技术栈变更时才更新）  
**AI读取时机**: 每次会话开始

**必填段落**:
- 技术栈
- 架构说明
- 代码规范
- 约束条件

**可选段落**:
- 团队信息
- 业务领域术语
- 第三方依赖

---

### 3.2 CURRENT_STATE.md

**用途**: 跟踪当前工作状态  
**更新频率**: 高（每次会话结束更新）  
**AI读取时机**: 每次会话开始

**模板**:

```markdown
# 当前状态

## 最后更新
2024-01-15 17:30

## 活跃需求
- req-id: add-search
- 描述: 商品搜索功能
- 当前阶段: 2-design
- 进度: 60%

## 最近完成
- 2024-01-15: add-cart (购物车功能) ✅
- 2024-01-14: user-login (用户登录) ✅

## 当前焦点
完成搜索功能的方案设计，等待用户确认技术选型。

## 下一步建议
1. 确认搜索技术方案（Elasticsearch vs DB LIKE）
2. 设计搜索API接口
3. 实现前端搜索组件

## 待解决问题
- Elasticsearch集群配置未完成
- 中文分词方案待确定

## 关键决策
- 采用Elasticsearch而非DB LIKE（理由：支持模糊搜索和分词）
- 前端使用debounce 300ms（平衡响应速度和服务器负载）
```

**AI自动更新逻辑**:
- 完成req → 添加到"最近完成"
- 做出决策 → 添加到"关键决策"
- 遇到问题 → 添加到"待解决问题"

---

### 3.3 DECISIONS.md

**用途**: 记录重要技术决策  
**更新频率**: 中（有重要决策时）  
**AI读取时机**: 做类似决策时参考

**模板**:

```markdown
# 关键决策记录

## ADR-001: 采用Elasticsearch进行搜索

**日期**: 2024-01-15  
**状态**: Accepted  
**决策者**: 开发团队

### 背景
需要实现商品搜索功能，支持模糊搜索和中文分词。

### 选项
1. **DB LIKE查询**
   - 优点: 简单，无需额外依赖
   - 缺点: 不支持分词，性能差

2. **Elasticsearch**
   - 优点: 支持分词、模糊搜索、高性能
   - 缺点: 需要额外部署和维护

### 决策
选择 Elasticsearch

### 理由
- 业务需要模糊搜索和中文分词
- 预期搜索量大，需要高性能
- 团队已有ES运维经验

### 后果
- ✅ 搜索体验好
- ✅ 支持复杂查询
- ❌ 增加运维成本
- ❌ 需要学习ES配置

### 参考
- [ES官方文档](https://www.elastic.co/guide/)
- ADR-001-detail.md
```

---

### 3.4 KNOWN_FAILURES.md

**用途**: 记录失败经验和教训  
**更新频率**: 低（遇到新问题时）  
**AI读取时机**: 类似问题出现时警告

**模板**:

```markdown
# 已知失败模式

## Failure-001: ES索引映射错误导致中文分词失败

**日期**: 2024-01-15  
**严重性**: High  
**影响范围**: 搜索功能

### 问题描述
创建ES索引时使用了默认analyzer，导致中文无法正确分词。

### 根本原因
未指定ik_max_word analyzer。

### 解决方案
```json
{
  "settings": {
    "analysis": {
      "analyzer": {
        "default": {
          "type": "ik_max_word"
        }
      }
    }
  }
}
```

### 教训
- 创建索引前必须先写测试验证分词效果
- 不要在生产环境直接修改索引映射

### 预防措施
- 建立ES索引migration流程
- 添加分词单元测试

### 相关文档
- tests/search-tokenizer.spec.ts
- docs/es-index-setup.md
```

---

### 3.5 Session Journal

**用途**: 记录每次会话的详细过程  
**更新频率**: 每次长会话（>1小时）  
**AI读取时机**: 回顾历史会话时

**自动生成**:
- 文件名: `YYYY-MM-DD-HHMM-简短描述.md`
- 位置: `.specs/.memory/session-journal/`

**内容**:
- 会话目标
- 关键活动（时间线）
- 产出物列表
- 关键决策
- 遇到的问题
- 验证结果
- 经验提炼

---

## 4. 日常维护

### 每日任务（2分钟）

1. **检查CURRENT_STATE.md**
   ```
   你: 更新当前状态
   
   AI: ✅ 已更新
   - 最近完成: add-search
   - 当前焦点: [下一个任务]
   ```

2. **补充重要决策**
   ```
   你: 记录决策：采用Redis缓存热点数据
   
   AI: ✅ 已添加到 DECISIONS.md
   ```

---

### 每周任务（10分钟）

1. **审查KNOWN_FAILURES.md**
   - 本周遇到的新问题是否已记录
   - 旧的失败模式是否有新的解决方案

2. **清理Session Journal**
   - 归档超过30天的日志
   - 删除临时文件

---

### 每月任务（30分钟）

1. **更新PROJECT_CONTEXT.md**
   - 技术栈是否有变化
   - 架构是否有调整
   - 团队规范是否有更新

2. **统计记忆系统效果**
   - AI重复提问次数（应该减少）
   - 跨会话效率提升（应该增加）

---

## 5. 跨会话实战

### 场景1: 第二天继续工作

**会话1 (周一)**:
```
你: Use devflow-kit. 我想加个搜索功能。

AI: ✅ 路由: 0-confirm
    ...
    ✅ 完成 01-需求分析.md
    
📝 记忆更新
已更新 CURRENT_STATE.md:
- 活跃需求: add-search
- 当前阶段: 1-analysis → 2-design
```

**会话2 (周二)**:
```
你: Use devflow-kit. 继续

AI: ✅ 读取记忆系统
    - PROJECT_CONTEXT.md: Vue 3 + TypeScript项目
    - CURRENT_STATE.md: add-search在2-design阶段
    
✅ 路由: 2-design（继续add-search）
✅ 第一动作: 加载昨天的设计方案，继续技术选型
```

**效果**: AI立即知道上下文，不用重新说明。

---

### 场景2: 一周后回顾

**会话 (下周一)**:
```
你: 上周做的搜索功能怎么样了？

AI: ✅ 读取记忆
    - CURRENT_STATE.md: add-search已完成
    - session-journal: 找到上周的会话日志
    
📊 搜索功能状态

完成情况: ✅ 已完成
- 完成时间: 2024-01-15
- 总耗时: 4小时
- 改动文件: 5个
- 测试通过率: 100%

关键决策:
- 采用Elasticsearch
- 前端debounce 300ms

遇到的问题:
- ES索引映射错误（已解决）

详见: session-journal/2024-01-15-1430-add-search.md
```

---

### 场景3: 团队协作

**开发者A (周一)**:
```
你: 我完成了搜索API，记录一下

AI: ✅ 更新 CURRENT_STATE.md
    - 当前阶段: 4-dev → 5-test
    - 下一步: 前端开发
```

**开发者B (周二)**:
```
你: Use devflow-kit. 我要做搜索前端

AI: ✅ 读取记忆
    - CURRENT_STATE.md: API已完成，前端待开发
    - PROJECT_CONTEXT.md: Vue 3 + Element Plus
    
✅ 路由: 4-dev（实现搜索前端组件）
✅ 第一动作: 查看API文档，设计组件接口
```

**效果**: 团队成员共享上下文，无缝协作。

---

## 6. 常见问题

### Q1: 记忆文件会污染Git吗？

**A**: 取决于你的策略：

**个人项目**:
```gitignore
.specs/.memory/  # 全部忽略
```

**团队项目**:
```gitignore
.specs/.memory/session-journal/  # 只忽略日志
# 提交其他记忆文件，共享上下文
```

---

### Q2: AI会误更新记忆吗？

**A**: 有可能。缓解措施：

1. **关键更新需确认**
   ```
   AI: 📝 建议更新 CURRENT_STATE.md
   
   添加决策: 采用Elasticsearch
   
   确认吗？
   1. ✅ 确认
   2. 取消
   ```

2. **定期审查**
   - 每周检查一次记忆文件
   - 纠正错误的记录

---

### Q3: 记忆系统和上下文.md有什么区别？

**A**: 

| 特性 | PROJECT_CONTEXT.md | 上下文.md |
|------|-------------------|----------|
| 位置 | .specs/.memory/ | .specs/ |
| 内容 | 稳定事实 | 项目概况 |
| 更新 | 手动 | AI自动 |
| 用途 | 跨会话保持 | 单会话参考 |

**建议**: 两者都保留，互补使用。

---

### Q4: Session Journal太多怎么办？

**A**: 定期归档：

```bash
# 归档30天前的日志
sh ./scripts/archive-session-journal.sh --days 30
```

或手动删除：
```bash
rm .specs/.memory/session-journal/2023-*.md
```

---

### Q5: 如何备份记忆系统？

**A**: 

**方法1: Git**
```bash
git add .specs/.memory/
git commit -m "backup memory system"
```

**方法2: 手动备份**
```bash
cp -r .specs/.memory/ backup/memory-2024-01-15/
```

---

## 7. 最佳实践总结

### DO ✅

1. **首次设置花10分钟** - 详细填写PROJECT_CONTEXT.md
2. **每次会话结束更新** - 让AI自动更新CURRENT_STATE.md
3. **重要决策立即记录** - 不要等到后面才补
4. **定期审查和清理** - 保持记忆文件准确
5. **团队共享上下文** - 提交记忆文件到Git

---

### DON'T ❌

1. **不要留空PROJECT_CONTEXT.md** - AI需要这些信息
2. **不要忽略更新提示** - 及时更新CURRENT_STATE.md
3. **不要删除旧日志** - 先归档再删除
4. **不要让AI随意修改** - 关键更新要确认
5. **不要过度依赖** - 重要的还是要口头沟通

---

## 8. 效果评估

### 指标

| 指标 | 无记忆系统 | 有记忆系统 | 改善 |
|------|-----------|-----------|------|
| 重复提问次数/天 | 10次 | 2次 | -80% |
| 跨会话启动时间 | 10分钟 | 2分钟 | -80% |
| 用户满意度 | 3.5/5 | 4.5/5 | +29% |

---

**下一步**: [教程 06: 高级技巧](06-advanced-tips.md)
