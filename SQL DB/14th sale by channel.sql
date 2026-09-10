/* 

Sales by Channel — Current Month AND Last Month 

Outputs (per row): 

  period_label | channel_name | num_orders | revenue | pct_of_total_revenue | pct_of_total_orders 

 

Tables: 

- orders(order_id, order_date, order_status, sales_id, ...) 

- order_line(order_id, product_id, quantity, price) 

- sales_channel(sales_channel_id, channel_name) 

 

Rules: 

- Exclude CANCELLED orders 

- Revenue = SUM(order_line.quantity * order_line.price) 

- Show channels even with 0 orders / $0 revenue 

*/ 

 

WITH periods AS ( 

  -- Define the two windows we want to compare 

  SELECT 'Current Month' AS period_label, 

         DATE_FORMAT(CURDATE(), '%Y-%m-01')                        AS start_date, 

         DATE_FORMAT(CURDATE() + INTERVAL 1 MONTH, '%Y-%m-01')     AS end_date 

  UNION ALL 

  SELECT 'Last Month', 

         DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01'), 

         DATE_FORMAT(CURDATE(), '%Y-%m-01') 

), 

orders_ct AS ( 

  -- Count orders per channel per period (keep channels with zero orders) 

  SELECT 

    p.period_label, 

    sc.sales_channel_id, 

    sc.channel_name, 

    COUNT(DISTINCT o.order_id) AS num_orders 

  FROM periods p 

  CROSS JOIN sales_channel sc 

  LEFT JOIN orders o 

    ON o.sales_id      = sc.sales_channel_id 

   AND o.order_status <> 'CANCELLED' 

   AND o.order_date   >= p.start_date 

   AND o.order_date   <  p.end_date 

  GROUP BY p.period_label, sc.sales_channel_id, sc.channel_name 

), 

revenue_ct AS ( 

  -- Revenue per channel per period (only orders with lines) 

  SELECT 

    p.period_label, 

    o.sales_id AS sales_channel_id, 

    ROUND(SUM(ol.quantity * ol.price), 2) AS revenue 

  FROM periods p 

  JOIN orders o 

    ON o.order_status <> 'CANCELLED' 

   AND o.order_date   >= p.start_date 

   AND o.order_date   <  p.end_date 

  JOIN order_line ol ON ol.order_id = o.order_id 

  GROUP BY p.period_label, o.sales_id 

), 

totals_orders AS ( 

  SELECT period_label, SUM(num_orders) AS total_orders 

  FROM orders_ct 

  GROUP BY period_label 

), 

totals_revenue AS ( 

  SELECT period_label, SUM(revenue) AS total_revenue 

  FROM revenue_ct 

  GROUP BY period_label 

) 

SELECT 

  oc.period_label, 

  oc.channel_name, 

  oc.num_orders, 

  COALESCE(rc.revenue, 0.00) AS revenue, 

  CONCAT(ROUND(100 * COALESCE(rc.revenue, 0.00) / NULLIF(tr.total_revenue, 0), 2), '%') AS pct_of_total_revenue, 

  CONCAT(ROUND(100 * oc.num_orders / NULLIF(to2.total_orders, 0), 2), '%')              AS pct_of_total_orders 

FROM orders_ct oc 

LEFT JOIN revenue_ct rc 

  ON rc.period_label = oc.period_label 

 AND rc.sales_channel_id = oc.sales_channel_id 

LEFT JOIN totals_orders to2 

  ON to2.period_label = oc.period_label 

LEFT JOIN totals_revenue tr 

  ON tr.period_label = oc.period_label 

ORDER BY 

  oc.period_label, 

  revenue DESC, 

  oc.channel_name; 

 

 

 

 

 

 

 

 

 

 

 

 

 

 