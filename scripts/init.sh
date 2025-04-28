#!/bin/bash
# 项目初始化脚本
# 版本号: 1.0.0
# 用法: ./scripts/init.sh

# 引入通用库
source "$(dirname "$0")/lib/common.sh"

# 初始化脚本环境
set_error_handling
cd "$PROJECT_ROOT"

log_section "初始化项目环境"

# 确保脚本可执行
log_info "设置脚本执行权限"
chmod +x "$PROJECT_ROOT"/scripts/lib/*.sh || { log_error "设置脚本权限失败"; exit 1; }
chmod +x "$PROJECT_ROOT"/scripts/*.sh || { log_error "设置脚本权限失败"; exit 1; }

# 初始化 Git 钩子
if [ -d "$PROJECT_ROOT/.git" ]; then
  log_info "设置 Git 钩子..."

  # 创建 pre-commit 钩子
  mkdir -p "$PROJECT_ROOT/.git/hooks" || { log_error "创建 Git 钩子目录失败"; exit 1; }
  cat > "$PROJECT_ROOT/.git/hooks/pre-commit" << 'EOF'
#!/bin/bash
# 运行测试确保代码可以构建
./scripts/test.sh unit

# 如果测试失败，阻止提交
if [ $? -ne 0 ]; then
  echo "测试失败，提交被阻止"
  exit 1
fi

# 运行代码格式检查
./scripts/quality.sh format

# 如果格式检查失败，阻止提交
if [ $? -ne 0 ]; then
  echo "代码格式检查失败，提交被阻止"
  echo "请运行 './scripts/quality.sh format' 来自动修复格式问题"
  exit 1
fi
EOF
  chmod +x "$PROJECT_ROOT/.git/hooks/pre-commit" || { log_error "设置 Git 钩子权限失败"; exit 1; }

  log_info "Git 钩子设置完成"
fi

# 安装依赖
log_info "构建项目..."
run_maven clean install -DskipTests

log_section "项目初始化完成"

# 显示可用脚本
log_info "您可以使用以下脚本:"
log_info "  ./scripts/build.sh     - 构建项目"
log_info "  ./scripts/test.sh      - 运行测试"
log_info "  ./scripts/quality.sh   - 运行代码质量检查"
log_info "  ./scripts/version.sh   - 管理项目版本"
log_info "  ./scripts/dependency.sh - 管理项目依赖"
log_info "  ./scripts/release.sh   - 发布项目"