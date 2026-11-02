
select 
	customer_id, first_name, last_name, phone, email, street, city, state, zip_code
from sales.customers
where first_name = 'Debra';

-- Concat Function / Concatenation Operator (+)
select
	CONCAT('Name of Customer: ',first_name, ' ', last_name) as customer_name,
	('Name of Customer: ' + first_name + ' ' + last_name) as full_name
from sales.customers;


-- Sub-String / Left / Right
select * from sales.customers;

-- Substring(col_name, start_length, number_of_values)
select
	first_name, 
	SUBSTRING(first_name, 2, 3) as extracted_name,
	SUBSTRING(first_name, 1, 3) as first_3,
	LEFT(first_name, 3) as left_3,
	RIGHT(first_name, 3) as right_3
from sales.customers;


-- customer_id-first_name(2, 4)-last_name(last_3)-email(5, 4)-street(2, 6)-city(2, 3)-state-zip_code(3, 2)
-- 1-ebra-rks-a.bu-273 Th-rch-NY-12
select
	CONCAT(
		customer_id, '-', SUBSTRING(first_name, 2, 4), '-', RIGHT(last_name, 3), '-',
		SUBSTRING(email, 5, 4), '-', SUBSTRING(street, 2, 6), '-', SUBSTRING(city, 2, 3),
		'-', State, '-', SUBSTRING(zip_code, 3, 2)
	) as data
from sales.customers;


-- Date Functions
select
	order_date,
	Year(order_date) as o_year,
	MONTH(order_date) as o_month,
	DAY(order_date) as o_day,
	
	-- Date Part -> Return Int
	DATEPART(QUARTER, order_date) as o_quarter,
	DATEPART(week, order_date) as o_weeks,
	DATEPART(WEEKDAY, order_date) as o_weekday,

	-- Date Name -> Return String
	DATENAME(MONTH, order_date) as month_name,
	DATENAME(WEEKDAY, order_date) as day_name,

	-- Format
	FORMAT(order_date, 'MMMM') as order_month,
	FORMAT(order_date, 'dddd') as order_day
from sales.orders;

select
	order_date, required_date, shipped_date,
	DATEDIFF(DAY, order_date, shipped_date) as date_diff,
	DATEADD(DAY, 3, required_date) as added_date
from sales.orders;


-- 1. Find all order details whose orders are not shipped/delivered.
-- 2. List all orders placed in 2016 that were processed by staffs 2, 3, 6.
-- 3. Identify any delayed orders where the shipped date was recorded after the required date. 
--		Display the order id , required date, shipped date and the number of days delayed.
-- 4. List all product details whose name contains word 'Trek' and its model year is 2017.



-- SQL CASE
-- 1 -> Pending, 2 -> Processing, 3 -> Rejected, 4 -> Completed
select
	order_id, order_date, required_date, shipped_date, order_status,
	Case
		when order_status = 1 then 'Pending'
		when order_status = 2 then 'Processing'
		when order_status = 3 then 'Rejected'
		Else 'Completed'
		--when order_status = 4 then 'Completed'
	End as status_label
from sales.orders;

/*
	SQL Relational Algebra
	-----
	SQL Execution Flow
	---------------------
	1. From
	2. Join
	3. Where
	4. Group by 
	5. Having
	6. Select
	7. Order By
	8. Limit / Top / Offset Fetch
*/

/*
	Calculate total price of each orders.
	total price between 0 to 4000 -> Low Spent
	total price between 4001 to 8000 -> Average Spent
	total price more than 8000 -> High Spent

	Display order_id, item_id, product_id, quantity, list_price, discount, total_price, price_label
*/


select
	order_id, item_id, product_id, quantity, list_price, discount, 
	((quantity * list_price) * (1 - discount)) as total_price,
	case
		when ((quantity * list_price) * (1 - discount)) <= 4000 then 'Low Spent'
		when ((quantity * list_price) * (1 - discount)) > 4000 and
			((quantity * list_price) * (1 - discount)) <= 8000 then 'Average Spent'
		when ((quantity * list_price) * (1 - discount)) > 8000 then 'High Spent'
	end as price_label
from sales.order_items;





























