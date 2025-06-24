/*
==============================================
    CRM ERP Database Initialization Script
==============================================
    This script initializes the CRM ERP database by creating necessary schemas.
    It includes the creation of the bronze, silver, and gold schemas.
    It also checks if the database already exists and drops it if necessary.

    This script is intended to be run in a SQL Server environment.

    Author: [Musharraf Abdullah]
    Date: [25-06-2025]
    Version: 1.0

WARNING:
    This script will drop the existing 'crm_erp_db' database if it exists.



*/




USE master;
GO

--drop database if exists [crm_erp_db]

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'crm_erp_db')

BEGIN
    ALTER DATABASE [crm_erp_db] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [crm_erp_db];
END;
GO


--create database [crm_erp_db]
CREATE DATABASE crm_erp_db;
GO

USE crm_erp_db;
GO

--create schemas

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
