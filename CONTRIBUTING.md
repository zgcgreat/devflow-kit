# 贡献指南

感谢你对 DevFlow Kit 的兴趣！我们欢迎所有形式的贡献。

---

## 📋 目录

- [行为准则](#行为准则)
- [如何贡献](#如何贡献)
- [开发流程](#开发流程)
- [提交规范](#提交规范)
- [代码审查](#代码审查)
- [发布流程](#发布流程)

---

## 行为准则

本项目采用 [Contributor Covenant](https://www.contributor-covenant.org/) 行为准则。请尊重所有参与者，营造友好、包容的社区环境。

---

## 如何贡献

### 1. 报告 Bug

在 [Issues](https://github.com/devflow-kit/devflow-kit/issues) 中创建 Bug 报告，包含：
- 清晰的问题描述
- 复现步骤
- 预期行为 vs 实际行为
- 环境信息（AI 工具版本、操作系统等）

### 2. 提出新功能

先在 Issues 中讨论新功能想法，确认方向后再开始开发。

### 3. 提交代码

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'feat: add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

---

## 开发流程

### 前置要求

- Node.js >= 18
- Git
- 任意 AI 编程工具（Cursor、Claude Code、Gemini CLI 等）

### 本地测试

```bash
# 克隆仓库
git clone https://github.com/your-username/devflow-kit.git
cd devflow-kit

# 在你的项目中测试
cp -r flow /your/project/.devflow-kit/flow
```

### 运行示例

在你的 AI 工具中：
```
Use devflow-kit.

我要添加一个用户认证功能
```

---

## 提交规范

我们遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

### 类型

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具变动

### 示例

```bash
feat: add stage-8-deployment skill
fix: correct template path in GO.md
docs: update README with new examples
refactor: simplify mode selection logic
```

---

## 代码审查

所有 Pull Request 都需要至少一位维护者审查。

### 审查要点

- [ ] 代码符合项目风格
- [ ] 新增功能有测试覆盖
- [ ] 文档已更新
- [ ] 变更日志已记录
- [ ] 向后兼容性保持

### 合并标准

- ✅ 通过所有自动化检查
- ✅ 至少 1 位维护者批准
- ✅ 无未解决的评论

---

## 发布流程

### 版本号规则

遵循 [语义化版本](https://semver.org/lang/zh-CN/)：

- **MAJOR**: 不兼容的 API 变更
- **MINOR**: 向后兼容的功能新增
- **PATCH**: 向后兼容的 Bug 修复

### 发布步骤

1. 更新 `CHANGELOG.md`
2. 更新版本号（README.md badges）
3. 创建 Git tag (`git tag v2.4.0`)
4. 推送 tag (`git push origin v2.4.0`)
5. 在 GitHub 创建 Release

---

## 文档规范

### 文件名

- 核心产物文件使用英文（STATE.md、CONTEXT.md 等）
- 其他文档以中文为主

### 内容语言

- 描述性文字统一使用中文
- 技术术语保留英文原名（Node.js、TypeScript、React 等）
- 禁止中英文混杂的描述句

### 格式

- 不使用 Mermaid 图表（改用纯文本流程图）
- 代码块指定语言类型
- 表格对齐清晰

---

## 常见问题

### Q: 如何测试我的改动？

A: 在实际项目中复制 `flow/` 目录，用 AI 工具执行完整工作流，验证各阶段产物是否正确生成。

### Q: 我可以添加新的 Stage Skill 吗？

A: 可以！请先在 Issues 中讨论设计思路，确保与现有架构兼容。

### Q: 如何报告安全问题？

A: 请发送邮件至 security@devflow-kit.org，不要在公开 Issues 中披露安全漏洞。

---

## 致谢

感谢所有贡献者让 DevFlow Kit 变得更好！

<a href="https://github.com/devflow-kit/devflow-kit/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=devflow-kit/devflow-kit" />
</a>

---

**有问题？** 在 [Discussions](https://github.com/devflow-kit/devflow-kit/discussions) 中提问，或加入我们的 Discord 社区。
