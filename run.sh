#!/bin/bash

# --- 配置 ---
# 应用名称 (与 application.properties 中的 spring.application.name 一致)
APP_NAME="demo"
# JAR 文件路径 (根据实际构建路径调整, * 通配符匹配版本号)
JAR_PATH="./target/${APP_NAME}-*.jar"
# PID 文件路径
PID_FILE="./${APP_NAME}.pid"
# JVM 启动参数 (根据需要调整)
JVM_OPTS="-Xms512m -Xmx1024m"
# Spring Boot 启动参数 (例如指定配置文件)
# SPRING_OPTS="--spring.profiles.active=prod"
SPRING_OPTS="--spring.profiles.active=dev" # 默认使用 dev 环境，可修改为 prod 等
# 优雅停机等待时间 (秒)，应略大于 spring.lifecycle.timeout-per-shutdown-phase
SHUTDOWN_WAIT_SECONDS=40

# --- 函数 ---

# 查找应用的 PID
find_pid() {
    # 优先从 PID 文件读取
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        # 检查该 PID 是否真的在运行对应的 Java 进程
        ps -p "$pid" -o comm= | grep -q 'java' && echo "$pid" && return 0
        # 如果 PID 文件中的进程不存在了，则清除无效的 PID 文件
        echo "警告: PID 文件 $PID_FILE 存在，但进程 $pid 未运行或不是 Java 进程。清除 PID 文件。" >&2
        rm -f "$PID_FILE"
    fi

    # 如果 PID 文件无效或不存在，尝试通过 pgrep 查找 (更健壮的方式)
    # 注意：需要确保 JAR_PATH 中的通配符能被正确解析或使用更精确的匹配
    # 这里假设 target 目录下只有一个符合条件的 JAR
    local actual_jar=$(ls -1 ${JAR_PATH} | head -n 1)
    if [ -n "$actual_jar" ]; then
       pgrep -f "java.*${actual_jar}"
    else
       # 如果找不到 JAR 文件，也无法通过 pgrep 查找
       return 1
    fi
}

# 启动应用
start() {
    pid=$(find_pid)
    if [ -n "$pid" ]; then
        echo "$APP_NAME 已经在运行 (PID: $pid)。"
        return 1
    fi

    # 检查 JAR 文件是否存在
    local actual_jar=$(ls -1 ${JAR_PATH} | head -n 1)
    if [ ! -f "$actual_jar" ]; then
        echo "错误: JAR 文件未找到: $JAR_PATH (请先执行 mvn package)"
        return 1
    fi

    echo "正在启动 $APP_NAME..."
    # 启动应用，并将输出重定向到 /dev/null (或指定日志文件)
    nohup java $JVM_OPTS -jar "$actual_jar" $SPRING_OPTS > /dev/null 2>&1 &
    # 获取新进程的 PID
    new_pid=$!

    # 检查进程是否成功启动
    sleep 2 # 等待一小段时间让进程启动
    if ps -p $new_pid > /dev/null; then
        echo $new_pid > "$PID_FILE"
        echo "$APP_NAME 启动成功 (PID: $new_pid)。"
    else
        echo "错误: $APP_NAME 启动失败。"
        rm -f "$PID_FILE" # 清理可能创建的无效 PID 文件
        return 1
    fi
}

# 停止应用
stop() {
    pid=$(find_pid)
    if [ -z "$pid" ]; then
        echo "$APP_NAME 未在运行。"
        # 确保 PID 文件不存在
        rm -f "$PID_FILE"
        return 1
    fi

    echo "正在停止 $APP_NAME (PID: $pid)..."
    # 发送 SIGTERM 信号，触发优雅停机
    kill -TERM "$pid"

    # 等待进程退出
    echo "等待最多 $SHUTDOWN_WAIT_SECONDS 秒让应用优雅停机..."
    count=0
    while [ $count -lt $SHUTDOWN_WAIT_SECONDS ]; do
        if ! ps -p "$pid" > /dev/null; then
            echo "$APP_NAME (PID: $pid) 已成功停止。"
            rm -f "$PID_FILE"
            return 0
        fi
        sleep 1
        ((count++))
    done

    # 如果超时后仍在运行，强制终止
    echo "警告: $APP_NAME (PID: $pid) 未能在 $SHUTDOWN_WAIT_SECONDS 秒内优雅停机。尝试强制终止..."
    kill -KILL "$pid"
    sleep 2

    if ! ps -p "$pid" > /dev/null; then
        echo "$APP_NAME (PID: $pid) 已被强制停止。"
        rm -f "$PID_FILE"
        return 0
    else
        echo "错误: 无法停止 $APP_NAME (PID: $pid)。请手动检查。"
        return 1
    fi
}

# 查看状态
status() {
    pid=$(find_pid)
    if [ -n "$pid" ]; then
        echo "$APP_NAME 正在运行 (PID: $pid)。"
    else
        echo "$APP_NAME 未在运行。"
        # 确保 PID 文件不存在
        rm -f "$PID_FILE"
    fi
}

# --- 主逻辑 ---
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        status
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac

exit $?