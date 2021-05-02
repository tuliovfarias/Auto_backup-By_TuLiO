#%%
##Limpar variáveis
#from IPython import get_ipython
#get_ipython().magic('reset -sf')

import win32api
import sys
import os
import time
import shutil
import subprocess

#for i in range(0,len(sys.argv)):
#    print(sys.argv[i])

BASE_DIR=os.path.dirname(os.path.dirname(__file__))
LIST_DIR=os.path.join(BASE_DIR,'list\\')
LAST_ID=os.path.join(LIST_DIR,'last_id.txt')
DRIVER_ID = "\\driver_id.txt"
BU_LIST_PATH=os.path.join(LIST_DIR,'backup_list.txt')


def cadastro():
    print('['+time.strftime("%d-%m-%Y %H:%M:%S")+']',"Iniciando cadastro para back-up...")
    #sys.argv.pop(1) #remove segundo elemento da lista de argumentos (path pra este script)
    paths_bu=[]
    for i in range(3,len(sys.argv)):
        paths_bu.append(sys.argv[i].strip("'"))
    print('paths_bu:',paths_bu)
    script_path=sys.argv[1]
    dest_bu=sys.argv[2]
    origin_dir_bu=os.path.dirname(paths_bu[0])

    win_letter=script_path.split('\\')[0] #letra do disco do windows
    dest_letter=dest_bu.split('\\')[0]
    origin_letter=origin_dir_bu.split('\\')[0]
    base_letter=BASE_DIR.split('\\')[0]

    if dest_letter!=win_letter:
        driver_id_dest_path=os.path.join(dest_letter,'\\',DRIVER_ID)
    if origin_letter!=win_letter:  
        driver_id_origin_path=os.path.join(origin_letter,'\\',DRIVER_ID)

    #print('driver_id_dest_path:',driver_id_dest_path)
    #print('driver_id_origin_path:',driver_id_origin_path)

    if not os.path.isfile(LAST_ID):
        with open(LAST_ID, 'w') as fid:
            fid.write("0") #caso primeiro back-up, escreve 0 na lista de ID

    #------Cadastra ID do driver ou lê caso já estiver cadastrado (ID vale 0 caso seja disco do windows):#######
    if (dest_letter!=win_letter):
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
    else:
        id_dest=0
    if (origin_letter!=win_letter):         
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
    else:
        id_origin=0

    with open(BU_LIST_PATH, 'a') as bu_list:
        line='      '
        for path_bu in paths_bu:
            if path_bu==paths_bu[-1]:
                line+=os.path.basename(path_bu)
            else:
                line+=os.path.basename(path_bu)+','
        print('+---->ORIGIN>'+str(id_origin)+'>'+origin_dir_bu+'>DEST>'+str(id_dest)+'>'+dest_bu, file=bu_list)
        print(line, file=bu_list) #bu_list.write(line)
    print('['+time.strftime("%d-%m-%Y %H:%M:%S")+']','Arquivos cadastrados para back-up!') #bu_list.write(line)

def get_driver_letter(id_origin,id_dest):
    #------Retorna letra dos drivers de acordo com os IDs:########################################################
    origin_disk_letter=""
    dest_disk_letter=""
    base_letter=BASE_DIR.split('\\')[0]
    if (id_origin=='0'):
        origin_disk_letter=base_letter
    if (id_dest=='0'):
        dest_disk_letter=base_letter
    disks=win32api.GetLogicalDriveStrings()[:-1].split('\x00') #retorna vetor com letra:\\ de todos os discos
    for disk in disks:
        file_driver_id=os.path.join(disk,DRIVER_ID)
        try:
            with open(file_driver_id, 'r') as fid:
                disk_id=fid.readline().strip()
                if (id_origin==disk_id):
                    origin_disk_letter=disk
                if (id_dest==disk_id):
                    dest_disk_letter=disk
        except:
            pass                
        if ((origin_disk_letter!="") & (dest_disk_letter!="")):
            return origin_disk_letter,dest_disk_letter

def backup():
    #------Backup de arquivos:####################################################################################
    print('['+time.strftime("%d-%m-%Y %H:%M:%S")+']','Iniciando back-up dos arquivos...')
    with open(BU_LIST_PATH, 'r') as bu_list:
        for line in bu_list:
            if line[0]=='+':
                line_split=line.split('>')
                origin_id=line_split[2]
                origin_folder=line_split[3]
                dest_id=line_split[5]
                dest_folder=line_split[6].strip()
                dest_driver,origin_driver=get_driver_letter(origin_id,dest_id)
                dest_path=os.path.join(dest_driver,dest_folder)
                print('+----Destino:',dest_folder)
            else:
                line_split=line.strip(" ").split(',')
                for file_bu in line_split:
                    file_path_bu=os.path.join(origin_driver,origin_folder,file_bu.strip())
                    try:
                        shutil.copy(file_path_bu, dest_path)  
                    except:
                        shutil.copytree(file_path_bu, dest_path+"\\"+file_bu.strip(), dirs_exist_ok=True)
                        #subprocess.call(['robocopy ', file_path_bu, dest_path, '/mir' ])                 
                    print('   Copiado:',file_path_bu)
    print('['+time.strftime("%d-%m-%Y %H:%M:%S")+']','Finalizou back-up dos arquivos!')

def main():
    if (len(sys.argv)>1):
        cadastro()
        backup()
    else:
        backup()

if __name__ == '__main__':
   main()
# %%
