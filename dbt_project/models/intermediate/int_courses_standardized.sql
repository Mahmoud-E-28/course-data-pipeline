{{ config(materialized='view') }}

WITH combined AS (
    SELECT * FROM {{ ref('int_courses_combined') }}
),

enriched AS (
    SELECT
        -- Identifiers & descriptive fields
        course_id,
        platform,
        title,
        course_url,
        description,
        skills,
        instructor,
        language,
        domain_name,
        
        -- Level standardization
        CASE
            WHEN LOWER(TRIM(level)) IN ('beginner', 'beginner level', 'introductory') THEN 'Beginner'
            WHEN LOWER(TRIM(level)) IN ('intermediate', 'intermediate level') THEN 'Intermediate'
            WHEN LOWER(TRIM(level)) IN ('advanced', 'expert', 'advanced level') THEN 'Advanced'
            WHEN LOWER(TRIM(level)) IN ('all levels', 'all', 'mixed') THEN 'All Levels'
            ELSE 'Unknown'
        END AS level,
        
        -- Numeric fields
        rating,
        review_count,
        enrolled_students,
        price,
        price_model,
        duration_hours,
        duration_raw,
        
        -- Price category logic
        CASE
            WHEN price IS NULL THEN 'Unknown'
            WHEN price = 0 THEN 'Free'
            WHEN price < 50 THEN 'Cheap'
            WHEN price < 200 THEN 'Medium'
            WHEN price < 500 THEN 'Expensive'
            ELSE 'Premium'
        END AS price_category,
        
        -- Duration category logic
        CASE
            WHEN duration_hours IS NULL THEN 'Unknown'
            WHEN duration_hours < 5 THEN 'Short'
            WHEN duration_hours < 20 THEN 'Medium'
            WHEN duration_hours < 50 THEN 'Long'
            ELSE 'Extensive'
        END AS duration_category,
        
        -- Popularity score (combines rating and normalized enrolled students)
        CASE
            WHEN rating IS NULL OR enrolled_students IS NULL THEN NULL
            ELSE ROUND(rating * LN(enrolled_students + 1), 2)
        END AS popularity_score,
        
        -- Engagement rate (reviews per enrolled student as percentage)
        CASE
            WHEN enrolled_students IS NULL OR enrolled_students = 0 THEN NULL
            WHEN review_count IS NULL THEN 0
            ELSE ROUND((CAST(review_count AS FLOAT) / enrolled_students) * 100, 2)
        END AS engagement_rate_pct,

        -- Offering type standardization
        CASE
             WHEN offering_type IS NULL THEN 'Unknown'
             WHEN LOWER(offering_type) LIKE '%nano%' THEN 'Nanodegree'
             WHEN LOWER(offering_type) LIKE '%special%' THEN 'Specialization'
             WHEN LOWER(offering_type) LIKE '%professional%' THEN 'Professional Certificate'
             ELSE 'Course'
        END AS offering_type,

        -- Timestamps
        last_updated
        
    FROM combined
)

SELECT * FROM enriched