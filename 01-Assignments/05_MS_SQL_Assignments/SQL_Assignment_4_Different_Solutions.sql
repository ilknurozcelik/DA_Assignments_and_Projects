/* Assignment-4 */

/* Generate a report including product IDs and discount effects on whether the increase
in the discount rate positively impacts the number of orders for the products. */

-- product_id ve discount'a göre order_count
SELECT SOI.product_id, SOI.discount , count(*) AS ORDER_COUNT
FROM sale.orders AS SO, sale.order_item AS SOI
WHERE SO.order_id = SOI.order_id
GROUP BY SOI.product_id, SOI.discount
ORDER BY SOI.product_id, SOI.discount

-- discount bazýnda order_count
SELECT SOI.discount , count(*) AS ORDER_COUNT
FROM sale.orders AS SO, sale.order_item AS SOI
WHERE SO.order_id = SOI.order_id
GROUP BY SOI.discount
ORDER BY SOI.discount


SELECT SOI.product_id, 
	count(SO.order_id) AS ORDER_COUNT, SOI.discount DENSE_RANK() OVER (PARTITION BY SOI.product_id ORDER BY count(SO.order_id))  as DISCOUNT_EFFECT
FROM sale.orders AS SO, sale.order_item AS SOI
WHERE SO.order_id = SOI.order_id

GROUP BY SOI.product_id, SOI.discount
ORDER BY SOI.product_id, SOI.discount



-- HOCA NIN ÇÖZÜMÜ
select  oi.product_id, count(oi.order_id), oi.discount , rank( ) over ( PARTITION by oi.product_id
                                                                        order by count(oi.product_id))  as DiscountEffect
from sale.order_item oi
join sale.orders so
on oi.order_id = so.order_id
GROUP by oi.product_id, oi.discount
ORDER by 1, 3

select  oi.product_id, count(oi.order_id) OrderCount, oi.discount ,
		rank( ) over ( PARTITION by oi.product_id order by count(oi.product_id))  as OrderCount_Rank,
		rank( ) over ( PARTITION by oi.product_id order by oi.discount)  as Discount_Rank
from sale.order_item oi
join sale.orders so
on oi.order_id = so.order_id
GROUP by oi.product_id, oi.discount
ORDER by 1, 3

SELECT SOI.product_id, count(*) AS ORDER_COUNT, avg(SOI.discount) avg_discount ,
	min(SOI.discount) min_discount, max(SOI.discount) max_discount,
	(max(SOI.discount)-min(SOI.discount)) discount_difference,
	(1.0*(max(SOI.discount)-min(SOI.discount))/ max(SOI.discount)) discount_rate
FROM sale.orders AS SO, sale.order_item AS SOI
WHERE SO.order_id = SOI.order_id
GROUP BY SOI.product_id
ORDER BY avg(SOI.discount)

SELECT SOI.product_id, sum(SOI.quantity) amount_product, count(*) AS ORDER_COUNT, avg(SOI.discount) avg_discount,
	min(SOI.discount) min_discount, max(SOI.discount) max_discount,
	(max(SOI.discount)-min(SOI.discount)) discount_difference,
	(1.0*(max(SOI.discount)-min(SOI.discount))/ max(SOI.discount)) discount_rate
FROM sale.orders AS SO, sale.order_item AS SOI
WHERE SO.order_id = SOI.order_id
GROUP BY SOI.product_id
ORDER BY (max(SOI.discount)-min(SOI.discount)), min(SOI.discount)


SELECT SOI.product_id, count(*) AS ORDER_COUNT, max(SOI.discount) max_discount
FROM sale.orders AS SO, sale.order_item AS SOI
WHERE SO.order_id = SOI.order_id
GROUP BY SOI.product_id
ORDER BY max(SOI.discount)


SELECT SOI.product_id, count(SO.order_id) AS ORDER_COUNT
FROM sale.orders AS SO, sale.order_item AS SOI
WHERE SO.order_id = SOI.order_id
GROUP BY SOI.product_id
ORDER BY max(SOI.discount)

-- pivot table
select *
from (
		select	soi.[product_id],soi.discount,so.[order_id]
		from [sale].[order_item] soi ,[sale].[orders] so
		where soi.[order_id]=so.[order_id]
		group by soi.[product_id],soi.discount,so.[order_id]
	) A
PIVOT ( count(order_id)
for discount in ([0.05],[0.07],[0.10],[0.20])
)pvt



-- serdar hoca'nýn çözümü:

select A.product_id,	case
				when A.first_+A.second_+A.third_>0 then 'Positive'
				when A.first_+A.second_+A.third_< 0 then 'Negative'
				else 'Nötr'
			end discount_Effect

