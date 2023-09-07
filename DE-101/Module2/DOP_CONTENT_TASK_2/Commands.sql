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
ALTER TABLE IF EXISTS public.orders RENAME TO orders_old;
DROP TABLE IF EXISTS  Calendar;
DROP TABLE IF EXISTS  Subcategories CASCADE;
DROP TABLE IF EXISTS  Categories CASCADE;
DROP TABLE IF EXISTS  cat_subcat CASCADE;
DROP TABLE IF EXISTS  Products CASCADE;
DROP TABLE IF EXISTS  Shiping_modes CASCADE;
DROP TABLE IF EXISTS  Managers CASCADE;
DROP TABLE IF EXISTS  Regions CASCADE;
DROP TABLE IF EXISTS  Managers_Regions CASCADE;
DROP TABLE IF EXISTS  "State" CASCADE;
DROP TABLE IF EXISTS  Countries CASCADE;
DROP TABLE IF EXISTS  City CASCADE;
DROP TABLE IF EXISTS  Postal_codes CASCADE;
DROP TABLE IF EXISTS  Segment CASCADE;
DROP TABLE IF EXISTS  Customers CASCADE;
DROP TABLE IF EXISTS  Orders CASCADE;
UPDATE public.orders_old
SET postal_code = 5432
where state = 'Vermont';
CREATE TABLE Calendar
(
 date_id     date NOT NULL,
 day      int GENERATED ALWAYS AS (date_part('day', date_id)) STORED,
 month      int GENERATED ALWAYS AS (date_part('month', date_id)) STORED,
 year      int GENERATED ALWAYS AS (date_part('year', date_id)) STORED,
 quarter      int GENERATED ALWAYS AS (date_part('quarter', date_id)) STORED,
 week      int GENERATED ALWAYS AS (date_part('week', date_id)) STORED,
 day_week      int GENERATED ALWAYS AS (date_part('isodow', date_id)) STORED,
 CONSTRAINT PK_Calendar PRIMARY KEY ( "date_id" )
);
INSERT INTO calendar 
VALUES (
DATE(generate_series(DATE(NOW()) - INTERVAL '10 year', DATE(NOW()), INTERVAL '1 day'))
);
CREATE TABLE Subcategories
(
 subcategory_id int  generated always as identity,
 subcat_name    varchar(30) NOT NULL,
 CONSTRAINT PK_subcategory_id PRIMARY KEY ( subcategory_id )
);
INSERT INTO subcategories (subcat_name)
SELECT distinct  subcategory 
FROM public.orders_old
ORDER BY subcategory;
CREATE TABLE Categories
(
 category_id    int  generated always as identity,
 category_name  varchar(30) NOT NULL,
 CONSTRAINT PK_category_id PRIMARY KEY ( category_id )
);
INSERT INTO categories (category_name)
SELECT distinct  category  
FROM public.orders_old;
CREATE TABLE Cat_subcat
(
 C_S_id    int  generated always as identity,
 category_id    int NOT NULL,
 subcategory_id int NOT NULL,
 CONSTRAINT PK_C_S_id PRIMARY KEY ( C_S_id ),
 CONSTRAINT FK_subcategory_id FOREIGN KEY ( subcategory_id ) REFERENCES Subcategories ( subcategory_id ),
 CONSTRAINT FK_category_id FOREIGN KEY ( category_id ) REFERENCES Categories ( category_id )
);
INSERT INTO cat_subcat (category_id, subcategory_id)
SELECT DISTINCT c.category_id ,s.subcategory_id 
FROM public.orders_old as o INNER JOIN categories c on o.category = c.category_name 
			    INNER JOIN subcategories s on o.subcategory = s.subcat_name;
CREATE TABLE Products
(
 product_id   varchar(30)  NOT NULL,
 product_name varchar  NOT NULL,
 "cost"       numeric      NOT NULL,
 C_S_id       int          NOT NULL,
 CONSTRAINT PK_product_id PRIMARY KEY ( product_id ),
 CONSTRAINT FK_C_S_id FOREIGN KEY ( C_S_id ) REFERENCES Cat_subcat ( C_S_id)
);
INSERT INTO products (product_id, product_name, cost, c_s_id) 
SELECT DISTINCT product_id, 
	LAST_VALUE(product_name) OVER(PARTITION BY product_id) product_name,
	ROUND(LAST_VALUE(sales) OVER(PARTITION BY product_id), 2) cost,
	cs.c_s_id 
FROM public.orders_old o INNER JOIN categories c ON o.category = c.category_name 
			 INNER JOIN subcategories s ON o.subcategory = s.subcat_name
			 INNER JOIN cat_subcat cs ON cs.category_id = c.category_id AND s.subcategory_id = cs.subcategory_id;
CREATE TABLE Shiping_modes
(
 ship_id   int generated always as identity,
 ship_mode varchar(14) NOT NULL,
 CONSTRAINT PK_ship_id PRIMARY KEY ( ship_id )
);
INSERT INTO shiping_modes (ship_mode)
SELECT DISTINCT ship_mode  FROM public.orders_old;
CREATE TABLE Managers
(
 manager_id   int generated always as identity,
 manager_name varchar(30) NOT NULL,
 CONSTRAINT PK_manager_id PRIMARY KEY ( manager_id )
);
INSERT INTO managers (manager_name)
SELECT person  FROM people;
CREATE TABLE Regions
(
 region_id   int generated always as identity,
 region_name varchar(20) NOT NULL,
 CONSTRAINT PK_region_id PRIMARY KEY ( region_id )
);
INSERT INTO regions(region_name)
SELECT region  FROM people;
CREATE TABLE Managers_Regions
(
 manager_id int NOT NULL,
 region_id  int NOT NULL,
 CONSTRAINT FK_manager_id FOREIGN KEY ( manager_id ) REFERENCES Managers ( manager_id ),
 CONSTRAINT FK_region_id FOREIGN KEY ( region_id ) REFERENCES Regions ( region_id )
);
INSERT INTO managers_regions (manager_id, region_id)
SELECT m.manager_id, r.region_id 
FROM people p INNER JOIN managers m ON p.person = m.manager_name 
	      INNER JOIN regions r ON p.region = r.region_name;
