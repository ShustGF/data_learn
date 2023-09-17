# **Задания для модуля 2:**
## 1. Внедрение реляционной базы данных (далее РБД) PostgreSQL ##
Вам необходимо установить Postgres базу данных к себе на компьютер. Вы можете посмотреть инструкции по установки Postgres.

___

В рамках выполнения 2  задания была выполнена установка **PostgreSQL** из коробки на локальный компьютер. В основе кроме кнопок "Далее" там делать ничего не требовалось, поэтому в целях усложнения данной задачи и оттачивании навыков полученых на курсе **"Docker"** (https://karpov.courses/docker)  было принято решение поднять контейнер Docker PostgreSQL. **Images** был создан и сохранён в репозитории и доступен по команде `docker pull shustgf/dlpostgresql`(https://hub.docker.com/repository/docker/shustgf/dlpostgresql/general). Данный контейнер имеет уже в себе все необходимы данные для выполения пункта 2.3.

Контейнер **PosgreSQL** поднимался с помощью следующего содержания **Dockerfile**:

        FROM postgres:14                                                # За основу взяли репозиторий PostreSQL версии 14 

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

2) Как говорилось в задании 1 создан файл **Commands.sql** который содержит: 



		CREATE TABLE orders(
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


Команды:

`CREATE TABLE` - позволяет создать таблицу

`SET datestyle = 'ISO,DMY'` - позволяет согласовать дату в формате **день-месяц-год**

`COPY ... FROM ... DELIMITER ';' CSV HEADER ENCODING 'windows-1251'` - позволяет скопировать данные из **CSV** файла в таблицу
 
3) Расчёт метрик из **Модуля 1**:

	А) Overview (обзор ключевых метрик)

* Total Sales, Total Profit, Profit Ratio, Profit per Order, Sales per Customer, Avg. Discount

		SELECT ROUND(SUM(sales), 2) AS total_sales,
		ROUND(SUM(profit), 2) AS total_profit,
		ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_ratio,
		ROUND(SUM(profit) / COUNT(DISTINCT order_id), 2) AS profit_per_order,
		ROUND(SUM(sales) / COUNT(DISTINCT customer_id), 2) AS sales_per_customer,
		ROUND(AVG(discount), 2) AS avg_discount
		FROM orders;

* Monthly Sales by Segment 

		SELECT CAST(DATE_TRUNC('month', order_date) as DATE) as date, 
	           segment, 
	           ROUND(SUM(sales)) as  monthly_sales_by_segment
		FROM orders
		GROUP BY segment, date
		ORDER BY date, segment 

* Monthly Sales by Product Category (табличка и график)

		SELECT CAST(DATE_TRUNC('month', order_date) as DATE) as date, 
			   category , 
		       ROUND(SUM(sales)) as  monthly_sales_by_category
		FROM orders
		GROUP BY category, date
		ORDER BY date, category 

	Б)Product Dashboard (Продуктовые метрики)

* Sales by Product Category over time (Продажи по категориям)

		SELECT category,
			order_date,  
			SUM(sales) AS  sales_by_product_category_over_time
		FROM orders
		GROUP BY category,order_date  
		ORDER BY category,order_date 

	В)Customer Analysis

* Sales and Profit by Customer, Customer Ranking

		with t1 as (SELECT customer_id , ROUND(sum(sales)) AS sum_sales , ROUND(SUM(profit)) as sum_profit 
		FROM orders
		GROUP BY customer_id)
		SELECT customer_id, 
			sum_sales, sum_profit,DENSE_RANK() OVER(ORDER BY sum_sales DESC) as rank_customer
		FROM t1
		ORDER BY rank_customer

* Sales per region

		SELECT region  , SUM(sales) AS sum_sales
		FROM orders
		group by region 
		order by sum_sales DESC

## 3. Модели Данных ##

1) Вам необходимо нарисовать модель данных для нашего файлика Superstore:

* Концептуальную
* Логическую
* Физическую 

