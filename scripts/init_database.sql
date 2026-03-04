/*
--------------------------------
Create database and schemas
--------------------------------
This script checks if DataWarehouse database exists. If it does, it is going to 
be dropped in order to create the database from scratch along with the schemas.

WARNING!!!
Running this script will drop the entire DataWarehouse database if it exists.
All data from the database will be deleted. Proceed with caution and ensure 
you have backups before running this script.
*/

USE master;
GO

-- Check if the database exists and recreates it from scratch

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse
END;
GO

--Create the database

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create schemas

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
