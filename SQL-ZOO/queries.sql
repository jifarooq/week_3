/* 
-----USING SUBQUERIES AS TABLES-----
SELECT 
	a.account_id, a.cust_id, a.open_date, a.product_cd
FROM account a INNER JOIN
	(SELECT emp_id, assigned_branch_id
	FROM employee
	WHERE start_date < '2007-01-01'
		AND (title = 'Teller' OR title = 'Head Teller')) e
ON a.open_emp_id = e.emp_id
INNER JOIN
	(SELECT branch_id
		FROM branch
		WHERE name = 'Woburn Branch') b
	ON e.assigned_branch_id = b.branch_id;

-----SELF JOIN-----
SELECT 
	e.fname, e.lname, e_mgr.fname AS mgr_fname, e_mgr.lname AS mgr_lname
FROM
	employee e INNER JOIN employee e_mgr
ON
	e.superior_emp_id = e_mgr.emp_id;

-----NON-EQUI-JOINS WITH A RANGE OF VALUES-----
SELECT e.emp_id, e.fname, e.lname, e.start_date
FROM employee e INNER JOIN product p
	ON e.start_date >= p.date_offered
	AND e.start_date <= p.date_retired
WHERE p.name = 'no-fee checking';


SELECT e1.fname, e1.lname, 'VS' vs, e2.fname, e2.lname
FROM employee e1 INNER JOIN employee e2
	ON e1.emp_id < e2.emp_id
WHERE e1.title = 'Teller' AND e2.title = 'Teller';

-----EXERCISE 5-2-----
SELECT a.account_id, c.cust_type_cd, c.fed_id, p.name AS product
FROM customer c INNER JOIN account a
	ON a.cust_id = c.cust_id
	INNER JOIN product p
	ON p.product_cd = a.product_cd
WHERE 
	cust_type_cd = 'I';
*/

/* -----EXERCISE 5-3----- */
SELECT e.emp_id, e.fname, e.lname
FROM employee e INNER JOIN employee mgr
ON e.superior_emp_id = mgr.emp_id
WHERE e.dept_id <> mgr.dept_id;



