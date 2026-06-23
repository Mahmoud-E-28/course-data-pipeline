with source as (
    select * from {{ source('raw_data', 'udemy_courses2') }}
),
transformed as (
    select
        cast(course_id as integer) as course_id,
        cast("Course_Title" as varchar) as title,
        cast("Language" as varchar) as language,
        nullif(cast(replace(cast("Price" as varchar), 'E£', '') as float), 0) as price,
        cast("No_of_Reviews" as integer) as review_count,
    
        cast("No_of_Students" as integer) as student_count,
        cast("Last_Update" as date) as last_updated
    from source
)
select * from transformed