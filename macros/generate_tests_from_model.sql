{% macro generate_tests_from_model(table_name) %}
    {% set model_relation = ref(table_name) %}
    {% set database_name = model_relation.database %}
    {% set schema_name = model_relation.schema %}

    {% set columns_query %}
        SELECT LOWER(column_name)
        FROM {{ database_name }}.information_schema.columns
        WHERE table_name = UPPER('{{ table_name }}')
        AND table_schema = UPPER('{{ schema_name }}')
        AND column_name NOT IN (
            SELECT UPPER(excluded_column) 
            FROM {{ ref('excluded_columns') }} 
            WHERE UPPER(table_name) = UPPER('{{ table_name }}')
        )
    {% endset %}

    {% set columns_result = run_query(columns_query) %}
    columns:
    {% for column in columns_result %}
    - name: {{ column[0] | trim }}
      tests:
        - not_null
        {% endfor %}
{% endmacro %}    
