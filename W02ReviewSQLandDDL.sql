-- W02 Review: SQL and DDL
-- Gabriel Yanqui

-- Sales Orders Database
USE SalesOrdersExample;

-- 1. “List customers and the dates they placed an order, sorted in order date sequence.”
-- (Hint: The solution requires a JOIN of two tables.)
SELECT
	CustFirstName, 
	CustLastName, 
	OrderDate 
FROM 
	office.customers c
JOIN 
	office.Orders o ON c.CustomerID = o.CustomerID
ORDER BY 
	OrderDate;


-- 2. “List employees and the customers for whom they booked an order.”
-- (Hint: The solution requires a JOIN of more than two tables.)
SELECT DISTINCT
	e.EmpLastName,
	e.EmpFirstName, 
	c.CustLastName, 
	c.CustFirstName
FROM 
	office.Employees e
JOIN 
	office.Orders o ON e.EmployeeID = o.EmployeeID
JOIN 
	office.Customers c ON o.CustomerID = c.CustomerID;

-- 3. “Display all orders, the products in each order, and the amount owed for each product, in order number sequence.”
-- (Hint: The solution requires a JOIN of more than two tables.)
SELECT 
    o.OrderNumber,
    o.OrderDate,
    p.ProductName,
    od.QuantityOrdered,
    od.QuotedPrice,
    (od.QuantityOrdered * od.QuotedPrice) AS AmountOwed
FROM 
    office.Orders o
JOIN 
    office.Order_Details od ON o.OrderNumber = od.OrderNumber
JOIN 
    dbo.Products p ON od.ProductNumber = p.ProductNumber
ORDER BY 
    o.OrderNumber;

-- 4. “Show me the vendors and the products they supply to us for products that cost less than $100.”
-- (Hint: The solution requires a JOIN of more than two tables.)
SELECT 
    v.VendorID,
    v.VendName,
    p.ProductName,
    pv.WholesalePrice
FROM 
    dbo.Vendors v
JOIN 
    dbo.Product_Vendors pv ON v.VendorID = pv.VendorID
JOIN 
    dbo.Products p ON pv.ProductNumber = p.ProductNumber
WHERE 
    pv.WholesalePrice < 100
ORDER BY 
	pv.WholesalePrice;


-- 5. “Show me customers and employees who have the same last name.”
-- (Hint: The solution requires a JOIN on matching values.)
SELECT 
    c.CustLastName, 
    c.CustFirstName,
    e.EmpLastName,
    e.EmpFirstName
FROM 
    office.Customers c
JOIN 
    office.Employees e ON c.CustLastName = e.EmpLastName;

-- 6. “Show me customers and employees who live in the same city.”
-- (Hint: The solution requires a JOIN on matching values.)
SELECT 
    c.CustLastName, 
    c.CustFirstName,
    e.EmpLastName,
    e.EmpFirstName
FROM 
    office.Customers c
JOIN 
    office.Employees e ON c.CustCity = e.EmpCity;

-- Entertainment Agency Database
USE EntertainmentAgencyExample;

-- 1. “Display agents and the engagement dates they booked, sorted by booking start date.”
-- (Hint: The solution requires a JOIN of two tables.)

SELECT
	AgtFirstName, 
	AgtLastName, 
	StartDate,
	EndDate
FROM 
	dbo. Agents a
JOIN 
	dbo.Engagements e ON a.AgentID = e.AgentID
ORDER BY 
	StartDate;

-- 2. “List customers and the entertainers they booked.”
-- (Hint: The solution requires a JOIN of more than two tables.)
SELECT DISTINCT
	c.CustFirstName,
	c.CustLastName,
	ent.EntStageName
FROM 
	dbo.Customers c
JOIN
	dbo.Engagements eng ON c.CustomerID = eng.CustomerID
JOIN
	dbo.Entertainers ent ON eng.EntertainerID = ent.EntertainerID;

-- 3. “Find the agents and entertainers who live in the same postal code.”
-- (Hint: The solution requires a JOIN on matching values.)
SELECT
	AgtFirstName,
	AgtLastName,
	EntStageName
FROM 
	dbo.Agents a
JOIN
	dbo.Entertainers e ON a.AgtZipCode = e.EntZipCode;

-- School Scheduling Database
USE SchoolSchedulingExample;

-- 1. “Display buildings and all the classrooms in each building.”
-- (Hint: The solution requires a JOIN of two tables.)

SELECT
	BuildingName,
	ClassRoomID
FROM
	dbo.Buildings b
JOIN 
	dbo.Class_Rooms cr ON b.BuildingCode = cr.BuildingCode;

--2. “List students and all the classes in which they are currently enrolled.”
-- (Hint: The solution requires a JOIN of more than two tables.)
SELECT
    s.StudFirstName,
    s.StudLastName,
	c.ClassID,
	scs.ClassStatusDescription
FROM
    Students s
JOIN
    Student_Schedules ss ON s.StudentID = ss.StudentID
JOIN
    Classes c ON ss.ClassID = c.ClassID
