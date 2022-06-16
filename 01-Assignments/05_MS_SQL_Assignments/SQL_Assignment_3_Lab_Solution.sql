/* Assignment-3 Solution */

-- CTE ile çözüm
WITH CTE1 AS
(
SELECT Adv_Type, COUNT(*) total_action
FROM Actions.Actions
GROUP BY Adv_Type
), CTE2 AS
(
SELECT Adv_Type, COUNT(*) order_action
FROM Actions.Actions
WHERE Action='Order'
GROUP BY Adv_Type
)
SELECT CTE1.Adv_Type, CAST(1.0*CTE2.order_action/CTE1.total_action AS DECIMAL (3,2)) AS conversion_rate
FROM CTE1, CTE2
WHERE CTE1.Adv_Type = CTE2.Adv_Type;

-- HOCA'NIN ÇÖZÜMÜ
WITH CTE1 AS
(
SELECT adv_type,
		COUNT (*) total_action
FROM	#T1
GROUP BY adv_type
), CTE2 AS
(
SELECT adv_type, COUNT (*) order_action
FROM	#T1
WHERE action = 'Order'
GROUP BY adv_type
)
SELECT	CTE1.adv_type, CTE1.total_action, CTE2.order_action, cast(1.0*order_action/total_action as decimal(3,2)) AS conversion_rate
FROM	CTE1, CTE2
WHERE	CTE1.adv_type = CTE2.adv_type