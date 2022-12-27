#! /bin/bash

set -e

#Переменный цвета
GREEN='\033[0;32m' #Зеленый
RED='\033[0;31m' #Красный
NC='\033[0m' #Нет цвета

clear

echo "${GREEN}Обновим пакеты системы, установим Docker, Docker compose и Airflow${NC}"

sleep 5

echo "${GREEN}Приступим${NC}"
sleep 2

echo "${GREEN}Начинаю обновлять пакеты...${NC}"
sleep 3

sudo yum -y update && sudo yum -y upgrade

echo "${GREEN}(1/3) Пакеты успешно обновлены!${NC}"
sleep 3

echo "${GREEN}Начинаю устанавливать Docker...${NC}"
sleep 3

sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

sudo systemctl start docker

sudo yum -y update

sudo usermod -aG docker $USER

var=`sudo systemctl status docker | grep Active | grep running | wc -l`

if [[ "$var" = 1 ]]; then
        echo "${GREEN}(2/3) Docker успешно установлен!${NC}"
        sleep 3
else
        sleep 3
        echo "${RED}Возникла ошибка во время установки Docker${NC}"
        sudo systemctl status docker
	exit 1
fi

echo "${GREEN}Начинаю устанавливать Airflow...${NC}"
sleep 3

mkdir ~/Docker-compose-Airflow
cd ~/Docker-compose-Airflow

curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.4.3/docker-compose.yaml'

mkdir -p ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)" > .env

sudo systemctl enable docker.service --now
sudo systemctl enable containerd.service --now

if [ $? -eq 0 ]; then
	echo "${GREEN}(3/3) Airflow успешно установлен!${NC}"
	sleep 3
else
        sleep 3
        echo "${REDВозникла ошибка во время установки Airflow${NC}"
        exit 1
fi

hostname=`hostname`

echo "${GREEN}Итого:${NC}"
sleep 2
echo "- успешно обновлены пакеты;"
sleep 2
echo "- установлен Docker;"
sleep 2
echo "- установлен Docker compose;"
sleep 2
echo "- установлен Airflow."
sleep 3

printf "${GREEN}Осталось перезайти в консоль «$hostname».\nДля этого необходимо выполнить в ручную команду «exit» и занаво залогиниться в системе.${NC}\n\n"
sleep 12

echo "${GREEN}Ознакомьтесь с инструкцией.${NC}"
sleep 3

touch README.txt

printf "Для того чтобы запустить AirFlow после перелогина в систему:\n- войдите в директорию ${GREEN}~/Docker-compose-Airflow${NC};\n- введите команду ${GREEN}docker compose up airflow-init${NC};\n- далее ${GREEN}docker compose up${NC}.\n\n"
printf "Для того чтобы запустить AirFlow после перелогина в систему:\n- войдите в директорию ${GREEN}~/Docker-compose-Airflow${NC};\n- введите команду ${GREEN}docker compose up airflow-init${NC};\n- далее ${GREEN}docker compose up${NC}.\n\n" > README.txt
sleep 10

printf "После запуска команды ${GREEN}docker compose up${NC}, будут подняты контейнеры, проверить можно командой ${GREEN}docker ps${NC}.\n"
printf "После запуска команды ${GREEN}docker compose up${NC}, будут подняты контейнеры, проверить можно командой ${GREEN}docker ps${NC}.\n" >> README.txt
sleep 6

printf "Остановить контейнеры можно командой ${GREEN}docker compose stop${NC}.\n"
printf "Остановить контейнеры можно командой ${GREEN}docker compose stop${NC}.\n" >> README.txt
sleep 6

printf "А остановить полностью и удалить контейнеры можно командой ${GREEN}docker compose down${NC}.\n\n"
printf "А остановить полностью и удалить контейнеры можно командой ${GREEN}docker compose down${NC}.\n\n" >> README.txt
sleep 6

printf "Airflow будет доступен по адресу: ${GREEN}http://localhost:8080${NC}\n"
printf "Airflow будет доступен по адресу: ${GREEN}http://localhost:8080${NC}\n" >> README.txt
sleep 6

printf "Пароль ${GREEN}airflow${NC} и логин ${GREEN}airflow${NC}.\n\n"
printf "Пароль ${GREEN}airflow${NC} и логин ${GREEN}airflow${NC}.\n\n" >> README.txt
sleep 6

pwd=`pwd`
echo "Вся эта информация будет в файле ${GREEN}README.txt${NC}, который будет находиться в ${GREEN}$pwd${NC}."
sleep 8

echo -e "${GREEN}Выходим из скрипта через...${NC}"
sleep 3
for i in {5..1}
do
	echo -e "${GREEN}$i...${NC}"
	sleep 1
done

exit 0
