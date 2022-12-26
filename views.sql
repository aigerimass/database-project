create schema view_internships;

set search_path = view_internships, public;

drop view if exists view_mentors;
create view view_mentors as
select first_name || ' ' || last_name                                                              as "Имя ментора",
       case when email notnull then regexp_replace(email, '[[:alpha:]]', '*') else 'Нет почты' end as "Email",
       case when team_name isnull then 'Без команды' else team_name end                            as "Название команды"
from internships.mentors;

drop view if exists view_projects;
create view view_projects as
select projects.id                    as "№",
       project_name                   as "Название проекта",
       design_doc_link                as "Дизайн-док",
       first_name || ' ' || last_name as "Имя ментора"
from internships.projects
         inner join internships.mentors m on m.id = projects.mentor_id;

drop view if exists view_students;
create view view_students as
select first_name || ' ' || last_name                                                              as "Имя студента",
       case when email notnull then regexp_replace(email, '[[:alpha:]]', '*') else 'Нет почты' end as "Email",
       cv_link                                                                                     as "Резюме"
from internships.students;

create view view_interns as
    select first_name || ' ' || last_name as "Имя стажера",
        project_id as "Номер проекта",
        hours_per_week as "Ставка",
        work_link as "Ссылка на работу"
    from internships.project_interns inner join internships.students s on s.id = project_interns.student_id;

create view view_tests as
    select topic as "Тема задания",
           id as "Номер задания",
           link as "Условие"
    from internships.tests;

create view view_solutions as
    select first_name || ' ' || last_name as "Имя студента",
           solutions.test_id as "Номер задания",
           solution_link as "Ссылка на решение",
           status as "Статус"
    from internships.solutions inner join internships.students s on s.id = solutions.student_id;


create view view_full_time_interns as
    select student_id as "Номер студента",
       students.first_name || ' ' || students.last_name as "Имя студента",
       string_agg(m.first_name || ' ' || m.last_name, ', ') as "Менторы"
from internships.students inner join internships.project_interns pi on students.id = pi.student_id
    inner join internships.projects p on pi.project_id = p.id
    inner join internships.mentors m on m.id = p.mentor_id
group by student_id, students.first_name, students.last_name
having sum(hours_per_week) >= 40;

create view view_tasks_stat as
    select tests.id as "Номер задания",
       topic as "Тема",
       solutions_amount as "Посылок",
       accepted * 100 / solutions_amount as "Доля решенных",
       count(*) as "Количество проектов",
       dense_rank() over (partition by tests.topic order by solutions_amount desc) as "Рейтинг в теме"
from internships.tests inner join internships.projects p on tests.id = p.test_id
    inner join (
        select test_id,
           count(*) as solutions_amount,
           sum(case when status = 'ACCEPTED' then 1 else 0 end) as accepted
        from internships.tests inner join internships.solutions s on tests.id = s.test_id
        group by test_id)
    solutions_stat on p.test_id = solutions_stat.test_id
group by tests.id, accepted, solutions_amount, tests.topic
order by solutions_amount desc;

drop view if exists view_candidates;
create view view_candidates as
    select
    projects.id as "Номер проекта",
    project_name as "Проект",
    s.student_id as "Номер студента",
    first_name || ' ' || last_name as "Имя студента",
    coalesce(sum(hours_per_week), 0) as "Загруженность"
from internships.projects inner join internships.tests t on t.id = projects.test_id
    inner join internships.solutions s on t.id = s.test_id
    inner join internships.students s2 on s2.id = s.student_id
    left join internships.project_interns pi on s2.id = pi.student_id
where status = 'ACCEPTED'
group by projects.id, s.student_id, first_name, last_name
having coalesce(sum(hours_per_week), 0) < 40
order by projects.id, "Загруженность";


