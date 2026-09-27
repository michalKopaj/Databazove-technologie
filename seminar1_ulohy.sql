--uloha 2
SELECT o.order_id,c.customer_name,o.sales FROM orders o JOIN customers c ON o.customer_id = c.customer_id WHERE o.sales > 500 ORDER BY o.sales DESC;
--uloha 3
SELECT o.order_id,c.customer_name,p.category,o.sales FROM orders o JOIN products p ON p.product_id =o.product_id  JOIN customers c ON c.customer_id = o.customer_id;
--uloha 4 
SELECT c.region,SUM(o.sales) as celkova_hodnota_predaja FROM customers c LEFT JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.region;
--uloha 5 
SELECT p.product_name,SUM(o.sales) AS celkova_hodnota_predaja FROM products p LEFT JOIN orders o ON p.product_id = o.product_id GROUP BY p.product_name;
--uloha 6 
SELECT c.customer_name,o.order_id,o.sales FROM customers c FULL JOIN orders o ON o.customer_id = c.customer_id;