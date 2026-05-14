# 教程 01: 你的第一个需求

> **学习目标**: 5分钟内完成第一个devflow-kit需求  
> **前置条件**: 已复制 devflow-kit 到项目根目录  
> **预计时间**: 5-10分钟

---

## 🎯 场景

你要修复一个按钮文案的typo（拼写错误）。

**当前状态**:
- 项目: `my-project`
- 问题: "登陆" 应该是 "登录"
- 文件: `src/components/Header.vue` 第42行

---

## 步骤 1: 启动 devflow-kit

在AI对话中输入：

```
Use devflow-kit. Fast模式：修复Header组件中"登陆"的typo，改为"登录"。
```

---

## 步骤 2: AI自动执行

AI会立即识别这是Fast模式，输出：

```
✅ 模式：Fast
✅ 改动范围：src/components/Header.vue (1文件)
✅ verify 命令：npm run lint && npm run test:unit
✅ 预期结果：lint通过，无regression

开始执行...
```

然后AI会：
1. 读取 `src/components/Header.vue`
2. 找到第42行的 "登陆"
3. 修改为 "登录"
4. 运行验证命令
5. 输出结果

---

## 步骤 3: 查看产物

AI完成后，你可以在 `.specs/` 下看到：

```
.specs/
└── fix-typo-header/          ← 自动生成的req-id
    └── 开发记录.md            ← 简要记录改动
```

打开 `开发记录.md`：

```markdown
# 开发记录: fix-typo-header

## 改动摘要
- 文件: src/components/Header.vue
- 行号: 42
- 修改: "登陆" → "登录"

## Verify 结果
✅ npm run lint: 通过
✅ npm run test:unit: 通过 (12/12)

## 完成时间
2024-01-15 14:30
```

---

## ✅ 完成！

你已经完成了第一个devflow-kit需求。

**关键点**:
- ✅ 明确说明是 Fast 模式
- ✅ 描述清楚改动内容
- ✅ AI自动处理所有流程
- ✅ 产物自动归档到 `.specs/`

---

## 🎓 学到了什么

1. **Fast模式适合小改动**
   - <50行
   - 1-2个文件
   - 低风险

2. **产物自动管理**
   - 不需要手动创建文件
   - AI自动生成 req-id
   - 所有记录保存在 `.specs/`

3. **验证很重要**
   - 即使小改动也要运行测试
   - AI会自动执行verify命令

---

## 🚀 下一步

尝试更复杂的场景：

- [教程 02: 理解阶段流程](02-understand-phases.md) - 学习Standard模式的7个阶段
- [教程 03: 模式选择](03-fast-vs-standard.md) - 何时用Fast/Standard/Strict
- [教程 04: 常见问题调试](04-debug-common-issues.md) - 解决使用中遇到的问题

---

## 💡 提示

**如果想跳过流程**:
```
Use devflow-kit. 不要走流程，直接帮我改一下这个typo。
```

**如果想看详细流程**:
```
Use devflow-kit. Standard模式：我想加一个用户反馈功能。
```

---

*恭喜完成第一个需求！🎉*
