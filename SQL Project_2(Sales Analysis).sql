-- Sales Analysis and Reporting Project

--Objective: Perform a comprehensive analysis of sales data and generate insightful reports to aid in decision-making and business growth.

--1. Data Exploration:

-- Obtain the sales dataset (e.g., CSV file, SQL database, or any other source).
-- Identify the relevant tables and columns in the dataset.
-- Use SQL queries to explore the data, check for missing values, duplicates, and outliers.

--2. Data Cleaning and Transformation:

-- Clean the data by handling missing values, duplicates, and any other data quality issues.
--Transform the data as necessary to make it suitable for analysis (e.g., data type conversions, splitting columns, merging tables).


--3. Data Analysis:

--Identify key metrics and business questions you want to answer (e.g., top-selling products, sales trends, customer segmentation).
--Write SQL queries to calculate the required metrics and answer the business questions.
--Perform aggregations, joins, and subqueries as needed to extract meaningful insights.


--------------------------------- Data Exploration:-------------------------------------

-- To get an overview of the tables in the database:

USE Learn_SQL;
SELECT * FROM sys.tables;

-- To view the structure and columns of a specific table:

USE Learn_SQL;
EXEC sp_columns Customer_Ratings;


-- To fetch a sample of records from a table:

SELECT TOP (10) * FROM [Learn_SQL].[dbo].[Customer_Feedback];

--------------------------------- Data Cleaning and Transformation:---------------------------------

-- To handle missing values in a table (assuming NULL is used for missing values):

UPDATE [Learn_SQL].[dbo].[Superstore_Orders] SET [Postal Code] = 0 WHERE [Postal Code] IS NULL;

-- To remove duplicate records from a table:

  WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [Customer ID] ORDER BY (SELECT NULL)) AS RowNum
    FROM [Learn_SQL].[dbo].[Superstore_Orders2]
)
DELETE FROM CTE WHERE RowNum > 1;

-- To merge two tables based on a common column:

SELECT * FROM [Learn_SQL].[dbo].[Customer_Ratings] A 
INNER JOIN [Learn_SQL].[dbo].[Customer_Feedback] B 
ON A.[Customer ID] = B.[Customer ID];

--------------------------Data Analysis:---------------------------------------

---To calculate total sales for each product:

SELECT [product_name], SUM(quantity * price) AS total_sales
FROM [Learn_SQL].[dbo].[Superstore_Orders]
GROUP BY [product_name];


-- To find the top-selling products:

SELECT [product_name], SUM(quantity) AS total_quantity_sold
FROM [Learn_SQL].[dbo].[Superstore_Orders]
GROUP BY [product_name]
ORDER BY [total_quantity_sold] DESC
LIMIT 5;

-- To analyze sales trends over time:

SELECT FORMAT([Order Date], 'yyyy-MM') AS month, SUM(Sales) AS monthly_sales
FROM [Learn_SQL].[dbo].[Superstore_Orders]
GROUP BY FORMAT([Order_Date], 'yyyy-MM')
ORDER BY month;


--we're using the LAG and LEAD functions to fetch the previous month's sales and the next month's sales. 
-- These functions allow us to compare the current month's sales with the previous and next months.

SELECT 
  FORMAT(sale_date, 'yyyy-MM') AS month,
  SUM(Sales) AS monthly_sales,
  LAG(SUM(Sales)) OVER (ORDER BY FORMAT(sale_date, 'yyyy-MM')) AS previous_month_sales,
  LEAD(SUM(Sales)) OVER (ORDER BY FORMAT(sale_date, 'yyyy-MM')) AS next_month_sales
FROM [Learn_SQL].[dbo].[Superstore_Orders]
GROUP BY FORMAT(sale_date, 'yyyy-MM')
ORDER BY month;
