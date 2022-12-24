create schema view_internships;

set search_path = view_internships, public;

drop view if exists view_mentors;
create view view_mentors as
    select first_name || ' ' || mentors.last_name as "Имя ментора",
           regexp_replace(mentors.email, '[[:alpha:]]', '*') as "Email",
           case when team_name isnull then 'Без команды' else team_name end as "Название команды"
    from internships.mentors;

drop view if exists view_projects;
create view view_projects as
    select
        projects.id as "№",
        project_name as "Название проекта",
        design_doc_link as "Дизайн-док",
        first_name || ' ' || last_name as "Имя ментора"
    from internships.projects inner join mentors m on m.id = projects.mentor_id;


