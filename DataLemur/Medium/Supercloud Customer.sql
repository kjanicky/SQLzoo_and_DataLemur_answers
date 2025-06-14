with subquery AS (SELECT customer_id,COUNT(DISTINCT  product_category) as number_of_products
FROM customer_contracts c INNER JOIN products p ON p.product_id = c.product_id
GROUP BY 1)
SELECT customer_id FROM subquery WHERE number_of_products = (SELECT COUNT(DISTINCT product_category) FROM products)