Вы можете использовать бесплатную версию SqlDBM или любой другой софт для создания моделей данных баз данных.

2) Когда вы нарисуете модель данных, вам нужно скопировать DDL и выполнить его в SQL клиенте.

3)Вам необходимо сделать `INSERT INTO SQL`, чтобы заполнить Dimensions таблицы и Sales Fact таблицу. Сначала мы заполняем Dimensions таблицы, где в качестве id мы генерим последовательность чисел, а зачем Sales Fact таблицу, в которую вставляем id из Dimensions таблиц. Такой пример я рассматривал в видео.

___

По итогам выполнения 3го задания:

- по первому пункту была построена следующая **физическая модель** (в связи с тем, что в физическую модель входят концептуальная и логическая не вижу большого смысла вставлять сюда 3 рисунка):

![Модель данных](https://github.com/ShustGF/data_learn/blob/main/DE-101/Module2/Images/Phisic_model_data.PNG)

- по второму и третьему пункам. С помощью **SqlDBM** было сформировано 17 запросов к базе данных. На основе Docker'а из первого задания был сформинован новый **SQL-скрипт**, который включал в себя всю необходимую информацию для выполнения задач по пункту 3. Скрипт создания таблиц и их заполнения представлен в файле [**Commands.sql**](https://github.com/ShustGF/data_learn/blob/main/DE-101/Module2/DOP_CONTENT_TASK_2/Commands.sql). Сам контейнер Docker'а можно поднять по следующим командам (ссылка на репозиторий: https://hub.docker.com/repository/docker/shustgf/dlpost243/general): 

	1) `docker pull shustgf/dlpost243:latest`

	2) `docker run --rm -d -p 2345:5432 --name ps1 shustgf/dlpost243:latest`

Так же при переносе данных из первоночальных данных в новые таблицы со связями были найдены некоторые **не точности** в данных:
	
1) Не понятно почему колонка Product_id имеет нескольно разных Product_name. По идее данные колонкидолжны быть разными чтобы использовать Product_id как первичный ключ. По моему мнению в данном случае это анамалия. Данную тему можно увидеть следующим запросом. 

		SELECT *
		FROM (SELECT product_id, product_name, COUNT(*) OVER(partition by product_id) AS count_znach
		FROM (SELECT distinct product_id , product_name  
		FROM public.orders) AS t1) AS t2
		WHERE count_znach > 1

Предполагаю, что значения **Product_name** по определённому ключу было изменено изначально в искомой таблице и именно в ней есть об этом информация в виде дополнительной колонки с датой.

2) штат Vermont в таблице orders не имеет почтового индекса, такого быть не должно, в рамках заполнения таблиц поставил ему значение "5432"

3) почтовый индекс относится к 2м разным городам например postal_code = 92024

## 4. База данных в облаке ##
<<<<<<< Updated upstream
=======

В рамках выполнения задания я попытался зарегистрировать аккаунт на AWS, но столкнулся с проблемой списания 1$. Банковская карта не проходила верификацию и деньги не списывались. В связи с этим зарегистрировать полноценный аккаунт у меня не полулучилось. Для выполпнения задания я воспользовался сервисом **ElephantSQL**, где есть возможность зарегистрировать аккаунт и воспользоваться бесплатным облачным хранилищем размером до 20 Мб(для учебных целей пойдёт). На **ElephanSQL**  я создал экземпляр 

[!ElephanSQL]()

и чтобы к нему подключиться через **DBeaver** нужно использовтаь Host подключение, а не URL. В противном случае подключиться к облаку не получится.

[!link_cloud]()

После чего я занёс данные используя уже готовый примеры запросов:

- Staging [stg.orders.sql](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module02/DE%20-%20101%20Lab%202.1/stg.orders.sql)
- Business Layer [from_stg_to_dw.sql](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module02/DE%20-%20101%20Lab%202.1/from_stg_to_dw.sql)

