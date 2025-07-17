/*
======================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
======================================================
Script Purpose:
	This stored procedure performs the ETL (Extract, transform, Load) process to populate the 'silver' schema tables from the 'bronze' schema.
   Actions Performed:
   - Truncates Silver tables
   - Inserts transformed and cleansed data from Bronze into Silver tables

Parameters:
	None.
	This stored procedure does not accept any parameters or return any values.

Usage Example:
	EXEC silver.load_silver;
======================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time	DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '======================================';
		PRINT 'Loading Silver Layer';
		PRINT '======================================';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.aisles';
		TRUNCATE TABLE silver.aisles;

		PRINT '>> Inserting Data Into: silver.aisles';

		INSERT INTO silver.aisles (aisle_id, aisle)
		SELECT aisle_id, aisle FROM bronze.aisles --No changes

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.departments';
		TRUNCATE TABLE silver.departments;

		PRINT '>> Inserting Data Into: silver.departments';
		
		INSERT INTO silver.departments (department_id, department)
		SELECT department_id, department FROM bronze.departments
		
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.order_products';
		TRUNCATE TABLE silver.order_products;

		PRINT '>> Inserting Data Into: silver.order_products';
		
		INSERT INTO silver.order_products (order_id, product_id, add_to_cart_order, reordered)
		SELECT order_id, product_id, add_to_cart_order, reordered
		FROM bronze.order_products_prior
		UNION ALL
		SELECT order_id, product_id, add_to_cart_order, reordered
		FROM bronze.order_products_train
		
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.orders';
		TRUNCATE TABLE silver.orders;

		PRINT '>> Inserting Data Into: silver.orders';
		
		INSERT INTO silver.orders (order_id, user_id, eval_set, order_number, order_dow, order_hour_of_day, days_since_prior_order)
		SELECT 
		order_id,
		user_id,
		eval_set,
		order_number,
		CASE WHEN order_dow = '0' THEN 'Sunday'
			 WHEN order_dow = '1' THEN 'Monday'
			 WHEN order_dow = '2' THEN 'Tuesday'
			 WHEN order_dow = '3' THEN 'Wednesday'
			 WHEN order_dow = '4' THEN 'Thursday'
			 WHEN order_dow = '5' THEN 'Friday'
			 WHEN order_dow = '6' THEN 'Saturday'
			 ELSE 'n/a'
		END AS order_dow,
		order_hour_of_day,
		days_since_prior_order
		FROM bronze.orders


		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.products';
		TRUNCATE TABLE silver.products;

		PRINT '>> Inserting Data Into: silver.products';
		
		INSERT INTO silver.products (product_id, product_name, aisle_id, department_id)
		SELECT 
		product_id, product_name, aisle_id, department_id
		FROM bronze.products
		
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '========================================';
		PRINT 'Loading Silver Layer is Completed';
		PRINT '	- Total Load Duration: ' +	CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '========================================';
	END TRY
	BEGIN CATCH
		PRINT '======================================';
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' +	CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================';
	END CATCH
END
