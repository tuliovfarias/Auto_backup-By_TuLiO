@echo off
:: Diretório base é a pasta onde o script está
set BASE_DIR=%~dp0
set SCRIPT_BU_PATH=%BASE_DIR%scripts\Backup.bat
set SCRIPT_BU_TEMP_PATH=%BASE_DIR%\_Backup.bat
set SCRIPT_ABU_PATH=%BASE_DIR%scripts\abu_task.bat
set LIST_PATH=%BASE_DIR%list\backup_list.txt

echo ----------------Auto Backup By TuLiO-------------------
echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Instalando Auto-backup...
del %LIST_PATH% >nul 2>&1
::copy NUL %LIST_PATH% >nul 2>&1
echo -Inserindo atalho _Backup.bat no menu contexto "Enviar para"...
::Insere menu contexto "Enviar para"
::call C:\cygwin64\bin\bash.exe -l -c "sed 's/CD "".*""/CD "%SCRIPT_BU_PATH%"/' ""%SCRIPT_BU_PATH%"""
SET COMMAND="(Get-Content %SCRIPT_BU_PATH%) | %%{$_ -replace 'BASE_DIR=.*','BASE_DIR=%BASE_DIR%'} | Set-Content -Path %SCRIPT_BU_TEMP_PATH%"
@PowerShell %COMMAND%
move "%SCRIPT_BU_TEMP_PATH%" "%APPDATA%\Microsoft\Windows\SendTo"
::net user Administrador /active:yes
echo -Agendanda tarefa "Auto_backup"
::Cria tarefa no Task Scheduler
SCHTASKS /Create /RU SYSTEM /SC MINUTE /MO 1 /TN Auto_backup /TR "'%~dp0%scripts\abu_task.bat'"
::SCHTASKS /Create /SC MINUTE /MO 1 /TN Auto_backup /TR "'%~dp0%scripts\abu_task.bat'"
echo [%date:~6,10%-%date:~3,2%-%date:~0,2% %time:~0,8%] Instalado!

PAUSE