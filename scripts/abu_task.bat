@echo off
CD %~dp0%
CD ..

echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Executando script...
call C:\cygwin64\bin\bash.exe -l "%CD%\scripts\auto_back-up.sh" > "%CD%\log\log_abu.txt" 2>&1

::pause