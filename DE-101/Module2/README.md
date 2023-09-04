# **Задания для модуля 2:**
## 1. Внедрение реляционной базы данных (далее РБД) PostgreSQL ##
Вам необходимо установить Postgres базу данных к себе на компьютер. Вы можете посмотреть инструкции по установки Postgres.

___

В рамках выполнения 2  задания была выполнена установка **PostgreSQL** из коробки на локальный компьютер. В основе кроме кнопок "Далее" там делать ничего не требовалось, поэтому в целях усложнения данной задачи и оттачивании навыков полученых на курсе **"Docker"** (https://karpov.courses/docker)  было принято решение поднять контейнер Docker PostgreSQL. **Images** был создан и сохранён в репозитории и доступен по команде `docker pull shustgf/dlpostgresql` (https://hub.docker.com/repository/docker/shustgf/dlpostgresql/general). Данный контейнер имеет уже в себе все необходимы данные для выполения пункта 2.3.

Контейнер **PosgreSQL** поднимался с помощью следующего содержания **Dockerfile**:

`       FROM postgres:14                                                # За основу взяли репозиторий PostreSQL версии 14 

        RUN apt-get update && apt-get install -y nano vim               # Устанавливаем дополнительные редакторы nano и vim

        COPY ./table ./table                                            # Копируем каталог table в котором находится 3 файла 
                                                                          "Orders.csv","Returns.csv","People.csv". Данные файлы
                                                                          созданы с учетом листов из файла "Sample - Superstore.xlsx"
        ENV POSTGRES_PASSWORD=gfh0km                                    # Объявляем переменное простраство с 3мя параметрами 
        ENV POSTGRES_USER=dl_user                                         "POSTGRES_PASSWORD", "POSTGRES_USER", "POSTGRES_DB" со
        ENV POSTGRES_DB=superstore                                        значениями "gfh0km", "dl_user", "superstore".
                                                                          Данные значения проставлены в рамках обучения на 
                                                                          реальных базах данных такого делать не стоит в рамках безопастности.
        EXPOSE 5432                                                     # Сообщаем какой порт слушается для пользователей

        COPY ./Commands.sql /docker-entrypoint-initdb.d/Commands.sql    # В связи с тем, что PostgreSQL "поднимается" позже чем выполняется 
                                                                          конструкция ENTRYPOIN, запросы из пункта 2.2 находящиеся в файле 
                                                                          "Commands.sql" нужно поместить в каталог /docker-entrypoint-initdb.d. В 
                                                                          данном случае файл "Commands.sql" выполнится при "поднятии" контейнера.
`

После скачивания **Images**, запускаем контейнер с помощью команды `docker run --rm -d -p 2345:5432 --name ps1 shustgf/dlpostgresql`. (порт на хосте равен 2345 из-за того, что установлена локальная версия PostgreSQL и чтобы небыло конфликта обращаться требуется на другой порт) 

## 2. Подключение базы данных и SQL ##

1) Вам необходимо установить клиент SQL для подключения базы данных. Вы можете посмотреть инструкции по установки DBeaver. Так же вы можете использовать любой другой клиент для подключения к ваше БД.
2) Создайте 3 таблицы и загрузите данные из Superstore Excel файл в вашу базу данных. Сохраните в вашем GitHub скрипт загрузки данных и создания таблиц. Вы можете использовать готовый пример sql файлов.
3) Напишите запросы, чтобы ответить на вопросы из Модуля 01. Сохраните в вашем GitHub скрипт загрузки данных и создания таблиц.

___

# Выполнение поставленной задачи

1) Локально была установлена программа **DBeaver**. Для подключения к **PostgreSQL** средствами **DBeaver** был автоматически скачен JDBC драйвер. Никаких дополнительных настроек программы и подключения не проводилось.

Параметры подключения базы данных представлена на следующем изображении:

![Подключение к БД](https://github.com/ShustGF/data_learn/blob/main/DE-101/Module2/Images/link_BD.PNG)

<<<<<<< Updated upstream
2) 
=======
2) Как говорилось в задании 1 создан файл **Commands.sql** который содержит: 
`	CREATE TABLE orders(
	   Row_ID        INTEGER  NOT NULL PRIMARY KEY 
	  ,Order_ID      VARCHAR(14) NOT NULL
	  ,Order_Date    DATE  NOT NULL
	  ,Ship_Date     DATE  NOT NULL
	  ,Ship_Mode     VARCHAR(14) NOT NULL
	  ,Customer_ID   VARCHAR(8) NOT NULL
	  ,Customer_Name VARCHAR(22) NOT NULL
	  ,Segment       VARCHAR(11) NOT NULL
	  ,Country       VARCHAR(13) NOT NULL
	  ,City          VARCHAR(17) NOT NULL
	  ,State         VARCHAR(20) NOT NULL
	  ,Postal_Code   INTEGER 
	  ,Region        VARCHAR(7) NOT NULL
	  ,Product_ID    VARCHAR(15) NOT NULL
	  ,Category      VARCHAR(15) NOT NULL
	  ,SubCategory   VARCHAR(11) NOT NULL
	  ,Product_Name  VARCHAR(127) NOT NULL
	  ,Sales         NUMERIC(9,4) NOT NULL
	  ,Quantity      INTEGER  NOT NULL
	  ,Discount      NUMERIC(4,2) NOT NULL
	  ,Profit        NUMERIC(21,16) NOT NULL
	);

	SET datestyle = 'ISO,DMY';

	COPY orders(Row_ID ,Order_ID ,Order_Date ,Ship_Date ,Ship_Mode ,Customer_ID , Customer_Name, Segment ,Country ,City ,State ,Postal_Code ,Region ,Product_ID ,Category ,SubCategory ,Product_Name ,Sales ,Quantity ,Discount ,Profit) from '/table/Orders.csv' DELIMITER ';' CSV HEADER ENCODING 'windows-1251';

	CREATE TABLE people(
	   Person VARCHAR(17) NOT NULL PRIMARY KEY
	  ,Region VARCHAR(7) NOT NULL
	);

	COPY people(Person, Region) FROM '/table/People.csv' DELIMITER ';' CSV HEADER ENCODING 'windows-1251';
	CREATE TABLE returns(
	   Returned VARCHAR(5) NOT NULL
	  ,Order_ID VARCHAR(14) NOT NULL
	);

	COPY returns(Returned, Order_ID) FROM '/table/Returns.csv' DELIMITER ';' CSV HEADER ENCODING 'windows-1251';
`
Команды:
`CREATE TABLE` - позволяет создать таблицу
`SET datestyle = 'ISO,DMY'` - позволяет согласовать дату в формате **день-месяц-год**
`COPY ... FROM ... DELIMITER ';' CSV HEADER ENCODING 'windows-1251'` - позволяет скопировать данные из **CSV** файла в таблицу
 
