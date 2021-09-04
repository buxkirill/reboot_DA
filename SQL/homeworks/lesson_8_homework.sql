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

select member_name, status, sum(unit_price * amount) as costs
from FamilyMembers t1
left join Payments t2 on t2.family_member=t1.member_id
where year(date) = '2005' 
group by member_name, status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

неправильно
with names as (
    select names
    from (
        select *,
            row_number() over(partition by names) as row_num
        from (
            select upper(substring(name, 1, instr(name, ' ') - 1)) as names
            from (select distinct name from Passenger) as t4
        ) as t1
    ) as t2
    where row_num = 2
)
select name
from Passenger
where upper(substring(name, 1, instr(name, ' ') - 1)) IN (select names from names)


корректно
with dublicate_name as (
    select name
    From (
        select name,
            row_number() over(partition by name) as row_num
        from Passenger
    ) as t1
    where row_num = 2
) 
select distinct name
from Passenger
where name IN (select name from dublicate_name)

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
