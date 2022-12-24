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
         inner join mentors m on m.id = projects.mentor_id;

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
    from internships.project_interns inner join students s on s.id = project_interns.student_id;

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
    from internships.solutions inner join students s on s.id = solutions.student_id;
