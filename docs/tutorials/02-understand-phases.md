# 教程 02: 理解阶段流程

> **学习目标**: 掌握Standard模式的7个阶段  
> **前置条件**: 已完成 [教程 01](01-first-req.md)  
> **预计时间**: 15-20分钟

---

## 🎯 场景

你要开发一个完整的功能：**用户反馈表单**。

**需求描述**:
- 在设置页面添加"意见反馈"入口
- 用户可以提交文本反馈（最多500字）
- 反馈保存到数据库
- 管理员可以在后台查看

这是一个典型的Standard模式需求，需要走完整流程。

---

## 步骤 1: 启动需求

```
Use devflow-kit. 我想在设置页面加一个用户反馈功能。
```

AI会反问澄清：

```
🔍 需求澄清

为了准确理解你的需求，请确认：

1. **反馈内容**: 
   - 仅文本？还是需要附件/截图？
   - 是否需要分类（bug/建议/其他）？

2. **存储方式**:
   - 直接存数据库？还是发送到邮箱？
   - 是否需要匿名提交？

3. **管理后台**:
   - 需要实时通知管理员吗？
   - 需要标记已读/处理状态吗？

4. **UI位置**:
   - 设置在哪个菜单下？
   - 需要单独的反馈列表页吗？

请回答以上问题，或说"按默认方案"让我推荐。
```

你回复：

```
1. 仅文本，不需要附件
2. 存数据库，可以匿名
3. 不需要实时通知，但要有未读标记
4. 放在"帮助与反馈"菜单下，需要列表页
```

---

## 步骤 2: 需求确认 (00-需求确认.md)

AI生成需求确认书：

```markdown
# 需求确认: add-feedback-form

## 一句话提案
在设置页面添加用户反馈表单，支持匿名提交文本反馈，管理员可在后台查看和管理。

## 核心价值
- 收集用户意见，改进产品
- 降低客服压力，自助反馈
- 建立用户沟通渠道

## 验收标准
- [ ] 用户可在"帮助与反馈"页面提交反馈
- [ ] 反馈限制500字以内
- [ ] 支持匿名提交
- [ ] 管理员可在后台查看所有反馈
- [ ] 反馈有未读/已读状态
- [ ] 反馈按时间倒序排列

## 非目标
- ❌ 不支持附件上传
- ❌ 不发送实时通知
- ❌ 不做情感分析

## 风险点
- ⚠️ 需要防止滥用（限流/验证码）
- ⚠️ 需要考虑数据隐私（GDPR合规）

是否确认此需求范围？[Y/n]
```

你确认：`Y`

---

## 步骤 3: 需求分析 (01-需求分析.md)

AI生成详细的需求分析：

```markdown
# 需求分析: add-feedback-form

## 用户故事

### Story 1: 普通用户提交反馈
**作为** 普通用户  
**我希望** 能在设置页面找到反馈入口并提交意见  
**以便** 向产品团队反馈问题或建议  

**验收准则**:
- Given 用户在设置页面
- When 点击"意见反馈"
- Then 显示反馈表单（文本框+提交按钮）
- And 文本框有字数提示（0/500）
- And 提交后显示成功提示

### Story 2: 管理员查看反馈
**作为** 管理员  
**我希望** 能在后台查看所有用户反馈  
**以便** 了解用户需求和问题  

**验收准则**:
- Given 管理员登录后台
- When 访问"用户反馈"页面
- Then 显示反馈列表（最新在前）
- And 每条反馈显示：内容、时间、是否已读
- And 可以点击标记为已读

## 技术约束
- 前端: Vue 3 + TypeScript
- 后端: Spring Boot + MySQL
- 数据库: feedbacks表
- API: RESTful

## 依赖项
- 需要现有的认证系统（判断是否登录）
- 需要现有的后台框架
```

---

## 步骤 4: 方案设计 (02-方案设计.md)

AI生成技术方案：

