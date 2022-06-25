/* E-COMMERCE DATA AND CUSTOMER RETENTION ANALYSIS WITH SQL */

		--########## CREATE A DATABASE ##########--

CREATE DATABASE E_COMMERCE;

	--########## IMPORTING TABLES AND ARRANGING THEM ##########--

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


--### E-COMMERCE DATA AND CUSTOMER RETENTION ANALYSIS WITH SQL ###--
					--### PROJECT SOLUTION ### --

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

--checking combined_table
select *
from combined_table;

----------------------------
/* 2. Find the top 3 customers who have the maximum count of orders. */--solution with cte and window function with main_table as (	select distinct Cust_id, Customer_Name, Ord_id	from combined_table)select distinct top 3 Cust_id, Customer_Name,	count(*) over (partition by Cust_id) order_countfrom main_tableorder by 3 desc;--solution with group byselect top 3 Cust_id, Customer_Name, count(distinct Ord_id)order_countfrom combined_tablegroup by Cust_id, Customer_Nameorder by 3 desc;-----------------------------/* 3. Create a new column at combined_table as DaysTakenForDelivery that 
contains the date difference of Order_Date and Ship_Date. */--checking the date difference between Order_Date and Ship_Dateselect Ord_id, DATEDIFF(DAY, Order_Date, Ship_Date)DaysTakenForDeliveryfrom combined_tableorder by Ord_id, DaysTakenForDelivery;--creating a new empty column in combined table in the name of 'DaysTakenForDelivery'alter table combined_table add DaysTakenForDelivery INT;--assign the values of date difference between Order_Date and Ship_Date to the 'DaysTakenForDelivery' columnupdate combined_tableset  DaysTakenForDelivery = DATEDIFF(DAY, Order_Date, Ship_Date);------------------------------/* 4. Find the customer whose order took the maximum time to get delivered. */ select top 1 Cust_id, Customer_Name, DaysTakenForDelivery from combined_table order by DaysTakenForDelivery desc; ----------------------------- /* 5. Count the total number of unique customers in January and how many of them 
came back every month over the entire year in 2011 */-- 1st aproach: finding the total number of unique customers in January and-- Find out how many of the customers in the 1st month of 2011 came back every month in 2011 with pivot table-- count of unique customers in 2011 Januaryselect distinct Cust_idfrom combined_tablewhere year(Order_Date) = 2011 and month(Order_Date) = 1;-- count of customers who came back every month over the entire year in 2011with customer_every_month as(		select *	from(		select Cust_id, DATENAME(MONTH, Order_Date) month_, Ord_id		from combined_table		where Cust_id in (					select distinct Cust_id					from combined_table					where year(Order_Date) = 2011 and month(Order_Date) = 1)				and year(Order_Date) = 2011	)tbl	pivot(		count(Ord_id)		for month_		in ([January],[February],[March],[April],[May],[June],[July],[August],			[September],[October],[November],[December])) as pivot_table)select distinct	SUM(CASE WHEN January > 0 THEN 1 ELSE 0 END) OVER()total_cust_Jan,	SUM(CASE WHEN February > 0 THEN 1 ELSE 0 END) OVER()total_cust_Feb,	SUM(CASE WHEN March > 0 THEN 1 ELSE 0 END) OVER()total_cust_Mrch,	SUM(CASE WHEN April > 0 THEN 1 ELSE 0 END) OVER()total_cust_Apr,	SUM(CASE WHEN May > 0 THEN 1 ELSE 0 END) OVER()total_cust_May,	SUM(CASE WHEN June > 0 THEN 1 ELSE 0 END) OVER()total_cust_June,	SUM(CASE WHEN July > 0 THEN 1 ELSE 0 END) OVER()total_cust_July,	SUM(CASE WHEN August > 0 THEN 1 ELSE 0 END) OVER()total_cust_Agu,	SUM(CASE WHEN September > 0 THEN 1 ELSE 0 END) OVER()total_cust_Sep,	SUM(CASE WHEN October > 0 THEN 1 ELSE 0 END) OVER()total_cust_Oct,	SUM(CASE WHEN November > 0 THEN 1 ELSE 0 END) OVER()total_cust_Nov,	SUM(CASE WHEN December > 0 THEN 1 ELSE 0 END) OVER()total_cust_Decfrom customer_every_month;--2nd Aproach: /* 
If any of the customers in the 1st month of 2011 came back every month in 2011,the sum of their different order dates on a monthly basis must be at least 12. */select Cust_id, count(distinct month(order_date))from combined_tablewhere Cust_id in (			select distinct Cust_id			from combined_table			where year(Order_Date) =2011 and datename(month, Order_Date)='January'			)group by Cust_idhaving count(distinct month(order_date)) >=12;  -- 0 customer came back every month--------------------------------/* 6. Write a query to return for each user the time elapsed between the first 
purchasing and the third purchasing, in ascending order by Customer ID.*/-- finding the customers having at least 3 distinct orders,select Cust_id, count(distinct Ord_id) -- Ord_idfrom combined_tablegroup by Cust_idhaving count(distinct Ord_id) >=3 --920order by Cust_id;-- finding the time elapsed between the first purchasing and third purchasing with lead window functionwith custom_wth_3_orders as (	select distinct Cust_id, Ord_id, order_date	from combined_table	where Cust_id in (		select Cust_id		from combined_table		group by Cust_id		having count(distinct Ord_id) >= 3)), diff_order_date as (	select *,			DATEDIFF(DAY, order_date, LEAD(order_date, 2) OVER(PARTITION BY Cust_id ORDER BY order_date)) time_elapsed	from custom_wth_3_orders)select distinct Cust_id,	FIRST_VALUE (time_elapsed) OVER (PARTITION BY Cust_id ORDER BY order_date) time_elapsedfrom diff_order_dateorder by 1;--------------------------/* 7. Write a query that returns customers who purchased both product 11 and 
product 14, as well as the ratio of these products to the total number of 
products purchased by the customer. */--ratio of total guantity for product 11 and product 14 to the total quantity of all products purchased by the same customerswith tbl as(	select Cust_id, Prod_id, Order_Quantity,		sum(Order_Quantity) over (partition by Cust_id) total_product	from combined_table	where Cust_id in(		select Cust_id		from combined_table		where Prod_id = 11		INTERSECT		select Cust_id		from combined_table		where Prod_id = 14))select distinct Cust_id,	cast(1.0 * sum(Order_Quantity) over (partition by Cust_id) / total_product as decimal(3,2)) product_ratiofrom tblwhere Prod_id in (11,14);-- finding the ratio for product 11 and product 14 separatelywith tbl as(	select Cust_id, Prod_id, Order_Quantity,		sum(Order_Quantity) over (partition by Cust_id) total_product	from combined_table	where Cust_id in(		select Cust_id		from combined_table		where Prod_id = 11		INTERSECT		select Cust_id		from combined_table		where Prod_id = 14))select distinct Cust_id, Prod_id,	cast(1.0 * sum(Order_Quantity) over (partition by Cust_id) / total_product as decimal(3,2)) product_ratio,	cast(1.0 * sum(Order_Quantity) over (partition by Cust_id, Prod_id)/ total_product as decimal(3,2)) each_product_ratiofrom tblwhere Prod_id in (11,14);--------------------/* Customer Segmentation */

