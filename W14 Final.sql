/*****************************************
******************************************
STEP 3
******************************************
******************************************/
-- Step for JOB
BACKUP DATABASE [BikeStores] TO  DISK = N'/var/opt/mssql/data/BikeStores.bak' WITH NOFORMAT, NOINIT,  NAME = N'BikeStores-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


/*****************************************
******************************************
STEP 4
******************************************
******************************************/
USE [BikeStores];
GO

-- Create new schemas
CREATE SCHEMA [product];
GO
CREATE SCHEMA [inventory];
GO

-- Move tables to product schema
ALTER SCHEMA product TRANSFER production.brands;
ALTER SCHEMA product TRANSFER production.products;

-- Move tables to the 'inventory' schema
ALTER SCHEMA inventory TRANSFER production.categories;
ALTER SCHEMA inventory TRANSFER production.stocks;


-- CREATE  a user final_test_user
USE [master];
GO
CREATE LOGIN [final_test_user] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

-- CREATE LOGIN USER For BowlingLeagueExample table
USE [BikeStores];
GO
CREATE USER [final_test_user] FOR LOGIN [final_test_user];
GO

-- Grant SELECT permissions for BowlingLeagueExample
USE [BikeStores];
GO
GRANT SELECT ON SCHEMA::[product] TO [final_test_user];
GO

-- TEST NUMBER 4
SELECT TOP (1000) [brand_id]
      ,[brand_name]
  FROM [BikeStores].[product].[brands]

  SELECT TOP (1000) [category_id]
      ,[category_name]
  FROM [BikeStores].[inventory].[categories]


/*****************************************
******************************************
STEP 5
******************************************
******************************************/

-- Create a view that combines (joins) data from two tables
USE [BikeStores];
GO

-- Create a view in the 'product' schema that joins 'product.products' with 'inventory.categories'
CREATE VIEW product.product_categories AS
SELECT 
    p.product_id,
    p.product_name,
    p.list_price,
    p.model_year,
    c.category_name
FROM product.products AS p
JOIN inventory.categories AS c ON p.category_id = c.category_id;
GO

-- Grant SELECT permission on the view to a specific user account (assuming the user account is named 'dbUser')
GRANT SELECT ON product.product_categories TO [final_test_user];
GO

/*****************************************
******************************************
STEP 6
******************************************
******************************************/
-- Create a new role 
CREATE ROLE DCLRole;
-- Grant permissions to the NewEmployees role
GRANT SELECT ON SCHEMA::[product] TO DCLRole;
GRANT SELECT ON product.product_categories TO DCLRole;

--Create new final_running_buddy user
USE [master];
GO
CREATE LOGIN [final_running_buddy] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [BikeStores];
GO
CREATE USER final_running_buddy FOR LOGIN final_running_buddy;
GO
ALTER ROLE DCLRole ADD MEMBER final_running_buddy;
GO

-- List all roles in the database
USE [BikeStores];
GO
SELECT name, type_desc 
FROM sys.database_principals 
WHERE type_desc = 'DATABASE_ROLE';

/*****************************************
******************************************
STEP 7
******************************************
******************************************/
-- Test encryption
SELECT TOP (1000) [product_id]
      ,[product_name]
      ,[brand_id]
      ,[category_id]
      ,[model_year]
      ,[list_price]
  FROM [BikeStores].[product].[products]

/*****************************************
******************************************
STEP 8
******************************************
******************************************/
-- Set a Full Recovery Model for BikeStores database


-- SECOND SCENARIO
-- SET TO FULL RECOVERY MODEL
ALTER DATABASE [WideWorldImporters]
SET RECOVERY FULL;
GO

BACKUP DATABASE [WideWorldImporters] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\WideWorldImporters.bak' 
WITH NOFORMAT, INIT,  NAME = N'WideWorldImporters-Full Database Backup', STATS = 10
GO

BACKUP DATABASE [WideWorldImporters] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\WideWorldImporters.dff' 
WITH  DIFFERENTIAL , NOFORMAT, INIT,  NAME = N'WideWorldImporters-Full Database Backup', STATS = 10
GO

  -- Insert 
INSERT INTO Warehouse.StockItemStockGroups (StockItemID, StockGroupID, LastEditedBy)
VALUES (1, 2, 1);  
SELECT GETDATE();
--

BACKUP LOG [WideWorldImporters] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\WorldWideImporters.trn' 
WITH NOFORMAT, INIT,  NAME = N'WideWorldImporters-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Update 
UPDATE Warehouse.StockItemStockGroups
SET LastEditedBy = 2 
WHERE StockItemID = 1 AND StockGroupID = 2;
SELECT GETDATE();
--2024-10-31 04:34:37.427

BACKUP LOG [WideWorldImporters] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\WorldWideImporters.trn2' 
WITH NOFORMAT, INIT,  NAME = N'WideWorldImporters-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Delete
DELETE FROM Warehouse.StockItemStockGroups
WHERE StockItemID = 1 AND StockGroupID = 2;
SELECT GETDATE();
--2024-10-31 04:35:03.503







