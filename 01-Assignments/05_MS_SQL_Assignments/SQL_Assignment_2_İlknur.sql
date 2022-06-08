/*ASSÝGNMENT ÇÖZÜMÜ 1: Burada izlenen adýmlar aþaðýdaki gibidir:

1. 2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD 
isimli ürünü alan müþteri bilgilerini içeren bir tablo oluþturulmuþ
ve bu tablo ANA TABLO olarak kabul edilmiþtir.

2. Diðer ürünler için de ayný þekilde tablolar oluþturulmuþ ve bunlar da sýrasýyla
FIRST_PRODUCT
SECON_PRODUCT
THIRD_PRODUCT
tablolarý olarak kabul edilmiþtir.

3. ANA TABLO ile diðer ürün tablolarý LEFT JOIN  ile birleþtirilmiþtir.

4. Elde edilen tablodaki ürün sütunlarýnda yer alan NULL deðerler ve ürün isimleri
'NO' ve 'YES' ile deðiþtirilerek ANA tabloda belirtilen ürünü alan kiþilerin diðer üç
ürünü alýp almadýðýný gösteren tablo elde edilmiþtir*/

/* ANA TABLO */
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

/* ANA TABLO ÝLE 1., 2., 3. PRODUCT TABLOLARININ LEFT JOIN ÝLE BÝRLEÞTÝRÝLMESÝ
VE NULL ÝFADELERÝNÝN STRÝNG FONKSÝYONLARLA DÜZELTÝLMESÝ*/

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


/* ASSÝGNMENT ÇÖZÜMÜ 2: VÝEW TANIMLAYARAK*/

/* VIEW OLUÞTURMA */
CREATE VIEW JOINT_TABLE AS
SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id

-- VIEW KULLANIMI
/* JOINT_TABLE VÝEW'Ü KULLANILARAK ANA TABLONUN OLUÞTURULMASI */
SELECT * FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

/* JOINT_TABLE VÝEW'Ü KULLANILARAK FIRST_PRODUCT TABLOSUNUN OLUÞTURULMASI */
SELECT customer_id, product_name AS FIRST_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE 'Polk Audio - 50 W Woofer - Black'

/* JOINT_TABLE VÝEW'Ü KULLANILARAK SECOND_PRODUCT TABLOSUNUN OLUÞTURULMASI */
SELECT customer_id, product_name AS SECOND_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

/* JOINT_TABLE VÝEW'Ü KULLANILARAK THIRD_PRODUCT TABLOSUNUN OLUÞTURULMASI */
SELECT customer_id, product_name AS THIRD_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

/* VÝEW KULLANILARAK OLUÞTURULAN ANA TABLO ÝLE DÝÐER ÜRÜN TABLOLARININ
LEFT JOIN ÝLE BÝRLEÞTÝRÝLMESÝ VE STRING FONKSÝYONLAR ÝLE ÜRÜN 
KOLONLARININ BÝLGÝLERÝNÝN DÜZENLENMESÝ */
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
