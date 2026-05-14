# devflow-kit 优化实施指南

> **目标读者**: 团队负责人、技术leader  
> **阅读时间**: 10分钟  
> **执行时间**: 根据范围选择（1天/1周/1月）

---

## 🎯 快速决策树

```
你的团队规模？
├─ 1-3人 → 实施「最小可行优化」（1天）
├─ 4-10人 → 实施「标准优化包」（1周）
└─ 10人以上 → 实施「完整路线图」（1月）
```

---

## 方案A: 最小可行优化 (1天)

**适用**: 个人开发者或小团队，想快速见效

### 包含内容

✅ **P1: 明确Fast模式边界** (3小时)  
✅ **P2: 产物归档脚本** (2小时)  
✅ **文档优化: QUICKSTART.md** (3小时)

### 实施步骤

#### Step 1: 修改 mode-rules.md (3小时)

在 `flow/mode-rules.md` 中添加：

```markdown
## Fast模式准入Checklist

进入Fast模式前，AI必须确认以下所有条件：

### 硬性指标（必须全部满足）
- [ ] 改动文件数 ≤ 2
- [ ] 预估代码行数 < 50
- [ ] 不涉及数据库schema变更
- [ ] 不涉及API接口签名变更
- [ ] 不涉及鉴权/权限/支付逻辑

### 软性指标（至少满足3项）
- [ ] 需求描述清晰无歧义
- [ ] 有明确的验收标准
- [ ] 不影响其他模块
- [ ] 有现成的测试框架
- [ ] 非核心业务逻辑

### 自动排除项（命中任一项→强制Standard）
❌ 修改订单/支付/用户认证核心逻辑
❌ 修改公共组件/工具函数
❌ 涉及第三方依赖版本升级
❌ 需要修改CI/CD配置
❌ 需要数据迁移或回滚方案
```

修改 `flow/GO.md` 第五步，添加检查逻辑：

```markdown
### 第五步 · 模式判定（增强版）

**Fast模式检查流程:**

1. AI初步判断为Fast模式
2. **执行Fast Checklist逐项检查**
3. 如有任一硬性指标不满足 → 升级为Standard
4. 如软性指标<3项 → 建议升级为Standard
5. 输出检查结果：

```
🔍 Fast模式检查

硬性指标:
✅ 改动文件数: 1个
✅ 预估行数: 30行
✅ 无schema变更
✅ 无API变更
✅ 非鉴权逻辑

软性指标:
✅ 需求清晰
✅ 有验收标准
❌ 影响其他模块（搜索组件被多处引用）
✅ 有测试框架
❌ 非核心逻辑

结果: 5/5硬性通过，3/5软性通过
建议: ⚠️ 建议升级到Standard（软性指标不足）

请确认:
1. 继续Fast模式
2. 升级到Standard（推荐）
```
```

#### Step 2: 创建归档脚本 (2小时)

创建 `scripts/archive-old-reqs.ps1`:

