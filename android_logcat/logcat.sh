#!/usr/bin/env bash

# __________________________
#< 查询安卓进程日志         >
# --------------------------
#        \   ^__^
#         \  (oo)\_______
#            (__)\       )\/\
#                ||----w |
#                ||     ||

# 使用方法：
#     1. 函数放入 .bashrc
#     2. 然后执行 source ~/.bashrc
#     3. 使用 logcat '用来grep进程的关键字' 查看进程日志
#     eg:
#       logcat push
#       logcat push$
#       logcat *push
#       logcat 'push[0-9]\+'
# alias：
#     在代码中的 declare -A PROCESS_ALIAS 下面添加行，格式如：PROCESS_ALIAS["替换为缩写关键字"]="替换为实际传递给grep的字符串"
#     eg:
#       declare -A PROCESS_ALIAS
#       PROCESS_ALIAS["p"]="push"
#       PROCESS_ALIAS["f"]="push[0-9]\+"
#     可以使用 logcat p 或者 logcat f 等避免过长的关键字输入
# 工作方式：
#     使用 grep 命令筛选进程和传递的关键字筛选进程，如果结果中只有 1 个进程，使用 logcat 查看该进程的日志
#     进程关键字可以使用 grep 命令支持的模式匹配或者正则表达式语法

function logcat()
{
    declare -A PROCESS_ALIAS
    # grep 关键字注释添加到下面
    # PROCESS_ALIAS["p"]="push[0-9]\+"
    local alias="${PROCESS_ALIAS["$1"]}"
    if [[ "$alias" == "" ]]; then
        alias=$1
    fi
    echo "grep process by keywords <$alias> :\n"
    adb shell ps | grep "$alias"
    linenumber=`adb shell "ps | grep \"$alias\"" | wc -l | tr -d ' '`
    if [ "$linenumber" -eq "1" ]; then
        adb logcat -v time | grep '(\s*'`adb shell "ps | grep \"$alias\"" | awk '{print $2}'`'):'
    else
        echo "\nshould grep one process with a unique keyword!"
    fi
}
