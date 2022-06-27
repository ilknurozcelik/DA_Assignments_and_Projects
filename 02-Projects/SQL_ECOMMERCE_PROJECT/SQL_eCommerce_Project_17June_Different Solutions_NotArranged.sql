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

------------

/*  Check market_fact table */
select *
from market_fact;

-- changing Ord_id, Prod_id, Ship_id, Cust_id columns values of market_fact table
update market_fact
set Ord_id = replace(Ord_id, 'Ord_', ''), Prod_id = replace(Prod_id, 'Prod_', ''),
Ship_id = replace(Ship_id, 'SHP_', ''), Cust_id = replace(Cust_id, 'Cust_', '');

-- changing datatype of Ord_id, Prod_id, Ship_id, Cust_id columns in market_fact table
alter table market_fact alter column Ord_id INT NOT NULL;
alter table market_fact alter column Prod_id INT NOT NULL;
alter table market_fact alter column Ship_id INT NOT NULL;
alter table market_fact alter column Cust_id INT NOT NULL;

------------

/*  Check orders_dimen table */

select *
from orders_dimen;

-- changing Ord_id columns values of orders_dimen table
update orders_dimen
set Ord_id = replace(Ord_id, 'Ord_', '')

-- changing datatype of Ord_id column in orders_dimen table
alter table orders_dimen alter column Ord_id INT NOT NULL;

-------------

/*  Check prod_dimen table */

select *
from prod_dimen;

-- changing Ord_id columns values of prod_dimen table
update prod_dimen
set Prod_id = replace(Prod_id, 'Prod_', '');

-- changing datatype of Ord_id column in prod_dimen table
alter table prod_dimen alter column Prod_id INT NOT NULL;

--------------

/*  Check shipping_dimen table */

select *
from shipping_dimen;

-- changing Ship_id columns values of shipping_dimen table
update shipping_dimen
set Ship_id = replace(Ship_id, 'SHP_', '');

-- changing datatype of Ord_id column in shipping_dimen table
alter table shipping_dimen alter column Ship_id INT NOT NULL;

--checking distinct Ship_id information
select distinct Ship_id
from shipping_dimen;

--checking distinct Order_ID information
select distinct Order_ID
from shipping_dimen;

--########### Queries below, have been written to preparation for the analysis of tables given for project

/* check unique Oder, Product, Shipping and Customer counts for market_fact table */
select count(distinct Ord_id)Ord, count(distinct Prod_id)Prod, count(distinct Ship_id)Ship,
	count(distinct Cust_id)Cust
from market_fact;

/* finding distinct order informations in market_fact table*/
select distinct Ord_id, Prod_id, Ship_id, Cust_id
from market_fact;

/* finding  customers having two or more orders*/
select Ord_id, Prod_id, Ship_id, Cust_id, count(*)
from market_fact
group by Ord_id, Prod_id, Ship_id, Cust_id
having count(*) >= 2


/* finding order information of customers having two or more orders */
select A.*, B.cnt
from market_fact A, (
select Ord_id, Prod_id, Ship_id, Cust_id, count(*)cnt
from market_fact
group by Ord_id, Prod_id, Ship_id, Cust_id
having count(*) >= 2) B
where A.Ord_id=B.Ord_id AND A.Prod_id=B.Prod_id
	AND A.Ship_id=B.Ship_id AND A.Cust_id=B.Cust_id
order by A.Ord_id, A.Prod_id, A.Ship_id, A.Cust_id;


/* finding order information of customers having two or more orders with window function */

select * from
(
select *,count(*) over(partition by [Ship_id],[Cust_id],[Ord_id],[Prod_id]) count_
from [dbo].[market_fact]
) A
where A.count_>1


-- 1st attempt : joining market_fact, cust_dimen, orders_dimen, prod_dimen and shipping_dimen tables with inner join
select *
from market_fact
inner join cust_dimen on market_fact.Cust_id=cust_dimen.Cust_id
inner join orders_dimen on market_fact.Ord_id=orders_dimen.Ord_id
inner join prod_dimen on market_fact.Prod_id=prod_dimen.Prod_id
inner join shipping_dimen on market_fact.Ship_id=shipping_dimen.Ship_id

