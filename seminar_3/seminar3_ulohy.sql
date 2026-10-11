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
--zadanie3
CREATE VIEW analyst_orders AS
SELECT order_id,
       customer_id,
       product_id,
       sales,
       quantity,
       discount
FROM orders ;
--zadanie4 
CREATE INDEX idx_orders_customer_id ON orders (customer_id);

SELECT *
FROM orders
WHERE customer_id = 'C001';
--zadanie5 



--zadanie6
CREATE INDEX idx_orders_region_category ON orders (customer_id, order_date);

SELECT o.*, c.customer_name, c.region
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE c.region = 'West'
  AND o.order_date >= '2024-01-01';

--zadanie7
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 'C001';

--zadanie11
DROP PROCEDURE IF EXISTS get_sales_between;

CREATE PROCEDURE get_sales_between(
    p_start_date DATE,
    p_end_date   DATE
)
LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_total NUMERIC(12,2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO v_total
    FROM orders
    WHERE order_date BETWEEN p_start_date AND p_end_date;

    RAISE NOTICE 'Obdobie od % do %: celkový predaj = %', p_start_date, p_end_date, v_total;
END;
$procedure$;

CALL get_sales_between('2024-01-01', '2024-03-31');