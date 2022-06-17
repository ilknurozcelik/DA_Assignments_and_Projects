/* Assignment-4 */

/* Generate a report including product IDs and discount effects on whether the increase
in the discount rate positively impacts the number of orders for the products. */

-- product_id ve discount'a g�re sipari� say�lar�n� ve sipari� verilen �r�n miktarlar�n� bulal�m.

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
�r�n baz�nda order say�lar�n�n ve �r�n miktarlar�n�n discount art��lar�na g�re farklar� al�nm��,

 farklar�n toplam� pozitif olanlar�n indirimden pozitif,
 negatif olanlar�n negatif etkilendi�i,
 s�f�r olanlar�n ise n�tr oldu�u

de�erlendirilmi�tir.

Bu yakla��mla soruyu ��zelim.
*/


/* product_id ve discount'a g�re sipari� say�lar�n� ve sipari� verilen �r�n miktarlar�n� bulan
bir view olu�tural�m*/

create view discount_effect_main as
SELECT distinct product_id, discount, count(order_id) over (partition by product_id, discount)count_order,
		sum(quantity) over(partition by product_id, discount) total_amount_product
FROM sale.order_item;


/* olu�turulan view kullan�larak lag() window fonksiyonu ile prv_order_count, prv_amount_product
s�tunlar�n� olu�turup, count_order ve total_amount_product de�erlerinin �r�n baz�nda indirim art���na
g�re art�p, artmad�klar�n�n bulunmas� ve diff_order ve diff_amount s�tunlar�n�n olu�turulmas� */

select *, lag(count_order) over(partition by product_id order by discount) prv_order_count,
		lag(total_amount_product) over(partition by product_id order by discount) prv_amount_product,
		(count_order-lag(count_order) over(partition by product_id order by discount)) diff_order,
		(total_amount_product-lag(total_amount_product) over(partition by product_id order by discount)) diff_amount
from discount_effect_main;


/* diff_order ve diff_amount de�erlerinin �r�n baz�nda toplamlar�n�n bulunmas�*/

with diff_label_cte as
	(select *, lag(count_order) over(partition by product_id order by discount) prv_order_count,
			lag(total_amount_product) over(partition by product_id order by discount) prv_amount_product,
			(count_order-lag(count_order) over(partition by product_id order by discount)) diff_order,
			(total_amount_product-lag(total_amount_product) over(partition by product_id order by discount)) diff_amount
	from discount_effect_main)
select product_id, sum(diff_order) total_order_diff, sum(diff_amount) total_amount_diff
from diff_label_cte
group by product_id;


/* case ile total_order_diff veya total_amount_diff de�eri
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
