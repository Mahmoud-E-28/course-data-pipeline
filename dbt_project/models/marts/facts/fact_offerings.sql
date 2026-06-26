{{ config(materialized='table') }}

with source_data as (
    select * from {{ ref('int_courses_standardized') }}),

final as (

    select

        dof.offering_sk,
        dp.platform_id,
        dd.domain_id,
        dl.level_id,
        dlang.language_id,

        coalesce(di.instructor_id,-1) as instructor_id,
        coalesce(dot.offering_type_id,-1) as offering_type_id,
        coalesce(dt.date_id,-1) as date_id,

        s.price,
        s.rating,
        s.review_count,
        s.enrolled_students,
        s.duration_hours,
        s.popularity_score,
        s.engagement_rate_pct

    from source_data s

    left join {{ ref('dim_platform') }} dp
        on s.platform = dp.platform_name

    left join {{ ref('dim_domain') }} dd
        on s.domain_name = dd.domain_name

    left join {{ ref('dim_level') }} dl
        on s.level = dl.level_name

    left join {{ ref('dim_language') }} dlang
        on s.language = dlang.language_name

    left join {{ ref('dim_instructor') }} di
        on coalesce(s.instructor,'Unknown Instructor')
        = di.instructor_name

    left join {{ ref('dim_offering_type') }} dot
        on coalesce(s.offering_type,'Unknown')
        = dot.offering_type
    left join {{ ref('dim_date') }} dt
        on cast(strftime(s.last_updated,'%Y%m%d') as integer) = dt.date_id

    left join {{ ref('dim_offering') }} dof
        on s.course_id = dof.offering_id
        and dof.is_current = true)

select * from final