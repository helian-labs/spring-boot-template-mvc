# Dockerfile 最佳实践指南

本文档旨在说明用于容器化 Spring Boot 应用的 `Dockerfile` 中采用的最佳实践。

## 1. 多阶段构建 (Multi-stage Builds)

```dockerfile
# Build Stage
FROM maven:3.9-eclipse-temurin-17 AS builder
# ... build steps ...

# Run Stage
FROM eclipse-temurin:17-jre-jammy
# ... copy artifact and run steps ...
```

* **实践**: 使用两个或多个阶段。第一阶段 (`builder`) 包含构建工具链（如 JDK, Maven）用于编译和打包应用。第二阶段使用一个最小化的基础镜像（如仅包含 JRE）来运行应用。
* **好处**:
  * **减小镜像体积**: 最终镜像不包含构建时的依赖和工具链。
  * **提高安全性**: 减少了最终镜像中的潜在攻击面（移除了不必要的工具和源代码）。

## 2. 依赖缓存

```dockerfile
# Build Stage
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B # 下载依赖
COPY src ./src                  # 复制源代码
RUN mvn package -B -Dmaven.test.skip=true # 打包
```

* **实践**: 先复制项目描述文件 (`pom.xml`) 并下载依赖，然后再复制源代码。
* **好处**: 利用 Docker 的层缓存机制。只要 `pom.xml` 文件没有变化，下载依赖的 `RUN` 指令层就会被缓存，后续构建时无需重新下载依赖，显著加快构建速度。

## 3. 使用 JRE 基础镜像

```dockerfile
# Run Stage
FROM eclipse-temurin:17-jre-jammy
```

* **实践**: 在最终的运行阶段，选择仅包含 Java 运行时环境 (JRE) 的基础镜像，而不是包含完整开发工具包 (JDK) 的镜像。
* **好处**: JRE 镜像比 JDK 镜像小得多，进一步优化最终镜像的大小。

## 4. 以非 Root 用户运行

```dockerfile
# Run Stage
ARG APP_USER=appuser
ARG APP_GROUP=appgroup
ARG APP_UID=1001
ARG APP_GID=1001

RUN groupadd -g ${APP_GID} ${APP_GROUP} && \
    useradd -u ${APP_UID} -g ${APP_GROUP} -m -s /bin/sh ${APP_USER}
# ... copy app.jar ...
RUN chown ${APP_USER}:${APP_GROUP} ./app.jar
USER ${APP_USER}
```

* **实践**: 创建一个专用的、非 `root` 权限的用户和用户组，并在容器内使用该用户运行应用程序。
* **好处**: 遵循最小权限原则，即使应用程序本身存在漏洞被利用，攻击者获取的权限也受限，提高了容器的安全性。

## 5. 明确工作目录 (`WORKDIR`)

```dockerfile
WORKDIR /app
```

* **实践**: 使用 `WORKDIR` 指令设置容器内的工作目录。
* **好处**: 使后续的 `COPY`, `RUN`, `CMD`, `ENTRYPOINT` 指令可以使用相对路径，使 Dockerfile 更清晰、易于维护。

## 6. 使用 `ENTRYPOINT` 的 `exec` 格式

```dockerfile
ENTRYPOINT ["java", "-Xmx1024m", "-jar", "./app.jar"]
```

* **实践**: 使用 JSON 数组格式（`exec` 格式）定义 `ENTRYPOINT` 或 `CMD`。
* **好处**: 确保 Java 进程作为容器的主进程 (PID 1) 运行。这使得 Java 进程能够直接接收和处理来自 Docker 守护进程的信号（如 `SIGTERM`），这对于实现优雅停机至关重要。如果使用 shell 格式 (`ENTRYPOINT java -jar ...`)，应用会运行在 shell 子进程中，可能无法正确处理信号。

## 7. 合理配置 JVM 参数

```dockerfile
ENTRYPOINT ["java", \
            "-Xms512m", \
            "-Xmx1024m", \
            "-Djava.security.egd=file:/dev/./urandom", \
            "-jar", \
            "./app.jar"]
```

* **实践**: 在 `ENTRYPOINT` 中为 Java 进程设置必要的 JVM 参数，特别是内存相关的参数 (`-Xms`, `-Xmx`)。
* **好处**: 控制应用的资源使用，防止内存溢出 (OOM)，优化性能。`-Djava.security.egd` 参数有助于解决某些环境下 JVM 启动慢的问题。**注意**: 这些值应根据实际部署环境和应用负载进行监控和调优。

## 8. 暴露端口 (`EXPOSE`)

```dockerfile
EXPOSE 18080
```

* **实践**: 使用 `EXPOSE` 指令声明容器打算监听的网络端口。
* **好处**:
  * 作为文档，告知用户容器内应用的服务端口。
  * 配合 `docker run -P` (大写 P) 可以自动将此端口映射到宿主机的随机端口。

## 9. 健康检查 (`HEALTHCHECK` - 可选)

```dockerfile
# HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
#   CMD curl -f http://localhost:18080/actuator/health || exit 1
```

* **实践**: 如果应用提供了健康检查端点（如 Spring Boot Actuator 的 `/actuator/health`），可以使用 `HEALTHCHECK` 指令让 Docker 监控容器内应用的健康状态。
* **好处**: 容器编排系统（如 Docker Swarm, Kubernetes）可以利用健康检查结果来判断容器是否正常工作，并在容器不健康时进行自动重启或替换。

## 10. 镜像标签 (`LABEL` - 可选)

```dockerfile
LABEL org.opencontainers.image.source="https://github.com/helian-labs/spring-boot-template-mvc"
LABEL org.opencontainers.image.description="Demo project for Spring Boot MVC Template"
LABEL org.opencontainers.image.licenses="Apache-2.0"
```

* **实践**: 使用 `LABEL` 指令为镜像添加元数据，推荐遵循 OCI (Open Container Initiative) 规范。
* **好处**: 提供关于镜像来源、描述、许可证等信息，便于管理和追踪。

## 11. 使用 `.dockerignore` 文件

* **实践**: 在项目根目录下创建一个 `.dockerignore` 文件，列出不需要包含在 Docker 构建上下文中的文件和目录。

    ```.dockerignore
    .git
    .gitignore
    .idea
    *.iml
    target/
    logs/
    *.log
    .mvn/
    mvnw
    mvnw.cmd
    Dockerfile
    .dockerignore
    RUN.md
    DOCKERFILE_BEST_PRACTICES.md
    ```

* **好处**:
  * **减小构建上下文体积**: 减少发送给 Docker 守护进程的数据量，加快构建初始化速度。
  * **避免缓存失效**: 防止不必要的文件（如日志、构建输出）变化导致 Docker 层缓存失效。
  * **安全性**: 防止将敏感信息（如 `.git` 目录、本地配置文件）意外复制到镜像中。

遵循这些最佳实践有助于构建出更小、更快、更安全、更易于管理的 Docker 镜像。