```markdown
# 方案设计: add-feedback-form

## 技术栈选择

### 前端
- **组件库**: Element Plus（项目已有）
- **表单验证**: VeeValidate
- **HTTP客户端**: Axios

### 后端
- **ORM**: MyBatis Plus
- **验证**: JSR-303 Bean Validation
- **安全**: 现有Spring Security配置

## 架构决策

### ADR-001: 数据存储方式
**决策**: 使用MySQL存储反馈  
**理由**: 
- 项目已有MySQL基础设施
- 需要结构化查询（按时间排序、筛选状态）
- 未来可能需要数据分析

**备选方案**:
- MongoDB: 更灵活，但增加运维复杂度
- 文件系统: 简单，但不利于查询和管理

### ADR-002: 防滥用策略
**决策**: IP限流 + 简单的数学验证码  
**理由**:
- 低成本实现
- 有效阻止自动化攻击
- 不影响用户体验

**备选方案**:
- reCAPTCHA: 更安全，但影响体验
- 登录才能提交: 最简单，但降低反馈率

## 数据模型

```sql
CREATE TABLE feedbacks (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    content TEXT NOT NULL COMMENT '反馈内容',
    is_anonymous BOOLEAN DEFAULT FALSE COMMENT '是否匿名',
    user_id BIGINT NULL COMMENT '用户ID（匿名时为NULL）',
    status ENUM('unread', 'read', 'resolved') DEFAULT 'unread',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_created_at (created_at DESC),
    INDEX idx_status (status)
);
```

## API设计

### POST /api/feedbacks
提交反馈

**Request**:
```json
{
  "content": "这是一个反馈",
  "isAnonymous": true
}
```

**Response**:
```json
{
  "code": 200,
  "message": "提交成功",
  "data": {
    "id": 123
  }
}
```

### GET /api/admin/feedbacks
获取反馈列表（管理员）

**Query Params**:
- `page`: 页码
- `pageSize`: 每页数量
- `status`: 状态筛选

**Response**:
```json
{
  "code": 200,
  "data": {
    "total": 100,
    "items": [...]
  }
}
```

### PATCH /api/admin/feedbacks/{id}/read
标记为已读

---

## 文件清单

**前端** (4个文件):
- `src/views/settings/FeedbackForm.vue` - 反馈表单组件
- `src/api/feedback.ts` - API调用封装
- `src/types/feedback.ts` - TypeScript类型定义
- `src/router/index.ts` - 路由配置（修改）

**后端** (5个文件):
- `src/main/java/com/example/controller/FeedbackController.java`
- `src/main/java/com/example/service/FeedbackService.java`
- `src/main/java/com/example/mapper/FeedbackMapper.java`
- `src/main/resources/mapper/FeedbackMapper.xml`
- `src/main/java/com/example/entity/Feedback.java`

**数据库** (1个文件):
- `db/migration/V001__create_feedbacks_table.sql`

**测试** (3个文件):
- `tests/unit/FeedbackForm.spec.ts`
- `tests/integration/FeedbackAPI.spec.ts`
- `tests/e2e/feedback-flow.spec.ts`

总计: 13个文件
```

---

## 步骤 5: 任务拆分 (03-任务拆分.md)

AI将方案拆分为可执行的任务：

```markdown
# 任务拆分: add-feedback-form

## Task 1: 数据库迁移
**优先级**: P0  
**预估时间**: 30分钟  

**步骤**:
1. 创建migration脚本
2. 执行migration
3. 验证表结构

**验收**: `SHOW TABLES` 能看到 feedbacks 表

---

## Task 2: 后端API实现
**优先级**: P0  
**预估时间**: 2小时  

**子任务**:
2.1 创建Entity和Mapper
2.2 实现Service层
2.3 实现Controller层
2.4 添加输入验证
2.5 编写单元测试

**验收**: 
- API能正常接收请求
- 单元测试通过率100%

---

## Task 3: 前端表单组件
**优先级**: P0  
**预估时间**: 1.5小时  

**子任务**:
3.1 创建FeedbackForm.vue
3.2 集成Element Plus表单
3.3 添加字数验证
3.4 实现提交逻辑
3.5 添加成功提示

**验收**: 
- 表单能正常提交
- 验证规则生效

---

## Task 4: 后台列表页
**优先级**: P1  
**预估时间**: 2小时  

**子任务**:
4.1 创建FeedbackList.vue
4.2 实现分页查询
4.3 实现状态筛选
4.4 实现标记已读功能
4.5 添加加载状态

**验收**: 
- 列表正常显示
- 分页和筛选正常工作

---

## Task 5: 集成测试
**优先级**: P0  
**预估时间**: 1小时  

**步骤**:
1. 编写E2E测试
2. 运行完整流程测试
3. 修复发现的问题

**验收**: E2E测试全部通过

---

## 执行顺序

```
Task 1 → Task 2 → Task 3 → Task 4 → Task 5
         ↓
      并行开发（前后端分离）
