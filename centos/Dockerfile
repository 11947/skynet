# за основу берем последний CentOS
FROM centos:latest
# копируем в контейнер скрипт для русской локализации
ADD ./i18n.sh /opt/i18n.sh
# обновим систему
RUN yum update -y \
    && yum clean all \
    # устанавливаем русскую локализацию
    && chmod +x /opt/i18n.sh \
    && /opt/i18n.sh \
    && localedef -i ru_RU -f UTF-8 ru_RU.UTF-8 \
    # установим московский часовой пояс
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
ENV LANG ru_RU.utf8
ENV LANGUAGE ru_RU:ru
ENV LC_ALL ru_RU.utf8

# установим gosu
ARG GOSU_VERSION=1.11
#RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
#    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
#    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
#    && gpg --verify /usr/local/bin/gosu.asc \
#    && rm /usr/local/bin/gosu.asc \
#    && rm -r /root/.gnupg/ \
#    && chmod +x /usr/local/bin/gosu \
#    && gosu nobody true

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

# команда, выполняемая при запуске контейнера
CMD ["/bin/bash"]
