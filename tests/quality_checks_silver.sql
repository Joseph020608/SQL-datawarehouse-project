/*
-----------------------------------------------------
Quality checks
-----------------------------------------------------
Script purpose:
  This script performs different quality checks for data consistency, accuracy
  and standardization across the silver schema, includes checks for:
  - Nulls or duplicates in PKs
  - Unwanted spaces in string fields.
  - Data standardization and consistency
  - Invalid date ranges and orders
  - Unconsistency between related fields

*/

-- silver.crm_cust_info table 

SELECT cst_id,
	COUNT(*)
FROM silver.crm_cust_info 
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);


SELECT
cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT
cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT
cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

SELECT
	DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT
	DISTINCT cst_gndr
FROM silver.crm_cust_info

-- silver.crm_prd_info

SELECT prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

SELECT
prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- silver.crm_sales_details

SELECT
NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 OR sls_due_dt > 20500101 OR sls_due_dt < 19000101;

SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_date > sls_ship_dt OR sls_order_date > sls_due_dt;

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0

SELECT 
DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE()

SELECT 
DISTINCT gen
FROM silver.erp_cust_az12


SELECT 
DISTINCT cntry AS old_country,
CASE
	WHEN TRIM(cntry) IN ('DE') THEN 'Germany'
	WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unkown'
	ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;

-- silver.erp_px_cat_g1v2 table

SELECT
subcat
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);


SELECT
DISTINCT subcat
FROM bronze.erp_px_cat_g1v2
