#! /bin/bash
set -e

############### 编译 ###############

# 引入配置
source "$WORK_PATH"/script/include/conf.sh

echoContent green "################### Build 开始 ###################"

cd "$WORK_PATH"

if [[ -z "$1" ]]; then
  echoContent green "编译为正式包..."
  go build -o "$server"
else
  echoContent green "编译为 Debug 包(支持远程调试)"
  GOOS=linux go build -gcflags "all=-N -l" -o "$server"
fi

echoContent default "编译成功: $WORK_PATH/$server"

echoContent green "################### Build 结束 ###################"