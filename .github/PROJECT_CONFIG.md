# 项目配置指南

## 概述

本文档详细说明项目的配置文件及其用途，帮助开发者理解项目结构和遵循开发规范。

## 版本信息

- 项目版本：1.0.0-SNAPSHOT
- 最后更新：2025-04-29
- 维护团队：Helian Labs

## 构建配置

### Maven Wrapper

- 文件位置：`.mvn/`、`mvnw`、`mvnw.cmd`
- 用途：提供统一的Maven构建环境，无需预先安装Maven
- 版本：Maven 3.9.9
- 配置文件：
  - `.mvn/wrapper/maven-wrapper.properties`：定义Maven版本
  - `.mvn/wrapper/settings.xml`：包含仓库和镜像配置

## 开源协议

- 协议类型：[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)
- 文件：`LICENSE`
- 说明：允许商业使用、修改和分发，需保留版权和许可声明

## 安全策略

- 文件：`SECURITY.md`
- 用途：提供安全漏洞报告指南和安全实践建议
- 内容：支持版本、漏洞报告流程、安全更新渠道

## 开发工具配置

### EditorConfig

- 文件：`.editorconfig`
- 用途：统一不同IDE和编辑器的代码风格
- 主要配置：
  - 编码：UTF-8
  - 缩进：4空格
  - 换行符：LF
  - 特定文件类型设置

### IDE支持

- 支持IDE：IntelliJ IDEA、Eclipse、VS Code
- 推荐插件：
  - Maven集成
  - Checkstyle
  - SonarLint
  - Git工具

### Git配置

#### 文件属性

- 文件：`.gitattributes`
- 用途：统一文件属性处理
- 配置：
  - 文本文件换行符转换
  - 二进制文件处理
  - 差异比较设置

#### 忽略文件

- 文件：`.gitignore`
- 用途：排除不需要版本控制的文件
- 主要忽略：
  - 编译输出：`target/`
  - IDE配置：`.idea/`、`.project`
  - 日志文件：`*.log`
  - 临时文件：`*.tmp`

## CI/CD配置

### GitHub Actions

- 文件：`.github/workflows/maven.yml`
- 用途：自动化构建、测试和代码质量检查
- 触发条件：
  - `main`分支的推送
  - 到`main`分支的PR
  - 每周定时运行
  - 手动触发
- 主要任务：
  - Java 17和21构建验证
  - 静态代码分析
  - 依赖漏洞扫描
  - 测试覆盖率报告
  - 构建产物上传

### Dependabot

- 文件：`.github/dependabot.yml`
- 用途：自动更新依赖
- 更新频率：
  - Maven依赖：每周
  - Actions依赖：每月
- 标签：`dependencies`、`security`、`ci`
- 提交前缀：`build(deps)`、`ci`

## 辅助脚本

- 目录：`scripts/`
- 用途：提供常用开发任务脚本
- 脚本列表：
  - `build.sh`：构建项目
  - `test.sh`：运行测试
  - `quality.sh`：代码质量检查
  - `version.sh`：版本管理
  - `dependency.sh`：依赖管理
  - `release.sh`：发布流程
  - `init.sh`：环境初始化
- 共享库：`scripts/lib/common.sh`

## 版本控制最佳实践

所有配置文件应通过Git版本控制，修改配置时建议：

1. 创建专门分支
2. 提交详细说明
3. 通过PR评审
4. 合并到主分支

## 配置更新流程

更新配置请遵循：

1. 在本文档添加更新说明
2. 更新相关配置文件
3. 提交变更并通知团队

## 注意事项

- 不随意修改基础配置
- 重要配置变更需团队共识
- 保持配置简洁可维护
