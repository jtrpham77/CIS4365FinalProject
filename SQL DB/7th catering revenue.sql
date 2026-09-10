/* 

Catering Revenue — Current Quarter by Event Type 

Outputs: event_type | num_orders | total_revenue 

Joins: orders(catering_id) → catering(event_id) → event(event_type) 

Counts only non-cancelled orders in the current calendar quarter. 

Uses orders.total_amount (your generated column). 

*/ 
use bakery_db;
SELECT 

  e.event_type,                                        -- Wedding / Birthday / Corporate … 

  COUNT(DISTINCT o.order_id) AS num_orders,            -- # of catering orders 

  ROUND(SUM(o.total_amount), 2) AS total_revenue       -- revenue (from generated total_amount) 

FROM orders   o 

JOIN catering c ON c.catering_id = o.catering_id 

JOIN event    e ON e.event_id     = c.event_id 

WHERE o.order_status <> 'CANCELLED' 

  AND o.order_date >= DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), 

                               INTERVAL MOD(MONTH(CURDATE())-1,3) MONTH)      -- start of this quarter 

  AND o.order_date <  DATE_ADD( 

        DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), 

                 INTERVAL MOD(MONTH(CURDATE())-1,3) MONTH), 

        INTERVAL 3 MONTH)                                                      -- end (exclusive) 

GROUP BY e.event_type 

ORDER BY total_revenue DESC, e.event_type; 