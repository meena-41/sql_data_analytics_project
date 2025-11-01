/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH category_sales AS(
  SELECT 
    p.category,
    SUM(sales_amount) total_sales
  FROM  gold_fact_sales F
  LEFT JOIN  gold_dim_products P
    ON f.product_key=p.product_key
  GROUP BY p.category
)
SELECT 
  category,
  total_sales,
  SUM(total_sales) OVER() AS overall_sales,
  CONCAT(ROUND((cast(total_sales AS FLOAT)/SUM(total_sales) OVER())*100,2),'%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC
