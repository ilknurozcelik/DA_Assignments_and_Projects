/* Assignment 4 Solution */

--indirim oranlar�na g�re ilk ve son indirimlere kar��l�k gelen de�erler aras�ndaki farklar� bularak ilerleyelim.
-- Fark� en d���k indirimdeki �r�n miktar�na b�lerek art�� oran� bulal�m.
with T1 as(
	select product_id, discount, sum(quantity)total_quantity
	from sale.order_item
	group by product_id, discount
), T2 as(
	select *,
		FIRST_VALUE(total_quantity) over (partition by product_id order by discount) lower_dis_quan,
		last_value(total_quantity) over (partition by product_id order by discount rows between unbounded preceding and unbounded following) higher_dis_quan
	from T1
), T3 as (
	select *, (1.0 *( higher_dis_quan - lower_dis_quan) / lower_dis_quan) increase_rate
	from T2
)
select distinct product_id,
	CASE WHEN increase_rate >= 0.05 THEN 'pozitive'
		WHEN increase_rate <= -0.05 THEN 'negative'
		ELSE 'neutral'
	END discount_effect
from T3;