/* Categorize customers based on their frequency of visits. The following steps 
will guide you. If you want, you can track your own way *//* 1. Create a “view” that keeps visit logs of customers on a monthly basis.
(For each log, three field is kept: Cust_id, Year, Month) */alter view visit_log asselect distinct Cust_id, Year(Order_Date)Year_, Month(Order_Date)Month_, Ord_idfrom combined_table;------------------/* 2. Create a “view” that keeps the number of monthly visits by users. (Show 
separately all months from the beginning business) */

create view monthly_visits asselect distinct Cust_id, Year_, Month_, 	count(*) over (partition by  Cust_id, Year_, Month_)monthly_visit_numfrom visit_log;


-- checking the number of monthly visits by customer in each year with pivot table
select *
from (
	select distinct Cust_id, Year_, Month_,		count(*) over (partition by  Cust_id, Year_, Month_)monthly_visit_num	from visit_log
) A
pivot (
	sum (monthly_visit_num)
	for Month_ in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) as pivot_table;

------------------
/* 3. For each visit of customers, create the next month of the visit as a separate 
column. */

select Cust_id, Year_, Month_,
	lead(Year_) over(partition by Cust_id order by Year_, Month_) next_year,
	lead(Month_) over(partition by Cust_id order by Year_, Month_) next_month
