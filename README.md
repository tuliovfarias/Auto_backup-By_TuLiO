# Auto-backup v2.0 - By TuLiO
 Cria backup automático de arquivos no Windows 10.

**Pré requisito:**

- Cygwin instalado

**Instalação:**

- Caso cygwin não estiver instalado em *%SystemDrive%\cygwin64\\*, alterar este caminho nos scripts *Backup.bat* e *auto_back-up.sh*
- Executar *Install.bat* **como Administrador** (necessário para configurar *Backup.bat* no menu contexto "Enviar para").
- Clicar com botão direito em *%SystemDrive%/cygwin64/bin/bash.exe*, Propriedades >> Segurança e marcar para executar como admin. (Necessário para criar lista de backup no diretório raiz do disco).

**Utilização:**
- Selecionar os arquivos ou pastas que deseja manter cópia automática, clicar com o botão direito >> Enviar para >> _Backup.bat.

- No prompt aberto, insira o caminho para onde deseja copiar os arquivos.

- Confirme com ENTER. O arquivo será constantemente atualizado no destino, mesmo se for um dispositivel móvel.

 Por exemplo, se a origem for uma pasta contendo fotos e o destino for um HD externo, ao adicionar fotos na pasta original, serão automaticamente copiadas para o HD externo.
 
 A lista com as origens e destinos encontra-se na raiz de cada disco, em *LISTA_BACKUP.txt*