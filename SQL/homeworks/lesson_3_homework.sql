--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

with grouped_sunken_ships as (
		select ships.class, count(*) as count_sunk
		from ships
		left outer join outcomes on ships.name=outcomes.ship
		where upper(result) = 'SUNK'
		group by ships.class
)
select t1.class,
case 
	when t2.count_sunk is null
	then 0
	else t2.count_sunk
end
from classes t1
left outer join grouped_sunken_ships t2 on t2.class=t1.class;

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

/*
 Дата запуска первого корабля = Дате запуска головного корабля (для текущих данных это условие выполняется)
 В запросе получился только 1 класс, в котором не определен головной корабль. Bismarck
 У класса Bismarck нет кораблей в таблице ships, то есть мы не знаем минимальный год спуска на воду по данного классу
 Чтобы хоть как-то заполнить год спуска по Bismarck, буду использовать минимальный год спуска для type кораблей (bb или bc).
 
 Итого: Если дата первого спуска не определена, выведем первую дату спуска для типа bb или bc
 */

with min_date_launched_by_type as (
		select t1.type, min(t2.launched) as year_of_first_launch_by_type
		from classes t1
		join ships t2 on t1.class=t2.class
		group by t1.type
)
select classes.class, 
	case 
		when ships.launched is not null
		then ships.launched
		else t3.year_of_first_launch_by_type
	end as "first time launched"
from classes
left join ships on classes.class=ships.name
left join min_date_launched_by_type t3 on t3.type=classes.type
order by "first time launched";

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

with classes_with_more_than_3_ships as (
		select classes.class, count(*)
		from classes
		left join ships on ships.class=classes.class
		group by classes.class
		having count(*) >= 3
),
classes_with_sunken_ships as (
		select classes.class, count(*)
		from classes
		left join ships on ships.class=classes.class
		left join outcomes on ships.name=outcomes.ship
		where upper(outcomes.result)='SUNK'
		group by classes.class
)
select t1.class, t2.count as count_of_sunken_ships
from classes_with_more_than_3_ships t1
join classes_with_sunken_ships t2 on t1.class=t2.class;

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with ships_names as (
		select name   -- подзапрос с названием всех кораблей из таблицы ships и outcomes
		from ships
		union
		select ship
		from outcomes
),
grouped_displacements_with_max_guns as (
		select displacement, max(numguns) 
		from classes 
		group by displacement
)
select t4.displacement, t1.name, t3.numguns
from ships_names t1 
left join ships t2 --добавляем к ships_names названия классов
	on t2.name=t1.name
left join classes t3 -- соединяем таблицы с classes
	on t3.class=t2.class 
join grouped_displacements_with_max_guns t4 -- соединяем со сгруппированной таблицей максимального количества орудий по водоизмещению
	on t4.displacement = t3.displacement 
	and t4.max = t3.numguns 
order by displacement;

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

with makers_with_smallest_ram_and_fastest_speed as (
		select * 
		from pc 
		join product on product.model=pc.model
		where ram = (select min(ram)  -- с наименьшим ram
					 from pc)
		and speed = (select max(speed) -- и с максимальной скоростью + наименьшим ram
					 from pc 
					 where ram = (select min(ram) 
					    	      from pc))
)
select distinct t1.maker
from product t1
join makers_with_smallest_ram_and_fastest_speed t2 on t1.maker=t2.maker
where t1.type='Printer';


--task16
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. (через with)

/*
 Все сражения прошли в 1941, 1942, 1943, 1944 годах. В каждом из перечисленных годов был корабль, который первый раз спускался на воду
 */

with all_battles_date as (
		select battle, to_char(date, 'YYYY') as date
		from outcomes
		join battles 
		on outcomes.battle = battles.name
) 
select *
from all_battles_date
where date not in (select distinct cast(launched as text) 
				   from ships);
				  
--task17
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select *
from outcomes
left outer join ships on ships.name=outcomes.ship
where upper(ships.class)='KONGO';
