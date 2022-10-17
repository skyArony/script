#! /bin/bash
set -e

########## 脚本工具函数 ##########

# 打印
echoContent() {
  # 如果第三个参数指定了文件则同步输入到文件里面
  if [[ $3 ]]; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") $2" >> $3
  fi

  echoType='echo -e'
	case $1 in
	"red")
		# shellcheck disable=SC2154
		${echoType} "\033[31m$2 \033[0m"
		;;
	"skyBlue")
		${echoType} "\033[1;36m$2 \033[0m"
		;;
	"green")
		${echoType} "\033[32m$2 \033[0m"
		;;
	"deepGreen")
		${echoType} "\033[92m$2 \033[0m"
		;;
	"white")
		${echoType} "\033[37m$2 \033[0m"
		;;
	"purple")
		${echoType} "\033[35m$2 \033[0m"
		;;
	"yellow")
		${echoType} "\033[33m$2 \033[0m"
		;;
  *)
    ${echoType} "$2"
    ;;
	esac
}

#echoContent red "123" ./xx.log
#echoContent skyBlue "123"
#echoContent green "123"
#echoContent white "123"
#echoContent purple "123"
#echoContent yellow "123"
#echoContent default "123"