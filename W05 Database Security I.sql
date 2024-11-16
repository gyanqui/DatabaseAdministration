--SHOW 1 
ALTER TABLE PlayerData.Bowlers
ADD 
	BowlerEmailAddress VARCHAR(50) NULL;


--Update statement when you feel the code is correct
UPDATE b SET
	b.BowlerEmailAddress = LOWER(CONCAT(TRIM(b.BowlerFirstName),TRIM(b.BowlerLastName), '@gmail.com'))
	FROM PlayerData.Bowlers AS b;

-- SHOW 1: The contents of the bowlers table with the new email addresses you added.
USE BowlingLeagueExample;

SELECT
	*
FROM
	PlayerData.Bowlers;

-- SHOW 2
-- Create a viewLinks to an external site. that displays all other information in the 
-- "bowlers" table except for street address, phone number and email address for each bowler.

CREATE VIEW PlayerData.BowlerInformation
AS
SELECT
	BowlerID,
	BowlerLastName,
	BowlerMiddleInit,
	BowlerFirstName,
	BowlerCity,
	BowlerState,
	BowlerZip,
	TeamID
FROM
	PlayerData.Bowlers;

--SHOW 2
--CREATE NEW LOGIN bob_the_scorekeeper
USE [master]
GO
CREATE LOGIN [bob_the_scorekeeper] WITH PASSWORD=N'password' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO;

--GRANT SELECT ACCESS TO bob_the_scorekeeper
USE [BowlingLeagueExample]
GO
GRANT SELECT ON [PlayerData].[BowlerInformation] TO [bob_the_scorekeeper];
GO

--SHOW 2
SELECT TOP (1000) [BowlerID]
      ,[BowlerLastName]
      ,[BowlerMiddleInit]
      ,[BowlerFirstName]
      ,[BowlerCity]
      ,[BowlerState]
      ,[BowlerZip]
      ,[TeamID]
  FROM [BowlingLeagueExample].[PlayerData].[BowlerInformation]

 --  Test Insert permission
INSERT INTO [BowlingLeagueExample].[PlayerData].[BowlerInformation]
    ([BowlerID], [BowlerLastName], [BowlerFirstName], [BowlerMiddleInit], [BowlerCity], [BowlerState], [BowlerZip], [TeamID])
VALUES 
    (33, 'Yanqui', 'Gabriel', 'C', 'City', 'BC', '12345', 3);

 --  Test Delete permission
DELETE FROM [BowlingLeagueExample].[PlayerData].[BowlerInformation]
WHERE [BowlerID] = 1;

--SHOW 3
--CREATE NEW LOGIN carol_the_programmer
USE [master]
GO
CREATE LOGIN [carol_the_programmer] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

--GRANT SELECT ACCESS TO carol_the_programmer
USE [BowlingLeagueExample]
GO
--CREATE USER
CREATE USER [carol_the_programmer] FOR LOGIN [carol_the_programmer];
GO
GRANT SELECT ON [PlayerData].[Bowlers] TO [carol_the_programmer];
GO
GRANT INSERT ON [PlayerData].[Bowlers] TO [carol_the_programmer];
GO

--SHOW 3
--TEST
SELECT * FROM PlayerData.Bowlers;
 --  Test Insert permission
INSERT INTO [BowlingLeagueExample].[PlayerData].[Bowlers] 
    ([BowlerID], [BowlerLastName], [BowlerFirstName], [BowlerMiddleInit], [BowlerCity], [BowlerState], [BowlerZip], [TeamID])
VALUES 
    (34, 'Yanqui', 'Gabriel', 'A', 'City', 'BC', '12345', 2);

 --  Test Delete permission
DELETE FROM [BowlingLeagueExample].[PlayerData].[Bowlers]
WHERE [BowlerID] = 34;



--SHOW 4
-- SHOW 4
--RECREATE STEPS 1-3 on the cloud class server 

