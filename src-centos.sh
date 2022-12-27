#! /bin/bash

set -e

#Переменный цвета
GREEN='\033[0;32m' #Зеленый
RED='\033[0;31m' #Красный
NC='\033[0m' #Нет цвета

clear

echo -e "${GREEN}Обновим пакеты системы, установим Docker, Docker compose и Airflow${NC}"

sleep 5

echo -e "${GREEN}Приступим${NC}"
sleep 2

echo -e "${GREEN}Начинаю обновлять пакеты...${NC}"
sleep 3

sudo yum -y update && sudo yum -y upgrade

echo -e "${GREEN}(1/3) Пакеты успешно обновлены!${NC}"
sleep 3

echo -e "${GREEN}Начинаю устанавливать Docker...${NC}"
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
        echo -e "${GREEN}(2/3) Docker успешно установлен!${NC}"
        sleep 3
else
        sleep 3
        echo -e "${RED}Возникла ошибка во время установки Docker${NC}"
        sudo systemctl status docker
	exit 1
fi

echo -e "${GREEN}Начинаю устанавливать Airflow...${NC}"
sleep 3

mkdir ~/Docker-compose-Airflow
cd ~/Docker-compose-Airflow

curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.4.3/docker-compose.yaml'

mkdir -p ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)" > .env

sudo systemctl enable docker.service --now
sudo systemctl enable containerd.service --now

if [ $? -eq 0 ]; then
	echo -e "${GREEN}(3/3) Airflow успешно установлен!${NC}"
	sleep 3
else
        sleep 3
        echo -e "${REDВозникла ошибка во время установки Airflow${NC}"
        exit 1
fi

hostname=`hostname`

echo -e "${GREEN}Итого:${NC}"
sleep 2
echo "- успешно обновлены пакеты;"
sleep 2
echo "- установлен Docker;"
sleep 2
echo "- установлен Docker compose;"
sleep 2
echo "- установлен Airflow."
sleep 3

printf -e "${GREEN}Осталось перезайти в консоль «$hostname».\nДля этого необходимо выполнить в ручную команду «exit» и занаво залогиниться в системе.${NC}\n\n"
sleep 12

echo -e "${GREEN}Ознакомьтесь с инструкцией.${NC}"
sleep 3

touch README.txt

printf -e "Для того чтобы запустить AirFlow после перелогина в систему:\n- войдите в директорию ${GREEN}~/Docker-compose-Airflow${NC};\n- введите команду ${GREEN}docker compose up airflow-init${NC};\n- далее ${GREEN}docker compose up${NC}.\n\n"
printf -e "Для того чтобы запустить AirFlow после перелогина в систему:\n- войдите в директорию ${GREEN}~/Docker-compose-Airflow${NC};\n- введите команду ${GREEN}docker compose up airflow-init${NC};\n- далее ${GREEN}docker compose up${NC}.\n\n" > README.txt
sleep 10

printf -e "После запуска команды ${GREEN}docker compose up${NC}, будут подняты контейнеры, проверить можно командой ${GREEN}docker ps${NC}.\n"
printf -e "После запуска команды ${GREEN}docker compose up${NC}, будут подняты контейнеры, проверить можно командой ${GREEN}docker ps${NC}.\n" >> README.txt
sleep 6

printf -e "Остановить контейнеры можно командой ${GREEN}docker compose stop${NC}.\n"
printf -e "Остановить контейнеры можно командой ${GREEN}docker compose stop${NC}.\n" >> README.txt
sleep 6

printf -e "А остановить полностью и удалить контейнеры можно командой ${GREEN}docker compose down${NC}.\n\n"
printf -e "А остановить полностью и удалить контейнеры можно командой ${GREEN}docker compose down${NC}.\n\n" >> README.txt
sleep 6

printf -e "Airflow будет доступен по адресу: ${GREEN}http://localhost:8080${NC}\n"
printf -e "Airflow будет доступен по адресу: ${GREEN}http://localhost:8080${NC}\n" >> README.txt
sleep 6

printf -e "Пароль ${GREEN}airflow${NC} и логин ${GREEN}airflow${NC}.\n\n"
printf -e "Пароль ${GREEN}airflow${NC} и логин ${GREEN}airflow${NC}.\n\n" >> README.txt
sleep 6

pwd=`pwd`
echo -e "Вся эта информация будет в файле ${GREEN}README.txt${NC}, который будет находиться в ${GREEN}$pwd${NC}."
sleep 8

echo -e "${GREEN}Выходим из скрипта через...${NC}"
sleep 3
for i in {5..1}
do
	echo -e "${GREEN}$i...${NC}"
	sleep 1
done

exit 0
