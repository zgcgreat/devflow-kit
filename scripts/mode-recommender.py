#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Mode Recommender - 智能模式推荐引擎

版本: v2.0-draft
状态: 原型实现
用途: 基于需求特征和历史数据，智能推荐 Fast/Standard/Strict 模式
"""

import re
from collections import Counter
from datetime import datetime
from typing import Dict, List, Optional


def analyze_text_features(requirement: str) -> Dict[str, int]:
    """
    分析需求文本特征
    
    Args:
        requirement: 需求描述文本
    
    Returns:
        {'fast': score, 'standard': score, 'strict': score}
    """
    scores = {'fast': 0, 'standard': 0, 'strict': 0}
    
    # 1.1 长度评分
    length = len(requirement)
    if length < 20:
        scores['fast'] += 20
    elif length < 100:
        scores['standard'] += 10
    else:
        scores['strict'] += 5
    
    # 1.2 关键词识别
    fast_keywords = ['修复', 'typo', '文案', '样式', '小改动', '简单']
    standard_keywords = ['功能', '页面', 'API', '模块', '搜索', '列表', '表单', '优化', '重构']
    strict_keywords = ['支付', '鉴权', '迁移', '架构', '安全', '权限', '账单', '数据库结构']
    
    for keyword in fast_keywords:
        if keyword in requirement:
            scores['fast'] += 25
            break
    
    for keyword in standard_keywords:
        if keyword in requirement:
            scores['standard'] += 20
            break
    
    for keyword in strict_keywords:
        if keyword in requirement:
            scores['strict'] += 30
            break
    
    return scores


def calculate_tf_idf(documents: list, query: str) -> dict:
    """
    计算TF-IDF相似度
    
    Args:
        documents: 历史需求列表 [{'req_id': ..., 'requirement': ...}]
        query: 当前需求
    
    Returns:
        每个历史文档的相似度分数
    """
    # 分词（简化版，实际应使用jieba等中文分词）
    def tokenize(text):
        return text.split()
    
    query_tokens = set(tokenize(query))
    
    similarities = []
    
    for doc in documents:
        doc_tokens = set(tokenize(doc['requirement']))
        
        # Jaccard相似度
        intersection = query_tokens.intersection(doc_tokens)
        union = query_tokens.union(doc_tokens)
        
        if len(union) == 0:
            similarity = 0
        else:
            similarity = len(intersection) / len(union)
        
        similarities.append({
            'req_id': doc['req_id'],
            'mode': doc['selected_mode'],
            'similarity': similarity
        })
    
    # 按相似度排序，取top 3
    similarities.sort(key=lambda x: x['similarity'], reverse=True)
    top_3 = similarities[:3]
    
    # 统计模式分布
    mode_counts = Counter([item['mode'] for item in top_3])
    total = sum(mode_counts.values())
    
    return {
        'fast': (mode_counts.get('Fast', 0) / total) * 100 if total > 0 else 0,
        'standard': (mode_counts.get('Standard', 0) / total) * 100 if total > 0 else 0,
        'strict': (mode_counts.get('Strict', 0) / total) * 100 if total > 0 else 0,
        'top_matches': top_3
    }


def predict_file_changes(requirement: str) -> dict:
    """
    基于需求描述预估文件改动数量
    
    Args:
        requirement: 需求描述文本
    
    Returns:
        {'fast': score, 'standard': score, 'strict': score}
    """
    scores = {'fast': 0, 'standard': 0, 'strict': 0}
    
    # 启发式规则
    estimated_files = 1
    estimated_lines = 10
    
    # 提到前后端 → +2文件
    if '前端' in requirement or '后端' in requirement or 'API' in requirement:
        estimated_files += 2
        estimated_lines += 100
    
    # 提到数据库 → +1文件, +50行
    if '数据库' in requirement or 'schema' in requirement or 'migration' in requirement:
        estimated_files += 1
        estimated_lines += 50
    
    # 提到测试 → +2文件
    if '测试' in requirement or 'test' in requirement:
        estimated_files += 2
    
    # 提到UI/样式 → +1文件
    if 'UI' in requirement or '样式' in requirement or '页面' in requirement:
        estimated_files += 1
        estimated_lines += 80
    
    # 根据预估判断模式
    if estimated_files <= 2 and estimated_lines < 50:
        scores['fast'] = 80
    elif estimated_files <= 6 and estimated_lines < 300:
        scores['standard'] = 70
    else:
        scores['strict'] = 60
    
    return scores


def assess_risk(requirement: str) -> int:
    """
    评估风险等级
    
    Args:
        requirement: 需求描述文本
    
    Returns:
        风险分数 (0-100)
    """
    risk_score = 0
    
    HIGH_RISK_KEYWORDS = [
        '支付', '账单', '订单',
        '鉴权', '权限', '认证',
        'secret', 'password', 'token',
        'schema', 'migration', '数据库结构',
        '公共API', 'SDK',
        '部署', 'CI/CD', 'infra',
        '数据丢失', '不可逆', '删除'
    ]
    
    for keyword in HIGH_RISK_KEYWORDS:
        if keyword.lower() in requirement.lower():
            risk_score += 15
    
    # 上限100
    return min(risk_score, 100)


def calculate_mode_score(requirement: str, history: list = None) -> dict:
    """
    计算模式推荐分数
    
    Args:
        requirement: 需求描述
        history: 历史数据列表（可选）
    
    Returns:
        {'scores': {...}, 'recommended_mode': ..., 'confidence': ...}
    """
    weights = {
        'text': 0.30,
        'history': 0.40,
        'file_prediction': 0.20,
        'risk': 0.10
    }
    
    # 1. 文本特征 (30%)
    text_scores = analyze_text_features(requirement)
    
    # 2. 历史相似性 (40%)
    if history and len(history) >= 3:
        history_scores = calculate_tf_idf(history, requirement)
    else:
        # 无历史数据，均匀分配
        history_scores = {'fast': 33, 'standard': 34, 'strict': 33}
    
    # 3. 文件改动预测 (20%)
    file_scores = predict_file_changes(requirement)
    
    # 4. 风险因子 (10%)
    risk_score = assess_risk(requirement)
    risk_scores = {'fast': 0, 'standard': 0, 'strict': 0}
    if risk_score > 20:
        risk_scores['strict'] = 100
    elif risk_score > 10:
        risk_scores['standard'] = 70
        risk_scores['strict'] = 30
    else:
        risk_scores['fast'] = 80
        risk_scores['standard'] = 20
    
    # 加权求和
    final_scores = {
        'Fast': (
            text_scores['fast'] * weights['text'] +
            history_scores['fast'] * weights['history'] +
            file_scores['fast'] * weights['file_prediction'] +
            risk_scores['fast'] * weights['risk']
        ),
        'Standard': (
            text_scores['standard'] * weights['text'] +
            history_scores['standard'] * weights['history'] +
            file_scores['standard'] * weights['file_prediction'] +
            risk_scores['standard'] * weights['risk']
        ),
        'Strict': (
            text_scores['strict'] * weights['text'] +
            history_scores['strict'] * weights['history'] +
            file_scores['strict'] * weights['file_prediction'] +
            risk_scores['strict'] * weights['risk']
        )
    }
    
    # 归一化到100
    total = sum(final_scores.values())
    if total > 0:
        for mode in final_scores:
            final_scores[mode] = round((final_scores[mode] / total) * 100, 1)
    
    # 置信度 = 最高分
    recommended_mode = max(final_scores, key=final_scores.get)
    confidence = final_scores[recommended_mode]
    
    return {
        'scores': final_scores,
        'recommended_mode': recommended_mode,
        'confidence': confidence
    }


def generate_reasons(requirement: str, result: dict) -> list:
    """生成推荐理由"""
    reasons = []
    
    # 文本特征理由
    if len(requirement) < 20:
        reasons.append("需求描述简短（<20字），倾向于简单改动")
    elif len(requirement) > 100:
        reasons.append("需求描述详细（>100字），可能涉及复杂逻辑")
    
    # 关键词理由
    if any(kw in requirement for kw in ['修复', 'typo']):
        reasons.append("包含\"修复\"关键词，通常是bugfix")
    elif any(kw in requirement for kw in ['功能', '页面']):
        reasons.append("包含\"功能/页面\"关键词，可能是新功能开发")
    
    # 风险理由
    risk_score = assess_risk(requirement)
    if risk_score > 20:
        reasons.append(f"检测到高风险关键词（风险分{risk_score}）")
    
    return reasons if reasons else ["基于历史数据和需求特征综合判断"]


def format_recommendation(result: dict, requirement: str) -> str:
    """
    格式化推荐结果为Markdown
    
    Args:
        result: calculate_mode_score的返回值
        requirement: 原始需求
    
    Returns:
        Markdown格式的推荐结果
    """
    scores = result['scores']
    recommended = result['recommended_mode']
    confidence = result['confidence']
    
    output = f"""🎯 模式推荐：**{recommended}**（置信度 {confidence}%）

