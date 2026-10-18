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
--uloha6
SELECT customer_id,
       SUM(quantity * unit_price) AS total_amount,
       NTILE(4) OVER(ORDER BY SUM(quantity * unit_price) DESC


       )AS sales_quartile
FROM retail_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_amount DESC;
