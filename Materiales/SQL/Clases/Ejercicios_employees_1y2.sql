-- Primera Tanda
-- 1. Ranking de los trabajadores, según su sueldo máximo, con el título de su cargo.
SELECT * FROM employees;
SELECT * FROM salaries;
    
WITH maxSalarios AS (
    SELECT
        s.emp_no
        , MAX(s.salary) AS salario_maximo
    FROM
        salaries s
    GROUP BY
        s.emp_no
)
SELECT 
	CONCAT(e.first_name, " ",  e.last_name) nombre
    , t.title cargo
    , ms.salario_maximo salario_maximo_puede_o_no_actual
    , RANK() OVER (ORDER BY ms.salario_maximo DESC) ranking
FROM 
    employees e
INNER JOIN maxSalarios ms ON e.emp_no = ms.emp_no
INNER JOIN salaries s ON e.emp_no = s.emp_no
INNER JOIN titles t ON e.emp_no = t.emp_no
WHERE 
	s.salary = ms.salario_maximo AND t.to_date = "9999-01-01" -- ¿Solo los que siguen en la empresa?
ORDER BY 
    ranking;
    
-- 2. Sueldo máximo de cada trabajador, con el sueldo máximo de todos los sueldos de la empresa.
-- 3. Variación del sueldo de cada trabajador respecto a su sueldo anterior.
        -- Tasa de variación: (actual-anterior)/anterior * 100

-- Segunda Tanda
-- 1. Encuentra los empleados que fueron contratados después del año 2000.
SELECT 
	CONCAT(first_name, " " , last_name) empleado
    , hire_date fecha_contratacion
FROM 
    employees
WHERE 
    YEAR(hire_date) >= 2000;

-- 2. Calcula la edad de cada empleado en años.

SELECT 
    CONCAT(first_name, " " , last_name) empleado
    , ROUND(DATEDIFF(CURDATE(), birth_date) / 365, 0) edad
FROM 
    employees;

-- 3. Lista los empleados que llevan más de 10 años trabajando en la empresa.
SELECT 
    CONCAT(first_name, " " , last_name) empleado
    , hire_date fecha_contratacion
    , ROUND(DATEDIFF(CURDATE(), hire_date) / 365, 0) AS años_currados
FROM 
    employees
INNER JOIN salaries
	using(emp_no)
WHERE 
    DATEDIFF(CURDATE(), hire_date) >= 3650 AND to_date = "9999-01-01";

-- 4. Lista los nombres de empleados que trabajan en el departamento 'd001' (Marketing).
select * from departments;
select * from dept_emp;
select * from dept_manager;

SELECT 
    CONCAT(first_name, " " , last_name) empleado
    , dept_name departamento
    , ROUND(DATEDIFF(CURDATE(), hire_date) / 365, 0) AS años_currados
    -- , COUNT(dept_name) cambios_de_dep_o_sal
FROM 
    employees
INNER JOIN salaries
	using(emp_no)
INNER JOIN dept_emp
	using(emp_no)
INNER JOIN departments
	using(dept_no)
WHERE 
    departments.dept_no = "d001" AND dept_emp.to_date = "9999-01-01"
GROUP BY empleado, departamento, años_currados;


-- 5. Calcula el salario promedio de cada departamento.
SELECT 
    dept_name departamento
    , ROUND(AVG(salary),2) AS salario_medio
FROM 
    departments
INNER JOIN 
	dept_emp using(dept_no)
INNER JOIN 
	salaries using(emp_no)
WHERE 
    salaries.to_date = '9999-01-01' 
GROUP BY 
    dept_name;

-- 6. Encuentra el salario máximo y mínimo dentro de cada departamento.

SELECT 
    dept_name departamento
    , MAX(salary) AS salario_maximo
    , MIN(salary) AS salario_minimo
FROM 
    departments 
INNER JOIN 
	dept_emp using(dept_no)
INNER JOIN 
	salaries using(emp_no)
WHERE 
    salaries.to_date = '9999-01-01'
GROUP BY 
    dept_name;

-- 7. Lista los empleados con su salario actual y el salario promedio de su departamento.
WITH sueldo_medio_departamento AS (
    SELECT 
        dept_no num_dep
        , dept_name departamento
        , AVG(salary) AS sueldo_medio
    FROM 
        departments 
    INNER JOIN 
		dept_emp using(dept_no)
	INNER JOIN 
		salaries using(emp_no)
    WHERE 
        salaries.to_date = '9999-01-01'
    GROUP BY 
        num_dep
)
SELECT 
    CONCAT(first_name, " " , last_name) empleado
    , salary sueldo_actual
    , departamento
    , sueldo_medio
FROM 
    employees
INNER JOIN 
	dept_emp using(emp_no)
INNER JOIN 
	salaries using(emp_no)
INNER JOIN 
	sueldo_medio_departamento ON dept_emp.dept_no = sueldo_medio_departamento.num_dep
WHERE 
    salaries.to_date = '9999-01-01';

-- 8. Encuentra los empleados que tienen un salario superior al promedio de la empresa.
WITH salario_medio_total AS (
SELECT 
    emp_no num_emp
    , CONCAT(first_name, " " , last_name) empleado
    , salary salario
    , AVG(salary) OVER () AS salario_medio_tottal
FROM 
    employees
INNER JOIN 
	salaries using(emp_no)
WHERE 
    to_date = '9999-01-01'
)
SELECT *
FROM 
	salario_medio_total
WHERE 
	salario > salario_medio_tottal
;

-- 9. Encuentra los empleados más recientes contratados en cada departamento.
SELECT 
	CONCAT(first_name, " " , last_name) empleado
    , dept_name departamento
    , MIN(hire_date) fecha_contratacion
FROM 
    employees
INNER JOIN 
	dept_emp using(emp_no)
INNER JOIN 
	departments using(dept_no)
GROUP BY
	departamento;

-- 10. Ranking de departamentos basado en el número de empleados que cobran por debajo de la media de ese departamento.
-- 11.Departamento con los empleados mas antiguos
-- 12.Departamento con los empleados más jóvenes
-- 13.Lista los empleados que han estado al menos en 2 departamentos.