with source as (
    select * from {{ source('mastr', 'EinheitenStromSpeicher') }}
),

renamed as (
    select
        -- Primary & Foreign Keys
        cast(EinheitMastrNummer as string)             as storage_unit_mastr_id,
        cast(LokationMaStRNummer as string)            as location_mastr_id,
        
        -- Capacities (kW)
        safe_cast(Nettonennleistung as numeric)        as net_capacity_kw,
        safe_cast(Bruttoleistung as numeric)           as gross_capacity_kw,
        
        -- Technology & Status
        cast(Batterietechnologie as string)            as battery_technology,
        safe_cast(EinheitBetriebsstatus as integer)    as unit_status_code,
        safe_cast(Inbetriebnahmedatum as date)         as commissioning_date,
        
        -- Location Attributes
        cast(Bundesland as string)                     as state_name,
        cast(Postleitzahl as string)                   as postal_code,
        cast(Ort as string)                            as city,
        
        -- Additional Attributes for Advanced Analysis
        cast(GemeinsamRegistrierteSolareinheitMastrNummer as string) as co_registered_solar_unit_id

    from source
)

select * 
from renamed
where net_capacity_kw is not null 
  and net_capacity_kw > 0
  and location_mastr_id is not null