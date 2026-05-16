# Design and Architecture

> 合并自：api-and-interface-design, source-driven-development, documentation-and-adrs

本skill包含三个子模块，在2-design阶段使用。

---

## API and Interface Design

### RESTful规范
- 资源命名：名词复数 `/api/v1/users`
- HTTP动词：GET/POST/PUT/PATCH/DELETE
- 状态码：200/201/400/401/403/404/500

### 请求/响应格式
```json
// 请求
{
  "name": "张三",
  "email": "zhang@example.com"
}

// 成功响应
{
  "code": 200,
  "data": {...}
}

// 错误响应
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "输入验证失败"
  }
}
```

---

## Source-Driven Development

### 核心流程
1. **读源码** - 理解现有实现
2. **找模式** - 识别项目约定
3. **扩展现有** - 基于当前架构
4. **保持一致** - 风格统一

### 实施要点
- 先搜索相关代码
- 分析调用链和依赖
- 复用现有抽象层
- 最小化改动范围

---

## Documentation and ADRs

### ADR模板
```markdown
# ADR-XXX: [标题]

## 状态
[Proposed | Accepted | Deprecated]

## 背景
[为什么需要这个决策]

## 决策
[我们决定做什么]

## 理由
- 理由1
- 理由2

## 备选方案
- 选项1：优缺点
- 选项2：优缺点

## 后果
[正面/负面影响]
```

### 必须编写ADR的场景
- 技术栈选择
- 架构决策
- 数据库schema变更
- 第三方依赖引入
