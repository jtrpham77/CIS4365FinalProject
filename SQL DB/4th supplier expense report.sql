/* 

Supplier Expense Report — Current and Last Quarter 

Goal: Show total expenses for each supplier during: 

  • The current quarter (for demonstration data) 

  • The previous quarter (as required by the assignment) 

Tables: 

- supplier_invoice(supplier_invoice_id, supplier_id, invoice_date, total_amount, ...) 

- supplier(supplier_id, supplier_name, ...) 

Notes: 

- Uses invoice_date to determine which quarter an expense falls in. 

- The date ranges automatically adjust based on the current date. 

- Includes suppliers only if they have expenses recorded. 

*/ 

 
use bakery_db;
SELECT 

  s.supplier_id,                                           -- Unique supplier ID 

  s.supplier_name,                                         -- Supplier name 

 

  /* Current quarter total 

     Example: If today is Nov 2025, this covers Oct–Dec 2025. */ 

  SUM( 

    CASE 

      WHEN si.invoice_date >= DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), 

                                       INTERVAL MOD(MONTH(CURDATE())-1,3) MONTH) 

       AND si.invoice_date < DATE_ADD(DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), 

                                               INTERVAL MOD(MONTH(CURDATE())-1,3) MONTH), 

                                      INTERVAL 3 MONTH) 

      THEN si.total_amount 

    END 

  ) AS current_quarter_total, 

  /* Last quarter total 

     Example: If today is Nov 2025, this covers Jul–Sep 2025. */ 

  SUM( 

    CASE 

      WHEN si.invoice_date >= DATE_SUB(DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), 

                                                INTERVAL MOD(MONTH(CURDATE())-1,3) MONTH), 

                                       INTERVAL 3 MONTH) 

       AND si.invoice_date < DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), 

                                      INTERVAL MOD(MONTH(CURDATE())-1,3) MONTH) 

      THEN si.total_amount 

    END 

  ) AS last_quarter_total 

FROM supplier_invoice AS si 

JOIN supplier AS s 

  ON s.supplier_id = si.supplier_id                       -- Match invoices to their suppliers 

GROUP BY 

  s.supplier_id, s.supplier_name 

 

ORDER BY 

  current_quarter_total DESC, s.supplier_name;             -- Rank by most spending this quarter 