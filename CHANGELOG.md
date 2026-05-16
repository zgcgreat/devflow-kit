# Changelog

所有重要变更将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

---

## [Unreleased]

### Added
- 快速索引表（GO.md）
- 记忆系统子目录 `.devflow-kit/memory/`

### Changed
- 产物目录从 `.specs/` 改为 `.devflow-kit/`
- 核心产物文件统一英文命名（STATE.md、CONTEXT.md 等）
- README.md 专业化重写（中文为主，国际化风格）
- GO.md 精简到 <200 行

### Fixed
- stage-i-intel-scan 强制中文输出规范
- stage-0-confirm 模式选择格式优化（增加理由和流程说明）
- 所有 Stage Skill 模板执行规范（read_file + 段落核对）

---

## [2.3.0] - 2026-05-16

### Added
- Stage Skill 架构（15个阶段技能）
- 三档模式系统（Fast/Standard/Strict）
- 风险评估矩阵
- 渐进式披露设计
- 弱 AI 友好机制（强制执行点 + 生成后核对）

### Changed
- 统一产物目录为 `.specs/`
- GO.md 精简版 v2.3

### Fixed
- 模板遵循问题（所有 Stage Skill 增加 read_file 强制调用）
- 中英文混杂输出问题

---

## [2.2.0] - 2026-05-10

### Added
- devflow-kit 核心工作流
- 8阶段标准流程（0-confirm → 7-integration）
- 4套原生适配器（Cursor、Claude Code、Gemini、Windsurf）

### Changed
- 整合 superpowers 工程纪律
- 整合 team-skills 记忆系统

---

## [2.1.0] - 2026-05-05

### Added
- 初始版本
- 基础流程编排
- 模板驱动开发

---

[Unreleased]: https://github.com/devflow-kit/devflow-kit/compare/v2.3.0...HEAD
[2.3.0]: https://github.com/devflow-kit/devflow-kit/releases/tag/v2.3.0
[2.2.0]: https://github.com/devflow-kit/devflow-kit/releases/tag/v2.2.0
[2.1.0]: https://github.com/devflow-kit/devflow-kit/releases/tag/v2.1.0
