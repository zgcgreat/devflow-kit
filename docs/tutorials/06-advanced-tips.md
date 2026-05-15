# 教程 06: 高级技巧

> **学习目标**: 掌握自定义、扩展和集成的高级用法  
> **预计时间**: 25分钟  
> **前置知识**: 已完成教程01-05

---

## 目录

1. [自定义Prompt模板](#1-自定义prompt模板)
2. [添加自己的Skill](#2-添加自己的skill)
3. [与CI/CD集成](#3-与cicd集成)
4. [团队协作最佳实践](#4-团队协作最佳实践)
5. [性能优化](#5-性能优化)

---

## 1. 自定义Prompt模板

### 为什么要自定义？

默认模板是通用设计，可能不适合你的项目：
- 你有特殊的代码规范
- 你需要额外的审查项
- 你想简化某些阶段

---

### 方法1: 修改现有模板

**位置**: `flow/templates/*.md`

**示例**: 修改需求确认模板，增加业务影响评估

```markdown
# 00-需求确认.md（自定义版）

## 必填段落清单
- [ ] 一句话提案
- [ ] 影响面判定
- [ ] **业务价值评估** (新增)
- [ ] **风险评估** (新增)

## 一句话提案
...

## 影响面判定
...

## 业务价值评估 (新增)
**用户受益**: <描述用户如何受益>
**商业价值**: <对业务的贡献>
**优先级理由**: <为什么现在做>

## 风险评估 (新增)
**技术风险**: <可能的技术问题>
**业务风险**: <对业务的影响>
**缓解措施**: <如何降低风险>
```

**使用**: AI会自动读取新模板并按此输出。

---

### 方法2: 创建新模板

**场景**: 你有特殊的需求类型

**步骤**:

1. **创建模板文件**
   ```
   flow/templates/00-需求确认-AI功能.md
   ```

2. **定义特殊结构**
   ```markdown
   # 00-需求确认-AI功能.md
   
   ## 必填段落清单
   - [ ] 一句话提案
   - [ ] AI模型选择
   - [ ] 数据隐私说明
   - [ ] 伦理风险评估
   
   ## AI模型选择
   **候选模型**:
   - GPT-4
   - Claude
   - 本地模型
   
   **选择理由**: ...
   
   ## 数据隐私说明
   **数据类型**: ...
   **存储方式**: ...
   **合规性**: GDPR/CCPA
   
   ## 伦理风险评估
   **潜在偏见**: ...
   **缓解措施**: ...
   ```

3. **在GO.md中添加路由规则**
   ```markdown
   | 用户说 | 路由到 | 模板 |
   |--------|--------|------|
   | "AI功能" | 0-confirm | 00-需求确认-AI功能.md |
   ```

---

### 方法3: 条件化模板

**场景**: 根据项目类型使用不同模板

**实现**:

```markdown
## 模板选择逻辑

IF 项目类型 == "前端":
  使用 templates/00-需求确认-前端.md
ELSE IF 项目类型 == "后端":
  使用 templates/00-需求确认-后端.md
ELSE:
  使用 templates/00-需求确认.md (默认)
```

**前端模板特色**:
- 增加UI/UX评估
- 增加浏览器兼容性检查
- 增加无障碍访问要求

**后端模板特色**:
- 增加API设计规范
- 增加数据库变更评估
- 增加安全性审查

---

## 2. 添加自己的Skill

### 什么是Skill？

Skill是专业知识的模块化封装，告诉AI如何做特定任务。

**现有Skill示例**:
- `design-and-architecture` - 如何设计系统
- `testing-suite` - 如何测试
- `code-quality` - 如何保证代码质量

---

### 创建新Skill的步骤

#### Step 1: 确定Skill用途

**示例**: 创建一个"国际化(i18n)" Skill

**用途**: 指导AI如何实现多语言支持

---

#### Step 2: 创建目录结构

```
agent-skills/skills/i18n-internationalization/
└── _SKILL.md
```

---

#### Step 3: 编写Skill内容

```markdown
# i18n Internationalization

## 核心原则

### 1. 文本外部化
**禁止硬编码文本**:
```vue
<!-- ❌ Bad -->
<button>Submit</button>

<!-- ✅ Good -->
<button>{{ $t('submit') }}</button>
```

### 2. 使用标准库
- Vue: vue-i18n
- React: react-intl
- Angular: @angular/localize

### 3. 语言文件组织
```
locales/
├── en.json
├── zh-CN.json
└── ja.json
```

## 实施流程

### Phase 1: 准备
1. 安装i18n库
2. 配置语言切换器
3. 创建语言文件骨架

### Phase 2: 提取文本
1. 扫描所有组件
2. 提取硬编码文本
3. 生成翻译键

### Phase 3: 翻译
1. 填充默认语言(en)
2. 翻译其他语言
3. 验证翻译完整性

### Phase 4: 测试
1. 切换语言测试
2. 检查文本溢出
3. 验证RTL支持(如需要)

## 常见问题

### Q1: 如何处理动态文本？
```javascript
// ✅ Good
$t('welcome', { name: userName })

// 语言文件
{
  "welcome": "Welcome, {name}!"
}
```

### Q2: 如何处理复数？
```javascript
// ✅ Good
$t('items', { count: itemCount })

// 语言文件
{
  "items": "{count} item | {count} items"
}
```

### Q3: 如何处理日期/数字格式？
```javascript
// ✅ Good
{{ $d(date, 'long') }}
{{ $n(price, 'currency') }}
```

## 检查清单

- [ ] 所有文本已外部化
- [ ] 语言文件完整
- [ ] 语言切换器工作正常
- [ ] 文本无溢出
- [ ] 日期/数字格式正确
- [ ] RTL支持(如需要)
```

---

#### Step 4: 在GO.md中注册

```markdown
### 阶段与 skill 加载对照表

| 阶段 | 必须加载的 skill |
|------|------------------|
| 2-design | design-and-architecture, **i18n-internationalization** (如需i18n) |
```

---

#### Step 5: 使用Skill

```
你: Use devflow-kit. 我要实现多语言支持。

AI: ✅ 检测到i18n需求
    ✅ 加载 i18n-internationalization skill
    
✅ 路由: 2-design
✅ 第一动作: 按i18n skill指导，选择i18n库并设计方案
```

---

### Skill设计原则

1. **单一职责** - 一个Skill只做一件事
2. **可操作性** - 提供具体步骤，不只是理论
3. **示例丰富** - 包含好/坏对比
4. **检查清单** - 便于验证完成度
5. **长度适中** - 50-100行最佳

---

## 3. 与CI/CD集成

### 目标

自动化执行devflow-kit的质量检查：
- 产物完整性检查
- 模板合规性验证
- 代码质量扫描

---

### 集成方案1: GitHub Actions

**文件**: `.github/workflows/devflow-check.yml`

```yaml
name: DevFlow Kit Check

on:
  pull_request:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Check .specs/ structure
        run: |
          # 检查是否有活跃的req
          if [ -d ".specs" ]; then
            echo "✅ .specs/ directory exists"
            
            # 检查产物完整性
            for req_dir in .specs/*/; do
              req_id=$(basename "$req_dir")
              echo "Checking $req_id..."
              
              required_files=(
                "00-需求确认.md"
                "01-需求分析.md"
                "02-方案设计.md"
                "03-任务拆分.md"
              )
              
              for file in "${required_files[@]}"; do
                if [ ! -f "$req_dir/$file" ]; then
                  echo "❌ Missing: $file"
                  exit 1
                fi
              done
              
              echo "✅ $req_id complete"
            done
          fi
      
      - name: Run code quality checks
        run: |
          npm run lint
          npm run test
```

---

### 集成方案2: Git Hook

**文件**: `.git/hooks/pre-commit`

```bash
#!/bin/bash

# 检查是否有未完成的req
if [ -d ".specs" ]; then
  active_reqs=$(find .specs -maxdepth 1 -type d -not -name ".specs" -not -name "archive" | wc -l)
  
  if [ $active_reqs -gt 0 ]; then
    echo "⚠️  Warning: You have $active_reqs active req(s)"
    echo "Consider completing or archiving them before committing."
    echo ""
    
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  fi
fi

# 检查产物格式
python scripts/validate-specs.py

exit 0
```

---

### 集成方案3: 自定义脚本

**文件**: `scripts/validate-specs.py`

```python
#!/usr/bin/env python3
"""Validate .specs/ directory structure and content."""

import os
import sys
from pathlib import Path

def validate_req(req_path: Path) -> bool:
    """Validate a single req directory."""
    required_files = [
        "00-需求确认.md",
        "01-需求分析.md",
        "02-方案设计.md",
        "03-任务拆分.md",
    ]
    
    missing = []
    for file in required_files:
        if not (req_path / file).exists():
            missing.append(file)
    
    if missing:
        print(f"❌ {req_path.name}: Missing {missing}")
        return False
    
    print(f"✅ {req_path.name}: Complete")
    return True

def main():
    specs_dir = Path(".specs")
    
    if not specs_dir.exists():
        print("ℹ️  No .specs/ directory found")
        return 0
    
    errors = 0
    for req_dir in specs_dir.iterdir():
        if req_dir.is_dir() and req_dir.name not in ["archive", ".memory"]:
            if not validate_req(req_dir):
                errors += 1
    
    if errors > 0:
        print(f"\n❌ Found {errors} incomplete req(s)")
        return 1
    
    print("\n✅ All reqs are complete")
    return 0

if __name__ == "__main__":
    sys.exit(main())
```

**使用**:
```bash
python scripts/validate-specs.py
```

---

## 4. 团队协作最佳实践

### 4.1 Git策略

#### 分支策略

```
main (protected)
├── develop
│   ├── feature/add-search (devflow-kit managed)
│   ├── feature/user-profile
│   └── hotfix/login-bug
```

**规则**:
- 每个feature分支对应一个req
- 分支名与req-id一致
- 合并前必须完成所有阶段

---

#### Commit策略

```bash
# 每个阶段完成后commit
git add .specs/add-search/00-需求确认.md
git commit -m "docs: complete 00-需求确认 for add-search"

git add .specs/add-search/01-需求分析.md
git commit -m "docs: complete 01-需求分析 for add-search"

# 开发完成后
git add src/
git add tests/
git commit -m "feat: implement search feature (add-search)"

# 最终合并
git add .specs/add-search/
git commit -m "docs: complete all phases for add-search"
```

---

### 4.2 Code Review流程

#### Reviewer检查清单

```markdown
## DevFlow Kit Review Checklist

### 产物完整性
- [ ] 00-需求确认.md 存在且完整
- [ ] 01-需求分析.md 包含用户故事和AC
- [ ] 02-方案设计.md 包含ADR和技术选型
- [ ] 03-任务拆分.md 任务粒度合理
- [ ] 05-测试报告.md 测试覆盖率达标
- [ ] 06-代码审查.md 问题已修复

### 流程合规性
- [ ] 没有跳级（或已记录原因）
- [ ] 模式选择合理
- [ ] ADR记录了关键决策

### 代码质量
- [ ] 代码符合项目规范
- [ ] 测试通过
- [ ] 无安全漏洞
```

---

### 4.3 知识共享

#### 定期分享会

**频率**: 每两周一次  
**时长**: 30分钟  
**内容**:
- 展示最近完成的req
- 分享遇到的问题和解决方案
- 讨论流程改进建议

---

#### 建立知识库

**位置**: `docs/devflow-examples/`

**结构**:
```
docs/devflow-examples/
├── good-reqs/           # 优秀案例
│   ├── add-search/
│   └── user-auth/
├── common-mistakes/     # 常见错误
│   ├── skipped-analysis.md
│   └── poor-ac.md
└── tips-tricks/         # 技巧汇总
    └── fast-mode-tips.md
```

---

### 4.4 指标追踪

#### 团队看板

**指标**:
- 平均req完成时间
- 返工率
- 测试覆盖率
- Code Review通过率

**工具**:
- GitHub Projects
- Jira
- 自定义Dashboard

---

## 5. 性能优化

### 5.1 Token优化

#### 问题

大型项目reference文档很多，容易超限。

---

#### 解决方案1: 按需加载

```markdown
# ❌ Bad: 整读
read_file path="tech-stacks.md"  # 500行

# ✅ Good: 按节读取
grep_search Query="Vue" SearchPath="tech-stacks.md"
# 找到line 120
read_file path="tech-stacks.md" offset=120 limit=30
```

---

#### 解决方案2: 拆分大文件

```
tech-stacks.md (500行)
↓ 拆分为
tech-stacks/
├── frontend.md (150行)
├── backend.md (200行)
└── devops.md (150行)
```

---

#### 解决方案3: 缓存常用内容

**实现**:
```markdown
## 第五步 · 显式声明执行计划

如果某个reference频繁使用（如上下文.md），可以：

1. 首次会话全读
2. 后续会话只读变化部分
3. 或使用summary版本
```

---

### 5.2 速度优化

#### 并行处理

**场景**: 多个任务可以并行

```markdown
## Task拆分

T01: 实现搜索API (后端)
T02: 实现搜索组件 (前端)
T03: 编写单元测试

→ T01和T02可以并行开发
```

**AI指令**:
```
你可以同时开始T01和T02，我分别给你上下文。
```

---

#### 增量更新

**场景**: 只需修改部分内容

```markdown
# ❌ Bad: 重新生成整个文件
请重新生成 02-方案设计.md

# ✅ Good: 增量更新
请修改 02-方案设计.md 的「技术选型」章节，
将MySQL改为PostgreSQL
```

---

### 5.3 存储优化

#### 归档策略

```bash
# 每月执行
sh ./scripts/archive-reqs.sh --days 30

# 效果
.specs/
├── archive/
│   ├── 2023-12/  (12月的req)
│   └── 2024-01/  (1月的req)
└── (当前活跃req)
```

---

#### 压缩历史

```bash
# Git打包
git gc --aggressive

# 清理大文件
git filter-branch --tree-filter 'rm -rf .specs/archive/*' HEAD
```

---

## 6. 总结

### 核心要点

1. **自定义要谨慎** - 保持与主流程兼容
2. **Skill要实用** - 解决实际问题
3. **CI/CD要自动化** - 减少人工检查
4. **团队要协作** - 共享知识和经验
5. **性能要优化** - 控制Token和速度

---

**下一步**: [教程 07: 智能推荐](07-smart-recommendation.md)
