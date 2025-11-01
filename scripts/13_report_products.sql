/*
===============================================================================
Product Report (MySQL Version)
===============================================================================
Purpose:
    - Consolidates key product metrics and behaviors.

Highlights:
    1. Retrieves product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

USE DataWarehouseAnalytics;

-- =============================================================================
-- Drop the view if it already exists
-- =============================================================================
DROP VIEW IF EXISTS gold_report_products;

-- =============================================================================
-- Create the view
-- =============================================================================
CREATE VIEW gold_report_products AS

WITH base_query AS (
    /*---------------------------------------------------------------------------
    1) Base Query: Retrieves core columns from fact_sales and dim_products
    ---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold_fact_sales f
    LEFT JOIN gold_dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

product_aggregations AS (
    /*---------------------------------------------------------------------------
    2) Product Aggregations: Summarizes key metrics at the product level
    ---------------------------------------------------------------------------*/
    SELECT
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        TIMESTAMPDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan,
        MAX(f.order_date) AS last_sale_date,
        COUNT(DISTINCT f.order_number) AS total_orders,
        COUNT(DISTINCT f.customer_key) AS total_customers,
        SUM(f.sales_amount) AS total_sales,
        SUM(f.quantity) AS total_quantity,
        ROUND(AVG(f.sales_amount / NULLIF(f.quantity, 0)), 1) AS avg_selling_price
    FROM base_query f
    JOIN gold_dim_products p ON f.product_key = p.product_key
    GROUP BY
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
)

    /*---------------------------------------------------------------------------
    3) Final Query: Combines all product results into one output
    ---------------------------------------------------------------------------*/
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    TIMESTAMPDIFF(MONTH, last_sale_date, CURDATE()) AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Average Order Revenue (AOR)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE ROUND(total_sales / total_orders, 2)
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE ROUND(total_sales / lifespan, 2)
    END AS avg_monthly_revenue

FROM product_aggregations;
