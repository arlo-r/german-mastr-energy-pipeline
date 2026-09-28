with source as (
    select * from {{ source('mastr', 'EinheitenSolar') }}
),

renamed as (
    select
        -- Primary & Foreign Keys
        cast(EinheitMastrNummer as string)             as solar_unit_mastr_id,
        cast(LokationMaStRNummer as string)            as location_mastr_id,
        
        -- Capacities (kW) 
        safe_cast(Nettonennleistung as numeric)        as net_capacity_kw,
        safe_cast(Bruttoleistung as numeric)           as gross_capacity_kw,
        
        -- Status & Dates
        safe_cast(EinheitBetriebsstatus as integer)    as unit_status_code,
        safe_cast(Inbetriebnahmedatum as date)         as commissioning_date,
        
        -- Location Attributes
        {{ map_german_state('Bundesland') }}           as state_name,
        cast(Postleitzahl as string)                   as postal_code,
        cast(Ort as string)                            as city

    from source
)

select * 
from renamed
where net_capacity_kw is not null 
  and net_capacity_kw > 0
  and location_mastr_id is not null