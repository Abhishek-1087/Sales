{{ config(
    tags = ["sales_gold"]
) }}

WITH source_daily_sales AS (
    SELECT * FROM {{ ref('stg_daily_sales') }}
)

SELECT 
    date,
    total_orders,
    total_sales,
    total_tax,
    total_discount,
    net_revenue,
    LAG(net_revenue) OVER (ORDER BY date) AS previous_day_revenue,
    (net_revenue - LAG(net_revenue) OVER (ORDER BY date)) AS revenue_change
FROM source_daily_sales