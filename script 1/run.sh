#! /bin/bash

############### 运行（流水线运行入口） ###############

echo -e "\033[92m############## Run 开始 ##############\033[0m"

# 重启
./restart.sh

# 如果守护进程已经存在，kill 掉
if [ -f "../bin/daemon.pid" ];then
  PID="$(cat ../bin/daemon.pid)"
  if [ "$PID" ]; then
    num="$(ps -p "$PID" | grep -c daemon.sh)"
    if [ "$num" == 1 ];then
      kill -9 "$PID"
      echo "KILL OLD: $PID"
    fi
  fi
fi

# 等待 1s
sleep 1

# 启动守护进程
./daemon.sh >> ../bin/daemon.log 2>&1 &
PID=$!
echo $PID > ../bin/daemon.pid
echo "NEW PID: $PID"

echo -e "\033[92m############## Run 结束 ##############\033[0m"
