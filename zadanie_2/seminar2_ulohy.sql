SELECT COUNT(*)
FROM flourmills_sales
WHERE total_amount > (SELECT AVG(total_amount) FROM flourmills_sales);
--uloha2

SELECT * FROM flourmills_sales
WHERE product_category=(SELECT product_category FROM flourmills_sales GROUP BY product_category ORDER BY total_amount LIMIT 1

);