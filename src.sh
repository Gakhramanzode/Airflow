#! /bin/bash

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
        echo "Версия операционной системы не поддерживается."
        exit 0
fi
