{% macro get_model_database_schema(model_name) %}
    {% set model_ref = ref(model_name) %}
    {% set model_database = target.database %}
    {% set model_schema = target.schema %}
    
    -- Return the database and schema as a dictionary
    {{ return({'database': model_database, 'schema': model_schema}) }}
{% endmacro %}
