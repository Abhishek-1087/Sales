{{ config(
    tags = ["sales_silver"]
) }}

WITH source_payment AS (
    SELECT * FROM {{ ref('snap_payments') }}
    WHERE dbt_valid_to IS NULL
),
source_order AS (
    SELECT * FROM {{ ref('snap_orders') }}
    WHERE dbt_valid_to IS NULL
)

SELECT 
    p.payment_id,
    p.order_id,
    o.customer_id,
    p.amount,
    p.payment_date,
    p.status
FROM source_payment p
JOIN source_order o ON p.order_id = o.order_id
WHERE p.status IN ('Failed', 'Refunded')