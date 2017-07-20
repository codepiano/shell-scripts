# 使用方法
1. 函数放入 .bashrc
1. 然后执行 source ~/.bashrc
1. 使用 logcat '用来grep进程的关键字' 查看进程日志

# eg:
1. logcat push
1. logcat push\$
1. logcat \*push
1. logcat 'push[0-9]\+'

# alias：
在代码中的 declare -A PROCESS_ALIAS 下面添加行，格式如：PROCESS_ALIAS["替换为缩写关键字"]="替换为实际传递给grep的字符串"，eg:

      declare -A PROCESS_ALIAS
      PROCESS_ALIAS["p"]="push"
      PROCESS_ALIAS["f"]="push[0-9]\+"
      
可以使用 logcat p 或者 logcat f 等避免过长的关键字输入

# 工作方式：
使用 grep 命令筛选进程和传递的关键字筛选进程，如果结果中只有 1 个进程，使用 logcat 查看该进程的日志

进程关键字可以使用 grep 命令支持的模式匹配或者正则表达式语法
