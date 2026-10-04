SELECT COUNT(*)
FROM flourmills_sales
WHERE total_amount > (SELECT AVG(total_amount) FROM flourmills_sales);
--uloha2

SELECT * FROM flourmills_sales
WHERE product_category=(SELECT product_category FROM flourmills_sales GROUP BY product_category ORDER BY total_amount LIMIT 1

);
--ULOHA3
SELECT product_name,total_amount,(SELECT SUM(total_amount) FROM flourmills_sales) AS avg_amount  FROM flourmills_sales;
--uloha4
SELECT product_name,total_amount,total_amount / (SELECT SUM(total_amount)  FROM flourmills_sales) AS amount_share FROM flourmills_sales ORDER BY sales_id;

--uloha5
SELECT month,monthly_sales 
FROM (SELECT EXTRACT (MONTH FROM sale_date) AS month ,SUM(total_amount) AS monthly_sales FROM flourmills_sales GROUP BY EXTRACT(MONTH FROM sale_date)) AS monthly
ORDER BY monthly_sales DESC;
--uloha6
SELECT product_category,total_sales FROM (SELECT product_category,SUM(total_amount) AS total_sales FROM flourmills_sales GROUP BY product_category) AS category_sales WHERE total_sales >50000000 ORDER BY total_sales DESC;

--uloha7
SELECT t1.product_name,t1.product_category,t1.total_amount FROM  flourmills_sales AS t1 WHERE t1.total_amount > (
SELECT AVG(t2.total_amount) FROM flourmills_sales AS t2 WHERE t1.product_category=t2.product_category


);
--ULOHA8
SELECT s1.product_name,s1.region,s1.total_amount,( SELECT MIN(s2.total_amount)FROM flourmills_sales AS s2 WHERE s2.region = s1.region) AS region_min_amount FROM flourmills_sales AS s1 ORDER BY s1.sales_id;

--uloha9 
SELECT s1.*
FROM flourmills_sales AS s1
WHERE EXISTS (SELECT 1 FROM flourmills_sales AS s2 WHERE s2.product_name = s1.product_name GROUP BY s2.product_name HAVING COUNT(DISTINCT EXTRACT(MONTH FROM s2.sale_date)) > 1);