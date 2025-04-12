{{ config(
    tags = ["sales_gold"]
) }}

WITH source_payment_summary AS (
    SELECT * FROM {{ ref('stg_payment_summery') }}
)

SELECT 
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status = 'Successful' THEN 1 ELSE 0 END) AS successful_payments,
    ROUND(SUM(CASE WHEN status = 'Successful' THEN 1 ELSE 0 END)::DECIMAL / COUNT(*), 4) AS success_rate
FROM source_payment_summary
GROUP BY payment_method
