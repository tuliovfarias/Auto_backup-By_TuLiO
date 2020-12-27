@echo off
::Insere menu contexto "Enviar para"
xcopy "%CD%\scripts\_Backup.bat" "%APPDATA%\Microsoft\Windows\SendTo"
::Cria tarefa no Task Scheduler
SCHTASKS /Create /RU SYSTEM /SC MINUTE /MO 5 /TN Auto_backup /TR "'D:\Google Drive\Auto_backup\scripts\abu_task.bat'"
echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Instalado!
pause