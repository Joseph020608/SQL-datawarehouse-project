/*
---------------------------------------------------------------------
Product Report
---------------------------------------------------------------------

Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:

1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
    - total orders
    - total sales
    - total quantity sold
    - total customers (unique)
    - lifespan (in months)
4. Calculates valuable KPIs:
    - recency (months since last sale)
    - average order revenue (AOR)
    - average monthly revenue
---------------------------------------------------------------------
*/

CREATE VIEW gold.report_products AS 
WITH base_query AS (
	SELECT
		fs.order_number,
		fs.customer_key,
		dp.product_key,
		dp.product_name,
		dp.category,
		dp.subcategory,
		dp.cost,
		fs.quantity,
		fs.sales_amount,
		fs.order_date
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_products AS dp
	ON fs.product_key = dp.product_key
	WHERE order_date IS NOT NULL
), 

product_agg AS (
SELECT
	product_name,
	product_key,
	category,
	subcategory,
	cost,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	MAX(order_date) AS last_sale,
	COUNT(DISTINCT customer_key) AS unique_customers,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 2) AS avg_selling_price
FROM base_query
GROUP BY product_name, product_key, category, subcategory, cost
)

SELECT
	product_name,
	product_key,
	category,
	subcategory,
	cost,
	CASE
		WHEN total_sales < 10000 THEN 'Low performer'
		WHEN total_sales > 10000 AND total_sales < 50000 THEN 'Mid performer'
		WHEN total_sales > 50000 THEN 'High performer'
	END AS product_segment,
	total_orders,
	total_sales,
	total_quantity,
	last_sale,
	unique_customers,
	lifespan,
	avg_selling_price,
	DATEDIFF(month, last_sale, GETDATE()) AS recency,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders 
	END AS avg_order_revenue,
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan 
	END AS avg_monthly_revenue
FROM product_agg;

SELECT
	*
FROM gold.report_products
