/* Assignment-4 */

/* Generate a report including product IDs and discount effects on whether the increase
in the discount rate positively impacts the number of orders for the products. */

-- product_id ve discount'a göre sipariþ sayýlarýný ve sipariþ verilen ürün miktarlarýný bulalým.

-- group by ile
SELECT product_id, discount, count(order_id) count_order, sum(quantity) total_amount_product
FROM sale.order_item
GROUP BY  product_id, discount
ORDER BY product_id, discount;

--window function ile
SELECT distinct product_id, discount, count(order_id) over (partition by product_id, discount)count_order,
		sum(quantity) over(partition by product_id, discount) total_amount_product
FROM sale.order_item;


/*
Ürün bazýnda order sayýlarýnýn ve ürün miktarlarýnýn discount artýþlarýna göre farklarý alýnmýþ,

 farklarýn toplamý pozitif olanlarýn indirimden pozitif,
 negatif olanlarýn negatif etkilendiði,
 sýfýr olanlarýn ise nötr olduðu

deðerlendirilmiþtir.

Bu yaklaþýmla soruyu çözelim.
*/


/* product_id ve discount'a göre sipariþ sayýlarýný ve sipariþ verilen ürün miktarlarýný bulan
bir view oluþturalým*/

create view discount_effect_main as
SELECT distinct product_id, discount, count(order_id) over (partition by product_id, discount)count_order,
		sum(quantity) over(partition by product_id, discount) total_amount_product
FROM sale.order_item;


/* oluþturulan view kullanýlarak lag() window fonksiyonu ile prv_order_count, prv_amount_product
sütunlarýný oluþturup, count_order ve total_amount_product deðerlerinin ürün bazýnda indirim artýþýna
göre artýp, artmadýklarýnýn bulunmasý ve diff_order ve diff_amount sütunlarýnýn oluþturulmasý */

select *, lag(count_order) over(partition by product_id order by discount) prv_order_count,
		lag(total_amount_product) over(partition by product_id order by discount) prv_amount_product,
		(count_order-lag(count_order) over(partition by product_id order by discount)) diff_order,
		(total_amount_product-lag(total_amount_product) over(partition by product_id order by discount)) diff_amount
from discount_effect_main;


/* diff_order ve diff_amount deðerlerinin ürün bazýnda toplamlarýnýn bulunmasý*/

with diff_label_cte as
	(select *, lag(count_order) over(partition by product_id order by discount) prv_order_count,
			lag(total_amount_product) over(partition by product_id order by discount) prv_amount_product,
			(count_order-lag(count_order) over(partition by product_id order by discount)) diff_order,
			(total_amount_product-lag(total_amount_product) over(partition by product_id order by discount)) diff_amount
	from discount_effect_main)
select product_id, sum(diff_order) total_order_diff, sum(diff_amount) total_amount_diff
from diff_label_cte
group by product_id;


/* case ile total_order_diff veya total_amount_diff deðeri
	>0 olanlara positive
	<0 olanlara negative
	=0 olanlara neutral
etiketlerinin verilmesi */


with diff_label_cte as
	(select *, lag(count_order) over(partition by product_id order by discount) prv_order_count,
			lag(total_amount_product) over(partition by product_id order by discount) prv_amount_product,
			(count_order-lag(count_order) over(partition by product_id order by discount)) diff_order,
			(total_amount_product-lag(total_amount_product) over(partition by product_id order by discount)) diff_amount
	from discount_effect_main)
select product_id,
	case 
		when sum(diff_order) < 0 then 'negative'
		when sum(diff_order) > 0 then 'positive'
		else 'neutral'
	end as diss_effect_order,
	case 
		when sum(diff_amount) < 0 then 'negative'
		when sum(diff_amount) > 0 then 'positive'
		else 'neutral'
	end as diss_effect_amount 
from diff_label_cte
group by product_id;
