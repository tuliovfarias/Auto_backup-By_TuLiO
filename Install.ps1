#Executa como administrador
param([switch]$Elevated)
function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Test-Admin) -eq $false){
    if ($elevated){exit} 
    else {Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))}
}

# Diretório base é a pasta onde o script está
$BASE_DIR=$PSScriptRoot
$SCRIPT_PATH="$BASE_DIR\scripts\_Backup2.bat"
function Get-TimeStamp {    
    return "[{0:dd/MM/yyyy} {0:HH:mm:ss}]" -f (Get-Date)   
}

echo "----------------By TuLiO-------------------"
echo "$(Get-TimeStamp) Instalando Auto-backup..."
echo "-Inserindo atalho _Backup.bat no menu contexto 'Enviar para'..."

(Get-Content $SCRIPT_PATH) |  %{$_ -replace 'CD \".*\"',"CD `"$BASE_DIR`""} | Set-Content $SCRIPT_PATH
Copy-Item "$SCRIPT_PATH" -Destination "$env:APPDATA\Microsoft\Windows\SendTo"

#net user Administrador /active:yes
echo "-Agendando tarefa 'Auto_backup'"
#Cria tarefa no Task Scheduler
$taskName = "Auto_backup"
$description = "Back-up files"
$taskTrigger = New-ScheduledTaskTrigger -Daily -At 3PM
$taskAction = New-ScheduledTaskAction `
    -Execute 'cmd.exe' `
    -Argument '-File $BASE_DIR\scripts\abu_task.bat'
Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description `
    -User 'SYSTEM'

echo "$(Get-TimeStamp) Instalado!"
Read-Host -Prompt "Press any key to continue"