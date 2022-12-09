#! /bin/bash

set -e

#Переменный цвета
RED='\033[0;31m' #Карсный
NC='\033[0m' #Нет цвета

ID=`cat /etc/os-release | grep ^ID=`

if [[ "$ID" = "ID=ubuntu" ]]; then
	clear
	echo "У вас Ubuntu"
	sleep 3
	clear
        chmod +x src-ubuntu.sh
        ./src-ubuntu.sh
elif [[ "$ID" = 'ID="centos"' ]]; then
	clear
	echo "У вас CentOS"
        sleep 3
        clear
        chmod +x src-centos.sh
        ./src-centos.sh
else
        echo "${RED}Версия операционной системы не поддерживается.${NC}"
        exit 1
fi

