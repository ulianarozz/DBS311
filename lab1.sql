-- *********************** 
-- Name: Uliana Rozzhyvaikina
-- ID: 132294190
-- Date: 2020/09/27 
-- Purpose: Lab 1 DBS311 
-- ***********************

--Q1
SELECT to_char(sysdate+1, 'mon dd" of year "yyyy')as Tomorrow from dual; 


--Q2
SELECT product_id, product_name, list_price, ceil(list_price*1.02) AS "New Price",
ceil(list_price*1.02) - list_price AS "Price Difference" FROM products
WHERE category_id=2 OR category_id=3 OR category_id=5 ORDER BY category_id, product_id;


--Q3

SELECT last_name ||', '||first_name ||' is ' || job_title AS "Employee Info" 
FROM employees WHERE manager_id= 2 ORDER BY employee_id;

--Q4
SELECT last_name AS "Last Name",TO_CHAR(hire_date, ' yy mon dd') AS "Hire Date",
FLOOR((sysdate- hire_date)/365) AS "Years Worked"
FROM employees WHERE hire_date < TO_DATE('2016-10-01','yyyy mm dd')
ORDER BY hire_date, employee_id;


--Q5
SELECT last_name AS "Last Name", hire_date AS "Hire Date",
TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date,12),'Tuesday'),'fmDAY, Month " the " Ddspth" of " YYYY') AS "Review Day" FROM employees
WHERE hire_date > to_date('2016-01-01')
ORDER BY to_date(hire_date);


--Q6

SELECT w.warehouse_id AS "Warehouse ID", w.warehouse_name AS "Warehouse Name", l.city AS "City", l.state AS "State" FROM  warehouses w
INNER JOIN locations l ON l.location_id = w.location_id ORDER BY w.warehouse_id;