{{ config(
    tags = ["sales_silver"]
) }}

WITH source_order AS (
    SELECT * FROM {{ ref('snap_orders') }}
    WHERE dbt_valid_to IS NULL
),
source_payment AS (
    SELECT * FROM {{ ref('snap_payments') }}
    WHERE dbt_valid_to IS NULL
),
source_return AS (
    SELECT * FROM {{ ref('snap_returns') }}
    WHERE dbt_valid_to IS NULL
)

SELECT 
    CONCAT('ORDER_', o.order_id) AS event_id,
    o.customer_id,
    'Order' AS event_type,
    o.order_date AS event_date,
    o.order_id AS related_id,
    o.net_amount AS amount
FROM source_order o
UNION ALL
SELECT 
    CONCAT('PAY_', p.payment_id) AS event_id,
    o.customer_id,
    'Payment' AS event_type,
    p.payment_date,
    p.order_id,
    p.amount
FROM source_payment p
JOIN source_order o ON p.order_id = o.order_id
UNION ALL
SELECT 
    CONCAT('RETURN_', r.return_id) AS event_id,
    o.customer_id,
    'Return' AS event_type,
    r.return_date,
    r.order_id,
    r.refund_amount
FROM source_return r
JOIN source_order o ON r.order_id = o.order_id