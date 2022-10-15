#! /bin/bash
set -e

############### 守护进程 ###############

# 引入配置
source "$WORK_PATH/script/include/conf.sh"

# 设置脚本执行的日志记录文件
daemonLogFile=$WORK_PATH/log/daemon.log # daemon 脚本的执行输出日志

echoContent green "################### Daemon 开始 ###################" "$daemonLogFile"

while true; do
  # 检查进程数
  num="$(pgrep -f "$execCmd" | wc -l)"
  num=$(eval echo "$num")
  echoContent default "当前进程数: $num" "$daemonLogFile"
  # 小于 1，进行启动
  if [[ "$num" -lt 1 ]]; then
      echoContent default "进程数小于 1 ,准备启动..." "$daemonLogFile"
      "$WORK_PATH"/script/include/start.sh "$1"  > /dev/null 2>&1
      echoContent default "启动成功！" "$daemonLogFile"
  fi
  sleep 10
done

echoContent green "################### Daemon 结束 ###################" "$daemonLogFile"

exit 0
