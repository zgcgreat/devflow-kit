# Changelog

All notable changes to SuperFlow Kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-05-16

### Added

#### 核心功能
- **智能流程编排** - 整合devflow-kit的Stage Skill架构,17个阶段技能
- **工程纪律保障** - 集成superpowers的14个核心skills(TDD/brainstorming/subagent-driven等)
- **跨会话记忆系统** - .superpowers-memory/持久化上下文保持
- **风险评估矩阵** - 4维度评分自动推荐Fast/Standard/Strict模式
- **工具无关部署** - 支持Cursor/Claude Code/Gemini/Copilot等所有主流AI工具

#### Stage Skills (17个)
- stage-0-confirm (需求确认)
- stage-1-analysis (需求分析)
- stage-2-design (方案设计)
- stage-2a-ui-design (UI设计,前端专用)
- stage-3-task (任务拆分)
- stage-3a-plan (实施计划)
- stage-4-dev (TDD开发)
- stage-5-test (风险驱动测试)
- stage-6-review (五轴代码审查)
- stage-7-integration (集成归档)
- stage-a-architect (架构梳理)
- stage-a-evolve (架构演进)
- stage-i-intel-scan (入场扫描)
- stage-m-health (健康检查)
- stage-orchestrator (流程编排器)

#### Superpowers Skills (14个)
- brainstorming (苏格拉底式设计澄清)
- test-driven-development (RED-GREEN-REFACTOR)
- subagent-driven-development (并行子代理执行)
- systematic-debugging (四阶段根因追溯)
- writing-plans (实施计划编写)
- executing-plans (计划执行)
- dispatching-parallel-agents (并行代理调度)
- requesting-code-review (代码审查请求)
- receiving-code-review (接收代码审查)
- using-git-worktrees (Git工作树隔离)
- finishing-a-development-branch (分支收尾)
- verification-before-completion (完成前验证)
- writing-skills (技能编写指南)
- using-superpowers (Superpowers使用介绍)

#### Agent Skills (20个专业工程技能)
- development-core (开发核心)
- design-and-architecture (设计与架构)
- code-quality (代码质量)
- security-and-performance (安全与性能)
- frontend-ui-engineering (前端UI工程)
- debugging-and-error-recovery (调试与错误恢复)
- planning-and-context (规划与上下文)
- deprecation-and-migration (弃用与迁移)
- devops (运维)
- idea-refine (想法精炼)
- 以及更多专业领域技能...

#### 记忆系统
- PROJECT_CONTEXT.md (项目基本信息模板)
- CURRENT_STATE.md (当前工作状态模板)
- DECISIONS.md (技术决策记录模板)
- KNOWN_FAILURES.md (已知失败模式模板)
- VERIFICATION_BASELINE.md (验证基线模板)
- TEAM_PREFERENCES.md (团队偏好模板)
- USER_PROFILE.md (用户画像模板)
- AGENT_NOTES.md (AI助手笔记模板)
- session-journal/ (会话日志目录)

#### 文档
- README.md (主文档)
- docs/MEMORY_GUIDE.md (记忆系统使用指南)
- docs/QUICKSTART.md (快速上手指南)
- docs/tutorials/ (7个教程系列)
- AGENTS.md (AI助手指令入口)

#### 脚本工具
- scripts/init-project.ps1/sh (项目初始化脚本)
- scripts/build-dist.ps1 (分发包构建脚本)
- memory/scripts/install-superpowers-memory.ps1 (记忆系统安装)
- memory/scripts/validate-superpowers-memory.ps1 (记忆质量验证)
- memory/scripts/run-superpowers-memory-closeout.ps1 (记忆收尾检查)
- scripts/common/dependency-check.ps1/sh (依赖检查)

#### 工具适配器
- adapters/claude/commands/ (Claude Code斜杠命令)
- adapters/cursor/rules/ (Cursor规则文件)
- adapters/gemini/commands/ (Gemini CLI命令)
- adapters/windsurf/workflows/ (Windsurf工作流)

### Enhanced

- **mode-rules.md增强** - 添加风险评估矩阵(4维度评分+特殊规则)
- **Stage Skill依赖声明** - 每个stage skill声明dependencies,自动加载superpowers skills
- **GO.md路由器优化** - 简化执行顺序清单,强化关键检查点

### Changed

- 从三个独立项目整合为统一的SuperFlow Kit
- 统一命名规范和目录结构
- 重写README.md突出核心价值主张
- 创建AGENTS.md作为AI助手通用入口

### Technical Details

- **目录结构**: 三层架构(路由层/执行层/持久层)
- **混合调度**: Stage Skill负责流程编排,Superpowers Skills提供工程纪律
- **智能降级**: 前置产物缺失时采用合理替代方案,不阻塞流程
- **显式激活**: 工作流不会干扰正常对话,需明确引用才激活

### Migration Guide

从任一源项目迁移:

**从devflow-kit迁移**:
- 保留.flow/目录结构不变
- 新增skills/和memory/目录
- 更新SKILL.md引用路径

**从superpowers迁移**:
- skills/目录直接兼容
- 新增flow/路由器和stage-skills/
- 可选添加memory/系统

**从team-skills迁移**:
- memory/目录直接兼容
- openspec/工作流保留
- 新增flow/和skills/核心功能

---

## [Unreleased]

### Planned

- [ ] 完善IMPLEMENTATION_GUIDE.md团队部署指南
- [ ] 补充UPGRADE_ROADMAP.md升级路线图
- [ ] 添加CONTRIBUTING.md贡献指南
- [ ] 创建演示案例和测试套件
- [ ] 支持更多AI工具适配器(Zhipu AI/Copilot Studio等)
- [ ] 实现自动化测试框架
- [ ] 添加性能监控和指标收集

### Under Discussion

- 是否默认启用记忆系统?
- OpenSpec集成的渐进式采用路径
- 企业级权限管理和审计追踪
- 与CI/CD系统的深度集成

---

## Version History

| Version | Release Date | Key Features |
|---------|-------------|--------------|
| 1.0.0 | 2026-05-16 | Initial release - 三大项目整合 |

---

**Note**: This is the first official release of SuperFlow Kit, combining the best features from devflow-kit, superpowers, and superpowers-openspec-team-skills.
