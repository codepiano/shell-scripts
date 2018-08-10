@echo off
setlocal enabledelayedexpansion
set tmp=%~dp0\tmp
echo Store image Temporary directory %tmp%

for %%i in ( %tmp% ) do  if not exist %%i md %%i

for /f  %%i in ('dir /b %localappdata%\Packages\Microsoft.Windows.ContentDeliveryManager_*') do (
    set res=%localappdata%\Packages\%%i\LocalState\Assets
    for /f "delims=" %%b in ('dir /a-d /b /s !res!') do (
       if not exist %tmp%/%%~nb.jpg if %%~zb GTR 409600 xcopy %%b %tmp%
    )
)
ren %tmp%\* *.jpg
echo Select Picture
start /w %tmp%
exit
