--средняя зарплата сотрудников в каждом отделе
set search_path=company;
SELECT 
    p.department_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM 
    employees e
JOIN 
    position p ON e.position_id = p.position_id
GROUP BY 
    p.department_name
ORDER BY 
    avg_salary DESC;


--отделы, в которых сотрудники получают зп >100к, и кол-во таких сотрудников в отделе
SELECT 
    p.department_name,
    COUNT(e.employee_id) AS high_salary_employees
FROM 
    employees e
JOIN 
    position p ON e.position_id = p.position_id
WHERE 
    e.salary > 100000
GROUP BY 
    p.department_name
HAVING 
    COUNT(e.employee_id) > 0;



--Вывести проекты, упорядоченные по кол-ву задач
SELECT 
    t.project_name, 
    COUNT(t.task_id) AS task_count
FROM tasks t
GROUP BY t.project_name
ORDER BY task_count DESC;

--Вывести среднюю зп сотрудников по проектам, при этом выбираем проекты, где сотрудники получают >80к
SELECT 
    p.project_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM 
    projects p
INNER JOIN 
    projects_X_employees pe ON p.project_name = pe.project_name
INNER JOIN 
    employees e ON pe.employee_id = e.employee_id
WHERE 
    e.salary > 80000
GROUP BY 
    p.project_name
HAVING 
    COUNT(e.employee_id) > 0
ORDER BY 
    avg_salary DESC;


--накопительная сумма бонусов за участие в проектах
SELECT 
    e.employee_name,
    a.project_name,
    a.achievement_date,
    a.bonus,
    SUM(a.bonus) OVER (PARTITION BY e.employee_id ORDER BY a.achievement_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_bonus
FROM 
    achievements a
INNER JOIN 
    employees e ON a.employee_id = e.employee_id
ORDER BY 
    e.employee_name, a.achievement_date;
