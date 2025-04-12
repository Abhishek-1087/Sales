{{ config(
    tags = ["sales_silver"]
) }}

WITH source_shipment AS (
    SELECT * FROM {{ ref('snap_shipments') }}
)

SELECT 
    shipment_id,
    order_id,
    shipping_date,
    delivery_date,
    delivery_status,
    DATEDIFF(day, CAST(delivery_date AS DATE), CAST(shipping_date AS DATE)) AS delivery_time_days
FROM source_shipment