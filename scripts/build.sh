#!/bin/bash
# 项目构建脚本
# 版本号: 1.0.0
# 用法: ./scripts/build.sh [clean|compile|package|install]

# 引入通用库
source "$(dirname "$0")/lib/common.sh"

# 初始化脚本环境
init_script

# 命令定义
COMMAND=${1:-"install"}
VALID_COMMANDS=("clean" "compile" "package" "install")

# 帮助信息
function show_usage() {
  show_help "构建脚本" "构建Maven项目" \
    "./scripts/build.sh [clean|compile|package|install]" \
    "  clean   - 清理项目构建产物\n  compile - 编译项目代码\n  package - 打包项目\n  install - 构建并安装到本地仓库（默认）"
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

# 执行构建
log_section "开始构建项目"
log_info "使用命令: $COMMAND"

# 执行Maven构建
run_maven "$COMMAND"

log_section "构建完成"