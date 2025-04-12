{{ config(
    tags = ["sales_silver"]
) }}

WITH source_order_detail AS (
    SELECT * FROM {{ ref('snap_order_details') }}
),
source_product AS (
    SELECT * FROM {{ ref('snap_products') }}
)

SELECT 
    od.product_id,
    p.product_name,
    p.category,
    SUM(od.quantity) AS units_sold,
    SUM(od.total_price) AS revenue_generated
FROM source_order_detail od
JOIN source_product p ON od.product_id = p.product_id
GROUP BY od.product_id, p.product_name, p.category