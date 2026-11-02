/*
	SubQuery
	----------
	Nested Query / Logical Query

	Types of SubQuery
	------------------
	1. Single Row SubQuery
		- If inner query provides output of single row and single column data.
		- Comparison Operator

	2. Multi Row SubQuery
		- If inner query provides output of mutiple row and single column data.
		- In (Categorical Data / Discrete), (Any, All (Continuous Data + Comparison Operator))

	3. Correlated SubQuery
		- Can be Multi Row SubQuery
		- If inner query provides output of multiple row and multiple columns data.
		- Exists (Does the data we have filtered exists in another table?)
				- If Yes -> Show filtered Value
				- If No -> Show all values

	Syntax
	--------
	select * from table_name where col_name = ( -- Outer Query
		select col_name from table_name -- Inner Query
	);
*/


-- Find all proudcts data whose price is less than its average price.
select
	AVG(list_price)
from production.products;

select * from production.products where list_price < 1520.591401
order by list_price asc;


select * from production.products where list_price < (
	select AVG(list_price) from production.products
);

-- Find second highest list price from product details.
select * from production.products where list_price = (
	select max(list_price) from production.products where list_price < ( -- 7499.99
		select max(list_price) from production.products -- 11999.99
	)
);

-- Find order details of third day order which customers has given.

select * from sales.orders where order_Date = (
	select min(order_date) from sales.orders where order_date > (
		select min(order_date) from sales.orders where order_date > (
			select min(order_date) from sales.orders
		)
	)
);

-- Find order details of third day order which customers has given. Find customer details of those dates using subquery.
select * from sales.customers where customer_id in (
	select customer_id from sales.orders where order_Date = (
		select min(order_date) from sales.orders where order_date > (
			select min(order_date) from sales.orders where order_date > (
				select min(order_date) from sales.orders
			)
		)
	)
);

-- Find order details of third day order which customers has given. Find customer details of those dates using Join.
select sc.customer_id, first_name, last_name, phone, email, street, city, state, zip_code from (
	select * from sales.orders where order_Date = (
		select min(order_date) from sales.orders where order_date > (
			select min(order_date) from sales.orders where order_date > (
				select min(order_date) from sales.orders
			)
		)
	)
) as data
join sales.customers sc
on sc.customer_id = data.customer_id;

-- Find all product details whose list price is less than 209.00 or 249.99.

select * from production.products where list_price < any ( -- or
	select list_price from production.products where list_price in (209.99, 249.99)
);

-- Find all product details whose list price is less than 209.00 and 249.99.

select * from production.products where list_price < all ( -- and
	select list_price from production.products where list_price in (209.99, 249.99)
);

 -- Find all customer details who have bought products whose list price is less than 209.00 or 249.99 using subquery.
select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name, sc.email, sc.street, sc.city, sc.state, sc.zip_code,
	pp.product_name
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
join production.products pp
on soi.product_id = pp.product_id
where (pp.list_price < 209.99 or pp.list_price < 249.99);


select CONCAT(first_name, ' ', last_name) as customer_name, email, street, city, state, zip_code
from sales.customers where customer_id in (
	select customer_id from sales.orders where order_id in (
		select order_id from sales.order_items where product_id in (
			select product_id from production.products where list_price < any (
				select list_price from production.products where list_price in (209.99, 249.99)
			)
		)
	)
);


/*
	CTE (Common Table Expressions)
	----------------------------------
	- Temporary Data Tables

	with cte_name as (
		query...
	)
	select * from cte_name;
*/

with customer_product as (
	select
		customer_id, ((soi.list_price * soi.quantity) * (1 - soi.discount)) as total_price,
		pp.product_id, pp.product_name, pp.model_year, pp.list_price
	from sales.orders so
	join sales.order_items soi
	on so.order_id = soi.order_id
	join production.products pp
	on soi.product_id = pp.product_id
	where pp.list_price < any (
		select list_price from production.products where list_price in (209.99, 249.99)
	)
),
customer_price as (
	select 
		CONCAT(first_name, ' ', last_name) as customer_name, product_id, total_price
	from customer_product cp
	join sales.customers sc
	on cp.customer_id = sc.customer_id
)
select
	customer_name, COUNT(product_id) as total_products, SUM(total_price) as total_spent 
from customer_price
group by customer_name
order by total_spent desc
offset 5 rows fetch next 5 rows only;



