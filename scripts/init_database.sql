/* 
=============================================================
Create Database and Schemas
=============================================================
Script use:
  This script creates a new database name 'Project' after checking if it already exists. If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas within the database: 'bronze', 'silver' and 'gold'.

WARNING:
  Running this script will drop the entire 'Project' database if it exists. All data in the database will be permenently deleted. Proceed with caution and ensure you have proper backups before running this script.
*/

USE master;
GO

--Drop and recreate the 'Project' database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Project')
BEGIN
	ALTER DATABASE Project SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Project;
END;
GO

--Create the 'DataWarehouse' database
CREATE DATABASE Project;
GO

USE Project;
GO

--Create Schemas
CREATE SCHEMA bronze;
GO
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
