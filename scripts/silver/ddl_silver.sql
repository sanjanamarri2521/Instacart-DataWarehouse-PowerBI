/*
===========================================================
DDL Script: Create Silver Tables
===========================================================
Script Purpose:
	This script creates tables in the 'silver' schema, dropping existing tables if they already exist.
	Run this script to re-define the DDL structure of 'bronze' Tables
===========================================================
*/

IF OBJECT_ID ('silver.aisles' , 'U') IS NOT NULL
	DROP TABLE silver.aisles;

GO

CREATE TABLE silver.aisles (
	aisle_id INT,
	aisle NVARCHAR(100),
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.departments' , 'U') IS NOT NULL
	DROP TABLE silver.departments;

GO

CREATE TABLE silver.departments (
	department_id INT,
	department NVARCHAR(100),
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.order_products_prior' , 'U') IS NOT NULL
	DROP TABLE silver.order_products_prior;

GO

CREATE TABLE silver.order_products (
	order_id INT,
	product_id INT,
	add_to_cart_order INT,
	reordered NVARCHAR(50),
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID ('silver.orders' , 'U') IS NOT NULL
	DROP TABLE silver.orders;

GO

CREATE TABLE silver.orders (
	order_id BIGINT,
	user_id INT,
	eval_set NVARCHAR(100),
	order_number INT,
	order_dow VARCHAR(50),
	order_hour_of_day INT,
	days_since_prior_order FLOAT NULL,
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.products' , 'U') IS NOT NULL
	DROP TABLE silver.products;

GO

CREATE TABLE silver.products (
	product_id INT,
	product_name NVARCHAR(200),
	aisle_id INT,
	department_id INT,
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);


