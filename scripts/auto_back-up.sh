#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" #diretorio do script

cd $DIR; cd ..
FILES_LIST="LISTA_BACKUP.txt"

#NUM_FILES=`cat "$FILES_LIST" | wc -l`
if [ $# -eq 1 ]; then #se tiver algum argumento (quando adiciona arquivos para backup)
	echo "["`date +%d/%m/%Y_%H:%M:%S`"]" "Arquivo(s)/pasta(s) adicionado(s) para Backup"
	sed -i $'s/\r$//' "$FILES_LIST" # DOS to Unix
	cat "$FILES_LIST" | while read -r LINE; do
		SOURCE_PATH="`echo "$LINE" | cut -d '>' -f1`"
		TARGET_DIR="`echo "$LINE" | cut -d '>' -f2`"
		echo " $LINE"
		SOURCE_DRIVE="`echo "$SOURCE_PATH" | sed 's/:.*//'`" #qual disco está o arquivo/pasta
		TARGET_DRIVE="`echo "$TARGET_DIR" | sed 's/:.*//'`"  #para qual disco será copiado
		CYG_USER_PATH=`cygpath "$1/$FILES_LIST"`
		echo "$LINE<SOURCE" >> $SOURCE_DRIVE:/$FILES_LIST #copia a linha na lista no drive da origem
		echo "$LINE<TARGET" >> $TARGET_DRIVE:/$FILES_LIST #copia a linha na lista no drive de destino
	done
	rm -rf $FILES_LIST
fi

#LISTA TEMPORÁRIA COM LETRAS DOS DISCOS QUE ESTÃO CONFIGURADOS NO BACKUP (ORIGEM OU DESTINO)
DRIVERS_LIST=`df | cut -d":" -f1 | tail -n +2`
for DRIVE in $DRIVERS_LIST; do
	if [ -e `cygpath $DRIVE:/$FILES_LIST` ]; then
		DRIVERS_LIST_BU+=( $DRIVE )
	fi
done

echo "["`date +%d/%m/%Y_%H:%M:%S`"]" "Iniciando backup de arquivo(s)/pasta(s)"
#MESMO SE A LETRA DO DISCO TIVER MUDADO (DISCOS REMOVÍVEIS), FARÁ O BACKUP CORRETAMENTE
for DRIVE1 in "${DRIVERS_LIST_BU[@]}";do
	for DRIVE2 in "${DRIVERS_LIST_BU[@]}"; do
		echo "$DRIVE1" ------------------------ "$DRIVE2"
		cat "$DRIVE1:/$FILES_LIST" | while read -r "LINE1"; do
			#echo ---LINE1: "$LINE1"
			TAG1=`echo "${LINE1}" | cut -d'<' -f2`
			LINE1=`echo "${LINE1}" | cut -d'<' -f1`
			cat "$DRIVE2:/$FILES_LIST" | while read -r "LINE2"; do
				#echo ---LINE2: "$LINE2"
				TAG2=`echo "${LINE2}" | cut -d'<' -f2`
				LINE2=`echo "${LINE2}" | cut -d'<' -f1`
				if [[ "${LINE1}" == "${LINE2}" && "$TAG1" == *"SOURCE"* && "$TAG2" == *"TARGET"* ]]; then
					SOURCE_PATH="$DRIVE1`echo $LINE1 | cut -d'>' -f1 | sed 's/.*:/:/'`" 
					TARGET_DIR="$DRIVE2`echo $LINE1 | cut -d'>' -f2 | sed 's/.*:/:/'`" 
					echo -Copying: "${LINE1}"
					rsync -az "`cygpath -u "${SOURCE_PATH}"`" "`cygpath -u "${TARGET_DIR}"`"
				fi
			done
		done
	done
done
rm -rf $DRIVERS_LIST_BU
#sed -i $'s/$/\r/' "$FILES_LIST" # Unix to DOS
echo -e "["`date +%d/%m/%Y_%H:%M:%S`"]" "Terminou backup dos arquivos\n"