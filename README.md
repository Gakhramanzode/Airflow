# Airflow
:octocat: Bash-скрипт по установке Airflow.

Поддерживаемые операционные системы для установки:
- [x] Linux Ubuntu
- [x] Linux CentOS

Данный скрипт выполняет следующие действия:
- обновляет пакеты;
- устанавливает Docker;
- устанавливает Docker compose;
- устанавливает Airflow.

Инструкция:
1) Клонируем репозиторий.
2) Переходим в нашу скаченную папку с помощью команды `cd Airflow`.
3) Для Linux Ubuntu вводим команду: `chmod +x src-ubuntu.sh`. Для Linux CentOS: `chmod +x src-centos.sh`.
4) Далее для Linux Ubuntu запускаем скрипт с помощью команды: `./src-ubuntu.sh`. Для Linux CentOS: `./src-centos.sh`.

[Ссылка](https://docs.docker.com/engine/install/) на документацию по установке Docker.
[Ссылка](https://docs.docker.com/compose/install/) на документацию по установке Docker compose.
[Ссылка](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html) на документацию по установке Airflow.
