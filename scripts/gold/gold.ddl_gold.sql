/*
============================================================
SQL Data Warehouse - Gold Layer DDL Script
============================================================
This script creates views in the gold layer of the CRM ERP database.
It aggregates data from the silver layer and includes additional fields from the ERP layer.
This script is intended to be run in a SQL Server environment
Author: [Musharraf Abdullah]
Date: [28-06-2025]
Version: 1.0
============================================================
WARNING:
This script assumes that the silver layer tables and views already exist.
Ensure that the silver layer is populated before running this script.
============================================================
*/
USE crm_erp_db;
GO
--Create a view for customer dimension in the gold layer
-- This view aggregates customer information from the silver layer and includes additional fields from the ERP layer.
-- =============================================================
IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
    DROP VIEW gold.dim_customer;

CREATE VIEW gold.dim_customer AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	ca.bdate AS birthdate,
	CASE
		WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'N/A')
	END AS gender,
	ci.cst_create_date AS create_date  

from silver.crm_cust_info ci
LEFT JOIN silver.erp_CUST_AZ12 ca
ON		ci.cst_key = ca.cid
LEFT JOIN silver.erp_LOC_A101 la 
ON		ci.cst_key = la.cid


-- Create a view for product dimension in the gold layer
-- This view aggregates product information from the silver layer and includes additional fields from the ERP layer.

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;

CREATE VIEW gold.dim_products AS

SELECT
	ROW_NUMBER() OVER (ORDER BY prd_start_dt, prd_key) AS product_key,
	prd_id AS product_id,
	prd_key AS product_number,
	prd_nm AS product_name,
	prd_line AS product_line,
	cat_id AS category_id,
	cat AS category,
	maintenance,
	subcat AS subcategory,	
	prd_cost AS COST,
	prd_start_dt,
	prd_end_dt
FROM 
	silver.crm_prd_info pn
	LEFT JOIN
	silver.erp_px_cat_g1v2 pc
	ON pn.cat_id = pc.id
WHERE 
	prd_end_dt IS NULL



-- Create a view for sales fact table in the gold layer
-- This view aggregates sales details from the silver layer and joins with product and customer dimensions.

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
CREATE VIEW gold.fact_sales AS

SELECT
	sd.sls_ord_num AS order_num,
	pr.product_key AS product_key,
	cu.customer_key AS customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price

FROM
	silver.crm_sales_details sd
	LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number
	LEFT JOIN gold.dim_customer cu
	ON sd.sls_cust_id = cu.customer_id


select * 
from gold.fact_sales f
LEFT JOIN gold.dim_customer c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
where f.product_key is null

select * from gold.fact_sales
