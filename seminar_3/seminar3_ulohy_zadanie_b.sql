--zadanie1
WITH daily_sales AS (
    SELECT sale_date,
           SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY sale_date
)
SELECT sale_date,
       total_sales
FROM daily_sales
WHERE total_sales > 3000000
ORDER BY total_sales DESC;
--zadanie2
WITH category_sales AS (
    SELECT product_category,
           SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
)
SELECT *
FROM category_sales
ORDER BY total_sales DESC;
--zadanie3
WITH product_sales AS (
    SELECT product_category,
           product_name,
           SUM(total_amount) AS total_product_sales
    FROM flourmills_sales
    GROUP BY product_category, product_name
),
ranked_products AS (
    SELECT product_category,
           product_name,
           total_product_sales,
           RANK() OVER (
               PARTITION BY product_category
               ORDER BY total_product_sales DESC
           ) AS category_rank
    FROM product_sales
)
SELECT *
FROM ranked_products
WHERE category_rank <= 3
ORDER BY product_category, category_rank;

--zadanie4
WITH type_revenue AS (
    SELECT customer_type,
           SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY customer_type
),
revenue_with_total AS (
    SELECT customer_type,
           revenue,
           SUM(revenue) OVER () AS total_revenue,
           ROUND(
               revenue * 100.0 / SUM(revenue) OVER (),
               2
           ) AS revenue_percentage
    FROM type_revenue
)
SELECT *
FROM revenue_with_total
ORDER BY revenue DESC;

--zadanie5
WITH ranked_transactions AS (
    SELECT customer_id,
           product_name,
           sale_date,
           total_amount,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY sale_date DESC
           ) AS rn
    FROM flourmills_sales
)
SELECT customer_id,
       product_name,
       sale_date,
       total_amount
FROM ranked_transactions
WHERE rn = 1
ORDER BY customer_id;

--zadanie6
WITH RECURSIVE date_range AS (
    SELECT MIN(sale_date) AS start_date,
           MAX(sale_date) AS end_date
    FROM flourmills_sales
),
calendar AS (
    SELECT start_date AS sale_date,
           end_date
    FROM date_range

    UNION ALL

    SELECT sale_date + INTERVAL '1 day',
           end_date
    FROM calendar
    WHERE sale_date < end_date
)
SELECT sale_date
FROM calendar
ORDER BY sale_date;

--zadanie7
WITH RECURSIVE monthly_revenue AS (
    SELECT DATE_TRUNC('month', sale_date) AS month,
           SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY 1
),
ordered_months AS (
    SELECT ROW_NUMBER() OVER (ORDER BY month) AS rn,
           month,
           revenue
    FROM monthly_revenue
),
cumulative_target AS (
    SELECT rn, month, revenue, revenue AS cumulative_revenue
    FROM ordered_months
    WHERE rn = 1

    UNION ALL

    SELECT om.rn,
           om.month,
           om.revenue,
           ct.cumulative_revenue + om.revenue
    FROM cumulative_target ct
    JOIN ordered_months om
        ON om.rn = ct.rn + 1
    WHERE ct.cumulative_revenue < 500000000
)
SELECT rn,
       month,
       revenue,
       cumulative_revenue
FROM cumulative_target
ORDER BY rn;
