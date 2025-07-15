/*
===============================================================
DDL Script: Create Bronze Tables
===============================================================
Script Purpose:
  This script creates tables in the 'bronze' schema, dropping existing tables if they already exist.

Run this script to re-define the DDL structure of 'bronze' Tables
================================================================
*/

IF OBJECT_ID ('bronze.aisles' , 'U') IS NOT NULL
	DROP TABLE bronze.aisles;

GO

CREATE TABLE bronze.aisles (
	aisle_id INT,
	aisle NVARCHAR(100)
);

IF OBJECT_ID ('bronze.departments' , 'U') IS NOT NULL
	DROP TABLE bronze.departments;

GO

CREATE TABLE bronze.departments (
	department_id INT,
	department NVARCHAR(100)
);

IF OBJECT_ID ('bronze.order_products_prior' , 'U') IS NOT NULL
	DROP TABLE bronze.order_products_prior;

GO

CREATE TABLE bronze.order_products_prior (
	order_id INT,
	product_id INT,
	add_to_cart_order INT,
	reordered INT
);

IF OBJECT_ID ('bronze.order_products_train' , 'U') IS NOT NULL
	DROP TABLE bronze.order_products_train;

GO

CREATE TABLE bronze.order_products_train (
	order_id INT,
	product_id INT,
	add_to_cart_order INT,
	reordered INT
);

IF OBJECT_ID ('bronze.orders' , 'U') IS NOT NULL
	DROP TABLE bronze.orders;

GO

CREATE TABLE bronze.orders (
	order_id BIGINT,
	user_id INT,
	eval_set NVARCHAR(100),
	order_number INT,
	order_dow INT,
	order_hour_of_day INT,
	days_since_prior_order FLOAT NULL
);

IF OBJECT_ID ('bronze.products' , 'U') IS NOT NULL
	DROP TABLE bronze.products;

GO

CREATE TABLE bronze.products (
	product_id INT,
	product_name NVARCHAR(200),
	aisle_id INT,
	department_id INT
);

