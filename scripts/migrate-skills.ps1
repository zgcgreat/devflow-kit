# devflow-kit Skill 迁移脚本 - Windows PowerShell
# 用途: 将22个旧skill合并为12个新skill
# 用法: .\scripts\migrate-skills.ps1 -ProjectRoot <路径> [-DryRun]

param(
    [string]$ProjectRoot,
    [switch]$DryRun,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

# 验证参数
if (-not $ProjectRoot) {
    Write-Host "❌ 错误: 请指定项目路径" -ForegroundColor Red
    Write-Host "用法: .\scripts\migrate-skills.ps1 -ProjectRoot <路径>" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $ProjectRoot)) {
    Write-Host "❌ 错误: 项目路径不存在: $ProjectRoot" -ForegroundColor Red
    exit 1
}

$SkillsDir = Join-Path $ProjectRoot "devflow-kit\agent-skills\skills"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "devflow-kit Skill 迁移工具" -ForegroundColor Cyan
Write-Host "目标项目: $ProjectRoot" -ForegroundColor Cyan
Write-Host "模式: $(if ($DryRun) {'预览'} else {'执行'})" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 检查skills目录是否存在
if (-not (Test-Path $SkillsDir)) {
    Write-Host "⚠️  警告: skills目录不存在: $SkillsDir" -ForegroundColor Yellow
    exit 0
}

# 定义合并映射
$MergeMap = @{
    'design-and-architecture' = @('api-and-interface-design', 'source-driven-development', 'documentation-and-adrs')
    'testing-suite' = @('test-driven-development', 'browser-testing-with-devtools')
    'code-quality' = @('code-review-and-quality', 'code-simplification')
    'devops' = @('ci-cd-and-automation', 'git-workflow-and-versioning', 'shipping-and-launch')
    'security-and-performance' = @('security-and-hardening', 'performance-optimization')
    'development-core' = @('incremental-implementation', 'spec-driven-development', 'doubt-driven-development')
    'planning-and-context' = @('planning-and-task-breakdown', 'context-engineering')
}

# 保持不变的skill
$KeepSkills = @('idea-refine', 'frontend-ui-engineering', 'debugging-and-error-recovery', 'deprecation-and-migration', 'using-agent-skills')

$MergedCount = 0
$SkippedCount = 0
$ErrorCount = 0

foreach ($newSkill in $MergeMap.Keys) {
    $oldSkills = $MergeMap[$newSkill]
    $newSkillPath = Join-Path $SkillsDir $newSkill
    
    Write-Host "`n处理: $newSkill" -ForegroundColor White
    Write-Host "  合并: $($oldSkills -join ', ')" -ForegroundColor Gray
    
    # 检查是否已存在新skill
    if (Test-Path $newSkillPath) {
        Write-Host "  ⚠️  跳过: 新skill已存在" -ForegroundColor Yellow
        $SkippedCount++
        continue
    }
    
    if ($DryRun) {
        Write-Host "  [DRY RUN] 将创建 $newSkill 并合并 $($oldSkills.Count) 个旧skill" -ForegroundColor Cyan
        $MergedCount++
        continue
    }
    
    try {
        # 创建新skill目录
        New-Item -ItemType Directory -Path $newSkillPath -Force | Out-Null
        
        # 合并旧skill内容
        $mergedContent = "# $newSkill`n`n"
        $mergedContent += "> 由以下skill合并而成：$($oldSkills -join ', ')`n`n---`n`n"
        
        foreach ($oldSkill in $oldSkills) {
            $oldSkillPath = Join-Path $SkillsDir $oldSkill
            $skillFile = Join-Path $oldSkillPath "_SKILL.md"
            
            if (Test-Path $skillFile) {
                $content = Get-Content -Path $skillFile -Raw
                $mergedContent += "## $oldSkill`n`n$content`n`n---`n`n"
                
                if ($Verbose) {
                    Write-Host "    ✅ 合并: $oldSkill" -ForegroundColor Green
                }
            } else {
                Write-Host "    ⚠️  警告: $oldSkill 缺少 _SKILL.md" -ForegroundColor Yellow
            }
        }
        
        # 写入新的_SKILL.md
        $newSkillFile = Join-Path $newSkillPath "_SKILL.md"
        Set-Content -Path $newSkillFile -Value $mergedContent -Encoding UTF8
        
        Write-Host "  ✅ 创建成功: $newSkill" -ForegroundColor Green
        $MergedCount++
        
    } catch {
        Write-Host "  ❌ 错误: $_" -ForegroundColor Red
        $ErrorCount++
    }
}

# 输出统计
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "迁移完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "统计:" -ForegroundColor White
Write-Host "  ✅ 已合并: $MergedCount 个新skill" -ForegroundColor Green
Write-Host "  ⏭️  已跳过: $SkippedCount 个skill" -ForegroundColor Yellow
if ($ErrorCount -gt 0) {
    Write-Host "  ❌ 错误: $ErrorCount 个skill" -ForegroundColor Red
}
Write-Host ""

if ($DryRun) {
    Write-Host "注意: 这是预览模式，未实际修改文件" -ForegroundColor Yellow
    Write-Host "移除 -DryRun 参数以执行实际迁移" -ForegroundColor Yellow
} else {
    Write-Host "下一步:" -ForegroundColor White
    Write-Host "1. 更新 GO.md 中的skill引用" -ForegroundColor White
    Write-Host "2. 测试流程是否正常" -ForegroundColor White
    Write-Host "3. 删除旧的skill目录（确认无误后）" -ForegroundColor White
}

Write-Host ""
