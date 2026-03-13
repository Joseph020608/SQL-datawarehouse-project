-- 5 products with highest revenue

SELECT
	TOP 5
	dp.product_key,
	dp.product_name,
	SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON dp.product_key = fs.product_key
GROUP BY dp.product_key,dp.product_name
ORDER BY total_revenue DESC;

SELECT * 
FROM(
	SELECT
		dp.product_key,
		dp.product_name,
		SUM(fs.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount) DESC) AS rank_prod
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_products AS dp
	ON dp.product_key = fs.product_key
	GROUP BY dp.product_key,dp.product_name) t
WHERE rank_prod <= 5


-- 5 sub-categories with highest revenue

SELECT
	TOP 5
	dp.subcategory,
	SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON dp.product_key = fs.product_key
GROUP BY dp.subcategory
ORDER BY total_revenue DESC;




-- 5 worst performing products in terms of sales

SELECT
	TOP 5
	dp.product_key,
	dp.product_name,
	SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON dp.product_key = fs.product_key
GROUP BY dp.product_key,dp.product_name
ORDER BY total_revenue ASC;

-- 5 sub-categories worst performing in terms of sales

SELECT
	TOP 5
	dp.subcategory,
	SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_products AS dp
ON dp.product_key = fs.product_key
GROUP BY dp.subcategory
ORDER BY total_revenue DESC;

-- TOP 10 customers with highest revenue

SELECT
	TOP 10
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	SUM(fs.sales_amount) AS total_revenue
FROM  gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_revenue DESC;


SELECT *
FROM(
	SELECT
		dc.customer_key,
		dc.first_name,
		dc.last_name,
		SUM(fs.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount) DESC) AS top_cust
	FROM  gold.fact_sales AS fs
	LEFT JOIN gold.dim_customers AS dc
	ON dc.customer_key = fs.customer_key
	GROUP BY dc.customer_key, dc.first_name, dc.last_name) t
WHERE top_cust <= 10

-- 3 customers with fewers orders placed

SELECT
	TOP 3
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	COUNT(DISTINCT fs.order_number) AS total_orders
FROM  gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_orders;


SELECT *
FROM(
SELECT
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	COUNT(DISTINCT fs.order_number) AS total_orders,
	ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT fs.order_number)) AS rank_cust
FROM  gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name) t
WHERE rank_cust <=3;
