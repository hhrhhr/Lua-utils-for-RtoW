@echo off

if exist _big_unp rmdir /s /q _big_unp >nul
mkdir _big_unp

for %%i in (_big\*.*) do (
    echo %%i
    mkdir _big_unp\%%~ni
    lua\lua.exe lua\2-unpack.lua "%%i" "_big_unp\%%~ni"
)

:eof
pause
