## kubectl-exec

帮助文档见 ./floo.sh -h

### 变量

#### kubectl\_options

额外的 kubectl 参数，每一次执行 kubectl 都会使用这些选项

### 用途

连接到 kubernetes 编排的容器内的 shell

### 选项

1. -n 命名空间，默认值 default
1. -p pod 名，模糊匹配
1. -c pod 内容器编号，从 0 开始，默认值为 0

如果不通过选项传递参数，会尝试从直接传递的参数中获取值，见 example [不通过选项传递参数] 一节，两种传递参数的方式不能混用

### EXAMPLE:

#### 通过选项传递参数

```
#  在 test 命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 1 个容器的命令行
./floo.sh -n test -p shop -c 1

#  在 default（命名空间默认值）命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 1 个容器的命令行
./floo.sh -p shop -c 1
```

#### 不通过选项传递参数

如果不通过选项指定，脚本会尝试通过序号获取参数

##### 只传递一个参数

使用参数作为 pod 过滤字符

```
#  在 default（命名空间默认值）命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 0 个容器的命令行
./floo.sh shop
```

##### 传递两个参数

分两种情况:

1. 第二个参数只有一位数字，此时第一个参数作为 pod 过滤字符，第二个参数作为 pod 内容器编号

```
#  在 default（命名空间默认值）命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 1 个容器的命令行
./floo.sh shop 1
```

2. 第二个参数不是一位数字，此时第一个参数作为命名空间名称， 第二个参数作为 pod 过滤字符

```
#  在 prod 命名空间中查找 pod 名称中包含 shop 的 pod，进入到其中第 0 个容器的命令行
./floo.sh prod shop
```

##### 传递三个参数

第一个参数作为命名空间名称，第二个参数作为 pod 过滤字符，第三个参数作为 pod 内容器编号

```
# 在 prod 命名中间中 pod 名称中包含 shop 的 pod，进入到其中第 1 个容器的命令行
./floo.sh prod shop 1
```
