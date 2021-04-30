#%%
##Limpar variáveis
#from IPython import get_ipython
#get_ipython().magic('reset -sf')

import win32api
import sys
import os
import time
from pathlib import Path
import pandas as pd
import datetime
from datetime import timedelta

BASE_DIR=os.path.dirname(os.path.dirname(__file__))
LIST_DIR=os.path.join(BASE_DIR,'list')
LAST_ID=os.path.join(LIST_DIR,'last_id.txt')
DRIVER_ID = "\\driver_id.txt"
BU_LIST_PATH=os.path.join(LIST_DIR,'backup_list.txt')

print(time.strftime("%Y-%m-%d %H:%M:%S"),"Starting...")

#sys.argv.pop(1) #remove segundo elemento da lista de argumentos (path pra este script)
dest_bu=sys.argv[1]
origin_dir_bu=os.path.dirname(sys.argv[2])
paths_bu=sys.argv[2:]

dest_letter=dest_bu.split('\\')[0]
origin_letter=origin_dir_bu.split('\\')[0]
base_letter=BASE_DIR.split('\\')[0]

if dest_letter==base_letter:
    driver_id_dest_path=BU_LIST_PATH #para não dar erro de permissão
else:
    driver_id_dest_path=os.path.join(dest_letter,DRIVER_ID)
if dest_letter==base_letter:  
    driver_id_origin_path=BU_LIST_PATH #para não dar erro de permissão
else:
    driver_id_origin_path=os.path.join(origin_letter,DRIVER_ID)

print('driver_id_dest_path:',driver_id_dest_path)
print('driver_id_origin_path:',driver_id_origin_path)

if not os.path.isfile(LAST_ID):
    with open(LAST_ID, 'w') as fid:
        fid.write("0") #caso primeiro back-up, escreve 0 na lista de ID

if not os.path.isfile(driver_id_dest_path):
    with open(LAST_ID, 'r+') as fid:
        id_dest=int(fid.read())+1 #soma 1 no last_id (id do driver)
        fid.seek(0)
        fid.truncate() #apaga valor atual
        fid.write(str(id_dest)) #coloca o valor incrementado  
    with open(driver_id_dest_path, 'w') as fd:
        print(id_dest, file=fd)
else: 
    with open(driver_id_dest_path, 'r') as fd:
        id_dest=int(fd.readline().strip()) #Caso já exista id configurado para o driver, apenas lê       
if not os.path.isfile(driver_id_origin_path):
    with open(LAST_ID, 'r+') as fid:
        id_origin=int(fid.read())+1 #soma 1 no id do driver
        fid.seek(0)
        fid.truncate() #apaga valor atual
        fid.write(str(id_origin)) #coloca o valor incrementado  
    with open(driver_id_origin_path, 'w') as fo:
        print(id_origin, file=fo)
else: 
    with open(driver_id_origin_path, 'r') as fo:
        id_origin=int(fo.readline().strip()) #Caso já exista id configurado para o driver, apenas lê
     
with open(BU_LIST_PATH, 'a') as f:
    line='      '
    for path_bu in paths_bu:
        if path_bu==paths_bu[-1]:
            line+=os.path.basename(path_bu)
        else:
            line+=os.path.basename(path_bu)+','
    print('----->ORIGIN>'+id_origin+'>'+origin_dir_bu+'>DEST>'+id_dest+'>'+dest_bu, file=f)
    print(line, file=f) #f.write(line)

# %%
