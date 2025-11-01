/*
===============================================================================
Database Exploration (MySQL Version)
===============================================================================
Purpose:
    - Explore the structure of the database: list all tables and their schemas.
    - Inspect columns and metadata for specific tables.
===============================================================================
*/

-- Step 1: Make sure you are using the correct database
USE DataWarehouseAnalytics;

-- Step 2: Retrieve a list of all tables in the current database
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE,
    ENGINE,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = DATABASE();   -- Limits to current database

-- Step 3: Retrieve all columns for a specific table (gold_dim_customers)
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    ORDINAL_POSITION,
    COLUMN_DEFAULT,
    IS_NULLABLE,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    COLUMN_TYPE,
    COLUMN_KEY,
    EXTRA
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'gold_dim_customers';
