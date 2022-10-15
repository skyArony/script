#! /bin/bash
set -e

# 帮助提示
if [[ -z "$1" || "$1" == "-h" || "$1" == "-help" || "$1" == "--help" || "$1" == "help" ]]; then
  echo -e "\033[92m################### 进程管理脚本 ###################\033[0m"
  echo -e "本脚本通用于基于 trpc-go 开发的项目\n"
  echo -e "可使用的命令:"

  echo -e "   \033[35m1. 启动守护进程\033[0m ./cmd.sh daemon [dev|other...]"
  echo -e "      不带参数: 启动为生产环境模式"
  echo -e "      dev: 启动为开发环境模式"
  echo -e "      可以修改 script/include/env.sh 脚本添加其他模式"

  echo -e "   \033[35m2. 启动服务\033[0m ./cmd.sh start [dev|other...]"
  echo -e "      这里的参数效果和「启动守护进程」一致"

  echo -e "   \033[35m3. 停止服务\033[0m ./cmd.sh stop [daemon|all]"
  echo -e "      不带参数: 停止服务（如果守护进程还在的话，又会被重新拉起）"
  echo -e "      daemon: 停止守护进程"
  echo -e "      all: 停止守护进程和服务"

  echo -e "   \033[35m4. 编译\033[0m ./cmd.sh build [debug]"
  echo -e "      不带参数: 编译为生产环境包"
  echo -e "      debug: 编译为支持远程调试的包"

  echo -e "   \033[35m5. 打包\033[0m ./cmd.sh pack"
    echo -e "      将需要部署到机器上的文件打包为压缩包"

  echo -e "\nTips:"
  echo -e "   1. 建议直接使用「启动守护进程」命令来启动服务"
  echo -e "   2. 守护进程没有关闭时，关闭服务后可能会被再度拉起，因此建议使用 ./cmd.sh stop all 来停止服务"
  echo -e "   3. 需要进行部署时，先执行「编译」命令，再执行「打包」命令，即可得到用于部署的压缩包"

  echo -e "\n使用 \"./cmd.sh -h\" 来获取帮助\n"

  exit
fi

# 获取工作目录，以精确定位执行文件和过程中文件
# 为了保证本地和远程调试体验一致，没有通过 readlink 来兼容符号链接的情况，因为这个函数在 macOS 上不兼容
# 定位到项目根目录，即当前脚本位置的上级目录
WORK_PATH="$(dirname "$(pwd)")"
export WORK_PATH=$WORK_PATH
cd "$WORK_PATH"
source "$WORK_PATH"/script/include/util.sh
echoContent yellow "设定工作目录: $WORK_PATH"

# 设置脚本日志目录
startStopLogFile=$WORK_PATH/log/start_stop.log # start & stop 脚本的输出
daemonLogFile=$WORK_PATH/log/daemon.log  # daemon 脚本的输出

case $1 in
  "pack")
    "$WORK_PATH"/script/include/pack.sh
    ;;
  "build")
    "$WORK_PATH"/script/include/build.sh "$2"
    ;;
  "start")
    "$WORK_PATH"/script/include/start.sh "$2"
    ;;
  "stop")
    "$WORK_PATH"/script/include/stop.sh "$2"
    ;;
  "daemon")
    daemonScriptNum=$(pgrep -f "$WORK_PATH"/script/include/daemon.sh | wc -l)
    daemonScriptNum=$(eval echo "$daemonScriptNum")
    if [[ "$daemonScriptNum" -lt 1 ]]; then
      nohup "$WORK_PATH"/script/include/daemon.sh "$2"  > /dev/null 2>&1 &
      daemonScriptNum=$(pgrep -f "$WORK_PATH"/script/include/daemon.sh | wc -l)
      daemonScriptNum=$(eval echo "$daemonScriptNum")
      if [[ "$daemonScriptNum" -eq 1 ]]; then
        echoContent green "守护进程启动成功！"
      elif [[ "$daemonScriptNum" -gt 1 ]]; then
        echoContent red "守护进程数异常: $daemonScriptNum"
      else
        echoContent red "守护进程启动失败！"
      fi
    elif [[ "$daemonScriptNum" -gt 1 ]]; then
      echoContent red "守护进程数异常: $daemonScriptNum"
    else
      echoContent green "守护进程正在运行！"
    fi
    ;;
  *)
    ;;
esac
