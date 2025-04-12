{{ config(
    tags = ["sales_silver"]
) }}

WITH source_order AS (
    SELECT * FROM {{ ref('snap_orders') }}
),
source_order_detail AS (
    SELECT * FROM {{ ref('snap_order_details') }}
)

SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    COUNT(od.product_id) AS total_items,
    o.net_amount,
    DATEDIFF(day, CAST(o.order_date AS DATE), CURRENT_DATE) AS order_age_days
FROM source_order o
LEFT JOIN source_order_detail od ON o.order_id = od.order_id
GROUP BY o.order_id, o.customer_id, o.order_date, o.order_status, o.net_amount