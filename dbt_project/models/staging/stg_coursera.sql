with source as (
    select * from {{ ref('coursera_final_data') }}
),
transformed as (
    select
        course_id,
        "Course_Title" as title,
        "Language" as language,
        nullif(cast("Rating" as float), 0) as rating,
        cast("No. of Reviews" as integer) as review_count,
        strptime("Last_Update", '%m/%d/%Y') as last_updated,
        -- نضيف هذا السطر لتحديد الصف الأحدث في حال التكرار
        row_number() over (partition by course_id order by strptime("Last_Update", '%m/%d/%Y') desc) as rn
    from source
)
select * from transformed 
where rn = 1  -- نختار الصف رقم 1 فقط (الأحدث)