/* 

Promotion Effectiveness (compact) 

Compares units sold for each promoted product: 

  - Baseline = same-length window immediately BEFORE the promo 

  - During   = the promo window 

Outputs: product, promo, units_before, units_during, growth_rate 

*/ 
use bakery_db;
WITH pw AS ( 

  SELECT 

    pr.promotion_id, 

    pr.promotion_name, 

    pp.product_id, 

    pr.start_date, 

    pr.end_date, 

    -- same-length baseline window just before the promo 

    DATE_SUB(pr.start_date, INTERVAL (DATEDIFF(pr.end_date, pr.start_date) + 1) DAY) AS baseline_start 

  FROM promotion pr 

  JOIN product_promotion pp ON pp.promotion_id = pr.promotion_id 

) 

SELECT 

  x.product_name, 

  x.promotion_name, 

  x.units_before, 

  x.units_during, 

  ROUND((x.units_during - x.units_before) / NULLIF(x.units_before, 0), 4) AS growth_rate  -- e.g., 0.80 = +80% 

FROM ( 

  SELECT 

    p.product_name, 

    pr.promotion_name, 

 

    /* Units BEFORE promo (baseline window) */ 

    COALESCE(( 

      SELECT SUM(ol.quantity) 

      FROM order_line ol 

      JOIN orders o ON o.order_id = ol.order_id 

      WHERE ol.product_id = pw.product_id 

        AND o.order_status <> 'CANCELLED' 

        AND o.order_date >= pw.baseline_start 

        AND o.order_date <  pw.start_date 

    ), 0) AS units_before, 

 

    /* Units DURING promo (inclusive end) */ 

    COALESCE(( 

      SELECT SUM(ol.quantity) 

      FROM order_line ol 

      JOIN orders o ON o.order_id = ol.order_id 

      WHERE ol.product_id = pw.product_id 

        AND o.order_status <> 'CANCELLED' 

        AND o.order_date >= pw.start_date 

        AND o.order_date <  DATE_ADD(pw.end_date, INTERVAL 1 DAY) 

    ), 0) AS units_during 

 

  FROM pw 

  JOIN product   p ON p.product_id   = pw.product_id 

  JOIN promotion pr ON pr.promotion_id = pw.promotion_id 

) AS x 

ORDER BY growth_rate DESC, product_name; 

 

 

 

 

 