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
	if [ $# -e 1 ]; then #se tiver algum argumento (primeira vez que for executado)
		SOURCE_DRIVE="`echo "$SOURCE_PATH" | sed 's/:.*//'`" #qual disco está o arquivo/pasta
		TARGET_DRIVE="`echo "$TARGET_DIR" | sed 's/:.*//'`"  #para qual disco será copiado
		if [ $SOURCE_DRIVE -ne $1 && $TARGET_DRIVE -ne $1 ]; then #se a origem e o destino não forem o drive do usuário
			echo "$LINE" >> $SOURCE_DRIVE/$FILES_LIST #copia a linha na lista no drive da origem
			echo "$LINE" >> $TARGET_DRIVE/$FILES_LIST #copia a linha na lista no drive de destino
			sed 's/*//' $FILES_LIST #apaga linha da lista do drive atual
		fi
		if [ $SOURCE_DRIVE -ne $1 && $TARGET_DRIVE -e $1 ]; then #se a origem não for o drive do usuário
			echo "$LINE" >> $SOURCE_DRIVE/$FILES_LIST #copia a linha na lista no drive da origem
			sed 's/*//' $FILES_LIST #apaga linha da lista do drive atual
		fi
		if [ $SOURCE_DRIVE -e $1 && $TARGET_DRIVE -ne $1 ]; then #se o destino não for o drive do usuário
			echo "$LINE" >> $TARGET_DRIVE/$FILES_LIST #copia a linha na lista no drive de destino
			sed 's/*//' $FILES_LIST #apaga linha da lista do drive atual
		fi
		#(Se tanto a origem quanto o destino forem iguais, mantém na lista de origem (driver do usuário))
	fi
	rsync -az "`cygpath -u "$SOURCE_PATH"`" "`cygpath -u "$TARGET_DIR"`"
done
sed -i $'s/$/\r/' "$FILES_LIST" # Unix to DOS
echo -e "["`date +%d/%m/%Y_%H:%M:%S`"]" "Terminou backup dos arquivos\n"