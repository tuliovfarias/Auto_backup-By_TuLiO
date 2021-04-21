@echo off
::UTF-8
@CHCP 65001 >nul 

:restart
::CD %~dp0%
cls

set BASE_DIR=do not change
set LISTA_BU_DIR=%BASE_DIR%\LISTA_BACKUP.txt
set SCRIPT_ABU=%BASE_DIR%\scripts\auto_back-up.sh
set LISTA_DRIVERS=%BASE_DIR%\drivers.txt

if not exist %LISTA_DRIVERS% echo 1 >> %LISTA_DRIVERS%
if not exist %LISTA_BU_DIR% type %LISTA_DRIVERS >> %LISTA_BU_DIR%

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
call %SystemDrive%\cygwin64\bin\bash.exe -l %SCRIPT_ABU% %userprofile%
echo [%date:~0,2%-%date:~3,2%-%date:~6,10% %time:~0,8%] Finalizado!
echo.

pause
::exit
