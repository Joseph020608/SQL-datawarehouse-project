-- Explore ALL objects in the database
USE DataWarehouse;
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore ALL columns in the database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';	-- Filter to see the columns of X table
