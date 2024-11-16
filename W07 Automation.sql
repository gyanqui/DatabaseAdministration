-- Create a SQL Authenticated login for Ralph and add it to the sysadmin server role.

USE [master]
GO
CREATE LOGIN [ralph] WITH PASSWORD=N'password' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [ralph]
GO

-- Create a query to list the name of each account with sysadmin privileges and the last modified date of that login.
SELECT 
    sp.name AS LoginName,
    sp.modify_date AS LastModifiedDate
FROM 
    sys.server_principals sp
JOIN 
    sys.server_role_members srm ON sp.principal_id = srm.member_principal_id
JOIN 
    sys.server_principals sr ON srm.role_principal_id = sr.principal_id
WHERE 
    sr.name = 'sysadmin';


-- Create Table
DROP TABLE IF EXISTS audit_sysadmin_users;

CREATE TABLE audit_sysadmin_users (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    LoginName NVARCHAR(120),
    CreatedDate DATETIME,
    LastModifiedDate DATETIME,
);

-- INSERT logins with sysadmin role
INSERT INTO audit_sysadmin_users (LoginName, CreatedDate, LastModifiedDate)
SELECT 
    sp.name AS LoginName,
    sp.create_date AS CreatedDate,
    sp.modify_date AS LastModifiedDate
FROM 
    sys.server_principals sp
JOIN 
    sys.server_role_members srm ON sp.principal_id = srm.member_principal_id
JOIN 
    sys.server_principals sr ON srm.role_principal_id = sr.principal_id
WHERE 
    sr.name = 'sysadmin';


-- Create 3 new users with sysadmin role
USE [master]
GO
CREATE LOGIN [user1] WITH PASSWORD=N'password' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [user1]
GO
CREATE LOGIN [user2] WITH PASSWORD=N'password' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [user2]
GO
CREATE LOGIN [user3] WITH PASSWORD=N'password' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [user3]
GO
CREATE LOGIN [user4] WITH PASSWORD=N'password' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [user4]
GO





--Code to create JOB with 2 steps Create table and insert data
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'check_sysadmin_users', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'GABS\ACER', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'check_sysadmin_users', @server_name = N'GABS\MSSQLSERVER2'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'check_sysadmin_users', @step_name=N'create_sysadmin_users_table', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DROP TABLE IF EXISTS audit_sysadmin_users;



CREATE TABLE audit_sysadmin_users (
   
	AuditID INT IDENTITY(1,1) PRIMARY KEY,
    
	LoginName NVARCHAR(120),
    
	CreatedDate DATETIME,
    
	LastModifiedDate DATETIME,
);', 
		@database_name=N'msdb', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'check_sysadmin_users', @step_name=N'insert_sysadmin_users', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO audit_sysadmin_users (
	LoginName, 
	CreatedDate, 
	LastModifiedDate)


SELECT 
    
	sp.name AS LoginName,
    
	sp.create_date AS CreatedDate,
    
	sp.modify_date AS LastModifiedDate

FROM 
    
	sys.server_principals sp

JOIN 
    
	sys.server_role_members srm ON sp.principal_id = srm.member_principal_id

JOIN 
    
	sys.server_principals sr ON srm.role_principal_id = sr.principal_id

WHERE 
    
	sr.name = ''sysadmin'';
', 
		@database_name=N'msdb', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'check_sysadmin_users', 
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
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'check_sysadmin_users', @name=N'weekly_review', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=2, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20241107, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
