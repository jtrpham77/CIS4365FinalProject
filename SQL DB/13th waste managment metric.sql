use bakery_db;
SELECT 

  i.ingredient_name,                                -- Ingredient name 

  SUM(w.waste_quantity) AS total_waste_quantity,    -- Total wasted quantity 

  i.base_unit AS unit_of_measure,                   -- Unit (g, ml, unit) 

  MAX(w.waste_reason) AS common_reason              -- Example reason for waste 

FROM wastelog AS w 

JOIN ingredient AS i 

  ON i.ingredient_id = w.ingredient_id 

WHERE 

  w.waste_date >= CURDATE() - INTERVAL 1 YEAR       -- Only past year 

GROUP BY 

  i.ingredient_id, i.ingredient_name, i.base_unit 

ORDER BY 

  total_waste_quantity DESC, i.ingredient_name 

LIMIT 5;   -- Only return top 5 

 

 

 

 

 