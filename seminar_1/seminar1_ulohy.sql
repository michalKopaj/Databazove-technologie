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
--uloha 7
SELECT c.region,SUM(o.sales) AS celkova_hodnota_predaja FROM customers c JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.region;
--uloha 8
SELECT c.customer_name,count(order_id) AS pocet_objednavok FROM customers c LEFT JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.customer_name;
--uloha 9 
SELECT p.category, AVG(o.discount) AS priemerna_zlava FROM products p JOIN orders o ON o.product_id = p.product_id GROUP BY p.category;
--uloha 10 
SELECT c.customer_name,SUM(o.sales) AS celkova_suma FROM customers c JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.customer_name  HAVING SUM(o.sales) >2000;
--uloha 11
SELECT c.region,SUM(o.sales) AS celkova_hodnota,AVG(o.discount) AS priemerna_zlava,COUNT(o.order_id) AS pocet_objednavok FROM orders o JOIN customers c ON o.customer_id = c.customer_id GROUP BY c.region; 
-- uloha 12
SELECT c.region,COUNT(CASE WHEN o.sales >1000 THEN 1 END) AS high_value ,COUNT(CASE WHEN o.sales <= 1000 THEN 1 END) AS low_value FROM customers c JOIN orders o ON o.customer_id = c.customer_id GROUP BY c.region;
-- uloha 13 
SELECT c.customer_name,SUM(o.sales) AS celkova_suma,AVG(o.discount) AS priemerna_zlava,COUNT(o.order_id) AS pocet_objednavok,CASE WHEN SUM(o.sales) > 2500 THEN 'VIP' ELSE 'REGULAR' END AS typ_zakaznika FROM customers c JOIN orders o ON c.customer_id = o.customer_id GROUP BY c.customer_name ORDER BY SUM(o.sales) DESC;