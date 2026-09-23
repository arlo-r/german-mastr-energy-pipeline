with source as (
    select * from {{ source('mastr', 'Lokationen') }} 
),

renamed as (
    select
        -- Primary Key
        cast(MastrNummer as string)                        as location_mastr_id,
        
        -- Location Attributes
        cast(NameDerTechnischenLokation as string)        as technical_location_name,
        safe_cast(Lokationtyp as integer)                  as location_type_code,
        
        -- Linked Assets & Grid Points
        cast(VerknuepfteEinheitenMaStRNummern as string)   as linked_units_mastr_ids,
        cast(NetzanschlusspunkteMaStRNummern as string)    as grid_connection_mastr_ids,
        
        -- Metadata & Timestamps
        safe_cast(DatumLetzteAktualisierung as timestamp)  as last_updated_at

    from source
)

select * 
from renamed
where location_mastr_id is not null