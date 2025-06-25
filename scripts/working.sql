-- DDL for Bronze layer tables 

USE crm_erp_db;
GO
IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info(
cst_id INT,
cst_key Varchar(50),
cst_firstname Varchar(50),
cst_lastname Varchar(50), 
cst_material_status Varchar(50),
cst_gndr Varchar(50),
cst_create_date DATE
);


IF OBJECT_ID ('bronze.prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.prd_info;

CREATE TABLE bronze.prd_info(
prd_id INT,
prd_key Varchar(50),
prd_nm Varchar(50),
prd_cost Float,
prd_line Char,
prd_start_dt Date,
prd_end_dt Date
);

IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details(
sls_ord_num Varchar(20),
sls_prd_key Varchar(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

IF OBJECT_ID ('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_CUST_AZ12;

CREATE TABLE bronze.erp_CUST_AZ12(
CID INT,
BDATE DATE,
GEN Varchar(20)
);

IF OBJECT_ID ('bronze.erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_LOC_A101;

CREATE TABLE bronze.erp_LOC_A101(
CID Varchar(50),
CNTRY Varchar(50)
);

IF OBJECT_ID ('bronze.PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE bronze.PX_CAT_G1V2;

CREATE TABLE bronze.PX_CAT_G1V2(
ID Varchar(20),
CAT Varchar(50),
SUBCAT Varchar(50),
MAINTENANCE Varchar(10)

);


-- Creating procedure
-- DDL for loading files to sql

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @proc_start_time DATETIME;
	SET @proc_start_time = GETDATE();
	DECLARE @proc_end_time DATETIME;
	DECLARE @start_time DATETIME, @end_time DATETIME;
	
	BEGIN TRY
		PRINT '====================';
		PRINT 'Loading Bronze Layer';
		PRINT '====================';
	
		PRINT '--------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data | Table: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Projects\sql-data-warehouse\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;
	
		PRINT '>> Inserting Data | Table: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Projects\sql-data-warehouse\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;
	
		PRINT '>> Inserting Data | Table: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Projects\sql-data-warehouse\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------------------------------'

		PRINT '--------------------';
		PRINT 'Loading ERP Tables';
		PRINT '--------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_CUST_AZ12'
		TRUNCATE TABLE bronze.erp_CUST_AZ12;

		PRINT '>> Inserting Data | Table: bronze.erp_CUST_AZ12'
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'D:\Projects\sql-data-warehouse\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_LOC_A101'
		TRUNCATE TABLE bronze.erp_LOC_A101;

		PRINT '>> Inserting Data | Table: bronze.erp_LOC_A101'	
		BULK INSERT bronze.erp_LOC_A101
		FROM 'D:\Projects\sql-data-warehouse\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_PX_CAT_G1V2'
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

		PRINT '>> Inserting Data | Table: bronze.erp_PX_CAT_G1V2'

		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'D:\Projects\sql-data-warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '------------------------------------------'
	END TRY
	BEGIN CATCH
		PRINT '==========================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error NUMBER' + CAST (ERROR_NUMBER() AS VARCHAR);
		PRINT 'Error NUMBER' + CAST (ERROR_STATE() AS VARCHAR);
	END CATCH
	SET @proc_end_time = GETDATE();
	PRINT '>> Proc Duration: ' + CAST(DATEDIFF(second, @proc_start_time, @proc_end_time) AS NVARCHAR) + 'seconds';

END

-- running procedure

EXEC bronze.load_bronze; 