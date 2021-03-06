/* 2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD 
isimli ?r?n? alan m??teri bilgilerini i?eren tablo*/

-- BU ANA TABLO

--Bu tablo ile di?er tablolar?(di?er ?r?nleri al?p almad???n? belirten tablolar?)
-- LEFT JOIN ile birle?tirerek ilerleyebiliriz.
SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
ORDER BY SC.customer_id


/* FIRST PRODUCT ('Polk Audio - 50 W Woofer - Black') TABLOSU*/

SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS FIRST_PRODUCT
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = 'Polk Audio - 50 W Woofer - Black'
ORDER BY SC.customer_id

/* SECOND PRODUCT ('SB-2000 12 500W Subwoofer (Piano Gloss Black)') TABLOSU*/

SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS SECOND_PRODUCT
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
ORDER BY SC.customer_id

/* THIRD PRODUCT ('SB-2000 12 500W Subwoofer (Piano Gloss Black)') TABLOSU*/

SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS THIRD_PRODUCT
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)' 
ORDER BY SC.customer_id

/* ANA TABLO ?LE 1., 2., 3. PRODUCT TABLOLARININ LEFT JOIN ?LE B?RLE?T?R?LMES?*/

/* 
SELECT
FROM (ANA TABLO) AS A
LEFT JOIN (FP TABLOSU) AS FP
ON A.c_id = FP.c_id
LEFT JOIN (SP TABLOSU) AS SP
ON A.c_id = SP.c_id
LEFT JOIN (TP TABLOSU) AS TP
ON A.c_id = TP.c_id
*/



SELECT A.customer_id, A.first_name, A.last_name,
	REPLACE(ISNULL(FP.FIRST_PRODUCT, 'NO'), 'Polk Audio - 50 W Woofer - Black', 'YES') AS FIRST_PRODUCT,
	REPLACE(ISNULL(SP.SECOND_PRODUCT, 'NO'), 'SB-2000 12 500W Subwoofer (Piano Gloss Black)', 'YES') AS SECOND_PRODUCT,
	REPLACE(ISNULL(TP.THIRD_PRODUCT, 'NO'), 'Virtually Invisible 891 In-Wall Speakers (Pair)', 'YES') AS THIRD_PRODUCT
