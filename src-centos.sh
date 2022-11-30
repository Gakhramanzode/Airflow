#! /bin/bash

set -e

clear

echo "Обновим пакеты системы, установем Docker, Docker compose и Airflow"
sleep 5
clear

echo "Приступим"
sleep 2
clear

echo "Начинаю обновлять пакеты..."
sleep 3 
clear
sleep 1

sudo yum -y update && sudo yum -y upgrade
clear

echo "(1/3) Пакеты успешно обновлены!"
sleep 3
clear

echo "Начинаю устанавливать Docker..."
sleep 3
clear
sleep 1

sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

clear
sleep 1

sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
clear
sleep 1

sudo systemctl start docker
clear
sleep 1

sudo yum -y update

clear
sleep 1

sudo usermod -aG docker $USER
clear
sleep 1

var=`sudo systemctl status docker | grep Active | grep running | wc -l`

if [[ "$var" = 1 ]]
then
        clear
        echo "(2/3) Docker успешно установлен!"
        sleep 3
        clear
else
        sleep 3
        clear
        echo "Возникла ошибка во время установки Docker"
        sudo systemctl status docker	#сразу вывести статус и на этом закончить скрипт
	exit 1
fi

echo "Начинаю устанавливать Airflow..."
sleep 3
clear
sleep 1

mkdir ~/Docker-compose-Airflow
cd ~/Docker-compose-Airflow

curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.4.3/docker-compose.yaml'

mkdir -p ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)" > .env

#я бы добавил
sudo systemctl enable docker.service --now
sudo systemctl enable containerd.service --now

exit 0

hostname=`hostname`
sleep 1

echo "Итого:"
sleep 2
echo "- успешно обновлены пакеты;"
sleep 2
echo "- установлен Docker;"
sleep 2
echo "- установлен Docker compose;"
sleep 2
echo "- установлен Airflow."
sleep 3
clear

echo "Осталось перезайти в консоль $hostname. Для этого необходимо выполнить в ручную команду "exit" и занаво залогиться в системе."
sleep 3

echo "Ознакомьтесь с инструкцией."
sleep 3

touch README.txt

echo "Для того чтобы запустить AirFlow после перелогина в систему, войдите в директорию «~/Docker-compose-Airflow» введите команду «docker compose up airflow-init», далее «docker compose up»."

echo "Для того чтобы запустить AirFlow после перелогина в систему, войдите в директорию «~/Docker-compose-Airflow» введите команду «docker compose up airflow-init», далее «docker compose up»." > README.txt

echo "После запуска команды «docker compose up», будут подняты контейнеры, проверить можно командой «docker ps»."
echo "После запуска команды «docker compose up», будут подняты контейнеры, проверить можно командой «docker ps»." >> README.txt
sleep 4

echo "Остановить контейнеры можно командой «docker compose stop»."
echo "Остановить контейнеры можно командой «docker compose stop»." >> README.txt
sleep 4

echo "А остановить полностью и удалить контейнеры можно командой «docker compose down»."
echo "А остановить полностью и удалить контейнеры можно командой «docker compose down»." >> README.txt
sleep 4

echo "Airflow будет доступен по адресу: http://localhost:8080"
echo "Airflow будет доступен по адресу: http://localhost:8080" >> README.txt
sleep 4

echo "Пароль «airflow» и логин «airflow»."
echo "Пароль «airflow» и логин «airflow»." >> README.txt
sleep 4

pwd=`pwd`
echo "Вся эта информация будет в файле «README.txt», который будет находиться в $pwd"
sleep 6

clear

echo "Выходим из скрипта через..."
sleep 3

for i in {5..1}
do
	echo "$i..."
	sleep 1
done

clear

exit 0
