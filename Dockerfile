# --- Build Stage ---
# 使用包含 Maven 和 JDK 17 的基础镜像来构建应用
# 选择 eclipse-temurin 作为 OpenJDK 发行版，它有良好的社区支持
FROM maven:3.9-eclipse-temurin-17 AS builder

# 设置工作目录
WORKDIR /app

# 1. 复制 pom.xml 并下载依赖项
# 利用 Docker 层缓存：只有当 pom.xml 变化时才重新下载依赖
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 2. 复制源代码
COPY src ./src

# 3. 打包应用，跳过测试
# 使用 -Dmaven.test.skip=true 而不是 -DskipTests 来确保 surefire 插件目标也被跳过
RUN mvn package -B -Dmaven.test.skip=true

# --- Run Stage ---
# 使用仅包含 JRE 的更小的基础镜像来运行应用
# jammy 是 Ubuntu 22.04 LTS 的代号，提供较新的基础环境
FROM eclipse-temurin:17-jre-jammy

# 设置工作目录
WORKDIR /app

# 定义参数，方便在构建时或运行时覆盖
ARG APP_JAR_NAME=demo-*.jar
ARG APP_USER=appuser
ARG APP_GROUP=appgroup
ARG APP_UID=1001
ARG APP_GID=1001

# 创建非 root 用户和组，提高安全性
RUN groupadd -g ${APP_GID} ${APP_GROUP} && \
    useradd -u ${APP_UID} -g ${APP_GROUP} -m -s /bin/sh ${APP_USER}

# 从构建阶段复制构建好的 JAR 文件
# 注意：路径需要匹配 Maven 构建输出的 JAR 文件名模式
COPY --from=builder /app/target/${APP_JAR_NAME} ./app.jar

# 更改 JAR 文件的所有者为非 root 用户
RUN chown ${APP_USER}:${APP_GROUP} ./app.jar

# 切换到非 root 用户
USER ${APP_USER}

# 暴露应用端口 (与 application.properties 中的 server.port 一致)
EXPOSE 18080

# 设置容器启动时执行的命令
# 使用 exec 格式，使 Java 进程成为 PID 1，能正确接收信号（如 SIGTERM 用于优雅停机）
# 添加 JVM 内存参数示例，应根据实际情况调整
# 添加 -Djava.security.egd=file:/dev/./urandom 以解决某些环境下的熵源问题，提高启动速度
ENTRYPOINT ["java", \
            "-Xms512m", \
            "-Xmx1024m", \
            "-Djava.security.egd=file:/dev/./urandom", \
            "-jar", \
            "./app.jar"]

# (可选) 添加健康检查，利用 Spring Boot Actuator 的 health 端点
# 需要确保 actuator 依赖已添加，并且 health 端点已暴露
# HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
#   CMD curl -f http://localhost:18080/actuator/health || exit 1

# 添加标准 OCI 镜像标签 (可选)
LABEL org.opencontainers.image.source="https://github.com/helian-labs/spring-boot-template-mvc"
LABEL org.opencontainers.image.description="Demo project for Spring Boot MVC Template"
LABEL org.opencontainers.image.licenses="Apache-2.0"