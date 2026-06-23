with source as (
    select * from {{ ref('coursera_final_data') }}
),
transformed as (
    select
        cast(course_id as varchar) as course_id,
        "Course_Title" as title,
        "Course_URL" as course_url,
        'Coursera' as platform,
        "Language" as language,
        "Description" as description,
        "Skill" as skills,
        "Level" as level,
        "Instructor" as instructor,
        null as domain_name,
        strptime("Last_Update", '%m/%d/%Y') as last_updated,
        "Duration" as duration, 
        cast("No. of Reviews" as integer) as review_count,
        null as enrolled_students,
        row_number() over (partition by course_id order by strptime("Last_Update", '%m/%d/%Y') desc) as rn
    from source
)
select * from transformed where rn = 1