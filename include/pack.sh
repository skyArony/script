#! /bin/bash
set -e

############### 打包 ###############

# 引入配置
source "$WORK_PATH"/script/include/conf.sh

echoContent green "################### 打包开始 ###################"

cd "$WORK_PATH"

# 创建临时目录
packDir=pack_temp
rm -rf "$packDir"
mkdir -p "$packDir/$server"
echoContent green "创建临时目录: $packDir/$server"

# 目前打包需要的文件清单:
#   1. 可执行文件
#   2. trpc_go.yaml 配置文件
#   3. script 启停脚本
pack_list=(
  script
  "$server"
  trpc_go.yaml
)

for item in "${pack_list[@]}"
do
  echoContent default "复制 $item ==> $packDir/$server"
  cp -r "$item" "$packDir/$server"
done

# 压缩打包
echoContent green "开始打包..."
tar -zcv -f "$server".tar.gz -C "$packDir" .
echoContent green "打包成功: $WORK_PATH/$server.tar.gz"

# 删除临时目录
echoContent green "删除临时目录..."
rm -rf "$packDir"

## 打印解压命令
echoContent yellow "打包结束，后续可以使用如下命令解压: "
echoContent default "tar -zxv -f $server.tar.gz -C 要解压到的目录"

echoContent green "################### 打包结束 ###################"