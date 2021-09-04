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

select count(*) as count
from Student
where upper(first_name) = 'ANNA'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(*) as count
from (
    select distinct classroom
    from Schedule
    where date = date('2019.09.02')
) as t1

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count
from Student
where upper(first_name) = 'ANNA'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select floor(avg(years)) as age
from (
    select floor(datediff(now(), birthday) / 365.23) as years
    from FamilyMembers
) as t1

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, sum(amount * unit_price) as costs
from Payments
join Goods on Payments.good=Goods.good_id
join GoodTypes on GoodTypes.good_type_id=Goods.type
where year(payments.date) = 2005
GROUP BY good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select floor(datediff(now(), birthday) / 365.23) as year
from Student
order by birthday DESC 
limit 1

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

with id_10_classes as (
    select id
    from Class
    where trim(substr(name, 1, instr(name, ' '))) = '10'
)
select floor(datediff(now(), birthday) / 365.23) as max_year
from Student
join Student_in_class on Student.id=Student_in_class.student
where Student_in_class.class in (select * from id_10_classes)
order by birthday
limit 1

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
