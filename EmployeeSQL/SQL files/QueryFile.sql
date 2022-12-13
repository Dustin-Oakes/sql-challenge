-- Create tables

CREATE TABLE if not exists titles (
	title_id CHAR(5) NOT NULL,
	title VARCHAR,
	PRIMARY KEY (title_id)
);

CREATE TABLE if not exists employees (
	emp_no INT NOT NULL,
	emp_title_id CHAR(5),
	birth_date DATE,
	first_name VARCHAR,
	last_name VARCHAR,
	sex CHAR(1),
	hire_date DATE,
	PRIMARY KEY (emp_no),
    FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)	
);

CREATE TABLE if not exists departments (
	dept_no CHAR(4) NOT NULL,
	dept_name VARCHAR,
	PRIMARY KEY (dept_no)	
);

CREATE TABLE if not exists salaries (
	emp_no INT NOT NULL,
	salary INT,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)	
);

CREATE TABLE if not exists dept_emp (
	emp_no INT NOT NULL,
	dept_no CHAR(4) NOT NULL,
	CONSTRAINT CompositeKey_dept_emp PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE if not exists dept_manager (
	dept_no CHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

/********************
After creating the tables, I imported the data from "..\data"
********************/

--List the employee number, last name, first name, sex, and salary of each employee
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees, salaries
WHERE employees.emp_no =salaries.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986
SELECT first_name, last_name, sex, hire_date
FROM employees
WHERE 1=1
	and hire_date >= '1986-01-01 00:00:00'
	and hire_date < '1987-01-01 00:00:00';

--List the manager of each department along with their department number, department name, 
--employee number, last name, and first name
SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager
JOIN employees ON employees.emp_no = dept_manager.emp_no 
JOIN departments ON departments.dept_no = dept_manager.dept_no
Where 1=1;

--List the department number for each employee along with that employee’s employee number, 
--last name, first name, and department name
SELECT dept_emp.dept_no, dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees ON employees.emp_no = dept_emp.emp_no 
JOIN departments ON departments.dept_no = dept_emp.dept_no
Where 1=1;

--List first name, last name, and sex of each employee whose first name is Hercules and 
--whose last name begins with the letter B
SELECT first_name, last_name, sex
FROM employees
WHERE 1=1
	and first_name = 'Hercules'
	and last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number, last name, 
--and first name
SELECT departments.dept_name, dept_emp.emp_no, employees.last_name, employees.first_name
FROM dept_emp
JOIN employees ON employees.emp_no = dept_emp.emp_no 
JOIN departments ON departments.dept_no = dept_emp.dept_no
Where 1=1
	and departments.dept_name ='Sales';

--List each employee in the Sales and Development departments, including their employee number, 
--last name, first name, and department name
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees ON employees.emp_no = dept_emp.emp_no 
JOIN departments ON departments.dept_no = dept_emp.dept_no
Where departments.dept_name ='Sales'
	or departments.dept_name ='Development';
	
--List the frequency counts, in descending order, of all the employee last names 
--(that is, how many employees share each last name)
SELECT last_name, count(employees.last_name)
FROM employees
GROUP BY employees.last_name
ORDER BY count(employees.last_name) desc