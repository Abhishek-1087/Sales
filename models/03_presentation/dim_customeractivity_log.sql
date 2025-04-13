{{ config(
    tags = ["sales_gold"]
) }}

WITH source_customeractivity_log AS (
    SELECT * FROM {{ ref('stg_customeractivity_log') }}
)

select 
    *
from source_customeractivity_log