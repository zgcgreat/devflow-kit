# Development Core

> 合并自：incremental-implementation, spec-driven-development, doubt-driven-development

---

## Spec-Driven Development

### 核心理念
先写规格，再写代码。确保需求清晰、验收标准明确。

### 流程
1. **需求确认** - 00-需求确认.md
2. **需求分析** - 01-需求分析.md（用户故事+验收准则）
3. **方案设计** - 02-方案设计.md（技术选型+ADR）
4. **任务拆分** - 03-任务拆分.md
5. **逐任务实现** - TDD循环

---

## Incremental Implementation

### 增量开发原则
- 小步快跑，频繁提交
- 每个commit可独立运行
- 持续集成，及时反馈

### 实施步骤
1. **MVP优先** - 先实现核心功能
2. **逐步完善** - 添加边界处理
3. **优化重构** - 保持代码质量

### Commit频率
- 每完成一个小功能就commit
- 每次commit不超过200行
- commit message清晰描述改动

---

## Doubt-Driven Development

### 核心理念
遇到疑问立即记录，不假设、不猜测。

### 实施方法
1. **记录疑问** - 在代码注释或文档中标记TODO
2. **验证假设** - 通过测试或文档确认
3. **消除不确定性** - 咨询团队或查阅资料

### 常见疑问类型
- 需求不明确 → 找产品经理确认
- 技术方案不确定 → 写POC验证
- API使用不清楚 → 查官方文档
- 边界条件未知 → 写测试探索
