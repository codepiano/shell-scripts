# 更改函数第一行 DOCKER_HOST 设置

# 使用方式：
    floo 搜索docker容器的关键字

# eg:
1. floo test
1. floo anything
1. floo test[0-9]

# 工作方式：
    通过 docker ps 命令列出所有容器，通过 grep 筛选，如果只筛选到 1 个容器，连接到容器的 shell
