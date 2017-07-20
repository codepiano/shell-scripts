#!/usr/bin/env bash

# _________________________
#/ 通过 grep 筛选出 docker \
#\ 容器进程，连接容器终端 /
# ------------------------
#        \   ^__^
#         \  (oo)\_______
#            (__)\       )\/\
#                ||----w |
#                ||     ||

# 更改函数第一行 DOCKER_HOST 设置
# 使用方式：
#     floo 搜索docker容器的关键字
# eg:
#     floo test
# 工作方式：
#     通过 docker ps 命令列出所有容器，通过 grep 筛选，如果只筛选到 1 个容器，连接到容器的 shell

function floo()
{
    export DOCKER_HOST=tcp://127.0.0.1:2376
    echo "find docker containers:"
    docker ps | grep "$1"
    linenumber=`docker ps | grep "$1"  | wc -l | tr -d ' '`
    if [ "$linenumber" -eq "1" ]; then
        docker exec -it `docker ps | grep "$1" | awk '{print $1}'` /bin/bash
    fi
    unset DOCKER_HOST
}
