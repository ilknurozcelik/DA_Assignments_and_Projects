/* E-COMMERCE DATA AND CUSTOMER RETENTION ANALYSIS WITH SQL */

/* CREATE A DATABASE */

CREATE DATABASE E_COMMERCE;

/* Check cust_dimen table */
select *
from cust_dimen;

select distinct Cust_id
from cust_dimen;

-- changing Cust_id columns values
update cust_dimen
set Cust_id = replace(Cust_id, 'Cust_', '');

-- changing datatype of Cust_id column
alter table cust_dimen alter column Cust_id INT;

/*  Check market_fact table */
select *
from market_fact;

select count(distinct Ord_id)Ord, count(distinct Prod_id)Prod, count(distinct Ship_id)Ship,
	count(distinct Cust_id)Cust
from market_fact;

select distinct Ord_id, Prod_id, Ship_id, Cust_id
from market_fact;


select Ord_id, Prod_id, Ship_id, Cust_id, count(*)
from market_fact
group by Ord_id, Prod_id, Ship_id, Cust_id
having count(*) >= 2

select *
from market_fact A, (
select Ord_id, Prod_id, Ship_id, Cust_id, count(*)cnt
from market_fact
group by Ord_id, Prod_id, Ship_id, Cust_id
having count(*) >= 2) B
where A.Ord_id=B.Ord_id AND A.Prod_id=B.Prod_id
	AND A.Ship_id=B.Ship_id AND A.Cust_id=B.Cust_id
order by A.Ord_id, A.Prod_id, A.Ship_id, A.Cust_id


select * from
(
select *,count(*) over(partition by [Ship_id],[Cust_id],[Ord_id],[Prod_id]) count_
from [dbo].[market_fact]
) A
where A.count_>1

select distinct [Ship_id], Sales
from market_fact;



-- changing Ord_id, Prod_id, Ship_id, Cust_id columns values
update market_fact
set Ord_id = replace(Ord_id, 'Ord_', ''), Prod_id = replace(Prod_id, 'Prod_', ''),
Ship_id = replace(Ship_id, 'SHP_', ''), Cust_id = replace(Cust_id, 'Cust_', '');


-- changing datatype of Ord_id, Prod_id, Ship_id, Cust_id columns
alter table market_fact alter column Ord_id INT NOT NULL;
alter table market_fact alter column Prod_id INT NOT NULL;
alter table market_fact alter column Ship_id INT NOT NULL;
alter table market_fact alter column Cust_id INT NOT NULL;

/*  Check orders_dimen table */

select *
from orders_dimen;


-- changing Ord_id columns values
update orders_dimen
set Ord_id = replace(Ord_id, 'Ord_', '')

-- changing datatype of Ord_id column
alter table orders_dimen alter column Ord_id INT NOT NULL;

/*  Check prod_dimen table */

select *
from prod_dimen;

-- changing Ord_id columns values
update prod_dimen
set Prod_id = replace(Prod_id, 'Prod_', '');

-- changing datatype of Ord_id column
alter table prod_dimen alter column Prod_id INT NOT NULL;

/*  Check shipping_dimen table */

select *
from shipping_dimen;

select distinct Ship_id
from shipping_dimen;

select distinct Order_ID
from shipping_dimen;

-- changing Ship_id columns values
update shipping_dimen
set Ship_id = replace(Ship_id, 'SHP_', '');

-- changing datatype of Ord_id column
alter table shipping_dimen alter column Ship_id INT NOT NULL;


select *
from market_fact
left join cust_dimen on market_fact.Cust_id=cust_dimen.Cust_id
left join orders_dimen on market_fact.Ord_id=orders_dimen.Ord_id
left join prod_dimen on market_fact.Prod_id=prod_dimen.Prod_id
left join shipping_dimen on market_fact.Ship_id=shipping_dimen.Ship_id


select *
from market_fact
full outer join cust_dimen on market_fact.Cust_id=cust_dimen.Cust_id
full outer join orders_dimen on market_fact.Ord_id=orders_dimen.Ord_id
full outer join prod_dimen on market_fact.Prod_id=prod_dimen.Prod_id
full outer join shipping_dimen on market_fact.Ship_id=shipping_dimen.Ship_id

/* 1. Using the columns of “market_fact”, “cust_dimen”, “orders_dimen”, 
“prod_dimen”, “shipping_dimen”, Create a new table, named as
“combined_table”.  */

with tbl as (
select cust_dimen.*, orders_dimen.*, prod_dimen.*,  shipping_dimen.*, market_fact.[Sales],
	market_fact.[Discount], market_fact.[Order_Quantity], market_fact.[Product_Base_Margin]
from market_fact
left join cust_dimen on market_fact.Cust_id=cust_dimen.Cust_id
left join orders_dimen on market_fact.Ord_id=orders_dimen.Ord_id
left join prod_dimen on market_fact.Prod_id=prod_dimen.Prod_id
left join shipping_dimen on market_fact.Ship_id=shipping_dimen.Ship_id
)
select *
into combined_table
from tbl;

select * from combined_table

