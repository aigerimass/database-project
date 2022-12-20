-- task 5

set search_path = internships, public;

-- добавим нового ментора и проект, с которым он пришел
insert into mentors(id, first_name, last_name, team_name, email)
values (8, 'Михаил', 'Терентьев', 'Финансовый отдел', 'mihal@yandex.ru');

insert into projects(mentor_id, test_id, project_name, design_doc_link)
values (8, 1, 'caching', 'desdoc.com/ddd1');

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
-- наименее загруженный проект №4

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
-- 4, 7

-- удалим их
delete
from mentors
where id = 4
   or id = 7;
-- теперь список менторов актуален

-- Посмотрим кто стажеры Михаила Терентьева(8)
select project_id, student_id
from project_interns
inner join projects p on p.id = project_interns.project_id
where mentor_id = 8;
-- Студент 4

-- Михаил Терентьев решил переманить стажера в свой собственный проект
delete
from project_interns
where project_id = 4;

insert into project_interns(student_id, project_id, work_link, hours_per_week)
values (4, 10, 'worksystem.com/caching', 30);

-- Вернул менторство над ненужным проектом Ментору №1
update projects
set mentor_id = 1
where id = 4;

