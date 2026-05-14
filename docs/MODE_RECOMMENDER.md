# 智能模式推荐引擎

> **版本**: v2.0-draft  
> **状态**: 实验性功能  
> **目标**: 基于历史数据和需求特征，智能推荐 Fast/Standard/Strict 模式

---

## 设计理念

### 当前问题

v1.x 的模式判定依赖静态规则：
```markdown
Fast: <50行、1-2文件、低风险
```

**局限性**:
- 规则僵化，无法适应复杂场景
- 无法学习团队历史偏好
- 相同需求不同人可能选择不同模式

### 解决方案

**基于多维度特征的推荐引擎**:

```
输入特征 → 加权评分 → 模式推荐 + 置信度
```

---

## 推荐算法

### 特征提取

#### 1. 文本特征（权重 30%）

**需求描述长度**:
- < 20字 → Fast (+20分)
- 20-100字 → Standard (+10分)
- > 100字 → Strict (+5分)

**关键词识别**:

| 关键词 | 倾向模式 | 分值 |
|--------|---------|------|
| "修复"、"typo"、"文案"、"样式" | Fast | +25 |
| "功能"、"页面"、"API"、"模块" | Standard | +20 |
| "支付"、"鉴权"、"迁移"、"架构" | Strict | +30 |
| "搜索"、"列表"、"表单" | Standard | +15 |
| "优化"、"重构" | Standard | +18 |

**示例**:
```
需求: "修复登录按钮点击无响应的问题"
- 长度: 16字 → Fast +20
- 关键词: "修复" → Fast +25
- 总分: 45 → 推荐 Fast
```

---

#### 2. 历史相似性（权重 40%）

**匹配逻辑**:
1. 从 `.specs/MODE_HISTORY.md` 查找历史req
2. 计算文本相似度（TF-IDF + Cosine Similarity）
3. 取最相似的3个req，统计其模式分布

**示例**:
```
当前需求: "实现商品搜索功能"

历史相似req:
- add-product-filter (Standard, 相似度0.85)
- implement-search-box (Standard, 相似度0.78)
- fix-search-bug (Fast, 相似度0.65)

统计: Standard 2次, Fast 1次
推荐: Standard (置信度 67%)
```

---

#### 3. 文件改动预测（权重 20%）

**基于需求描述的预估**:

| 需求类型 | 预估文件数 | 预估行数 | 推荐模式 |
|---------|-----------|---------|---------|
| Bugfix (单个组件) | 1-2 | <50 | Fast |
| 新功能 (单模块) | 3-5 | 50-200 | Standard |
| 新功能 (跨模块) | 6-10 | 200-500 | Standard |
| 架构调整 | 10+ | 500+ | Strict |

**启发式规则**:
- 提到"前端+后端" → +2文件
- 提到"数据库" → +1文件, +50行
- 提到"测试" → +2文件
- 提到"UI/样式" → +1文件

---

#### 4. 风险因子（权重 10%）

**自动检测高风险关键词**:

```python
HIGH_RISK_KEYWORDS = [
    "支付", "账单", "订单",
    "鉴权", "权限", "认证",
    "secret", "password", "token",
    "schema", "migration", "数据库结构",
    "公共API", "SDK",
    "部署", "CI/CD", "infra",
    "数据丢失", "不可逆", "删除"
]

if any(keyword in requirement for keyword in HIGH_RISK_KEYWORDS):
    risk_score += 30  # 强制升级到 Strict
```

---

### 评分计算

```python
def calculate_mode_score(requirement, history):
    scores = {
        'Fast': 0,
        'Standard': 0,
        'Strict': 0
    }
    
    # 1. 文本特征 (30%)
    text_score = analyze_text_features(requirement)
    scores['Fast'] += text_score['fast'] * 0.3
    scores['Standard'] += text_score['standard'] * 0.3
    scores['Strict'] += text_score['strict'] * 0.3
    
    # 2. 历史相似性 (40%)
    history_score = analyze_history_similarity(requirement, history)
    scores['Fast'] += history_score['fast'] * 0.4
    scores['Standard'] += history_score['standard'] * 0.4
    scores['Strict'] += history_score['strict'] * 0.4
    
    # 3. 文件改动预测 (20%)
    file_score = predict_file_changes(requirement)
    scores['Fast'] += file_score['fast'] * 0.2
    scores['Standard'] += file_score['standard'] * 0.2
    scores['Strict'] += file_score['strict'] * 0.2
    
    # 4. 风险因子 (10%)
    risk_score = assess_risk(requirement)
    if risk_score > 20:
        scores['Strict'] += 30  # 高风险直接加分
    
    # 归一化
    total = sum(scores.values())
    for mode in scores:
        scores[mode] = (scores[mode] / total) * 100
    
    return scores
```

---

## 输出格式

### 推荐结果

```markdown
🎯 模式推荐：Standard（置信度 82%）

**评分详情**:
- Fast: 15%
- Standard: 82% ← 推荐
- Strict: 3%

**推荐理由**:
1. 需求描述中等长度（65字），涉及多模块
2. 历史相似req "add-product-filter" 使用 Standard（相似度0.85）
3. 预估改动文件数：4-6个（前端2个 + 后端2个 + 测试2个）
4. 无高风险关键词

**其他选项**:
• Fast（15%）: 仅当你确定改动很小时
• Strict（3%）: 如涉及支付/鉴权可考虑

**请确认或选择其他模式**:
1. ✅ Standard（推荐）
2. Fast
3. Strict
```

### 低置信度处理

如果最高分 < 60%，输出：

