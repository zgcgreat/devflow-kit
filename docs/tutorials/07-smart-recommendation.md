# 教程 07: 智能推荐

> **学习目标**: 理解和使用智能模式推荐系统  
> **预计时间**: 15分钟  
> **前置知识**: 已完成教程01-06

---

## 目录

1. [什么是智能推荐](#1-什么是智能推荐)
2. [推荐算法详解](#2-推荐算法详解)
3. [如何使用](#3-如何使用)
4. [提高准确率](#4-提高准确率)
5. [查看历史记录](#5-查看历史记录)
6. [自定义权重](#6-自定义权重)

---

## 1. 什么是智能推荐

### 传统方式 vs 智能推荐

**传统方式（规则判定）**:
```markdown
Fast模式规则:
- 改动文件 ≤ 2
- 代码行数 < 50
- 无高风险操作

问题:
- 规则僵化
- 无法学习历史
- 误判率高（30%）
```

**智能推荐（v2.2）**:
```markdown
基于多维度分析:
- 需求长度
- 关键词识别
- 历史相似性
- 风险因子检测

优势:
- 更准确（>85%）
- 自适应学习
- 可解释性强
```

---

### 推荐流程

```
用户需求 → 多维分析 → 加权评分 → 推荐模式 + 置信度
                ↓
          用户确认/调整
                ↓
          执行对应流程
                ↓
          记录实际结果
                ↓
          优化下次推荐
```

---

## 2. 推荐算法详解

### 维度1: 需求长度分析（权重30%）

**原理**: 需求描述长度与复杂度相关

**规则**:
```python
if len(requirement) < 20:
    fast_score += 30
elif 20 <= len(requirement) <= 100:
    standard_score += 20
else:
    strict_score += 15
```

**示例**:
```
"修复typo" (4字) → Fast +30
"我想加个搜索功能，支持关键词和排序" (18字) → Fast +30
"我需要实现一个完整的商品搜索系统，包括前端UI、后端API、ES集成、性能优化..." (50字) → Standard +20
```

---

### 维度2: 关键词识别（权重30%）

**原理**: 特定关键词暗示复杂度

**关键词库**:

| 模式 | 关键词 |
|------|--------|
| Fast | "修复"、"typo"、"文案"、"改颜色"、"调整样式"、"删除" |
| Standard | "功能"、"页面"、"API"、"组件"、"接口"、"列表"、"表单" |
| Strict | "支付"、"鉴权"、"迁移"、"重构"、"数据库schema"、"安全" |

**匹配逻辑**:
```python
fast_keywords = ["修复", "typo", "文案"]
standard_keywords = ["功能", "页面", "API"]
strict_keywords = ["支付", "鉴权", "迁移"]

for keyword in fast_keywords:
    if keyword in requirement:
        fast_score += 15

for keyword in standard_keywords:
    if keyword in requirement:
        standard_score += 10

for keyword in strict_keywords:
    if keyword in requirement:
        strict_score += 20
```

**示例**:
```
"修复登录按钮typo"
→ 匹配: "修复"(+15), "typo"(+15)
→ Fast总分: 30

"实现用户认证功能"
→ 匹配: "功能"(+10)
→ Standard总分: 10
⚠️ 但"认证"是高风险词 → Strict +20
→ 最终: Strict推荐
```

---

### 维度3: 历史相似性（权重40%）

**原理**: 类似需求通常用相同模式

**算法**: TF-IDF + Jaccard相似度

**步骤**:

1. **提取历史需求**
   ```python
   history = load_mode_history()  # 从MODE_HISTORY.md读取
   # [
   #   {"req": "add-search", "desc": "商品搜索功能", "mode": "Standard"},
   #   {"req": "fix-typo", "desc": "修复登录按钮typo", "mode": "Fast"},
   #   ...
   # ]
   ```

2. **计算相似度**
   ```python
   def jaccard_similarity(req1, req2):
       words1 = set(tokenize(req1))
       words2 = set(tokenize(req2))
       intersection = words1 & words2
       union = words1 | words2
       return len(intersection) / len(union)
   
   similarities = []
   for h in history:
       sim = jaccard_similarity(current_req, h["desc"])
       similarities.append((sim, h["mode"]))
   
   # 取最相似的5条
   top5 = sorted(similarities, reverse=True)[:5]
   ```

3. **统计模式分布**
   ```python
   mode_counts = {"Fast": 0, "Standard": 0, "Strict": 0}
   for sim, mode in top5:
       mode_counts[mode] += sim  # 加权计数
   
   # 归一化
   total = sum(mode_counts.values())
   for mode in mode_counts:
       mode_counts[mode] = (mode_counts[mode] / total) * 40
   ```

**示例**:
```
当前需求: "添加商品搜索"

历史相似需求:
1. "商品搜索功能" (相似度0.85) → Standard
2. "实现搜索框" (相似度0.72) → Standard
3. "添加过滤器" (相似度0.65) → Standard
4. "搜索优化" (相似度0.58) → Standard
5. "修复搜索bug" (相似度0.45) → Fast

统计:
- Standard: (0.85+0.72+0.65+0.58) / 3.25 * 40 = 34.5
- Fast: 0.45 / 3.25 * 40 = 5.5

→ History维度: Standard +34.5
```

---

### 维度4: 风险因子检测（权重10%）

**原理**: 高风险领域需要更谨慎

**高风险指标**:
```python
risk_indicators = [
    "支付", "金钱", "转账",
    "鉴权", "权限", "登录",
    "用户数据", "隐私", "个人信息",
    "数据库schema", "迁移", "重构",
    "核心业务", "公共组件"
]

for indicator in risk_indicators:
    if indicator in requirement:
        strict_score += 20
        break  # 命中一个就够
```

**示例**:
```
"集成支付宝支付"
→ 匹配: "支付" → Strict +20

"修改用户表结构"
→ 匹配: "数据库schema" → Strict +20
```

---

### 综合评分

**公式**:
```
final_fast = text_fast * 0.30 + history_fast * 0.40 + file_fast * 0.20 + risk_fast * 0.10
final_standard = text_standard * 0.30 + history_standard * 0.40 + file_standard * 0.20 + risk_standard * 0.10
final_strict = text_strict * 0.30 + history_strict * 0.40 + file_strict * 0.20 + risk_strict * 0.10
```

**归一化**:
```python
total = final_fast + final_standard + final_strict
final_fast = (final_fast / total) * 100
final_standard = (final_standard / total) * 100
final_strict = (final_strict / total) * 100
```

**推荐**:
```python
recommended = max(final_fast, final_standard, final_strict)
confidence = recommended  # 最高分即置信度
```

---

## 3. 如何使用

### 自动触发

**无需任何操作**，AI会在你提出需求后自动推荐：

```
你: Use devflow-kit. 我想加个搜索功能。

AI: 🎯 模式推荐：Standard（置信度 85%）

评分详情:
- Fast: 10%
- Standard: 85% ← 推荐
- Strict: 5%

推荐理由:
1. 需求描述中等长度（15字），涉及多模块
2. 关键词"功能"出现，通常是Standard
3. 历史相似req使用Standard（相似度0.82）
4. 预估改动文件数：4-6个

请确认或选择其他模式：
1. ✅ Standard（推荐）
2. Fast
3. Strict
```

**你只需回复**:
- "1" 或 "确认" → 使用推荐模式
- "2" → 切换到Fast
- "3" → 切换到Strict

---

### 手动指定

如果你已经知道要用什么模式：

```
你: Use devflow-kit. Fast模式：修复登录按钮typo。

AI: ✅ 模式：Fast（用户指定）
    ✅ 路由: 4-dev
    ...
```

---

### 中途切换

如果在执行中发现模式不合适：

```
你: 这个比想象复杂，切换到Standard模式。

AI: ✅ 模式升级: Fast → Standard
    
    已暂停当前工作。
    
    现在开始Standard流程：
    1. 需求确认
    2. 需求分析
    ...
```

---

## 4. 提高准确率

### 方法1: 提供详细的需求描述

**Bad**:
```
"加搜索"
```
→ AI难以判断复杂度

**Good**:
```
"在商品列表页添加搜索功能，支持关键词模糊搜索和按价格/销量排序"
```
→ AI可以准确评估

---

### 方法2: 明确技术范围

**Bad**:
```
"做个用户系统"
```
→ 可能包含注册、登录、权限、个人资料...

**Good**:
```
"只实现用户登录功能，包括邮箱/密码登录和JWT token"
```
→ 范围清晰

---

### 方法3: 说明约束条件

**示例**:
```
"我要加个导出功能，但要注意：
- 数据量可能很大（10万+行）
- 需要在后台异步处理
- 完成后邮件通知用户"
```
→ AI会推荐Standard或Strict

---

### 方法4: 积累历史数据

**效果**: 历史数据越多，推荐越准确

**建议**:
- 至少10条历史记录 → 准确率70%
- 50条以上 → 准确率85%
- 100条以上 → 准确率90%

---

## 5. 查看历史记录

### 位置

`.specs/MODE_HISTORY.md`

---

### 格式

```markdown
# Mode History

| 日期 | req-id | 需求描述(前20字) | 推荐模式 | 用户选择 | 实际规模 | 是否升级 |
|------|--------|------------------|----------|----------|----------|----------|
| 2024-01-15 | add-search | 商品搜索功能 | Standard | Standard | 5文件/120行 | 否 |
| 2024-01-14 | fix-typo | 修复登录按钮typo | Fast | Fast | 1文件/3行 | 否 |
| 2024-01-13 | user-auth | 用户认证系统 | Strict | Strict | 12文件/350行 | 否 |
```

---

### 分析方法

#### 分析1: 推荐准确率

```bash
# 统计推荐与选择一致的比例
grep -c "Standard.*Standard" MODE_HISTORY.md  # 推荐Standard且选Standard
grep -c "Fast.*Fast" MODE_HISTORY.md          # 推荐Fast且选Fast

准确率 = 一致次数 / 总次数
```

---

#### 分析2: 升级频率

```bash
# 统计发生模式升级的次数
grep -c "是" MODE_HISTORY.md | tail -1  # "是否升级"列

升级率 = 升级次数 / 总次数

目标: <15%
如果 >20% → 需要调整算法
```

---

#### 分析3: 常见模式分布

```bash
# 统计各模式使用频率
awk -F'|' '{print $5}' MODE_HISTORY.md | sort | uniq -c

输出:
     45 Standard
     30 Fast
     10 Strict
```

---

## 6. 自定义权重

### 场景

你的项目可能有特殊需求，需要调整权重。

---

### 方法1: 修改GO.md

**位置**: `flow/GO.md` 第四步半

**示例**: 如果你的项目大部分是Small fixes，提高Fast权重

```markdown
#### 维度权重调整

默认权重:
- 文本特征: 30%
- 历史相似性: 40%
- 文件预测: 20%
- 风险因子: 10%

自定义权重（根据你的项目调整）:
- 文本特征: 25%
- 历史相似性: 35%
- 文件预测: 25%  # 提高
- 风险因子: 15%  # 提高
```

---

### 方法2: 自定义关键词库

**位置**: `flow/GO.md` 第四步半

**示例**: 添加你项目的特有词汇

```markdown
#### 维度2: 关键词识别

**Fast关键词** (新增):
- "hotfix"
- "紧急修复"
- "线上bug"

**Standard关键词** (新增):
- "微服务"
- "消息队列"
- "缓存"

**Strict关键词** (新增):
- "金融"
- "合规"
- "审计"
```

---

### 方法3: 调整风险阈值

**示例**: 如果你的项目对安全要求极高

```markdown
#### 维度4: 风险因子检测

**高风险指标** (增加):
- "API变更"  # 新增
- "向后兼容"  # 新增
- "SLA"      # 新增

命中任一项 → Strict +30 (原来是+20)
```

---

## 7. 常见问题

### Q1: 推荐总是不准怎么办？

**A**: 
1. 检查需求描述是否足够详细
2. 积累更多历史数据（至少10条）
3. 调整关键词库和权重
4. 手动指定模式，让AI学习

---

### Q2: 可以不使用智能推荐吗？

**A**: 可以。直接指定模式：

```
"Use devflow-kit. Standard模式：..."
```

AI会跳过推荐，直接使用你指定的模式。

---

### Q3: 历史记录太多怎么办？

**A**: 定期清理：

```bash
# 保留最近100条
tail -n 100 MODE_HISTORY.md > MODE_HISTORY.tmp
mv MODE_HISTORY.tmp MODE_HISTORY.md
```

---

### Q4: 如何评估推荐效果？

**A**: 追踪以下指标：

| 指标 | 目标值 | 计算方法 |
|------|--------|---------|
| 推荐准确率 | >85% | 推荐=选择的次数/总次数 |
| 升级率 | <15% | 发生升级的次数/总次数 |
| 用户满意度 | >4/5 | 问卷调查 |

---

## 8. 总结

### 核心要点

1. **智能推荐基于4个维度** - 长度、关键词、历史、风险
2. **历史数据越多越准确** - 目标50+条记录
3. **详细描述提高准确率** - 不要只说"做个X"
4. **可以随时手动切换** - 推荐不是强制的
5. **可以自定义调整** - 适应你的项目特点

---

### 下一步

恭喜！你已完成所有进阶教程。

**实战练习**:
- [教程 08: 前端项目实战](08-frontend-practice.md)
- [教程 09: 后端项目实战](09-backend-practice.md)
- [教程 10: 存量项目改造](10-legacy-migration.md)

---

**返回**: [教程目录](README.md)
