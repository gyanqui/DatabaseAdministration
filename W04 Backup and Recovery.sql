-- 1 Use the data dictionary to write a query to find out when the last time all of your databases were backed up. 

-- SHOW 1: 
-- Your query and the results.
SELECT bs.database_name,
    backuptype = CASE 
        WHEN bs.type = 'D' AND bs.is_copy_only = 0 THEN 'Full Database'
        WHEN bs.type = 'D' AND bs.is_copy_only = 1 THEN 'Full Copy-Only Database'
        WHEN bs.type = 'I' THEN 'Differential database backup'
        WHEN bs.type = 'L' THEN 'Transaction Log'
        WHEN bs.type = 'F' THEN 'File or filegroup'
        WHEN bs.type = 'G' THEN 'Differential file'
        WHEN bs.type = 'P' THEN 'Partial'
        WHEN bs.type = 'Q' THEN 'Differential partial'
        END + ' Backup',
    CASE bf.device_type
        WHEN 2 THEN 'Disk'
        WHEN 5 THEN 'Tape'
        WHEN 7 THEN 'Virtual device'
        WHEN 9 THEN 'Azure Storage'
        WHEN 105 THEN 'A permanent backup device'
        ELSE 'Other Device'
        END AS DeviceType,
    bms.software_name AS backup_software,
    bs.recovery_model,
    bs.compatibility_level,
    BackupStartDate = bs.Backup_Start_Date,
    BackupFinishDate = bs.Backup_Finish_Date,
    LatestBackupLocation = bf.physical_device_name,
    backup_size_mb = CONVERT(DECIMAL(10, 2), bs.backup_size / 1024. / 1024.),
    compressed_backup_size_mb = CONVERT(DECIMAL(10, 2), bs.compressed_backup_size / 1024. / 1024.),
    database_backup_lsn, -- For tlog and differential backups, this is the checkpoint_lsn of the FULL backup it is based on.
    checkpoint_lsn,
    begins_log_chain,
    bms.is_password_protected
FROM msdb.dbo.backupset bs
LEFT JOIN msdb.dbo.backupmediafamily bf
    ON bs.[media_set_id] = bf.[media_set_id]
INNER JOIN msdb.dbo.backupmediaset bms
    ON bs.[media_set_id] = bms.[media_set_id]
WHERE bs.backup_start_date > DATEADD(MONTH, - 2, sysdatetime()) --only look at last two months
ORDER BY bs.database_name ASC,
    bs.Backup_Start_Date DESC;
	
-- 2 Make new backups for ALL of your user databases (not system databases).

-- SHOW 2: 
-- I. The method you used to backup the databases.

BACKUP DATABASE [BowlingLeagueExample] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\BowlingLeagueExample.bak' WITH NOFORMAT, NOINIT,  NAME = N'BowlingLeagueExample-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE [EntertainmentAgencyExample] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\EntertainmentAgencyExample.bak' WITH NOFORMAT, NOINIT,  NAME = N'EntertainmentAgencyExample-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE [RecipesExample] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\RecipesExample.bak' WITH NOFORMAT, NOINIT,  NAME = N'RecipesExample-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE [SalesOrdersExample] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\SalesOrdersExample.bak' WITH NOFORMAT, NOINIT,  NAME = N'SalesOrdersExample-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE [SchoolSchedulingExample] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\SchoolSchedulingExample.bak' WITH NOFORMAT, NOINIT,  NAME = N'SchoolSchedulingExample-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE [WideWorldImporters] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\WideWorldImporters-Full.bak' WITH NOFORMAT, NOINIT,  NAME = N'WideWorldImporters-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- II. Re-run the query from step one, proving that you now have recent backups.



--3 You decide to make copies of the bowling database for test purposes:
--Restore the bowling database using your backup from step 2. However, 
--you should restore it within your instance with the new name, 
--"bowling_TEST." Be sure the internal database file names are also 
--changed as part of the restore.

--Use the videos this week to login to the class server in the cloud and 
--restore it there also. You will consider this copy to be a development 
--version. Change the name of the bowling database to start with your 
--last name such as "jones_bowling_development." Again be sure to change 
--your file names.

--SHOW 3 (screenshot examples): 

--The process you used to copy the database as a “test” version. Show that the new copy exists.
USE [master]
RESTORE DATABASE [bowling_TEST] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\BowlingLeagueExample.bak' WITH  FILE = 1,  MOVE N'BowlingLeagueExample' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\DATA\bowling_TEST.mdf',  MOVE N'BowlingLeagueExample_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\DATA\bowling_TEST_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5

GO

--The process you used to copy the database as a “development” version. Show that this copy exists in the cloud.

USE [master]
RESTORE DATABASE [yanqui_bowling_development] FROM  DISK = N'/home/yanqui_bowling_development.bak' WITH  FILE = 1,  MOVE N'BowlingLeagueExample' TO N'/var/opt/mssql/data/yanqui_bowling_development.mdf',  MOVE N'BowlingLeagueExample_log' TO N'/var/opt/mssql/data/yanqui_bowling_development_log.ldf',  NOUNLOAD,  STATS = 5

GO


-- SHOW 4:

-- Your bcp export files created in step b for the Bowler_scores and Bowlers tables. 

-- You have deleted all rows in the Bowler_scores and Bowlers tables.

 -- Successful import messages from step d and that you once again have data in those two tables.


USE BowlingLeagueExample;
select * from GameData.Bowler_Scores;
select * from PlayerData.Bowlers;

SELECT COUNT(*) FROM GameData.Bowler_Scores;
SELECT COUNT(*) FROM PlayerData.Bowlers;

DELETE FROM GameData.Bowler_Scores;
DELETE FROM PlayerData.Bowlers;
