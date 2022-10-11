#! /bin/bash

############### 编译 ###############
# 正常编译 ./build.sh
# 调试编译 ./build.sh dev

set -e

# 引入配置
source ./conf.sh

echo -e "\033[92m######## Build 开始 ########\033[0m"


# 获取工作目录，以精确定位执行文件和过程中文件
# 为了保证本地和远程调试体验一致，没有通过 readlink 来兼容符号链接的情况，因为这个函数在 macOS 上不兼容
WORK_PATH="$(dirname "$(pwd)")"

# 定位到项目根目录，即当前脚本位置的上级目录
cd "$WORK_PATH"
echo "设定工作目录: $WORK_PATH"

# 开始编译
echo "编译目标: $main"
# 根据入参情况决定是否启动调试支持（参数不存在或者设置不为 dev 则进行 online 编译）
if [ -z "$1" ] || [ "$1" != "dev" ];then
  echo "编译中......"
  go build -o $bin $main
else
  echo "交叉编译中(支持远程调试)...... linux"
  GOOS=linux go build -gcflags "all=-N -l" -o $bin $main
fi

echo "编译结果: $bin"
echo -e "\033[92m######## Build 成功 ########\033[0m"
