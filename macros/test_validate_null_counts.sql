{% macro test_validate_null_counts(model,table) %}

    {% set table_name = table|join(' ,')  %}

    {% set model_relation = ref(table_name) %}

    {% set database_name = model_relation.database %}
    {% set schema_name = model_relation.schema %}
    {% set model_name = model_relation.identifier %}

    {# Query to get the list of columns excluding certain ones #}
    {% set columns_query %}
        SELECT column_name
        FROM {{ database_name }}.information_schema.columns
        WHERE table_name = UPPER('{{ model_name }}')
        AND table_schema = UPPER('{{ schema_name }}')
        AND column_name NOT IN (SELECT UPPER(excluded_column) FROM {{ ref('excluded_columns') }} WHERE UPPER(table_name) = UPPER('{{ model_name }}'))
    {% endset %}

    {# Execute the query and store the result #}
    {% set columns_result = run_query(columns_query) %}

    {# Construct the SELECT query with null checks for each column #}
     
    WITH result as (
    {% for column in columns_result %}
    SELECT SUM(CASE WHEN {{ column[0] }} IS NULL THEN 1 ELSE 0 END) = 0 AS NULL_COUNT,'{{ column[0] }}' as NULL_COLUMN_NAME FROM {{ ref(model_name) }}
    {% if not loop.last %} UNION ALL {% endif %}
    {% endfor %}
    )
    
    select * 
    from result
    where NULL_COUNT = 'FALSE' 

{% endmacro %}
