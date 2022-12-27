#! /bin/bash

set -e

#Переменный цвета
GREEN='\033[0;32m' #Зеленый
RED='\033[0;31m' #Красный
NC='\033[0m' #Нет цвета

ID=`cat /etc/os-release | grep ^ID=`

if [[ "$ID" = "ID=ubuntu" ]]; then
	clear
	echo -e "${GREEN}У вас Ubuntu${NC}"
	sleep 3
	clear
        chmod +x src-ubuntu.sh
        ./src-ubuntu.sh
elif [[ "$ID" = 'ID="centos"' ]]; then
	clear
	echo -e "${GREEN}У вас CentOS${NC}"
        sleep 3
        clear
        chmod +x src-centos.sh
        ./src-centos.sh
else

        echo -e "${RED}Версия операционной системы не поддерживается.${NC}"
        exit 1
fi
