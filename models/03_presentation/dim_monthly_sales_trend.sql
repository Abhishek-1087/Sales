{{ config(
    tags = ["sales_gold"]
) }}

WITH source_monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', date) AS month,  
        SUM(total_orders) AS total_orders,
        SUM(total_sales) AS total_sales,
        SUM(total_tax) AS total_tax,
        SUM(total_discount) AS total_discount,
        SUM(net_revenue) AS net_revenue
    FROM {{ ref('stg_daily_sales') }}
    GROUP BY DATE_TRUNC('month', date)
)

SELECT 
    month,
    total_orders,
    total_sales,
    total_tax,
    total_discount,
    net_revenue,
    LAG(net_revenue) OVER (ORDER BY month) AS previous_month_revenue,
    (net_revenue - LAG(net_revenue) OVER (ORDER BY month)) AS revenue_change
FROM source_monthly_sales
