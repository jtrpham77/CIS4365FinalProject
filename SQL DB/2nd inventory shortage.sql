use bakery_db;
SELECT 

  i.ingredient_name,                     -- Ingredient name 

  inv.quantity_on_hand  AS current_stock, -- Current amount available 

  inv.reorder_level     AS minimum_stock, -- Minimum required before reordering 

  i.base_unit           AS unit_of_measure -- g, ml, units, lbs, etc. 

FROM inventory AS inv 

JOIN ingredient AS i 

  ON i.ingredient_id = inv.ingredient_id 

WHERE inv.quantity_on_hand < inv.reorder_level   -- Below reorder point 

ORDER BY i.ingredient_name; 

 

 

 

 