FROM (SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
	FROM product.product AS PP
	INNER JOIN sale.order_item AS SOI 
	ON PP.product_id = SOI.product_id
	INNER JOIN sale.orders AS SO
	ON SO.order_id = SOI.order_id
	INNER JOIN sale.customer AS SC
	ON SC.customer_id = SO.customer_id
	WHERE PP.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD') AS A
LEFT JOIN (SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS FIRST_PRODUCT
	FROM product.product AS PP
	INNER JOIN sale.order_item AS SOI
	ON PP.product_id = SOI.product_id
	INNER JOIN sale.orders AS SO
	ON SO.order_id = SOI.order_id
	INNER JOIN sale.customer AS SC
	ON SC.customer_id = SO.customer_id
	WHERE PP.product_name = 'Polk Audio - 50 W Woofer - Black') as FP
ON A.customer_id = FP.customer_id
LEFT JOIN (SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS SECOND_PRODUCT
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)') AS SP
ON A.customer_id=SP.customer_id
LEFT JOIN (SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS THIRD_PRODUCT
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)') AS TP
ON A.customer_id=TP.customer_id
ORDER BY A.customer_id



/* V?EW TANIMLAYARAK AYNI KODU TEKRAR YAZALIM.*/

/* CREATE VIEW:

CREATE VIEW view_name AS
SELECT column1, column2.....
FROM table_name
WHERE [condition];
*/

/* USE V?EW:

SELECT * FROM CUSTOMERS_VIEW
*/

-- BU VIEW ?LE B?RLE?T?RME ??LEMLER?N? YAPIYORUZ
CREATE VIEW JOINT_TABLE AS
SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id

-- JOINT_TABLE V?EW'? KULLANILARAK ANA TABLONUN OLU?TURULMASI
SELECT * FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

-- JOINT_TABLE V?EW'? KULLANILARAK FIRST_PRODUCT TABLOSUNUN OLU?TURULMASI
SELECT customer_id, product_name AS FIRST_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE 'Polk Audio - 50 W Woofer - Black'

-- JOINT_TABLE V?EW'? KULLANILARAK SECOND_PRODUCT TABLOSUNUN OLU?TURULMASI
SELECT customer_id, product_name AS SECOND_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

-- JOINT_TABLE V?EW'? KULLANILARAK THIRD_PRODUCT TABLOSUNUN OLU?TURULMASI
SELECT customer_id, product_name AS THIRD_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'



-- V?EW KULLANILARAK ANA TABLO ?LE D??ER ?R?N TABLOLARININ LEFT JOIN ?LE B?RLE?T?R?LMES?
SELECT A.customer_id, A.first_name, A.last_name,
	REPLACE(ISNULL(FP.FIRST_PRODUCT, 'NO'),  'Polk Audio - 50 W Woofer - Black', 'YES') AS FIRST_PRODUCT,
	REPLACE(ISNULL(SP.SECOND_PRODUCT, 'NO'), 'SB-2000 12 500W Subwoofer (Piano Gloss Black)', 'YES') AS SECOND_PRODUCT,
	REPLACE(ISNULL(TP.THIRD_PRODUCT, 'NO'), 'Virtually Invisible 891 In-Wall Speakers (Pair)', 'YES') AS THIRD_PRODUCT
FROM (SELECT * FROM JOINT_TABLE
	WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD') AS A
LEFT JOIN (SELECT customer_id, product_name AS FIRST_PRODUCT FROM JOINT_TABLE
		WHERE product_name LIKE 'Polk Audio - 50 W Woofer - Black') AS FP
		ON A.customer_id = FP.customer_id
LEFT JOIN (SELECT customer_id, product_name AS SECOND_PRODUCT FROM JOINT_TABLE
		WHERE product_name LIKE 'SB-2000 12 500W Subwoofer (Piano Gloss Black)') AS SP
		ON A.customer_id = SP.customer_id
LEFT JOIN (SELECT customer_id, product_name AS THIRD_PRODUCT FROM JOINT_TABLE
		WHERE product_name LIKE 'Virtually Invisible 891 In-Wall Speakers (Pair)') AS TP
		ON A.customer_id = TP.customer_id
ORDER BY customer_id


/* IFF KULLANARAK ASS?GNMENT ??Z?M? */

select distinct so.[customer_id],[first_name],[last_name],pp.[product_name]
into #Main_Tab
from [product].[product] 		pp
	join [sale].[order_item] 	soi		on pp.[product_id] = soi.[product_id]
	join [sale].[orders] 		so		on so.[order_id] = soi.[order_id]
	join [sale].[customer]		sc		on so.[customer_id] = sc.[customer_id]

select distinct customer_id,first_name,last_name 
		,IIF(product_name = 'Polk Audio - 50 W Woofer - Black','Yes','No') as First_
		,IIF(product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)','Yes','No') as Second_
		,IIF(product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)','Yes','No') as Third_
from #Main_Tab
where customer_id in (select customer_id from #Main_Tab 
						where product_name like '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' )
order by customer_id


/* yan yana jo?n kullan?m?*/

CREATE VIEW NEW_JOINT_TABLE AS
SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI AND sale.orders AS SO 
ON PP.product_id = SOI.product_id
INNER JOIN 
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id


/* A?A?IDAK? ??Z?M ALLEN HOCA'YA A?TT?R. */

USE SampleRetail;

SELECT	sc.customer_id, 
		sc.first_name, sc.last_name,
		pp.product_name
INTO	#jointable     -- Temporary table olu?turma
FROM	sale.customer sc
JOIN	sale.orders so
		ON sc.customer_id=so.customer_id
JOIN	sale.order_item soi
		ON so.order_id=soi.order_id
JOIN	product.product pp
		ON	soi.product_id=pp.product_id;

SELECT * FROM #jointable;
--DROP TABLE IF EXISTS #jointable;   -- temporary table'? kulland?ktan sonra silmek i?in

--#table_hdd -> '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
SELECT DISTINCT *
INTO	#table_hdd  --temporary table
FROM	#jointable
WHERE	product_name='2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD';

SELECT * FROM #table_hdd; --109

--1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)
SELECT DISTINCT *
INTO	#table_Woofer  --temporary table
FROM	#jointable
WHERE	product_name='Polk Audio - 50 W Woofer - Black';

SELECT * FROM #table_Woofer; --102

--2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)
SELECT DISTINCT *
INTO	#table_Subwoofer  --temporary table
FROM	#jointable
WHERE	product_name='SB-2000 12 500W Subwoofer (Piano Gloss Black)';

SELECT * FROM #table_Subwoofer; --90

--3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)
SELECT DISTINCT *
INTO	#table_Speakers  --temporary table
FROM	#jointable
WHERE	product_name='Virtually Invisible 891 In-Wall Speakers (Pair)';

SELECT * FROM #table_Speakers; --95

--RESULT -> LEFT JOIN #table_hdd, #table_Woofer, #table_Subwoofer, #table_Speakers
SELECT		hdd.*, 
			woofer.product_name as First_product,
			subwoofer.product_name as Second_product,
			speakers.product_name as Third_product
INTO		#result  --temporary table
FROM		#table_hdd as hdd
LEFT JOIN	#table_Woofer as woofer ON hdd.customer_id=woofer.customer_id
LEFT JOIN	#table_Subwoofer as subwoofer ON hdd.customer_id=subwoofer.customer_id
LEFT JOIN	#table_Speakers as speakers ON hdd.customer_id=speakers.customer_id;

SELECT * FROM #result;

--UPDATE -> NOT NULL to YES
UPDATE #result 
SET First_product = 'Yes'  WHERE First_product IS NOT NULL;
UPDATE #result 
SET Second_product = 'Yes' WHERE Second_product IS NOT NULL;
UPDATE #result 
SET Third_product = 'Yes'  WHERE Third_product IS NOT NULL;

--UPDATE -> NULL to NO
UPDATE #result 
SET First_product = COALESCE(First_product, 'No');
UPDATE #result 
SET Second_product = COALESCE(Second_product, 'No');
UPDATE #result 
SET Third_product = COALESCE(Third_product, 'No');

--RESULT
SELECT * FROM #result;