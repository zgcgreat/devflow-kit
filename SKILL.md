---
name: devflow-kit
description: 整合结构化流程、工程纪律与跨会话记忆的AI编程工作流系统
---

# DevFlow Kit

> ⚠️ **本文件只是入口引导。真正执行流程必须读取 `flow/GO.md` 并严格按其步骤执行。**
>
> **不读 GO.md 直接动手 = 违反流程。**

## 唯一入口

`flow/GO.md` 是唯一路由器和流程事实源。它包含:

- 模式判定规则（Fast / Standard / Strict）
- 入场检测流程
- 路由表与 stage skill 加载对照表
- 阶段门验证规则
- 自检清单

## 模板强制规则

> **⚠️ 所有产物必须严格按模板输出**：
> - 输出前必须先读取对应模板文件（`flow/templates/*.md`）
> - 产物必须包含模板所有段落，不得省略或改写
> - 占位符（如 `<req-id>`）必须替换为实际值
> - 详见 RULES.md R13.9 / R13.10

## 执行步骤

```
1. 读取 flow/GO.md（必须，不可跳过）
2. 严格按 GO.md 的步骤执行
3. 不要凭本文件的引导内容直接开始工作
```

## 核心目录

| 文件 | 用途 |
|------|------|
| `flow/GO.md` | **唯一路由器**，必须先读 |
| `flow/RULES.md` | 全局红线与状态纪律 |
| `flow/stage-skills/` | Stage Skills（各阶段执行逻辑） |
| `flow/prompts/*.md` | 各阶段执行 prompt（后备） |
| `flow/templates/*.md` | 阶段产物模板 |
| `flow/reference/*.md` | 按需查阅的参考资料 |
| `agent-skills/skills/*/_SKILL.md` | 专业工程 skill |

## 开始

读取 `flow/GO.md`，按它完成路由、模式判定、状态检查和阶段执行。

## 版本

v1.0.0 - DevFlow Kit 初始版本
- 整合 devflow-kit v2.3 + superpowers + team-skills
- Stage Skills: v1.0.0(稳定)
- 向后兼容: 是
