# Data dictionary

The purpose of this file is to provide the user a clear guide of each table in the gold layer for a better understanding of this layer.

## Overview

The gold layer is the business level data representation, to support analysis and reporting processes, consists of dimension tables and fact tables for different business purposes.

## gold.dim_customers 

This view contains information of the customer enriched with demographic and geographic data

| column name | data type | description |
|-------------|-----------|-------------|
|customer_key|INT|Surrogate key used to identify each customer record within the dimension table|
|customer_id|INT|Unique numerical identifier assigned to each customer|
|customer_number|NVARCHAR(50)|Alphanumeric identifier used to identify each customer, used for tracking and referencing|
|first_name|NVARCHAR(50)|Name of the customer|
|last_name|NVARCHAR(50)|Last name of the customer|
|marital_status|NVARCHAR(50)|Marital status of the customer (e.g married, single)|
|country|NVARCHAR(50)|Country of residence of the customer as it is in the records (e.g Canada)|
|gender|NVARCHAR(50)|Gender of the customer (e.g male, female)|
|birth_date|DATE|Birth date of the customer|
|create_date|DATE| Creation date of the record|

## gold.dim_products

This view contains information of the different products and their attributes

| column name | data type | description |
|-------------|-----------|-------------|
|product_key|INT|Surrogate key used to identify each product record within the dimension table|
|product_id|INT|Unical numerical identifier assigned to each product|
|product_number|NVARCHAR(50)|Structured alphanumeric code used to identify each product, used categorization and inventory|
|product_name|NVARCHAR(50)|Name of the product, including key details such as color, size and type|
|category_id|NVARCHAR(50)|Unique identifier for the product´s category|
|category|NVARCHAR(50)|The clasiffication of the product (e.g. component, clothing) to group related items|
|subcategory|NVARCHAR(50)|more detailed classification of the product within the category (e.g socks, mountain bikes)|
|maintenance|NVARCHAR(50)|Indicates whether the product requires maintenance (Yes, No)|
|cost|INT|The cost or base price of the product.|
|product_line|NVARCHAR(50)| Specific line of products to which the product belongs (e.g Touring, Road)|
|start_date|DATE|The date when the product became available for sale|

## gold.fact_sales

This view contains information of the transactional sales data.

| column name | data type | description |
|-------------|-----------|-------------|
|order_number|NVARCHAR(50)|Unique alphanumeric identifier for each sales order (e.g 'SO43702')|
|product_key|INT|Surrogate key that links the order to the products dimension|
|customer_key|INT|Surrogate key that links the order to the customer dimension|
|order_date|DATE|Date when the order was made|
|shipping_date|DATE|Date when the order was shipped to the customer|
|due_date|DATE|Date when the order payment was due|
|sales_amount|INT|Total value of the sale for the line item|
|quantity|INT|Number of units of the product ordered in the line item|
|price|INT|Price per unit of the product for the line item|

