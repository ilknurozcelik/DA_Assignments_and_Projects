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
products purchased by the customer. */with tbl as(	select Cust_id, Prod_id, Order_Quantity,		sum(Order_Quantity) over (partition by Cust_id) total_product	from combined_table	where Cust_id in(		select Cust_id		from combined_table		where Prod_id = 11		INTERSECT		select Cust_id		from combined_table		where Prod_id = 14))select distinct Cust_id,	cast(1.0 * sum(Order_Quantity) over (partition by Cust_id) / total_product as decimal(3,2)) product_ratiofrom tblwhere Prod_id in (11,14)-- Aþaðýdaki kod doðru sonucu veriyor mu karþýlaþtýrýlacak?with tbl as (select Cust_id, Prod_id, Order_Quantity,		sum(Order_Quantity) over (partition by Cust_id) total_product,		sum(case when Prod_id =11 or Prod_id=14 then Order_quantity else 0 end)quantity_11_14	from combined_table	where Cust_id in(		select Cust_id		from combined_table		where Prod_id = 11		INTERSECT		select Cust_id		from combined_table		where Prod_id = 14)group by Cust_id, Prod_id, Order_Quantity)select Cust_id, sum(quantity_11_14),	cast(1.0* sum(quantity_11_14) / total_product as decimal (3,2)) product_ratiofrom tblgroup by Cust_id, total_productorder by Cust_id;