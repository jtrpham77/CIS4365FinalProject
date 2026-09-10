/* 

Holiday Bestsellers — holiday season window (±7 days) 

Edit window_days to widen/narrow the season. 

*/ 

SET @window_days := 7; 

 

SELECT 

  h.holiday_name, 

  p.product_name, 

  SUM(ol.quantity) AS units_sold 

FROM holiday h 

JOIN product_holiday ph ON ph.holiday_id = h.holiday_id 

JOIN product p          ON p.product_id  = ph.product_id 

JOIN order_line ol      ON ol.product_id = p.product_id 

JOIN orders o           ON o.order_id    = ol.order_id 

WHERE o.order_status <> 'CANCELLED' 

  AND o.order_date BETWEEN (h.holiday_date - INTERVAL @window_days DAY) 

                      AND (h.holiday_date + INTERVAL @window_days DAY) 

GROUP BY h.holiday_name, p.product_name 

ORDER BY h.holiday_name, units_sold DESC, p.product_name; 