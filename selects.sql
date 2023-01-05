-- task 6

-- 0.1 за простые SELECT- запросы
-- 0.3 за запросы с группировками и соединениями
-- 0.5 за запросы с версионностью/ оконными функциями

-- Сформулировать5смысловыхзапросовкБДсловами.НаписатьихнаSQL.
-- Запросы должны содержать (необязательно всё в одном запросе):
-- a. GROUP BY + HAVING;
-- b. ORDER BY;
-- c. оконные функции.
-- Вместе с кодом приложить ваши ожидания от работы запроса.
-- Пример: «В результате выполнения Запроса 1 будут
-- получены суммарные остатки каждого товара на всех складах».


-- В результате запроса по каждому проекту (id) выведем
-- id, имена, фамилии, загруженность по часам студентов,
-- которые подходят на роль стажеров (то есть выполнили задание,
-- которое необходимо для проекта, и их решение было принято),
-- но при этом их общая загруженность составляет не больше 40 часов
-- в неделю, отсортированных по загруженности

insert into project_interns(student_id, project_id, work_link, hours_per_week)
values(4, 8, 'worklink.com/project-8-4', 5);

-- кандидаты в проекты
select
    projects.id,
    s.student_id,
    first_name,
    last_name,
    coalesce(sum(hours_per_week), 0) as work_time
from projects inner join tests t on t.id = projects.test_id
    inner join solutions s on t.id = s.test_id
    inner join students s2 on s2.id = s.student_id
    left join project_interns pi on s2.id = pi.student_id
where status = 'ACCEPTED'
group by projects.id, s.student_id, first_name, last_name
having coalesce(sum(hours_per_week), 0) < 40
order by projects.id, work_time
;

-- В результате запроса соберем статистику по каждому заданию:
-- сколько всего решений было отправлено,
-- процент принятых решений,
-- для скольки проектов необходимо это задание
-- рейтинг по сдаче среди заданий в той же области

-- статистика по заданиям
select tests.id,
       topic,
       solutions_amount,
       accepted * 100 / solutions_amount  as acceptance_percentage,
       count(*) as projects_amount,
       dense_rank() over (partition by tests.topic order by solutions_amount desc) as rank_in_topic
from tests inner join projects p on tests.id = p.test_id
    inner join (
        select test_id,
           count(*) as solutions_amount,
           sum(case when status = 'ACCEPTED' then 1 else 0 end) as accepted
        from tests inner join solutions s on tests.id = s.test_id
        group by test_id)
    solutions_stat on p.test_id = solutions_stat.test_id
group by tests.id, accepted, solutions_amount, tests.topic
order by solutions_amount desc;


-- выведем топ студентов по возможности попасть на проект
-- перцентиль, id, имя, фамилия,
-- на сколько проектов он проходит по сданным заданиям

-- рейтинг студентов
select cast(percent_rank() over (order by count(*) desc) * 100 as decimal(10, 2)) as percentile,
       student_id,
       first_name,
       last_name,
       count(*) as available_projects
from students inner join solutions s on students.id = s.student_id
    inner join tests t on s.test_id = t.id
    inner join projects p on t.id = p.test_id
where status = 'ACCEPTED'
group by student_id, first_name, last_name;


-- В результате запроса получим
-- студентом-фуллтаймеров (id, имя, фамилия)
-- и имена и фамилии их менторов, перечисленные через запятую
select student_id,
       students.first_name,
       students.last_name,
       string_agg(m.first_name || ' ' || m.last_name, ', ')
from students inner join project_interns pi on students.id = pi.student_id
    inner join projects p on pi.project_id = p.id
    inner join mentors m on m.id = p.mentor_id
group by student_id, students.first_name, students.last_name
having sum(hours_per_week) >= 40;

-- В результате запроса найдем пересечение в версионной таблице solutions

insert into solutions(test_id, student_id, solution_link, status)
values (1, 1, 'solution.com/1', 'ACCEPTED');
-- создадим пересечение с первой версией решения
update solutions
set valid_to = now()
where test_id = 1 and student_id = 1 and
      valid_from = (select valid_from
                    from solutions
                    where test_id = 1 and student_id = 1
                    order by valid_from
                    limit 1);

-- пересечение в версионной таблице solutions,
-- номер теста, номер студента,
-- ранний временной отрезок, статус решения в нем
-- поздний временной отрезок, статус решения в нем
select s1.test_id,
       s1.student_id,
       s1.valid_from as prev_valid_from,
       s1.valid_to as prev_valid_to,
       s1.status as prev_status,
       s2.valid_from as valid_from,
       s2.valid_to as valid_to,
       s2.status as status
from solutions s2
inner join solutions s1 on s1.student_id = s2.student_id
    and s1.test_id = s2.test_id
    and s2.valid_from between s1.valid_from and s1.valid_to
    and s2.valid_to <> s1.valid_to;

