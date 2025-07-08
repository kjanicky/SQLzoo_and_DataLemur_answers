WITH subquery AS (
SELECT e1.name as manager_name,e1.salary AS manager_salary,e2.name as employee_name,
e2.salary AS employee_salary,e2.employee_id AS employee_id
FROM employee e1
INNER JOIN employee e2 ON e1.employee_id = e2.manager_id
WHERE e2.salary > e1.salary
)
SELECT employee_id,employee_name FROM subquery