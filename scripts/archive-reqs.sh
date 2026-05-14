#!/bin/bash
# devflow-kit 归档脚本 - Linux/macOS Bash
# 用途: 自动归档30天前的req，防止 .specs/ 目录膨胀
# 用法: sh ./scripts/archive-reqs.sh --project-root <路径> [--days 30]

set -e

# 解析参数
PROJECT_ROOT=""
DAYS_THRESHOLD=30
DRY_RUN=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --project-root)
            PROJECT_ROOT="$2"
            shift 2
            ;;
        --days)
            DAYS_THRESHOLD="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        *)
            echo "❌ 错误: 未知参数 $1"
            echo "用法: sh ./scripts/archive-reqs.sh --project-root <路径> [--days 30] [--dry-run] [--verbose]"
            exit 1
            ;;
    esac
done

# 验证参数
if [ -z "$PROJECT_ROOT" ]; then
    echo "❌ 错误: 请指定项目路径"
    echo "用法: sh ./scripts/archive-reqs.sh --project-root <路径>"
    exit 1
fi

if [ ! -d "$PROJECT_ROOT" ]; then
    echo "❌ 错误: 项目路径不存在: $PROJECT_ROOT"
    exit 1
fi

SPECS_DIR="$PROJECT_ROOT/.specs"
ARCHIVE_DIR="$SPECS_DIR/archive"
INDEX_FILE="$ARCHIVE_DIR/ARCHIVE_INDEX.md"
TODAY=$(date +%s)

echo "========================================"
echo "devflow-kit Req 归档工具"
echo "目标项目: $PROJECT_ROOT"
echo "归档阈值: $DAYS_THRESHOLD 天"
echo "========================================"

# 检查 .specs/ 是否存在
if [ ! -d "$SPECS_DIR" ]; then
    echo "⚠️  警告: .specs/ 目录不存在"
    exit 0
fi

# 获取所有req目录（排除特殊目录）
ARCHIVED_COUNT=0
SKIPPED_COUNT=0
ERROR_COUNT=0

for req_dir in "$SPECS_DIR"/*/; do
    # 跳过不存在的目录（glob未匹配时）
    [ -d "$req_dir" ] || continue
    
    req_name=$(basename "$req_dir")
    
    # 排除特殊目录
    if [[ "$req_name" == "archive" ]] || [[ "$req_name" == ".memory" ]]; then
        continue
    fi
    
    # 获取最后修改时间
    LAST_MODIFIED=$(find "$req_dir" -type f -exec stat -f %m {} + 2>/dev/null | sort -rn | head -1)
    
    if [ -z "$LAST_MODIFIED" ]; then
        # Linux fallback
        LAST_MODIFIED=$(find "$req_dir" -type f -printf '%T@\n' 2>/dev/null | sort -rn | head -1 | cut -d. -f1)
    fi
    
    if [ -z "$LAST_MODIFIED" ]; then
        echo "  ⚠️  跳过 $req_name: 无法确定修改时间"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi
    
    DAYS_OLD=$(( (TODAY - LAST_MODIFIED) / 86400 ))
    
    if [ "$DAYS_OLD" -gt "$DAYS_THRESHOLD" ]; then
        # 创建年月归档目录
        YEAR_MONTH=$(date -r "$LAST_MODIFIED" +%Y-%m 2>/dev/null || date -d "@$LAST_MODIFIED" +%Y-%m)
        TARGET_DIR="$ARCHIVE_DIR/$YEAR_MONTH"
        
        if [ "$DRY_RUN" = true ]; then
            echo "  [DRY RUN] 将归档: $req_name ($DAYS_OLD 天前) → archive/$YEAR_MONTH/"
            ARCHIVED_COUNT=$((ARCHIVED_COUNT + 1))
            continue
        fi
        
        # 创建目标目录
        mkdir -p "$TARGET_DIR"
        
        # 移动req目录
        mv "$req_dir" "$TARGET_DIR/"
        
        if [ "$VERBOSE" = true ]; then
            echo "  ✅ 归档: $req_name ($DAYS_OLD 天前)"
        else
            echo "  ✅ $req_name"
        fi
        
        ARCHIVED_COUNT=$((ARCHIVED_COUNT + 1))
        
        # 更新 ARCHIVE_INDEX.md
        update_archive_index "$INDEX_FILE" "$req_name" "$YEAR_MONTH" "$LAST_MODIFIED"
    else
        if [ "$VERBOSE" = true ]; then
            echo "  ⏭️  跳过: $req_name ($DAYS_OLD 天前，未达阈值)"
        fi
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    fi
done

# 输出统计
echo ""
echo "========================================"
echo "归档完成!"
echo "========================================"
echo ""
echo "统计:"
echo "  ✅ 已归档: $ARCHIVED_COUNT 个req"
echo "  ⏭️  已跳过: $SKIPPED_COUNT 个req"
if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "  ❌ 错误: $ERROR_COUNT 个req"
fi
echo ""

if [ "$DRY_RUN" = true ]; then
    echo "注意: 这是预览模式，未实际移动文件"
    echo "移除 --dry-run 参数以执行实际归档"
else
    echo "归档位置: $ARCHIVE_DIR"
    echo "索引文件: $INDEX_FILE"
fi

echo ""

# 辅助函数：更新 ARCHIVE_INDEX.md
update_archive_index() {
    local index_file="$1"
    local req_name="$2"
    local year_month="$3"
    local last_modified="$4"
    
    local completed_date=$(date -r "$last_modified" +%Y-%m-%d 2>/dev/null || date -d "@$last_modified" +%Y-%m-%d)
    
    # 如果索引文件不存在，创建它
    if [ ! -f "$index_file" ]; then
        cat > "$index_file" << 'EOF'
# Archive Index

> 自动生成的归档索引，请勿手动编辑

EOF
    fi
    
    # 检查是否已有该年月的章节
    if ! grep -q "^## $year_month$" "$index_file"; then
        # 添加新年月章节
        cat >> "$index_file" << EOF

## $year_month

| Req-ID | 完成日期 | 状态 |
|--------|---------|------|
| $req_name | $completed_date | ✅ 已归档 |

EOF
    else
        # 在现有章节中添加条目
        # 找到章节位置并插入到表格中
        local temp_file=$(mktemp)
        awk -v section="## $year_month" -v new_line="| $req_name | $completed_date | ✅ 已归档 |" '
        BEGIN { found=0; inserted=0 }
        {
            print
            if ($0 == section && !found) {
                found=1
            }
            if (found && !inserted && /^|---/) {
                # 下一行是表头，再下一行插入
                getline header
                print header
                print new_line
                inserted=1
            }
        }
        ' "$index_file" > "$temp_file"
        mv "$temp_file" "$index_file"
    fi
}
