{% snapshot snap_products %}

    {{
        config(
            unique_key = "product_id",
            tags = ['snapshot'],
            updated_at='_fivetran_synced'
        )
    }}

    WITH source AS (
        SELECT 
            * 
        FROM {{ source('sales_data', 'products') }} 
    )

    , valid AS (
        SELECT  
            *,
            row_number() OVER (PARTITION BY product_id
                ORDER BY _fivetran_synced DESC) AS rn
        FROM source
    )

    , deduped_data AS (
        SELECT 
            * exclude(rn)
        FROM valid
        WHERE rn = 1
    )

    SELECT 
        *
    FROM deduped_data

{% endsnapshot %}
