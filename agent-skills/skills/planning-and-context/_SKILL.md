# Planning and Context

> 合并自：planning-and-task-breakdown, context-engineering

---

## Task Breakdown

### 拆分原则
- 每个任务≤4小时完成
- 任务之间低耦合
- 明确的验收标准

### 拆分方法
1. **按功能模块** - 前端/后端/数据库
2. **按用户故事** - 每个story独立任务
3. **按技术层次** - API/Service/Mapper

### 任务模板
```markdown
## Task X: [任务名称]
**优先级**: P0/P1/P2  
**预估时间**: X小时  

**步骤**:
1. ...
2. ...

**验收**:
- [ ] ...
```

---

## Context Engineering

### 上下文管理
- **项目状态** - `.specs/项目状态.md`
- **记忆系统** - `.specs/.memory/`
- **会话日志** - `session-journal/`

### 关键信息
1. **技术栈** - 语言、框架、工具
2. **架构** - 分层、模块划分
3. **约定** - 命名规范、代码风格
4. **约束** - 性能要求、安全要求

### 跨会话保持
- 每次会话结束更新CURRENT_STATE.md
- 重要决策记录到DECISIONS.md
- 失败经验总结到KNOWN_FAILURES.md
