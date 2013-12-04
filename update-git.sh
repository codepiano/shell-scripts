#!/bin/bash 
#execute 'git pull' command in all subdirectory under the given path

#the given path,eg:("~/git","/git",...)
path_list=("$HOME/wiz-github" "$HOME/git")
#total repostitory
total_count=0
#no such directory error
NO_SUCH_DIRECTORY_ERROR=2

function pull() {
    local single_project_path=$1
    local error_code=0;
    if [ -d "$single_project_path" ]
    then
        if [ -d "$single_project_path/.git" ]
        then
            echo "------------------- $single_project_path"
            git --git-dir "$single_project_path/.git" pull origin master
            error_code=$?
        fi
        #update submodules
        if [ -f "$single_project_path/.gitmodules" ]
        then
            echo "------------------- $single_project_path submodules"
            (cd $single_project_path && git submodule foreach git pull origin master)
            error_code=$?
        fi
    else
        error_code=$NO_SUCH_DIRECTORY_ERROR
    fi
    return $error_code
}

function update() {
    local projects_host=$1
    local error_code=0;
    if [ -d "$projects_host" ]; then
        echo ">>>>>>>>>>>>>>>>>>> scaning $projects_host"
        for file in `ls $projects_host`
        do
            if [ -d "$projects_host/$file" ] 
            then
                pull $projects_host/$file
                error_code=$?
            fi
        done
        echo "<<<<<<<<<<<<<<<<<<< $projects_host done"
    fi
}

if [ $# -eq 0 ]
then
	#update all project
	echo "=================== start"
	for path in "${path_list[@]}"
	do
        update $path
	done
	echo "=================== $total_count pulled"
else
	#update single project
	while getopts "ld:" optname
	do
		case "$optname" in
			"d")
				echo "$OPTARG"
                    pull $OPTARG
				;;
        esac
        case "$optname" in
			"l")
                echo "请选择要更新的目录序号:"
                for ((index=0;index<${#path_list[@]};index++))
                do
                    echo ${index}:${path_list[$index]}
                done
                read select
                update ${path_list[$select]}
				;;
		esac
	done
fi
