# Security and Performance

> 合并自：security-and-hardening, performance-optimization

---

## Security Checklist

### 输入验证
- [ ] 所有用户输入必须验证
- [ ] 使用白名单而非黑名单
- [ ] 长度、类型、格式检查

### 认证与授权
- [ ] 使用强密码策略
- [ ] JWT token过期时间合理
- [ ] 权限校验在服务端
- [ ] 敏感操作需要二次确认

### 数据安全
- [ ] 密码哈希存储（bcrypt）
- [ ] 敏感数据加密
- [ ] SQL参数化查询
- [ ] XSS防护（转义输出）

### 常见漏洞防护
- **SQL注入**: 使用ORM/参数化查询
- **XSS**: 转义HTML输出
- **CSRF**: 使用token验证
- **DDoS**: 限流+验证码

---

## Performance Optimization

### 前端优化
- [ ] 代码分割（Code Splitting）
- [ ] 懒加载图片/组件
- [ ] 缓存静态资源
- [ ] 减少HTTP请求

### 后端优化
- [ ] 数据库索引优化
- [ ] 查询避免N+1
- [ ] 缓存热点数据（Redis）
- [ ] 异步处理耗时操作

### 性能指标
- **FCP** (First Contentful Paint): < 1.8s
- **LCP** (Largest Contentful Paint): < 2.5s
- **FID** (First Input Delay): < 100ms
- **CLS** (Cumulative Layout Shift): < 0.1

### 监控工具
- Lighthouse
- WebPageTest
- New Relic / DataDog
