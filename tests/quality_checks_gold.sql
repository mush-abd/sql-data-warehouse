/*
Quality Checks for Gold Layer
This script performs quality checks on the gold layer views to ensure data integrity and consistency.
Author: [Musharraf Abdullah]
Date: [28-06-2025]
Version: 1.0
---------------------------------------------
To Run Script:
EXEC gold.quality_check_gold;
---------------------------------------------
*/
-- Check for dim_customer view
SELECT 
    customer_key,
    count(*) AS duplicate_count
FROM gold.dim_customer
GROUP BY customer_key
HAVING count(*) > 1;

-- create more queries accordingly

-- Check for dim_products view
SELECT 
    product_key,
    count(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING count(*) > 1;

-- Check for fact_sales view
SELECT 
    order_num,
    count(*) AS duplicate_count
FROM gold.fact_sales
GROUP BY order_num
HAVING count(*) > 1;


