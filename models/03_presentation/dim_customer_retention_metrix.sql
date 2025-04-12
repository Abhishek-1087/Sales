{{ config(
    tags = ["sales_gold"]
) }}

WITH source_customer_activity_log AS (
    SELECT * FROM {{ ref('stg_customeractivity_log') }}
)

SELECT 
    customer_id,
    COUNT(*) AS total_visits,
    MIN(event_date) AS first_activity,
    MAX(event_date) AS last_activity,
    DATEDIFF(day, CAST(MAX(event_date) AS DATE), CAST(MIN(event_date) AS DATE)) AS retention_days
FROM source_customer_activity_log
GROUP BY customer_id