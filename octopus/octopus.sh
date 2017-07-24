#!/usr/bin/env bash


#  ___________________________________
# / tmux broadcast模式下根据pane-index\
# \ 连接远程server                    /
#  -----------------------------------
#         \   ^__^
#          \  (oo)\_______
#             (__)\       )\/\
#                 ||----w |
#                 ||     ||

# 解决的问题：
#     tmux 打开多个 pane 操作多个远程服务器，需要切换到每个 pane 单独登录，然后再使用 synchronize-panes 模式，比较麻烦
#
# 解决办法：
#     假如有 4 个服务器: s1 s2 s3 s4，启动 tmux 分割窗口为 4 个 pane
#     tmux 的配置文件中使用 set -g pane-base-index 1 使 pane 编号从 1 而不是 0 开始
#     为方便登录一般会在 ~/.ssh/config 中添加配置如下：
#         Host *
#         HostName 10.0.0.%h
#         User root
#     这样在 tmux 的 4 个 pane 中分别输入 ssh 1、ssh 2、ssh 3、ssh 4 就能连接到 4 个服务器
#     由于 tmux 的每个 pane 都有一个编号，可以利用这个编号和配置的规则
#     达到在 4 个 pane 中执行相同的命令来让每个 pane 连接到不同的远程服务器的效果
#
# 使用方法：
#     仍旧以上例，在 octopus 函数中的 SERVER_ALIAS_RULES 关联数组中定义规则如下：
#     SERVER_ALIAS_RULES["s"]="{index}" 
#     规则中的 {index} 会被替换为编号
#     source octopus.sh 以后可以在 tmux 中打开 4 个 pane，直接在 synchronize-panes 模式执行命令 octopus s
#     每个 pane 会按照自己的 tmux 编号分别连接到对应的 server，pane 1 执行 ssh 1，pane 2 执行 ssh 2 ...
#
# base 参数场景：
#     仍旧上例 4 个 server，只想操作 s2 和 s3，可以通过传递 base 参数来实现，octopus 会把 base 和 pane 编号相加作为最终的数字
#     在 tmux 中打开两个 pane，开启 synchronize-panes 模式，执行命令 octopus s 1，pane 1 会连接 s2， pane 2 会连接 s3
#     如果想操作 s3 和 s4 就执行 octopus s 2
#
# 服务器 ip 没有规律：
#     对于没有规律的服务器 ip，也可以通过配置 ~/.ssh/config 实现，下面是一个例子
#         Host s1-web
#         HostName 10.1.2.3
#
#         Host s2-web
#         HostName 10.4.5.6
#
#         Host s3-web
#         HostName 10.7.8.9
#
#         Host *-web
#         User root
#     配置规则 SERVER_ALIAS_RULES["web"]="s{index}-web"


function octopus() {
    declare -A SERVER_ALIAS_RULES
    # SERVER_ALIAS_RULES["web"]="s{index}-web"
    local base='0'
    if [[ "$2" != "" ]]; then
        base="$2"
    fi
    if [[  "$TMUX" = "" ]]; then
        echo 'must in a tmux pane!'
    else
        if [[  "$TMUX_PANE" = "" ]]; then
            echo "can not find variable 'TMUX_PANE' from env"
            exit 1
        fi
        local pane_index=`tmux display-message -t "$TMUX_PANE" -p "#{pane_index}"`
        pane_index=$(( $base + $pane_index ))
        if [[ -n "$pane_index" ]]; then
            local rule="${SERVER_ALIAS_RULES[\"$1\"]}"
            if [[ "$rule" = "" ]]; then
                echo "no rule for $1!"
            else
                ssh "${rule/\{index\}/$pane_index}"
            fi
        else
            echo 'get pane index failed!'
        fi
    fi
}
