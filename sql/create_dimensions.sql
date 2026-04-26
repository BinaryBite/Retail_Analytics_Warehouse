CREATE SCHEMA warehouse;

--------------------------------------------------

CREATE TABLE warehouse.dim_geolocation AS
WITH cleaned AS (
    SELECT
        geolocation_zip_code_prefix AS zip_prefix,
        TRIM(UPPER(geolocation_city)) AS city,
        geolocation_state AS state,
        geolocation_lat AS lat,
        geolocation_lng AS lng
    FROM staging.geolocation
)

SELECT
    ROW_NUMBER() OVER(ORDER BY zip_prefix) AS location_key,
    zip_prefix,
    AVG(lat) AS avg_lat,
    AVG(lng) AS avg_lng,
    MODE() WITHIN GROUP (ORDER BY city) AS city,
    MODE() WITHIN GROUP (ORDER BY state) AS state
FROM cleaned
GROUP BY zip_prefix;

-- Create primary key
ALTER TABLE warehouse.dim_geolocation
ADD PRIMARY KEY (location_key);

--Create business key
CREATE UNIQUE INDEX idx_zip_prefix
ON warehouse.dim_geolocation(zip_prefix);

--------------------------------------------------

CREATE TABLE warehouse.dim_customers AS
SELECT DISTINCT
    ROW_NUMBER() OVER () AS customer_key,
    c.customer_id,
    c.customer_unique_id,
    g.location_key
FROM staging.customers c
LEFT JOIN warehouse.dim_geolocation g
    ON c.customer_zip_code_prefix = g.zip_prefix;

-- Create primary key
ALTER TABLE warehouse.dim_customers
ADD PRIMARY KEY (customer_key);

--Create business key
CREATE UNIQUE INDEX idx_customer_id
ON warehouse.dim_customers(customer_id);

--------------------------------------------------

CREATE TABLE warehouse.dim_sellers AS
SELECT DISTINCT
    ROW_NUMBER() OVER () AS seller_key,
    s.seller_id,
    g.location_key
FROM staging.sellers s
LEFT JOIN warehouse.dim_geolocation g
    ON s.seller_zip_code_prefix = g.zip_prefix;

-- Create primary key
ALTER TABLE warehouse.dim_sellers
ADD PRIMARY KEY (seller_key);

--Create business key
CREATE UNIQUE INDEX idx_seller_id
ON warehouse.dim_sellers(seller_id);

--------------------------------------------------


CREATE TABLE warehouse.dim_products AS
SELECT DISTINCT
    ROW_NUMBER() OVER () AS product_key,
    p.product_id,
    t.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM staging.products p
LEFT JOIN staging.product_category_name_translation t
    ON p.product_category_name = t.product_category_name;

-- Create primary key
ALTER TABLE warehouse.dim_products
ADD PRIMARY KEY (product_key);

--Create business key
CREATE UNIQUE INDEX idx_product_id
ON warehouse.dim_products(product_id);
--------------------------------------------------

CREATE TABLE warehouse.dim_date AS
SELECT
    d::DATE AS date_key,
    EXTRACT(YEAR FROM d) AS year,
    EXTRACT(MONTH FROM d) AS month,
    EXTRACT(DAY FROM d) AS day,
    TO_CHAR(d, 'FMMonth') AS month_name,
    EXTRACT(DOW FROM d) AS day_of_week,
    TO_CHAR(d, 'Day') AS day_name,
    EXTRACT(WEEK FROM d) AS week,
    (EXTRACT(YEAR FROM d) * 100 + EXTRACT(MONTH FROM d)) AS year_month,
    CASE
        WHEN EXTRACT(DOW FROM d) IN (0,6) THEN TRUE
        ELSE FALSE
    END AS is_weekend
    FROM generate_series(
        (SELECT MIN(order_purchase_timestamp)::DATE FROM staging.orders),
        (SELECT MAX(order_purchase_timestamp)::DATE FROM staging.orders),
        INTERVAL '1 day'
    ) AS d;

-- Create primary key
ALTER TABLE warehouse.dim_date
ADD PRIMARY KEY (date_key);

--------------------------------------------------

CREATE TABLE warehouse.dim_review_text AS
SELECT DISTINCT
    ROW_NUMBER() OVER () AS review_text_key,
    r.review_id,
    r.review_comment_title,
    r.review_comment_message
FROM staging.reviews r;

-- Create primary key
ALTER TABLE warehouse.dim_review_text
ADD PRIMARY KEY (review_text_key);

--Create business key
CREATE UNIQUE INDEX idx_review_text_id
ON warehouse.dim_review_text(review_id);

