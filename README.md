# Auto-backup v1.0 - By TuLiO
 Backup automático de arquivos no Windows.
 
 Vídeo demonstrativo: https://youtu.be/RmRL_FgeChg

**Instalação:**

- Executar *Install.bat* **como Administrador** (necessário para configurar *Backup.bat* no menu contexto "Enviar para").
- Caso não tenha o python instalado no Windows, intalar última versão do site: https://www.python.org/downloads/windows/

**Utilização:**
- Selecionar os arquivos ou pastas que deseja manter cópia automática, clicar com o botão direito >> Enviar para >> _Backup.bat.

- No prompt aberto, insira o caminho para onde deseja copiar os arquivos e aperte ENTER.

- O arquivo será constantemente atualizado no destino, mesmo se for um dispositivo móvel.

 Por exemplo, se a origem for uma pasta contendo fotos e o destino for um HD externo, ao adicionar fotos na pasta original, serão automaticamente copiadas para o HD externo.
 
 A lista com as origens e destinos encontra-se em *Auto-backup\lista\backup_list.txt*
 Para excluir backups automáticos, apenas deletar as linhas correspondentes (posteriormente, será desenvolvida uma para fazer isso)
