/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATE_FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions

SELECT 
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS tota_customers,
SUM(quantity) AS total_quantity
FROM  gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date);

-- Monthly aggregation --
SELECT 
DATE_FORMAT(order_date, '%Y-%m-01') AS month_label,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS tota_customers,
SUM(quantity) AS total_quantity
FROM  gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY DATE_FORMAT(order_date, '%Y-%m-01');


-- Formatted month labels --

SELECT 
DATE_FORMAT(order_date, '%Y-%b') AS order_date, 
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS tota_customers,
SUM(quantity) AS total_quantity
FROM  gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%b') 
ORDER BY DATE_FORMAT(order_date, '%Y-%b') 


