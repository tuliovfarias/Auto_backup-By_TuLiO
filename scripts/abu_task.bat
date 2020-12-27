@echo off

echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Executando script...
call C:\cygwin64\bin\bash.exe -l "D:\Google Drive\Auto_backup\scripts\auto_back-up.sh" > "D:\Google Drive\Auto_backup\log\log_abu.txt" 2>&1

::pause