#!/bin/bash

# 设置 Spring Boot 应用的 JAR 包名称
APP_NAME="ms-nginx-0.0.1-SNAPSHOT.jar"

# 设置应用运行目录
APP_DIR="/opt/ms-nginx"

# 设置日志输出文件
LOG_FILE="$APP_DIR/app.log"

# 设置 Java 启动参数
JAVA_OPTS="-Xms512m -Xmx1024m"

# 获取端口参数，默认端口为 8080
COMMAND=$1
PORT=${2:-8080}

# 检查应用是否已在运行
is_running() {
  pid=$(pgrep -f "$APP_NAME.*--server.port=$PORT")
  if [ -z "$pid" ]; then
    return 1
  else
    return 0
  fi
}

# 启动应用
start() {
  if is_running; then
    echo "应用已在运行，PID: $pid"
  else
    echo "正在启动应用，端口: $PORT..."
    echo "启动命令: java $JAVA_OPTS -jar "$APP_DIR/$APP_NAME" --server.port=$PORT"
    nohup java $JAVA_OPTS -jar "$APP_DIR/$APP_NAME" --server.port=$PORT > "$LOG_FILE" 2>&1 &
    sleep 2
    if is_running; then
      echo "应用启动成功，PID: $(pgrep -f "$APP_NAME.*--server.port=$PORT")"
    else
      echo "应用启动失败，请检查日志文件 $LOG_FILE"
    fi
  fi
}

# 停止应用
stop() {
  if is_running; then
    echo "正在停止应用，端口: $PORT，PID: $pid"
    kill -9 $pid
    sleep 2
    if is_running; then
      echo "应用停止失败，PID: $pid 仍在运行"
    else
      echo "应用已停止"
    fi
  else
    echo "应用未运行"
  fi
}

# 查看日志
logs() {
  echo "查看日志文件：$LOG_FILE"
  tail -f "$LOG_FILE"
}

# 显示脚本使用帮助
usage() {
  echo "用法: $0 {start|stop|restart|status|logs} [port]"
  echo "  示例:"
  echo "    启动应用: $0 start 8081"
  echo "    停止应用: $0 stop 8081"
  exit 1
}

# 主逻辑
case "$COMMAND" in
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
    if is_running; then
      echo "应用正在运行，端口: $PORT，PID: $pid"
    else
      echo "应用未运行"
    fi
    ;;
  logs)
    logs
    ;;
  *)
    usage
    ;;
esac
