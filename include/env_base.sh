#! /bin/bash
set -e

############### trpc_go.yaml 参数配置 ###############
# 复制到新项目使用的话，只要改这个文件的配置就可以了
# 基础参数默认是以 Production 环境配置的，无需新增或者修改就可以以生产环境的方式启动
# 其他开发环境配置是基于以下基础参数进行新增或者覆盖得到的

# APP 通用配置
export namespace=Production
export env_name=online
export app=nba2
export server=http_proxy
export zone_id=0
export transport=tbuspp
export log_level=info
export log_roll_type=time
export log_path=~user00/nba2/logs/trpc/${server}

# tbuspp 配置
export agent_url=tbuspp://127.0.0.1:11235
export game_id=478756237
export password=29b9347cfa24d9f5e683da11e2a611be

############### trpc_go.yaml 参数配置 ###############
