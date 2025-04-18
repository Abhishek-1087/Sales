{{ config(
    tags = ["sales_silver"]
) }}

WITH source_inventory AS (
    SELECT * FROM {{ ref('snap_inventory') }}
    WHERE dbt_valid_to IS NULL
),
source_product AS (
    SELECT * FROM {{ ref('snap_products') }}
    WHERE dbt_valid_to IS NULL
)

SELECT 
    p.product_id,
    p.product_name,
    i.warehouse_location,
    i.stock_quantity,
    i.last_updated
FROM source_inventory i
JOIN source_product p ON i.product_id = p.product_id