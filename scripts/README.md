# Maven项目脚本工具集

本工具集提供了一套完整的Maven项目开发、构建和维护脚本，遵循企业级最佳实践设计，采用模块化架构，确保脚本的可维护性和可扩展性。

## 环境要求

| 依赖项 | 最低版本 | 说明 |
|--------|----------|------|
| Bash   | 4.0+     | 脚本执行环境 |
| Maven  | 3.6+     | 项目构建工具 |
| Java   | 8+       | 运行环境 |
| Git    | 2.0+     | 版本控制 |

## 快速开始

1. **设置脚本权限**

   ```bash
   chmod +x scripts/*.sh scripts/lib/*.sh
   ```

2. **初始化项目**

   ```bash
   ./scripts/init.sh
   ```

3. **构建项目**

   ```bash
   ./scripts/build.sh install
   ```

## 脚本架构

工具集采用分层架构设计：

```bash
scripts/
├── lib/                 # 共享库目录
│   └── common.sh        # 通用函数库（日志、错误处理、Maven操作等）
├── build.sh             # 项目构建脚本
├── test.sh              # 测试执行脚本
├── quality.sh           # 代码质量检查脚本
├── version.sh           # 版本管理脚本
├── dependency.sh        # 依赖管理脚本
├── release.sh           # 发布管理脚本
└── init.sh              # 项目初始化脚本
```

### 核心功能

| 模块 | 功能描述 |
|------|----------|
| 通用函数库 | 提供统一的日志输出、错误处理、Maven命令封装等基础功能 |
| 构建管理 | 支持清理、编译、打包、安装等标准Maven生命周期 |
| 测试管理 | 集成单元测试、集成测试和代码覆盖率分析 |
| 质量控制 | 集成代码格式检查、静态分析、规范检查等质量工具 |
| 版本控制 | 支持语义化版本管理和发布流程 |
| 依赖管理 | 提供依赖分析、更新和冲突检测功能 |

## 设计原则

- **模块化设计**：每个脚本专注于单一职责，便于维护和扩展
- **代码复用**：通用功能统一封装在`lib/common.sh`中
- **统一接口**：所有脚本采用一致的命令行参数格式和帮助信息
- **健壮性**：完善的错误处理和日志记录机制
- **自文档化**：详细的帮助信息和使用说明

## 使用指南

### 查看帮助

使用 `-h` 或 `--help` 参数可查看帮助信息：

```bash
# 构建脚本帮助
./scripts/build.sh -h
构建Maven项目
用法: ./scripts/build.sh [clean|compile|package|install]
命令:
  clean   - 清理项目构建产物
  compile - 编译项目代码
  package - 打包项目
  install - 构建并安装到本地仓库（默认）

# 测试脚本帮助
./scripts/test.sh -h
运行项目测试
用法: ./scripts/test.sh [unit|integration|coverage|all]
命令:
  unit        - 运行单元测试（默认）
  integration - 运行集成测试
  coverage    - 生成代码覆盖率报告
  all         - 运行所有测试并生成覆盖率报告

# 质量检查脚本帮助
./scripts/quality.sh -h
运行代码质量检查工具
用法: ./scripts/quality.sh [all|format|spotbugs|pmd|checkstyle]
命令:
  all        - 运行所有质量检查（默认）
  format     - 运行代码格式检查
  spotbugs   - 运行静态代码分析
  pmd        - 运行PMD代码分析
  checkstyle - 运行代码规范检查

# 版本管理脚本帮助
./scripts/version.sh -h
管理项目版本
用法: ./scripts/version.sh [current|set <version>|release|next]
命令:
  current       - 显示当前版本（默认）
  set <version> - 设置指定版本
  release       - 从快照版本创建发布版本
  next          - 创建下一个开发版本

# 依赖管理脚本帮助
./scripts/dependency.sh -h
管理和分析项目依赖
用法: ./scripts/dependency.sh [list|tree|update|analyze|revert]
命令:
  list    - 列出所有依赖版本信息（默认）
  tree    - 显示依赖树结构
  update  - 更新依赖到最新版本
  analyze - 分析依赖冲突和使用情况
  revert  - 撤销依赖版本更改

# 发布管理脚本帮助
./scripts/release.sh -h
准备和执行项目发布
用法: ./scripts/release.sh [prepare|perform]
命令:
  prepare - 准备发布（测试、版本检查，默认）
  perform - 执行发布（提交、打标签、部署）
```

