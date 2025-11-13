DROP TABLE IF EXISTS schools; 
CREATE TABLE schools(
  id int auto_increment not null primary key,
  name varchar(500) not null,
  address varchar(500) not null,
  phone varchar(250) not null,
  logo varchar(5000),
  status boolean default true,
  create_at datetime default (current_date)
);

DROP TABLE IF EXISTS people;
CREATE TABLE people(
  id int auto_increment not null primary key,
  code varchar(25) not null,
  father_last_name varchar(50) not null,
  mother_last_name varchar(50) not null,
  names varchar(50) not null,
  gender boolean,
  birth_date date,
  create_at datetime default (current_date)
);

DROP TABLE IF EXISTS parents;
CREATE TABLE parents(
  id int auto_increment not null primary key,
  person_id int not null,
  parent_id int not null,
  relation varchar(50) not null,
  create_at datetime default (current_date),
  foreign key (person_id) references people(id),
  foreign key (parent_id) references people(id)
);

DROP TABLE IF EXISTS students;
CREATE TABLE students(
  id int auto_increment not null primary key,
  code varchar(25) not null,
  password varchar(500) not null,
  person_id int not null,
  create_at datetime default (current_date),
  foreign key (person_id) references people(id)
);

DROP TABLE IF EXISTS grades;
CREATE TABLE grades(
  id int auto_increment not null primary key,
  name varchar(100) not null,
  number int default 0,
  create_at datetime default (current_date)
);

DROP TABLE IF EXISTS enrollments;
CREATE TABLE enrollments(
  id int auto_increment not null primary key,
  school_id int not null,
  student_id int not null,
  grade_id int not null,
  create_at datetime default (current_date),
  foreign key (school_id) references schools(id),
  foreign key (student_id) references students(id),
  foreign key (grade_id) references grades(id)
);

DROP TABLE IF EXISTS documents;
CREATE TABLE documents(
  id int auto_increment not null primary key,
  enrollment_id int not null,
  student_id int not null,
  file_path varchar(5000),
  create_at datetime default (current_date),
  foreign key (enrollment_id) references enrollments(id),
  foreign key (student_id) references students(id)
);

drop table if exists grades_in_schools;
create table grades_in_schools(
	id int auto_increment not null primary key,
	grade_id int not null,
	school_id int not null,
	vacancies int default 0,
	create_at datetime default (current_date),
	foreign key (grade_id) references grades(id),
	foreign key (school_id) references schools(id)
);