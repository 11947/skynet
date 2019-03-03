# Контейнер Docker Apache 2.4 с модулем 1С внутри и публикациями баз

## Сборка ораза Docker:

Поместить в каталог "dist" установочные пакеты для 64-битных Debian систем (*.deb)

В файле "Dockerfile" значение переменной "SERVER_1C_VERSION" установить в соотвтетсвии с версией дистрибутива

Собрать образ скриптом "scripts/build.cmd"

## Тестовый запуск контейнера

Создать и запустить контейнер скриптом "scripts/run.cmd"

В браузере открыть адрес "http://localhost", должна появиться стандартная страница Apache "It works!"

## Публикация инфортационных баз 1С

На каждую информационную базу в файл "publications.conf" добавляется шаблон:

    Alias "/[BaseName]" "/usr/local/apache2/htdocs/[BaseName]/"
        <Directory "/usr/local/apache2/htdocs/[BaseName]/">
            AllowOverride All
            Options None
            #Order allow,deny
            #Allow from all
            Require all granted
            SetHandler 1c-application
            ManagedApplicationDescriptor "/usr/local/apache2/htdocs/[BaseName]/default.vrd"
        </Directory>
        
В каталоге "publications" нужно создать каталог с таким же именем, которое было использовано в [BaseName]

В каталоге publications/[BaseName] должен быть создан файл с именем  "default.vrd". Этот файл создается платформой 1С-Предприятие при публиации информационной базы.