-- 2nd attempt : joining market_fact, cust_dimen, orders_dimen, prod_dimen and shipping_dimen tables with left join
select *
from market_fact
left join cust_dimen on market_fact.Cust_id=cust_dimen.Cust_id
left join orders_dimen on market_fact.Ord_id=orders_dimen.Ord_id
left join prod_dimen on market_fact.Prod_id=prod_dimen.Prod_id
left join shipping_dimen on market_fact.Ship_id=shipping_dimen.Ship_id

-- 3rd attempt : joining market_fact, cust_dimen, orders_dimen, prod_dimen and shipping_dimen tables with full outer join
select *
from market_fact
full outer join cust_dimen on market_fact.Cust_id=cust_dimen.Cust_id
full outer join orders_dimen on market_fact.Ord_id=orders_dimen.Ord_id
full outer join prod_dimen on market_fact.Prod_id=prod_dimen.Prod_id
full outer join shipping_dimen on market_fact.Ship_id=shipping_dimen.Ship_id


--### E-COMMERCE DATA AND CUSTOMER RETENTION ANALYSIS WITH SQL ###--
					--### PROJECT SOLUTION ### --

/* 1. Using the columns of �market_fact�, �cust_dimen�, �orders_dimen�, 
�prod_dimen�, �shipping_dimen�, Create a new table, named as
�combined_table�.  */

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

--checking combined_table
select *
from combined_table;


/* 2. Find the top 3 customers who have the maximum count of orders. */
contains the date difference of Order_Date and Ship_Date.
came back every month over the entire year in 2011 */
If any of the customers in the 1st month of 2011 came back every month in 2011,
purchasing and the third purchasing, in ascending order by Customer ID.
product 14, as well as the ratio of these products to the total number of 
products purchased by the customer. */

/* Categorize customers based on their frequency of visits. The following steps 
will guide you. If you want, you can track your own way */
(For each log, three field is kept: Cust_id, Year, Month) */
separately all months from the beginning business) */

create view monthly_visits as
order by 1



-- pivot table ile
select *
from (
	select distinct Cust_id, Year_, Month_,
) A
pivot (
	sum (monthly_visit_num)
	for Month_ in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) as pivot_table



---------- denemeler

select distinct Cust_id, Year(Order_Date)Year_, Month(Order_Date)Month_, Ord_id
where Cust_id=1163

select distinct Cust_id, Year(Order_Date)Year_, Month(Order_Date)Month_, Order_date, Ord_id 

select distinct Cust_id, Year(Order_Date)Year_, Month(Order_Date)Month_, count(*)


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
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))time_gap
from [dbo].[combined_table]
--group by cust_id, year(order_date), month(order_date), ord_id, order_date 
order by 1,2,3,4

--di�er yol

select Cust_id, Year_, Month_,
	lead(Year_) over(partition by Cust_id order by Year_, Month_) next_year,
	lead(Month_) over(partition by Cust_id order by Year_, Month_) next_month
from visit_log



/* 5. Categorise customers using average time gaps. Choose the most fitted
labeling model for you.
o Labeled as churn if the customer hasn't made another purchase in the 
months since they made their first purchase.
o Labeled as regular if the customer has made a purchase every month.
Etc.
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))monthly_time_gap 
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
)
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))monthly_time_gap 
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
)
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))monthly_time_gap 
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
), tbl2 as (
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))monthly_time_gap 
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
), tbl2 as (

 /* Find month-by-month customer retention rate since the start of the business. */
/*There are many different variations in the calculation of Retention Rate. But we will 
try to calculate the month-wise retention rate in this project.
So, we will be interested in how many of the customers in the previous month could 
be retained in the next month.
Proceed step by step by creating �views�. You can use the view you got at the end of 
the Customer Segmentation section as a source.

1. Find the number of customers retained month-wise. (You can use time gaps)
2. Calculate the month-wise retention rate. */
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))date_diff
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
;
	@year_min int,
	@year_max int,
	@month_min int,
	@month_max int,
	@retention_rate decimal(10,2)

select @year_min = min(years) from time_gap
select @year_max = max(years) from time_gap
select @month_min = min(months) from time_gap
select @month_max = max(months) from time_gap

