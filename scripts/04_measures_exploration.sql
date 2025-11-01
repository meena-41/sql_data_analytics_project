use DataWarehouseAnalytics;
/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold_fact_sales;

-- Find how many items are sold
SELECT COUNT(quantity) AS total_quantity FROM gold_fact_sales;

-- Find the average selling price
SELECT AVG(price) AS average_price FROM gold_fact_sales;

-- Find the Total number of Orders
SELECT COUNT(order_number) AS Total_orders FROM gold_fact_sales;
SELECT COUNT(DISTINCT order_number) AS Total_orders FROM gold_fact_sales;

-- Find the total number of products
SELECT COUNT(product_number) AS Total_products FROM gold_dim_products;
SELECT COUNT(DISTINCT product_number) AS Total_products FROM gold_dim_products;

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customer FROM gold_dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customer FROM gold_fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' as measure_value,SUM(sales_amount) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'Total Quantity' as measure_value,COUNT(quantity) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'Average Price' as measure_value, AVG(price) AS  measure_value FROM gold_fact_sales
UNION ALL
SELECT 'Total Nr. Orders' as measure_value,COUNT(DISTINCT order_number) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'Total Nr.  Products' as measure_value, COUNT(DISTINCT product_number) AS measure_value FROM gold_dim_products
UNION ALL
SELECT 'total Nr. Customer' as measure_value, COUNT(customer_key) AS measure_value FROM gold_dim_customers
UNION ALL
SELECT 'total Nr. customer' as measure_value,COUNT(DISTINCT customer_key) AS measure_value FROM gold_fact_sales

