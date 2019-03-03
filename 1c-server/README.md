# docker-1c-server

## Что это?

docker-1c-server -- это сервер 1С:Предприятия 8.3.13-1644 в контейнере Docker. Все настройки - стандартные.

## Как запустить?

    docker run --name 1c-server --hostname 1c-server --net host --detach --volume 1c-server-home:/home/usr1cv8 --volume 1c-server-logs:/var/log/1C ms4b/1c-server:8.3.13-1644

## Как остановить/запустить/перезапустить контейнер?

Для управления контейнером используйте команды:

    docker stop 1c-server
    docker start 1c-server
    docker restart 1c-server

## Где мои данные?

Данные сервера 1С:Предприятия вы можете найти в каталогах `/var/lib/docker/volumes/1c-server-home/_data` (домашний каталог пользователя `usr1cv8`) и `/var/lib/docker/volumes/1c-server-logs/_data` (технологические журналы).

## Как это удалить?

Удалите контейнер:

    docker rm -f 1c-server

Удалите образ:

    docker rmi ms4b/1c-server

Удалите данные:

    docker volume rm 1c-server-home
    docker volume rm 1c-server-logs
