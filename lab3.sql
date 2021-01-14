--Uliana Rozzhyvaikina
--132294190
--Lab 3 

--q1

SELECT last_name, to_char(hire_date, 'dd-fmMon-yy') AS "HIRE_DATE" 
FROM employees 
WHERE hire_date >= TO_CHAR('2016-04-01')
AND hire_date < 
(SELECT hire_date 
FROM employees 
WHERE employee_id = 107) 
ORDER BY
TO_DATE(hire_date, 'dd-mm-yyyy') , employee_id ;
   
   
--q2
SELECT name, credit_limit
FROM customers
WHERE credit_limit= 
(SELECT MIN(credit_limit)
FROM customers)
ORDER BY customer_id;
   
--q3
   
SELECT b.category_id, a.product_id, a.product_name, a.list_price 
FROM product_categories b, products a 
WHERE b.category_id = a.category_id  AND a.list_price = 
(SELECT MAX(a.list_price) 
FROM products a 
WHERE b.category_id = a.category_id)
ORDER BY a.category_id;

--q4

SELECT category_id, category_name
FROM product_categories
WHERE category_id IN
(SELECT category_id
FROM products 
WHERE list_price IN
(SELECT MAX(list_price)
FROM products));

--q5 
SELECT product_name,list_price 
FROM products 
WHERE category_id = 1 
AND list_price < ANY
(SELECT MIN(list_price) 
FROM products 
GROUP BY category_id) 
ORDER BY  list_price DESC, product_name;

--q6

SELECT MAX(list_price) 
FROM products 
WHERE category_id IN   
(SELECT category_id 
FROM products 
WHERE list_price IN
(SELECT MIN(list_price) 
FROM products));