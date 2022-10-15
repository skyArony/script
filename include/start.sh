#! /bin/bash
set -e

############### 启动 ###############

# 引入配置
source "$WORK_PATH"/script/include/conf.sh

# 设置脚本执行的日志记录文件
startStopLogFile=$WORK_PATH/log/start_stop.log # start & stop 脚本的执行输出日志

# 输出环境参数
echoContent green "#################### 环境参数 ####################" "$startStopLogFile"
echoContent default "Namespace: $namespace" "$startStopLogFile"
echoContent default "EnvName: $env_name" "$startStopLogFile"
echoContent default "LogPath: $log_path" "$startStopLogFile"
echoContent default "Transport: $transport" "$startStopLogFile"

# 输出启停参数
echoContent green "#################### 启停参数 ####################" "$startStopLogFile"
echoContent default "可执行文件: $execCmd" "$startStopLogFile"

echoContent green "################### Start 开始 ###################" "$startStopLogFile"

# 检查进程数
num="$(pgrep -f "$execCmd" | wc -l)"
num=$(eval echo "$num")
echoContent default "当前进程数: $num" "$startStopLogFile"

# 退出
if [[ "$num" -ge 1 ]]; then
    echoContent red "############# 执行失败，请勿重复启动 #############" "$startStopLogFile"
    exit 1
fi

# 启动
echoContent default "启动 $binFile 进程..." "$startStopLogFile"
ulimit -c unlimited # 放开资源限制
export GOTRACEBACK=single # Core 时输出协程调用栈
nohup "$execCmd" > /dev/null 2>&1  &

# 等待 3s
sleep 3

# 再次检查进程数
num="$(pgrep -f "$execCmd" | wc -l)"
num=$(eval echo "$num")
echoContent default "再次检查当前进程数: $num" "$startStopLogFile"

# 输出结果
if [[ "$num" -eq 1 ]];then
  echoContent green "################### Start 成功 ###################" "$startStopLogFile"
else
  echoContent red "################### Start 失败 ###################" "$startStopLogFile"
  exit 1
fi
