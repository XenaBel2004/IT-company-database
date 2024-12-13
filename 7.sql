DROP SCHEMA IF EXISTS company_views cascade;
CREATE SCHEMA company_views;
SET search_path = company_views;


--projects

CREATE VIEW company_views.project_view AS
SELECT 
    project_name,
    LEFT(project_description, 15) || '...' AS masked_description
FROM company.projects;

SELECT * FROM company_views.project_view;

--tasks

CREATE VIEW company_views.tasks_view AS
SELECT
    project_name,
    task_description
FROM company.tasks;

SELECT * FROM company_views.tasks_view;


--task_history

CREATE VIEW company_views.task_history_view AS
SELECT
    project_name,
    finishing_date
FROM company.task_history;

SELECT * FROM company_views.task_history_view;


--departments

CREATE VIEW company_views.departments_view AS
SELECT
    department_name,
    num_employees
FROM company.departments;

SELECT * FROM company_views.departments_view;

--position

CREATE VIEW company_views.position_view AS
SELECT 
    department_name,
    position_name
FROM company.position;

SELECT * FROM company_views.position_view;

--employees

create VIEW company_views.employees_view AS
with split_names as (
    SELECT regexp_replace(employee_name,'\s\S+','') as first_name,
    regexp_replace(employee_name,'.+[\s]','') as last_name, hiring_date,
    CASE 
    WHEN salary > 100000 THEN 'High Salary'
    ELSE 'Low Salary'
    END AS salary_range
    from company.employees
)
SELECT Last_Name || ' ' || LEFT(First_Name, 1) || '.', hiring_date, salary_range from split_names;

select * from company_views.employees_view;

--achievements

create VIEW company_views.achievements_view AS 
select project_name, achievement_description, achievement_date, '***' as bonus from company.achievements;

--transaction

create view company_views.transaction_view AS
select timestamp, '***' as transaction_amount, LEFT(bank_account, 4)||'*******'||RIGHT(bank_account,4) from company.transaction;
select * from company_views.transaction_view;