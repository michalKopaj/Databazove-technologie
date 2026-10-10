--zadanie1
DROP VIEW IF EXISTS high_value_customers;

CREATE VIEW high_value_customers AS
SELECT c.customer_id,
       c.customer_name,
       SUM(o.sales) AS total_sales
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.sales) > 2000;

SELECT *
FROM high_value_customers;

--zadanie2
CREATE VIEW regional_monthly_sales AS
SELECT c.region,
       DATE_TRUNC('month',o.order_date) AS  month,
       SUM(o.sales) AS monthly_sales
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
GROUP BY c.region,DATE_TRUNC('month',o.order_date);
