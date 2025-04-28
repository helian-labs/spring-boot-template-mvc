#!/bin/bash
# 发布管理脚本
# 版本号: 1.0.0
# 用法: ./scripts/release.sh [prepare|perform]

# 引入通用库
source "$(dirname "$0")/lib/common.sh"

# 初始化脚本环境
init_script

# 命令定义
COMMAND=${1:-"prepare"}
VALID_COMMANDS=("prepare" "perform")

# 帮助信息
function show_usage() {
  show_help "发布管理脚本" "准备和执行项目发布" \
    "./scripts/release.sh [prepare|perform]" \
    "  prepare - 准备发布（运行测试，创建发布版本，默认）\n  perform - 执行发布（提交更改，创建标签，部署，创建下一个开发版本）"
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

# 准备发布
function prepare_release() {
  log_section "准备发布"

  # 检查工作区是否干净
  if ! check_git_clean; then
    exit 1
  fi

  # 更新到最新代码
  log_info "更新到最新代码"
  git pull

  # 运行测试
  log_info "运行测试"
  run_maven clean test

  # 从快照版本创建发布版本
  log_info "创建发布版本"
  "$PROJECT_ROOT/scripts/version.sh" release

  log_info "发布版本已准备就绪"
  log_info "请检查更改，然后运行 './scripts/release.sh perform' 完成发布"
}

# 执行发布
function perform_release() {
  log_section "执行发布"

  VERSION=$(get_project_version)

  # 提交版本更改
  log_info "提交版本更改"
  git add .
  git commit -m "Release version $VERSION"

  # 创建标签
  log_info "创建标签 v$VERSION"
  git tag -a "v$VERSION" -m "Release version $VERSION"

  # 构建并部署
  log_info "构建并部署"
  run_maven clean deploy

  # 创建下一个开发版本
  log_info "创建下一个开发版本"
  "$PROJECT_ROOT/scripts/version.sh" next

  # 提交新版本
  NEW_VERSION=$(get_project_version)
  log_info "提交新版本 $NEW_VERSION"
  git add .
  git commit -m "Prepare for next development iteration $NEW_VERSION"

  log_info "推送更改和标签到远程仓库"
  git push origin main
  git push origin "v$VERSION"

  log_info "发布完成: $VERSION"
  log_info "下一个开发版本: $NEW_VERSION"
}

# 执行命令
case "$COMMAND" in
  prepare)
    prepare_release
    ;;
  perform)
    perform_release
    ;;
esac

log_section "发布管理操作完成"