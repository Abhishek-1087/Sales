{% snapshot snap_orders %}

    {{
        config(
            unique_key = "order_id",
            tags = ['snapshot'],
            updated_at='_fivetran_synced'
        )
    }}

    WITH source AS (
        SELECT 
            * 
        FROM {{ source('sales_data', 'orders') }} 
    )

    , valid AS (
        SELECT  
            *,
            row_number() OVER (PARTITION BY order_id
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
