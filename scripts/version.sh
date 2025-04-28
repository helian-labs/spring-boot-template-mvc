#!/bin/bash
# 版本管理脚本
# 版本号: 1.0.0
# 用法: ./scripts/version.sh [current|set <version>|release|next]

# 引入通用库
source "$(dirname "$0")/lib/common.sh"

# 初始化脚本环境
init_script

# 命令定义
COMMAND=${1:-"current"}
VALID_COMMANDS=("current" "set" "release" "next")

# 帮助信息
function show_usage() {
  show_help "版本管理脚本" "管理项目版本" \
    "./scripts/version.sh [current|set <version>|release|next]" \
    "  current       - 显示当前版本（默认）\n  set <version> - 设置指定版本\n  release       - 从快照版本创建发布版本（移除-SNAPSHOT后缀）\n  next          - 从发布版本创建下一个开发版本（增加补丁版本号并添加-SNAPSHOT后缀）"
}

# 检查是否需要显示帮助信息
if [[ "$COMMAND" == "--help" || "$COMMAND" == "-h" ]]; then
  show_usage
  exit 0
fi

# 验证命令
if [[ "$COMMAND" == "set" && -z "$2" ]]; then
  log_error "设置版本需要提供版本号参数"
  show_usage
  exit 1
fi

if [[ "$COMMAND" != "set" && ! " ${VALID_COMMANDS[@]} " =~ " $COMMAND " ]]; then
  show_usage
  exit 1
fi

# 获取当前版本
function current_version() {
  log_section "当前版本"
  VERSION=$(get_project_version)
  log_info "当前项目版本: $VERSION"
  echo "$VERSION"
}

# 设置版本
function set_version() {
  local version=$1
  log_section "设置版本"
  log_info "设置版本为: $version"
  set_project_version "$version"
}

# 创建发布版本
function release_version() {
  log_section "创建发布版本"
  CURRENT=$(get_project_version)
  if [[ $CURRENT == *-SNAPSHOT ]]; then
    RELEASE_VERSION=${CURRENT%-SNAPSHOT}
    log_info "从 $CURRENT 创建发布版本 $RELEASE_VERSION"
    set_project_version "$RELEASE_VERSION"
  else
    log_warn "当前版本 $CURRENT 已经是发布版本"
  fi
}

# 创建下一个开发版本
function next_version() {
  log_section "创建下一个开发版本"
  CURRENT=$(get_project_version)
  if [[ $CURRENT == *-SNAPSHOT ]]; then
    log_warn "当前版本 $CURRENT 已经是快照版本"
  else
    # 简单版本号增加
    MAJOR=$(echo $CURRENT | cut -d. -f1)
    MINOR=$(echo $CURRENT | cut -d. -f2)
    PATCH=$(echo $CURRENT | cut -d. -f3)

    NEXT_PATCH=$((PATCH + 1))
    NEXT_VERSION="$MAJOR.$MINOR.$NEXT_PATCH-SNAPSHOT"

    log_info "从 $CURRENT 创建下一个开发版本 $NEXT_VERSION"
    set_project_version "$NEXT_VERSION"
  fi
}

# 执行命令
case "$COMMAND" in
  current)
    current_version
    ;;
  set)
    set_version "$2"
    ;;
  release)
    release_version
    ;;
  next)
    next_version
    ;;
esac

log_section "版本管理操作完成"