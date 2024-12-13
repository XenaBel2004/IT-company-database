DROP SCHEMA IF EXISTS company CASCADE;
CREATE SCHEMA company;
set search_path=company;
create table company.projects (project_name text primary key, 
                            project_description text);

create table company.tasks (task_id serial primary key, 
                            project_name text references projects(project_name) ON DELETE CASCADE, 
                            task_description text NOT NULL);

create table company.task_history (task_id int, 
                                    project_name text references projects(project_name) ON DELETE CASCADE, 
                                    task_description text NOT NULL, 
                                    employee_involved int NOT NULL,
                                    finishing_date date NOT NULL,
                                    primary key(task_id, employee_involved));

create table company.departments (department_name text primary key,
                                director_id int,
                                description text,
                                num_employees int check (num_employees >= 0));

create table company.position (position_id serial primary key,
                            department_name text references company.departments(department_name),
                            position_name text not null);

create table company.employees (employee_id serial primary key,
                                employee_name text,
                                position_id int not null references company.position(position_id) ON DELETE CASCADE,
                                hiring_date date not null,
                                salary int check (salary >= 0));

create table company.achievements (achievement_id serial primary key,
                                employee_id int,
                                project_name text,
                                achievement_description text not null,
                                achievement_date date not null,
                                bonus int check (bonus >= 0),
                                foreign key(employee_id) references company.employees(employee_id),
                                foreign key(project_name) references company.projects(project_name) ON DELETE CASCADE);

ALTER TABLE company.departments add constraint department_director foreign key (director_id) 
                                references company.employees(employee_id);

CREATE TABLE company.transaction (transaction_type char(1) check (transaction_type in ('B','S')),
                                achievement_id int,
                                employee_id int,
                                timestamp timestamp,
                                transaction_amount integer check (transaction_amount > 0),
                                bank_account text check (bank_account not like '%[^0-9]%'),
                                primary key(transaction_type, employee_id, timestamp),
                                foreign key(achievement_id) references company.achievements(achievement_id) ON DELETE CASCADE,
                                foreign key(employee_id) references company.employees(employee_id));

CREATE TABLE company.tasks_X_employees (task_id int, employee_id int,
                                        primary key (task_id, employee_id),
                                        foreign key (task_id) references company.tasks(task_id) ON DELETE CASCADE,
                                        foreign key (employee_id) references company.employees(employee_id) ON DELETE CASCADE);

CREATE TABLE company.projects_X_employees (project_name text, employee_id int,
                                        primary key (project_name, employee_id),
                                        foreign key (project_name) references company.projects(project_name) ON DELETE CASCADE,
                                        foreign key (employee_id) references company.employees(employee_id) ON DELETE CASCADE);

-- SELECT pg_terminate_backend(pid)
-- FROM pg_stat_activity
-- WHERE state = 'idle' AND datname = 'postgres';