/* 2. Find the top 3 customers who have the maximum count of orders. */select distinct top 3 Cust_id, Customer_Name,	count(Ord_id) over (partition by Cust_id) order_countfrom combined_tableorder by order_count desc/* 3. Create a new column at combined_table as DaysTakenForDelivery that 
contains the date difference of Order_Date and Ship_Date. */select Ord_id, DATEDIFF(DAY, Order_Date, Ship_Date)DaysTakenForDeliveryfrom combined_tableorder by Ord_id, DaysTakenForDeliveryalter table combined_table add DaysTakenForDelivery INT;update combined_tableset  DaysTakenForDelivery = DATEDIFF(DAY, Order_Date, Ship_Date);/* 4. Find the customer whose order took the maximum time to get delivered. */ select top 1 Cust_id, Customer_Name, DaysTakenForDelivery from combined_table order by DaysTakenForDelivery desc /* 5. Count the total number of unique customers in January and how many of them 
came back every month over the entire year in 2011 */-- 2011 1. aydaki unique customerselect distinct Cust_idfrom combined_tablewhere year(Order_Date) = 2011 and month(Order_Date) = 1select *from(	select Cust_id, month(Order_Date) month_, Ord_id	from combined_table	where Cust_id in (				select distinct Cust_id				from combined_table				where year(Order_Date) = 2011 and month(Order_Date) = 1)			and year(Order_Date) = 2011	--order by Cust_id, Order_Date)tblpivot(	count(Ord_id)	for month_	in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) as pivot_table;select Cust_id,count(distinct month(order_date))
from combined_table
where cust_id in (select distinct cust_id
				from combined_table
				where year(order_date) = 2011 and month(order_date) = 1)
			and year(order_date) = 2011
group by  Cust_id
having count(distinct month(order_date))=12/* 6. Write a query to return for each user the time elapsed between the first 
purchasing and the third purchasing, in ascending order by Customer ID. */select Cust_id, order_date,	ROW_NUMBER () OVER(PARTITION BY Cust_id ORDER BY order_date) RowNumberfrom combined_tablewhere Cust_id in (	select Cust_id	from combined_table	group by Cust_id	having count(order_date) >= 3	)select Cust_id, order_date,	ROW_NUMBER () OVER(PARTITION BY Cust_id ORDER BY order_date) RowNumber,	datediff(d,order_date,lead(order_date,2,order_date) over(partition by cust_id order by order_date))time_elapsedfrom combined_tablewhere Cust_id in (	select Cust_id	from combined_table	group by Cust_id	having count(order_date) >= 3	)with tbl as(	select Cust_id, order_date,		ROW_NUMBER () OVER(PARTITION BY Cust_id ORDER BY order_date) RowNumber,		datediff(d,order_date,lead(order_date,2,order_date) over(partition by cust_id order by order_date))time_elapsed	from combined_table	where Cust_id in (		select Cust_id		from combined_table		group by Cust_id		having count(order_date) >= 3		))select Cust_id,  time_elapsedfrom tblwhere RowNumber=1-- Row number ile çözümü deneyelim./* 7. Write a query that returns customers who purchased both product 11 and 
product 14, as well as the ratio of these products to the total number of 
products purchased by the customer. */with tbl as(	select Cust_id, Prod_id, Order_Quantity,		sum(Order_Quantity) over (partition by Cust_id) total_product	from combined_table	where Cust_id in(		select Cust_id		from combined_table		where Prod_id = 11		INTERSECT		select Cust_id		from combined_table		where Prod_id = 14))select distinct Cust_id,	cast(1.0 * sum(Order_Quantity) over (partition by Cust_id) / total_product as decimal(3,2)) product_ratiofrom tblwhere Prod_id in (11,14)-- Aþaðýdaki kod doðru sonucu veriyor mu karþýlaþtýrýlacak?with tbl as (select Cust_id, Prod_id, Order_Quantity,		sum(Order_Quantity) over (partition by Cust_id) total_product,		sum(case when Prod_id =11 or Prod_id=14 then Order_quantity else 0 end)quantity_11_14	from combined_table	where Cust_id in(		select Cust_id		from combined_table		where Prod_id = 11		INTERSECT		select Cust_id		from combined_table		where Prod_id = 14)group by Cust_id, Prod_id, Order_Quantity)select Cust_id, sum(quantity_11_14),	cast(1.0* sum(quantity_11_14) / total_product as decimal (3,2)) product_ratiofrom tblgroup by Cust_id, total_productorder by Cust_id;/* Customer Segmentation */

/* Categorize customers based on their frequency of visits. The following steps 
will guide you. If you want, you can track your own way *//* 1. Create a “view” that keeps visit logs of customers on a monthly basis. (For 
each log, three field is kept: Cust_id, Year, Month) */alter view visit_log asselect distinct Cust_id, Year(Order_Date)Year_, Month(Order_Date)Month_, Ord_idfrom combined_table/* 2. Create a “view” that keeps the number of monthly visits by users. (Show 
separately all months from the beginning business) */

