-- Segment products in cost ranges and count how many products fall into each segment

WITH product_segments AS 
(SELECT
	product_key,
	product_name,
	cost,
	CASE
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END AS cost_range
FROM gold.dim_products
)

SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC


/* Group customers into three segments based on spending behavior, VIP, Regular, New 
VIP: 12 months history, +5000 spend
Regular: 12 months history, -5000 spend
New: -12 months*/

WITH customer_cycle AS (
SELECT
	dc.customer_key,
	SUM(fs.sales_amount) AS total_spend,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.dim_customers AS dc
LEFT JOIN gold.fact_sales AS fs
ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key
),

segments AS
(SELECT
	CASE
		WHEN lifespan >= 12 AND total_spend > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spend <= 5000 THEN 'Regular'
		WHEN lifespan < 12 THEN 'New'
		ELSE 'Unknown'
	END AS customer_segment,
	customer_key
FROM customer_cycle
)

SELECT
	customer_segment,
	COUNT(customer_key) AS num_customers
FROM segments
GROUP BY customer_segment
