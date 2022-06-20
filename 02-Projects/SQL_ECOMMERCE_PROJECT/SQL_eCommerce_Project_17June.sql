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

-- Creating select combined_table

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