{{ config(
    tags = ["sales_gold"]
) }}

WITH source_top_selling_products AS (
    SELECT * FROM {{ ref('stg_topselling_products') }}
)

SELECT 
    category,
    SUM(units_sold) AS total_units_sold,
    SUM(revenue_generated) AS total_revenue,
    ROUND(AVG(revenue_generated), 2) AS avg_revenue_per_product
FROM source_top_selling_products
GROUP BY category