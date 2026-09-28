with fct_co_located as (
    select * from {{ ref('fct_mastr__solar_storage_co_located') }}
),

aggregated as (
    select
        coalesce(state_name, 'Unknown') as state_name,
        
        -- Site & Unit Counts
        count(distinct location_mastr_id) as total_co_located_sites,
        count(distinct solar_unit_mastr_id) as total_solar_units,
        count(distinct storage_unit_mastr_id) as total_storage_units,
        
        -- Capacity Metrics
        round(sum(solar_capacity_kw), 2) as total_solar_capacity_kw,
        round(sum(storage_capacity_kw), 2) as total_storage_capacity_kw,
        round(avg(storage_to_solar_ratio), 2) as avg_storage_to_solar_ratio,
        
        -- Timeline Breakdowns
        countif(deployment_timeline_status = 'Storage added on/after Solar') as storage_added_after_solar_count,
        countif(deployment_timeline_status = 'Storage installed before Solar') as storage_installed_before_solar_count

    from fct_co_located
    group by 1
)

select * 
from aggregated
order by total_co_located_sites desc