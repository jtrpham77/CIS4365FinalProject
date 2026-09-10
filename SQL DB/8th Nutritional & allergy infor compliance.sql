/* 

Nutritional & Allergy Information Compliance 

Goal: 

Find products missing either nutritional info or allergy info. 

Tables: 

- product(product_id, product_name, allergy_id) 

- nutritionalinfo(product_id, nutri_calories, nutri_sugar_grams, nutri_fat_grams, nutri_protein_grams, nutri_carbs_grams) 

Rules: 

- Missing Allergy  → allergy_id IS NULL 

- Missing Nutrition → no record in nutritionalinfo OR any key nutrition field is NULL 

Output: 

Product name | Type of missing information 

*/ 

 
use bakery_db;
SELECT 

  p.product_name,                                              -- Product name 

  TRIM(BOTH ', ' FROM CONCAT( 

    CASE WHEN n.product_id IS NULL 

       OR n.nutri_calories IS NULL 

       OR n.nutri_sugar_grams IS NULL 

       OR n.nutri_fat_grams IS NULL 

       OR n.nutri_protein_grams IS NULL 

       OR n.nutri_carbs_grams IS NULL THEN 'Nutrition' ELSE '' END, 

    CASE WHEN (n.product_id IS NULL 

       OR n.nutri_calories IS NULL 

       OR n.nutri_sugar_grams IS NULL 

       OR n.nutri_fat_grams IS NULL 

       OR n.nutri_protein_grams IS NULL 

       OR n.nutri_carbs_grams IS NULL) 

       AND p.allergy_id IS NULL THEN ', ' ELSE '' END, 

    CASE WHEN p.allergy_id IS NULL THEN 'Allergy' ELSE '' END 

  )) AS missing_information                                   -- Type of missing data 

FROM product p 

LEFT JOIN nutritionalinfo n ON n.product_id = p.product_id 

WHERE 

  p.allergy_id IS NULL                                        -- No allergy record 

  OR n.product_id IS NULL                                     -- No nutrition record 

  OR n.nutri_calories IS NULL                                 -- Incomplete nutrition data 

  OR n.nutri_sugar_grams IS NULL 

  OR n.nutri_fat_grams IS NULL 

  OR n.nutri_protein_grams IS NULL 

  OR n.nutri_carbs_grams IS NULL 

ORDER BY p.product_name; 

 

 

 