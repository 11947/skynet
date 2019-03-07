# за основу берем свой образ CentOS с поддержкой Systemd
FROM ms4b/centos:latest

# источники
ARG DIST_EP=./docker-entrypoint.sh
ARG DIST_CFG=./postgresql.conf
ARG DIST_PG=./dist/postgres/*
ARG DIST_PGA=./dist/addon/*
# приемники
ARG DEST_EP
ARG DEST_CFG=/docker-entrypoint-initdb.d
ARG DEST_PG=/tmp/postgres
ARG DEST_PGA=/tmp/addon

# дополнение путей поиска приложений
ENV PATH /usr/pgsql-10/bin:$PATH
# расположение данных
ENV PGDATA /data

# создание пользователя и группы
RUN groupadd postgres \
    && adduser --gid postgres postgres \
    # создание служебных каталогов
    && mkdir --parent /var/run/postgresql ${PGDATA} ${DEST_CFG} ${DEST_PG} ${DEST_PGA} \
    && chown --recursive postgres:postgres /var/run/postgresql ${PGDATA} \
    && chmod g+s /var/run/postgresql

# перенос основного дистрибутива
ADD ${DIST_PG} ${DEST_PG}/
# перенос аддона
ADD ${DIST_PGA} ${DEST_PGA}/

# установка необходимых для postgres пакеты, не находятся libicu50 libtermcap
RUN yum install -y readline krb5-libs openssl libicu-devel --nogpgcheck \
    # установка основного дистрибутива и аддона
    && yum localinstall -y ${DEST_PG}/*.rpm ${DEST_PGA}/*.rpm --nogpgcheck \
    # удаление установочных пакетов
    && rm --recursive /tmp/* \
    # очистка локального кэша
    && yum clean all

# перенос конфигурационного файла
ADD ${DIST_CFG} ${DEST_CFG}/
# перенос скрипта запуска
ADD ${DIST_EP} ${DEST_EP}/

# установим возможность запуска управляющего скрипта
RUN chmod +x /docker-entrypoint.sh

# скрипт запуска
ENTRYPOINT ["/docker-entrypoint.sh"]

# описание томов, хранимых на хосте
VOLUME $PGDATA

# публикация портов сервера
EXPOSE 5432

# параметр скрипта запуска
CMD ["postgres"]