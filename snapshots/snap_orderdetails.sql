{% snapshot snap_order_details %}

    {{
        config(
            unique_key = "order_detail_id",
            tags = ['snapshot'],
            updated_at='_fivetran_synced'
        )
    }}

    WITH source AS (
        SELECT 
            * 
        FROM {{ source('sales_data', 'order_details') }} 
    )

    , valid AS (
        SELECT  
            *,
            row_number() OVER (PARTITION BY order_detail_id
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
