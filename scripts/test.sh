#!/bin/bash
# 项目测试脚本
# 版本号: 1.0.0
# 用法: ./scripts/test.sh [unit|integration|coverage|all]

# 引入通用库
source "$(dirname "$0")/lib/common.sh"

# 初始化脚本环境
init_script

# 命令定义
COMMAND=${1:-"unit"}
VALID_COMMANDS=("unit" "integration" "coverage" "all")

# 帮助信息
function show_usage() {
  show_help "测试脚本" "运行项目测试" \
    "./scripts/test.sh [unit|integration|coverage|all]" \
    "  unit        - 运行单元测试（默认）\n  integration - 运行集成测试\n  coverage    - 生成代码覆盖率报告\n  all         - 运行所有测试并生成覆盖率报告"
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

# 运行单元测试
function run_unit_tests() {
  log_section "运行单元测试"
  run_maven test
}

# 运行集成测试
function run_integration_tests() {
  log_section "运行集成测试"
  run_maven verify -DskipUnitTests
}

# 生成覆盖率报告
function generate_coverage() {
  log_section "生成代码覆盖率报告"
  run_maven verify
  
  log_info "覆盖率报告生成在: target/site/jacoco/"
  log_info "可以在浏览器中打开 target/site/jacoco/index.html 查看详细报告"
}

# 执行命令
case "$COMMAND" in
  unit)
    run_unit_tests
    ;;
  integration)
    run_integration_tests
    ;;
  coverage)
    generate_coverage
    ;;
  all)
    run_unit_tests
    run_integration_tests
    generate_coverage
    ;;
esac

log_section "测试完成"