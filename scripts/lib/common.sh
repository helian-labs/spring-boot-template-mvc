#!/bin/bash
# 通用函数库
# 版本号: 1.0.0
# 此文件包含所有脚本共用的函数和变量

# 获取脚本和项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}"
PROJECT_ROOT="$(dirname "$(dirname "${SCRIPT_DIR}")")"

# 颜色定义
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# 日志函数
log_info() {
  echo -e "${GREEN}[INFO]${NC} $@"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $@"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $@"
}

log_section() {
  echo -e "\n${BLUE}===== $@ =====${NC}"
}

# 错误处理
handle_error() {
  log_error "执行过程中发生错误，退出代码: $?"
  exit 1
}

# 设置错误处理
set_error_handling() {
  set -e
  trap 'handle_error' ERR
}

# 验证命令是否有效
validate_command() {
  local cmd=$1
  shift
  local valid_commands=("$@")

  for valid_cmd in "${valid_commands[@]}"; do
    if [[ "$cmd" == "$valid_cmd" ]]; then
      return 0
    fi
  done

  log_error "无效的命令: '${cmd}'"
  return 1
}

# 显示帮助信息
show_help() {
  local script_name=$1
  local description=$2
  local usage=$3
  local commands=$4

  echo -e "${CYAN}${description}${NC}"
  echo -e "${YELLOW}用法:${NC} ${usage}"
  echo -e "${YELLOW}命令:${NC}"
  echo -e "$commands"
}

# 获取项目版本
get_project_version() {
  cd "$PROJECT_ROOT"
  ./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout
}

# 设置项目版本
set_project_version() {
  local version=$1
  cd "$PROJECT_ROOT"

  log_info "更新项目根目录的版本号为: $version"
  ./mvnw versions:set-property -Dproperty=revision -DnewVersion="$version" -DprocessAllModules=true -DgenerateBackupPoms=false || { log_error "更新项目版本失败"; exit 1; }
}

# 检查工作区是否干净
check_git_clean() {
  if [ -n "$(git status --porcelain)" ]; then
    log_error "工作区不干净，请先提交或暂存更改"
    return 1
  fi
  return 0
}

# 运行Maven命令
run_maven() {
  cd "$PROJECT_ROOT"
  ./mvnw "$@"
}

# 初始化脚本环境
init_script() {
  set_error_handling
  cd "$PROJECT_ROOT"
}