#!/usr/bin/env bash

set -e

# kubectl 选项
# kubectl_options=" --kubeconfig /etc/kubernetes/config "
kubectl_options=""

red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
bold=`tput bold`
reset=`tput sgr0`

function show_help() {
    echo "${bold}用途:${reset}"
    echo
    echo "连接到 kubernetes 编排的容器内的 shell"
    echo
    echo "${bold}选项:${reset}"
    echo
    echo "-n 命名空间，默认值 default"
    echo "-p pod 名，模糊匹配"
    echo "-c pod 内容器编号，从 0 开始，默认值为 0"
    echo
    echo "如果不通过选项传递参数，会尝试从直接传递的参数中获取值，见 example [不通过选项传递参数] 一节，${red}两种传递参数的方式不能混用${reset}"
    echo
    echo "${bold}EXAMPLE:${reset}"
    echo
    echo "通过选项传递参数:"
    echo "${blue}./floo.sh -n test -p shop -c 1${reset} 在 test 命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 1 个容器的命令行"
    echo "${blue}./floo.sh -p shop -c 1${reset} 在 default（命名空间默认值）命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 1 个容器的命令行"
    echo
    echo "不通过选项传递参数:"
    echo
    echo "只传递一个参数，使用参数作为 pod 过滤字符"
    echo "${blue}./floo.sh shop${reset} 在 default（命名空间默认值）命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 0 个容器的命令行"
    echo
    echo "传递两个参数，分两种情况:"
    echo "1. 第二个参数只有一个数字，此时第一个参数作为 pod 过滤字符，第二个参数作为 pod 内容器编号"
    echo "${blue}./floo.sh shop 1${reset} 在 default（命名空间默认值）命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 1 个容器的命令行"
    echo "1. 第二个参数不只是一个数字，此时第一个参数作为命名空间名称， 第二个参数作为 pod 过滤字符"
    echo "${blue}./floo.sh prod shop${reset} 在 prod 命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 0 个容器的命令行"
    echo
    echo "传递三个参数，第一个参数作为命名空间名称，第二个参数作为 pod 过滤字符，第三个参数作为 pod 内容器编号"
    echo "${blue}./floo.sh prod shop 1${reset} 在 prod 命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 1 个容器的命令行"
}

# 判断是否安装 kubectl
if [ ! `which kubectl` ]; then
    echo "${red}未找到 kubectl 可执行文件${reset}"
    exit 1
fi


namespace="default"
pod=""
container=""

if [ $# -eq 0 ]; then
    # 没有参数
    echo "${red}没有参数，默认显示所有命名空间：${reset}"
    kubectl $kubectl_options get namespace
    exit 1
else
    #update single project
    while getopts "n:p:c:h" optname
    do
        case "$optname" in
            "n")
                namespace="$OPTARG"
                ;;
            "p")
                pod="$OPTARG"
                ;;
            "c")
                container="$OPTARG"
                ;;
            "h")
                show_help
                exit 0
                ;;
        esac
    done
fi

# 通过选项没有获取到参数，尝试通过序号获取

if [ ! $# -eq 0 ] && [ -z "$pod" ]; then
    if [ $# -eq 1 ]; then
        pod="$1"
    elif [ $# -eq 2 ]; then
        second_arg_length=`printf "$2" | wc -m`
        if [[ "$2" =~ ^[0-9]$ ]]; then
            pod="$1"
            container="$2"
        else
            namespace="$1"
            pod="$2"
        fi
    elif [ $# -eq 3 ]; then
        namespace="$1"
        pod="$2"
        container="$3"
    else
        echo "${red}参数非法!${reset}"
        show_help
    fi
fi

if [ -z "$pod" ]; then
    echo "${red}必须通过 -p 选项指定 pod 搜索条件${reset}"
    exit 1
fi

# 通过 kubectl $kubectl_options 查询 pod
pod_list=`kubectl $kubectl_options get pod -n $namespace | grep $pod`
if [ "$?" == "0" ]; then
    pod_result_count=`echo "$pod_list" | wc -l`
    if [ "$pod_result_count" = "0" ]; then
        # 没有查到内容
        echo "${red}通过 $pod 模糊匹配失败${reset}"
        exit 1
    elif [ "$pod_result_count" = "1" ]; then
        # 只查到一个 pod，判断容器状态
        pod_id=`echo "$pod_list" | awk '{print $1}'`
        pod_status=`echo "$pod_list" | awk '{print $3}'`
        if [ "$pod_status" = "Running" ]; then
            # pod 运行状态，判断容器数量
            container_number=`echo "$pod_list" | awk '{print $2}' | cut -d '/' -f 2`
            if [ "$container_number" = "1" ]; then
                # 单个容器，进入到 shell
                echo "${green} 进入 pod $pod_id 的命令行： ${reset}"
                kubectl $kubectl_options exec -n $namespace $pod_id -it /bin/bash
            else
                if [ -z "$container" ]; then
                    # 多个容器，参数未传容器编号
                    echo "${green} pod 内含有多个容器，请在参数中指定容器编号：${reset}"
                    kubectl $kubectl_options get pod -n $namespace $pod_id -o jsonpath={.spec.containers[*].name} | tr ' ' '\n' | nl -w2 -s': ' -v 0
                else
                    # 多个容器，进入指定编号的容器
                    container_name=`kubectl $kubectl_options get pod -n $namespace $pod_id -o jsonpath={.spec.containers[$container].name}`
                    echo "${green} 进入 pod $pod_id 容器 $container_name 的命令行： ${reset}"
                    kubectl $kubectl_options exec -n $namespace $pod_id -it /bin/bash -c "$container_name"
                fi
            fi
        else
            echo "${red}pod $pod_id 非运行状态${reset}"
            echo "$pod_list"
            exit 1
        fi
    else
        # 查到多个 pod，提示更改查询条件
        echo "${green}找到多个 pod，请使用更精确的过滤条件${reset}"
        echo "$pod_list"
        exit 1
    fi
else
    # 命令执行失败
    echo "${red}命令执行失败，请检查网络状况或者集群${reset}"
    echo "$pod_list"
    exit 1
fi
