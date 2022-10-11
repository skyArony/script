#! /bin/bash

############### 参数配置 ###############
# 不同项目改这里就好，后面不需要改动

# 可执行文件名
binFile=NBA2_Exporter
# 可执行文件相对工作目录的位置
bin=./bin/$binFile
# 编译入口文件相对工作目录的位置
main=./cmd/exporter/main.go
# 最大进程数
maxProcessNum=1

############### 参数配置 ###############
