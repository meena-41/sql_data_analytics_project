-- =============================================================
-- Create Database and Tables (MySQL Version)
-- =============================================================

-- WARNING:
-- Running this script will DROP and RECREATE the database 'DataWarehouseAnalytics'
-- All existing data in that database will be permanently deleted.
-- Ensure you have backups before executing this script.

-- Drop and recreate the database
DROP DATABASE IF EXISTS DataWarehouseAnalytics;
CREATE DATABASE DataWarehouseAnalytics CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE DataWarehouseAnalytics;

-- =============================================================
-- Create Gold Layer Tables
-- =============================================================

-- Table: gold_dim_customers
CREATE TABLE IF NOT EXISTS gold_dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: gold_dim_products
CREATE TABLE IF NOT EXISTS gold_dim_products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: gold_fact_sales
CREATE TABLE IF NOT EXISTS gold_fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================
-- Load Data from CSV files
-- =============================================================

-- ⚠️ Before running these LOAD DATA commands:
-- 1. Ensure 'secure_file_priv' allows reading from your folder, OR
-- 2. Use LOCAL option if running from a client and have enabled:
--      SET GLOBAL local_infile = 1;
--      (requires SUPER privileges)
--
-- 3. Replace backslashes '\' with double backslashes '\\' or forward slashes '/'.

-- Truncate tables (equivalent of TRUNCATE + BULK INSERT)
TRUNCATE TABLE gold_dim_customers;
TRUNCATE TABLE gold_dim_products;
TRUNCATE TABLE gold_fact_sales;

-- Load customers
LOAD DATA LOCAL INFILE
'C:/SQL PROJECT/Data analyst project/sql-data-analytics-project/datasets/csv-files/gold.dim_customers.csv'
INTO TABLE gold_dim_customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(customer_key, customer_id, customer_number, first_name, last_name, country, marital_status, gender, birthdate, create_date);

-- Load products
LOAD DATA LOCAL INFILE
'C:/SQL PROJECT/Data analyst project/sql-data-analytics-project/datasets/csv-files/gold.dim_products.csv'
INTO TABLE gold_dim_products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(product_key, product_id, product_number, product_name, category_id, category, subcategory, maintenance, cost, product_line, start_date);

-- Load fact_sales
LOAD DATA LOCAL INFILE
'C:/SQL PROJECT/Data analyst project/sql-data-analytics-project/datasets/csv-files/gold.fact_sales.csv'
INTO TABLE gold_fact_sales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_number, product_key, customer_key, order_date, shipping_date, due_date, sales_amount, quantity, price);
