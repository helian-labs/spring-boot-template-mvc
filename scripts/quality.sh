#!/bin/bash
# 代码质量检查脚本
# 版本号: 1.0.0
# 用法: ./scripts/quality.sh [all|format|spotbugs|pmd|checkstyle]

# 引入通用库
source "$(dirname "$0")/lib/common.sh"

# 初始化脚本环境
init_script

# 命令定义
COMMAND=${1:-"all"}
VALID_COMMANDS=("all" "format" "spotbugs" "pmd" "checkstyle")

# 帮助信息
function show_usage() {
  show_help "代码质量检查脚本" "运行代码质量检查工具" \
    "./scripts/quality.sh [all|format|spotbugs|pmd|checkstyle]" \
    "  all       - 运行所有质量检查（默认）\n  format    - 运行代码格式检查\n  spotbugs  - 运行静态代码分析\n  pmd       - 运行PMD代码分析\n  checkstyle - 运行代码规范检查"
}

# 检查是否需要显示帮助信息
if [[ "$COMMAND" == "--help" || "$COMMAND" == "-h" ]]; then
  show_usage
  exit 0
fi

# 验证命令
if ! validate_command "$COMMAND" "${VALID_COMMANDS[@]}"; then
  show_usage
  exit 1
fi

# 运行代码格式检查
function run_format() {
  log_section "运行 Spotless 代码格式检查"
  run_maven spotless:check -P quality || {
    log_warn "Spotless 检查失败，尝试自动修复..."
    run_maven spotless:apply -P quality
  }
}

# 运行静态代码分析
function run_spotbugs() {
  log_section "运行 SpotBugs 静态代码分析"
  run_maven spotbugs:check -P quality
}

# 运行PMD代码分析
function run_pmd() {
  log_section "运行 PMD 代码分析"
  run_maven pmd:check -P quality
}

# 运行Checkstyle代码规范检查
function run_checkstyle() {
  log_section "运行 Checkstyle 代码规范检查"
  run_maven checkstyle:check -P quality
}

# 运行所有质量检查
function run_all() {
  run_format
  run_spotbugs
  run_pmd
  run_checkstyle
}

# 执行命令
case "$COMMAND" in
  format)
    run_format
    ;;
  spotbugs)
    run_spotbugs
    ;;
  pmd)
    run_pmd
    ;;
  checkstyle)
    run_checkstyle
    ;;
  all)
    run_all
    ;;
esac

log_section "代码质量检查完成"

# 提示如何查看详细报告
log_info "提示："
log_info "- 使用 './scripts/quality.sh format' 检查和修复代码格式"
log_info "- 使用 './scripts/test.sh coverage' 生成详细的代码覆盖率报告"