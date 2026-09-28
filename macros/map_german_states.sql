{% macro map_german_state(column_name) %}
    case cast({{ column_name }} as string)
        when '1400' then 'Brandenburg'
        when '1401' then 'Berlin'
        when '1402' then 'Baden-Württemberg'
        when '1403' then 'Bayern'
        when '1404' then 'Bremen'
        when '1405' then 'Hessen'
        when '1406' then 'Hamburg'
        when '1407' then 'Mecklenburg-Vorpommern'
        when '1408' then 'Niedersachsen'
        when '1409' then 'Nordrhein-Westfalen'
        when '1410' then 'Rheinland-Pfalz'
        when '1411' then 'Schleswig-Holstein'
        when '1412' then 'Saarland'
        when '1413' then 'Sachsen'
        when '1414' then 'Sachsen-Anhalt'
        when '1415' then 'Thüringen'
        else 'Unknown'
    end
{% endmacro %}