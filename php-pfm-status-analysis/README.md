### 前置条件

php-fpm 开启配置：

`pm.status_path = /status`

```
# https://github.com/php/php-src/blob/28985e982b5ecef73615a949632f7985ac72d0de/sapi/fpm/www.conf.in#L232

; Note: There is a real-time FPM status monitoring sample web page available
;       It's available in: @EXPANDED_DATADIR@/fpm/status.html
;
; Note: The value must start with a leading slash (/). The value can be
;       anything, but it may not be a good idea to use the .php extension or it
;       may conflict with a real PHP file.
; Default Value: not set
pm.status_path = /status

; By default the status page output is formatted as text/plain. Passing either
; 'html', 'xml' or 'json' in the query string will return the corresponding
; output syntax. Example:
;   http://www.foo.bar/status
;   http://www.foo.bar/status?json
;   http://www.foo.bar/status?html
;   http://www.foo.bar/status?xml
;
; By default the status page only outputs short status. Passing 'full' in the
; query string will also return status for each pool process.
; Example:
;   http://www.foo.bar/status?full
;   http://www.foo.bar/status?json&full
;   http://www.foo.bar/status?html&full
;   http://www.foo.bar/status?xml&full
```

### 脚本使用方法

#### 使用说明
1. 请求 localhost/status?full 获得 php-fpm 各进程的状态的文本，保存到文本文件，文件名模式为:status{数字}，例如 status8、status9、status6、status4
2. 调用脚本对文件进行分析
    + 第一个参数为数字，拼接到status后面作为文件名，调用 ./analysis.sh 1 就分析当前目录下的 status1 文件，不传参数就分析当前目录下的 status 文件
    + 第二个参数为文本或者正则表达式，当一台机器上运行部署多个项目的时候，用来过滤项目，比如 status194 中同时有 example 和 other 两个项目，需要通过正则表达式对执行的 script 进行过滤，获取目标进程的信息，过滤功能是通过对 php-fpm 输出的 script 行进行过滤实现

#### eg:

目录下的 status194 是一个 php-fpm 输出的示例数据文件，执行 `./analysis.sh 194 '\/example\.*'` 可以对其进行分析，获取 example 进程的信息

*bash 脚本性能低，文件行数过多的话速度比较慢*

### php-fpm 输出信息说明

localhost/status 输出的进程状态统计信息参数说明：

```
# https://github.com/php/php-src/blob/28985e982b5ecef73615a949632f7985ac72d0de/sapi/fpm/www.conf.in#L135

; The URI to view the FPM status page. If this value is not set, no URI will be
; recognized as a status page. It shows the following informations:
;   pool                 - the name of the pool;
;   process manager      - static, dynamic or ondemand;
;   start time           - the date and time FPM has started;
;   start since          - number of seconds since FPM has started;
;   accepted conn        - the number of request accepted by the pool;
;   listen queue         - the number of request in the queue of pending
;                          connections (see backlog in listen(2));
;   max listen queue     - the maximum number of requests in the queue
;                          of pending connections since FPM has started;
;   listen queue len     - the size of the socket queue of pending connections;
;   idle processes       - the number of idle processes;
;   active processes     - the number of active processes;
;   total processes      - the number of idle + active processes;
;   max active processes - the maximum number of active processes since FPM
;                          has started;
;   max children reached - number of times, the process limit has been reached,
;                          when pm tries to start more children (works only for
;                          pm 'dynamic' and 'ondemand');
; Value are updated in real time.
; Example output:
;   pool:                 www
;   process manager:      static
;   start time:           01/Jul/2011:17:53:49 +0200
;   start since:          62636
;   accepted conn:        190460
;   listen queue:         0
;   max listen queue:     1
;   listen queue len:     42
;   idle processes:       4
;   active processes:     11
;   total processes:      15
;   max active processes: 12
;   max children reached: 0
```

localhost/status?full 输出的各个进程信息参数说明：

```
# https://github.com/php/php-src/blob/28985e982b5ecef73615a949632f7985ac72d0de/sapi/fpm/www.conf.in#L186

; The Full status returns for each process:
;   pid                  - the PID of the process;
;   state                - the state of the process (Idle, Running, ...);
;   start time           - the date and time the process has started;
;   start since          - the number of seconds since the process has started;
;   requests             - the number of requests the process has served;
;   request duration     - the duration in µs of the requests;
;   request method       - the request method (GET, POST, ...);
;   request URI          - the request URI with the query string;
;   content length       - the content length of the request (only with POST);
;   user                 - the user (PHP_AUTH_USER) (or '-' if not set);
;   script               - the main script called (or '-' if not set);
;   last request cpu     - the %cpu the last request consumed
;                          it's always 0 if the process is not in Idle state
;                          because CPU calculation is done when the request
;                          processing has terminated;
;   last request memory  - the max amount of memory the last request consumed
;                          it's always 0 if the process is not in Idle state
;                          because memory calculation is done when the request
;                          processing has terminated;
; If the process is in Idle state, then informations are related to the
; last request the process has served. Otherwise informations are related to
; the current request being served.
; Example output:
;   ************************
;   pid:                  31330
;   state:                Running
;   start time:           01/Jul/2011:17:53:49 +0200
;   start since:          63087
;   requests:             12808
;   request duration:     1250261
;   request method:       GET
;   request URI:          /test_mem.php?N=10000
;   content length:       0
;   user:                 -
;   script:               /home/fat/web/docs/php/test_mem.php
;   last request cpu:     0.00
;   last request memory:  0
```
