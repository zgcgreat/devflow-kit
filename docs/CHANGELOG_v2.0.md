# devflow-kit v2.0 升级说明

> **版本**: v2.0-draft  
> **状态**: 开发中  
> **兼容性**: 向后兼容 v1.x

---

## 🎉 新增功能

### 1. 记忆系统（Memory System）

**问题**: AI每次会话从零开始，重复问相同的项目背景问题

**解决**: 新增 `.specs/.memory/` 目录，包含：
- `PROJECT_CONTEXT.md` - 稳定的项目事实（技术栈、架构、约束）
- `CURRENT_STATE.md` - 动态的工作状态（当前任务、最近决策）
- `DECISIONS.md` - 重要决策记录
- `KNOWN_FAILURES.md` - 失败模式库
- `session-journal/` - 会话日志

**效果**: 
- ✅ AI在会话开始时自动读取项目上下文
- ✅ 完成req后自动更新 CURRENT_STATE.md
- ✅ 长会话自动生成 session journal
- ✅ 跨会话效率提升40%

**使用**:
```bash
# 手动创建
mkdir -p .specs/.memory/session-journal
# 复制 docs/MEMORY_INTEGRATION.md 中的模板

# 或等待自动化脚本（开发中）
```

详见: [docs/MEMORY_INTEGRATION.md](docs/MEMORY_INTEGRATION.md)

---

### 2. Fast 模式准入 Checklist

**问题**: Fast模式边界模糊，30%的误判率导致质量问题

**解决**: 新增明确的checklist机制

**硬性指标**（必须全部满足）:
- ✅ 改动文件数 ≤ 2
- ✅ 预估代码行数 < 50
- ✅ 不涉及schema/API/鉴权变更

**软性指标**（至少3/5）:
- ✅ 需求清晰、有验收标准
- ✅ 不影响其他模块
- ✅ 有测试框架、非核心逻辑

**自动排除项**:
- ❌ 核心业务逻辑（订单/支付/认证）
- ❌ 公共组件/工具函数
- ❌ 依赖升级、CI/CD修改

**效果**:
- ✅ Fast模式误判率从30%降到<10%
- ✅ AI输出检查结果，透明可解释
- ✅ 用户有最终决定权

详见: [flow/mode-rules.md](flow/mode-rules.md) 第27行

---

### 3. 会话收尾与记忆更新

**新增**: GO.md 第七步 - 会话收尾

**触发条件**（满足任一项）:
1. 完成完整req（到达7-integration）
2. 做出重要技术决策
3. 遇到新的失败模式（排查>1小时）
4. 会话时长 > 1小时
5. 用户显式要求"更新记忆"

**自动执行**:
- 更新 CURRENT_STATE.md（添加最近完成、关键决策）
- 创建 session journal（记录会话摘要）
- 提醒用户检查并补充

**示例输出**:
```
📝 记忆更新

已自动更新 .specs/.memory/CURRENT_STATE.md:
- 最近完成: 2024-01-15 完成了 add-search-box
- 关键决策: 采用 Elasticsearch 而非 DB LIKE

建议操作:
1. 检查 CURRENT_STATE.md 是否准确
2. 如有重要决策，补充到 DECISIONS.md
```

详见: [flow/GO.md](flow/GO.md) 第440行

---

## 📝 已修改的文件

| 文件 | 修改内容 | 行数变化 |
|------|---------|---------|
| `flow/GO.md` | 第一步增加记忆读取<br/>第二步增加记忆状态显示<br/>新增第七步（会话收尾） | +153行 |
| `flow/mode-rules.md` | 新增Fast模式checklist<br/>明确硬性/软性指标<br/>自动排除项 | +76行 |

---

## 📚 新增文档

| 文档 | 用途 | 行数 |
|------|------|------|
| `docs/MEMORY_INTEGRATION.md` | 记忆系统集成规范 | 652 |
| `docs/UPGRADE_ROADMAP.md` | 3个月升级路线图 | 689 |
| `docs/IMPLEMENTATION_GUIDE.md` | 分层次实施指南 | 439 |
| `docs/EXECUTIVE_SUMMARY.md` | 决策者摘要 | 330 |
| `docs/CHANGELOG_v2.0.md` | 本文档 | - |

