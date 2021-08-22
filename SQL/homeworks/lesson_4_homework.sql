--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing


--task10 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по каждому производителю график (X: category_price, Y: count)

/*
request = """
SELECT * FROM products_price_categories_with_makers_second_stream;
"""
df = pd.read_sql_query(request, conn)

for maker in df.maker.unique():
    df_temp = df[df.maker == maker]
    ax = df_temp.plot(kind='bar', x='category_price', y='count', figsize=(12, 4), title=maker)
    ax.set_xticks([0,1,2])
    plt.show()
    del df_temp 
 */


--task11 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по A & D график (X: category_price, Y: count)

/*
df[(df.maker == 'A') | (df.maker == 'D')].groupby(by='category_price').sum().plot(kind='bar',figsize=(13,4))
plt.show()
 */

--task12 (lesson4)
-- Корабли: Сделать копию таблицы ships, но у название корабля не должно начинаться с буквы N (ships_without_n)

create table ships_without_n_second_stream as (
	select * 
	from ships
	where upper(name) not like 'N%'
);

select * from ships_without_n_second_stream;

/*___________________________________________________ДОМАШНЕЕ ЗАДАНИЕ___________________________________________________*/

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select product.model, product.maker, product.type
from product 
join pc on pc.model=product.model
union all 
select product.model, product.maker, product.type
from product 
join laptop on laptop.model=product.model
union all 
select product.model, product.maker, product.type
from product 
join printer on printer.model=product.model
order by model;

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case
	when price > (select avg(price) from pc)
	then 1
	else 0
end price_more_than_avg_pc
from printer;

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

/*
В таблице ships у всех кораблей определен класс. Поэтому определим список кораблей без класса только по таблице outcomes 
 */
select outcomes.ship, ships.class
from outcomes
left join ships on ships.name=outcomes.ship 
where ships.class is null;

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

/*
Все сражения прошли в 1941, 1942, 1943, 1944 годах. 
В каждом из вышеперечисленных годов был хоть один корабль, который первый раз спускался на воду
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
				  
--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select *
from outcomes
left outer join ships on ships.name=outcomes.ship
where upper(ships.class)='KONGO';
				  
--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300_second_stream as (
	with combined_tables as (
		select price, product.model from product join laptop  on product.model = laptop.model 
		union all
		select price, product.model from product join pc  on product.model = pc.model 
		union all 
		select price, product.model from product join printer  on product.model = printer.model
	)
	select *,
	case 
		when price > 300
		then 1
		else 0
	end flag
	from combined_tables
);
select model, price, flag from all_products_flag_300_second_stream;

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price_second_stream as (

	with combined_tables as (
		select price, product.model from product join laptop  on product.model = laptop.model 
		union all
		select price, product.model from product join pc  on product.model = pc.model 
		union all 
		select price, product.model from product join printer  on product.model = printer.model
	)
	select *,
	case 
		when price > (select avg(price) from combined_tables)
		then 1
		else 0
	end flag
	from combined_tables
);

select * from all_products_flag_avg_price_second_stream;

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select printer.model
from printer
join product on product.model=printer.model
where upper(product.maker) = 'A' 
and printer.price > (
	select avg(price)
	from printer
	join product on product.model=printer.model
	where upper(product.maker) in ('D', 'C')
);

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with all_products_maker_a as (
	select product.model, price from printer join product on product.model=printer.model
	where upper(product.maker) = 'A' 
	union all 
	select product.model, price from pc join product on product.model=pc.model
	where upper(product.maker) = 'A' 
	union all
	select product.model, price from laptop	join product on product.model=laptop.model
	where upper(product.maker) = 'A'
)
select *
from all_products_maker_a
where price > (
	select avg(price)
	from printer
	join product on product.model=printer.model
	where upper(product.maker) in ('D', 'C')
);

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

/*
В этом задании я бы вначале уточнил, что является "уникальным" продуктом. 
Являются ли уникальными 2 продукта с одинаковыми номерами модели, но с разными ценами/характеристиками?
В моем понимании являются. В таком случае у нас нет неуникальных продуктов.
Решил посчитать среднюю цену по каждой уникальной модели для производителя А (думаю, что лучше так показать среднюю цену, чем просто получить одну цифру по всем 15 продукта производителя А)
 */

with all_products_maker_a as (
	select product.model, price, code from printer join product on product.model=printer.model
	where upper(product.maker) = 'A' 
	union all
	select product.model, price, code from pc join product on product.model=pc.model
	where upper(product.maker) = 'A' 
	union all
	select product.model, price, code from laptop join product on product.model=laptop.model
	where upper(product.maker) = 'A'
)
select model, avg(price)
from all_products_maker_a
group by model;

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers_second_stream as (
	with combined_tables as (
		select price, product.model, maker from product join laptop  on product.model = laptop.model
		union all
		select price, product.model, maker from product join pc  on product.model = pc.model
		union all 
		select price, product.model, maker from product join printer  on product.model = printer.model
	)
	select maker, count(*)
	from combined_tables
	group by maker
	order by maker
);

select * from count_products_by_makers_second_stream;

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

/*
request = """
SELECT * FROM count_products_by_makers_second_stream;
"""
df = pd.read_sql_query(request, conn)

df.plot(kind='bar', x='maker', y='count', figsize=(13,4))
plt.show()
 */

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated_second_stream as (
	select * 
	from printer
	where model not in (select model 
			    from product 
	        	    where Upper(maker)='D'
	)
);

select * from printer_updated_second_stream;

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_view_second_stream as ( 
	select 
		t1.code, 
		t1.model, 
		t1.color, 
		t1.type, 
		t1.price, 
		t2.maker
	from printer_updated_second_stream t1
	left outer join product t2 on t2.model=t1.model
);

select * from printer_updated_view_second_stream;

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes_second_stream as (
	select 
		coalesce(class, '0') as class, 
		count(*)
	from outcomes 
	left outer join ships on ships.name = outcomes.ship
	where upper(result) = 'SUNK'
	group by class
);

select * from sunk_ships_by_classes_second_stream;

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

/*
request = """
SELECT * FROM sunk_ships_by_classes_second_stream;
"""
df = pd.read_sql_query(request, conn)
df.plot(kind='bar', x='class', y='count', figsize=(13,4))
plt.show()
 */

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag_second_stream as (
	select *,
	case 
		when numguns >= 9
		then 1
		else 0
	end flag
	from classes
);

select * from classes_with_flag_second_stream;

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

/*
request = """
SELECT * FROM classes;
"""
df = pd.read_sql_query(request, conn)
df.country.value_counts().plot(kind='bar', figsize=(12,4))
plt.show()
 */

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(*)
from (select name from ships
	  union
	  select ship from outcomes
	  ) all_ships_name
where upper(substring(trim(name), 1, 1)) in ('O', 'M');

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(*)
from (select name from ships
	  union
	  select ship from outcomes
	  ) all_ships_name
where --где количество пробелов в слове = 1. Предварительно использовав trim для обрезания пробелов в начале и в конце (на всякий случай)
(length(trim(name)) - length(replace(trim(name), ' ', ''))) = 1; 


--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

/*
request = """
SELECT * FROM ships;
"""
df = pd.read_sql_query(request, conn)

df.groupby(by='launched').count().plot(kind='bar', y='class', figsize=(12,4))
plt.legend('count')
plt.show()
*/
