--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

with query as (
    select 
        t2.name as Department, 
        t1.name as Employee, 
        t1.salary as Salary,
        dense_rank() over(partition by t1.departmentid order by t1.salary desc) as rank_col
    from employee t1
    join department t2 on t2.id=t1.departmentid
)

select Department, Employee, Salary
from query
where rank_col <= 3;


--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
