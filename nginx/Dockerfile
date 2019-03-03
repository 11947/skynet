# за основу берем стандартный образ Alpine+Nginx 1.15: https://hub.docker.com/_/nginx
FROM nginx:1.15-alpine
MAINTAINER ms4b

# основной файл конфигурации
ARG DIST_CFG=./nginx.conf
# дополнительный файл конфигурации
ARG DIST_CFG_ADD=./app.conf
# сертификаты
ARG DIST_CERT=./cert

# расположение основного файла конфигурации
ARG DEST_CFG=/etc/nginx
# расположение дополнительных файлов конфигурации
ARG DEST_CFG_ADD=/etc/nginx/conf.d
# расположение сертификатов
ARG DEST_CERT=/etc/nginx/ssl

# удалим файлы конфигурации по умолчанию
RUN rm ${DEST_CFG_ADD}/default.conf ${DEST_CFG}/nginx.conf \
# создадим каталог для сертификатов
    && mkdir ${DEST_CERT}

# перенос основаного файла конфигурации
ADD ${DIST_CFG} ${DEST_CFG}/
# перенос дополнительного файла конфигурации
ADD ${DIST_CFG_ADD} ${DEST_CFG_ADD}/
# перенос сертификатов
ADD ${DIST_CERT} ${DEST_CERT}/

# публикация портов сервера
EXPOSE 80 443

