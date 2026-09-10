/* 

Best-Selling Products — Last Month (calendar) 

Goal: Top 5 products by quantity sold in the previous calendar month. 

Tables: 

- order_line(order_id, product_id, quantity, price) 

- orders(order_id, order_date, order_status) 

- product(product_id, product_name) 

Rules: 

- Sales volume = SUM(order_line.quantity) 

- Exclude CANCELLED orders 

- Window = last calendar month (e.g., if today is Nov 2025 → Oct 1–31, 2025) 

*/ 
use bakery_db;
SELECT 

  p.product_name,                          -- Product 

  SUM(ol.quantity) AS units_sold           -- Total units sold last month 

FROM order_line ol 

JOIN orders  o ON o.order_id   = ol.order_id 

JOIN product p ON p.product_id = ol.product_id 

WHERE 

  o.order_status <> 'CANCELLED' 

  AND o.order_date >= DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01')  -- start of last month 

  AND o.order_date <  DATE_FORMAT(CURDATE(), '%Y-%m-01')                      -- start of this month 

GROUP BY p.product_name 

ORDER BY units_sold DESC, p.product_name 

LIMIT 5; 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 