from
(
select *,	case
				when pvt.[0.07]-pvt.[0.05]> 0 then 1
				when pvt.[0.07]-pvt.[0.05]< 0 then -1
				else 0
			end first_
		,	case
				when pvt.[0.10]-pvt.[0.07]> 0 then 1
				when pvt.[0.10]-pvt.[0.07]< 0 then -1
				else 0
			end second_
		
		, case
				when pvt.[0.20]-pvt.[0.10]> 0 then 1
				when pvt.[0.20]-pvt.[0.10]< 0 then -1
				else 0
			end third_
from (
		select	soi.[product_id],soi.discount,so.[order_id]
		from [sale].[order_item] soi ,[sale].[orders] so
		where soi.[order_id]=so.[order_id]
		group by soi.[product_id],soi.discount,so.[order_id]
	) A
PIVOT ( 
count(order_id)
for discount in ([0.05],[0.07],[0.10],[0.20])
)pvt
) A



---16 June
/* Generate a report including product IDs and discount effects on whether the increase
in the discount rate positively impacts the number of orders for the products. */

SELECT order_id, discount, product_id,  count(order_id) count_order, sum(quantity) total_amount_product
FROM sale.order_item
GROUP BY order_id, discount, product_id

SELECT  order_id, discount, product_id,  count(order_id) count_order, sum(quantity) total_amount_product
FROM sale.order_item
GROUP BY  order_id, discount, product_id



SELECT product_id, discount, count(order_id) count_order, sum(quantity) total_amount_product
FROM sale.order_item
GROUP BY  product_id, discount
ORDER BY product_id, discount


SELECT distinct product_id, discount, count(order_id) over (partition by product_id, discount)count_order,
		sum(quantity) over(partition by product_id, discount) total_amount_product
FROM sale.order_item

/*
SELECT distinct product_id, discount, count(order_id) over (partition by product_id order by discount)count_order,
		sum(quantity) over(partition by product_id order by discount) total_amount_product
FROM sale.order_item

bizim iþimize yaramýyor
*/

/* YAKLAÞIM: ürün bazýnda order veya amount miktarlarýnýn discount artýþlarýna göre farklarý alýnýp, farklarýn toplamý
positive olanlar discount'tan positive,
negative olanlar negative etkilenmiþtir. Sýfýr olanlar da nötr olarak deðerlendirilmiþtir.
Bu yaklaþýmla soruyu çözelim.*/

create view discount_effect_main as
SELECT distinct product_id, discount, count(order_id) over (partition by product_id, discount)count_order,
		sum(quantity) over(partition by product_id, discount) total_amount_product
FROM sale.order_item



select *, lag(count_order) over(partition by product_id order by discount) prv_order_count,
		lag(total_amount_product) over(partition by product_id order by discount) prv_amount_product,
		(count_order-lag(count_order) over(partition by product_id order by discount)) diff_order,
		(total_amount_product-lag(total_amount_product) over(partition by product_id order by discount)) diff_amount
from discount_effect_main


with cume_dist_cte as
	(select *, lag(count_order) over(partition by product_id order by discount) prv_order_count,
			lag(total_amount_product) over(partition by product_id order by discount) prv_amount_product,
			(count_order-lag(count_order) over(partition by product_id order by discount)) diff_order,
			(total_amount_product-lag(total_amount_product) over(partition by product_id order by discount)) diff_amount
	from discount_effect_main)
select product_id, sum(diff_order) total_order_diff, sum(diff_amount) total_amount_diff
from cume_dist_cte
group by product_id

/* case ile diff deðeri >0 olanlara positive
	<0 olanlara negative
	=0 olanalra nötr */

with cume_dist_cte as
	(select *, lag(count_order) over(partition by product_id order by discount) prv_order_count,
			lag(total_amount_product) over(partition by product_id order by discount) prv_amount_product,
			(count_order-lag(count_order) over(partition by product_id order by discount)) diff_order,
			(total_amount_product-lag(total_amount_product) over(partition by product_id order by discount)) diff_amount
	from discount_effect_main)
select product_id, sum(diff_order) total_order_diff, sum(diff_amount) total_amount_diff,
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
from cume_dist_cte
group by product_id



with cume_dist_cte as
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
from cume_dist_cte
group by product_id


/* 2. YAKLAÞIM: 
product_id ye göre gruplayýp, order ve amountlarýn ortalamasýný alýp, */


