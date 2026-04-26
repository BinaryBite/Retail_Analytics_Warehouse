
---------------------------------------------
CREATE TABLE warehouse.fact_sales AS
SELECT
o.order_id,
dc.customer_key,
dp.product_key,
ds.seller_key,
DATE(o.order_purchase_timestamp) AS date_key,
oi.price,
oi.freight_value,
(oi.price + oi.freight_value) AS total_revenue

--Orders--
FROM staging.orders o
--Items--
JOIN staging.order_items oi
    ON o.order_id = oi.order_id
--Customers--
JOIN warehouse.dim_customers dc
    ON o.customer_id = dc.customer_id
--Products--
JOIN warehouse.dim_products dp
    ON oi.product_id = dp.product_id
--Sellers--
JOIN warehouse.dim_sellers ds
    ON oi.seller_id = ds.seller_id; 
    
CREATE INDEX idx_fact_customer ON warehouse.fact_sales(customer_key);
CREATE INDEX idx_fact_product ON warehouse.fact_sales(product_key);
CREATE INDEX idx_fact_date ON warehouse.fact_sales(date_key);
CREATE INDEX idx_fact_order ON warehouse.fact_sales(order_id);
CREATE INDEX idx_fact_seller ON warehouse.fact_sales(seller_key);

---------------------------------------------
CREATE TABLE warehouse.fact_payments AS
SELECT
op.order_id,
dc.customer_key,
DATE(o.order_purchase_timestamp) AS date_key,
op.payment_type,
op.payment_installments,
op.payment_value

--Order Payments--
FROM staging.order_payments op
--Orders--
JOIN staging.orders o
    ON op.order_id = o.order_id
--Customers--
JOIN warehouse.dim_customers dc
    ON o.customer_id = dc.customer_id;

CREATE INDEX idx_payment_customer ON warehouse.fact_payments(customer_key);
CREATE INDEX idx_payment_date ON warehouse.fact_payments(date_key);
---------------------------------------------
CREATE TABLE warehouse.fact_reviews AS
SELECT
r.review_id,
r.order_id,
dc.customer_key,
DATE(r.review_creation_date) AS date_key,
r.review_score,
r.review_creation_date,
r.review_answer_timestamp
--Reviews--
FROM staging.reviews r
--Orders--
JOIN staging.orders o
    ON r.order_id = o.order_id
--Customers--
JOIN warehouse.dim_customers dc
    ON o.customer_id = dc.customer_id;


CREATE INDEX idx_review_customer ON warehouse.fact_reviews(customer_key);
CREATE INDEX idx_review_date ON warehouse.fact_reviews(date_key);
