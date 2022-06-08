/*ASS�GNMENT ��Z�M� 1: Burada izlenen ad�mlar a�a��daki gibidir:

1. 2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD 
isimli �r�n� alan m��teri bilgilerini i�eren bir tablo olu�turulmu�
ve bu tablo ANA TABLO olarak kabul edilmi�tir.

2. Di�er �r�nler i�in de ayn� �ekilde tablolar olu�turulmu� ve bunlar da s�ras�yla
FIRST_PRODUCT
SECON_PRODUCT
THIRD_PRODUCT
tablolar� olarak kabul edilmi�tir.

3. ANA TABLO ile di�er �r�n tablolar� LEFT JOIN  ile birle�tirilmi�tir.

4. Elde edilen tablodaki �r�n s�tunlar�nda yer alan NULL de�erler ve �r�n isimleri
'NO' ve 'YES' ile de�i�tirilerek ANA tabloda belirtilen �r�n� alan ki�ilerin di�er ��
�r�n� al�p almad���n� g�steren tablo elde edilmi�tir*/

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

/* ANA TABLO �LE 1., 2., 3. PRODUCT TABLOLARININ LEFT JOIN �LE B�RLE�T�R�LMES�
VE NULL �FADELER�N�N STR�NG FONKS�YONLARLA D�ZELT�LMES�*/

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


/* ASS�GNMENT ��Z�M� 2: V�EW TANIMLAYARAK*/

/* VIEW OLU�TURMA */
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
/* JOINT_TABLE V�EW'� KULLANILARAK ANA TABLONUN OLU�TURULMASI */
SELECT * FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

/* JOINT_TABLE V�EW'� KULLANILARAK FIRST_PRODUCT TABLOSUNUN OLU�TURULMASI */
SELECT customer_id, product_name AS FIRST_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE 'Polk Audio - 50 W Woofer - Black'

/* JOINT_TABLE V�EW'� KULLANILARAK SECOND_PRODUCT TABLOSUNUN OLU�TURULMASI */
SELECT customer_id, product_name AS SECOND_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

/* JOINT_TABLE V�EW'� KULLANILARAK THIRD_PRODUCT TABLOSUNUN OLU�TURULMASI */
SELECT customer_id, product_name AS THIRD_PRODUCT FROM JOINT_TABLE
WHERE product_name LIKE '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

/* V�EW KULLANILARAK OLU�TURULAN ANA TABLO �LE D��ER �R�N TABLOLARININ
LEFT JOIN �LE B�RLE�T�R�LMES� VE STRING FONKS�YONLAR �LE �R�N 
KOLONLARININ B�LG�LER�N�N D�ZENLENMES� */
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
