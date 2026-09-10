/* 

Top Customers — Past Year 

Goal: 

List the top 5 customers by total spending in the last 12 months. 

 

Tables: 

- customer(customer_id, first_name, last_name, ...) 

- orders(order_id, customer_id, order_date, order_status, ...) 

- order_line(order_id, product_id, quantity, price) 

 

Rules: 

- Spending = SUM(order_line.quantity * order_line.price) 

- Exclude CANCELLED orders 

- Window = rolling last 12 months from today 

*/ 

 
use bakery_db;
SELECT 

  c.customer_id, 

  CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 

  ROUND(SUM(ol.quantity * ol.price), 2)  AS total_spent 

FROM orders o 

JOIN customer c   ON c.customer_id = o.customer_id 

JOIN order_line ol ON ol.order_id   = o.order_id 

WHERE 

  o.order_status <> 'CANCELLED' 

  AND o.order_date >= (CURDATE() - INTERVAL 1 YEAR) 

GROUP BY 

  c.customer_id, c.first_name, c.last_name 

ORDER BY 

  total_spent DESC, customer_name 

LIMIT 5; 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 