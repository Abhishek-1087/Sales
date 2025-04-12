{% snapshot snap_returns %}

    {{
        config(
            unique_key = "return_id",
            tags = ['snapshot'],
            updated_at='_fivetran_synced'
        )
    }}

    WITH source AS (
        SELECT 
            * 
        FROM {{ source('sales_data', 'returns') }} 
    )

    , valid AS (
        SELECT  
            *,
            row_number() OVER (PARTITION BY return_id
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
