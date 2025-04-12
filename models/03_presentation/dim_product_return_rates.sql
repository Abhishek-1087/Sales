{{ config(
    tags = ["sales_gold"]
) }}

WITH source_returns_summary AS (
    SELECT * FROM {{ ref('stg_return_summery') }}
),
source_order_items_detailed AS (
    SELECT * FROM {{ ref('stg_orderitem_details') }}
),
source_product_catalog AS (
    SELECT * FROM {{ ref('stg_product_catelog') }}
)

SELECT 
    p.product_id,
    p.product_name,
    COUNT(r.return_id) AS return_count,
    SUM(od.quantity) AS sold_quantity,
    ROUND(COUNT(r.return_id)::DECIMAL / NULLIF(SUM(od.quantity), 0), 4) AS return_rate
FROM source_returns_summary r
JOIN source_order_items_detailed od ON r.product_id = od.product_id AND r.order_id = od.order_id
JOIN source_product_catalog p ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name