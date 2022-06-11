/* Assignment-2 Solution */


SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_id, PP.product_name
FROM product.product AS PP, sale.order_item AS SOI, sale.orders AS SO, sale.customer SC
WHERE PP.product_id=SOI.product_id
	AND SOI.order_id=SO.order_id
	AND SO.customer_id= SC.customer_id
	AND product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_id, PP.product_name
FROM product.product AS PP, sale.order_item AS SOI, sale.orders AS SO, sale.customer SC
WHERE PP.product_id=SOI.product_id
	AND SOI.order_id=SO.order_id
	AND SO.customer_id= SC.customer_id
	AND product_name = 'Polk Audio - 50 W Woofer - Black'

SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_id, PP.product_name
FROM product.product AS PP, sale.order_item AS SOI, sale.orders AS SO, sale.customer SC
WHERE PP.product_id=SOI.product_id
	AND SOI.order_id=SO.order_id
	AND SO.customer_id= SC.customer_id
	AND product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'



/* Creating View */
CREATE VIEW CUSTOMER_PRODUCT AS
	SELECT DISTINCT SC.customer_id, SC.first_name, SC.last_name, PP.product_id, PP.product_name
	FROM product.product AS PP, sale.order_item AS SOI, sale.orders AS SO, sale.customer SC
	WHERE PP.product_id=SOI.product_id
		AND SOI.order_id=SO.order_id
		AND SO.customer_id= SC.customer_id

/* Solution of Assignment_2 by using view */

SELECT A.customer_id, A.first_name, A.last_name,
	ISNULL (NULLIF (ISNULL(B.product_name, 'NO'), B.product_name), 'YES') First_product,
	ISNULL (NULLIF (ISNULL(C.product_name, 'NO'), C.product_name), 'YES') Second_product,
	ISNULL (NULLIF (ISNULL(D.product_name, 'NO'), D.product_name), 'YES') Third_product
FROM (
	SELECT * FROM CUSTOMER_PRODUCT
	where product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)') A
	LEFT JOIN(
		SELECT * FROM CUSTOMER_PRODUCT
		where product_name = 'Polk Audio - 50 W Woofer - Black') B
	ON A.customer_id = B.customer_id
	LEFT JOIN(
		SELECT * FROM CUSTOMER_PRODUCT
		where product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)') C
	ON A.customer_id = C.customer_id
	LEFT JOIN(
		SELECT * FROM CUSTOMER_PRODUCT
		where product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)') D
	ON A.customer_id=D.customer_id