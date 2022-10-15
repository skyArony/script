#! /bin/bash
set -e

############### 停止 ###############

# 引入配置
source "$WORK_PATH"/script/include/conf.sh

# 设置脚本执行的日志记录文件
startStopLogFile="$WORK_PATH"/log/start_stop.log # start & stop 脚本的执行输出日志

######### 停止服务 #########
stopService() {
  # 检查进程数
  num="$(pgrep -f "$execCmd" | wc -l)"
  num=$(eval echo "$num")
  echoContent default "当前服务进程数: $num" "$startStopLogFile"

  # 杀死进程
  if [[ "$num" -gt 0 ]]; then
    echoContent default "杀死所有 $binFile 进程..." "$startStopLogFile"
    pkill -15 -f "$execCmd" # 这里使用 15 而非 9 时因为 15 是 trpc 进程注册了的终止信号量
    sleep 3
  fi

  # 再次检查进程数
  num="$(pgrep -f "$execCmd" | wc -l)"
  num=$(eval echo "$num")
  echoContent default "再次检查当前服务进程数: $num" "$startStopLogFile"
}

######### 停止守护进程 #########
stopDaemon() {
  # 检查进程数
  daemonCmd="$WORK_PATH"/script/include/daemon.sh
  num="$(pgrep -f "$daemonCmd" | wc -l)"
  num=$(eval echo "$num")
  echoContent default "当前守护进程数: $num" "$startStopLogFile"

  # 杀死进程
  if [[ "$num" -gt 0 ]]; then
    echoContent default "杀死所有守护进程..." "$startStopLogFile"
    pkill -15 -f "$daemonCmd" # 这里使用 15 而非 9 时因为 15 是 trpc 进程注册了的终止信号量
    sleep 3
  fi

  # 再次检查进程数
  num="$(pgrep -f "$daemonCmd" | wc -l)"
  num=$(eval echo "$num")
  echoContent default "再次检查当前守护进程数: $num" "$startStopLogFile"
}


echoContent green "################### Stop 开始 ###################" "$startStopLogFile"

if [[ -z "$1" ]]; then
  echoContent green "stop 服务..." "$startStopLogFile"
  stopService
elif [[ "$1" == "daemon" ]]; then
  echoContent green "stop 守护进程..." "$startStopLogFile"
  stopDaemon
else
  echoContent green "stop 服务 & 守护进程..." "$startStopLogFile"
  stopDaemon
  stopService
fi



# 输出结果
if [[ "$num" -eq 0 ]];then
  echoContent green "################### Stop 成功 ###################" "$startStopLogFile"
else
  echoContent red "################### Stop 失败 ###################" "$startStopLogFile"
  exit 1
fi
