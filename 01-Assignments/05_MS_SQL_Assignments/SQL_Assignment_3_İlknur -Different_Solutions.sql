/* ASSIGNMENT_3 SOLUTION */

/*Question:
CONVERSION RATE

Below you see a table of the actions of customers visiting the website by clicking
on two different types of advertisements given by an E-Commerce company.
Write a query to return the conversion rate for each Advertisement type.

a.    Create above table (Actions) and insert values,

b.    Retrieve count of total Actions and Orders for each Advertisement Type,

c.    Calculate Orders (Conversion) rates for each Advertisement Type by
	dividing by total count of actions casting as float by multiplying by 1.0.
*/

CREATE SCHEMA Actions;

CREATE TABLE Actions.Actions (
			[Visitor_ID] TINYINT PRIMARY KEY NOT NULL,
			[Adv_Type] VARCHAR(1),
			[Action] VARCHAR(10));

INSERT INTO Actions.Actions
VALUES 
	(1, 'A', 'Left'),
	(2, 'A', 'Order'),
	(3, 'B', 'Left'),
	(4, 'A', 'Order'),
	(5, 'A', 'Review'),
	(6, 'A', 'Left'),
	(7, 'B', 'Left'),
	(8, 'B', 'Order'),
	(9, 'B', 'Review'),
	(10, 'A', 'Review');

SELECT * FROM Actions.Actions

-- Finding total count of actions for each advertisement type
SELECT Adv_Type, COUNT(*) Count_Actions
FROM Actions.Actions
GROUP BY Adv_Type

-- Finding count of orders for each advertisement type
SELECT Adv_Type, [Action], COUNT([Action]) AS ORDERS  --Action = Order olanlarýn Adv_type' a göre gruplanmasý
	FROM Actions.Actions
	WHERE [Action]='Order'
	GROUP BY Adv_Type, [Action]

SELECT Adv_Type, COUNT([Action]) AS ORDERS_TOTAL
	FROM Actions.Actions
	GROUP BY Adv_Type


SELECT A.Adv_Type, A.COUNT_ORDER, B.ORDERS_TOTAL,
	CAST(((A.COUNT_ORDER*1.0)/(B.ORDERS_TOTAL*1.0)) AS NUMERIC(10,2)) AS CONVERSION_RATE
FROM (
	SELECT Adv_Type, [Action], COUNT([Action]) AS COUNT_ORDER 
	FROM Actions.Actions
	WHERE [Action]='Order'
	GROUP BY Adv_Type, [Action]) AS A,
	(SELECT Adv_Type, COUNT([Action]) AS ORDERS_TOTAL
	FROM Actions.Actions
	GROUP BY Adv_Type) AS B
	WHERE A.Adv_Type=B.Adv_Type


SELECT A.Adv_Type, A.COUNT_ORDER, B.ORDERS_TOTAL,
	CAST(CAST(A.COUNT_ORDER AS FLOAT)/CAST(B.ORDERS_TOTAL AS FLOAT)AS DECIMAL(3,2)) AS CONVERSION_RATE
FROM (
	SELECT Adv_Type, [Action], COUNT([Action]) AS COUNT_ORDER 
	FROM Actions.Actions
	WHERE [Action]='Order'
	GROUP BY Adv_Type, [Action]) AS A,
	(SELECT Adv_Type, COUNT([Action]) AS ORDERS_TOTAL
	FROM Actions.Actions
	GROUP BY Adv_Type) AS B
	WHERE A.Adv_Type=B.Adv_Type



SELECT A.Adv_Type, A.COUNT_ORDER, B.ORDERS_TOTAL,
	CAST((A.COUNT_ORDER*1.0/B.ORDERS_TOTAL*1.0)AS DECIMAL(3,2)) AS CONVERSION_RATE
FROM (
	SELECT Adv_Type, [Action], COUNT([Action]) AS COUNT_ORDER 
	FROM Actions.Actions
	WHERE [Action]='Order'
	GROUP BY Adv_Type, [Action]) AS A,
	(SELECT Adv_Type, COUNT([Action]) AS ORDERS_TOTAL
	FROM Actions.Actions
	GROUP BY Adv_Type) AS B
	WHERE A.Adv_Type=B.Adv_Type