```markdown
⚠️ 模式推荐不确定（最高置信度 55%）

**评分详情**:
- Fast: 40%
- Standard: 55%
- Strict: 5%

**原因**: 
- 需求描述模糊，难以准确判断
- 历史数据不足（仅1个相似req）

**建议**: 
请补充更多信息，或手动选择模式：
1. Fast - 小改动
2. Standard - 常规功能（默认）
3. Strict - 高风险改动
```

---

## 数据收集与学习

### MODE_HISTORY.md 结构

```markdown
# Mode Selection History

> 自动记录，用于优化模式推荐算法

## 2024-01

| Date | Req-ID | Requirement (摘要) | Recommended | Selected | Actual Files | Actual Lines | Correct? |
|------|--------|-------------------|-------------|----------|--------------|--------------|----------|
| 2024-01-15 | add-search-box | 实现商品搜索功能 | Standard (82%) | Standard | 5 | 180 | ✅ |
| 2024-01-16 | fix-typo | 修复按钮文案typo | Fast (95%) | Fast | 1 | 8 | ✅ |
| 2024-01-17 | add-payment | 集成支付宝支付 | Strict (88%) | Standard | 8 | 350 | ❌ 应选Strict |

## 统计

### 准确率
- Fast: 95% (20/21)
- Standard: 82% (45/55)
- Strict: 88% (15/17)
- 总体: 87% (80/93)

### 常见误判
1. Standard → Strict: 涉及隐藏的安全逻辑
2. Fast → Standard: 实际影响多个模块
3. Strict → Standard: 用户认为风险可控

### 优化方向
- 增加"安全逻辑"关键词识别
- 改进文件改动预测算法
- 考虑用户手动override的频率
```

### 学习机制

**每次req完成后自动记录**:

```python
def record_mode_decision(req_id, requirement, recommended_mode, 
                         selected_mode, actual_files, actual_lines):
    """记录模式决策结果"""
    
    entry = {
        'date': datetime.now().strftime('%Y-%m-%d'),
        'req_id': req_id,
        'requirement_summary': requirement[:50],
        'recommended_mode': recommended_mode,
        'recommended_confidence': confidence,
        'selected_mode': selected_mode,
        'actual_files': actual_files,
        'actual_lines': actual_lines,
        'is_correct': (selected_mode == get_optimal_mode(actual_files, actual_lines))
    }
    
    append_to_history(entry)
    
    # 如果误判，调整权重
    if not entry['is_correct']:
        adjust_weights(entry)
```

**权重自适应**:

```python
def adjust_weights(error_entry):
    """根据错误案例调整特征权重"""
    
    if error_entry['recommended_mode'] == 'Fast' and error_entry['selected_mode'] == 'Standard':
        # Fast低估了复杂度，降低文本特征权重，提高文件预测权重
        WEIGHTS['text'] -= 0.05
        WEIGHTS['file_prediction'] += 0.05
    
    elif error_entry['recommended_mode'] == 'Standard' and error_entry['selected_mode'] == 'Strict':
        # 未识别出高风险，增加风险因子权重
        WEIGHTS['risk'] += 0.1
    
    # 确保权重总和为1
    normalize_weights()
```

---

## 集成到 GO.md

### 修改第五步：模式判定

```markdown
## 第五步 · 模式判定（v2.0 增强版）

### 5.1 智能推荐（可选）

如果 `.specs/MODE_HISTORY.md` 存在且有足够历史数据（≥10条），启用智能推荐：

```python
# 伪代码
scores = calculate_mode_score(user_requirement, load_history())
recommended_mode = max(scores, key=scores.get)
confidence = scores[recommended_mode]

if confidence >= 60:
    output_recommendation(recommended_mode, confidence, scores)
    wait_for_user_confirmation()
else:
    # 低置信度，回退到规则判定
    use_rule_based_judgment()
```

### 5.2 规则判定（fallback）

如果智能推荐不可用或用户跳过，使用原有规则：

1. 检查高风险关键词 → Strict
2. 执行 Fast checklist
3. 默认 Standard

### 5.3 用户确认

Standard/Strict 必须等用户确认，Fast 可直接执行但允许用户反对。
```

---

## 实施计划

### Week 1: 基础框架

- [ ] 创建 `flow/mode-recommender.md` 算法文档
- [ ] 实现文本特征分析函数
- [ ] 实现关键词识别
- [ ] 创建 MODE_HISTORY.md 模板

### Week 2: 历史数据分析

- [ ] 实现相似度计算（TF-IDF）
- [ ] 实现历史匹配逻辑
- [ ] 添加数据统计功能

### Week 3: 集成与测试

- [ ] 修改 GO.md 集成推荐引擎
- [ ] 在3个项目试点
- [ ] 收集反馈并调优

### Week 4: 自动化学习

- [ ] 实现自动记录功能
- [ ] 实现权重自适应
- [ ] 生成准确率报告

---

## 预期效果

| 指标 | 基线（规则） | 目标（智能） | 提升 |
|------|------------|------------|------|
| 推荐准确率 | 70% | >85% | +15% |
| 用户采纳率 | 60% | >75% | +15% |
| 模式升级次数 | 30% | <15% | -50% |
| 用户满意度 | 3.5/5 | 4.5/5 | +28% |

---

## 风险与缓解

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|---------|
| 推荐不准确导致用户不信任 | 中 | 高 | 始终显示置信度，允许用户override |
| 历史数据不足 | 高 | 中 | 回退到规则判定，冷启动友好 |
| 计算开销大 | 低 | 低 | 缓存相似度计算结果 |
| 隐私问题 | 低 | 中 | 仅存储需求摘要，不存完整内容 |

---

*最后更新: 2024-01-15*  
*版本: v2.0-draft*
