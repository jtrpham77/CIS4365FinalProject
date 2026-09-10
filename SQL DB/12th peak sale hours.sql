/* 

Peak Sales Hours — compute window via time join (handles overnight) 

*/ 
use bakery_db;
SELECT 

  s.shift_name, 

  CONCAT(DATE_FORMAT(s.start_time, '%H:%i'), '–', DATE_FORMAT(s.end_time, '%H:%i')) AS time_range, 

  COUNT(*) AS order_count 

FROM orders o 

JOIN shift s 

  ON s.day_of_week = DAYNAME(o.order_date) 

 AND ( 

       (s.end_time >  s.start_time AND o.order_time >= s.start_time AND o.order_time < s.end_time) 

    OR (s.end_time <= s.start_time AND (o.order_time >= s.start_time OR  o.order_time < s.end_time)) 

     ) 

WHERE o.order_status <> 'CANCELLED' 

  AND o.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') 

  AND o.order_date <  DATE_FORMAT(CURDATE() + INTERVAL 1 MONTH, '%Y-%m-01') 

GROUP BY s.shift_name, s.start_time, s.end_time 

ORDER BY order_count DESC, s.start_time; 

 

 

 

 