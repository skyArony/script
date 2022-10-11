#! /bin/bash
set -e

############### 启动 ###############

# 引入配置
source ./conf.sh

echo -e "\033[92m######## Start 开始 ########\033[0m"


# 获取工作目录，以精确定位执行文件和过程中文件
# 为了保证本地和远程调试体验一致，没有通过 readlink 来兼容符号链接的情况，因为这个函数在 macOS 上不兼容
WORK_PATH="$(dirname "$(pwd)")"

# 定位到项目根目录，即当前脚本位置的上级目录
cd "$WORK_PATH"
echo "设定工作目录: $WORK_PATH"

# 检查进程数
num="$(pgrep "$binFile" | wc -l)"
echo -n "剩余进程数: " && num=eval echo $num

# 退出
if [ "$num" -ge 1 ]; then
    echo -e "\033[91m######## 执行失败，请勿重复启动 ########\033[0m"
    exit 1
fi

# 启动
echo "启动 $binFile 进程"
ulimit -c unlimited
export GOTRACEBACK=crash
printf "\n" >> ./bin/run.log
./bin/NBA2_Exporter >> ./bin/run.log 2>&1 &
PID=$!

# 再次检查进程数
num="$(pgrep "$binFile" | wc -l)"
echo -n "再次检查剩余进程数: " && num=eval echo $num
echo "PID: $PID"

# 输出结果
if [ "$num" -eq 1 ];then
  echo -e "\033[92m######## Start 成功 ########\033[0m"
else
  echo -e "\033[91m######## Start 失败 ########\033[0m"
  exit 1
fi
