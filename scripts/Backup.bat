@echo off
::UTF-8
@CHCP 65001 >nul 

:restart
::CD %~dp0%
cls

set BASE_DIR=do not change
set LISTA_BU_DIR=%BASE_DIR%\LISTA_BACKUP.txt
set SCRIPT_ABU=%BASE_DIR%\scripts\auto_back-up.sh

echo [%date:~0,2%-%date:~3,2%-%date:~6,10% %time:~0,8%] Adicionar arquivo/pasta para lista de backup
::start shell:mycomputerfolder
:READ_PWA_PATH
echo -Origem: && for %%I IN (%*) DO echo %%~I
set /p DIR_OUT= -Destino: 
::%SystemRoot%\explorer.exe "%DIR_OUT%"
::dir
set OP=s
set /p OP= -Confirma? (s/n)
if %op% equ n goto restart
for %%I IN (%*) DO echo %%~I^>%DIR_OUT%\ >> %LISTA_BU_DIR%
call C:\cygwin64\bin\bash.exe -l %SCRIPT_ABU%
echo [%date:~0,2%-%date:~3,2%-%date:~6,10% %time:~0,8%] Finalizado!
echo.

pause
::exit
