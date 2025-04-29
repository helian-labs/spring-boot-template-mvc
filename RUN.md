# run.sh 脚本使用指南与最佳实践

该脚本 (`run.sh`) 提供了一个方便的方式来管理你的 Spring Boot 应用（启动、停止、重启、查看状态），并集成了优雅停机的逻辑。

## 1. 基本用法

* **授权:** 首次使用前，请确保脚本具有执行权限：

    ```bash
    chmod +x run.sh
    ```

* **构建:** 确保你的项目已经通过 Maven 打包（生成 JAR 文件到 `target` 目录）：

    ```bash
    mvn clean package -DskipTests
    ```

* **命令:**
  * 启动应用: `./run.sh start`
  * 停止应用 (优雅停机): `./run.sh stop`
  * 重启应用: `./run.sh restart`
  * 查看状态: `./run.sh status`

## 2. 脚本配置项说明

脚本顶部包含一些可配置的变量：

* `APP_NAME`: 应用名称，应与 `pom.xml` 和 `application.properties` 中定义的一致。
* `JAR_PATH`: 指向构建出的 Spring Boot 可执行 JAR 文件的路径。脚本使用了 `*` 通配符，通常能自动找到 `target` 目录下的 JAR。
* `PID_FILE`: 存储运行中应用进程 ID 的文件，用于脚本管理进程。
* `JVM_OPTS`: **核心配置**，用于设置 Java 虚拟机参数。详见下文 JVM 配置最佳实践。
* `SPRING_OPTS`: 传递给 Spring Boot 应用的参数，例如 `--spring.profiles.active=prod` 用于指定生产环境配置。
* `SHUTDOWN_WAIT_SECONDS`: 优雅停机时，脚本等待应用进程退出的最长时间（秒）。**建议此值略大于** `application.properties` 中 `spring.lifecycle.timeout-per-shutdown-phase` 的值，给应用足够的时间完成清理。

## 3. 通用脚本最佳实践

* **日志记录:**
  * 当前脚本将 `nohup` 的输出重定向到了 `/dev/null`。在开发或生产环境中，强烈建议将其重定向到指定的日志文件，以便于问题排查。例如，在 `start` 函数中修改 `nohup` 行：

        ```bash
        # 在 start 函数中修改 nohup 行
        nohup java $JVM_OPTS -jar "$actual_jar" $SPRING_OPTS > ./logs/app.log 2>&1 &
        ```

  * 确保 `./logs` 目录存在且具有写权限。
  * 考虑使用日志轮转工具（如 `logrotate`）来管理日志文件大小。
* **配置外部化:** 对于经常变更的配置（如 `JVM_OPTS`, `SPRING_OPTS`），可以考虑将其移到脚本外部的配置文件 (`.conf` 或 `.env`) 中，或者使用环境变量传入，增加灵活性。
* **错误处理:** 脚本包含基本的错误检查。对于关键生产环境，可以根据需要添加更细致的检查（如检查端口是否被占用、依赖服务是否可用等）。
* **环境一致性:** 确保运行脚本的环境（Java 版本、系统依赖等）与开发和测试环境一致。
* **生产环境管理:** 在生产环境中，推荐使用更专业的进程管理工具（如 `systemd`, `supervisor`）或容器化方案（Docker, Kubernetes）来管理应用的生命周期，它们提供了更强大的监控、自愈和管理能力。此脚本可作为这些工具的基础或开发环境下的便捷工具。

## 4. JVM 配置 (`JVM_OPTS`) 最佳实践

`JVM_OPTS` 是影响应用性能和稳定性的关键配置。以下是一些最佳实践：

