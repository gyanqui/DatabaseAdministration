-- FIRST SCENARIO
-- SET TO SIMPLE RECOVERY MODEL
ALTER DATABASE [BowlingLeagueExample]
SET RECOVERY SIMPLE;
GO

BACKUP DATABASE [BowlingLeagueExample] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\Bowling.bak' 
WITH NOFORMAT, INIT,  NAME = N'BowlingLeagueExample-Full Database Backup', STATS = 10
GO

BACKUP DATABASE [BowlingLeagueExample] 
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\Bowling.dff' 
WITH  DIFFERENTIAL , NOFORMAT, INIT,  NAME = N'BowlingLeagueExample-Full Database Backup', STATS = 10
GO


-- Insert new player
INSERT INTO PlayerData.Bowlers(BowlerID, BowlerFirstName, BowlerLastName, TeamID)
VALUES (199, 'Gabriel', 'Yanqui', 3);
SELECT GETDATE();
--2024-10-31 02:36:44.007

-- Insert new player
INSERT INTO PlayerData.Bowlers(BowlerID, BowlerFirstName, BowlerLastName, TeamID)
VALUES (200, 'Angel', 'Alvarez', 3);
SELECT GETDATE();
--2024-10-31 02:37:01.830

-- Delete a player
DELETE FROM PlayerData.Bowlers
WHERE BowlerID = 199 OR BowlerID = 200;
SELECT GETDATE();
--2024-10-31 02:38:08.573


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
