# Maven 仓库配置指南

本文档提供了常用 Maven 仓库的配置示例，可以根据需要将这些配置添加到 `settings.xml` 文件中。

## 配置示例

### 完整的 settings.xml 模板

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
    
    <!-- 本地仓库路径配置 -->
    <localRepository>${user.home}/.m2/repository</localRepository>
    
    <!-- 仓库服务器认证信息 -->
    <servers>
        <server>
            <id>enterprise-releases</id>
            <username>your-username</username>
            <password>your-password</password>
        </server>
        <server>
            <id>enterprise-snapshots</id>
            <username>your-username</username>
            <password>your-password</password>
        </server>
    </servers>

    <!-- Maven 仓库镜像配置 -->
    <mirrors>
        <!-- 阿里云公共仓库 -->
        <mirror>
            <id>aliyun</id>
            <name>Aliyun Maven Central Mirror</name>
            <url>https://maven.aliyun.com/repository/public</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
        
        <!-- 阿里云 Spring 仓库 -->
        <mirror>
            <id>aliyun-spring</id>
            <name>Aliyun Spring Mirror</name>
            <url>https://maven.aliyun.com/repository/spring</url>
            <mirrorOf>spring</mirrorOf>
        </mirror>
    </mirrors>

    <!-- 项目配置 -->
    <profiles>
        <profile>
            <id>default</id>
            <repositories>
                <!-- Maven 中央仓库 -->
                <repository>
                    <id>central</id>
                    <name>Maven Central</name>
                    <url>https://repo1.maven.org/maven2/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </repository>

                <!-- Spring 仓库 -->
                <repository>
                    <id>spring-releases</id>
                    <name>Spring Releases</name>
                    <url>https://repo.spring.io/release</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </repository>

                <!-- Spring 里程碑版本仓库 -->
                <repository>
                    <id>spring-milestones</id>
                    <name>Spring Milestones</name>
                    <url>https://repo.spring.io/milestone</url>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </repository>

                <!-- Aliyun 仓库 -->
                <repository>
                    <id>aliyun</id>
                    <name>Aliyun Maven</name>
                    <url>https://maven.aliyun.com/repository/public</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </repository>

                <!-- 企业私有仓库示例 -->
                <repository>
                    <id>enterprise-releases</id>
                    <name>Enterprise Releases</name>
                    <url>https://nexus.your-company.com/repository/maven-releases/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </repository>
                
                <repository>
                    <id>enterprise-snapshots</id>
                    <name>Enterprise Snapshots</name>
                    <url>https://nexus.your-company.com/repository/maven-snapshots/</url>
                    <releases>
                        <enabled>false</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>

            <!-- 插件仓库配置 -->
            <pluginRepositories>
                <pluginRepository>
                    <id>central</id>
                    <name>Maven Central</name>
                    <url>https://repo1.maven.org/maven2/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </pluginRepository>
                
                <pluginRepository>
                    <id>spring-releases</id>
                    <name>Spring Releases</name>
                    <url>https://repo.spring.io/release</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </pluginRepository>

                <pluginRepository>
                    <id>aliyun</id>
                    <name>Aliyun Maven</name>
                    <url>https://maven.aliyun.com/repository/public</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>

    <!-- 激活配置 -->
    <activeProfiles>
        <activeProfile>default</activeProfile>
    </activeProfiles>
</settings>
```

## 使用说明

1. 根据需要复制相关配置到您的 `settings.xml` 文件中
2. 替换企业仓库的 URL、用户名和密码
3. 如果使用阿里云镜像，建议将阿里云镜像配置放在 mirrors 部分的最前面
4. 可以根据需要启用或禁用特定的仓库

## 常用仓库地址

1. Maven 中央仓库：<https://repo1.maven.org/maven2/>
2. 阿里云公共仓库：<https://maven.aliyun.com/repository/public>
3. 阿里云 Spring 仓库：<https://maven.aliyun.com/repository/spring>
4. Spring 官方仓库：<https://repo.spring.io/release>
5. Spring 里程碑版本：<https://repo.spring.io/milestone>

## 注意事项

1. 企业仓库的认证信息应妥善保管，不要提交到代码仓库
2. 建议使用加密的密码存储方式
3. 如果使用阿里云镜像，可以提升国内访问速度
4. 根据项目需求选择合适的仓库配置

## 最佳实践

在项目中使用阿里云镜像仓库，可以提升国内访问速度：

```xml
    <repositories>
        <repository>
            <id>aliyun</id>
            <name>Aliyun Maven</name>
            <url>https://maven.aliyun.com/repository/public</url>
            <releases>
                <enabled>true</enabled>
            </releases>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </repository>
    </repositories>
    <pluginRepositories>
        <pluginRepository>
            <id>aliyun</id>
            <name>Aliyun Maven</name>
            <url>https://maven.aliyun.com/repository/public</url>
            <releases>
                <enabled>true</enabled>
            </releases>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </pluginRepository>
    </pluginRepositories>
```
