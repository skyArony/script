#! /bin/bash
set -e

############### 停止 ###############

# 引入配置
source ./conf.sh

echo -e "\033[92m######## Stop 开始 ########\033[0m"


# 获取工作目录，以精确定位执行文件和过程中文件
# 为了保证本地和远程调试体验一致，没有通过 readlink 来兼容符号链接的情况，因为这个函数在 macOS 上不兼容
WORK_PATH="$(dirname "$(pwd)")"

# 定位到项目根目录，即当前脚本位置的上级目录
cd "$WORK_PATH"
echo "设定工作目录: $WORK_PATH"

# 检查进程数
num="$(pgrep "$binFile" | wc -l)"
echo -n "剩余进程数: " && num=eval echo $num

# 杀死进程
if [ "$num" -gt 0 ]; then
  echo "杀死所有 $binFile 进程"
  pkill -9 "$binFile"
fi

# 等待 1s
sleep 1

# 再次检查进程数
num="$(pgrep $binFile | wc -l)"
echo -n "再次检查剩余进程数: " && num=eval echo $num

# 输出结果
if [ "$num" -eq 0 ];then
  echo -e "\033[92m######## Stop 成功 ########\033[0m"
else
  echo -e "\033[91m######## Stop 失败 ########\033[0m"
  exit 1
fi
