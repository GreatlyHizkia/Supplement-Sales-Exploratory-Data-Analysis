SELECT * FROM SupplementSales_Weekly;


-- DATA CLEANING
-- Change format date column from this format '2020-01-06 00:00:00.0000000' to this format '2020-01-06'
ALTER TABLE SupplementSales_Weekly
ALTER COLUMN Date DATE  

-- Add new column 'Price_before_discount'
ALTER TABLE SupplementSales_Weekly
ADD Price_before_discount float;

-- Fill in the column 'Price_before_discount' with formula 'Price = Price / (1 - Discount)'
UPDATE SupplementSales_Weekly
SET Price_before_discount = ROUND(Price / NULLIF(1 - Discount, 0),2)
WHERE Price_before_discount IS NULL;

-- Change data type column 'Units_Returned' From Nvarchar to Int
ALTER TABLE SupplementSales_Weekly
ADD Units_Returned_Int INT;

UPDATE SupplementSales_Weekly
SET Units_Returned_Int = TRY_CONVERT(INT, Units_Returned);


-- Drop Old Column
ALTER TABLE SupplementSales_Weekly
DROP COLUMN Units_Returned;

EXEC sp_rename 'SupplementSales_Weekly.Units_Returned_Int', 'Units_Returned', 'COLUMN'; --Change Column Name

-- ADD Column 'Revenue_before_disc'
ALTER TABLE SupplementSales_Weekly
ADD Revenue_before_disc float;

-- Fill in column 'Revenue_before_disc'
UPDATE SupplementSales_Weekly
SET Revenue_before_disc = ROUND(Units_Sold * Price_before_discount,2)
WHERE Revenue_before_disc IS NULL;

-- Exploratory Data Analysis (EDA)

-- Dimensions Exploration
-- Explore The location of the Sale
SELECT DISTINCT Location FROM SupplementSales_Weekly;

-- Explore the name and category of the Supplement 
SELECT DISTINCT Product_Name, Category FROM SupplementSales_Weekly
ORDER BY 2;

-- Explore the e-commerce platform
SELECT DISTINCT Platform FROM SupplementSales_Weekly;

-- Date Exploration 
SELECT 
	MIN(Date) as First_Record_Date, 
	Max(Date) as Last_Record_Date,
	DATEDIFF(Month, Min(Date), Max(Date)) AS Order_Range_Months
FROM
	SupplementSales_Weekly;

-- Measures Exploration
-- Report that shows all metrics of the business
SELECT 'Products Supplement' as Measure_Name, COUNT(DISTINCT Product_Name)  AS Measure_Value FROM SupplementSales_Weekly
UNION ALL
SELECT 'Category Supplement', COUNT(DISTINCT Category) FROM SupplementSales_Weekly
UNION ALL
SELECT 'Location of the Sale', COUNT(DISTINCT Location) FROM SupplementSales_Weekly
UNION ALL
SELECT 'Minimum Price', MIN(Price) FROM SupplementSales_Weekly
UNION ALL
SELECT 'Maximum Price', Max(Price) FROM SupplementSales_Weekly
UNION ALL
SELECT 'Total Revenue before disc', SUM(Revenue_before_disc) FROM SupplementSales_Weekly
UNION ALL
SELECT 'Total Revenue after disc' , SUM(Revenue) FROM SupplementSales_Weekly
UNION ALL 
SELECT 'Total Units Sold', SUM(Units_Sold) FROM SupplementSales_Weekly
UNION ALL
SELECT 'Average price', AVG(Price) FROM SupplementSales_Weekly
UNION ALL
Select 'Total Number Product', COUNT(Product_Name) FROM SupplementSales_Weekly
UNION ALL
SELECT 'Average Units Returned', AVG(Units_Returned) FROM SupplementSales_Weekly

-- What is the Total Revenue for Each Year?
SELECT
	YEAR(DATE) AS Year,
	FORMAT(SUM(Revenue),'C2') AS Total_Revenue
FROM 
	SupplementSales_Weekly
GROUP BY 
	YEAR(DATE)
ORDER BY 
	1 ASC;

-- What is revenue per unit of each product?
SELECT
	Product_Name,
	FORMAT(SUM(Revenue), 'C2') as Total_Revenue,
	SUM(Units_Sold) as Total_Units_Sold,
	FORMAT(CAST(SUM(Revenue) AS decimal(18,4)) / SUM(Units_Sold), 'C2') as Revenue_Per_Unit
FROM
	SupplementSales_Weekly
GROUP BY 
	Product_Name

