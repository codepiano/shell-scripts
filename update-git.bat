@echo off
rem given path
set path1=%cd%
set path2=%homedrive%%homepath%
rem eg:
rem set path3=C:\
rem set path4=D:\
setlocal enabledelayedexpansion
set /a total_count=0
set /a path_index=1
if "%1"=="" (
	echo =================== start
	rem traversal each path
	for /L %%i in (1,1,1000) do (
		if defined path%%i if exist !path%%i! (
			echo ^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>^>^> scaning !path%%i!
			for /D %%r in (!path%%i!\*) do (
				if exist %%r\.git (
					echo ------------------- %%r
					git --git-dir "%%r\.git" pull
					set /a total_count=total_count+1
				)
				if exist %%r\.gitmodules (
					echo ------------------- %%r submodules
					cd /d %%r && git submodule foreach git pull origin master
				)
		    )
			echo ^<^<^<^<^<^<^<^<^<^<^<^<^<^<^<^<^<^<^< !path%%i! done
		) else (
			goto end
		)
	)
	echo =================== !total_count! pulled
) else (
	if exist %1\.git (
		echo ------------------- %1
		git --git-dir "%1\.git" pull
	)
	if exist %1\.gitmodules (
		echo ------------------- %1 submodules
		cd /d %1 && git submodule foreach git pull origin master
	)
)
:end
pause

