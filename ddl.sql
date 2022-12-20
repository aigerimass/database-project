-- drop schema if exists internships;
create schema internships;

-- set search_path to default;
set search_path = internships, public;

-- Создание таблицы менторов

-- drop table if exists mentors;
create table mentors
(
    id         serial primary key,
    first_name varchar(40) not null,
    last_name  varchar(50),
    team_name  varchar(100),
    email      varchar(100) unique check ( regexp_match(email, '^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$') notnull)
);

-- Создание таблицы студентов

-- drop table if exists students;
create table students
(
    id         serial primary key,
    first_name varchar(40) not null,
    last_name  varchar(50),
    email      varchar(100) unique check ( regexp_match(email, '^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$') notnull),
    cv_link    varchar(100) unique
);

-- Создание таблицы заданий

-- drop table if exists tests;
create table tests
(
    id    serial primary key,
    link  varchar(100) not null,
    topic varchar(100)
);

-- Создание таблицы решений

-- drop table if exists solutions;
create table solutions
(
    test_id       int references tests (id)          not null,
    student_id    int references students (id)       not null,
    solution_link varchar(100)                       not null,
    status        varchar(20) default 'WAITING'      not null check ( status in ('ACCEPTED', 'WAITING', 'DECLINED')),
    valid_from    timestamp   default (now())        not null,
    valid_to      timestamp   default ('9999-12-31') not null check ( valid_from < valid_to ),

    constraint solution_ver primary key (test_id, student_id, valid_from)
);

-- Создание таблицы проектов

-- drop table if exists projects;
create table projects
(
    id              serial primary key,
    mentor_id       int references mentors (id) not null,
    test_id         int references tests (id)   not null,
    project_name    varchar(100)                not null,
    design_doc_link varchar(100)
);

-- Создание таблицы для пар проект-студент
-- drop table if exists project_interns;
create table project_interns
(
    student_id     int references students (id) on delete cascade,
    project_id     int references projects (id) on delete cascade,
    work_link      varchar(100),
    hours_per_week int default 40 check ( hours_per_week <= 40 and hours_per_week > 0 ),

    constraint intern primary key (student_id, project_id)
);