@echo off

set PYTHON3=d:\devel\Python34\python.exe
set LJD=d:\devel_src\ljd\main.py


echo %time% > time.log
for /r %%i in (*.luac) do (
    echo %%i
    "%PYTHON3%" "%LJD%" "%%i" > "%%~dpni"
)
echo %time% >> time.log

:eof
pause
