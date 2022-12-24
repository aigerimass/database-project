-- task 4

set search_path = internships, public;

insert into mentors(first_name, last_name, team_name, email)
values ('Дмитрий', 'Васильев', 'Поисковая система', 'davasilev_7@mail.ru'),
       ('Дарья', 'Кайдалова', 'Поисковая система', 'dakaydalova@mail.ru'),
       ('Кирилл', 'Маковеев', 'Премиум подписка', 'komakoveev@mail.ru'),
       ('Андрей', 'Серов', 'Премиум подписка', 'aaserov@mail.ru'),
       ('Денис', 'Тарасов', 'Корпоративная подписка', 'dtarasov@mail.ru'),
       ('Василий', 'Белов', 'Внутренние инструменты', 'vvkolubelov@mail.ru'),
       ('Семен', 'Кудашкин', 'Бизнес отдел', 'sakudashkina@mail.ru');

insert into students(first_name, last_name, cv_link, email)
values ('Василий', 'Ефимов', 'https://jacksonpollock.org/', 'vaefimov@edu.hse.ru'),
       ('Дмитрий', 'Жуков', 'http://tunnelsnakes.com/', 'dazhukov_2@edu.hse.ru'),
       ('Елена', 'Крымова', 'https://a4shop.by/', 'edkrymova@edu.hse.ru'),
       ('Елена', 'Римша', 'http://www.trashloop.com/', 'enrimsha@edu.hse.ru'),
       ('Яна', 'Ткаченко', 'https://thepigeon.org/', 'yavtkachenko@edu.hse.ru'),
       ('Анна', 'Тортакова', 'www.overleaf.com/project/6', 'aatortakova@edu.hse.ru'),
       ('Милана', 'Шурпакова', 'www.overleaf.com/project/7', 'mishurpakova@edu.hse.ru'),
       ('Денис', 'Толкачев', 'www.overleaf.com/project/8', 'dvtolkachev@edu.hse.ru'),
       ('Алина', 'Ким', 'www.overleaf.com/project/9', 'askim_7@edu.hse.ru'),
       ('Андрей', 'Гулам', 'www.overleaf.com/project/0', 'aggulam@edu.hse.ru'),
       ('Максим', 'Ахмедов', 'www.overleaf.com/project/60', 'mvakhmedov@edu.hse.ru');

insert into tests(link, topic)
values ('https://leetcode.com/problems/two-sum/', 'DP'),
       ('https://leetcode.com/problems/2', 'Trees'),
       ('https://leetcode.com/problems/3', 'SQL'),
       ('https://leetcode.com/problems/4', 'C++'),
       ('https://leetcode.com/problems/5', 'Python'),
       ('https://leetcode.com/problems/6', 'Python');

insert into projects(mentor_id, test_id, project_name, design_doc_link)
values (1, 1, 'membership-benefits-page', 'docs.google.com/document/d/1'),
       (2, 2, 'search-utilities', 'docs.google.com/document/d/12'),
       (3, 3, 'db-project', 'docs.google.com/document/d/13'),
       (1, 4, 'membership-benefits-page', 'docs.google.com/document/d/14'),
       (5, 1, 'kotlin-tools', 'docs.google.com/document/d/15'),
       (6, 5, 'linear-models', 'docs.google.com/document/d/16'),
       (5, 6, 'embeddings', 'docs.google.com/document/d/17'),
       (3, 5, 'plugin-sa', 'docs.google.com/document/d/11'),
       (2, 5, 'sre-project', 'docs.google.com/document/d/122');

insert into project_interns(student_id, project_id, work_link)
values (1, 1, 'example.com/1'),
       (2, 2, 'example.com/2'),
       (3, 3, 'example.com/23'),
       (4, 4, 'example.com/23'),
       (5, 5, 'example.com/42'),
       (6, 6, 'example.com/25'),
       (7, 7, 'example.com/425'),
       (8, 8, 'example.com/233'),
       (9, 9, 'example.com/21'),
       (10, 1, 'example.com/2342');

-- добавим принятые решения
insert into solutions(test_id, student_id, solution_link, status)
values (4, 10, 'solutions.com/1', 'ACCEPTED'),
       (5, 9, 'solutions.com/123', 'ACCEPTED'),
       (3, 8, 'solutions.com/13423', 'ACCEPTED'),
       (5, 6, 'solutions.com/1234', 'ACCEPTED'),
       (6, 7, 'solutions.com/1q2341', 'ACCEPTED'),
       (6, 4, 'solutions.com/1234', 'ACCEPTED'),
       (5, 3, 'solutions.com/114', 'ACCEPTED'),
       (4, 8, 'solutions.com/156', 'ACCEPTED'),
       (1, 4, 'solutions.com/145734', 'ACCEPTED'),
       (1, 5, 'solutions.com/124', 'ACCEPTED'),
       (1, 7, 'solutions.com/1df', 'ACCEPTED');

-- добавим новые решения

insert into solutions(test_id, student_id, solution_link)
values (1, 1, 'solutions.com/143'),
       (1, 2, 'solutions.com/1x43'),
       (1, 3, 'solutions.com/1x3xtx'),
       (2, 1, 'solutions.com/xgx31'),
       (2, 2, 'solutions.com/14gx'),
       (2, 4, 'solutions.com/x5t1'),
       (2, 5, 'solutions.com/1x52'),
       (3, 11, 'solutions.com/1x255');