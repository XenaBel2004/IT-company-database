
-- Представление выводящее, сколько тасок еще не выполнено по проекту, сколько сотрудников в них задействовано
-- и сколько денег было потрачено на бонусы за проект

CREATE VIEW company_views.project_financial_statistics AS
SELECT 
    p.project_name,
    p.project_description,
    COUNT(DISTINCT t.task_id) AS current_tasks,
    COUNT(DISTINCT a.achievement_id) AS total_achievements,
    COALESCE(SUM(a.bonus), 0) AS total_bonus_paid,
    COUNT(DISTINCT te.employee_id) AS employees_involved
FROM 
    company.projects p
LEFT JOIN company.tasks t ON p.project_name = t.project_name
LEFT JOIN company.tasks_X_employees te ON t.task_id = te.task_id
LEFT JOIN company.achievements a ON p.project_name = a.project_name
GROUP BY 
    p.project_name, p.project_description;


----------------------------------

---показывает сколько бонусов выплатили, сколько всего выплатили зп,
--средняя по бонусам, процент бонусов от зп и количество месяцев, когда были транзакции                                   
CREATE OR REPLACE VIEW company.employee_transaction_stats AS
SELECT
    employees.employee_id AS employee_id,
    employees.employee_name AS employee_name,
    SUM(CASE WHEN transaction.transaction_type = 'B' THEN transaction.transaction_amount ELSE 0 END) AS total_bonuses,
    SUM(CASE WHEN transaction.transaction_type = 'S' THEN transaction.transaction_amount ELSE 0 END) AS total_salaries,
    AVG(CASE WHEN transaction.transaction_type = 'B' THEN transaction.transaction_amount ELSE NULL END) AS avg_bonus,
    SUM(CASE WHEN transaction.transaction_type = 'B' THEN transaction.transaction_amount ELSE 0 END) * 100.0 / 
        NULLIF(SUM(transaction.transaction_amount), 0) AS bonus_percentage,
    COUNT(DISTINCT DATE_TRUNC('month', transaction.timestamp)) AS active_months
FROM
    company.employees
LEFT JOIN
    company.transaction
ON
    employees.employee_id = transaction.employee_id
GROUP BY
    employees.employee_id, employees.employee_name
ORDER BY
    bonus_percentage DESC NULLS LAST;

--------------------------------------

-- Выводит статистику по проектам за месяцы: сколько тасок было сделано,
-- разницу с предыдущим месяцем и сотрудника месяца по сделанным таскам

-- DROP VIEW company_views.projects_stats;
CREATE VIEW company_views.projects_stats as

with distinct_tasks AS (
    SELECT DISTINCT ON (task_id) 
        task_id, 
        project_name, 
        task_description, 
        employee_involved, 
        finishing_date
    FROM company.task_history
),
month_tasks as (
    select t.project_name, date_part('month', finishing_date) as m, count(t.task_id) as total_tasks
    FROM distinct_tasks as t join company.projects as p ON
    t.project_name = p.project_name
    GROUP BY (t.project_name, date_part('month', finishing_date))
    ORDER by m
),
employees_results as (
    select t.project_name, date_part('month', finishing_date) as m, employee_name, count(t.task_id) as total_tasks_emp
    FROM company.task_history as t join company.projects as p ON
    t.project_name = p.project_name
    join company.employees as e on e.employee_id = t.employee_involved
    GROUP BY (t.project_name, date_part('month', finishing_date), employee_name)
    ORDER BY m
),
ranked_employees as (
    select er.project_name, er.m, employee_name, ROW_NUMBER() over (PARTITION BY er.project_name, er.m order by total_tasks_emp DESC) as rank,
first_value(total_tasks_emp) over (PARTITION BY er.project_name, er.m order by total_tasks_emp DESC) as best_res from
employees_results as er
),
best_employees as (
    select project_name, m, employee_name, best_res
    from ranked_employees
    WHERE rank = 1
)
select mt.project_name, mt.m, total_tasks, (total_tasks - lag(total_tasks, 1, 0) over (PARTITION BY mt.project_name, mt.m)) as prev_month_task_diff,
be.employee_name, be.best_res
from month_tasks as mt join best_employees as be on mt.project_name = be.project_name and mt.m = be.m
ORDER BY project_name, m;

-- select * from company_views.projects_stats;
-- select * from company_views.project_financial_statistics;
--------------------------------------


