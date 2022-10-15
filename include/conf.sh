#! /bin/bash
set -e

# 引入环境参数
source "$WORK_PATH"/script/include/env.sh
source "$WORK_PATH"/script/include/util.sh

################ 启停参数配置 ###############

# 可执行文件名
binFile="$server"
# 启动命令
execCmd="$WORK_PATH/$binFile"

################ 启停参数配置 ###############
