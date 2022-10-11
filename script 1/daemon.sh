#! /bin/bash
set -e

############### 守护进程 ###############

# 引入配置
source ./conf.sh

echo -e "\033[92m######## Daemon 开始 ########\033[0m"

while true; do
  # 检查进程数
  num="$(pgrep "$binFile" | wc -l)"
  time=$(date "+%Y-%m-%d %H:%M:%S")
  echo -n "$time 当前进程数: " && num=eval echo $num
  # 小于 1，杀掉所有进程重启
  if [ "$num" -lt "$maxProcessNum" ]; then
      echo -e "\033[93m######## 进程数小于 $maxProcessNum ,杀掉所有进程重启 ########\033[0m"
      ./restart.sh
  # 大于 1，杀掉所有进程重启
  elif [ "$num" -gt "$maxProcessNum" ]; then
      echo -e "\033[93m######## 进程数小于 $maxProcessNum ,杀掉所有进程重启 ########\033[0m"
      ./restart.sh
  fi
  sleep 10
done

exit 0
