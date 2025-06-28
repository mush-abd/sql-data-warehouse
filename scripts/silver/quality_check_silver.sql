/* 
==== Quality Check for Silver Layer ====
This script performs quality checks on the silver layer tables to ensure data integrity and consistency.
Author: [Musharraf Abdullah]
Date: [28-06-2025]
Version: 1.0
---------------------------------------------
To Run Script:
EXEC silver.quality_check_silver;
---------------------------------------------
*/


-- Check for crm_sales_details

-- Check for Unwanted Spaces in Primary Key 
-- Expectations: No results 

SELECT * 
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- check for duplicate in primary key

SELECT Distinct *
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

SELECT 
NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0 
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101

USE crm_erp_db;
GO
SELECT * 
FROM silver.crm_sales_details
where sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt


SELECT
sls_sales ,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_quantity IS NULL or sls_quantity <= 0
OR sls_sales IS NULL or sls_sales <= 0
OR sls_price IS NULL or sls_sales <= 0

-- Check for crm_cust_info
SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL
OR cst_key IS NULL
OR cst_firstname IS NULL
OR cst_lastname IS NULL
OR cst_marital_status IS NULL
OR cst_gndr IS NULL
OR cst_create_date IS NULL;
-- Check for crm_prd_info

SELECT *
FROM silver.crm_prd_info
WHERE prd_id IS NULL
OR prd_key IS NULL
OR prd_nm IS NULL
OR prd_cost IS NULL
OR prd_line IS NULL
OR prd_start_dt IS NULL
OR prd_end_dt IS NULL;

-- Check for erp_CUST_AZ12
SELECT *
FROM silver.erp_CUST_AZ12
WHERE cid IS NULL
OR bdate IS NULL
OR gen IS NULL;

-- Check for erp_LOC_A101
SELECT *
FROM silver.erp_LOC_A101
WHERE cid IS NULL

--check for erp_PX_CAT_G1V2
SELECT *
FROM silver.erp_PX_CAT_G1V2
WHERE id IS NULL
OR cat IS NULL
OR subcat IS NULL
OR maintenance IS NULL;

-- add your additional quality checks here


