drop schema if exists internships;
create schema internships;

set search_path to default;
set search_path = internships;

-- Создание таблицы менторов


drop table if exists mentors;
create table mentors
(
    id         serial primary key,
    first_name varchar(100)        not null,
    last_name  varchar(100),
    team_name  varchar(100),
    email      varchar(100) unique not null
);

-- Создание таблицы студентов


drop table if exists students;
create table students
(
    id         serial primary key,
    first_name varchar(100)        not null,
    last_name  varchar(100),
    email      varchar(100) unique not null,
    cv_link    varchar(100) unique
);

-- Создание таблицы заданий


drop table if exists tests;
create table tests
(
    id   serial primary key,
    link varchar(100) not null
);

-- Создание таблицы решений

drop table if exists solutions;
create table solutions
(
    id            serial primary key,
    test_id       int references tests (id),
    student_id    int references students (id),
    solution_link varchar(100),
    status        varchar(100) default 'WAITING',
    valid_from    timestamp, -- i will add triggers here
    valid_to      timestamp,

    constraint valid_dates_check check ( valid_from < valid_to ),
    constraint solution_status_check check ( status in ('ACCEPTED', 'WAITING', 'DECLINED'))
);

-- Создание таблицы проектов

drop table if exists projects;
create table projects
(
    id              serial primary key,
    mentor_id       int references mentors (id) not null,
    test_id         int references tests (id)   not null,
    project_name    varchar(100)                not null unique,
    design_doc_link varchar(100)
);

-- Создание таблицы для пар проект-студент
drop table if exists project_interns;
create table project_interns
(
    student_id     int references students (id),
    project_id     int references projects (id),
    work_link      varchar(100),
    hours_per_week int default 40,
    primary key (student_id, project_id),
    constraint working_hours check ( hours_per_week <= 40 and hours_per_week > 0)
);