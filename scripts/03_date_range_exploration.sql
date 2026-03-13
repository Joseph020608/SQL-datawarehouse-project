-- Min and Max date from orders
-- How many years of sales are available

SELECT 
	MIN(order_date) AS min_date,
	MAX(order_date) AS max_date,
	DATEDIFF(YEAR, MIN(order_date),MAX(order_date)) AS years_of_sales
FROM gold.fact_sales;
