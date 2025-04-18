{{ config(
    tags = ["sales_silver"]
) }}

WITH source_order_detail AS (
    SELECT * FROM {{ ref('snap_order_details') }}
    WHERE dbt_valid_to IS NULL
),
source_product AS (
    SELECT * FROM {{ ref('snap_products') }}
    WHERE dbt_valid_to IS NULL
)

SELECT 
    od.order_id,
    od.product_id,
    p.product_name,
    od.quantity,
    od.unit_price,
    od.total_price,
    p.category,
    p.brand
FROM source_order_detail od
JOIN source_product p ON od.product_id = p.product_id