**评分详情**:
- Fast: {scores['Fast']}%
- Standard: {scores['Standard']}%
- Strict: {scores['Strict']}% ← 推荐

**推荐理由**:
"""
    
    # 添加理由
    reasons = generate_reasons(requirement, result)
    for i, reason in enumerate(reasons, 1):
        output += f"{i}. {reason}\n"
    
    output += f"""
**其他选项**:
• Fast（{scores['Fast']}%）: 仅当你确定改动很小时
• Strict（{scores['Strict']}%）: 如涉及高风险可考虑

**请确认或选择其他模式**:
1. ✅ {recommended}（推荐）
2. Fast
3. Standard
4. Strict
"""
    
    # 低置信度警告
    if confidence < 60:
        output = f"""⚠️ 模式推荐不确定（最高置信度 {confidence}%）

**评分详情**:
- Fast: {scores['Fast']}%
- Standard: {scores['Standard']}%
- Strict: {scores['Strict']}%

**原因**: 
- 需求描述模糊，难以准确判断
- 历史数据不足

**建议**: 
请补充更多信息，或手动选择模式：
1. Fast - 小改动
2. Standard - 常规功能（默认）
3. Strict - 高风险改动
"""
    
    return output


class ModeHistoryManager:
    """模式历史记录管理器"""
    
    def __init__(self, history_file: str = '.specs/MODE_HISTORY.md'):
        self.history_file = history_file
    
    def load_history(self) -> list:
        """加载历史记录"""
        try:
            with open(self.history_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # 解析Markdown表格（简化版）
            lines = content.strip().split('\n')
            records = []
            
            in_table = False
            for line in lines:
                if line.startswith('| Date'):
                    in_table = True
                    continue
                elif in_table and line.startswith('|'):
                    parts = [p.strip() for p in line.split('|')[1:-1]]
                    if len(parts) >= 9:
                        try:
                            records.append({
                                'date': parts[0],
                                'req_id': parts[1],
                                'requirement_summary': parts[2],
                                'recommended_mode': parts[3].split('(')[0].strip(),
                                'recommended_confidence': float(parts[3].split('(')[1].rstrip('%)')),
                                'selected_mode': parts[4],
                                'actual_files': int(parts[5]),
                                'actual_lines': int(parts[6]),
                                'is_correct': parts[7] == '✅'
                            })
                        except (ValueError, IndexError):
                            continue
            
            return records
        except FileNotFoundError:
            return []
    
    def record_decision(self, req_id: str, requirement: str, 
                       recommended_mode: str, confidence: float,
                       selected_mode: str, actual_files: int, 
                       actual_lines: int):
        """记录模式决策"""
        is_correct = selected_mode == self._get_optimal_mode(actual_files, actual_lines)
        
        record = {
            'date': datetime.now().strftime('%Y-%m-%d'),
            'req_id': req_id,
            'requirement_summary': requirement[:50],
            'recommended_mode': recommended_mode,
            'recommended_confidence': confidence,
            'selected_mode': selected_mode,
            'actual_files': actual_files,
            'actual_lines': actual_lines,
            'is_correct': is_correct
        }
        
        self._append_to_markdown(record)
        
        # 如果误判，调整权重
        if not is_correct:
            self._adjust_weights(record)
    
    def _get_optimal_mode(self, files: int, lines: int) -> str:
        """根据实际改动判断最优模式"""
        if files <= 2 and lines < 50:
            return 'Fast'
        elif files <= 6 and lines < 300:
            return 'Standard'
        else:
            return 'Strict'
    
    def _append_to_markdown(self, record: dict):
        """追加记录到Markdown文件"""
        status = '✅' if record['is_correct'] else '❌'
        line = f"| {record['date']} | {record['req_id']} | {record['requirement_summary']} | {record['recommended_mode']} ({record['recommended_confidence']}%) | {record['selected_mode']} | {record['actual_files']} | {record['actual_lines']} | {status} |\n"
        
        with open(self.history_file, 'a', encoding='utf-8') as f:
            f.write(line)
    
    def _adjust_weights(self, error_record: dict):
        """根据错误案例调整权重（简化版）"""
        # TODO: 实现权重自适应逻辑
        pass


# 测试代码
if __name__ == '__main__':
    # 示例1: 简单bugfix
    req1 = "修复登录按钮typo"
    result1 = calculate_mode_score(req1)
    print(format_recommendation(result1, req1))
    print("\n" + "="*60 + "\n")
    
    # 示例2: 新功能开发
    req2 = "我想做一个用户登录功能"
    result2 = calculate_mode_score(req2)
    print(format_recommendation(result2, req2))
    print("\n" + "="*60 + "\n")
    
    # 示例3: 高风险改动
    req3 = "集成支付宝支付，支持扫码支付"
    result3 = calculate_mode_score(req3)
    print(format_recommendation(result3, req3))
