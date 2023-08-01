#!/bin/bash

# coleta_status_server_linux.sh
# Script simples para coletar os principais pontos para avaliar performance

# USO:
# Se vc tiver curl instalado no servidor:
# curl https://raw.githubusercontent.com/ruan-oliveira/scripts/main/coleta_status_server_linux.sh | bash
# Se vc tiver o wget:
#  wget -O- -q https://raw.githubusercontent.com/ruan-oliveira/scripts/main/coleta_status_server_linux.sh | bash


# FUTURO:
# Incluir outros coletores e permitir que o usuário escolha o que deseja coletar
# Permitir que o usuário set o intervalo de tempo
# Incluir outros tipos de saída de OUTPUT, as principais idéias são:
#    HTML, CSV, etc..

trap control_c SIGINT

#Arquivo de log
LOG="coleta_performance-`hostname -f`-`/bin/date +"%m-%d-%y_%T"`.log"

function control_c {
  clear
  echo -en "\n*** COLETA FINALIZADA***\n"
  echo "Arquivo de log: $LOG"
  exit $?
}

function main {
    echo -e "\n###### INICIO ######" >> $LOG
    while true
    do
        clear
            echo "#################################" 
                echo `/bin/date +"%m-%d-%y_%T"` >> $LOG
        echo -e "\n\n" >> $LOG
            date                                      
            echo "#################################"   
        coleta 
        sleep 5
    done
        echo -e "\n###### FIM ######" >> $LOG
}


function coleta {

    echo -en '\n\E[47;31m'"\033[1m"
    echo -e "#####################"
    echo -e "# CONEXOES - RESUMO #" | tee -a $LOG
    echo -e "#####################\033[0m"
    netstat -tan | grep tcp | awk '{print $6}' | sort | uniq -c | sort -nr -k 1,1 | tee -a $LOG
    echo -e "\n\n" >> $LOG

    echo -en '\n\E[47;31m'"\033[1m"
    echo -e "#############"
    echo -e "#  MEMÓRIA  #"| tee -a $LOG
    echo -e "#############\033[0m"
    free -m | tee -a $LOG
    echo -e "\n\n" >> $LOG

    echo -en '\n\E[47;31m'"\033[1m" 
    echo -e "########################"
    echo -e "# TOP 10 de uso de RAM #" | tee -a $LOG
    echo -e "########################\033[0m"
    ps -A --sort -rss -o comm,pmem | head -n 11 | tee -a $LOG
    echo -e "\n\n" >> $LOG


    echo -en '\n\E[47;31m'"\033[1m"
        echo -e "########"
        echo -e "# LOAD #" | tee -a $LOG
        echo -e "########\033[0m"
        uptime | cut -d, -f4-6 | tee -a $LOG
    echo -e "\n\n" >> $LOG

    echo -en '\n\E[47;31m'"\033[1m"
        echo -e "############"
        echo -e "# CPU / IO #" | tee -a $LOG
        echo -e "############\033[0m"
        iostat | tee -a $LOG
}

echo "Eu amo a natalia"


main
