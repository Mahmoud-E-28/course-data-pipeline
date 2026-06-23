with source as (
    select * from {{ ref('udacity_final_data') }}
),
transformed as (
    select
        cast(course_id as varchar) as course_id,
        "Course_Title" as title,
        "Course_URL" as course_url,
        'Udacity' as platform,
        cast("Language" as varchar) as language,
        cast("Description" as varchar) as description,
        cast("Skill" as varchar) as skills,
        cast("Level" as varchar) as level,
        cast("Programming Instructor" as varchar) as instructor,
        null as domain_name,
        try_cast("Last Update" as date) as last_updated,
        cast("Duration_Hours" as varchar) as duration, 
        cast("Review_Count" as float) as review_count,
        cast("enrolled_students" as integer) as enrolled_students
    from source
)
select * from transformed