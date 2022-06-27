/* SQL RELATIONAL DN E_COMMERCE PROJECT */

-- 1. Creating COMBINED_TABLE table joining all tables

SELECT *
INTO COMBINED_TABLE
FROM
(
SELECT
cd.Cust_id, cd.Customer_Name, cd.Province, cd.Region, cd.Customer_Segment,
mf.Ord_id, mf.Prod_id, mf.Sales, mf.Discount, mf.Order_Quantity, mf.Product_Base_Margin,
od.Order_Date, od.Order_Priority,
pd.Product_Category, pd.Product_Sub_Category,
sd.Ship_id, sd.Ship_Mode, sd.Ship_Date
FROM market_fact mf
INNER JOIN cust_dimen cd ON mf.Cust_id = cd.Cust_id
INNER JOIN orders_dimen od ON od.Ord_id = mf.Ord_id
INNER JOIN prod_dimen pd ON pd.Prod_id = mf.Prod_id
INNER JOIN shipping_dimen sd ON sd.Ship_id = mf.Ship_id
) A

SELECT *
FROM COMBINED_TABLE

--2. Find the top 3 customers who have maximum count of orders

SELECT TOP 3 Cust_id, COUNT(distinct Ord_id) CNT_ORDERS
FROM COMBINED_TABLE
GROUP BY Cust_id
ORDER BY CNT_ORDERS DESC

-- 3. Create a new column ar combined table as DaysTakenForDelivery that contains the date difference
--of order dates

ALTER TABLE combined_table
ADD DaysTakenForDelivery INT
UPDATE combined_table
SET DaysTakenForDelivery = DATEDIFF (DAY, Order_Date, Ship_Date)

SELECT *
FROM	combined_table


/* 4. Find the customer whose order took the maximum time to get delivered. */SELECT TOP 1 Cust_id, Customer_Name, DaysTakenForDeliveryFROM combined_tableORDER BY DaysTakenForDelivery DESC;


 /* 5. Count the total number of unique customers in January and how many of them 
came back every month over the entire year in 2011 */

WITH T1 AS(
	SELECT DISTINCT Cust_id
	FROM COMBINED_TABLE
	WHERE YEAR(order_date) = 2011 AND MONTH(order_date) = 1
)
SELECT DATENAME(MONTH, A.order_date), MONTH(A.order_date) ORD_MONTH, COUNT(DISTINCT T1.Cust_id)CNT_CUST
FROM COMBINED_TABLE A, T1
WHERE A.Cust_id=T1.Cust_id
	AND YEAR(order_date) = 2011
GROUP BY DATENAME(MONTH, order_date), MONTH(A.order_date)
ORDER BY 2;

/* 6. Write a query to return for each user the time elapsed between the first 
purchasing and the third purchasing, in ascending order by Customer ID.*/

WITH T1 AS(
	SELECT Cust_id,
		MIN(Order_Date) OVER(PARTITION BY Cust_id) First_Order_Date
	FROM COMBINED_TABLE
), T2 AS (
SELECT DISTINCT Cust_id, Order_Date, ord_id,
	DENSE_RANK() OVER(PARTITION BY Cust_id ORDER BY Order_Date, ord_id) ORD_DATE_NUMBER
FROM COMBINED_TABLE
)
SELECT DISTINCT T1.Cust_id, T1.First_Order_Date, 
	DATEDIFF(DAY, T1.First_Order_Date, T2.Order_Date) DATE_DIFF
FROM T1, T2
WHERE T1.Cust_id=T2.Cust_id
	AND ORD_DATE_NUMBER=3
ORDER BY 1,2,3

/* 7. */

SELECT Cust_id, SUM(Order_Quantity)
FROM COMBINED_TABLE
WHERE Prod_id = '11'
GROUP BY Cust_id

SELECT DISTINCT Cust_id,
	CASE WHEN Prod_id = 11 THEN Order_quantity ELSE 0 END Ord_quant_11,
	CASE WHEN Prod_id = 14 THEN Order_quantity ELSE 0 END Ord_quant_14
FROM COMBINED_TABLE


WITH T1 AS (
SELECT DISTINCT Cust_id,
	SUM(CASE WHEN Prod_id = 11 THEN Order_quantity ELSE 0 END) Ord_quant_11,
	SUM(CASE WHEN Prod_id = 14 THEN Order_quantity ELSE 0 END) Ord_quant_14
FROM COMBINED_TABLE
GROUP BY Cust_id
HAVING SUM(CASE WHEN Prod_id = 11 THEN Order_quantity ELSE 0 END) > 0
	AND SUM(CASE WHEN Prod_id = 14 THEN Order_quantity ELSE 0 END) > 0
), T2 AS (
SELECT Cust_id, SUM(Order_Quantity)Total_Prod
FROM COMBINED_TABLE
GROUP BY Cust_id
)
SELECT T1.Cust_id, CAST(1.0 * T1.Ord_quant_11/T2.Total_Prod AS DECIMAL (3,2)) AS RATIO_11, CAST(1.0 * T1.Ord_quant_14/T2.Total_Prod AS DECIMAL (3,2)) AS RATIO_14
FROM T1, T2
WHERE T1.Cust_id=T2.Cust_id
ORDER BY 1



/* CUSTOMER SEGMENTATION */

CREATE VIEW CUST_MONTH_VIEW AS
SELECT DISTINCT Cust_id, YEAR(Order_Date)YEAR_, MONTH(Order_Date)MONTH_,
	DENSE_RANK() OVER(ORDER BY YEAR(Order_Date), MONTH(Order_Date)) MONTH_NUMBER
FROM COMBINED_TABLE

SELECT *,
	MONTH_NUMBER - LAG(MONTH_NUMBER) OVER(PARTITION BY Cust_id ORDER BY MONTH_NUMBER) TIME_GAP
FROM CUST_MONTH_VIEW


/* Retention Rate */

CREATE VIEW log_customer AS 
SELECT DISTINCT Cust_id, Ord_id, Order_date, MONTH(Order_Date) [Month], YEAR(Order_Date) [Year]
FROM combined_table

SELECT DISTINCT [Year], [Month], 
	SUM (CASE WHEN Monthly_time_gap = 1 THEN 1 ELSE 0 END) OVER (PARTITION BY [Year], [Month])
	AS number_retained_customers
FROM (
SELECT *,
		DATEDIFF(month, Order_date, lead(Order_date) OVER (PARTITION BY Cust_id ORDER BY Order_Date )) AS Monthly_time_gap
FROM log_customer ) AS a
ORDER BY 1,2
