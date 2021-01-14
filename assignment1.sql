-- ***********************
-- Student1 Name: Nisrein Hinnawi Student1 ID: 130223183
-- Student2 Name: Uliana Rozzhyvaikina Student2 ID: 132294190
-- Student3 Name: Vishisht Akhileshkumar Gupta Student3 ID: 147208193
-- Date: 2020-11-03
-- Purpose: Assignment 1 - DBS311
-- ***********************

-- Question 1 – Display the employee number, full employee name, job title, 
--and hire date of all employees hired in September with the most 
--recently hired employees displayed first. 

-- Q1 SOLUTION --
select employee_id as "Employee Number", 
concat(CONCAT(last_name, ', '), first_name) as "Full Name",
job_title as "Job Title", 
TO_CHAR( hire_date, 'FMMonth ddth "of" YYYY' ) as "Start Date" 
from employees
where EXTRACT(month FROM hire_date) = 9
order by hire_date desc;


-- Question 2 - Display the salesman ID and the total sale amount for each employee. 
--Sort the result according to employee number.

-- Q2 SOLUTION --
select "Emplyee Number", TO_CHAR(sum(total), '$999,999,999.00') as "Total Sale" from (
select nvl(orders.salesman_id, 0) as "Emplyee Number", 
(order_items.unit_price * order_items.quantity ) as total
from orders, order_items
where orders.order_id = order_items.order_id) tmp
group by "Emplyee Number"
order by "Emplyee Number";


-- Question 3 - Display customer Id, customer name and total number of orders for customers 
--that the value of their customer ID is in values from 35 to 45. 
--Include the customers with no orders in your report if their customer ID falls in the range 35 and 45.  
--Sort the result by the value of total orders. 

-- Q3 SOLUTION --
select customers.customer_id as "Customer Id", 
customers.name as "Name", 
count(orders.order_id) as "Total Orders"
from customers
left join orders on customers.customer_id = orders.customer_id
where customers.customer_id between 35 and 45
group by customers.customer_id, customers.name
order by "Total Orders";


-- Question 4 - Display customer ID, customer name, and the order ID and the order date of all orders 
--for customer whose ID is 44.
--a.Show also the total quantity and the total amount of each customer’s order.
--b.Sort the result from the highest to lowest total order amount.

-- Q4 SOLUTION --
select customers.customer_id as "Customer Id", 
customers.name as "Name", 
tmp.order_id as "Order Id", 
tmp.order_date as "Order Date", 
tmp.quantity as "Total Items", 
tmp.total as "Total Amount"
from (
select orders.customer_id, orders.order_id, orders.order_date, 
sum(order_items.quantity) as quantity, 
to_char(sum(order_items.quantity * order_items.unit_price), '$999,999,999.00') as total
from orders, order_items
where orders.order_id = order_items.order_id and orders.customer_id = 44
group by orders.customer_id, orders.order_id, orders.order_date) tmp, customers
where tmp.customer_id = customers.customer_id
order by total desc;


-- Question 5 -5.	Display customer Id, name, total number of orders, the total number of items ordered, 
--and the total order amount for customers who have more than 30 orders. 
--Sort the result based on the total number of orders.

-- Q5 SOLUTION --
select customers.customer_id as "Customer Id",
customers.name as "Name",
tmp.total_orders as "Total Number of Orders",
tmp.total_items as"Total Items",
tmp.total_amount as "Total Amount"
from customers,
(select orders.customer_id, 
count(order_items.item_id) as total_orders,
sum(order_items.quantity) as total_items, 
to_char(sum(order_items.quantity * unit_price), '$999,999,999.00') as total_amount
from orders, order_items
where orders.order_id = order_items.order_id
group by orders.customer_id
having count(order_items.item_id) >30) tmp
where customers.customer_id = tmp.customer_id
order by "Total Number of Orders";



-- Question 6 - Display Warehouse Id, warehouse name, product category Id, product category name,
--and the lowest product standard cost for this combination.
--•In your result, include the rows that the lowest standard cost is less than $200.
--•Also, include the rows that the lowest cost is more than $500.
--•Sort the output according to Warehouse Id, warehouse name and then product category Id, 
--and product category name.

