#! /bin/bash

set -e

clear

echo "Обновим пакеты системы, установим Docker, Docker compose и Airflow"
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

var=`sudo systemctl status docker | grep Active | grep running | wc -l`

if [[ "$var" = 1 ]]; then
        clear
        echo "(2/3) Docker успешно установлен!"
        sleep 3
        clear
else
        sleep 3
        clear
        echo "Возникла ошибка во время установки Docker"
        sudo systemctl status docker
	exit 1
fi

echo "Начинаю устанавливать Airflow..."
sleep 3
clear

mkdir ~/Docker-compose-Airflow
cd ~/Docker-compose-Airflow

curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.4.3/docker-compose.yaml'

mkdir -p ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)" > .env

sudo systemctl enable docker.service --now
sudo systemctl enable containerd.service --now

if [ $? -eq 0 ]; then
	clear
	echo "(3/3) Airflow успешно установлен!"
	sleep 3
	clear
else
        sleep 3
        clear
        echo "Возникла ошибка во время установки Airflow"
        exit 1
fi

hostname=`hostname`

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

printf "Осталось перезайти в консоль «$hostname».\nДля этого необходимо выполнить в ручную команду «exit» и занаво залогиниться в системе.\n\n"
sleep 12

echo "Ознакомьтесь с инструкцией."
sleep 3

touch README.txt

printf "Для того чтобы запустить AirFlow после перелогина в систему:\n- войдите в директорию «~/Docker-compose-Airflow»;\n- введите команду «docker compose up airflow-init»;\n- далее «docker compose up».\n\n"
printf "Для того чтобы запустить AirFlow после перелогина в систему:\n- войдите в директорию «~/Docker-compose-Airflow»;\n- введите команду «docker compose up airflow-init»;\n- далее «docker compose up».\n\n" > README.txt
sleep 10

printf "После запуска команды «docker compose up», будут подняты контейнеры, проверить можно командой «docker ps».\n"
printf "После запуска команды «docker compose up», будут подняты контейнеры, проверить можно командой «docker ps».\n" >> README.txt
sleep 6

printf "Остановить контейнеры можно командой «docker compose stop».\n"
printf "Остановить контейнеры можно командой «docker compose stop».\n" >> README.txt
sleep 6

printf "А остановить полностью и удалить контейнеры можно командой «docker compose down».\n\n"
printf "А остановить полностью и удалить контейнеры можно командой «docker compose down».\n\n" >> README.txt
sleep 6

printf "Airflow будет доступен по адресу: http://localhost:8080\n"
printf "Airflow будет доступен по адресу: http://localhost:8080\n" >> README.txt
sleep 6

printf "Пароль «airflow» и логин «airflow».\n\n"
printf "Пароль «airflow» и логин «airflow».\n\n" >> README.txt
sleep 6

pwd=`pwd`
echo "Вся эта информация будет в файле «README.txt», который будет находиться в «$pwd»."
sleep 8

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
