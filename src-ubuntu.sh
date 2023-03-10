#! /bin/bash

set -e

#Переменный цвета
GREEN='\033[0;32m' #Зеленый
RED='\033[0;31m' #Красный
NC='\033[0m' #Нет цвета

echo -e "${GREEN}Обновим пакеты системы, установим Docker, Docker compose и Airflow${NC}"

sleep 5

echo -e "${GREEN}Приступим${NC}"
sleep 2

echo -e "${GREEN}Начинаю обновлять пакеты...${NC}"
sleep 3

sudo apt-get update && sudo apt-get upgrade -y
sudo apt -y autoremove

echo -e "${GREEN}(1/3) Пакеты успешно обновлены!${NC}"
sleep 3

echo -e "${GREEN}Начинаю устанавливать Docker...${NC}"
sleep 3

sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get -y update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

sudo usermod -aG docker $USER

sudo apt-get -y update

var=`sudo service docker status | grep Active | grep running | wc -l`

if [[ "$var" = 1 ]]; then
        echo -e "${GREEN}(2/3) Docker успешно установлен!${NC}"
        sleep 3
else
        echo -e "${RED}Возникла ошибка во время установки Docker${NC}"
	sleep 3
	sudo service docker status
        exit 1
fi

echo -e "${GREEN}Начинаю устанавливать Airflow...${NC}"
sleep 3

mkdir ~/Docker-compose-Airflow
cd ~/Docker-compose-Airflow

curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.4.3/docker-compose.yaml'

mkdir -p ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)" > .env

if [ $? -eq 0 ]; then
	echo -e "${GREEN}(3/3) Airflow успешно установлен!${NC}"
	sleep 3
else
        echo -e "${RED}Возникла ошибка во время установки Airflow${NC}"
	sleep 3
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

printf "Осталось перезайти в консоль ${GREEN}$hostname${NC}.\nДля этого необходимо выполнить в ручную команду ${GREEN}exit${NC} и занаво залогиниться в системе.\n\n"
sleep 12

echo -e "${GREEN}Ознакомьтесь с инструкцией.${NC}"
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
