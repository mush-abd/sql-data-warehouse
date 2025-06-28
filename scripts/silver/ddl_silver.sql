
-- DDL for silver layer tables
/*
=============================================
DDL for Silver layer tables
Creating the necessary tables in the Silver layer of the CRM and ERP database.
This script checks if the tables already exist and drops them if they do.
This script is intended to be run in a SQL Server environment
Author: [Musharraf Abdullah]
Date: [28-06-2025]

Version: 1.0
*/

USE crm_erp_db;
GO

IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info(
cst_id INT,
cst_key Varchar(50),
cst_firstname Varchar(50),
cst_lastname Varchar(50), 
cst_marital_status Varchar(50),
cst_gndr Varchar(50),
cst_create_date DATE
);


IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info(
prd_id INT,
prd_key Varchar(50),
prd_nm Varchar(50),
prd_cost INT,
prd_line Char,
prd_start_dt Date,
prd_end_dt Date
);

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details(
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

IF OBJECT_ID ('silver.erp_CUST_AZ12', 'U') IS NOT NULL
	DROP TABLE silver.erp_CUST_AZ12;

CREATE TABLE silver.erp_CUST_AZ12(
CID varchar(20),
BDATE DATE,
GEN Varchar(20)
);

IF OBJECT_ID ('silver.erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE silver.erp_LOC_A101;

CREATE TABLE silver.erp_LOC_A101(
CID Varchar(50),
CNTRY Varchar(50)
);

IF OBJECT_ID ('silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE silver.erp_PX_CAT_G1V2;

CREATE TABLE silver.erp_PX_CAT_G1V2(
ID Varchar(20),
CAT Varchar(50),
SUBCAT Varchar(50),
MAINTENANCE Varchar(10)
);
 
