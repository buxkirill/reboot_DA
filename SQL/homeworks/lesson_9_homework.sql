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

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
