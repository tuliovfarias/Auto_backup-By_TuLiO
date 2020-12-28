@echo off
:: Diretório base é a pasta onde o script está
set BASE_DIR=%~dp0

echo ----------------By TuLiO-------------------
echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Instalando Auto-backup...
echo -Inserindo atalho _Backup.bat no menu contexto "Enviar para"...
::Insere menu contexto "Enviar para"
::mklink "%BASE_DIR%\_Backup.bat" "%BASE_DIR%\scripts\_Backup.bat"
::move "%BASE_DIR%\_Backup.bat" "%APPDATA%\Microsoft\Windows\SendTo"
::cacls %APPDATA%\Microsoft\Windows\SendTo /E /P %USERNAME%:F
mklink "%APPDATA%\Microsoft\Windows\SendTo" "%BASE_DIR%\scripts\_Backup.bat"
::xcopy "%BASE_DIR%\scripts\_Backup.bat" "%APPDATA%\Microsoft\Windows\SendTo"
::net user Administrador /active:yes
echo -Agendando tarefa "Auto_backup"
::Cria tarefa no Task Scheduler
SCHTASKS /Create /RU SYSTEM /SC MINUTE /MO 5 /TN Auto_backup /TR "'%~dp0%scripts\abu_task.bat'"
echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Instalado!
pause