--Uliana Rozzhyvaikina
--132294190
--Lab 4

--Q1
SELECT city 
FROM locations MINUS
SELECT l.city 
FROM locations l, warehouses w 
WHERE l.location_id = w.location_id;


--Q2
SELECT pc.category_id, pc.category_name, COUNT(p.product_id)
FROM product_categories pc JOIN products p
ON pc.category_id = p.category_id
WHERE p.category_id = 5
GROUP BY pc.category_id, pc.category_name
UNION ALL 
SELECT pc.category_id, pc.category_name, COUNT(p.product_id)
FROM product_categories pc JOIN products p
ON pc.category_id = p.category_id
WHERE p.category_id = 1
GROUP BY pc.category_id, pc.category_name
UNION ALL 
SELECT pc.category_id, pc.category_name, COUNT(p.product_id)
FROM product_categories pc JOIN products p
ON pc.category_id = p.category_id
WHERE p.category_id = 2
GROUP BY pc.category_id, pc.category_name;

--Q3 using INTERSECT
SELECT product_id
FROM products
INTERSECT
SELECT product_id
FROM inventories
WHERE quantity <5;


--Q4

SELECT warehouse_name, state
FROM warehouses w
JOIN locations l
ON w.location_id = l.location_id
UNION
SELECT  warehouse_name, state
FROM warehouses w
RIGHT JOIN locations l
ON w.location_id = l.location_id;


