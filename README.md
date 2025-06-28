# SQL Data Warehouse Project - Medallion Architecture

## 📌 Overview

This project implements a **SQL Data Warehouse** following the **Medallion Architecture** (**Bronze → Silver → Gold layers**).

It takes data from raw source folders, processes and cleans it through multiple layers, and presents business-ready analytical views for reporting and analytics tools like **Power BI** and **SSRS**.

---

## 🏗️ Data Pipeline Architecture

![Data Pipeline Architecture](./docs/pipeline%20architecture.png)

---

## 🗂️ Source Systems

The source data comes from two folders:

### 📁 CRM Folder
| Table Name | Description |
|----------- | ----------- |
| `cust_info` | Customer master details |
| `prd_info` | Product master details |
| `sales_info` | Sales transactions |

### 📁 ERP Folder
| Table Name | Description |
|----------- | ----------- |
| `loc_a101` | Customer location information (country, etc.) |
| `px_cat_g1v2` | Product category details |
| `cust_AZ12` | Additional customer details (e.g., date of birth) |

---

## 🏅 Medallion Architecture Layers

### 🥉 Bronze Layer (Raw Ingestion)
- **What:** Raw data loaded directly from source folders.
- **Naming convention:**  

- **Examples:**  
- `bronze.crm.cust_info`
- `bronze.erp.loc_a101`

---

### 🥈 Silver Layer (Cleaned & Standardized)
- **What:**  
Cleaned, standardized, and lightly transformed data.

- **Processes include:**
- Null handling
- Data type corrections
- Column name standardization
- Deduplication

- **Naming Convention:**  

- **Examples:**  
- `silver.crm.cust_info`
- `silver.erp.loc_a101`

---

### 🥇 Gold Layer (Business Views / Analytics Ready)
- **What:**  
Final, business-focused, reporting-ready views.

- **Outputs:**

| Gold View | Type | Description |
|---------- | ---- | ----------- |
| `gold.dim_customer` | Dimension | Combines all customer-related tables from Silver layer |
| `gold.dim_product` | Dimension | Combines all product-related tables |
| `gold.fact_sales` | Fact | Combines sales data with customer and product dimensions |

---

## 🚦 Data Flow Summary

1. **Source Files → Bronze Layer** (Raw Load)
2. **Bronze → Silver Layer** (Data Cleaning & Standardization)
3. **Silver → Gold Layer** (Business Logic and Aggregation)
4. **Gold Layer → Consumption Tools:**  
 - Power BI  
 - SQL Server Reporting Services (SSRS)  
 - Custom Dashboards  

---

## 📂 Project Folder Structure (Schema Naming Convention)


---

## ✅ Benefits of This Architecture
- **Scalable and Modular Design**
- **Clear Raw-to-Curated Data Lineage**
- **Optimized for Business Reporting and Analytics**
- **Compatible with Multiple BI Tools**

---