create view monthly_visits asselect distinct Cust_id, Year_, Month_,	count(*) over (partition by  Cust_id, Year_, Month_)monthly_visit_numfrom visit_log


---------- denemeler

select distinct Cust_id, Year(Order_Date)Year_, Month(Order_Date)Month_, Ord_idfrom combined_table
where Cust_id=1163

select distinct Cust_id, Year(Order_Date)Year_, Month(Order_Date)Month_, Order_date, Ord_id from combined_tablegroup by Year(Order_Date)Year_, Month(Order_Date)Month_,order by 1,2,3

select distinct Cust_id, Year(Order_Date)Year_, Month(Order_Date)Month_, count(*)from combined_tablegroup by Cust_id, Year(Order_Date), Month(Order_Date)order by 1,2,3


select *
from combined_table
where Cust_id =1163
order by Order_date

------


/* 3. For each visit of customers, create the next month of the visit as a separate 
column. */

select Cust_id, Year_, Month_,
	lead(Month_) over(partition by Cust_id, Year_ order by Month_) next_month
from monthly_visits


select Cust_id, Year_, Month_,
	lead(Month_) over(partition by Cust_id, Year_ order by Month_) next_month
from visit_log


select Cust_id, Year_, Month_,
	lead(Year_) over(partition by Cust_id order by Year_, Month_) next_year,
	lead(Month_) over(partition by Cust_id order by Year_, Month_) next_month
from visit_log

select Cust_id, Year_, Month_,
	lead(Month_) over(partition by Cust_id, Year_ order by Month_) next_month
from visit_log

/* 4. Calculate the monthly time gap between two consecutive visits by each 
customer. */

--Serdar Hoca'dan
select cust_id, year(order_date)years, month(order_date)months, ord_id, order_date 
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
order by 1,2,3,4

--diðer yol

select Cust_id, Year_, Month_,
	lead(Year_) over(partition by Cust_id order by Year_, Month_) next_year,
	lead(Month_) over(partition by Cust_id order by Year_, Month_) next_month
from visit_log



/* 5. Categorise customers using average time gaps. Choose the most fitted
labeling model for you.For example: 
o Labeled as churn if the customer hasn't made another purchase in the 
months since they made their first purchase.
o Labeled as regular if the customer has made a purchase every month.
Etc.*/with tbl as (select cust_id, year(order_date)years, month(order_date)months, ord_id, order_date 
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))monthly_time_gap 
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
)select *,	avg(monthly_time_gap) over(partition by cust_id) avg_time_gap,	count(ord_id) over(partition by cust_id) total_order_per_custfrom tbl-- cust_id ve year partition yapýlarakwith tbl as (select cust_id, year(order_date)years, month(order_date)months, ord_id, order_date 
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))monthly_time_gap 
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
)select *,	avg(monthly_time_gap) over(partition by cust_id) avg_time_gap,	count(ord_id) over(partition by cust_id) total_order_per_cust,	avg(monthly_time_gap) over(partition by cust_id, years) avg_time_gap_wy,	count(ord_id) over(partition by cust_id, years) total_order_per_cust_wyfrom tbl-- avg_time_gap ve total_order_per_cust verilerinden gidersekwith tbl as (select cust_id, year(order_date)years, month(order_date)months, ord_id, order_date 
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))monthly_time_gap 
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
), tbl2 as (select *,	avg(monthly_time_gap) over(partition by cust_id) avg_time_gap_per_cust,	avg(monthly_time_gap) over() avg_time_gap,	count(ord_id) over(partition by cust_id) total_order_per_cust	from tbl), tbl3 as (select *from tbl2), tbl4 as (select *,	avg(total_order_per_cust) over() avg_order_count,	ntile(4) over(order by avg_time_gap_per_cust) ntile_for_avg_time_gapfrom tbl3)select *from tbl4where ntile_for_avg_time_gap=1/*Yukarýda;- müþteri bazýnda ortalama sipariþ zaman aralýðý (avg_time_gap_per_cust),- tüm veri için ortalama sipariþ zaman aralýðý (avg_time_gap),- müþteri bazýnda toplam sipariþ sayýsý (total_order_per_cust),- tüm veri için ortalama sipariþ sayýsý (avg_order_count) ve-- avg_time_gap_per_cust deðerlerine göre ntile (ntile_for_avg_time_gap) deðerlerihesaplanmýþ ve tüm bu veriler deðerlendirilerek müþterilerin categorilere ayýrýlmasý içinaþaðýdaki modelin kullanýlmasýna karar verilmiþtir.1. Sadece tek alýþveriþ yapmýþ olanlar (total_order_per_cust=1 olanlar) 'CHUNK',2. avg_time_gap_per_cust <= 4 ve total_order_per_cust > avg_time_gap_per_cust olanlar 'MOST VISITING'3. avg_time_gap_per_cust = 6 ve total_order_per_cust > avg_time_gap_per_cust ile	avg_time_gap_per_cust > 6 olanlar 'LESS VISITING'4. diðerleri ise 'MODERATE VISITING'olarak aþaðýda etiketlenmiþtir.