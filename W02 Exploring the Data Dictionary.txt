-- Week 2 Assignment

-- SHOW 1: Your queries and query results. The results should include the names of
-- all user tables in each database, when each was created, and last modified date.
-- WideWorldImporters, BowlingLeagueExample, SchoolScheduling

USE WideWorldImporters
SELECT 
	name, 
	create_date, 
	modify_date
FROM 
	sys.tables;

USE BowlingLeagueExample
SELECT 
	name, 
	create_date, 
	modify_date
FROM 
	sys.tables;

USE SchoolSchedulingExample
SELECT 
	name, 
	create_date, 
	modify_date
FROM 
	sys.tables;

-- SHOW 2: Your queries and query results for each of the three databases. The 
-- results should include: the name of the column, the name of the table the 
-- column belongs to, and the current maximum length for that column.

USE WideWorldImporters
SELECT 
    c.name AS ColumnName,
    t.name AS TableName,
    c.max_length AS MaximumLength
FROM 
    sys.columns AS c
JOIN 
    sys.tables AS t ON c.object_id = t.object_id
WHERE 
    c.name LIKE '%name%'; 

USE BowlingLeagueExample
SELECT 
    c.name AS ColumnName,
    t.name AS TableName,
    c.max_length AS MaximumLength
FROM 
    sys.columns AS c
JOIN 
    sys.tables AS t ON c.object_id = t.object_id
WHERE 
    c.name LIKE '%name%'; 

USE SchoolSchedulingExample
SELECT 
    c.name AS ColumnName,
    t.name AS TableName,
    c.max_length AS MaximumLength
FROM 
    sys.columns AS c
JOIN 
    sys.tables AS t ON c.object_id = t.object_id
WHERE 
    c.name LIKE '%name%'; 

-- SHOW 3
-- Part i: Queries and results which list the file name, file location, and file size 
-- (as listed in the database_files catalog view without conversion) of any file 
-- greater than or equal to size 1024.

USE master
SELECT 
	mf.name,
	d.name,
    mf.physical_name AS FileLocation, 
    mf.size,
	(mf.size * 8) / 1024 AS FileSize
FROM 
	sys.master_files AS mf
JOIN sys.databases AS d ON d.database_id = mf.database_id
WHERE 1=1 
	AND mf.size >= 1024
	AND d.name IN ('WideWorldImporters', 'BowlingLeagueExample', 'SchoolSchedulingExample');

-- Part ii: Queries and results which list the full size of each database in MB.
-- You will have to add the size for each database file using the SUM functionLinks
-- to an external site. and then include the calculations from the hint above.
-- (Video reviewLinks to an external site. on using math in your SQL.)

USE master
SELECT 
	d.name,
	SUM(( mf.size * 8) / 1024) AS FileSize
FROM 
	sys.master_files AS mf
JOIN sys.databases AS d ON d.database_id = mf.database_id
WHERE
	d.name IN ('WideWorldImporters', 'BowlingLeagueExample', 'SchoolSchedulingExample')
GROUP BY d.name;

-- Part iii: Show the screen in your Windows explorer where you navigate to the folder
-- which holds the files (listed in your query from part i). Identify them and compare
-- them to your results from steps i and ii. Your calculations from step ii should 
-- match what you see in Windows!

USE master
SELECT 
	mf.name,
	d.name,
    mf.physical_name AS FileLocation, 
    mf.size,
	(mf.size * 8) / 1024 AS FileSize
FROM 
	sys.master_files AS mf
JOIN sys.databases AS d ON d.database_id = mf.database_id
WHERE 1=1 
	AND mf.size >= 1024
	AND d.name IN ('WideWorldImporters', 'BowlingLeagueExample', 'SchoolSchedulingExample');


-- SHOW 4 :  The two items you discovered in the data dictionary and the corresponding 
-- query results. Explain why you believe these would be important to keep an eye on.


-- sys.objects
USE SchoolSchedulingExample
SELECT object_id, name, type, create_date, modify_date
FROM sys.objects
WHERE type = 'U'
ORDER BY object_id;



-- is_nullable and information_schema.columns
USE SchoolSchedulingExample;
SELECT table_name, column_name, is_nullable
FROM information_schema.columns
ORDER BY table_name;

