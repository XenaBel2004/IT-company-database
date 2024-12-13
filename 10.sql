create or replace procedure company.send_money_to(employee_id int, bank_account text) as
$$
    declare
        sal int;
        ach_id int;
        bon int;
    begin
        set search_path to company;
        select p.salary into sal from employees as e join position as p
        on e.position_id = p.position_id;
        insert into transaction VALUES ('S', null, employee_id, CURRENT_TIMESTAMP, sal, bank_account);
        for ach_id, bon in select achievement_id, bonus from achievements
        where date_part('month', achievement_date) = date_part('month', CURRENT_DATE)
        loop
            insert into transaction VALUES ('B', ach_id, employee_id, CURRENT_TIMESTAMP, bon, bank_account);
        end loop;
    end;
$$ language plpgsql;

-- call company.send_money_to(1, '1234343434');

---------------------------------------------------

CREATE OR REPLACE PROCEDURE finish_task(
    f_task_id INT
)
AS $$
DECLARE
    employee int;
    task_project text;
    task_desc text;
BEGIN
    SELECT tasks.project_name, tasks.task_description into task_project, task_desc from
    company.tasks where task_id = f_task_id;

    for employee in select employee_id from company.tasks_X_employees
    where tasks_X_employees.task_id = f_task_id
    loop
    INSERT INTO company.task_history (task_id, project_name, task_description, employee_involved, finishing_date)
    VALUES (f_task_id, task_project, task_desc, employee, CURRENT_DATE);
    end loop;
    delete from company.tasks where task_id = f_task_id;
END;
$$
LANGUAGE plpgsql;

-- CALL finish_task(1);
-- CALL finish_task(2);




