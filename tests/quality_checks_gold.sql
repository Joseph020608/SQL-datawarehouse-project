/*
--------------------------------------------------
Quality checks
--------------------------------------------------
Script purpose:
  - This script perform some quality checks that were made at the moment
    of the views creation
*/

SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE
		WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr -- CRM go first for gender info
		ELSE COALESCE(ca.gen, 'Unknown')
	END AS new_gen
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid
ORDER BY 1,2;

SELECT DISTINCT gender FROM gold.dim_customers;

SELECT * FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE f.product_key IS NULL
