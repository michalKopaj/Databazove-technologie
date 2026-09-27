--uloha 2
SELECT o.order_id,c.customer_name,o.sales FROM orders o JOIN customers c ON o.customer_id = c.customer_id WHERE o.sales > 500 ORDER BY o.sales DESC;
--uloha 3
SELECT o.order_id,c.customer_name,p.category,o.sales FROM orders o JOIN products p ON p.product_id =o.product_id  JOIN customers c ON c.customer_id = o.customer_id;
--uloha 4 
SELECT c.region,SUM(o.sales) as celkova_hodnota_predaja FROM customers c LEFT JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.region;