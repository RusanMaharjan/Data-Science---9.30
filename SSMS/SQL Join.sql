/*
	- SQL Joins
	a. Inner Join
	b. Left Join
	c. Right Join
	d. Outer Join
	e. Cross Join
	f. Self Join
	g. Natural Join

	Syntax
	----------------------------------------
	Select
		col1, col2, col3, col4, col5
	from table1
	join talbe2
	on table1.pk = table2.fk;
*/


select
	sc.customer_id, CONCAT(sc.first_name, ' ', sc.last_name) as customer_name, sc.email, sc.street, sc.city, sc.city,
	sc.zip_code,
	so.order_status, so.order_date,
	case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		when order_status = 4 then 'Completed'
	End as order_label
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id;

-- Find total amount spent by each customers.
select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
	SUM((soi.list_price * soi.quantity) * (1 - soi.discount)) as total_spent
from sales.customers sc
	join sales.orders so
	on sc.customer_id = so.customer_id
	join sales.order_items soi
	on so.order_id = soi.order_id
group by CONCAT(sc.first_name, ' ', sc.last_name)
having SUM((soi.list_price * soi.quantity) * (1 - soi.discount)) > 6000
order by total_spent desc;


select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
	COUNT(distinct so.order_id) as total_orders,
	COUNT(distinct soi.item_id) as total_items
from sales.customers sc
	join sales.orders so
	on sc.customer_id = so.customer_id
	join sales.order_items soi
	on so.order_id = soi.order_id
group by CONCAT(sc.first_name, ' ', sc.last_name);


select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
	so.order_id, soi.item_id
from sales.customers sc
	join sales.orders so
	on sc.customer_id = so.customer_id
	join sales.order_items soi
	on so.order_id = soi.order_id
where CONCAT(sc.first_name, ' ', sc.last_name) = 'Adelaida Hancock';

-- Self Join
-- Find staff detail and manager details.
select
	CONCAT(s1.first_name, ' ', s1.last_name) as Manager_Name,
	CONCAT(s2.first_name, ' ', s2.last_name) as Staff_Name,
	s1.email as Mgr_Email, s2.email as st_email
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Find total staffs and customers handled by each Manager.
select
	CONCAT(s1.first_name, ' ', s1.last_name) as manager_name,
	COUNT(distinct so.order_id) as total_orders,
	COUNT(distinct s2.staff_id) as total_staffs,
	COUNT(distinct sc.customer_id) as total_customers
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id
join sales.orders so
on s1.staff_id = so.staff_id
join sales.customers sc
on so.customer_id = sc.customer_id
group by CONCAT(s1.first_name, ' ', s1.last_name);


-- Cross Join
select * from sales.customers; -- 1445
select * from sales.orders; -- 1615

-- 2333675
select
	*
from sales.customers sc
cross join sales.orders so
where so.customer_id = 2
	and sc.customer_id = 2;


-- Left Join
-- Provides all data from left table and common data from right table. Remaining unmatched data from right table shows null.
select
	*
from sales.staffs s1
left join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Right Join
-- Provides all data from right table and common data from left table. Remaining unmatched data from left table shows null.
select
	*
from sales.staffs s1
right join sales.staffs s2
on s1.staff_id = s2.manager_id;


-- Outer Join
-- Combination of all 3 joins
select
	*
from sales.staffs s1
full outer join sales.staffs s2
on s1.staff_id = s2.manager_id;


-- Natural Join
select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name, so.order_status, so.order_date,
	soi.list_price
from sales.customers sc, sales.orders so, sales.order_items soi
where sc.customer_id = so.customer_id
	and so.order_id = soi.order_id;





















