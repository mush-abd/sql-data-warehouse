-- =====================================================
/*
Stored Procedure: silver.load_silver
=============================================='
This procedure loads data into the silver layer of the CRM ERP database.
It truncates existing tables before loading new data.
This script is intended to be run in a SQL Server environment
Author: [Musharraf Abdullah]
Date: [28-06-2025]
Version: 1.0
---------------------------------------------
To Run Procedure:
EXEC silver.load_silver;
---------------------------------------------
WARNING:
This procedure will truncate existing tables before loading new data.
This means that any existing data in these tables will be lost.
Ensure you have backups of any important data before running this procedure.
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @proc_start_time DATETIME, 
		@proc_end_time DATETIME,
		@start_time DATETIME, 
		@end_time DATETIME;
	BEGIN TRY
		SET @proc_start_time = GETDATE();
		PRINT '====================';
		PRINT 'Loading Silver Layer';
		PRINT '====================';
		PRINT '------------------------------------------';
		PRINT '>> Silver Layer Load Started';
		PRINT '------------------------------------------';
	-- DML for silver layer tables
	-- Inserting data from bronze to silver layer
	-- This script inserts data from the bronze layer tables to the silver layer tables.
	-- Takes care of data cleaning and transformation as per requirements.
	-- Ensures consistency and integrity of data.

	-- Inserting data into table silver.crm_cust_info

	SET @start_time = GETDATE();

	PRINT '>> Truncating Table: silver.crm_cust_info';
	TRUNCATE TABLE silver.crm_cust_info;
	PRINT '>> Inserting Data | Table: silver.crm_cust_info';
	PRINT '------------------------------------------'
	INSERT INTO silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)
	SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'N/A'
	END cst_marital_status,
	CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'N/A'
	END cst_gndr,
	cst_create_date
	FROM (
	SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
	)t
	WHERE flag_last = 1  AND cst_id IS NOT NULL;

	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '------------------------------------------';

	-- =================================================

	--Inserting data into table silver.crm_prd_info
	--
	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info;
	PRINT '>> Inserting Data | Table: silver.crm_prd_info';
	PRINT '------------------------------------------'
	INSERT INTO silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, len(prd_key)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		WHEN 'R' THEN 'Road'
		ELSE 'N/A'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))  AS DATE) AS prd_end_dt
	from bronze.crm_prd_info

	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '------------------------------------------';


	-- Inserting data into table silver.crm_sales_details
	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: silver.crm_sales_details';
	TRUNCATE TABLE silver.crm_sales_details;
	PRINT '>> Inserting Data | Table: silver.crm_sales_details';
	PRINT '------------------------------------------'
	INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key ,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)

	SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt,
	CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * abs(sls_price)
			THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE WHEN sls_price IS NULL OR sls_price <= 0
			THEN sls_sales / NULLIF(sls_quantity, 0)
		ELSE sls_price
	END AS sls_price
	FROM bronze.crm_sales_details

	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '------------------------------------------';

	-- cleaning and loading erp_cust_az12
	-- This script cleans and loads data into the silver.erp_CUST_AZ12 table

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: silver.erp_CUST_AZ12';
	TRUNCATE TABLE silver.erp_CUST_AZ12;
	PRINT '>> Inserting Data | Table: silver.erp_CUST_AZ12';
	PRINT '------------------------------------------'
	INSERT INTO silver.erp_CUST_AZ12(
		cid, 
		bdate,
		gen)

	SELECT
	CASE WHEN cid like 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END AS cid,
	CASE WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate,
	CASE 
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'N/A'
	END AS gen 
	FROM bronze.erp_CUST_AZ12

	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '------------------------------------------';

	-- loading erp_loc_a101
	-- This script cleans and loads data into the silver.erp_LOC_A101 table
	SET @start_time = GETDATE();

	PRINT '>> Truncating Table: silver.erp_LOC_A101';
	TRUNCATE TABLE silver.erp_LOC_A101;
	PRINT '>> Inserting Data | Table: silver.erp_LOC_A101';
	PRINT '------------------------------------------'
	INSERT INTO silver.erp_LOC_A101(
		cid, 
		cntry
	)
	select 
	REPLACE(cid, '-', ''),
	CASE
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') Then 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL then 'N/A'
		ELSE TRIM(cntry)
	END AS cntry
	FROM 
	bronze.erp_loc_a101

	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '------------------------------------------';

	-- load data into silver.erp_px_cat_g1v2

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: silver.erp_PX_CAT_G1V2';
	TRUNCATE TABLE silver.erp_PX_CAT_G1V2;
	PRINT '>> Inserting Data | Table: silver.erp_PX_CAT_G1V2';
	PRINT '------------------------------------------'
	INSERT INTO silver.erp_PX_CAT_G1V2(
		id,
		cat,
		subcat,
		maintenance)
	select 
	id,
	cat,
	subcat,
	maintenance
	from bronze.erp_PX_CAT_G1V2
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '------------------------------------------';
	-- =================================================
	PRINT '>> Silver Layer Load Completed Successfully';
	SET @proc_end_time = GETDATE();
	PRINT '>> Total Load Duration: ' + CAST(DATEDIFF(second, @proc_start_time, @proc_end_time) AS NVARCHAR) + ' seconds';
	PRINT '------------------------------------------';
	END TRY
	BEGIN CATCH
		PRINT '>> Silver Layer Load Failed';
		PRINT '------------------------------------------';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT '------------------------------------------';
	END CATCH
END