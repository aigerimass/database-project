create schema view_internships;

set search_path = view_internships, public;

drop view if exists view_candidates_rating;
create view view_candidates_rating as
    select first_name || ' ' || mentors.last_name as "Имя ментора",
           regexp_replace(mentors.email, '[[:alpha:]]', '*') as "Email",
           case when team_name isnull then 'Без команды' else team_name end as "Название команды"
    from internships.mentors
