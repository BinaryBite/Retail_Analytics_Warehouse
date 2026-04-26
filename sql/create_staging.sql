CREATE SCHEMA staging;

--Dim--
CREATE TABLE staging.customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);


--Dim--
CREATE TABLE staging.geolocation (
    geolocation_zip_code_prefix TEXT,
    geolocation_lat NUMERIC(9,6),
    geolocation_lng NUMERIC(9,6),
    geolocation_city TEXT,
    geolocation_state TEXT
);

--Fact--
CREATE TABLE  staging.orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

--Fact--
CREATE TABLE staging.order_items (
    order_id TEXT,
    order_item_id TEXT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TIMESTAMP,
    price FLOAT,
    freight_value FLOAT
);

--Fact--
CREATE TABLE staging.order_payments (
    order_id TEXT,
    payment_sequential INT,
    payment_type TEXT,
    payment_installments INT,
    payment_value FLOAT
);

--Fact and Dim--
CREATE TABLE staging.reviews (
    review_id TEXT,
    order_id TEXT,
    review_score INT, --FACT--
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

--Dim--
CREATE TABLE staging.products (
    product_id TEXT,
    product_category_name TEXT,
    product_name_lenght FLOAT,
    product_description_lenght FLOAT,
    product_photos_qty FLOAT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);

--Dim--
CREATE TABLE staging.sellers (
    seller_id TEXT,
    seller_zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT
);

--Mapping--
CREATE TABLE staging.product_category_name_translation (
    product_category_name TEXT,
    product_category_name_english TEXT
);