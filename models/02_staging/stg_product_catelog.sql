{{ config(
    tags = ["sales_silver"]
) }}

WITH source_product AS (
    SELECT * FROM {{ ref('snap_products') }}
),
source_inventory AS (
    SELECT * FROM {{ ref('snap_inventory') }}
)

SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    p.price,
    i.stock_quantity,
    CASE 
        WHEN i.stock_quantity >= 0 and i.stock_quantity <= 20 THEN 'Out of Stock'
        WHEN i.stock_quantity > 20 and i.stock_quantity < 100 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM source_product p
LEFT JOIN source_inventory i ON p.product_id = i.product_id