В целом работа с базой данных через облочные технологии, не сильно отличается от работы на локальной базе данных, за исключением того, что приходтся здать когда данные попадут на само облако, т.е. есть небольшая задержка в зависимости от того где находится сервер к которому мы подключаемся.

## 5. Как донести данные до бизнес-пользователя (Пример решений на KlipFolio, Google Sheets и пр.) ##

В связи с тем, что **ElephanSQL** поддерживает не более 5 подключений, а в lookerstudio каждая визуализация подрозумевает отдельное подключение (как я понял), при работе с lookerstudio возникает следующая ошибка:

[!errors]()

Имено из-за неё не получается  полноценно выполнить данное задание. В связи с этим было принято решение разверинуть Docker из пункта 3 и написать запрос на объединения данных из таблиц.

			WITH man_reg as (
			select r.region_id, r.region_name, m.manager_name  
			FROM managers_regions mr INNER JOIN managers m  ON  mr.manager_id =m.manager_id 
									INNER JOIN regions r ON r.region_id = mr.region_id 
			) 
			,Postal_code as (
			select postal_code, 
				c.country_name, 
				s.state_name,
				c2.city_name,
				mr.region_name,
				mr.manager_name
			FROM postal_codes pc INNER JOIN countries c ON pc.country_id = c.country_id 
								INNER JOIN "State" s ON pc.state_id = s.state_id
								INNER JOIN city c2 ON pc.city_id = c2.city_id
								INNER JOIN man_reg mr ON pc.region_id = mr.region_id 
			),
			C_S as (
			SELECT C_S_id, s2.subcat_name , c3.category_name 
			FROM cat_subcat cs INNER JOIN subcategories s2 ON cs.subcategory_id = s2.subcategory_id 
							INNER JOIN categories c3  ON cs.category_id = c3.category_id  
			),
			Prod as (
			SELECT product_id, product_name, cs2.subcat_name, cs2.category_name
			FROM products p INNER JOIN C_S cs2 ON cs2.C_S_id = p.c_s_id 
			),
			seg as (
			SELECT customer_id, customer_name, s.segment_name  
			FROM customers c JOIN segment s ON c.segment_id  = s.segment_id 
			),
			general_orders as
			(SELECT o.order_id, order_date, year, month, day, quarter, week, day_week, ship_date, ship_mode, o.customer_id, customer_name, segment_name,
				o.product_id, product_name, category_name, subcat_name, o.postal_code, country_name, state_name, city_name, region_name, manager_name,
				sales, quantity, discount, profit, status
			FROM public.orders o JOIN Postal_code pc ON o.postal_code = pc.postal_code
								JOIN Prod ON Prod.product_id = o.product_id 
								JOIN seg ON o.customer_id = seg.customer_id
								JOIN shiping_modes sm ON o.ship_id = sm.ship_id
								LEFT JOIN return_orders ro ON ro.order_id= o.order_id
								JOIN calendar cal ON cal.date_id = o.order_date
			)
			SELECT order_id,
				order_date,
				year as order_year,
				month as order_month,
				day as order_day,
				quarter as order_quarter,
				week as order_week,
				day_week as order_day_week,
				ship_date,
				ship_mode,
				customer_id,
				customer_name,
				segment_name,
				product_id,
				product_name,
				category_name,
				subcat_name,
				postal_code,
				country_name,
				state_name,
				city_name,
				region_name,
				manager_name,
				sales,
				quantity,
				discount,
				profit,
				COALESCE(status,'No') as status_order
			FROM general_orders

Сравнив начальную таблицу с обобщенной таблицей в них по 9994 строчек, это значит что данные не потеряли. (своего рода сверка данных)

Далее я экспортировал полученные данные из DBeaver в CSV файл и подгрузил его с систему визуализации **Tablue Public**. В целом я имею представление, что используя облачные сервисы, мне облегчило бы задачу получения данных, а на построение самого дашборда не влияет от куда брать данные. Самое главное уметь их преобразовать до постоения. Долго не думая я решил построить такойже дашборд как и в модуле 1.

![дашборд]()

>>>>>>> Stashed changes