### 日常开发流程

#### 1. 构建项目

```bash
# 清理项目构建产物
./scripts/build.sh clean

# 编译项目代码
./scripts/build.sh compile

# 打包项目
./scripts/build.sh package

# 构建并安装到本地仓库（默认）
./scripts/build.sh install
```

#### 2. 运行测试

```bash
# 运行单元测试
./scripts/test.sh unit

# 运行所有测试并生成覆盖率报告
./scripts/test.sh all
```

#### 3. 代码质量检查

```bash
# 运行所有质量检查
./scripts/quality.sh all

# 仅运行代码格式检查
./scripts/quality.sh format
```

### 版本发布流程

#### 1. 发布准备

```bash
# 检查当前版本
./scripts/version.sh current

# 设置发布版本
./scripts/version.sh set 1.0.0

# 如果是快照版（*-SNAPSHOT），可直接设置为发布版本
./scripts/version.sh release

# 准备发布
./scripts/release.sh prepare
```

#### 2. 执行发布

```bash
# 执行发布（提交、打标签、部署）
./scripts/release.sh perform
```

#### 3. 更新开发版本

```bash
# 设置下一个开发版本
./scripts/version.sh next
```

### 依赖管理

```bash
# 查看依赖树
./scripts/dependency.sh tree

# 分析依赖冲突
./scripts/dependency.sh analyze

# 更新依赖版本
./scripts/dependency.sh update
```

## 故障排除

### 常见问题及解决方案

| 问题 | 可能原因 | 解决方案 |
|------|---------|----------|
| 脚本无法执行 | 权限不足 | 运行 `chmod +x scripts/*.sh scripts/lib/*.sh` |
| 构建失败 | Maven配置错误 | 1. 检查Maven配置<br>2. 确认`JAVA_HOME`设置<br>3. 查看日志：`./scripts/build.sh install` |
| 测试失败 | 环境配置问题 | 1. 检查测试环境配置<br>2. 查看测试日志：`./scripts/test.sh unit`<br>3. 单独运行失败的测试 |
| 依赖问题 | 依赖冲突或缺失 | 1. 运行依赖分析：`./scripts/dependency.sh analyze`<br>2. 检查本地Maven仓库<br>3. 清理缓存：`./scripts/build.sh clean` |

## 最佳实践

### 提交前检查清单

- [ ] 运行质量检查

  ```bash
  ./scripts/quality.sh all
  ```

- [ ] 执行完整测试

  ```bash
  ./scripts/test.sh all
  ```

### 版本发布检查清单

- [ ] 所有测试通过
- [ ] 代码质量检查通过
- [ ] 依赖分析无冲突
- [ ] 更新日志完善
- [ ] 文档更新

### 定期维护建议

- 每周：更新依赖版本
- 每次提交：运行质量检查
- 每月：全面依赖分析
- 持续：维护测试覆盖率

```markdown
GitHub Actions会自动执行以下检查:

- 每次提交时运行单元测试
- 每次提交时执行代码格式检查
- 每周运行完整测试套件
- 每周生成代码覆盖率报告
- 每月执行依赖分析和更新检查
- 定期检查代码质量指标
```

## 扩展开发

### 新增脚本模板

```bash
#!/bin/bash
# 脚本说明
# 版本号: 1.0.0

# 引入通用库
source "$(dirname "$0")/lib/common.sh"
init_script

# 命令定义
COMMAND=${1:-"default"}
VALID_COMMANDS=("command1" "command2")

# 主要逻辑
function main() {
    # 实现脚本逻辑
}

main "$@"
```

### 开发规范

1. **错误处理**
   - 使用`set -e`确保错误时退出
   - 使用通用库中的错误处理函数

2. **日志输出**
   - 使用通用库中的日志函数
   - 保持统一的输出格式

3. **参数处理**
   - 提供清晰的帮助信息
   - 验证输入参数
   - 支持`--help`选项

4. **文档要求**
   - 更新README.md
   - 添加脚本注释
   - 提供使用示例