ALTER TABLE PlayerData.Bowlers
ADD 
	BowlerEmailAddress VARCHAR(50) NULL;


--Update statement when you feel the code is correct
UPDATE b SET
	b.BowlerEmailAddress = LOWER(CONCAT(TRIM(b.BowlerFirstName),TRIM(b.BowlerLastName), '@gmail.com'))
	FROM PlayerData.Bowlers AS b;

-- SHOW 1: The contents of the bowlers table with the new email addresses you added.

SELECT
	*
FROM
	PlayerData.Bowlers;


-- Create a viewLinks to an external site. that displays all other information in the 
-- "bowlers" table except for street address, phone number and email address for each bowler.

CREATE VIEW PlayerData.BowlerInformation
AS
SELECT
	BowlerID,
	BowlerLastName,
	BowlerMiddleInit,
	BowlerFirstName,
	BowlerCity,
	BowlerState,
	BowlerZip,
	TeamID
FROM
	PlayerData.Bowlers;

USE [master]
GO
CREATE LOGIN [bob_yanqui_the_scorekeeper] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [yanqui_bowling_development]
GO
--CREATE USER
CREATE USER [bob_yanqui_the_scorekeeper] FOR LOGIN [bob_yanqui_the_scorekeeper];
GO
GRANT SELECT ON [PlayerData].[BowlerInformation] TO [bob_yanqui_the_scorekeeper];
GO


--SHOW 3
--CREATE NEW LOGIN carol_the_programmer
USE [master]
GO
CREATE LOGIN [carol_yanqui_the_programmer] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

--GRANT SELECT ACCESS TO carol_the_programmer
USE [yanqui_bowling_development]
GO
--CREATE USER
CREATE USER [carol_yanqui_the_programmer] FOR LOGIN [carol_yanqui_the_programmer];
GO
GRANT SELECT ON [PlayerData].[Bowlers] TO [carol_yanqui_the_programmer];
GO
GRANT INSERT ON [PlayerData].[Bowlers] TO [carol_yanqui_the_programmer];
GO

--TEST BUDDY bob login accesses
SELECT TOP (1000) [BowlerID]
      ,[BowlerLastName]
      ,[BowlerFirstName]
      ,[BowlerMiddleInit]
      ,[BowlerCity]
      ,[BowlerState]
      ,[BowlerZip]
      ,[TeamID]
  FROM [allred_bowling_development].[Bowlers].[scorekeeper]

-- test
INSERT INTO [allred_bowling_development].[Bowlers].[scorekeeper] 
    ([BowlerLastName], [BowlerFirstName], [BowlerMiddleInit], [BowlerCity], [BowlerState], [BowlerZip], [TeamID])
VALUES 
    ('Smith', 'Jane', 'B', 'BowlingCity', 'BC', '98765', 2);


--TEST BUDDY carol login accesses
SELECT TOP (1000) [BowlerID]
      ,[BowlerLastName]
      ,[BowlerFirstName]
      ,[BowlerMiddleInit]
      ,[BowlerAddress]
      ,[BowlerCity]
      ,[BowlerState]
      ,[BowlerZip]
      ,[BowlerPhoneNumber]
      ,[TeamID]
      ,[email]
  FROM [allred_bowling_development].[Bowlers].[programmer]


INSERT INTO [allred_bowling_development].[Bowlers].[programmer] 
    ([BowlerID], [BowlerLastName], [BowlerFirstName], [BowlerMiddleInit], [BowlerAddress], [BowlerCity], [BowlerState], [BowlerZip], [BowlerPhoneNumber], [TeamID], [email])
VALUES 
    (33, 'Yanqui', 'Gabriel', 'C', '123 Street', 'City', 'BC', '12345', '123-4567', 3, 'gyanqui@example.com');

DELETE FROM [allred_bowling_development].[Bowlers].[programmer]
WHERE [BowlerLastName] = 'Yanqui' AND [BowlerFirstName] = 'Gabriel';
