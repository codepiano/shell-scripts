@echo off
set tmp=%~dp0\screensaver
set base=(dir /b %localappdata%\Packages\Microsoft.Windows.ContentDeliveryManager_*)
set res=%res%\LocalState\Assets
echo Store image Temporary directory %tmp%

for %%i in ( %tmp% ) do  if not exist %%i md %%i

for /f "delims=" %%b in ('dir /a-d /b /s %res%') do (   
    if not exist %tmp%/%%~nb.jpg if %%~zb GTR 409600 xcopy %%b %tmp%
)

ren %tmp%\* *.jpg
echo Select Picture
start /w %tmp%
exit
