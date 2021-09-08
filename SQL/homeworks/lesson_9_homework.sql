--task4 (lesson9)
-- Компьютерная фирма: Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа. Вывести: maker, type

with makers_with_one_type as (
	select maker
	from (
		select *,
			count(*) over(partition by maker) c
		from (
			select maker, type
			from product
			group by maker, type
			order by maker 
		) as t1
	) as t2
	where c = 1
)
select maker, count(*)
from product
where maker in (select * from makers_with_one_type)
group by maker 
having count(*) > 1;

--task5 (lesson9)
-- Компьютерная фирма: Найти максимальную, минимальную и среднюю цену на персональные компьютеры при условии, что средняя цена не превышает 600

select model, min(price), max(price), avg(price)
from pc
group by model
having avg(price) <= 600;


--task6 (lesson9)
-- Компьютерная фирма: Получить количество ПК и среднюю цену для каждой модели, средняя цена которой менее 800

select model, count(*), avg(price)
from pc
group by model
having avg(price) < 800;


--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select 
    case
        when grade >= 8
        then name
        else null
    end name, 
    grade,
    marks 
from (
    select 
        students.name,
        students.marks,
        grades.grade,
        case 
            when students.marks between grades.min_mark and grades.max_mark
            then 1
            else 0
        end flag_grade
    from students 
    cross join grades
) t1
where flag_grade = 1
order by grade desc, name, marks asc;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

with query1 as (
    select 
        name, 
        occupation,
        row_number() over(order by name) as row_num
    from OCCUPATIONS
    where upper(occupation) like '%PROFESSOR%'
),
query2 as (
    select 
        name, 
        occupation,
        row_number() over(order by name) as row_num
    from OCCUPATIONS
    where upper(occupation) like '%DOCTOR%'
),
query3 as (
    select 
        name, 
        occupation,
        row_number() over(order by name) as row_num
    from OCCUPATIONS
    where upper(occupation) like '%SINGER%'
),
query4 as (
    select 
        name, 
        occupation,
        row_number() over(order by name) as row_num
    from OCCUPATIONS
    where upper(occupation) like '%ACTOR%'
)
select t2.name, t1.name, t3.name, t4.name
from query1 t1
full outer join query2 t2 on t1.row_num=t2.row_num
full outer join query3 t3 on t1.row_num=t3.row_num
full outer join query4 t4 on t1.row_num=t4.row_num;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city 
from STATION 
where upper(substr(city, 0, 1)) not in ('E', 'U', 'I', 'O', 'A');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city
from station
where upper(substr(city, -1, 1)) not in ('E', 'U', 'I', 'O', 'A');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
