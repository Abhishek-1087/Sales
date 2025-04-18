{{ config(
    tags = ["sales_silver"]
) }}

WITH source_payment AS (
    SELECT * FROM {{ ref('snap_payments') }}
    WHERE dbt_valid_to IS NULL
)

SELECT 
    payment_id,
    order_id,
    payment_method,
    status,
    amount,
    payment_date
FROM source_payment