-- Q6 SOLUTION -- 
select tmp.warehouse_id as "Warehouse ID", 
warehouses.warehouse_name as "Warehouse Name",
tmp.category_id as "Category ID",
categories.category_name as "Category Name",
tmp.lowest_cost as "Lowest Cost"
from categories, warehouses,
(
select products.category_id, 
inventories.warehouse_id, 
to_char(min(standard_cost), '$999,999,999.00') as lowest_cost
from products, inventories
where products.product_id = inventories.product_id
group by products.category_id,inventories.warehouse_id
having min(standard_cost)<200 or min(standard_cost)>500) tmp
where tmp.warehouse_id = warehouses.warehouse_id
and tmp.category_id = categories.category_id
order by "Warehouse ID", "Warehouse Name", "Category ID", "Category Name";


--Question 7 
--Display the total number of orders per month. Sort the result from January to December.

SELECT to_char(to_date(the_month, 'MM'), 'Month') AS "MONTH", counts AS "number OF orders" 
FROM (SELECT EXTRACT(MONTH 
FROM order_date) 
AS the_month, COUNT(*) AS counts 
FROM orders 
GROUP BY
EXTRACT(MONTH 
FROM order_date) )
sales 
ORDER BY the_month;

--8. Display product Id, product name for products that their list price is more than any highest product standard cost per warehouse outside Americas regions.
--(You need to find the highest standard cost for each warehouse that is located outside the Americas regions.
--Then you need to return all products that their list price is higher than any highest standard cost of those warehouses.) Sort the result according to list price from highest value to the lowest.

SELECT product_id AS "Product ID", product_name AS "Product name", to_char(list_price, '$999,999.99') AS "Price"
FROM products 
WHERE list_price > ANY (SELECT MAX(standard_cost) FROM locations
                        JOIN countries  ON locations.country_id = countries.country_id
                        JOIN regions  ON regions.region_id = countries.region_id
                        JOIN warehouses  ON warehouses.location_id = locations.location_id 
                        JOIN inventories  ON inventories.warehouse_id = warehouses.warehouse_id 
                        JOIN products  ON products.product_id = inventories.product_id
                        WHERE region_name NOT LIKE 'Americas' GROUP BY warehouses.warehouse_id)
ORDER BY list_price DESC; 

--9. Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price.

SELECT product_id,product_name,list_price 
FROM products 
WHERE list_price = 
        ( SELECT
         MAX(list_price) 
         FROM
         products )
UNION
SELECT product_id,product_name,list_price 
FROM products 
WHERE list_price = 
        ( SELECT
         MIN(list_price) 
         FROM
         products );
         
--10. Write a SQL query to display the number of customers with total order amount over the average amount of all orders, the number of customers with total order amount under the average amount of all orders, number of customers with no orders, and the total number of customers. See the format of the following result.
SELECT
   'Number of customers with total purchase amount over average: ' || COUNT(*) AS "Customer Report" 
FROM (SELECT customers.customer_id,SUM(quantity*unit_price) AS total 
      FROM customers 
      INNER JOIN orders 
      ON customers.customer_id = orders.customer_id 
      INNER JOIN order_items 
      ON order_items.order_id = orders.order_id 
      GROUP BY customers.customer_id )
WHERE total > 
            ( SELECT AVG(quantity*unit_price) 
              FROM order_items) 
UNION ALL
   SELECT
      'Number of customers with total purchase amount below average: ' || COUNT(*) 
FROM (SELECT customers.customer_id,SUM(quantity*unit_price) AS total 
      FROM customers 
      INNER JOIN orders 
      ON customers.customer_id = orders.customer_id 
      INNER JOIN order_items 
      ON order_items.order_id = orders.order_id 
      GROUP BY customers.customer_id )
WHERE total < 
             (SELECT AVG(quantity*unit_price) 
             FROM order_items) 
UNION ALL
SELECT 'Number of customers with no orders: ' || COUNT(*) 
FROM ( SELECT customer_id 
        FROM customers 
        minus 
        SELECT customer_id 
        FROM orders )
UNION ALL
      SELECT 'Total number of customers: ' || COUNT(*) 
      FROM( SELECT customer_id 
            FROM customers 
            UNION
            SELECT customer_id 
            FROM orders );   

