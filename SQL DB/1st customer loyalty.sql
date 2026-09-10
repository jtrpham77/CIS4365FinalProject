/* 

Customer Loyalty Analysis 

Goal: List customers who made more than 5 purchases in the last 2 months 

      but are NOT enrolled in the loyalty program. 

*/ 

 
use bakery_db;
SELECT 

  c.customer_id,                                           -- Customer's unique ID 

  CONCAT(c.first_name, ' ', c.last_name) AS customer_name, -- Full name 

  c.email,                                                 -- Email address 

  c.phone,                                                 -- Phone number 

  COUNT(*) AS total_purchases                              -- Number of purchases made 

FROM orders AS o 

JOIN customer AS c 

  ON c.customer_id = o.customer_id                         -- Match each order to its customer 

WHERE o.order_status = 'COMPLETED'                         -- Only count completed orders 

  AND o.order_date >= CURDATE() - INTERVAL 2 MONTH         -- Restrict to last 2 months 

  AND NOT EXISTS (                                         -- Exclude customers already in loyalty program 

        SELECT 1 

        FROM loyalty_program lp 

        WHERE lp.customer_id = c.customer_id 

      ) 

GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.phone  -- Group by each customer 

HAVING COUNT(*) > 5                                       -- Keep only customers with >5 purchases 

ORDER BY total_purchases DESC, customer_name;             -- Show most active customers first 

 

 

 

 