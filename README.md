pull-all-git-project
====================

在给定目录的所有子文件夹下执行git pull

execute "git pull" command in the subdirectory of the specify directory

如果你签出的项目都在一个或几个目录下，

if your projects under git control are in one directory or more

例如,你使用git clone命令签出了4个项目到F:\GIT目录下：

eg，if you cloned 4 projects in F:\GIT with 'git clone' command:

>F:\GIT

>├─JQuerySourceCode

>├─pull-all-git-project

>├─RapidValidation

>└─TableKnight

可以在脚本的配置变量中添加路径：F:\GIT，执行脚本就可以依次在每个目录中执行git pull命令，具体的配置方式参见下面的说明

then you can add the path "F:\GIT" into the script,execute the script,all the projects under git control will be update(examples below)

Linux Bash脚本 (Linux Bash Script）
--------------------

默认的路径为 $HOME/git 和 /git

the default path is $HOME/git and /git

请修改脚本添加自己的设置

please modify the script to add your own directory path

按照例子修改path\_list变量,使用$HOME来代替~

modify the variable path\_list,use $HOME instead of symbol '~'

eg:

>*添加以前 before:*

>path\_list=("$HOME/git" "/git")

>*添加以后 after add my git path:F:/git*

>path\_list=("$HOME/git" "/git" "F:/git")

Windows批处理脚本 (Windows Batch Script）
--------------------

默认的路径为 %cd% （当前脚本所在路径） 和 %homedrive%%homepath% （系统用户主目录的完整路径）

the default path is %cd% (the path to the bat-file itself) and %homedrive%%homepath% (the user's home path)

请修改脚本添加自己的设置

please modify the script to add your own directory path

按照例子添加path1,path2,paht3,...,path1000变量，数字必须连续

add the variable path1,path2,path3,...,path1000,the number must begin with 1,step 1,the max number is 1000,I think it is enough

eg:

>*添加以前 before*

>set path1=%cd%

>set path2=%homedrive%%homepath%

>*添加以后 after add my git path:F:/git*

>set path1=%cd%

>set path2=%homedrive%%homepath%

>set path3=F:\git 

