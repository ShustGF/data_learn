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