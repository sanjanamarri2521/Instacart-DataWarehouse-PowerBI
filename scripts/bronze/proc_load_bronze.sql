/*
======================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
======================================================
Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the bronze tables before loading data
  - Uses the 'BULK INSERT' command to load data from CSV files to bronze tables

Parameters:
    None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time	DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '======================================';
		PRINT 'Loading Bronze Layer';
		PRINT '======================================';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.aisles';
		TRUNCATE TABLE bronze.aisles;

		PRINT '>> Inserting Data Into: bronze.aisles';
		BULK INSERT bronze.aisles
		FROM 'C:\Users\sanja\Desktop\New folder\datasets\aisles.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.departments';
		TRUNCATE TABLE bronze.departments;

		PRINT '>> Inserting Data Into: bronze.departments';
		BULK INSERT bronze.departments
		FROM 'C:\Users\sanja\Desktop\New folder\datasets\departments.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.order_products_prior';
		TRUNCATE TABLE bronze.order_products_prior;

		PRINT '>> Inserting Data Into: bronze.order_products_prior';
		BULK INSERT bronze.order_products_prior
		FROM 'C:\Users\sanja\Desktop\New folder\datasets\order_products__prior.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.order_products_train';
		TRUNCATE TABLE bronze.order_products_train;

		PRINT '>> Inserting Data Into: bronze.order_products_train';
		BULK INSERT bronze.order_products_train
		FROM 'C:\Users\sanja\Desktop\New folder\datasets\order_products__train.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.orders';
		TRUNCATE TABLE bronze.orders;

		PRINT '>> Inserting Data Into: bronze.orders';
		BULK INSERT bronze.orders
		FROM 'C:\Users\sanja\Desktop\New folder\datasets\orders.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.products';
		TRUNCATE TABLE bronze.products;

		PRINT '>> Inserting Data Into: bronze.products';
		BULK INSERT bronze.products
		FROM 'C:\Users\sanja\Desktop\New folder\datasets\products_pipe.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '========================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '	- Total Load Duration: ' +	CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '========================================';
	END TRY
	BEGIN CATCH
		PRINT '======================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' +	CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '======================================';
	END CATCH
END
