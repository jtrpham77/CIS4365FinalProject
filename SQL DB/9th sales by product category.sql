/* 

Sales by Product Category — Last Quarter 

Schema: 

- order_line(order_id, product_id, quantity, price) 

- orders(order_id, order_date, order_status) 

- category(product_id, category_name)   -- category linked by product_id 

Notes: 

- Revenue per category = SUM(quantity * price) 

- Exclude CANCELLED orders 

- Last quarter window is dynamic 

*/ 
use bakery_db;
SELECT 

  COALESCE(c.category_name, 'Uncategorized') AS category_name, -- fallback if a product lacks a category row 

  ROUND(SUM(ol.quantity * ol.price), 2)     AS total_sales     -- revenue by category 

FROM order_line AS ol 

JOIN orders     AS o ON o.order_id    = ol.order_id 

LEFT JOIN category AS c ON c.product_id = ol.product_id        -- category via product_id 

WHERE 

  o.order_status <> 'CANCELLED' 

  AND o.order_date >= DATE_SUB(                                -- start_of_last_quarter 

        DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), 

                 INTERVAL MOD(MONTH(CURDATE())-1,3) MONTH), 

        INTERVAL 3 MONTH) 

  AND o.order_date <  DATE_SUB(                                -- start_of_this_quarter (exclusive) 

        DATE_FORMAT(CURDATE(), '%Y-%m-01'), 

        INTERVAL MOD(MONTH(CURDATE())-1,3) MONTH) 

GROUP BY COALESCE(c.category_name, 'Uncategorized') 

ORDER BY total_sales DESC, category_name; 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 