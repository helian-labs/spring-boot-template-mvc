#!/bin/bash
# 依赖管理脚本
# 版本号: 1.0.0
# 用法: ./scripts/dependency.sh [list|tree|update|analyze|revert]

# 引入通用库
source "$(dirname "$0")/lib/common.sh"

# 初始化脚本环境
init_script

# 命令定义
COMMAND=${1:-"list"}
VALID_COMMANDS=("list" "tree" "update" "analyze" "revert")

# 帮助信息
function show_usage() {
  show_help "依赖管理脚本" "管理和分析项目依赖" \
    "./scripts/dependency.sh [list|tree|update|analyze|revert]" \
    "  list    - 列出所有依赖的版本信息（默认）\n  tree    - 显示依赖树结构\n  update  - 更新依赖到最新版本\n  analyze - 分析依赖冲突和使用情况\n  revert  - 撤销依赖版本更改"
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

# 列出依赖版本信息
function list_versions() {
  log_section "列出所有依赖的版本信息"

  log_info "当前依赖版本:"
  run_maven versions:display-dependency-updates

  log_info "当前插件版本:"
  run_maven versions:display-plugin-updates

  log_info "属性版本:"
  run_maven versions:display-property-updates
}

# 显示依赖树
function show_tree() {
  log_section "显示依赖树"
  run_maven dependency:tree
}

# 更新依赖版本
function update_versions() {
  log_section "更新依赖到最新版本"

  # 1. 仅显示可更新版本但不实际更新
  log_info "检查可更新的依赖版本..."
  run_maven versions:display-dependency-updates

  # 2. 交互式确认是否继续
  read -p "确认要更新所有依赖到最新版本吗? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "已取消更新操作"
    return 1
  fi

  # 3. 分步骤更新
  log_info "更新依赖版本..."
  run_maven versions:use-latest-versions

  log_info "更新属性版本..."
  run_maven versions:update-properties

  # 4. 显示更新结果
  log_info "依赖版本更新完成，请检查以下更新结果:"
  run_maven versions:display-dependency-updates
  run_maven versions:display-plugin-updates

  log_info "如需撤销更改，可以运行 './scripts/dependency.sh revert'"
}

# 分析依赖
function analyze_dependencies() {
  log_section "分析依赖冲突和使用情况"
  run_maven dependency:analyze
}

# 撤销版本更改
function revert_changes() {
  log_section "撤销版本更改"
  if [ -f "pom.xml.versionsBackup" ]; then
    run_maven versions:revert
    log_info "已撤销版本更改"
  else
    log_warn "没有找到备份文件，无法撤销更改"
  fi
}

# 执行命令
case "$COMMAND" in
  list)
    list_versions
    ;;
  tree)
    show_tree
    ;;
  update)
    update_versions
    ;;
  analyze)
    analyze_dependencies
    ;;
  revert)
    revert_changes
    ;;
esac

log_section "依赖管理操作完成"