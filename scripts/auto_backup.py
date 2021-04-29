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

LAST_ID=os.path.join(os.path.dirname(__file__),'last_id.txt')
BU_LIST = "\\bu_list.txt"

print(time.strftime("%Y-%m-%d %H:%M:%S"),"Starting...")

#sys.argv.pop(1) #remove segundo elemento da lista de argumentos (path pra este script)
dest_bu=sys.argv[1]
dest_letter=dest_bu.split('\\')[0]
origin_dir_bu=os.path.dirname(sys.argv[2])
origin_letter=origin_dir_bu.split('\\')[0]
paths_bu=sys.argv[2:]

bu_list_path_dest=os.path.join(dest_letter,BU_LIST)
print('bu_list_path1:',bu_list_path_dest)
bu_list_path_origin=os.path.join(origin_letter,BU_LIST)
print('bu_list_path2:',bu_list_path_origin)

if not os.path.isfile(LAST_ID):
    with open(LAST_ID, 'w') as fid:
        fid.write("0") #caso primeiro back-up, escreve 0 na lista de ID

with open(LAST_ID, 'r+') as fid:
    if not os.path.isfile(bu_list_path_dest):
        id=int(fid.read())+1 #soma 1 no id do driver
        fid.seek(0)
        fid.truncate() #apaga valor atual
        fid.write(str(id)) #coloca o valor incrementado  
        with open(bu_list_path_dest, 'w') as fd:
            print('Driver-ID:',id, file=fd)        
    if not os.path.isfile(bu_list_path_origin):
        id=id+1 #soma 1 no id do driver
        fid.seek(0)
        fid.truncate() #apaga valor atual
        fid.write(str(id)) #coloca o valor incrementado  
        with open(bu_list_path_origin, 'w') as fo:
            print('Driver-ID:',id, file=fo)
     
with open(bu_list_path_dest, 'a') as fd, open(bu_list_path_origin, 'a') as fo:
    line='      '
    for path_bu in paths_bu:
        if path_bu==paths_bu[-1]:
            line+=os.path.basename(path_bu)
        else:
            line+=os.path.basename(path_bu)+','
    for f in [fd,fo]:
        print('----->'+origin_dir_bu+'>'+dest_bu, file=f)
        print(line, file=f) #f.write(line)
        if dest_letter==origin_letter:
            break #para evitar de escrever 2 vezes no mesmo arquivo

