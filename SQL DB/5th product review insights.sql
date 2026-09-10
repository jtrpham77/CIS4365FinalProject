/* 

Product Review Insights (no rating table join) 

Assumption: review.rating_id represents the actual star value (e.g., 1–5). 

If rating_id is just a surrogate key (not the score), this method will not be accurate. 

*/ 

-- Step 1: Average rating per product using review.rating_id directly 
use bakery_db;
WITH product_ratings AS ( 

  SELECT 

    p.product_id,                                      -- Product ID 

    p.product_name,                                    -- Product name 

    ROUND(AVG(r.rating_id * 1.0), 2) AS avg_rating,    -- Average "rating_id" treated as numeric score 

    COUNT(r.review_id) AS review_count                 -- Number of reviews per product 

  FROM review AS r 

  JOIN product AS p 

    ON p.product_id = r.product_id 

  GROUP BY p.product_id, p.product_name 

) 

-- Step 2: Return top 3 and bottom 3 by average rating 

SELECT * 

FROM ( 

  -- Top 3 highest average ratings 

  SELECT product_name, avg_rating 

  FROM product_ratings 

  ORDER BY avg_rating DESC, product_name 

  LIMIT 3 

) AS top_products 

 

UNION ALL 

 

SELECT * 

FROM ( 

  -- Bottom 3 lowest average ratings 

  SELECT product_name, avg_rating 

  FROM product_ratings 

  ORDER BY avg_rating ASC, product_name 

  LIMIT 3 

) AS low_products; 

 

 

 

 

 

 

 

 

 