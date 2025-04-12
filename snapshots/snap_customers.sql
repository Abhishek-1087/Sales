{% snapshot snap_customers %}

    {{
        config(
            unique_key = "customer_id",
            tags = ['snapshot'],
            updated_at='_fivetran_synced'
        )
    }}

    WITH source AS (
        SELECT 
            * 
        FROM {{ source('sales_data', 'customers') }} 
    )

    , valid AS (
        SELECT  
            *,
            row_number() OVER (PARTITION BY customer_id
                ORDER BY _fivetran_synced DESC) AS rn
        FROM source
    )

    , deduped_data AS (
        SELECT 
            * exclude(rn),
            TO_DATE(signup_date, 'DD-MM-YYYY') AS signup_date_converted
        FROM valid
        WHERE rn = 1
    )

    SELECT 
        _line,
        _fivetran_synced,
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        address,
        city,
        country,
        signup_date_converted AS signup_date  
    FROM deduped_data

{% endsnapshot %}