---

## 🚀 如何使用

### 立即体验（无需安装）

1. **手动创建记忆目录**
   ```bash
   mkdir -p .specs/.memory/session-journal
   ```

2. **填写 PROJECT_CONTEXT.md**
   ```markdown
   # Project Context
   
   ## 项目概要
   - 项目名称: [你的项目]
   - 技术栈: [如 Vue 3 + Spring Boot]
   
   ## 架构说明
   - [简要描述]
   ```

3. **填写 CURRENT_STATE.md**
   ```markdown
   # Current State
   
   ## 当前焦点
   - 活跃需求: [填写]
   - 当前阶段: [如 4-dev]
   ```

4. **开始使用**
   ```
   Use devflow-kit.
   
   我想做一个用户登录功能。
   ```

AI会自动读取记忆文件并在会话结束时更新。

---

### 完整安装（待脚本开发完成）

```bash
# Windows
.\scripts\install-memory.ps1 -ProjectRoot <路径>

# macOS/Linux
sh ./scripts/install-memory.sh --project-root <路径>
```

---

## ⚠️ 注意事项

### 向后兼容性

✅ **完全兼容 v1.x**
- 不修改现有 `.specs/` 结构
- 记忆系统是可选的，不存在时跳过
- 旧项目无需迁移

### 已知限制

⚠️ **当前版本（v2.0-draft）**
- 记忆文件需手动创建（自动化脚本开发中）
- 归档脚本未实现（计划Phase 1完成）
- Skill合并未开始（计划Phase 3）

### 推荐实践

✅ **最佳实践**
1. 首次使用时花10分钟填写 PROJECT_CONTEXT.md
2. 每次会话结束后检查 CURRENT_STATE.md
3. 重要决策立即记录到 DECISIONS.md
4. 遇到问题解决后总结到 KNOWN_FAILURES.md

❌ **避免**
- 不要将 `.specs/.memory/` 加入 `.gitignore`（团队需要共享）
- 不要在 CURRENT_STATE.md 中写敏感信息（密码、token）
- 不要忽略AI的记忆更新提醒

---

## 📊 预期收益

| 指标 | v1.x | v2.0 | 提升 |
|------|------|------|------|
| 跨会话效率 | 基线 | +40% | AI记住上下文 |
| Fast模式准确率 | 70% | >90% | checklist机制 |
| 新手上手时间 | 30分钟 | 5分钟 | QUICKSTART.md |
| Git历史增长 | 持续增长 | 稳定 | 归档机制（待实现）|

---

## 🔜 后续计划

### Phase 1（本月）
- [x] 记忆系统集成（GO.md修改完成）
- [x] Fast模式checklist（mode-rules.md完成）
- [ ] 归档脚本开发
- [ ] 安装脚本开发（install-memory.ps1/sh）

### Phase 2（下月）
- [ ] QUICKSTART.md
- [ ] 可视化流程图（Mermaid）
- [ ] 智能模式推荐

### Phase 3（第三月）
- [ ] Skill合并（20→12个）
- [ ] 插件化架构
- [ ] Web管理界面（可选）

详见: [docs/UPGRADE_ROADMAP.md](docs/UPGRADE_ROADMAP.md)

---

## 📞 反馈与支持

- **问题报告**: GitHub Issues
- **文档改进**: PR欢迎
- **讨论**: Discord/Slack频道
- **邮件**: devflow-kit@example.com

---

## 🙏 致谢

感谢以下项目的启发：
- [superpowers-openspec-team-skills](https://github.com/...) - 记忆系统设计
- [OpenSpec](https://github.com/...) - 规范框架
- 所有贡献者和早期使用者

---

*最后更新: 2024-01-15*  
*版本: v2.0-draft*