CREATE TABLE "State"
(
 state_id   int generated always as identity,
 state_name varchar(30) NOT NULL,
 CONSTRAINT PK_state_id PRIMARY KEY ( state_id )
);
INSERT INTO "State" (state_name)
SELECT DISTINCT state 
FROM orders_old;
CREATE TABLE Countries
(
 country_id   int generated always as identity,
 country_name varchar(30) NOT NULL,
 CONSTRAINT PK_country_id PRIMARY KEY ( country_id )
);
INSERT INTO countries (country_name)
SELECT DISTINCT country 
FROM orders_old;
CREATE TABLE City
(
 city_id   int generated always as identity,
 city_name varchar(20) NOT NULL,
 CONSTRAINT PK_city_id PRIMARY KEY ( city_id )
);
INSERT INTO city (city_name)
SELECT DISTINCT city 
FROM orders_old;
CREATE TABLE Postal_codes
(
 postal_code int NOT NULL,
 country_id  int NOT NULL,
 state_id    int NOT NULL,
 city_id     int NOT NULL,
 region_id   int NOT NULL,
 CONSTRAINT PK_postal_code PRIMARY KEY ( postal_code ),
 CONSTRAINT FK_country_id FOREIGN KEY ( country_id ) REFERENCES Countries ( country_id ),
 CONSTRAINT FK_state_id FOREIGN KEY ( state_id ) REFERENCES "State" ( state_id ),
 CONSTRAINT FK_city_id FOREIGN KEY ( city_id ) REFERENCES City ( city_id ),
 CONSTRAINT FK_region_id FOREIGN KEY ( region_id ) REFERENCES Regions ( region_id )
);
INSERT INTO postal_codes  
SELECT distinct postal_code, 
		c.country_id,  
		s.state_id,
		first_value(city.city_id) OVER (PARTITION BY postal_code),
		r.region_id 
FROM orders_old o INNER JOIN countries c ON o.country = c.country_name 
		  INNER JOIN "State" s ON o.state = s.state_name 
		  INNER JOIN city ON o.city =city.city_name
		  INNER JOIN regions r ON o.region = r.region_name;
CREATE TABLE Segment
(
 segment_id   int generated always as identity,
 segment_name varchar(20) NOT NULL,
 CONSTRAINT PK_segment_id PRIMARY KEY ( segment_id )
);
INSERT INTO segment (segment_name)
SELECT distinct segment 
FROM orders_old;
CREATE TABLE Customers
(
 customer_id   varchar(10),
 customer_name varchar(30) NOT NULL,
 segment_id    int NOT NULL,
 CONSTRAINT PK_customer_id PRIMARY KEY ( customer_id ),
 CONSTRAINT FK_segment_id FOREIGN KEY ( segment_id ) REFERENCES Segment ( segment_id )
);
INSERT INTO customers
SELECT distinct customer_id, customer_name, s.segment_id  
FROM orders_old o INNER JOIN segment s ON o.segment = s.segment_name;
CREATE TABLE Orders
(
 row_id      int generated always as identity,
 order_id    varchar(14) NOT NULL,
 order_date  date NOT NULL,
 ship_date   date NOT NULL,
 sales       numeric(9, 4) NOT NULL,
 quantity    int NOT NULL,
 discount    numeric(4, 2) NOT NULL,
 profit      numeric(21, 16) NOT NULL,
 customer_id varchar(10) NOT NULL,
 ship_id     int NOT NULL,
 product_id  varchar(30) NOT NULL,
 postal_code int NOT NULL,
 CONSTRAINT PK_row_id PRIMARY KEY ( row_id ),
 CONSTRAINT FK_customer_id FOREIGN KEY ( customer_id ) REFERENCES Customers ( customer_id ),
 CONSTRAINT FK_ship_id FOREIGN KEY ( ship_id ) REFERENCES Shiping_modes ( ship_id ),
 CONSTRAINT FK_product_id FOREIGN KEY ( product_id ) REFERENCES Products ( product_id ),
 CONSTRAINT FK_postal_code FOREIGN KEY ( postal_code ) REFERENCES Postal_codes ( postal_code )
);
INSERT INTO orders (order_id, order_date, ship_date, sales, quantity, discount, profit,customer_id,ship_id,product_id,postal_code)
SELECT order_id, 
	   order_date, 
	   ship_date, 
	   sales, 
	   quantity, 
	   discount, 
	   profit,
	   customer_id,
	   sm.ship_id,
	   product_id,
	   postal_code
FROM orders_old o INNER JOIN shiping_modes sm ON o.ship_mode = sm.ship_mode;
CREATE TABLE Return_orders
(
 order_id    varchar(14) NOT NULL,
 status varchar(5) NOT NULL,
 CONSTRAINT PK_order_id PRIMARY KEY ( order_id )
);
INSERT INTO Return_orders
SELECT DISTINCT  order_id, returned
from "returns";
drop table orders_old ;
drop table people;
drop table "returns";