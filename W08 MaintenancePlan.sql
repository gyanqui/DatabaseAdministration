
--QUERY TO RETRIEVE BACKUP INFORMATION
SELECT 
    CASE 
        WHEN b.type = 'D' THEN 'Full'
        WHEN b.type = 'I' THEN 'Differential'
        WHEN b.type = 'L' THEN 'Log'
        ELSE 'Other'
    END AS BackupType,
    b.database_name,
    CASE 
        WHEN b.is_copy_only = 1 THEN 'Copy-Only'
        ELSE 'Regular'
    END AS BackupStatus,
    b.backup_start_date,
    b.backup_finish_date,
    CAST(b.backup_size / 1048576.0 AS DECIMAL(10, 2)) AS BackupSizeMB
FROM msdb.dbo.backupset b
ORDER BY b.backup_start_date DESC;


-- CREATE TABLE TO STORE BACKUP INFORMATION
DROP TABLE IF EXISTS dbo.BackupLogs;

CREATE TABLE dbo.BackupLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    BackupType VARCHAR(50),
    DatabaseName VARCHAR(100),
    BackupStatus VARCHAR(50),
    BackupStart DATETIME,
    BackupEnd DATETIME,
    BackupSizeMB FLOAT
);


-- INSERT STATEMENT
INSERT INTO dbo.BackupLogs (BackupType, DatabaseName, BackupStatus, BackupStart, BackupEnd, BackupSizeMB)
SELECT 
    CASE 
        WHEN b.type = 'D' THEN 'Full'
        WHEN b.type = 'I' THEN 'Differential'
        WHEN b.type = 'L' THEN 'Log'
        ELSE 'Other'
    END AS BackupType,
    b.database_name,
    CASE 
        WHEN b.is_copy_only = 1 THEN 'Copy-Only'
        ELSE 'Regular'
    END AS BackupStatus,
    b.backup_start_date,
    b.backup_finish_date,
    CAST(b.backup_size / 1048576.0 AS DECIMAL(10, 2)) AS BackupSizeMB
FROM msdb.dbo.backupset b
ORDER BY b.backup_start_date DESC;



--CODE TO CREATE CHECK_DATABASE_BACKUP JOB

USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'check_database_backup', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'GABS\ACER', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'check_database_backup', @server_name = N'GABS\MSSQLSERVER2'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'check_database_backup', @step_name=N'create_backup_table', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DROP TABLE IF EXISTS dbo.BackupLogs;



CREATE TABLE dbo.BackupLogs (
    
	LogID INT PRIMARY KEY IDENTITY(1,1),
    
	BackupType VARCHAR(50),
    
	DatabaseName VARCHAR(100),
    
	BackupStatus VARCHAR(50),
    
	BackupStart DATETIME,
    
	BackupEnd DATETIME,
    
	BackupSizeMB FLOAT
);', 
		@database_name=N'msdb', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'check_database_backup', @step_name=N'insert_backup_data', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO dbo.BackupLogs (BackupType, DatabaseName, BackupStatus, BackupStart, BackupEnd, BackupSizeMB)
SELECT 
    CASE 
        WHEN b.type = ''D'' THEN ''Full''
        WHEN b.type = ''I'' THEN ''Differential''
        WHEN b.type = ''L'' THEN ''Log''
        ELSE ''Other''
    END AS BackupType,
    b.database_name,
    CASE 
        WHEN b.is_copy_only = 1 THEN ''Copy-Only''
        ELSE ''Regular''
    END AS BackupStatus,
    b.backup_start_date,
    b.backup_finish_date,
    CAST(b.backup_size / 1048576.0 AS DECIMAL(10, 2)) AS BackupSizeMB
FROM msdb.dbo.backupset b
ORDER BY b.backup_start_date DESC;', 
		@database_name=N'msdb', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'check_database_backup', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'GABS\ACER', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'check_database_backup', @name=N'weekly_backup_report', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20241111, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
