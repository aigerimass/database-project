-- task 5

set search_path = internships, public;

-- добавим нового ментора
insert into mentors(id, first_name, last_name, team_name, email)
values (8, 'Михаил', 'Терентьев', 'Финансовый отдел', 'mihal@yandex.ru');

-- посмотрим нагрузку менторов по количеству стажеров
select mentor_id,
       count(*) as amount_of_interns
from projects
         inner join project_interns pi on projects.id = pi.project_id
group by mentor_id
order by amount_of_interns
;

-- самый загруженный ментор №1, посмотрим временную загруженность по его проектам
select project_id,
       sum(hours_per_week) as workload
from projects
         inner join project_interns pi on projects.id = pi.project_id
where mentor_id = 1
group by project_id
order by workload;

-- отдадим проект №4 новому ментору
update projects
set mentor_id = 8
where id = 4;

-- найдем менторов без проектов
(select id
 from mentors)
except
(select mentor_id
 from projects);

-- удалим их
delete
from mentors
where id = 4
   or id = 7;

-- теперь список менторов актуален