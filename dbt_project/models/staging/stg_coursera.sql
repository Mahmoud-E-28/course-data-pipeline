with source as (
    select * from {{ source('raw_data', 'coursera_courses2') }}
),
transformed as (
    select
        cast(course_id as varchar) as course_id,
        "Course_Title" as title,
        cast("Language" as varchar) as language,
        nullif(cast("Rating" as float), 0) as rating,
        cast("No. of Reviews " as integer) as review_count,
        strptime("Last_Update", '%m/%d/%Y') as last_updated
    from source
)
select * from transformed