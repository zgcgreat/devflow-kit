# devflow-kit 归档脚本 - Windows PowerShell
# 用途: 自动归档30天前的req，防止 .specs/ 目录膨胀
# 用法: .\scripts\archive-reqs.ps1 -ProjectRoot <路径> [-DaysThreshold 30]

param(
    [string]$ProjectRoot,
    [int]$DaysThreshold = 30,
    [switch]$DryRun,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

# 验证参数
if (-not $ProjectRoot) {
    Write-Host "❌ 错误: 请指定项目路径" -ForegroundColor Red
    Write-Host "用法: .\scripts\archive-reqs.ps1 -ProjectRoot <路径>" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $ProjectRoot)) {
    Write-Host "❌ 错误: 项目路径不存在: $ProjectRoot" -ForegroundColor Red
    exit 1
}

$SpecsDir = Join-Path $ProjectRoot ".specs"
$ArchiveDir = Join-Path $SpecsDir "archive"
$IndexFile = Join-Path $ArchiveDir "ARCHIVE_INDEX.md"
$Today = Get-Date

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "devflow-kit Req 归档工具" -ForegroundColor Cyan
Write-Host "目标项目: $ProjectRoot" -ForegroundColor Cyan
Write-Host "归档阈值: $DaysThreshold 天" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 检查 .specs/ 是否存在
if (-not (Test-Path $SpecsDir)) {
    Write-Host "⚠️  警告: .specs/ 目录不存在" -ForegroundColor Yellow
    exit 0
}

# 获取所有req目录（排除特殊目录）
$ExcludedDirs = @("archive", ".memory")
$ReqDirs = Get-ChildItem -Path $SpecsDir -Directory | 
           Where-Object { $_.Name -notin $ExcludedDirs }

if ($ReqDirs.Count -eq 0) {
    Write-Host "✅ 没有需要归档的req" -ForegroundColor Green
    exit 0
}

Write-Host "`n扫描到 $($ReqDirs.Count) 个req目录..." -ForegroundColor White

$ArchivedCount = 0
$SkippedCount = 0
$ErrorCount = 0

foreach ($req in $ReqDirs) {
    try {
        # 获取最后修改时间
        $LastModified = (Get-ChildItem -Path $req.FullName -Recurse -File | 
                         Sort-Object LastWriteTime -Descending | 
                         Select-Object -First 1).LastWriteTime
        
        if (-not $LastModified) {
            Write-Host "  ⚠️  跳过 $($req.Name): 无法确定修改时间" -ForegroundColor Yellow
            $SkippedCount++
            continue
        }
        
        $DaysOld = ($Today - $LastModified).Days
        
        if ($DaysOld -gt $DaysThreshold) {
            # 创建年月归档目录
            $YearMonth = $LastModified.ToString("yyyy-MM")
            $TargetDir = Join-Path $ArchiveDir $YearMonth
            
            if ($DryRun) {
                Write-Host "  [DRY RUN] 将归档: $($req.Name) ($DaysOld 天前) → archive/$YearMonth/" -ForegroundColor Gray
                $ArchivedCount++
                continue
            }
            
            # 创建目标目录
            if (-not (Test-Path $TargetDir)) {
                New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
            }
            
            # 移动req目录
            Move-Item -Path $req.FullName -Destination (Join-Path $TargetDir $req.Name) -Force
            
            if ($Verbose) {
                Write-Host "  ✅ 归档: $($req.Name) ($DaysOld 天前)" -ForegroundColor Green
            } else {
                Write-Host "  ✅ $($req.Name)" -ForegroundColor Green
            }
            
            $ArchivedCount++
            
            # 更新 ARCHIVE_INDEX.md
            Update-ArchiveIndex -IndexFile $IndexFile -ReqName $req.Name -YearMonth $YearMonth -CompletedDate $LastModified
        } else {
            if ($Verbose) {
                Write-Host "  ⏭️  跳过: $($req.Name) ($DaysOld 天前，未达阈值)" -ForegroundColor DarkGray
            }
            $SkippedCount++
        }
    } catch {
        Write-Host "  ❌ 错误: $($req.Name) - $_" -ForegroundColor Red
        $ErrorCount++
    }
}

# 输出统计
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "归档完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "统计:" -ForegroundColor White
Write-Host "  ✅ 已归档: $ArchivedCount 个req" -ForegroundColor Green
Write-Host "  ⏭️  已跳过: $SkippedCount 个req" -ForegroundColor Yellow
if ($ErrorCount -gt 0) {
    Write-Host "  ❌ 错误: $ErrorCount 个req" -ForegroundColor Red
}
Write-Host ""

if ($DryRun) {
    Write-Host "注意: 这是预览模式，未实际移动文件" -ForegroundColor Yellow
    Write-Host "移除 -DryRun 参数以执行实际归档" -ForegroundColor Yellow
} else {
    Write-Host "归档位置: $ArchiveDir" -ForegroundColor White
    Write-Host "索引文件: $IndexFile" -ForegroundColor White
}

Write-Host ""

# 辅助函数：更新 ARCHIVE_INDEX.md
function Update-ArchiveIndex {
    param(
        [string]$IndexFile,
        [string]$ReqName,
        [string]$YearMonth,
        [datetime]$CompletedDate
    )
    
    # 如果索引文件不存在，创建它
    if (-not (Test-Path $IndexFile)) {
        $InitialContent = @"
# Archive Index

> 自动生成的归档索引，请勿手动编辑

"@
        Set-Content -Path $IndexFile -Value $InitialContent -Encoding UTF8
    }
    
    # 读取现有内容
    $Content = Get-Content -Path $IndexFile -Raw
    
    # 检查是否已有该年月的章节
    $SectionHeader = "## $YearMonth"
    if ($Content -notmatch [regex]::Escape($SectionHeader)) {
        # 添加新年月章节
        $NewSection = @"

$SectionHeader

| Req-ID | 完成日期 | 状态 |
|--------|---------|------|
| $ReqName | $($CompletedDate.ToString('yyyy-MM-dd')) | ✅ 已归档 |

"@
        Add-Content -Path $IndexFile -Value $NewSection -Encoding UTF8
    } else {
        # 在现有章节中添加条目
        $Lines = Get-Content -Path $IndexFile
        $NewLine = "| $ReqName | $($CompletedDate.ToString('yyyy-MM-dd')) | ✅ 已归档 |"
        
        # 找到章节位置并插入
        $SectionIndex = $Lines.IndexOf($SectionHeader)
        if ($SectionIndex -ge 0) {
            # 找到表格分隔线后的位置
            $InsertIndex = $SectionIndex + 3  # 标题 + 分隔线 + 表头
            $Lines = $Lines[0..$InsertIndex] + $NewLine + $Lines[($InsertIndex+1)..($Lines.Length-1)]
            $Lines | Set-Content -Path $IndexFile -Encoding UTF8
        }
    }
}
