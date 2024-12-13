set search_path=company;
--position
INSERT into employees (employee_name, position_id, hiring_date, salary) VALUES
                    ('Zaikova Olga', 9, CURRENT_DATE, 100000);

--зп не меньше 100к
SELECT employee_name, salary
FROM employees
WHERE salary >= 100000;

--projects
INSERT INTO projects (project_name, project_description) VALUES 
                    ('Project FoodDeliveryApp', 'Приложение для доставки еды');
--выводим приложения
SELECT project_name, project_description
FROM projects 
WHERE project_name LIKE '%App%';


set search_path=company;

--увеличиваем зарплату, если сотрудник работает больше 10 лет
UPDATE employees
SET salary = salary + 5000
WHERE hiring_date <= (CURRENT_DATE - INTERVAL '10 years');

--обновление описания проекта
UPDATE projects
SET project_description = 'Создание бота-агента для общения с клиентами'
WHERE project_name = 'Project Agent';

--удаление определенного проекта
DELETE FROM projects
WHERE project_name = 'Project Agent';

--удаление определенного проекта
DELETE FROM position
WHERE position_name = 'Дизайнер';