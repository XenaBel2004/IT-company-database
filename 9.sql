

CREATE OR REPLACE FUNCTION company.recalc_employee()
RETURNS trigger AS $$
    BEGIN
    SET SEARCH_PATH to company;
    IF TG_OP = 'INSERT' THEN
        UPDATE company.departments
        SET num_employees = (num_employees + 1)
        WHERE department_name = (
            SELECT department_name
            FROM company.position
            WHERE position_id = NEW.position_id
        );

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE company.departments
        SET num_employees = num_employees - 1
        WHERE department_name = (
            SELECT department_name
            FROM company.position
            WHERE position_id = OLD.position_id
        );
    END IF;
    RETURN NULL;
  END;
$$
LANGUAGE plpgsql;

select * from company.departments;

CREATE TRIGGER after_salary_update
AFTER INSERT OR DELETE ON company.employees
FOR EACH ROW
EXECUTE FUNCTION recalc_employee();

-- set SEARCH_PATH to company;
-- delete from company.employees where employee_name='ddd';
-- INSERT into company.employees (position_id,employee_name,hiring_date) VALUES(5,'ddd','1200-01-01');


-------------------------------------------


create or replace function trig_add_task()
returns trigger as $$
    declare
        id int := new.employee_id;
        num_of_tasks int;
    begin
        set SEARCH_PATH to company;
        select count(*) into num_of_tasks from tasks_X_employees
        where employee_id = id;
        if num_of_tasks = 3
        then raise 'Too many tasks! Cannot add one more!';
        end if;
        return new;
    end;
$$ language plpgsql;



-- set SEARCH_PATH to company
create or replace trigger tg_task_update
before insert on company.tasks_X_employees
for each row execute function trig_add_task();

-- INSERT INTO company.tasks_x_employees VALUES (4,2);
