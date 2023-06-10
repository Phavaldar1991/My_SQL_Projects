SQL Project:

-- The Excel file contains a sheet named "Sheet1" with the data.
-- The Excel file has the following columns: [ID], [Name], [Amount], [Date].

--1. Create a Database: Open SSMS and create a new database for the project. Let's call it "CustomerDB".

--2. Create a Table: Create a table in the "CustomerDB" database to hold the imported data. Use the following SQL query:

CREATE TABLE CustomerDB (
    ID INT,
    Name VARCHAR(50),
    Amount DECIMAL(10, 2),
    Date DATE
);
--3. Import Data from Excel: Importing excel data through SSIS PACKAGE -- either through Import option in SSMS or create SSIS package through Visual Studio - SSIS integration service


--4. Once data is imported onto CustomerDB table next step is Remove Special Characters: 
    -- Run the following query to remove special characters from the "Name" column:
	
UPDATE CustomerDB
SET Name = REGEXP_REPLACE(Name, '[^a-zA-Z0-9 ]', '');

--This query uses the REGEXP_REPLACE function to replace any character that is not alphanumeric or a space with an empty string.

--5. Remove Duplicates: Execute the following query to remove duplicate rows from the CustomerDB table:

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ID ORDER BY (SELECT NULL)) AS RowNum
    FROM CustomerDB
)
DELETE FROM CTE WHERE RowNum > 1;

-- This query uses a common table expression (CTE) along with the ROW_NUMBER() function to assign row numbers to each row within a group of duplicates, based on the "ID" column. 
-- It then deletes all rows except the one with the lowest row number.

--6. Join Tables: Assuming you have another table called "Customers" with a "CustomerID" column, you can join the two tables using the "ID" column.

SELECT A.*, C.CustomerID, C.CustomerName
FROM CustomerDB A
INNER JOIN Customers B ON A.ID = B.CustomerID;

--7. Sort Data: To sort the data based on the "Date" column in ascending order:

SELECT *
FROM CustomerDB
ORDER BY Date ASC;

-- 8. Add New Column with Calculation: called "TotalAmount" that calculates the total amount plus 10% for each row:

ALTER TABLE CustomerDB
ADD TotalAmount DECIMAL(10, 2);

UPDATE CustomerDB
SET TotalAmount = Amount * 1.1;

--9. To find the names with an amount greater than $50,000 in the "CustomerDB"

SELECT Name
FROM CustomerDB
WHERE Amount > 50000
ORDER BY Amount DESC;
