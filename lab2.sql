--ULiana Rozzhyvaikina
--132294190
--urozzhyvaikina@myseneca.ca
--Lab 2

--Q1
SELECT job_title, COUNT(employee_id)
FROM employees
GROUP BY job_title
ORDER BY COUNT(employee_id);

--Q2

SELECT MAX(credit_limit) AS "HIGH",
MIN(credit_limit)AS "LOW", 
ROUND(AVG(credit_limit),2) AS "AVERAGE",
MAX(credit_limit)-MIN(credit_limit) AS " High Low Difference"
FROM customers;

--Q3

SELECT order_id, SUM(quantity), SUM(quantity*unit_price) AS "Total_amount"
FROM order_items
HAVING SUM(quantity*unit_price) >1000000
GROUP BY order_id
ORDER BY SUM(quantity*unit_price) DESC;

--Q4

SELECT wh.warehouse_id, wh.warehouse_name ,tot.Total_Products
FROM warehouses wh
INNER JOIN (
SELECT warehouse_id,
SUM(quantity) AS Total_Products
FROM inventories
GROUP BY warehouse_id) tot
ON tot.warehouse_id=wh.warehouse_id
ORDER BY wh.warehouse_id;

--Q5
SELECT cus.customer_id, 
cus.name AS "customer name",
COUNT(ord.order_id) AS "total number OF orders"
FROM customers cus
LEFT OUTER JOIN orders ord 
ON cus.customer_id = ord.customer_id
WHERE cus.name LIKE 'O%e%'
OR cus.name LIKE '%t'
GROUP BY cus.customer_id, cus.name
ORDER BY COUNT(ord.order_id)DESC ;


--Q6

SELECT
pr.category_id,
SUM(ord.quantity * ord.unit_price) AS TOTAL_AMOUNT,
ROUND(AVG(ord.quantity * ord.unit_price), 2) AS AVERAGE_AMOUNT 
FROM order_items ord
INNER JOIN products pr ON pr.product_id = ord.product_id 
GROUP BY pr.category_id;