from visit_log

-------------------
/* 4. Calculate the monthly time gap between two consecutive visits by each 
customer. */

--Serdar Hoca'dan
select cust_id, year(order_date)years, month(order_date)months, ord_id, order_date 
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))time_gap
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
), tbl2 as (select *,	avg(monthly_time_gap) over(partition by cust_id) avg_time_gap_per_cust,	avg(monthly_time_gap) over() avg_time_gap,	count(ord_id) over(partition by cust_id) total_order_per_cust	from tbl), tbl3 as (select *from tbl2), tbl4 as (select *,	avg(total_order_per_cust) over() avg_order_count,	ntile(4) over(order by avg_time_gap_per_cust) ntile_for_avg_time_gapfrom tbl3)select *from tbl4where ntile_for_avg_time_gap=1/*Yukarýda;- müþteri bazýnda ortalama sipariþ zaman aralýðý (avg_time_gap_per_cust),- tüm veri için ortalama sipariþ zaman aralýðý (avg_time_gap),- müþteri bazýnda toplam sipariþ sayýsý (total_order_per_cust),- tüm veri için ortalama sipariþ sayýsý (avg_order_count) ve-- avg_time_gap_per_cust deðerlerine göre ntile (ntile_for_avg_time_gap) deðerlerihesaplanmýþ ve tüm bu veriler deðerlendirilerek müþterilerin categorilere ayýrýlmasý içinaþaðýdaki modelin kullanýlmasýna karar verilmiþtir.1. Sadece tek alýþveriþ yapmýþ olanlar (total_order_per_cust=1 olanlar) 'CHURN',2. avg_time_gap_per_cust <= 4 ve total_order_per_cust > avg_time_gap_per_cust olanlar 'MOST VISITING'3. avg_time_gap_per_cust = 6 ve total_order_per_cust > avg_time_gap_per_cust ile	avg_time_gap_per_cust > 6 olanlar 'LESS VISITING'4. diðerleri ise 'MODERATE VISITING'olarak aþaðýda etiketlenmiþtir.*/with tbl as (select cust_id, year(order_date)years, month(order_date)months, ord_id, order_date 
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))monthly_time_gap 
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
), tbl2 as (select *,	avg(monthly_time_gap) over(partition by cust_id) avg_time_gap_per_cust,	count(ord_id) over(partition by cust_id) total_order_per_cust	from tbl)select cust_id,	case		when total_order_per_cust=1 then 'CHURN'		when avg_time_gap_per_cust <= 4 and total_order_per_cust > avg_time_gap_per_cust then 'MOST VISITING'		when (avg_time_gap_per_cust = 6 and total_order_per_cust > avg_time_gap_per_cust) and (avg_time_gap_per_cust > 6) then 'LESS VISITING'		else 'MODERATE VISITING'	end as cust_visit_catgfrom tbl2;/* Month-Wise Retention Rate */

 /* Find month-by-month customer retention rate since the start of the business. */
