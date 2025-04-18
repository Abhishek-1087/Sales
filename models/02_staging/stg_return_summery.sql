{{ config(
    tags = ["sales_silver"]
) }}

WITH source_return AS (
    SELECT * FROM {{ ref('snap_returns') }}
    WHERE dbt_valid_to IS NULL
),
source_product AS (
    SELECT * FROM {{ ref('snap_products') }}
    WHERE dbt_valid_to IS NULL
),
source_order AS (
    SELECT * FROM {{ ref('snap_orders') }}
    WHERE dbt_valid_to IS NULL
)

SELECT 
    r.return_id,
    r.order_id,
    r.product_id,
    p.product_name,
    o.customer_id,
    r.return_date,
    r.refund_amount,
    r.refund_status
FROM source_return r
JOIN source_product p ON r.product_id = p.product_id
JOIN source_order o ON r.order_id = o.order_id