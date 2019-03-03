# за основу берем свой образ CentOS с поддержкой Systemd
FROM ms4b/centos:latest

# источники
ARG DIST_EP=./docker-entrypoint.sh
#ARG DIST_CFG=./postgresql.conf.sh
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

#Далее в файле /var/lib/pgsql/9.4/data/postgresql.conf изменяем настройки под наши нужды. Редактируемые настройки:
#
#shared_buffers = 512MB
#temp_buffers = 16MB
#work_mem = 128MB
#maintenance_work_mem = 192MB
#effective_cache_size = 8GB

#Здесь /var/lib/pgsql/data/postgresql.conf первое что я сразу меняю это параметр effective_cache_size , который рекомендуют выставлять не менее половины от объема всей оперативной памяти сервера, а точнее размер кэша можно посмотреть в самой системе, набрав в командной строке free. Необходимое значение будет в столбце cached (в kB).
#
#Усредненная настройка наиболее важных параметров:
#
#shared_buffers = 1/8 RAM или больше (но не более 1/4)
#work_mem = в 1/20 RAM
#maintenance_work_mem = в 1/4 RAM
#max_fsm_relations = в планируемое кол-во таблиц в базах * 1.5
#max_fsm_pages в max_fsm_relations * 2000;
#fsync = true
#wal_sync_method = fdatasync
#commit_delay = от 10 до 100
#commit_siblings = от 5 до 10
#effective_cache_size = 0.9 от значения cached, которое показывает free
#random_page_cost = 2 для быстрых cpu, 4 для медленных
#cpu_tuple_cost = 0.001 для быстрых cpu, 0.01 для медленных
#cpu_index_tuple_cost = 0.0005 для быстрых cpu, 0.005 для медленных
#Для оптимизации настроек рассчитанных на максимальную производительность, можно попробовать воспользоваться утилитой pgtune.

# make the sample config easier to munge (and "correct by default")
#RUN mv -v /usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample /usr/share/postgresql/ \
#	&& ln -sv ../postgresql.conf.sample /usr/share/postgresql/$PG_MAJOR/ \
#	&& sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample