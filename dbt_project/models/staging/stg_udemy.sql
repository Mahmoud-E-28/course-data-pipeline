with source as (
    select * from {{ ref('udemy_final_data') }}
),
transformed as (
    select
        cast(course_id as varchar) as course_id,
        "Course_Title" as title,
        "Course_URL" as course_url,
        'Udemy' as platform,
        "Language" as language,
        "Description" as description,
        "Skills" as skills,
        "Level" as level,
        "Programming_Instructor" as instructor,
        "Domain_Name" as domain_name,
        cast("Last_Update" as date) as last_updated,
        "Duration" as duration,
        cast("No_of_Reviews" as integer) as review_count,
        cast("No_of_Students" as integer) as enrolled_students
    from source
    where try_cast(course_id as integer) is not null
)
select * from transformed