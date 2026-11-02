/*
	Window Functions
	-------------------
	1. Row Number
		- To give a uniquely identifing numbers to each row of data.
		- To Find and Remove duplicate data

	2. Rank
		- To rank data with similar values.
		- Skips Rank Number

	3. Dense Rank
		- To rank data with similar values.
		- Doesnot Skips Rank Number

	4. NTile
	5. Lead -> Next Value
	6. Lag -> Previous Value
	7. Running Sum
	8. Moving Average

	Syntax
	---------
	select
		col1, col2, col3, col4, win_fun() Over(partition by col_name order by col_name)
	from table_name;
*/


-- Row Number
select
	Transaction_ID, User_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used,
	Location, Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H,
	Payment_Method, Fraudulent,
	ROW_NUMBER() Over(partition by Transaction_Type order by Number_of_Transactions_Last_24H) as rn
from FDD.dbo.[Fraud Detection Dataset];

-- To Find Duplicate Data
select
	Transaction_ID, User_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used,
	Location, Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H,
	Payment_Method, Fraudulent,
	ROW_NUMBER() Over(partition by Transaction_ID order by Transaction_ID) as rn
from FDD.dbo.[Fraud Detection Dataset];

-- Remove Duplicate Data
with fraud_duplicate_data as (
	select
		Transaction_ID, User_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used,
		Location, Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H,
		Payment_Method, Fraudulent,
		ROW_NUMBER() Over(partition by Transaction_ID order by Transaction_ID) as rn
	from FDD.dbo.[Fraud Detection Dataset]
)
delete from fraud_duplicate_data where rn > 1;


-- Rank
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	Rank() Over(partition by model_year order by list_price) as product_rank
from production.products;

-- Dense_Rank
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	DENSE_RANK() Over(order by list_price) as product_dr
from production.products;

select * from (
	select
		product_id, product_name, brand_id, category_id, model_year, list_price,
		DENSE_RANK() Over(order by list_price desc) as product_dr
	from production.products
) as data
where product_dr = 4;

-- NTile
with price_segment as (
	select
		product_id, product_name, brand_id, category_id, model_year, list_price,
		NTILE(3) Over(order by list_price) as ntile_data
	from production.products
) 
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	case
		when ntile_data = 1 then 'Low Price'
		when ntile_data = 2 then 'Average Price'
		when ntile_data = 3 then 'High price'
	end as price_label
from price_segment;


-- Lead and Lag
select
	Transaction_ID, User_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used,
	Location, Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H,
	Payment_Method, Fraudulent,
	LEAD(Payment_Method) Over(partition by Device_used order by Transaction_Amount) as next_payment,
	LAG(Payment_Method) Over(partition by Device_used order by Transaction_Amount) as prev_payment
from FDD.dbo.[Fraud Detection Dataset]
where Device_Used is not null;

-- Running sum and Moving Average
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	SUM(list_price) Over(partition by model_year order by list_price) as running_sum,
	Avg(list_price) Over(partition by model_year order by list_price) as moving_avg
from production.products;







