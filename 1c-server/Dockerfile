FROM ubuntu:bionic
MAINTAINER ms4b

# для избежания ошибок установки
ARG DEBIAN_FRONTEND=noninteractive
# версии дистрибутивов
ARG GOSU_VERSION=1.7
ARG SERVER_1C_VERSION=8.3.13-1644
ARG SERVER_1C_ARCH=amd64
# источники
ARG DIST_SERVER_1C=./dist/*.deb
ARG DIST_FONTS=./dist/MsCoreFonts/*
ARG DIST_CFG=./logcfg.xml
ARG DIST_EP=./docker-entrypoint.sh
# приемники
ARG DEST_FONTS=/home/usr1cv8/.fonts
ARG DEST_CFG=/opt/1C/v8.3/x86_64/conf
ARG DEST_TMP=/tmp
ARG DEST_EP=
# служебные каталоги
ARG OPT=/opt/1C
ARG HOME_1C=/home/usr1cv8
ARG LOG_1C=/var/log/1c

# создание служебных каталогов
RUN mkdir --parent ${DEST_FONTS} ${DEST_CFG} ${LOG_1C}/dumps

# перенос шрифтов
ADD ${DIST_FONTS} ${DEST_FONTS}/
# перенос дистрибутивов 1С
ADD ${DIST_SERVER_1C} ${DEST_TMP}/

# установка apt-utils, wget, ca-certificates и locales
RUN apt-get update \
    && apt-get install --yes --quiet --no-install-recommends apt-utils wget ca-certificates locales \
    # установка необходимых для сервера 1С зависимостей
    && apt-get install --yes --quiet --no-install-recommends libwebkitgtk-3.0-0 libMagickWand-6.Q16 libgsf-1-114 unixodbc libfreetype6 libglib2.0-0 libkrb5-3 libgssapi-krb5-2 \
    # установка gosu
    && wget --output-document /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    # установка русской локали
    && localedef --inputfile ru_RU --force --charmap UTF-8 --alias-file /usr/share/locale/locale.alias ru_RU.UTF-8 \
    && update-locale LANG=ru_RU.UTF-8 \
    && locale-gen en_US.UTF-8 \
    # установка московского часового пояса
    && ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
    # очистка
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# установка русской локали
ENV LANG=ru_RU.utf8

# установка 1С
RUN dpkg -i /tmp/1c-enterprise83-common_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-common-nls_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-server_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-server-nls_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-ws_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-ws-nls_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    # удаление дистрибутива
    && rm /tmp/*.deb \
    # удаление ненужных пакетов
    && apt-get clean \
    # установим владельцем служебных каталогов пользователя usr1cv8
    && chown -R usr1cv8:grp1cv8 ${OPT} ${HOME_1C} ${LOG_1C}

# перенос файла настроек сервера 1С
ADD ${DIST_CFG} ${DEST_CFG}/
# перенос скрипта запуска
ADD ${DIST_EP} ${DEST_EP}/

# установим возможность запуска управляющего скрипта
RUN chmod +x /docker-entrypoint.sh

# описание томов, хранимых на хосте
VOLUME ${HOME_1C}
VOLUME ${LOG_1C}

# скрипт запуска
ENTRYPOINT ["/docker-entrypoint.sh"]

# публикация портов сервера
EXPOSE 1540-1541 1560-1591

# параметр скрипта запуска
CMD ["ragent"]