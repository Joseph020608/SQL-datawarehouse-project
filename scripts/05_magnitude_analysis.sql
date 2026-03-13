-- Total customers per country

SELECT
	country,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Total customers per gender

SELECT
	gender,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Total products per category

SELECT
	category,
	COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Average costs in each category

SELECT
	category,
	AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Total revenue per category

SELECT
	dp.category,
	SUM(fs.sales_amount) AS total_revenue
FROM gold.dim_products AS dp
LEFT JOIN gold.fact_sales AS fs
ON dp.product_key = fs.product_key
GROUP BY category
ORDER BY total_revenue DESC;

-- Total revenue per customer

SELECT
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	SUM(fs.sales_amount) AS total_revenue
FROM  gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_revenue DESC;

-- Distribution of sold items across countries

SELECT
	dc.country,
	SUM(fs.quantity) AS items_sold
FROM gold.fact_sales AS fs 
LEFT JOIN gold.dim_customers AS dc
ON dc.customer_key = fs.customer_key
GROUP BY dc.country
ORDER BY items_sold DESC;
