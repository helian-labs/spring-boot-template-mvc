# 贡献指南

感谢您考虑为Maven BOM模板项目做出贡献！以下是参与本项目的指导原则。

## 行为准则

所有贡献者请遵循我们的[行为准则](./CODE_OF_CONDUCT.md)，确保项目健康发展。

## 开发流程

我们采用简化的Gitflow分支模型：

- **main**: 稳定版本分支，始终保持可发布状态
- **feature/xxx**: 新功能开发分支，从main创建，完成后合并回main
- **fix/xxx**: bug修复分支，从main创建，修复后合并回main
- **release/vx.y.z**: 版本发布准备分支，从main创建，调整测试后合并回main并打标签

**开发步骤：**

1. Fork本仓库
2. 同步您的Fork仓库：

   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

3. 创建特性分支：`git checkout -b feature/amazing-feature`
4. 提交更改：`git commit -m 'Add some amazing feature'`
5. 推送分支：`git push origin feature/amazing-feature`
6. 向main分支发起Pull Request

## 代码评审流程

1. **发起评审**：向main分支发起Pull Request
2. **评审人**：项目维护者或核心贡献者负责评审
3. **评审标准**：
   - 符合项目目标和需求
   - 遵循代码风格规范
   - 包含必要单元测试且通过
   - 无明显bug或性能问题
   - 文档已更新
4. **反馈修改**：根据评审建议修改并再次推送
5. **合并**：通过评审后合并到main分支

## 代码风格

- 遵循Java代码规范
- 使用4空格缩进
- 为类和方法添加Javadoc注释
- 使用Checkstyle或SpotBugs检查代码质量

## 提交信息规范

提交信息格式：

  ```markdown
  <类型>: <描述>
  [可选的详细描述]
  [可选的关闭问题引用]
  ```

类型包括：

- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码风格调整
- refactor: 代码重构
- test: 测试相关
- chore: 构建过程或辅助工具变动

示例：

  ```markdown
  feat: 添加用户登录功能
  实现了基本的用户登录功能，包括表单验证和错误处理。
  关闭 #123
  ```

## 测试要求

- **编写测试**: 新功能和bug修复必须包含相应测试
- **运行测试**: 提交PR前确保测试通过：`./mvnw test`
- **测试覆盖率**: 确保不降低覆盖率，鼓励提高覆盖率
- **保持测试通过**: 确保不破坏现有测试

## 设置开发环境

1. **先决条件**: 安装兼容版本的JDK和Maven
2. **克隆仓库**: `git clone https://github.com/YOUR_USERNAME/maven-template-bom.git`
3. **构建项目**: 运行`./mvnw clean install`确保构建成功

## 报告问题

通过GitHub Issues报告bug或提出功能建议：

- **先搜索现有问题**避免重复
- **提供详细信息**：复现步骤、预期行为、实际行为，以及相关日志或截图

## 发布流程

项目遵循[语义化版本](https://semver.org/lang/zh-CN/)规范：

1. **准备发布**：
   - 创建`release/vx.y.z`分支
   - 更新pom.xml版本号
   - 更新CHANGELOG.md
   - 执行`./mvnw clean install`验证构建
2. **最终测试**：进行最后集成测试
3. **合并与打标**：
   - 合并回main分支
   - 打上版本标签：`git tag -a v1.0.0 -m "Release version 1.0.0"`
   - 推送：`git push origin main --tags`
4. **发布构建**：需要时触发CI/CD流水线或执行`./scripts/release.sh`发布到Maven仓库

## 许可证

贡献代码即表示您同意将其授权给本项目使用Apache License 2.0。
