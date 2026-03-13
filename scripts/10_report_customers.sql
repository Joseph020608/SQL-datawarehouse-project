/*
---------------------------------------------------------------------
Customer Report
---------------------------------------------------------------------

Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:

1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
    - total orders
    - total sales
    - total quantity purchased
    - total products
    - lifespan (in months)
4. Calculates valuable KPIs:
    - recency (months since last order)
    - average order value
    - average monthly spend
---------------------------------------------------------------------
*/

-- base query, retrieve core columns from tables
CREATE VIEW gold.report_customers AS
WITH base_query AS (
	SELECT
		fs.order_number,
		fs.product_key,
		fs.order_date,
		fs.sales_amount,
		fs.quantity,
		dc.customer_key,
		dc.customer_number,
		CONCAT(dc.first_name, ' ', dc.last_name) AS customer_name,
		DATEDIFF(year, dc.birth_date, GETDATE()) AS age
	FROM gold.fact_sales AS fs 
	LEFT JOIN gold.dim_customers AS dc
	ON fs.customer_key = dc.customer_key
	WHERE order_date IS NOT NULL
),

customer_agg AS (
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_spend,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY customer_key, customer_number, customer_name, age
)

SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50+'
	END AS age_group,
	CASE
		WHEN lifespan >= 12 AND total_spend > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spend <= 5000 THEN 'Regular'
		WHEN lifespan < 12 THEN 'New'
		ELSE 'Unknown'
	END AS customer_segment,
	last_order,
	DATEDIFF(month, last_order, GETDATE()) AS recency,
	total_orders,
	total_spend,
	total_quantity,
	total_products,
	lifespan,
	CASE
		WHEN total_spend = 0 THEN 0
		ELSE total_spend / total_orders 
	END AS avg_per_order,
	CASE
		WHEN lifespan = 0 THEN total_spend
		ELSE total_spend / lifespan
	END AS avg_monthly_spend
FROM customer_agg;

SELECT
	*
FROM gold.report_customers;
