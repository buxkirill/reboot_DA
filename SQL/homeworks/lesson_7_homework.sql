--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

ok

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

with query as (
    select email,
        row_number() over(partition by email order by id)  row_num
    from person
)
select email 
from query
where row_num = 2;

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select t1.name as employee
from Employee t1
left outer join Employee t2 on t1.managerid=t2.id
where t1.salary > t2.salary


--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select 
    score,
    dense_rank() over(order by score desc) as "Rank"
from scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select 
    FirstName,
    LastName,
    City,
    State
from person
left outer join address
    on address.personid=person.personid

