CREATE SCHEMA warehouse;

--------------------------------------------------

CREATE TABLE warehouse.dim_customers AS
SELECT DISTINCT
    ROW_NUMBER() OVER () AS customer_key,
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM staging.customers;

-- Create primary key
ALTER TABLE warehouse.dim_customers
ADD PRIMARY KEY (customer_key);


--Create business key
CREATE UNIQUE INDEX idx_customer_id
ON warehouse.dim_customers(customer_id);

--------------------------------------------------

CREATE TABLE warehouse.dim_geolocation AS
SELECT DISTINCT
    geolocation_zip_code_prefix AS zip_code_prefix,
    AVG(geolocation_lat) AS avg_lat,
    AVG(geolocation_lng) AS avg_lng,
    MIN(geolocation_city) AS city,
    MIN(geolocation_state) AS state
FROM staging.geolocation
GROUP BY geolocation_zip_code_prefix;

-- Create primary key
ALTER TABLE warehouse.dim_geolocation
ADD COLUMN location_key SERIAL PRIMARY KEY;


--Create business key
CREATE UNIQUE INDEX idx_zip_prefix
ON warehouse.dim_geolocation(zip_code_prefix);

--------------------------------------------------


CREATE TABLE warehouse.dim_customers AS
SELECT DISTINCT
    ROW_NUMBER() OVER () AS customer_key,
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM staging.customers;

-- Create primary key
ALTER TABLE warehouse.dim_customers
ADD PRIMARY KEY (customer_key);


--Create business key
CREATE UNIQUE INDEX idx_customer_id
ON warehouse.dim_customers(customer_id);