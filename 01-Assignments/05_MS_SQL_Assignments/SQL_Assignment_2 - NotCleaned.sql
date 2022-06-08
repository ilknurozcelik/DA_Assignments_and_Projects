/* 2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD 
isimli ürünü alan müþteri bilgilerini içeren tablo*/

-- BU ANA TABLO

--Bu tablo ile diðer tablolarý(diðer ürünleri alýp almadýðýný belirten tablolarý)
-- LEFT JOIN ile birleþtirerek ilerleyebiliriz.
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

/* ANA TABLO ÝLE 1., 2., 3. PRODUCT TABLOLARININ LEFT JOIN ÝLE BÝRLEÞTÝRÝLMESÝ*/

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



/* VÝEW TANIMLAYARAK AYNI KODU TEKRAR YAZALIM.*/

/* CREATE VIEW:

CREATE VIEW view_name AS
SELECT column1, column2.....
FROM table_name
WHERE [condition];
*/

/* USE VÝEW:

SELECT * FROM CUSTOMERS_VIEW
*/

-- BU VIEW ÝLE BÝRLEÞTÝRME ÝÞLEMLERÝNÝ YAPIYORUZ
CREATE VIEW JOINT_TABLE AS
SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id

-- JOINT_TABLE VÝEW'Ü KULLANILARAK ANA TABLONUN OLUÞTURULMASI
SELECT * FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

-- JOINT_TABLE VÝEW'Ü KULLANILARAK FIRST_PRODUCT TABLOSUNUN OLUÞTURULMASI
SELECT customer_id, product_name AS FIRST_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE 'Polk Audio - 50 W Woofer - Black'

-- JOINT_TABLE VÝEW'Ü KULLANILARAK SECOND_PRODUCT TABLOSUNUN OLUÞTURULMASI
SELECT customer_id, product_name AS SECOND_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

-- JOINT_TABLE VÝEW'Ü KULLANILARAK THIRD_PRODUCT TABLOSUNUN OLUÞTURULMASI
SELECT customer_id, product_name AS THIRD_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'



-- VÝEW KULLANILARAK ANA TABLO ÝLE DÝÐER ÜRÜN TABLOLARININ LEFT JOIN ÝLE BÝRLEÞTÝRÝLMESÝ
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


/* IFF KULLANARAK ASSÝGNMENT ÇÖZÜMÜ */

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


/* yan yana joýn kullanýmý*/

CREATE VIEW NEW_JOINT_TABLE AS
SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI AND sale.orders AS SO 
ON PP.product_id = SOI.product_id
INNER JOIN 
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id


