--uloha2
SELECT customer_id,
	   invoice_no,
	   invoice_date,
	   quantity,
	   unit_price,
	   quantity * unit_price AS revenue,
	   SUM(quantity * unit_price) OVER(
			PARTITION BY customer_id
			ORDER BY invoice_date
			RANGE BETWEEN INTERVAL '14 days' PRECEDING AND CURRENT ROW
	
	   ) AS revenue_last_14_days
	   FROM retail_sales
	   WHERE customer_id IS NOT NULL 
	   ORDER BY customer_id,invoice_date;
--uloha3
SELECT avg_7_days
FROM (
SELECT stock_code,
	   country,
	   invoice_date,
	   quantity,
	   ROUND(AVG(quantity) OVER(
		PARTITION BY stock_code,country
		ORDER BY invoice_date
		RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW

	   ),2) AS avg_7_days 
	   FROM retail_sales
	   WHERE quantity >1) t
WHERE stock_code = '10002' AND country = 'EIRE'
ORDER BY invoice_date
LIMIT 1;
--uloha4
SELECT customer_id,
       invoice_no,
       invoice_date,
       LEAD(invoice_date) OVER (
           PARTITION BY customer_id
           ORDER BY invoice_date
       ) AS next_invoice_date,
       LEAD(invoice_date::DATE) OVER (
           PARTITION BY customer_id
           ORDER BY invoice_date
       ) - invoice_date::DATE AS days_to_next_invoice
FROM retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id, invoice_no, invoice_date
ORDER BY days_to_next_invoice DESC NULLS LAST;
--uloha5 
SELECT stock_code,
       invoice_no,
       invoice_date,
       previous_price,
       current_price,
       current_price - previous_price AS price_difference
FROM (
    SELECT stock_code,
           invoice_no,
           invoice_date,
           LAG(unit_price) OVER (
               PARTITION BY stock_code
               ORDER BY invoice_date
           ) AS previous_price,
           unit_price AS current_price
    FROM retail_sales
) AS t
WHERE previous_price IS NOT NULL
  AND current_price <> previous_price
ORDER BY invoice_date;
--uloha6
SELECT customer_id,
       SUM(quantity * unit_price) AS total_amount,
       NTILE(4) OVER(ORDER BY SUM(quantity * unit_price) DESC


       )AS sales_quartile
FROM retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_amount DESC;
--uloha7 
SELECT country,
       DATE_TRUNC('month', invoice_date)::DATE AS month,
       SUM(quantity * unit_price) AS total_amount,
       NTILE(4) OVER (
           PARTITION BY country
           ORDER BY SUM(quantity * unit_price) DESC
       ) AS sales_quartile
FROM retail_sales
GROUP BY country, DATE_TRUNC('month', invoice_date)
ORDER BY country, month;
--uloha8
SELECT customer_id,
       invoice_no,
       invoice_date,
       stock_code,
       description,
       quantity,
       unit_price
FROM (
    SELECT customer_id,
           invoice_no,
           invoice_date,
           stock_code,
           description,
           quantity,
           unit_price,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY invoice_date ASC
           ) AS rn
    FROM retail_sales
    WHERE customer_id IS NOT NULL
) AS t
WHERE rn = 1
ORDER BY customer_id ASC
LIMIT 5;
--uloha9
SELECT invoice_no,
       stock_code,
       description,
       quantity,
       unit_price,
       amount,
       row_num
FROM (
    SELECT invoice_no,
           stock_code,
           description,
           quantity,
           unit_price,
           quantity * unit_price AS amount,
           ROW_NUMBER() OVER (
               PARTITION BY invoice_no
               ORDER BY quantity * unit_price DESC
           ) AS row_num
    FROM retail_sales
) AS t
WHERE row_num <= 3
ORDER BY invoice_no, row_num;
--uloha10

SELECT country, month, customer_id, total_amount, sales_rank
FROM (
    SELECT country,
           DATE_TRUNC('month', invoice_date) AS month,
           customer_id,
           SUM(quantity * unit_price) AS total_amount,
           DENSE_RANK() OVER (
               PARTITION BY country, DATE_TRUNC('month', invoice_date)
               ORDER BY SUM(quantity * unit_price) DESC
           ) AS sales_rank
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY country, DATE_TRUNC('month', invoice_date), customer_id
) AS t
WHERE sales_rank <= 5
ORDER BY country, month, sales_rank, customer_id;
--uloha11
SELECT invoice_no,
       stock_code,
       description,
       quantity,
       unit_price,
       price_rank
FROM (
    SELECT invoice_no,
           stock_code,
           description,
           quantity,
           unit_price,
           DENSE_RANK() OVER (
               PARTITION BY invoice_no
               ORDER BY unit_price DESC
           ) AS price_rank
    FROM retail_sales
) AS t
WHERE price_rank <= 5
ORDER BY invoice_no, price_rank, stock_code;
