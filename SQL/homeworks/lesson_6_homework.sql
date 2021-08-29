--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.

create table random_numbers_table as (
	select 
		floor(random()::numeric * 1000000)::int as col1,
		floor(random()::numeric * 1000000)::int as col2,
		floor(random()::numeric * 1000000)::int as col3
	from generate_series(1, 10000) 
)

/*
Проверим операторы сравнения
 */
explain select * 
from random_numbers_table;
-- Seq Scan on random_numbers_table  (cost=0.00..167.20 rows=11220 width=12)

explain select *
from random_numbers_table
where col1 = 15000;
--Seq Scan on random_numbers_table  (cost=0.00..180.00 rows=1 width=12)

explain select *
from random_numbers_table
where col1 = col2;
--Seq Scan on random_numbers_table  (cost=0.00..180.00 rows=50 width=12)

explain select *
from random_numbers_table
where col1 in (15000);
--Seq Scan on random_numbers_table  (cost=0.00..180.00 rows=1 width=12)

explain select *
from random_numbers_table
where col1 in (15000, 749267);
--Seq Scan on random_numbers_table  (cost=0.00..180.00 rows=2 width=12)

explain select *
from random_numbers_table
where col1 in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
--Seq Scan on random_numbers_table  (cost=0.00..280.00 rows=10 width=12)

explain select *
from random_numbers_table
where col1 between 1 and 10;
--Seq Scan on random_numbers_table  (cost=0.00..205.00 rows=1 width=12)

explain select *
from random_numbers_table
where col1 in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
and col2 = 9899
and col3 != 0;
--Seq Scan on random_numbers_table  (cost=0.00..330.00 rows=1 width=12)

/*
Проверим оператор case
 */
explain 
select *,
	case 
		when col1 = 0
		then 1
		else 0
	end flag
from random_numbers_table
--Seq Scan on random_numbers_table  (cost=0.00..180.00 rows=10000 width=16)

/*
Проверим агрегацию
 */

explain
select count(*)
from random_numbers_table
--Aggregate  (cost=180.00..180.01 rows=1 width=8)

explain
select count(*), avg(col1), max(col2), min(col3)
from random_numbers_table
--Aggregate  (cost=255.00..255.01 rows=1 width=48)

/*
Проверим эффективно ли мы выполняли запросы на уроке по оконным функциям
 */

explain
select *
from random_numbers_table
order by col1
limit 1
--Limit  (cost=205.00..205.00 rows=1 width=12)

explain
select * from (
	select *, row_number() over(order by col1) as row_num
	from random_numbers_table
) as t1
where row_num = 1
--Subquery Scan on t1  (cost=819.39..1119.39 rows=50 width=20)

/*
Проверим join
 */
explain
select *
from random_numbers_table t1
join random_numbers_table t2 on t1.col1=t2.col2
--Hash Join  (cost=280.00..585.43 rows=10043 width=24)

explain
select *
from random_numbers_table t1
cross join random_numbers_table t2 
--Nested Loop  (cost=0.00..1250335.00 rows=100000000 width=24)

explain
with t2 as (
	select *
	from random_numbers_table
	where col3 between 0 and 10000
)
select *
from random_numbers_table t1
join t2 on t1.col1 = t2.col2
--Hash Join  (cost=208.28..401.79 rows=101 width=24)

explain
select *
from random_numbers_table t1
join (
	select *
	from random_numbers_table
	where col3 between 0 and 10000
) t2 on t1.col1 = t2.col2
--Hash Join  (cost=206.26..412.27 rows=101 width=24)
	  
/*
Проверим несколько функций
 */

explain
select cast(col1 as text)
from random_numbers_table
--Seq Scan on random_numbers_table  (cost=0.00..205.00 rows=10000 width=32)

explain
select floor(log(2, col1)) 
from random_numbers_table
--Seq Scan on random_numbers_table  (cost=0.00..230.00 rows=10000 width=32)

	  
--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 

--открываем терминал и выполняем в нем следующие команды (файл avocado загрузил на свой гугл диск):
/*
pip3 install pandas
pip3 install sqlalchemy
wget 'https://drive.google.com/uc?export=download&id=1Gm5svHa6KRUUyTKExqYop9VDVwmPAEZX' -O './avocado.csv'
python3
*/

--Потом в интерпретаторе python выполняю следующее:
/*
from sqlalchemy import create_engine
import pandas as pd
DB_HOST = '52.157.159.24'
DB_USER = 'student10'
DB_USER_PASSWORD = 'student10_password'
DB_NAME = 'sql_ex_for_student10'
df = pd.read_csv('avocado.csv')
df.columns = [c.lower().replace(' ', '_') for c in df.columns]
engine = create_engine(f'postgresql://{DB_USER}:{DB_USER_PASSWORD}@{DB_HOST}:5432/{DB_NAME}')
df.to_sql('avocado', con=engine, if_exists='replace', method='multi')
*/

--Таблица загружена в БД. Проверяем
select *
from avocado;