```

**建议**: 
- 先完成Task 1-2（后端基础）
- 然后Task 3（前端表单）
- 最后Task 4-5（完善和测试）

是否开始执行Task 1？[Y/n]
```

---

## 步骤 6: 逐任务执行

AI会自动进入Task 1，完成后询问是否继续Task 2，依此类推。

每个任务完成后，AI会：
1. 更新 `.specs/add-feedback-form/04-开发记录.md`
2. 运行相关测试
3. 输出任务完成报告

---

## 步骤 7: 测试与审查

所有任务完成后，AI会：

### 测试阶段 (05-测试报告.md)
```markdown
# 测试报告: add-feedback-form

## 单元测试
✅ FeedbackService: 12/12通过
✅ FeedbackController: 8/8通过
✅ FeedbackForm组件: 15/15通过

## 集成测试
✅ API端到端测试: 5/5通过
✅ 数据库操作测试: 3/3通过

## E2E测试
✅ 用户提交流程: 通过
✅ 管理员查看流程: 通过

## 性能测试
⚠️ 列表页加载时间: 450ms（目标<300ms）
  → 建议：添加数据库索引优化

## 安全测试
✅ SQL注入防护: 通过
✅ XSS防护: 通过
✅ CSRF防护: 通过
```

### 审查阶段 (06-代码审查.md)
```markdown
# 代码审查: add-feedback-form

## Spec符合度
✅ 所有验收标准已满足
✅ 无偏离原始需求

## 代码质量
✅ 命名规范
✅ 注释充分
⚠️ FeedbackService有重复代码（建议提取公共方法）

## 安全性
✅ 输入验证完整
✅ 权限控制正确
✅ 无敏感信息泄露

## 性能
⚠️ 列表查询缺少缓存（中等优先级）
✅ 数据库查询已优化

## 建议修复项
1. [中] 提取FeedbackService中的重复逻辑
2. [低] 为列表页添加Redis缓存
```

---

## 步骤 8: 集成发布 (07-发布清单.md)

```markdown
# 发布清单: add-feedback-form

## 部署前检查
- [x] 所有测试通过
- [x] 代码审查完成
- [x] Migration脚本已准备
- [x] 环境变量已配置

## 部署步骤
1. 备份数据库
2. 执行migration: `flyway migrate`
3. 部署后端服务
4. 部署前端资源
5. 验证功能正常

## 回滚方案
如果出现问题：
1. 回滚代码到上一版本
2. 不需要回滚数据库（向后兼容）
3. 验证回滚成功

## 监控指标
- 反馈提交成功率 > 99%
- API响应时间 < 200ms
- 错误率 < 1%

是否确认发布？[Y/n]
```

---

## ✅ 完成！

你已经走完完整的Standard流程。

**产物总览**:
```
.specs/add-feedback-form/
├── 00-需求确认.md
├── 01-需求分析.md
├── 02-方案设计.md
├── 03-任务拆分.md
├── 04-开发记录.md
├── 05-测试报告.md
├── 06-代码审查.md
└── 07-发布清单.md
```

---

## 🎓 学到了什么

1. **7个阶段的价值**
   - 每个阶段解决不同问题
   - 前期思考避免后期返工
   - 文档化便于追溯和协作

2. **ADR的重要性**
   - 记录为什么这样设计
   - 方便后续review和调整
   - 新成员快速理解决策背景

3. **任务拆分的技巧**
   - 小任务易于估算和执行
   - 明确的验收标准
   - 合理的优先级排序

4. **测试驱动开发**
   - 先写测试再实现
   - 保证代码质量
   - 减少回归bug

---

## 🚀 下一步

- [教程 03: 模式选择](03-fast-vs-standard.md) - 学习何时用哪种模式
- [教程 05: 记忆系统](05-memory-system.md) - 利用跨会话记忆提升效率
- [教程 06: 高级技巧](06-advanced-tips.md) - 自定义流程和扩展

---

*掌握7阶段流程，开发更高效！💪*
