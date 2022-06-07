/* 2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD 
isimli ürünü alan müþteri bilgileri*/
-- BU ANA TABLO
--Bu tablo ile diðer tablolarý(diðer ürünleri alýp almadýðýný belirten tablolarý)
-- LEFT JOIN ile birleþtirerek ilerleyebiliriz.
SELECT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
ORDER BY SC.customer_id


/* FIRST PRODUCT ('Polk Audio - 50 W Woofer - Black') TABLOSU*/

SELECT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS FIRST_PRODUCT
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

SELECT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS SECOND_PRODUCT
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

SELECT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS THIRD_PRODUCT
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

SELECT A.customer_id, A.first_name, A.last_name, FP.FIRST_PRODUCT, SP.SECOND_PRODUCT, TP.THIRD_PRODUCT
FROM (SELECT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD') AS A
LEFT JOIN (SELECT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS FIRST_PRODUCT
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = 'Polk Audio - 50 W Woofer - Black') as FP
ON A.customer_id = FP.customer_id
LEFT JOIN (SELECT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS SECOND_PRODUCT
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)') AS SP
ON A.customer_id=SP.customer_id
LEFT JOIN (SELECT SC.customer_id, SC.first_name, SC.last_name, PP.product_name AS THIRD_PRODUCT
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







/* 2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD 
isimli ürünü alan müþterilerin customer ID leri*/

SELECT SC.customer_id
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
ORDER BY SC.customer_id

/* 2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD 
isimli ürünü alan müþterilerin aldýklarý diðer ürün bilgilerinin getirilmesi*/

SELECT SC.customer_id, SC.first_name, SC.last_name, PP.product_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name
	IN('Polk Audio - 50 W Woofer - Black', 'SB-2000 12 500W Subwoofer (Piano Gloss Black)', 'Virtually Invisible 891 In-Wall Speakers (Pair)')
GROUP BY SC.customer_id, SC.first_name, SC.last_name, PP.product_name
HAVING SC.customer_id IN(SELECT SC.customer_id
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD')
ORDER BY SC.customer_id

/* UNION ile faklý sorgu sonuçlarýnýn birleþitirilmesi*/
/* NOT: UNION ile birleþtirilecek sonuçlarýn ayný uzunlukta olmasý gerekir.*/

SELECT SC.customer_id, SC.first_name, SC.last_name
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
UNION ALL
SELECT PP.product_name AS first_product
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name
	IN('Polk Audio - 50 W Woofer - Black')
GROUP BY SC.customer_id, SC.first_name, SC.last_name, PP.product_name
HAVING SC.customer_id IN(SELECT SC.customer_id
FROM product.product AS PP
INNER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
INNER JOIN sale.orders AS SO
ON SO.order_id = SOI.order_id
INNER JOIN sale.customer AS SC
ON SC.customer_id = SO.customer_id
WHERE PP.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD')
ORDER BY SC.customer_id








