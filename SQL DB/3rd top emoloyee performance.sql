use bakery_db;
SELECT 

  DATE_FORMAT(CURDATE(), '%M %Y') AS report_month,   -- Displays the current month and year (e.g., "November 2025") 

  e.employee_id,                                     -- Unique employee ID 

  CONCAT(e.first_name, ' ', e.last_name) AS employee_name, -- Full employee name for readability 

  COUNT(DISTINCT oa.order_id) AS total_orders_processed    -- Number of unique orders the employee handled this month 

FROM order_assignment AS oa 

    -- Connect assigned orders to their actual order records 

JOIN orders AS o  

  ON o.order_id = oa.order_id 

    -- Connect each assignment to the employee who processed it 

JOIN employee AS e  

  ON e.employee_id = oa.employee_id 

WHERE 

    -- Start of current month (e.g., 2025-11-01) 

  oa.assigned_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') 

    -- First day of next month (not included), creating a proper month range 

  AND oa.assigned_date < DATE_FORMAT(CURDATE() + INTERVAL 1 MONTH, '%Y-%m-01') 

    -- Exclude cancelled orders from performance counting 

  AND o.order_status <> 'CANCELLED' 

GROUP BY 

  report_month,      -- Required because report_month is a selected expression 

  e.employee_id,     -- Group results by employee 

  e.first_name, 

  e.last_name 

ORDER BY 

  total_orders_processed DESC,  -- Rank employees by highest number of orders 

  employee_name;                -- Alphabetical tie-breaker 

 

 

 

 

 

 

 

 

 

 

 

 