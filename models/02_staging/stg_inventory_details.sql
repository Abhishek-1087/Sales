{{ config(
    tags = ["sales_silver"]
) }}

WITH source_inventory AS (
    SELECT * FROM {{ ref('snap_inventory') }}
),
source_product AS (
    SELECT * FROM {{ ref('snap_products') }}
)

SELECT 
    p.product_id,
    p.product_name,
    i.warehouse_location,
    i.stock_quantity,
    i.last_updated
FROM source_inventory i
JOIN source_product p ON i.product_id = p.product_id