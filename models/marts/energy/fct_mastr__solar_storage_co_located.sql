with co_located_base as (
    select * from {{ ref('int_mastr__solar_storage_co_located') }}
),

final as (
    select
        -- Primary Identifiers
        location_mastr_id,
        solar_unit_mastr_id,
        storage_unit_mastr_id,
        
        -- Geography & Location
        state_name,
        postal_code,
        city,
        technical_location_name,
        grid_connection_mastr_ids,
        
        -- Capacity Metrics (kW)
        solar_capacity_kw,
        storage_capacity_kw,
        
        -- Calculated Ratio: Storage to Solar Capacity Ratio
        round(safe_divide(storage_capacity_kw, solar_capacity_kw), 2) as storage_to_solar_ratio,
        
        -- Timeline & Dates
        solar_commissioning_date,
        storage_commissioning_date,
        deployment_timeline_status,
        
        -- Commissioning Year for Time-series Analysis
        extract(year from solar_commissioning_date) as solar_commissioning_year,
        extract(year from storage_commissioning_date) as storage_commissioning_year

    from co_located_base
)

select * from final