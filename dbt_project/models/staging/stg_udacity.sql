with source as (
    select * from {{ ref('udacity_final_data') }}
),

transformed as (
    select
        cast("course_id" as varchar) as course_id,
        cast("Course_Title" as varchar) as title,
        cast("Language" as varchar) as language,
        cast("Review_Count" as float) as rating,
       
        try_cast("Last Update" as date) as last_updated
    from source
)

select * from transformed