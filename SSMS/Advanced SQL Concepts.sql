/*
	- View
	- Synonym
	- Indexing -> Used to make data filter optimized.
	- Basic Stored Procedure
*/

-- Indexing
Create index idx_category_name on production.categories(category_name);

-- View
Create or Alter View vw_customer_product as
	select
		pp.product_id, CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
		pp.product_name, ((soi.list_price * soi.quantity) * (1 - soi.discount)) as total_price
	from sales.customers sc
	join sales.orders so
	on sc.customer_id = so.customer_id
	join sales.order_items soi
	on so.order_id = soi.order_id
	join production.products pp
	on soi.product_id = pp.product_id;

select * from cp;

select 
	customer_name, COUNT(product_id) as total_products,
	sum(total_price) as total_spent
from cp
group by customer_name;

-- Synonym
create synonym cp for vw_customer_product;

-- Stored Procedure
Create or Alter Procedure usp_customer_product as
select
		pp.product_id, CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
		pp.product_name, ((soi.list_price * soi.quantity) * (1 - soi.discount)) as total_price
	from sales.customers sc
	join sales.orders so
	on sc.customer_id = so.customer_id
	join sales.order_items soi
	on so.order_id = soi.order_id
	join production.products pp
	on soi.product_id = pp.product_id;

exec usp_customer_product;

-- Filter data and Input Function
Create or Alter procedure usp_products (
	@list_price int = 9999999.99,
	@model_year int
) as
BEGIN
	select 
		product_id, product_name, brand_id, category_id, model_year, list_price
	from production.products
	where list_price <= @list_price
		and model_year = @model_year
END;

exec usp_products @list_price=200, @model_year = 2018;


-- IF Else and Output Function
Create or Alter Procedure usp_findCustomerbyEmail(
	@email varchar(60),
	@response_message varchar(100) output
) AS
BEGIN
	IF NOT Exists (select 1 from sales.customers where email = @email) -- Search Email
	BEGIN
		SET @response_message = CONCAT('Provided Email ', @email, ' doesnot exists in database.') -- Show Message if email does not exists
		RETURN -- Stop Query
	END

	select * from sales.customers where email = @email; -- Show data if email exists
	SET @response_message = CONCAT('Customer found with email ', @email, '.')
END;

Declare @output_message varchar(100)
Exec usp_findCustomerbyEmail @email='dbra.burks@yahoo.com', @response_message=@output_message output

select @output_message as output;


select @@SERVERNAME;