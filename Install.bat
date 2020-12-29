@echo off
:: Diretório base é a pasta onde o script está
set BASE_DIR=%~dp0
set SCRIPT_BU_PATH=%BASE_DIR%scripts\_Backup.bat
set SCRIPT_ABU_PATH=%BASE_DIR%scripts\abu_task.bat
set LIST_PATH=%BASE_DIR%listas\LISTA_BACKUP.txt

echo ----------------By TuLiO-------------------
echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Instalando Auto-backup...
del %LIST_PATH%
copy NUL %LIST_PATH%
echo -Inserindo atalho _Backup.bat no menu contexto "Enviar para"...
::Insere menu contexto "Enviar para"
SET COMMAND="(Get-Content %SCRIPT_BU_PATH%) | %%{$_ -replace 'BASE_DIR=.*','BASE_DIR=%BASE_DIR%'} | Set-Content -Path %SCRIPT_BU_PATH%"
@PowerShell %COMMAND%
SET COMMAND="(Get-Content %SCRIPT_ABU_PATH%) | %%{$_ -replace 'BASE_DIR=.*','BASE_DIR=%BASE_DIR%'} | Set-Content -Path %SCRIPT_ABU_PATH%"
@PowerShell %COMMAND%
::call C:\cygwin64\bin\bash.exe -l -c "sed 's/CD "".*""/CD "%SCRIPT_BU_PATH%"/' ""%SCRIPT_BU_PATH%"""
xcopy "%SCRIPT_BU_PATH%" "%APPDATA%\Microsoft\Windows\SendTo"
::net user Administrador /active:yes
echo -Agendando tarefa "Auto_backup"
::Cria tarefa no Task Scheduler
SCHTASKS /Create /RU SYSTEM /SC MINUTE /MO 5 /TN Auto_backup /TR "'%~dp0%scripts\abu_task.bat'"
echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Instalado!

PAUSE