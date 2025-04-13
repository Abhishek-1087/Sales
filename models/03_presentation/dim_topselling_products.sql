{{ config(
    tags = ["sales_gold"]
) }}

WITH source_topselling_products AS (
    SELECT * FROM {{ ref('stg_topselling_products') }}
)

select 
    *
from source_topselling_products