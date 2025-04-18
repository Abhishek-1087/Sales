{{ config(
    tags = ["sales_silver"]
) }}

WITH source_customer AS (
    SELECT * FROM {{ ref('snap_customers') }}
    WHERE dbt_valid_to IS NULL
),
source_order AS (
    SELECT * FROM {{ ref('snap_orders') }}
    WHERE dbt_valid_to IS NULL
),
source_order_detail AS (
    SELECT * FROM {{ ref('snap_order_details') }}
    WHERE dbt_valid_to IS NULL
),

-- Pre-aggregate order details to get total items per order
order_detail_agg AS (
    SELECT 
        order_id,
        COUNT(product_id) AS total_items
    FROM source_order_detail
    GROUP BY order_id
),

customer_orders AS (
    SELECT 
        c.customer_id,
        o.order_id,
        o.order_date,
        o.order_status,
        COALESCE(o.net_amount, null) AS net_amount
    FROM source_customer c
    LEFT JOIN source_order o ON c.customer_id = o.customer_id
),

final AS (
    SELECT 
        co.customer_id,
        co.order_id,
        co.order_date,
        co.order_status,
        COALESCE(od.total_items, null) AS total_items,
        co.net_amount,
        CASE 
            WHEN co.order_date IS NOT NULL THEN DATEDIFF(day, CAST(co.order_date AS DATE), CURRENT_DATE)
            ELSE NULL
        END AS order_age_days
    FROM customer_orders co
    LEFT JOIN order_detail_agg od ON co.order_id = od.order_id
)

SELECT 
distinct 
        customer_id,
        order_id,
        order_date,
        order_status,
        total_items,
        net_amount,
        order_age_days
FROM final
