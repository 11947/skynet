# за основу берем стандартный образ Debian+Apache 2.4: https://store.docker.com/images/httpd
FROM httpd:2.4
MAINTAINER ms4b

# для избежания ошибок установки
ARG DEBIAN_FRONTEND=noninteractive
# версии дистрибутивов
ARG SERVER_1C_VERSION=8.3.13-1644
ARG SERVER_1C_ARCH=amd64
# дистрибутив 1С
ARG DIST_SERVER_1C=./dist/*.deb
# основная конфигурация Apache
ARG DIST_CFG=./httpd.conf
# конфигурация опубликованных баз 1С
ARG DIST_PUB=./publications.conf
# каталоги c настройками публикаций баз 1С
ARG DIST_BASES=./publications

# приемники
ARG DEST_TMP=/tmp
ARG DEST_CFG=/usr/local/apache2/conf
# расположение сайтов
ARG DEST_BASES=/usr/local/apache2/htdocs
# расположение логов
ARG LOGS=/usr/local/apache2/logs

# перенос дистрибутивов 1С
ADD ${DIST_SERVER_1C} ${DEST_TMP}/

# установка 1С
RUN    dpkg -i /tmp/1c-enterprise83-common_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-common-nls_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-server_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-server-nls_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-ws_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    && dpkg -i /tmp/1c-enterprise83-ws-nls_${SERVER_1C_VERSION}_${SERVER_1C_ARCH}.deb \
    # удаление дистрибутива
    && rm /tmp/*.deb \
    # удаление ненужных пакетов
    && apt-get clean \
    # перенаправление ошибок в docker
    && ln -s /dev/stderr ${LOGS}/error.log \
    # перенаправление обращений в docker
    && ln -s /dev/stdout ${LOGS}/access.log

# перенос файла настроек Apache
ADD ${DIST_CFG} ${DEST_CFG}/
# перенос файла конфигурации опубликованных баз 1С
ADD ${DIST_PUB} ${DEST_CFG}/extra/
# каталоги c настройками публикаций баз 1С
ADD ${DIST_BASES} ${DEST_BASES}/

# публикация портов сервера
EXPOSE 80