-- How many total units sold by location?
SELECT
	Location,
	SUM(Units_Sold) AS Total_Units_Sold
FROM
	SupplementSales_Weekly
GROUP BY
	Location
ORDER BY 
	2 DESC;

-- What are the platform that the customers use the most for purchasing?
SELECT 
	Platform,
	SUM(Units_Sold) as Total_Units_Sold
FROM
	SupplementSales_Weekly
GROUP BY
	Platform
ORDER BY 2 DESC;

-- What is the average price each category?
SELECT 
	Category,
	FORMAT(Avg(Price), 'C2') as Avg_Price
FROM
	SupplementSales_Weekly
Group By 
	Category
ORDER BY 
	2 DESC;

-- What is the total revenue generated for each category?
SELECT
	Category,
	FORMAT(SUM(Revenue), 'C2') as Total_Revenue
FROM
	SupplementSales_Weekly
GROUP BY 
	Category
ORDER BY 
	2 DESC;

-- What Platform has the most total returned?
SELECT 
	Platform,
	SUM(Units_Returned) as total_returned
FROM SupplementSales_Weekly
GROUP BY Platform
ORDER BY 2 DESC

-- Ranking Analysis
-- Which 5 Products generate the highest revenue?
SELECT * 
FROM 
	(SELECT 
		Product_Name,
		FORMAT(SUM(Revenue),'C2') as Total_Revenue,
		Rank() OVER(ORDER BY SUM(Revenue) DESC) as rank_product
	FROM
		SupplementSales_Weekly
	GROUP BY Product_Name) a
WHERE rank_product <= 5

-- Which 5 Products generate the least revenue?
SELECT * 
FROM 
	(SELECT 
		Product_Name,
		FORMAT(SUM(Revenue),'C2') as Total_Revenue,
		Rank() OVER(ORDER BY SUM(Revenue) ASC) as rank_product
	FROM
		SupplementSales_Weekly
	GROUP BY Product_Name) a
WHERE rank_product <= 5

-- What are the category that customers often purchase and rarely purchase?
SELECT
	Category,
	SUM(Units_Sold) AS Total_Sold,
	rank() over(Order By SUM(Units_Sold) DESC) as rank_total_sold
FROM 
	SupplementSales_Weekly
GROUP BY 
	Category;

-- What are the 5 Products that have most total units returned?
SELECT * 
FROM (
	SELECT 
		Product_Name,
		SUM(Units_Returned) as Total_Units_Returned,
		RANK() OVER(ORDER BY SUM(Units_Returned) DESC) rank_returned
	FROM
		SupplementSales_Weekly
	GROUP BY
		Product_Name) a
WHERE rank_returned <=5

-- What are the location generate most total revenue each year?
SELECT 
	YEAR(Date) as Order_Year,
	Location,
	SUM(Units_Sold) as Total_Sold,
	FORMAT(SUM(Revenue), 'C2') as Total_Revenue,
	RANK() Over(Partition By YEAR(Date)  Order By FORMAT(SUM(Revenue), 'C2')DESC) Rank
FROM
	SupplementSales_Weekly
GROUP BY 
	YEAR(Date), Location

-- What category that have the most total revenue in each location?
SELECT 
	Location,
	Category,
	SUM(Units_Sold) as Total_Units_Sold,
	FORMAT(SUM(Revenue),'C2') as Total_Revenue,
	RANK() Over(Partition By Location ORDER BY ROUND(SUM(Revenue),2) DESC) Rank
FROM
	SupplementSales_Weekly
GROUP BY Location, Category;

-- What are the category that customers always purchase?
SELECT
	Category,
	DATETRUNC(Month ,Date) as Date,
	AVG(Units_Sold) AS Total_Sold,
	rank() over(partition by DATETRUNC(Month,Date) Order By AVG(Units_Sold) DESC) as rank
FROM 
	SupplementSales_Weekly
GROUP BY 
	DATETRUNC(Month, Date), Category

-- Change over time analysis
-- What is the total product sold each product in year compare to average product sold each year? (exluded 2025)
WITH yearly_products_sold AS
	(SELECT 
		YEAR(Date) as YEAR,
		Product_Name,
		SUM(Units_Sold) as total_units_sold
	FROM SupplementSales_Weekly
	GROUP BY YEAR(Date), Product_Name
	 )
SELECT *,
AVG(total_units_sold) OVER (PARTITION BY Product_Name) as avg_units_sold
FROM yearly_products_sold
WHERE YEAR BETWEEN 2020 AND 2024
ORDER BY 2,1






















