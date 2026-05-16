# DevOps

> 合并自：ci-cd-and-automation, git-workflow-and-versioning, shipping-and-launch

---

## Git Workflow

### 分支策略
- `main` - 生产环境
- `develop` - 开发主分支
- `feature/*` - 功能分支
- `hotfix/*` - 紧急修复

### Commit规范
```
type(scope): subject

body

footer
```

**Type**: feat/fix/docs/style/refactor/test/chore

**示例**:
```
feat(auth): add JWT authentication

- Implement login endpoint
- Add token validation middleware

Closes #123
```

---

## CI/CD Pipeline

### 基本流程
```
Push → Build → Test → Deploy
```

### 关键步骤
1. **Lint** - 代码风格检查
2. **Build** - 编译/打包
3. **Test** - 单元测试+集成测试
4. **Security Scan** - 安全扫描
5. **Deploy** - 部署到 staging/prod

---

## Shipping Checklist

### 发布前
- [ ] 所有测试通过
- [ ] 代码审查完成
- [ ] CHANGELOG更新
- [ ] 版本号递增
- [ ] 数据库migration准备

### 发布中
- [ ] 备份数据库
- [ ] 执行migration
- [ ] 部署新版本
- [ ] 健康检查

### 发布后
- [ ] 监控错误率
- [ ] 验证核心功能
- [ ] 性能指标正常
- [ ] 用户反馈收集

### 回滚方案
如果出现问题：
1. 立即回滚到上一版本
2. 分析问题原因
3. 修复后重新发布
