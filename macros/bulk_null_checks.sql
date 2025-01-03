{% macro bulk_null_checks(table_name) %}

    {% set model_relation = ref(table_name) %}

    {% set database_name = model_relation.database %}
    {% set schema_name = model_relation.schema %}

    {# Query to get the list of columns excluding certain ones #}
    {% set columns_query %}
        SELECT column_name
        FROM {{ database_name }}.information_schema.columns
        WHERE table_name = UPPER('{{ table_name }}')
        AND table_schema = UPPER('{{ schema_name }}')
        AND column_name NOT IN (SELECT UPPER(excluded_column) FROM {{ ref('excluded_columns') }} WHERE UPPER(table_name) = UPPER('{{ table_name }}'))
    {% endset %}

    {# Execute the query and store the result #}
    {% set columns_result = run_query(columns_query) %}

    {# Construct the SELECT query with null checks for each column #}
    SELECT 
        {% for column in columns_result %}
        SUM(CASE WHEN {{ column[0] }} IS NULL THEN 1 ELSE 0 END) AS {{ column[0] }}_null_count
        {% if not loop.last %},{% endif %}
        {% endfor %}
    FROM {{ ref(table_name) }}

{% endmacro %}
