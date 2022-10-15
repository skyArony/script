#! /bin/bash
set -e

# 引入基础配置
source "$WORK_PATH"/script/include/env_base.sh

###################### 多环境参数配置 ######################
if [[ "$1" == "dev" ]]; then
  ################## 本地开发环境 ##################
  export namespace=Development
  export env_name=local
  export log_level=debug
  export log_roll_type=size
  export log_path=./log
  export transport=default
  ############### 通过 elif 添加其他环境... ###############
fi
