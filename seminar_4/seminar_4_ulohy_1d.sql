--uloha1
SELECT customer_name, order_id, order_date
FROM (
    SELECT c.customer_name, o.order_id, o.order_date,
           ROW_NUMBER() OVER (
               PARTITION BY c.customer_id
               ORDER BY o.order_date DESC, o.order_id DESC
           ) AS rn
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
) t
WHERE rn <= 2
ORDER BY customer_name, rn;
--uloha2
WITH customer_profit AS (
    SELECT c.region, c.customer_id, c.customer_name,
           SUM(o.profit) AS total_profit
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.region, c.customer_id, c.customer_name
)
SELECT region, customer_name, total_profit,
       RANK()       OVER (PARTITION BY region ORDER BY total_profit DESC) AS rank_profit,
       DENSE_RANK() OVER (PARTITION BY region ORDER BY total_profit DESC) AS dense_rank_profit
FROM customer_profit
ORDER BY region, rank_profit;
--uloha3
WITH customer_sales AS (
    SELECT c.customer_id, c.customer_name, SUM(o.sales) AS total_sales
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_name, total_sales,
       NTILE(4) OVER (ORDER BY total_sales DESC) AS quartile
FROM customer_sales
ORDER BY total_sales DESC;
--uloha4
WITH monthly AS (
    SELECT DATE_TRUNC('month', order_date)::date AS month,
           SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY 1
)
SELECT month, monthly_sales,
       LAG(monthly_sales, 1)  OVER (ORDER BY month) AS prev_month_sales,
       LEAD(monthly_sales, 1) OVER (ORDER BY month) AS next_month_sales
FROM monthly
ORDER BY month;
--uloha5
WITH product_sales AS (
    SELECT p.category, p.product_name, SUM(o.sales) AS product_sales
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.category, p.product_name
)
SELECT category,
       product_name,
       product_sales,
       SUM(product_sales) OVER (PARTITION BY category) AS category_total,
       ROUND(
           product_sales * 100.0 / SUM(product_sales) OVER (PARTITION BY category),
           2
       ) AS pct_of_category
FROM product_sales
ORDER BY category, pct_of_category DESC;
--uloha6
WITH x AS (
    SELECT c.customer_id, c.customer_name,
           MAX(o.order_date) OVER (PARTITION BY c.customer_id) AS last_order_date,
           MAX(o.order_date) OVER ()                           AS latest_order_date
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
)
SELECT DISTINCT customer_id, customer_name, last_order_date
FROM x
WHERE last_order_date < latest_order_date - INTERVAL '90 days'
ORDER BY last_order_date;
--uloha7
WITH monthly AS (
    SELECT DATE_TRUNC('month', order_date)::date AS month,
           SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY 1
),
lagged AS (
    SELECT month, monthly_sales,
           LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales
    FROM monthly
)
SELECT month, monthly_sales, prev_month_sales,
       monthly_sales - prev_month_sales AS sales_change,
       ROUND(((monthly_sales - prev_month_sales) / prev_month_sales * 100)::numeric, 2) AS growth_percentage
FROM lagged
ORDER BY month;
--uloha8
WITH first_purchase AS (
    SELECT customer_id,
           DATE_TRUNC('month', MIN(order_date))::date AS first_month
    FROM orders
    GROUP BY customer_id
)
SELECT COUNT(*) AS returned_customers
FROM first_purchase f
WHERE f.first_month = DATE '2024-06-01'
  AND EXISTS (
      SELECT 1
      FROM orders o
      WHERE o.customer_id = f.customer_id
        AND DATE_TRUNC('month', o.order_date) > f.first_month
  );

