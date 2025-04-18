{{ config(
    tags = ["sales_silver"]
) }}

WITH source_order AS (
    SELECT * FROM {{ ref('snap_orders') }}
    WHERE dbt_valid_to IS NULL
)

SELECT 
    DATE(order_date) AS date,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_sales,
    SUM(tax) AS total_tax,
    SUM(discount) AS total_discount,
    SUM(net_amount) AS net_revenue
FROM source_order
GROUP BY DATE(order_date)