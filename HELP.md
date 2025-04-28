# 项目帮助文档

此文档包含项目中使用的主要插件的链接和简要说明。本项目采用了最新的Maven构建实践，集成了代码质量、安全检查、测试覆盖等多个维度的工具链。

## 插件列表

### Maven Compiler Plugin

用于编译Java代码，支持Java 17及更高版本。

- 文档链接: [Maven Compiler Plugin](https://maven.apache.org/plugins/maven-compiler-plugin/)
- 版本: ${maven-compiler-plugin.version}
- 常用命令:

  ```bash
  mvn compiler:compile  # 编译主代码
  mvn compiler:testCompile  # 编译测试代码
  ```

- 配置特点:
  - 启用参数名保留
  - 开启所有警告(-Xlint:all)
  - 将警告视为错误(-Werror)
  - UTF-8编码

### Maven Surefire Plugin

用于运行单元测试，支持JUnit 5。

- 文档链接: [Maven Surefire Plugin](https://maven.apache.org/surefire/maven-surefire-plugin/)
- 版本: ${maven-surefire-plugin.version}
- 常用命令:

  ```bash
  mvn test  # 运行所有测试
  mvn test -Dtest=TestClass  # 运行特定测试类
  ```

### Maven Enforcer Plugin

用于强制执行项目的构建规则和环境要求。

- 文档链接: [Maven Enforcer Plugin](https://maven.apache.org/enforcer/maven-enforcer-plugin/)
- 版本: ${maven-enforcer-plugin.version}
- 强制规则:
  - Maven最低版本要求: 3.6.3
  - Java版本要求: 17+
  - 依赖收敛性检查

### Jacoco Maven Plugin

用于生成代码覆盖率报告，并强制执行覆盖率标准。

- 文档链接: [Jacoco Maven Plugin](https://www.jacoco.org/jacoco/trunk/doc/maven.html)
- 版本: ${jacoco-maven-plugin.version}
- 覆盖率要求:
  - 行覆盖率最低要求: 70%
- 常用命令:

  ```bash
  mvn verify  # 运行测试并检查覆盖率
  ```

### Maven Source Plugin

用于生成项目的源码包，Maven中央仓库发布必需。

- 文档链接: [Maven Source Plugin](https://maven.apache.org/plugins/maven-source-plugin/)
- 版本: ${maven-source-plugin.version}
- 配置特点:
  - 自动在verify阶段生成源码jar
  - 使用jar-no-fork目标避免重复编译

### Maven Javadoc Plugin

用于生成项目的API文档，Maven中央仓库发布必需。

- 文档链接: [Maven Javadoc Plugin](https://maven.apache.org/plugins/maven-javadoc-plugin/)
- 版本: ${maven-javadoc-plugin.version}
- 常用命令:

  ```bash
  mvn javadoc:javadoc  # 生成HTML格式的API文档
  mvn javadoc:jar      # 生成Javadoc jar包
  ```

### Spotbugs Maven Plugin

用于静态代码分析，查找潜在的bug。

- 文档链接: [Spotbugs Maven Plugin](https://spotbugs.github.io/spotbugs-maven-plugin/)
- 版本: ${spotbugs-maven-plugin.version}
- 执行时机: verify阶段
- 常用命令:

  ```bash
  mvn spotbugs:check  # 执行代码分析
  ```

### Maven PMD Plugin

用于代码质量检查，发现潜在的代码问题。

- 文档链接: [Maven PMD Plugin](https://maven.apache.org/plugins/maven-pmd-plugin/)
- 版本: ${maven-pmd-plugin.version}
- 执行时机: verify阶段
- 常用命令:

  ```bash
  mvn pmd:check       # 检查代码
  mvn pmd:cpd-check   # 检查重复代码
  ```

### Maven Checkstyle Plugin

用于确保代码风格符合Google Java Style规范。

- 文档链接: [Maven Checkstyle Plugin](https://maven.apache.org/plugins/maven-checkstyle-plugin/)
- 版本: ${maven-checkstyle-plugin.version}
- 配置特点:
  - 使用Google代码风格检查规则
  - 在verify阶段执行检查

### Spotless Maven Plugin

用于代码格式化和风格统一。

- 文档链接: [Spotless Maven Plugin](https://github.com/diffplug/spotless/tree/main/plugin-maven)
- 版本: ${spotless-maven-plugin.version}
- 功能特点:
  - 自动整理导入语句
  - 移除未使用的导入
  - 应用Google Java格式化
  - 确保行尾空白和文件结尾换行符
- 常用命令:

  ```bash
  mvn spotless:check  # 检查代码格式
  mvn spotless:apply  # 自动格式化代码
  ```

### OWASP Dependency-Check Maven Plugin

用于检查项目依赖中的已知安全漏洞。作为独立的安全审计工具使用，需要手动触发检查。

- 文档链接: [Dependency-Check Maven Plugin](https://jeremylong.github.io/DependencyCheck/dependency-check-maven/)
- 版本: ${dependency-check-maven.version}
- 配置特点:
  - CVSS评分阈值：7.0（高危及以上漏洞将导致构建失败）
  - 同时生成HTML和JSON格式报告
- 常用命令:

  ```bash
  mvn dependency-check:check  # 执行依赖安全检查
  mvn dependency-check:aggregate  # 多模块项目的聚合检查
  mvn dependency-check:purge  # 清除本地CVE数据库缓存
  ```

- 使用建议:
  - 定期执行检查以发现潜在安全隐患
  - 在CI/CD流水线中配置为独立的安全检查步骤
  - 建议在以下场景执行检查：
    - 添加新依赖后
    - 发布前的安全审计
    - 定期安全扫描（如每周一次）

### Versions Maven Plugin

用于管理项目依赖版本。

- 文档链接: [Versions Maven Plugin](https://www.mojohaus.org/versions-maven-plugin/)
- 版本: ${versions-maven-plugin.version}
- 常用命令:

  ```bash
  mvn versions:display-dependency-updates  # 显示可用的依赖更新
  mvn versions:use-latest-versions        # 更新依赖到最新版本
  ```

### Maven Resources Plugin

用于处理项目资源文件。

- 文档链接: [Maven Resources Plugin](https://maven.apache.org/plugins/maven-resources-plugin/)
- 版本: ${maven-resources-plugin.version}
- 配置特点:
  - 使用@作为变量分隔符
  - 禁用默认分隔符

### Flatten Maven Plugin

用于简化多模块项目中的版本管理。

- 文档链接: [Flatten Maven Plugin](https://www.mojohaus.org/flatten-maven-plugin/)
- 版本: ${flatten-maven-plugin.version}
- 配置特点:
  - 使用resolveCiFriendliesOnly模式
  - 自动在process-resources阶段执行
  - 默认激活

## 项目构建配置

### 默认激活的插件

- Maven Compiler Plugin
- Maven Enforcer Plugin
- Jacoco Maven Plugin

### 可选Profile

#### quality

激活额外的代码质量和安全检查插件：

- Spotless Plugin
- Spotbugs Plugin
- PMD Plugin
- Checkstyle Plugin
- Dependency-Check Plugin

使用场景：

- 提交PR前的完整检查
- CI/CD流水线中的质量关卡
- 发布前的安全审计
- 定期代码质量检查

使用方式：

```bash
mvn verify -Pquality  # 执行构建并进行全面的代码质量检查
```

#### security

*该环境由Github Actions自动执行。*

激活额外的依赖安全检查插件：

- Dependency Check Plugin

使用场景：

- 在发布前进行依赖安全审计
- CI/CD 流水线中的安全扫描步骤
- 定期（如每周）的依赖安全检查
- 添加新依赖后的安全验证

使用方式：

```bash
mvn verify -Psecurity  # 执行构建并进行依赖安全检查
```

#### flatten

用于处理版本变量（默认激活）：

- Flatten Maven Plugin

## 最佳实践

1. 在提交代码前运行完整的质量检查：

   ```bash
   mvn clean verify -Pquality
   ```

2. 保持代码格式统一：

   ```bash
   mvn spotless:apply
   ```

3. 定期检查依赖更新和安全漏洞：

   ```bash
   mvn versions:display-dependency-updates
   mvn dependency-check:check
   ```

4. 确保测试覆盖率达标：

   ```bash
   mvn verify
   ```

## 安全检查最佳实践

1. 定期执行依赖安全检查：

   ```bash
   # 完整的依赖检查
   mvn dependency-check:aggregate
   
   # 清除并更新CVE数据库后检查
   mvn dependency-check:purge dependency-check:check
   ```

2. 在CI/CD中设置独立的安全检查任务：

   ```bash
   # 示例：Jenkins pipeline
   stage('Security Check') {
     steps {
       sh 'mvn dependency-check:aggregate'
     }
   }
   ```

本文档会随项目演进持续更新，如有问题请参考各插件的官方文档或联系项目维护者。