/*There are many different variations in the calculation of Retention Rate. But we will 
try to calculate the month-wise retention rate in this project.
So, we will be interested in how many of the customers in the previous month could 
be retained in the next month.
Proceed step by step by creating “views”. You can use the view you got at the end of 
the Customer Segmentation section as a source.

1. Find the number of customers retained month-wise. (You can use time gaps)
2. Calculate the month-wise retention rate. */create view time_gap asselect cust_id, year(order_date)years, month(order_date)months, ord_id, order_date 
		,datediff(month,order_date,lead(order_date)over(partition by cust_id order by order_date ))date_diff
from [dbo].[combined_table]
group by cust_id, year(order_date), month(order_date), ord_id, order_date 
;select cust_idfrom time_gapwhere years=2009 and months=1 --144INTERSECTselect cust_idfrom time_gapwhere years=2009 and months=2 --104  11/144select cust_idfrom time_gapwhere years=2009 and months=2 --104INTERSECTselect cust_idfrom time_gapwhere years=2009 and months=3  --131  13/104select cust_idfrom time_gapwhere years=2009 and months=3 --131INTERSECTselect cust_idfrom time_gapwhere years=2009 and months=4  --123  13/131--Oran hesaplamawith tbl as(	select distinct cust_id  -- iki ay üstüste gelen müþteri id lerini bulmak için	from time_gap	where years=2009 and months=1 --144	INTERSECT	select distinct cust_id	from time_gap	where years=2009 and months=2)select (1.0 * count(cust_id)/(select count(distinct cust_id) from time_gap where years=2009 and months=1))from tbl-- aylýk müþteri sayýsýselect count(distinct cust_id)from time_gapwhere years=2009 and months=1-- while loop ile döngü içine almaDROP TABLE IF EXISTS RETENTION_RATECREATE TABLE RETENTION_RATE (							YEAR INT,							MONTH INT,							cust_retention_rate DECIMAL(10,2));DECLARE
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
			begin				with tbl as(					select distinct cust_id  -- iki ay üstüste gelen müþteri id lerini bulmak için					from time_gap					where years=@year_min and months=@month_min					INTERSECT					select distinct cust_id					from time_gap					where years=@year_min and months=@month_min+1					)								select @retention_rate = (1.0 * count(cust_id)/(select count(distinct cust_id) from time_gap where years=@year_min and months=@month_min))				from tbl
				insert into RETENTION_RATE values(@year_min, @month_min, @retention_rate)
				-- print @year_min
				-- print @month_min
				-- print @retention_rate
				set @month_min += 1
			end
		--print @retention_rate
		set @year_min += 1
		select @month_min = min(months) from time_gap
		
	end;select *
from RETENTION_RATE

--Serdar Hoca'dan gelen DENSE RANK lý kod:

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


-------fonksiyon bitti ve tabloyu yazdýrdýk
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


-- min year deðerini bulmak için
DECLARE
	@year intselect @year = min(years) from time_gapprint @year-- min ve max yýl ve ay deðerlerini yazdýrmak içinDECLARE
	@year_min int,
	@year_max int,
	@month_min int,
	@month_max intselect @year_min = min(years) from time_gap
select @year_max = max(years) from time_gap
select @month_min = min(months) from time_gap
select @month_max = max(months) from time_gapprint @year_minprint @year_maxprint @month_minprint @month_maxwith tbl as(	select distinct cust_id  -- iki ay üstüste gelen müþteri id lerini bulmak için	from time_gap	where years=2009 and months=1 --144	INTERSECT	select distinct cust_id	from time_gap	where years=2009 and months=2)select (1.0 * count(cust_id)/(select count(distinct cust_id) from time_gap where years=2009 and months=1))from tblCREATE FUNCTION CUST_PER_YEAR_MONTH(@year int@month int)RETURNS /*20091. ay 532. ay 35 --15--15/353. ay 42 --20--20/42...20101. ay 532. ay 35 --15--15/353. ay 42 --20--20/42...*//* 1. Find the number of customers retained month-wise. (You can use time gaps) */

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