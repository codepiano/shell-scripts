#!/bin/bash 
#execute 'git pull' command in all subdirectory under the given path

#the given path,eg:("~/git","/git",...)
path_list=("$HOME/git" "/git")
#total repostitory
total_count=0
if [ $# -eq 0 ]
then
	#update all project
	echo "=================== start"
	for path in "${path_list[@]}"
	do
		if [ -d "$path" ]; then
			echo ">>>>>>>>>>>>>>>>>>> scaning $path"
			for file in `ls $path`
			do
				if [ -d "$path/$file" ] && [ -d "$path/$file/.git" ]
				then
					echo "------------------- $file"
					git --git-dir "$path/$file/.git" pull
					((total_count=total_count+1))
				fi
			done
			echo "<<<<<<<<<<<<<<<<<<< $path done"
		fi
	done
	echo "=================== $total_count pulled"
else
	#update single project
	while getopts "d:" optname
	do
		case "$optname" in
			"d")
				echo "$OPTARG"
					if [ -d "$OPTARG" ] && [ -d "$OPTARG/.git" ]
					then
						echo "------------------- $OPTARG"
						git --git-dir "$OPTARG/.git" pull
					fi
				;;
			*)
				;;
		esac
	done
fi
