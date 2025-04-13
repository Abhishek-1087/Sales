{{ config(
    tags = ["sales_gold"]
) }}

WITH source_shipment_status AS (
    SELECT * FROM {{ ref('stg_shipment_status') }}
)

SELECT 
    delivery_status,
    COUNT(*) AS total_shipments,
    -1 * ROUND(AVG(delivery_time_days), 2) AS avg_delivery_days
FROM source_shipment_status
GROUP BY delivery_status