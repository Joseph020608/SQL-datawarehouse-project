-- Categories that contribute the most to overall sales

WITH category_sales AS (
	SELECT
		dp.category,
		SUM(fs.sales_amount) AS sales_category
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_products AS dp
	ON fs.product_key = dp.product_key
	GROUP BY category
)

SELECT
	category,
	sales_category,
	SUM(sales_category) OVER () AS global_sales,
	ROUND((CAST(sales_category AS FLOAT)/SUM(sales_category) OVER ())*100, 2) AS category_rate
FROM category_sales AS cs
ORDER BY category_rate DESC;
