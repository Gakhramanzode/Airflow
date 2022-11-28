#! /bin/bash

set -e

clear

echo "Обновим пакеты системы, установем Docker, Docker compose, запустим Airflow"
sleep 5
clear

echo "Приступим"
sleep 2
clear

echo "Начинаю обновлять пакеты..."
sleep 3 
clear
sleep 1

sudo yum -y update
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

sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
clear
sleep 1

sudo systemctl start docker
clear
sleep 1

sudo yum update
sudo yum install docker-compose-plugin

clear
sleep 1

sudo usermod -aG docker $USER
clear
sleep 1

var=`docker --version`
re="Docker version"

if [[ $var =~ $re ]]; then
        clear
        echo "(2/3) Docker успешно установлен!"
        sleep 3
        clear
else
        sleep 3
        clear
        echo "Возникла ошибка во время установки Docker"
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

sudo docker compose up airflow-init

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

echo "Осталось перезагрузить $hostname. Это произойдет через 48 сек."
sleep 3

echo "Пока ознакомься со следующим."
sleep 3

touch README.txt

echo "Для того чтобы запустить AirFlow после перезагрузки, введите команду «docker compose up».‎" 
echo "Для того чтобы запустить AirFlow после перезагрузки, введите команду «docker compose up».‎" > README.txt

echo "Если вдруг выйдет ошибка «Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?», введите команду «sudo systemctl start docker»"
echo "Если вдруг выйдет ошибка «Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?», введите команду «sudo systemctl start docker»" >> README.txt
sleep 6

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
echo "Вся это информация будет в файле «README.txt». Файл будет находиться в $pwd"
sleep 6

clear

echo "Через 10 сек будет перезагрузка $hostname... "
sleep 4

echo "Начинаю обратный отсчет"
sleep 1

for i in {5..1}
do
	echo "$i..."
	sleep 1
done

echo  "Начинаю перезагрзку..."

sudo reboot now
