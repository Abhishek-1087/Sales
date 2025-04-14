{{ config(
    tags = ["sales_gold"]
) }}

WITH source_order_summary AS (
    SELECT * FROM {{ ref('stg_order_summery') }}
)

SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(net_amount) AS lifetime_value,
    AVG(net_amount) AS avg_order_value,
    MAX(order_date) AS last_order_date
FROM source_order_summary
GROUP BY customer_id