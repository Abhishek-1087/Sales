{{ config(
    tags = ["sales_silver"]
) }}

WITH source_payment AS (
    SELECT * FROM {{ ref('snap_payments') }}
)

SELECT 
    payment_id,
    order_id,
    payment_method,
    status,
    amount,
    payment_date
FROM source_payment