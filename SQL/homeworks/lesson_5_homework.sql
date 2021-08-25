--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing



--task11 (lesson5)
-- Компьютерная фирма: Построить график с со средней и максимальной ценами на базе products_with_lowest_price (X: maker, Y1: max_price, Y2: avg)price

/*
request = """
SELECT * from products_with_lowest_price_second_stream;
"""
df = pd.read_sql_query(request, conn)

df.groupby(by='maker').agg({"price": [max, np.mean]}).plot(kind='bar')
plt.show()
 */



--task12 (lesson5) and task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

create view pages_all_products_second_stream as (
	select 
		code, 
		model, 
		speed, 
		ram, 
		hd, 
		price, 
		screen, 
		row_number () over (partition by page) as sheet_number,
		dense_rank () over (order by page) as page
	from (
		select *,
			row_num - "1_0_column" as page
		from (
			select *,
				case 
					when row_num % 2 = 0 then 1 else 0
				end "1_0_column"
			from (select *, row_number () over () as row_num from laptop
			) as t1
		) as t2
	) as t3
);

select * from pages_all_products_second_stream;

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель,

/*
Кажется, что в задании не дописали какие колонки еще требуется выводить (стоит запятая в конце. Во всех остальных заданиях предложение на запятую не заканчивалось)
Сделал вывод только по type и количеству. Добавить производителя не сложно, но в условии было указано сделать группировку по типу устройства
*/

create or replace view distribution_by_type_second_stream as (
	select distinct type,
		cast(count_by_type as float) / count_all as part
	from (
		select  type,
			count(*) over(partition by type) as count_by_type,
			count(*) over() as count_all
		from (
			select maker, product.type from product join pc on pc.model = product.model
			union all 
			select maker, product.type from product join laptop on laptop.model = product.model
			union all 
			select maker, product.type from product join printer on printer.model = product.model
		) as t1
	) as t2
);
select * from distribution_by_type_second_stream;

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму

/*
request = """
SELECT * from distribution_by_type_second_stream;
"""
df = pd.read_sql_query(request, conn)

df.set_index('type').plot.pie(y='count', figsize=(10,10))
plt.show()
 */

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но у название корабля должно состоять из двух слов

create table ships_two_words_second_stream as (
	select *
	from ships
	where (length(trim(name)) - length(replace(trim(name), ' ', ''))) = 1
);

select * from ships_two_words_second_stream;

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

/*
У всех кораблей в таблице ships определен класс. Поэтому выбираем корабли только из таблицы outcomes
 */

select ship, class
from outcomes
left outer join ships on ships.name=outcomes.ship
where (class is null) and (upper(ship) like 'S%');

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

with printer_with_avg_price_on_maker as (
	select 
		product.model,
		product.maker,
		printer.price,
		avg(price) over(order by maker)
	from product 
	join printer on printer.model=product.model
)
select t1.model, 'цена у А больше, чем средняя цена у С'
from printer_with_avg_price_on_maker t1
cross join printer_with_avg_price_on_maker t2
where (t1.maker = 'A')
	and (t2.maker = 'C')
	and (t1.price > t2.avg)
union all 
select model, 'Один из трех самых дорогих принтеров' as comment
from (
	select product.model,
		row_number() over(order by price desc) as row_num
	from product 
	join printer on printer.model=product.model
) as t1
where row_num in (1,2,3);
