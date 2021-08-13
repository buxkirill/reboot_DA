--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

Задание 1: Вывести name, class по кораблям, выпущенным после 1920

select name, class 
from ships
where launched > 1920;

Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942

select name, class 
from ships
where launched > 1920 and launched <= 1942;

Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class

select ships.class, count(*)
from ships 
group by ships.class
order by count(*);

Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)

select country, class
from classes 
where bore >= 16;

Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.

select ship
from outcomes
where battle = 'North Atlantic' and result='sunk';

Задание 6: Вывести название (ship) последнего потопленного корабля

/*
 Выводит только 1 строку
 */
select *
from outcomes t1
join battles t2 on t2.name = t1.battle 
where t1.result='sunk'
order by t2.date desc
limit 1;

/*
 Второй и более правильный вариант.
 */
select t1.ship
from outcomes t1
join battles t2 on t2.name = t1.battle 
where t1.result='sunk' 
and t2.date=(select max(date)
		from outcomes t1
		join battles t2 on t2.name = t1.battle --двойная проверка в Join
				and t1."result"='sunk');


Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля

/*
 По имеющимся данным, последний корабль потонул в 1944-10-25. И это корабли Fuso, Yamashiro (получены из задания №6)
 Данные корабли не имеют связи с таблицей ships, в которой указаны name и class
 Выведем только название корабля их таблицы outcomes, колонка class будет пустой 
 */

with query_from_6_task as (
		select t1.ship
		from outcomes t1
		join battles t2 on t2.name = t1.battle 
		where t1.result='sunk' 
		and t2.date=(select max(date)
				from outcomes t1
				join battles t2 on t2.name = t1.battle 
						and t1."result"='sunk'
			     )
)
select t1.ship, t2.class
from query_from_6_task t1
left outer join ships t2 on t2.name=t1.ship;

Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class

/*
 Таких кораблей не оказалось
 */
select t1.name , t2.class
from ships t1
left join classes t2 on t2.class = t1.class
left join outcomes t3 on t3.ship = t1.name
where t3.result='sunk'
	and t2.bore >= 16
	
	
Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class

select distinct class
from classes
where country = 'USA'

Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

select t1.name, t2.class
from ships t1
join classes t2 on t2.class = t1.class
where t2.country = 'USA'
