/*
	Aggregate Functions
	------------------
	- Sum, Avg, Count, Min, Max

	Rules of Group by
	------------------
	1. If any non-aggregate columns are defined with aggregate column then non-aggregate columns must be defined
		in group by clause.

	2. We can define any column name in group by clause if it exists in selected table.

	Rules of Having
	----------------
	1. To use having clause query must have a group by clause.
	2. Having is used to filter aggregate column data.
	3. Having also filter column which are defined in group by clause.
*/


-- Find total customers from each state.
select
	state, city, count(customer_id) as total_customers
from sales.customers
where state = 'CA' and Customer_Id = 110
group by state, city
order by total_customers desc;


select
	count(order_id) as total_orders,
	case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Completed'
	End as order_label
from sales.orders
group by case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Completed'
	End;

-- Sum Case
select
	SUM(case when order_status = 1 then 1 else 0 end) as Pending,
	SUM(case when order_status = 2 then 1 else 0 end) as Processing,
	SUM(case when order_status = 3 then 1 else 0 end) as Rejected,
	SUM(case when order_status = 4 then 1 else 0 end) as Completed
from sales.orders;

-- Count Case
select
	COUNT(case when order_status = 1 then 1 end) as Pending,
	COUNT(case when order_status = 2 then 1 end) as Processing,
	COUNT(case when order_status = 3 then 1 end) as Rejected,
	COUNT(case when order_status = 4 then 1 end) as Completed
from sales.orders;