```powershell
# 归档30天前的req

param(
    [string]$ProjectRoot,
    [int]$DaysThreshold = 30
)

$SpecsDir = Join-Path $ProjectRoot ".specs"
$ArchiveDir = Join-Path $SpecsDir "archive"
$Today = Get-Date

# 获取所有req目录
$ReqDirs = Get-ChildItem -Path $SpecsDir -Directory | 
           Where-Object { $_.Name -notmatch "^(archive|\.memory)$" }

foreach ($req in $ReqDirs) {
    # 检查最后修改时间
    $LastModified = (Get-ChildItem -Path $req.FullName -Recurse | 
                     Sort-Object LastWriteTime -Descending | 
                     Select-Object -First 1).LastWriteTime
    
    $DaysOld = ($Today - $LastModified).Days
    
    if ($DaysOld -gt $DaysThreshold) {
        # 创建年月归档目录
        $YearMonth = $LastModified.ToString("yyyy-MM")
        $TargetDir = Join-Path $ArchiveDir $YearMonth
        
        if (-not (Test-Path $TargetDir)) {
            New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        }
        
        # 移动req目录
        Move-Item -Path $req.FullName -Destination (Join-Path $TargetDir $req.Name) -Force
        Write-Host "✓ 归档: $($req.Name) ($DaysOld 天前)" -ForegroundColor Green
    }
}

Write-Host "`n归档完成!" -ForegroundColor Cyan
```

添加到 `.gitignore`:
```gitignore
# 归档目录可选忽略（根据团队偏好）
# .specs/archive/
```

#### Step 3: 创建 QUICKSTART.md (3小时)

在项目根目录创建 `QUICKSTART.md`（参考UPGRADE_ROADMAP.md中的内容）

### 预期效果

- ✅ Fast模式误判率从30%降到<10%
- ✅ .specs/目录大小稳定（每月归档一次）
- ✅ 新手上手时间从30分钟降到5分钟

---

## 方案B: 标准优化包 (1周)

**适用**: 中型团队(4-10人)，追求平衡

### 包含内容

✅ 方案A的所有内容  
✅ **P0: 轻量级记忆系统** (3天)  
✅ **可视化流程图** (1天)

### 额外实施步骤

#### Day 1-2: 记忆系统基础

1. 创建 `.specs/.memory/` 目录结构
2. 填充4个模板文件（PROJECT_CONTEXT.md等）
3. 手动填写当前项目的PROJECT_CONTEXT.md

#### Day 3: 集成到GO.md

修改 `flow/GO.md` 第一步和第七步，添加记忆读写逻辑（参考MEMORY_INTEGRATION.md）

#### Day 4: 创建README流程图

在 README.md 顶部添加Mermaid流程图

#### Day 5: 团队培训

- 30分钟演示新功能
- 收集团队反馈
- 调整模板和流程

### 预期效果

- ✅ 跨会话上下文保持，AI不再重复问项目背景
- ✅ 团队决策透明化（DECISIONS.md）
- ✅ 失败经验可复用（KNOWN_FAILURES.md）
- ✅ 新人通过流程图快速理解全流程

---

## 方案C: 完整路线图 (1月)

**适用**: 大型团队(10人以上)，长期项目

### 包含内容

✅ 方案B的所有内容  
✅ **Skill合并重构** (2周)  
✅ **智能模式推荐** (1周)  
✅ **插件化架构** (1周)

### 实施建议

**Week 1**: 实施方案B（标准优化包）  
**Week 2**: Skill合并与测试  
**Week 3**: 智能推荐算法开发  
**Week 4**: 插件系统 + 文档完善

### 注意事项

⚠️ **高风险操作**:
- Skill合并可能破坏现有项目
- 建议在分支上先试点
- 保留旧skill作为fallback

---

## 📋 立即行动清单

### 今天就可以做的（无需代码修改）

- [ ] **阅读 MEMORY_INTEGRATION.md** (30分钟)
  - 理解记忆系统设计理念
  - 评估是否适合你的团队

- [ ] **手动创建记忆文件** (20分钟)
  ```bash
  mkdir -p .specs/.memory/session-journal
  # 复制docs/MEMORY_INTEGRATION.md中的模板
  ```

- [ ] **填写 PROJECT_CONTEXT.md** (15分钟)
  - 项目名称、技术栈、架构说明
  - 这是ROI最高的15分钟投入

- [ ] **填写 CURRENT_STATE.md** (10分钟)
  - 当前焦点、最近完成、下一步
  - 让AI下次会话立即获得上下文

### 本周可以完成的

- [ ] **修改 mode-rules.md** (3小时)
  - 添加Fast模式checklist
  - 减少误判

- [ ] **创建归档脚本** (2小时)
  - 防止.specs/膨胀
  - 设置cron每月执行一次

- [ ] **编写 QUICKSTART.md** (3小时)
  - 降低新手门槛
  - 放在README显眼位置

- [ ] **团队分享会** (1小时)
  - 演示新功能
  - 收集反馈

### 本月可以规划的

- [ ] **评估是否需要完整路线图**
  - 团队规模是否>10人？
  - 项目周期是否>6个月？
  - 是否有多个并行项目？

- [ ] **制定Phase 2-3实施计划**
  - 分配责任人
  - 设定里程碑
  - 预留buffer时间

---

## 🎓 最佳实践建议

### 对于个人开发者

**推荐**: 方案A（最小可行优化）

**重点投入:**
1. Fast模式checklist（避免误判）
2. QUICKSTART.md（自己也会忘记流程）
3. 简单的CURRENT_STATE.md（跨会话记忆）

**不需要:**
- ❌ 复杂的记忆系统
- ❌ Skill重构
- ❌ Web管理界面

### 对于小团队(2-5人)

**推荐**: 方案A + 轻量记忆

**重点投入:**
1. Fast模式checklist
2. PROJECT_CONTEXT.md（团队共享）
3. DECISIONS.md（决策透明）
4. 归档脚本（保持整洁）

**可选:**
- ⚠️ session-journal（如果会话频繁）
- ❌ 智能推荐（规则足够）

### 对于中型团队(5-15人)

**推荐**: 方案B（标准优化包）

**重点投入:**
1. 完整记忆系统
2. KNOWN_FAILURES.md（经验共享）
3. 可视化流程图（统一认知）
4. 定期团队培训

**可选:**
- ⚠️ 智能推荐（如果有历史数据）
- ❌ 插件系统（维护成本高）

### 对于大型团队(15人以上)

**推荐**: 方案C（完整路线图）

**重点投入:**
1. 所有Phase 1-3内容
2. 插件化架构（团队自定义）
3. Web管理界面（多人协作）
4. 专职维护人员

**必须:**
- ✅ 完整的变更管理流程
- ✅ 向后兼容性保证
- ✅ 详细的迁移指南

---

## 📊 ROI分析

### 投入 vs 产出

| 优化项 | 投入时间 | 预期收益 | ROI评级 |
|--------|---------|---------|---------|
| Fast模式checklist | 3h | 减少50%返工 | ⭐⭐⭐⭐⭐ |
| 归档脚本 | 2h | Git历史减少70% | ⭐⭐⭐⭐ |
| QUICKSTART.md | 3h | 上手时间减少80% | ⭐⭐⭐⭐⭐ |
| PROJECT_CONTEXT.md | 1h | 每次会话节省10min | ⭐⭐⭐⭐⭐ |
| 完整记忆系统 | 3d | 长期效率提升30% | ⭐⭐⭐⭐ |
| Skill重构 | 2w | 维护成本减半 | ⭐⭐⭐ |
| Web界面 | 3w | 协作效率提升20% | ⭐⭐ |

### 推荐优先级

**立即做（高ROI，低投入）:**
1. Fast模式checklist
2. QUICKSTART.md
3. PROJECT_CONTEXT.md

**本周做（中高ROI，中投入）:**
4. 归档脚本
5. CURRENT_STATE.md
6. 可视化流程图

**本月规划（中ROI，高投入）:**
7. 完整记忆系统
8. Skill重构
9. 智能推荐

---

## 🔧 故障排查

### 问题1: 记忆文件没人维护

**症状**: CURRENT_STATE.md超过1个月未更新

**解决**:
- 在GO.md第七步强制提醒更新
- 设置每周自动检查脚本
- 简化模板，只保留核心字段

### 问题2: Fast模式checklist太严格

**症状**: 90%的需求都被升级到Standard

**解决**:
- 放宽软性指标要求（从3/5降到2/5）
- 允许用户override AI判断
- 收集误判案例，调整规则

### 问题3: 归档后找不到历史req

**症状**: 团队成员抱怨ARCHIVE_INDEX.md难用

**解决**:
- 添加搜索脚本（按关键词检索）
- 在README中添加快速链接
- 考虑Web界面（如果团队规模大）

---

## 📞 获取帮助

- **文档**: docs/ 目录下所有文档
- **示例**: 查看 `.specs/example-req/` （如有）
- **社区**: GitHub Issues / Discord
- **定制**: 联系核心团队获取咨询服务

---

## ✅ 成功检查清单

完成优化后，确认以下指标：

- [ ] 新用户能在5分钟内完成第一个req
- [ ] Fast模式误判率 < 10%
- [ ] .specs/目录大小稳定（不持续增长）
- [ ] AI能准确读取项目上下文
- [ ] 团队成员知道如何查看历史决策
- [ ] 常见问题有文档可查

如果以上全部打勾，恭喜！你的devflow-kit已经升级到v2.0水平。

---

*最后更新: 2024-01-15*  
*版本: v2.0-implementation-guide*
