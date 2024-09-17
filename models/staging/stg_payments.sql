WITH source AS (
    SELECT 
        id, 
        order_id, 
        payment_method, 
        amount 
    FROM {{ ref('raw_payments') }}
),

renamed AS (
    SELECT
        id AS payment_id,
        order_id,
        payment_method,

        -- Convert `amount` from cents to dollars
        amount / 100 AS amount

    FROM source
)

SELECT * 
FROM renamed
