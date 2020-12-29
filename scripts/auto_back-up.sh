#FILES_LIST=`cygpath -u "D:\Google Drive\Auto_backup\listas\LISTA_BACKUP.txt"`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#echo "diretorio do script" $DIR
cd $DIR; cd ..
FILES_LIST="LISTA_BACKUP.txt"

sed -i $'s/\r$//' "$FILES_LIST" # DOS to Unix
NUM_FILES=`cat "$FILES_LIST" | wc -l`
echo "["`date +%d/%m/%Y_%H:%M:%S`"]" "Iniciando backup de $NUM_FILES arquivo(s)/pasta(s)"
cat "$FILES_LIST" | while read -r LINE; do
	SOURCE_PATH="`echo "$LINE" | cut -d '>' -f1`"
	TARGET_DIR="`echo "$LINE" | cut -d '>' -f2`"
	echo " $LINE"
	rsync -az "`cygpath -u "$SOURCE_PATH"`" "`cygpath -u "$TARGET_DIR"`"
done
sed -i $'s/$/\r/' "$FILES_LIST" # Unix to DOS
echo -e "["`date +%d/%m/%Y_%H:%M:%S`"]" "Terminou backup dos arquivos\n"