select *, avg(count_order) over(partition by product_id) avg_order_count,
		avg(total_amount_product) over(partition by product_id) avg_amount_product,
		(avg(count_order) over(partition by product_id)-count_order) diff_order,
		(avg(total_amount_product) over(partition by product_id) - total_amount_product) diff_amount
from discount_effect_main


with cume_dist_cte as
	(select *, avg(count_order) over(partition by product_id) avg_order_count,
		avg(total_amount_product) over(partition by product_id) avg_amount_product,
		(avg(count_order) over(partition by product_id)-count_order) diff_order,
		(avg(total_amount_product) over(partition by product_id) - total_amount_product) diff_amount
from discount_effect_main)
select distinct product_id, first_value(diff_order) over(partition by product_id order by discount) as frst_diff_order,
	first_value(diff_amount) over(partition by product_id order by discount) as frst_diff_amount
from cume_dist_cte


with cume_dist_cte as
	(select *, avg(count_order) over(partition by product_id) avg_order_count,
		avg(total_amount_product) over(partition by product_id) avg_amount_product,
		(avg(count_order) over(partition by product_id)-count_order) diff_order,
		(avg(total_amount_product) over(partition by product_id) - total_amount_product) diff_amount
from discount_effect_main)
select distinct product_id, first_value(diff_order) over(partition by product_id order by discount) as frst_diff_order,
	first_value(diff_amount) over(partition by product_id order by discount) as frst_diff_amount,
	case 
		when first_value(diff_order) over(partition by product_id order by discount) < 0 then 'negative'
		when first_value(diff_order) over(partition by product_id order by discount) > 0 then 'positive'
		else 'neutral'
	end as diss_effect_order,
	case 
		when first_value(diff_amount) over(partition by product_id order by discount) < 0 then 'negative'
		when first_value(diff_amount) over(partition by product_id order by discount) > 0 then 'positive'
		else 'neutral'
	end as diss_effect_amount 
from cume_dist_cte;


with cume_dist_cte as
	(select *, avg(count_order) over(partition by product_id) avg_order_count,
		avg(total_amount_product) over(partition by product_id) avg_amount_product,
		(avg(count_order) over(partition by product_id)-count_order) diff_order,
		(avg(total_amount_product) over(partition by product_id) - total_amount_product) diff_amount
from discount_effect_main)
select distinct product_id,
	case 
		when first_value(diff_order) over(partition by product_id order by discount) < 0 then 'negative'
		when first_value(diff_order) over(partition by product_id order by discount) > 0 then 'positive'
		else 'neutral'
	end as diss_effect_order,
	case 
		when first_value(diff_amount) over(partition by product_id order by discount) < 0 then 'negative'
		when first_value(diff_amount) over(partition by product_id order by discount) > 0 then 'positive'
		else 'neutral'
	end as diss_effect_amount 
from cume_dist_cte;


-- temp table oluþturmak için
with cume_dist_cte as
	(select *, avg(count_order) over(partition by product_id) avg_order_count,
		avg(total_amount_product) over(partition by product_id) avg_amount_product,
		(avg(count_order) over(partition by product_id)-count_order) diff_order,
		(avg(total_amount_product) over(partition by product_id) - total_amount_product) diff_amount
from discount_effect_main)
select distinct product_id,
	case 
		when first_value(diff_order) over(partition by product_id order by discount) < 0 then 'negative'
		when first_value(diff_order) over(partition by product_id order by discount) > 0 then 'positive'
		else 'neutral'
	end as diss_effect_order,
	case 
		when first_value(diff_amount) over(partition by product_id order by discount) < 0 then 'negative'
		when first_value(diff_amount) over(partition by product_id order by discount) > 0 then 'positive'
		else 'neutral'
	end as diss_effect_amount
into #temp_table
from cume_dist_cte

-- avg yaklaþýmý ile
select diss_effect_order, count(diss_effect_order) count_catg
from #temp_table
group by diss_effect_order

select diss_effect_amount, count(diss_effect_amount) count_catg
from #temp_table
group by diss_effect_amount



-- 1. yaklaþým için temp_table oluþturma

with cume_dist_cte as
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
into #temp_table1
from cume_dist_cte
group by product_id

-- 1. yaklaþýmý ile 
select diss_effect_order, count(diss_effect_order) count_catg
from #temp_table1
group by diss_effect_order

select diss_effect_amount, count(diss_effect_amount) count_catg
from #temp_table1
group by diss_effect_amount

-- 2. yaklaþým
select diss_effect_order, count(diss_effect_order) count_catg
from #temp_table
group by diss_effect_order

select diss_effect_amount, count(diss_effect_amount) count_catg
from #temp_table
group by diss_effect_amount