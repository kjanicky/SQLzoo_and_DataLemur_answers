SELECT u.city,COUNT(city) AS total_orders
FROM trades t
INNER JOIN users u ON t.user_id = u.user_id
WHERE t.status = 'Completed'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;