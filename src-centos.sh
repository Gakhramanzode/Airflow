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

sudo yum -y update && sudo yum -y upgrade	#лишние пакеты нам не нужны
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

sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y		#чтобы не согласовывать установку каждого пакета, заранее соглашаемся
clear
sleep 1

sudo systemctl start docker
clear
sleep 1

sudo yum -y update	#тут тоже соглашаемся
#sudo yum install docker-compose-plugin - зачем повторно его ставить? он же выше заинсталлился

clear
sleep 1

sudo usermod -aG docker $USER
clear
sleep 1

#я бы проверку делел не через вывод версии, а через статус, потому что версия не говорит о том, работает ли сервис или на нем висит ошибка
var=`sudo systemctl status docker |grep Active |grep running | wc -l`

if [[ "$var" = 1 ]]	#почитай отличие про [[]] и [] и почему я сделал так
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
sudo systemctl enable docker.service	#Чтобы автоматически запускать Docker и Containerd при загрузке
sudo systemctl enable containerd.service	#создается симлинк на 2 сервиса

#тут можешь перенправить все, что хочешь в README.txt и выходить из скрипта
exit 0

sudo docker compose up airflow-init	#Выполнять запуск контейнера из под рута - дурной тон и не позволителен в некоторых сервисах, но проблема в том, что что у тебя пользователь еще не добавлен в группу docker
# по хорошему тут нужно закончить скрипт и выйти из консоли командой exit. Т.е. тебе ребут не нужно делать, незачем лишний раз машину перегружать. Просто перезайди в консоль
# после перезахода выполнишь 2 команды руками (docker compose up airflow-init, docker compose up и проверишь состояние docker ps). В ямле, если не ошибаюсь уже прописан перезапуск остановленных контейнеров в случае ребута.
# можешь их записать в README.txt, как ты делаешь ниже
# почитай мои коменты ниже
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

#ошибки не будет, если ты заранее настроишь перезапуск сервиса. Я это сделал перед exit 0
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

echo  "Начинаю перезагрзку..."		#ощущение, что в этот момент должен поевиться Гагарин с фрозой: "Поехали!" )))

sudo reboot now
