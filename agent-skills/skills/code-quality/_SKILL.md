# Code Quality

> 合并自：code-review-and-quality, code-simplification

---

## Code Review Checklist

### 功能性
- [ ] 需求是否完全实现
- [ ] 边界条件是否处理
- [ ] 错误处理是否完善

### 代码质量
- [ ] 命名是否清晰
- [ ] 函数是否单一职责
- [ ] 是否有重复代码
- [ ] 注释是否必要且准确

### 安全性
- [ ] 输入验证
- [ ] SQL注入防护
- [ ] XSS防护
- [ ] 敏感信息不硬编码

### 性能
- [ ] 无N+1查询
- [ ] 缓存合理使用
- [ ] 无内存泄漏风险

---

## Code Simplification Patterns

### 提取方法
**Before**:
```python
def process():
    # 50行复杂逻辑
    ...
```

**After**:
```python
def process():
    data = validate_input()
    result = transform(data)
    save(result)
```

### 消除重复
- DRY原则
- 提取公共函数
- 使用继承/组合

### 简化条件
**Before**:
```python
if x > 0 and x < 10 and y > 0 and y < 10:
```

**After**:
```python
if is_in_range(x, y):
```
