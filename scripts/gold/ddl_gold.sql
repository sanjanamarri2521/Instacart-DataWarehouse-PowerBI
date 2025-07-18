/*
===================================================
DDL Script: Create Gold Views
===================================================
Script Purpose:
	This script creates views for the Gold Layer in the data warehouse.
	The Gold layer represents the final dimension and fact tables (Star Schema)

	Each view performs tranformations and combines data from the Silver layer to produce a clean, enriched, and business-ready dataset
Usage:
	- These views can be queried directly for analytics and reporting.
===================================================
*/
-- ================================================
-- Create Dimension Table: gold.dim_users
-- ================================================
DROP VIEW IF EXISTS gold.dim_users;
GO
CREATE VIEW gold.dim_users AS
SELECT DISTINCT
    user_id
FROM silver.orders;
GO

-- ================================================
-- Create Dimension Table: gold.dim_products
-- ================================================
DROP VIEW IF EXISTS gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT DISTINCT
    product_id,
    product_name,
    department_id,
    aisle_id
FROM silver.products;
GO

-- ================================================
-- Create Dimension Table: gold.dim_departments
-- ================================================
DROP VIEW IF EXISTS gold.dim_departments;
GO
CREATE VIEW gold.dim_departments AS
SELECT DISTINCT
    department_id,
    department
FROM silver.departments;
GO

-- ================================================
-- Create Dimension Table: gold.dim_aisles
-- ================================================
DROP VIEW IF EXISTS gold.dim_aisles;
GO
CREATE VIEW gold.dim_aisles AS
SELECT DISTINCT
    aisle_id,
    aisle
FROM silver.aisles;
GO

-- ================================================
-- Create Fact Table: gold.fact_orders_flat
-- ================================================
DROP VIEW IF EXISTS gold.fact_orders_flat;
GO
CREATE VIEW gold.fact_orders_flat AS
SELECT 
    o.user_id,
	o.order_id,
    o.order_number,
    o.order_dow AS order_day_name,
    o.order_hour_of_day AS order_hour,
    o.days_since_prior_order,
    p.product_id,
    p.product_name,
    a.aisle_id,
    a.aisle,
    d.department_id,
    d.department,
    op.reordered
FROM silver.order_products op 
LEFT JOIN silver.orders o ON op.order_id = o.order_id
LEFT JOIN silver.products p ON op.product_id = p.product_id
LEFT JOIN silver.aisles a ON p.aisle_id = a.aisle_id
LEFT JOIN silver.departments d ON p.department_id = d.department_id;
GO

-- ================================================
-- Create Fact Table: gold.fact_product_stats
-- ================================================
DROP VIEW IF EXISTS gold.fact_product_stats;
GO
CREATE VIEW gold.fact_product_stats AS
SELECT 
    p.product_id,
    p.product_name,
	d.department,
    a.aisle,
    COUNT(*) AS total_orders,
    SUM(op.reordered) AS total_reorders,
    ROUND(CAST(SUM(op.reordered) AS FLOAT) / COUNT(*), 2) AS reorder_rate    
FROM silver.order_products op
JOIN silver.products p ON op.product_id = p.product_id
JOIN silver.departments d ON p.department_id = d.department_id
JOIN silver.aisles a ON p.aisle_id = a.aisle_id
GROUP BY 
    p.product_id,
    p.product_name,
    d.department,
    a.aisle;
GO

-- ================================================
-- Create Fact Table: gold.fact_user_order_summary
-- ================================================
DROP VIEW IF EXISTS gold.fact_user_order_summary;
GO
CREATE VIEW gold.fact_user_order_summary AS
SELECT 
    o.user_id,
    MAX(o.order_number) AS total_orders,
    AVG(o.days_since_prior_order) AS avg_days_between_orders,
    COUNT(p.product_id) AS total_products_ordered,
    SUM(p.reordered) AS total_reordered,
    1.0 * SUM(p.reordered) / COUNT(p.product_id) AS reorder_ratio
FROM silver.orders o
JOIN silver.order_products p ON o.order_id = p.order_id
GROUP BY o.user_id;
GO

