-- Youngest and oldest customer

SELECT 
	DATEDIFF(YEAR, MIN(birth_date), GETDATE()) AS oldest_customer,
	DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS youngest_customer
FROM gold.dim_customers;

-- Find total sales

SELECT 
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find number of sold items

SELECT
	SUM(quantity) AS total_sold_items
FROM gold.fact_sales;

-- Find average selling price

SELECT
	AVG(price) AS avg_price
FROM gold.fact_sales;

-- Find total number of orders

SELECT
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- Find total number of products

SELECT 
	COUNT(DISTINCT product_key) AS total_number_products
FROM gold.dim_products;

-- Find total number of customers

SELECT
	COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers;

-- Find total  number of customers that has placed an order

SELECT
	COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales 

-- General overview of the measures

SELECT 'Total sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total quantity' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Avg price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total # orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total # products' AS measure_name, COUNT(DISTINCT product_key )AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total # customers' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.dim_customers