JOIN
	Student_Class_Status scs ON ss.ClassStatus = scs.ClassStatus
WHERE
    scs.ClassStatus = '1';

-- 3. “List the faculty staff and the subject each teaches.”
-- (Hint: The solution requires a JOIN of more than two tables.)

SELECT
    s.StfFirstName,
    s.StfLastName,
    sub.SubjectName
FROM
    Staff s
JOIN
    Faculty_Subjects fs ON s.StaffID = fs.StaffID
JOIN
	Subjects sub ON fs.SubjectID = sub.SubjectID;

-- 4. “Show me the students who have a grade of 85 or better in art and who also have a grade of 85 or better in any computer course.”
-- (Hint: The solution requires a JOIN on matching values.)
SELECT 
	StudFirstName,
	StudLastName,
	Grade
FROM
	Students s
JOIN 
	Student_Schedules ss ON s.StudentID = ss.StudentID
JOIN 
	Classes c ON ss.ClassID = c.ClassID
JOIN 
	Subjects sub ON c.SubjectID = sub.SubjectID
WHERE 
	(sub.SubjectName LIKE '%art%' AND ss.Grade >= '85') 
      AND (sub.SubjectName LIKE '%computer%' AND ss.Grade >= '85');

-- Bowling League Database
USE BowlingLeagueExample;

-- 1. “List the bowling teams and all the team members.”
-- (Hint: The solution requires a JOIN of two tables.)

SELECT
	TeamName,
	CONCAT (BowlerFirstName, ' ' , BowlerLastName) TeamMemberName
FROM 
	Teams t
JOIN 
	Bowlers b ON t.TeamID = b.TeamID

-- 2. “Display the bowlers, the matches they played in, and the bowler game scores.”
-- (Hint: The solution requires a JOIN of more than two tables.)
SELECT 
	b.BowlerFirstName,
	b.BowlerLastName,
    bs.MatchID,
	bs.RawScore, 
	bs.HandiCapScore 
FROM 
	bowlers b
JOIN 
	bowler_scores bs ON bs.BowlerID = b.BowlerID;

-- 3. “Find the bowlers who live in the same ZIP Code.”
-- (Hint: The solution requires a JOIN on matching values, and be sure to not match bowlers with themselves.)

SELECT 
	CONCAT(b1.BowlerFirstName, ' ' , b1.BowlerLastName) AS Bowler,
	CONCAT(b2.BowlerFirstName, ' ', b2.BowlerLastName) AS OtherBowler
FROM
	Bowlers b1
JOIN 
	Bowlers b2 ON b1.BowlerZip = b2.BowlerZip
WHERE
	b1.BowlerID <> b2.BowlerID

-- Recipes Database
USE RecipesExample;

-- 1. “List all the recipes for salads.”
-- (Hint: The solution requires a JOIN of two tables.)
SELECT
	*
FROM
	Recipes r
JOIN 
	Recipe_Classes rc ON r.RecipeClassID = rc.RecipeClassID
WHERE
	rc.RecipeClassDescription = 'Salad';

-- 2. “List all recipes that contain a dairy ingredient.”
-- (Hint: The solution requires a JOIN of more than two tables.)
SELECT DISTINCT
	r.RecipeTitle
FROM 
	Recipes r
JOIN 
	Recipe_Ingredients ri ON r.recipeID = ri.RecipeID
JOIN
	Ingredients i ON ri.IngredientID = i.IngredientID
JOIN 
	Ingredient_Classes ic ON i.IngredientClassID = ic.IngredientClassID
WHERE 
	ic.IngredientClassDescription = 'dairy';

-- 3. “Find the ingredients that use the same default measurement amount.”
-- (Hint: The solution requires a JOIN on matching values.)
SELECT 
    one.FirstIngredient, 
    one.Measurement, 
    two.SecondIngredient
FROM 
    (SELECT 
        i1.IngredientName AS FirstIngredient, 
        m1.MeasurementDescription AS Measurement 
     FROM 
        ingredients i1 
     JOIN 
        measurements m1 ON i1.MeasureAmountID = m1.MeasureAmountID) AS one 
JOIN 
    (SELECT 
        i2.IngredientName AS SecondIngredient, 
        m2.MeasurementDescription AS Measurement 
     FROM 
        ingredients i2 
     JOIN 
        measurements m2 ON i2.MeasureAmountID = m2.MeasureAmountID) AS two 
ON 
    one.Measurement = two.Measurement 
WHERE 
    one.FirstIngredient <> two.SecondIngredient;

-- 4. “Show me the recipes that have beef and garlic.”
-- (Hint: The solution requires a JOIN on matching values.)
SELECT DISTINCT
    r.RecipeTitle
FROM 
    Recipes r
JOIN 
    Recipe_Ingredients ri ON r.RecipeID = ri.RecipeID
JOIN 
    Ingredients i ON ri.IngredientID = i.IngredientID
WHERE 
    i.IngredientName IN ('Beef', 'Garlic')
GROUP BY 
    r.RecipeID, r.RecipeTitle
HAVING 
    COUNT(DISTINCT i.IngredientName) = 2;
