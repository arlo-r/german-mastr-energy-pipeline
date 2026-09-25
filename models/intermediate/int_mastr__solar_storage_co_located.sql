with solar as (
    select
        location_mastr_id,
        solar_unit_mastr_id,
        net_capacity_kw as solar_capacity_kw,
        gross_capacity_kw as solar_gross_capacity_kw,
        commissioning_date as solar_commissioning_date,
        unit_status_code as solar_status_code,
        state_name,
        postal_code,
        city
    from {{ ref('stg_mastr__solar') }}
),

storage as (
    select
        location_mastr_id,
        storage_unit_mastr_id,
        net_capacity_kw as storage_capacity_kw,
        gross_capacity_kw as storage_gross_capacity_kw,
        battery_technology,
        commissioning_date as storage_commissioning_date,
        unit_status_code as storage_status_code,
        co_registered_solar_unit_id
    from {{ ref('stg_mastr__storage') }}
),

locations as (
    select
        location_mastr_id,
        technical_location_name,
        location_type_code,
        grid_connection_mastr_ids
    from {{ ref('stg_mastr__location') }}
),

co_located as (
    select
        -- Primary Location info
        s.location_mastr_id,
        s.state_name,
        s.postal_code,
        s.city,
        l.technical_location_name,
        l.grid_connection_mastr_ids,
        
        -- Solar Details
        s.solar_unit_mastr_id,
        s.solar_capacity_kw,
        s.solar_commissioning_date,
        
        -- Storage Details
        st.storage_unit_mastr_id,
        st.storage_capacity_kw,
        st.battery_technology,
        st.storage_commissioning_date,
        
        -- Analytical Flags
        case 
            when st.storage_commissioning_date >= s.solar_commissioning_date then 'Storage added on/after Solar'
            when st.storage_commissioning_date < s.solar_commissioning_date then 'Storage installed before Solar'
            else 'Unknown timeline'
        end as deployment_timeline_status

    from solar s
    inner join storage st
        on s.location_mastr_id = st.location_mastr_id
    left join locations l
        on s.location_mastr_id = l.location_mastr_id
)

select * from co_located