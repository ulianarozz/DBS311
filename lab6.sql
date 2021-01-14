--Uliana Rozzhyvaikina
--132294190
--Lab6

SET SERVEROUTPUT ON;

-- Q1

CREATE OR replace PROCEDURE Findfactorial(n IN INT) 
IS 
factorialvalue INT := 1; 
i INT := 0; 
BEGIN 
LOOP 
factorialvalue := ( factorialvalue * ( n - i ) ); 
i := i + 1; 
EXIT WHEN i = n; 
END LOOP; 
dbms_output.Put_line(factorialvalue); 
EXCEPTION 
WHEN OTHERS THEN 
dbms_output.Put_line('error!'); 
END; 

BEGIN 
Findfactorial(5); 
END; 


-- Q2

CREATE OR replace PROCEDURE Calculate_salary(employee_id IN NUMBER) 
IS 
  salary    NUMBER := 10000; 
  yearcount NUMBER; 
  firstname VARCHAR(20); 
  lastname  VARCHAR(20); 
  i         INT := 0; 
BEGIN 
    SELECT Trunc(To_char(SYSDATE - employees.hire_date) / 365) 
    INTO   yearcount 
    FROM   employees 
    WHERE  employees.employee_id = Calculate_salary.employee_id; 

    SELECT employees.first_name 
    INTO   firstname 
    FROM   employees 
    WHERE  employees.employee_id = Calculate_salary.employee_id; 

    SELECT employees.last_name 
    INTO   lastname 
    FROM   employees 
    WHERE  employees.employee_id = Calculate_salary.employee_id; 

LOOP 
salary := salary * 1.05; 
i := i + 1; 
EXIT WHEN i = yearcount; 
END LOOP; 
 dbms_output.Put_line('First Name: '  ||firstname); 
 dbms_output.Put_line('Last Name: '   ||lastname); 
 dbms_output.Put_line('Salary: '      ||salary); 
EXCEPTION 
  WHEN no_data_found THEN dbms_output.Put_line('No Data Found'); 
END;

BEGIN 
Calculate_salary(0); 
END; 
-- Q3

CREATE PROCEDURE warehouse_report IS l_wid warehouses.warehouse_id % TYPE;
l_wn warehouses.warehouse_name % TYPE;
l_city locations.city % TYPE;
l_state locations.state % TYPE;
BEGIN
FOR i IN 1..9 loop 
SELECT
      w.warehouse_id,
      w.warehouse_name,
      l.city,
      nvl(l.state, 'no state') INTO l_wid,
      l_wn,
      l_city,
      l_state 
FROM warehouses w 
INNER JOIN locations l 
ON (w.location_id = l.location_id) 
WHERE w.warehouse_id = i;
dbms_output.put_line('Warehouse ID: ' || l_wid);
dbms_output.put_line('Warehouse name: ' || l_wn);
dbms_output.put_line('City: ' || l_city);
dbms_output.put_line('State: ' || l_state);
dbms_output.put_line('');
END
loop;
exception 
WHEN others 
THEN dbms_output.put_line('Error Occured');
END;
BEGIN warehouse_report();
END;