while @year_min <= @year_max
	begin
		while @month_min <= @month_max
			begin
				insert into RETENTION_RATE values(@year_min, @month_min, @retention_rate)
				-- print @year_min
				-- print @month_min
				-- print @retention_rate
				set @month_min += 1
			end
		--print @retention_rate
		set @year_min += 1
		select @month_min = min(months) from time_gap
		
	end;
from RETENTION_RATE

--Serdar Hoca'dan gelen DENSE RANK l� kod:

create view tbl_by_time as
select distinct cust_id, year(order_date) years, month(order_date) months
	, dense_rank() over(order by year(order_date),month(order_date) ) rank_by_time
from combined_table
order by 4
-----------
-----------
create table result_table (
	years int,
	months int,
	monthly_rate decimal(10,2)
)
----------
---------
declare	 @rank_min int
		,@rank_max int
		,@result decimal(10,2)

select @rank_min = min(rank_by_time) from tbl_by_time
select @rank_max = max(rank_by_time) from tbl_by_time

while @rank_min < @rank_max
begin
	with t1 as(
	select cust_id
	from tbl_by_time
	where	rank_by_time = @rank_min
	intersect 
	select cust_id
	from tbl_by_time
	where	rank_by_time = @rank_min+1
	) 
	select @result = (1.0*count(*)/(select count(*) from tbl_by_time where rank_by_time = @rank_min))
	from t1	
insert into result_table 
values ( (select distinct years from tbl_by_time where rank_by_time=@rank_min)
		,(select distinct months from tbl_by_time where rank_by_time=@rank_min)
		,@result
		)
set @rank_min += 1
end


-------fonksiyon bitti ve tabloyu yazd�rd�k
select * from result_table


-- vildan hoca'dan gelen kod:

DECLARE
	@year_min int,
	@year_max int,
	@month_min int,
	@month_max int,
	@result decimal(10,2)

select @year_min = min(years) from time_gap
select @year_max = max(years) from time_gap
select @month_min = min(months) from time_gap
select @month_max = max(months) from time_gap

while @year_min <= @year_max
	begin
		while @month_min < @month_max
			begin
				with tbl as(
					select distinct cust_id
					from time_gap
					where years=@year_min and months=@month_min
					intersect
					select distinct cust_id
					from time_gap
					where years=@year_min and months=@month_min+1
					)
				select @result = (1.0*count(cust_id)/(select count(distinct cust_id) from time_gap where years=@year_min and months=@month_min))
				from tbl;
				PRINT @result
				set @month_min += 1
			end

		PRINT @result
		set @year_min += 1
	end


-- min year de�erini bulmak i�in
DECLARE
	@year int
	@year_min int,
	@year_max int,
	@month_min int,
	@month_max int
select @year_max = max(years) from time_gap
select @month_min = min(months) from time_gap
select @month_max = max(months) from time_gap

DROP TABLE IF EXISTS ???????????
CREATE TABLE RETENTION_RATE (
							YEAR INT,
							MONTH INT,
							cust_retention_rate DECIMAL(10,2));

DECLARE
	@year_min int,
	@year_max int,
	@month_min int,
	@month_max int,
	@customers_retained int

select @year_min = min(years) from time_gap
select @year_max = max(years) from time_gap
select @month_min = min(months) from time_gap
select @month_max = max(months) from time_gap

while @year_min <= @year_max
	begin
		while @month_min <= @month_max
			begin
				with tbl as(
					select distinct cust_id
					from time_gap
					where years=@year_min and months=@month_min
					intersect
					select distinct cust_id
					from time_gap
					where years=@year_min and months=@month_min+1
					)
				select @customers_retained = count(cust_id)
				from tbl;
				print @year_min
				print @month_min
				PRINT @customers_retained
				set @month_min += 1
			end

		PRINT @customers_retained
		set @year_min += 1
		select @month_min = min(months) from time_gap
	end


/* 2. Calculate the month-wise retention rate. */


-- Serdar Hoca'dan

select distinct cust_id, year(order_date) years, month(order_date) months
	, dense_rank() over(order by year(order_date),month(order_date) ) rank_
from combined_table
order by rank_