-- Analyze sales performance over time

SELECT 
	FORMAT(order_date, 'yyyy-MM') AS year_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_units_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY year_month ASC;


--Years

SELECT 
	YEAR(order_date) AS year,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_units_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);


--Months

SELECT 
	MONTH(order_date) AS month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_units_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);


-- Total sales per month

SELECT
	year_month,
	total_sales,
	SUM(total_sales) OVER(ORDER BY year_month) AS running_total_sales,
	AVG(avg_price) OVER(ORDER BY year_month) AS moving_avg_price
FROM (
SELECT 
	DATETRUNC(month, order_date) AS year_month,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)) t;

-- Analyze yearly products performance vs AVG sales performance and VS previios year sales

WITH yearly_product_sales AS (
	SELECT
		YEAR(fs.order_date) AS order_year,
		dp.product_name,
		SUM(fs.sales_amount) AS total_sales
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_products AS dp
	ON fs.product_key = dp.product_key
	WHERE fs.order_date IS NOT NULL
	GROUP BY YEAR(fs.order_date), dp.product_name
)

SELECT
	order_year,
	product_name,
	total_sales,
	AVG(total_sales) OVER(PARTITION BY product_name) AS avg_sales,
	total_sales - AVG(total_sales) OVER(PARTITION BY product_name) AS diff_avg,
	CASE
		WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above avg'
		WHEN total_sales - AVG(total_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below avg'
		ELSE 'Avg'
	END AS avg_change,
	LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS previous_year_sales,
	total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS diff_prev_year,
	CASE
		WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) > 0 THEN 'Increase'
		WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) < 0 THEN 'Decrease'
		ELSE 'No change'
	END AS prev_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year;
