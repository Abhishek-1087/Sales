{{ config(
    tags = ["sales_silver"]
) }}

With source_customer AS(
        SELECT
        *
    FROM {{ ref('snap_customers') }}
    WHERE dbt_valid_to IS NULL
)

, source_order AS(
        SELECT
        *
    FROM {{ ref('snap_orders') }}
    WHERE dbt_valid_to IS NULL
)

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    c.city,
    c.signup_date,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.net_amount), 0) AS total_spent,
    COALESCE(AVG(o.net_amount), 0) AS avg_order_value,
    MAX(o.order_date) AS last_order_date
FROM source_customer c
LEFT JOIN source_order o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.city, c.signup_date