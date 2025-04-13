{{ config(
    tags = ["sales_gold"]
) }}

WITH source_payment_summery AS (
    SELECT * FROM {{ ref('stg_payment_summery') }}
)

select 
    *
from source_payment_summery