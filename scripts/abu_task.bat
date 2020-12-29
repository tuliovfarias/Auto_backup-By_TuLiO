:@echo off
::CD %~dp0
::CD ..
SET BASE_DIR=C:\GitHub\Auto-backup\

echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Executando script...
call C:\cygwin64\bin\bash.exe -l "%BASE_DIR%\scripts\auto_back-up.sh" > "%BASE_DIR%\log\log_abu.txt" 2>&1

::pause
