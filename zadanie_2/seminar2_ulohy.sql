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
