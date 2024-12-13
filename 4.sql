INSERT INTO company.projects (project_name, project_description)
VALUES 
    ('Project RecSys', 'Разработка рекомендательной системы'), -- ML
    ('Project OnlineShop', 'Создание онлайн магазина'), -- Backend
    ('Project Redesign', 'Разработка нового визуального стиля компании'), -- Design
    ('Project MobileApp', 'Мобильное приложение'), -- Mobile
    ('Project DB', 'Проектирование базы данных'), -- Engineering 
    ('Project Agent', 'Создание агента'); -- ML


alter table company.departments drop constraint department_director;

INSERT INTO company.departments (department_name, director_id, description, num_employees) VALUES
('Engineering', 1, 'Отдел занимается распределенными системами и базами данных', 2),
('ML', 2, 'Отдел занимается внедрением ML решений в production', 3),
('Backend', 3, NULL, 2),
('Mobile', 4, NULL, 1),
('Design', 5, NULL, 2);


INSERT into company.position (department_name, position_name) VALUES
                            ('Engineering', 'Директор'),
                            ('Engineering', 'Senior-разработчик'),
                            ('ML', 'Директор'),
                            ('ML', 'ML Researcher'),
                            ('ML', 'ML Junior dev'),
                            ('Backend', 'Директор'),
                            ('Backend', 'Backend dev'),
                            ('Mobile', 'Директор и единственный разработчик'),
                            ('Design', 'Директор'),
                            ('Design', 'Дизайнер');

INSERT INTO company.employees (employee_name, position_id, hiring_date, salary) VALUES 
        ('Nam Alina', 1, '2020-01-15', 140000), 
        ('Belkova Ksenia', 2, '2021-03-22', 80000),
        ('Saprygin Igor', 3, '2005-03-23', 120000),
        ('Novitsky Grigoriy',4, '2019-03-22', 90000),
        ('Strazdina Alisa', 5, '2022-04-20', 60000),
        ('Okorokov Nikita', 6, '2019-01-15', 200000),
        ('Abdulkadirov Timur',7, '2024-09-10', 100000),
        ('Stovba Igor', 8, '2008-10-22', 200000),
        ('Nazarov Maxim', 9, '2012-07-13', 130000),
        ('Barukhov Kirill', 10, '2024-09-01', 80000);

alter table company.departments add constraint department_director foreign key (director_id) 
                                references company.employees(employee_id);

INSERT INTO company.tasks (project_name, task_description) VALUES
('Project RecSys', 'Сбор и очистка данных'),
('Project OnlineShop', 'Создание сервера'),
('Project OnlineShop', 'Реализация аутентификации пользователей'),
('Project Redesign', 'Дизайн нового логотипа'),
('Project MobileApp', 'Разработка Android версии приложения'),
('Project DB', 'Спроектировать логическую модель базы данных'),
('Project Agent', 'Создание среды для обучения');

INSERT INTO company.achievements (employee_id, project_name, achievement_description, achievement_date, bonus) VALUES
(5, 'Project Agent', 'Реализовала эффективный подход к обучению из свежей статьи', '2024-01-20', 7000),
(2, 'Project DB', 'Нормализовала модель базы данных', '2024-03-08', 10000),
(3, 'Project RecSys', 'Нашел полезную метрику', '2024-04-22', 5000),
(9, 'Project Redesign', 'Отдел дизайна показывает высокую продуктивность', '2024-05-05', 11000),
(1, 'Project DB', 'Завершен сложный переход на новую базу данных', '2024-06-10', 13000),
(6, 'Project OnlineShop', 'Реализовал CRUD запросы для приложения', '2024-06-15', 9000),
(9, 'Project Redesign', 'Макет дизайна создан раньше срока', '2024-06-25', 8000);

-- drop SCHEMA company cascade;
 INSERT INTO company.transaction (transaction_type, achievement_id, employee_id, timestamp, transaction_amount, bank_account) VALUES
('B', 1, 5, '2024-02-01 14:30:00', 7000, '1234567890'),
('B', 2, 2, '2024-09-01 09:00:00', 10000, '0987654321'),
('B', 3, 3, '2024-05-01 10:00:00', 5000, '1122334455'),
('S', NULL, 4, '2024-05-01 10:00:00', 90000, '2233445566'),
('S', NULL, 5, '2024-06-01 13:15:00', 60000, '3344556677'),
('B', 6, 6, '2024-06-01 11:45:00', 9000, '4455667788'),
('S', NULL, 7, '2024-06-01 11:45:00', 100000, '5566778899');

insert into company.projects_x_employees (project_name, employee_id) VALUES
('Project RecSys', 5),
('Project RecSys', 3),
('Project RecSys', 4),
('Project Agent', 4),
('Project DB', 1),
('Project DB', 2),
('Project MobileApp', 8),
('Project Redesign', 9),
('Project Redesign', 10),
('Project OnlineShop',6),
('Project OnlineShop',7);

insert into company.tasks_X_employees(task_id, employee_id) VALUES
(1, 5),
(1, 4),
(2, 7),
(3, 6),
(4, 10),
(5, 8),
(6, 2);