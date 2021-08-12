select * from pc;
select * from product;
select * from printer;
select * from laptop;

select distinct model
from product_new;

UPDATE product_new SET maker = 'E_updated' WHERE model = 'product_by_student_10_new';
select * from product_new where model = 'product_by_student_10_new';

-- Задание 9: Посчитать количество возможных типов cd в таблице PC
select count(distinct cd) from pc;

-- Задание 10: Какое количество принтеров у каждого производителя (maker), стоимость (price) которых (принтера) больше 280
select maker, count(*)
from printer t1
left join product_new t2 on t2.model = t1.model
where price > 280
group by maker;

-- Задание 11: Найти модели принтеров с самой высокой ценой. Вывести: model, price
select model, price
from printer
where price = (select max(price) from printer);

-- Задание 12: Вывести разницу в средней цене между PC и принтерами (Printer)
select 
	(select avg(price) from pc) 
	- 
	(select avg(price) from printer) as "разнциа в средней цене";

-- Задание 13: Вывести производителей самых дешевых принтеров. Вывести price, maker
select distinct price, maker
from product_new t1
left outer join printer t2 on t2.model = t1.model 
where t2.price = (select min(price) from printer);

-- Задание 14: Вывести производителей самых дешевых цветных принтеров (color = 'y')

select distinct maker
from product_new t1
left outer join printer t2 on t2.model = t1.model 
where t2.color='y' and t2.price = (select min(price) --подзапрос минимальной цены на принтер с цветом y
									from printer
									where color='y')


-- Задание 15: Вывести все принтеры со стоимостью выше средней по принтерам
select * 
from printer
where price > (select avg(price) from printer);

-- Задание 16: Какое количество уникальных продуктов среди PC и Laptop
select 
	(select count(distinct model) from pc) -- уникальный продукт = уникальная модель
	+
	(select count(distinct model) from laptop);

-- Задание 17: Какая средняя цена среди уникальных продуктов производителя = 'A' (только printer & laptop, без pc)

select t1.type, t2.model, avg(t2.price)
from product_new t1
join printer t2 on t2.model = t1.model 
where t1.maker = 'A' and t1.type='Printer'
group by t2.model, t1.type
union ALL
select t1.type, t2.model, avg(t2.price)
from product_new t1
join laptop t2 on t2.model = t1.model 
where t1.maker = 'A' and t1.type='Laptop'
group by t2.model, t1.type;

-- Задание 18: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D'. Вывести model

select distinct t1.model
from product_new t1
join printer t2 on t2.model = t1.model 
where t1.maker = 'A' 
	and t2.price > (select avg(price)
					from product_new t1
					join printer t2 on t2.model = t1.model 
					where t1.maker = 'D' )

-- Задание 19: Найдите производителей, которые производили бы как PC со скоростью (speed) не менее 750, так и laptop со скоростью (speed) не менее 750. Вывести maker


select distinct maker
from product_new t1
left join laptop t2 on t2.model = t1.model  
where t2.speed >= 750 -- ноуты со скоростью не менее 750
	and t1.maker in (select distinct maker --  и компьютеры со скоростью не менее 750
					from product_new t1
					left join pc t2 on t2.model = t1.model  
					where t2.speed >= 750);

-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

select t1.maker, avg(t2.hd) as "Средний размер HD"
from product_new t1
join pc t2 on t2.model = t1.model 
where t1.maker in (select distinct maker -- maker также выпускает и принтеры
					from product_new pn 
					where type='Printer')
group by t1.maker
/*
dsfsdfds
*/