* **堆内存设置 (`-Xms`, `-Xmx`)**:
  * `-Xms<size>`: 设置 JVM 初始堆大小。
  * `-Xmx<size>`: 设置 JVM 最大堆大小。
  * **最佳实践**: 在**生产环境**中，通常建议将 `-Xms` 和 `-Xmx` 设置为**相同的值**。例如：`-Xms1024m -Xmx1024m`。
    * **原因**: 避免 JVM 在运行时动态调整堆大小带来的性能开销和潜在的 Full GC 暂停；启动时即分配所需内存，性能更稳定。
  * **大小确定**:
    * 没有万能值。需要根据应用的实际内存消耗来确定。
    * **监控是关键**: 使用 Spring Boot Actuator 的 `/actuator/metrics/jvm.memory.used`、JMX 工具 (JConsole, VisualVM) 或 APM 系统监控应用在高负载下的内存使用情况。
    * 初始可以根据经验设置（如脚本中的 `-Xms512m -Xmx1024m` 适用于开发），然后根据监控数据调整。
    * **注意**: 不要超过服务器物理内存的限制，并为操作系统和其他进程留出足够内存。如果使用容器，需考虑容器的内存限制。

* **垃圾收集器 (GC)**:
  * 现代 JVM (Java 17+) 默认通常使用 G1 GC (`-XX:+UseG1GC`)，它在多数场景下提供了较好的吞吐量和暂停时间的平衡。
  * **最佳实践**:
    * 通常从默认的 G1 GC 开始。
    * 根据应用特性（如高并发、低延迟要求）和性能测试结果，可以考虑其他 GC，如 Parallel GC (`-XX:+UseParallelGC`，吞吐量优先) 或 ZGC (`-XX:+UseZGC`) / Shenandoah GC (`-XX:+UseShenandoahGC`) (低延迟优先，需要较新 JDK 版本支持)。
    * **启用 GC 日志**: `-Xlog:gc*:file=./logs/gc.log:time,level,tags:filecount=10,filesize=50m`。这对于分析 GC 行为和调优至关重要。路径、文件数量和大小可按需调整。确保 `./logs` 目录存在。

* **Metaspace**:
  * 用于存储类元数据。
  * `-XX:MetaspaceSize=<size>`: 初始 Metaspace 大小。
  * `-XX:MaxMetaspaceSize=<size>`: 最大 Metaspace 大小。
  * **最佳实践**: 通常不需要显式设置，JVM 会自动调整。但如果遇到 `OutOfMemoryError: Metaspace`，则需要根据监控增加 `-XX:MaxMetaspaceSize`。

* **诊断与排错**:
  * `-XX:+HeapDumpOnOutOfMemoryError`: 在发生 OOM 时自动生成堆转储快照 (Heap Dump)，是排查内存泄漏的关键。
  * `-XX:HeapDumpPath=./logs/java_pid<pid>.hprof`: 指定 Heap Dump 文件的生成路径。确保 `./logs` 目录存在且有写权限。`<pid>` 会被替换为进程 ID。
  * `-XX:ErrorFile=./logs/hs_err_pid%p.log`: 指定 JVM 崩溃日志 (hs_err) 的路径。确保 `./logs` 目录存在。

* **其他常用选项**:
  * `-Djava.net.preferIPv4Stack=true`: 在某些网络环境下可能需要，强制使用 IPv4。
  * `-Duser.timezone=Asia/Shanghai`: 显式设置 JVM 时区，确保时间处理的一致性（虽然 Spring Boot 也有 `spring.jackson.time-zone`，但在 JVM 层面设置更彻底）。
  * `-XX:+UseStringDeduplication` (配合 G1 GC): 如果应用中存在大量重复字符串，可以开启此选项尝试减少内存占用。

* **JMX 监控 (可选，注意安全)**:
  * 如果需要远程监控 JVM（例如使用 JConsole），可以添加 JMX 参数：

    ```bash
    -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.port=9090 \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Djava.rmi.server.hostname=<your_server_ip>
    ```

  * **安全警告**: 上述配置禁用了认证和 SSL，非常不安全，仅适用于受信任的内部网络或开发环境。生产环境必须启用认证和 SSL，或通过安全的隧道访问。

## 总结

`run.sh` 脚本为 Spring Boot 应用提供了一个实用的管理框架。理解其配置项，特别是 `JVM_OPTS`，并结合监控数据进行调优，是确保应用稳定高效运行的关键。始终根据你的具体应用负载和运行环境来调整这些参数。
