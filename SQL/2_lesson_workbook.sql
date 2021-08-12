select * from pc;
select * from product;
select * from printer;
select * from laptop;

select distinct model
from product_new;

UPDATE product_new SET maker = 'E_updated' WHERE model = 'product_by_student_10_new';
select * from product_new where model = 'product_by_student_10_new';

-- ������� 9: ��������� ���������� ��������� ����� cd � ������� PC
select count(distinct cd) from pc;

-- ������� 10: ����� ���������� ��������� � ������� ������������� (maker), ��������� (price) ������� (��������) ������ 280
select maker, count(*)
from printer t1
left join product_new t2 on t2.model = t1.model
where price > 280
group by maker;

-- ������� 11: ����� ������ ��������� � ����� ������� �����. �������: model, price
select model, price
from printer
where price = (select max(price) from printer);

-- ������� 12: ������� ������� � ������� ���� ����� PC � ���������� (Printer)
select 
	(select avg(price) from pc) 
	- 
	(select avg(price) from printer) as "������� � ������� ����";

-- ������� 13: ������� �������������� ����� ������� ���������. ������� price, maker
select distinct price, maker
from product_new t1
left outer join printer t2 on t2.model = t1.model 
where t2.price = (select min(price) from printer);

-- ������� 14: ������� �������������� ����� ������� ������� ��������� (color = 'y')

select distinct maker
from product_new t1
left outer join printer t2 on t2.model = t1.model 
where t2.color='y' and t2.price = (select min(price) --��������� ����������� ���� �� ������� � ������ y
									from printer
									where color='y')


-- ������� 15: ������� ��� �������� �� ���������� ���� ������� �� ���������
select * 
from printer
where price > (select avg(price) from printer);

-- ������� 16: ����� ���������� ���������� ��������� ����� PC � Laptop
select 
	(select count(distinct model) from pc) -- ���������� ������� = ���������� ������
	+
	(select count(distinct model) from laptop);

-- ������� 17: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (������ printer & laptop, ��� pc)

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

-- ������� 18: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D'. ������� model

select distinct t1.model
from product_new t1
join printer t2 on t2.model = t1.model 
where t1.maker = 'A' 
	and t2.price > (select avg(price)
					from product_new t1
					join printer t2 on t2.model = t1.model 
					where t1.maker = 'D' )

-- ������� 19: ������� ��������������, ������� ����������� �� ��� PC �� ��������� (speed) �� ����� 750, ��� � laptop �� ��������� (speed) �� ����� 750. ������� maker


select distinct maker
from product_new t1
left join laptop t2 on t2.model = t1.model  
where t2.speed >= 750 -- ����� �� ��������� �� ����� 750
	and t1.maker in (select distinct maker --  � ���������� �� ��������� �� ����� 750
					from product_new t1
					left join pc t2 on t2.model = t1.model  
					where t2.speed >= 750);

-- ������� 20: ������� ������� ������ hd PC ������� �� ��� ��������������, ������� ��������� � ��������. �������: maker, ������� ������ HD.

select t1.maker, avg(t2.hd) as "������� ������ HD"
from product_new t1
join pc t2 on t2.model = t1.model 
where t1.maker in (select distinct maker -- maker ����� ��������� � ��������
					from product_new pn 
					where type='Printer')
group by t1.maker
/*
dsfsdfds
*/
