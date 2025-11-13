-- PROCEDIMIENTOS ALMACENADOS DE SELECCION - LECTURA

DROP PROCEDURE IF EXISTS sp_sel_schools;
CREATE PROCEDURE sp_sel_schools(
    IN p_id INT,
    IN p_search VARCHAR(500)
)
BEGIN
    IF p_id IS NOT NULL THEN
        SELECT * FROM schools WHERE id = p_id;
    ELSEIF p_search IS NOT NULL AND p_search != '' THEN
        SELECT * FROM schools 
        WHERE name LIKE CONCAT('%', p_search, '%') 
           OR address LIKE CONCAT('%', p_search, '%')
           OR phone LIKE CONCAT('%', p_search, '%')
        ORDER BY name;
    ELSE
        SELECT * FROM schools ORDER BY name;
    END IF;
END

DROP PROCEDURE IF EXISTS sp_sel_people;
CREATE PROCEDURE sp_sel_people(
    IN p_id INT,
    IN p_search VARCHAR(500)
)
BEGIN
    IF p_id IS NOT NULL THEN
        SELECT * FROM people WHERE id = p_id;
    ELSEIF p_search IS NOT NULL AND p_search != '' THEN
        SELECT * FROM people 
        WHERE code LIKE CONCAT('%', p_search, '%')
           OR father_last_name LIKE CONCAT('%', p_search, '%')
           OR mother_last_name LIKE CONCAT('%', p_search, '%')
           OR names LIKE CONCAT('%', p_search, '%')
        ORDER BY father_last_name, mother_last_name, names;
    ELSE
        SELECT * FROM people ORDER BY father_last_name, mother_last_name, names;
    END IF;
END

DROP PROCEDURE IF EXISTS sp_sel_parents;
CREATE PROCEDURE sp_sel_parents(
    IN p_id INT,
    IN p_search VARCHAR(500)
)
BEGIN
    IF p_id IS NOT NULL THEN
        SELECT * FROM parents WHERE id = p_id;
    ELSEIF p_search IS NOT NULL AND p_search != '' THEN
        SELECT p.* 
        FROM parents p
        INNER JOIN people per ON p.person_id = per.id
        INNER JOIN people par ON p.parent_id = par.id
        WHERE per.names LIKE CONCAT('%', p_search, '%')
           OR per.father_last_name LIKE CONCAT('%', p_search, '%')
           OR par.names LIKE CONCAT('%', p_search, '%')
           OR par.father_last_name LIKE CONCAT('%', p_search, '%')
           OR p.relation LIKE CONCAT('%', p_search, '%')
        ORDER BY p.relation;
    ELSE
        SELECT * FROM parents ORDER BY relation;
    END IF;
END

DROP PROCEDURE IF EXISTS sp_sel_students;
CREATE PROCEDURE sp_sel_students(
    IN p_id INT,
    IN p_search VARCHAR(500)
)
BEGIN
    IF p_id IS NOT NULL THEN
        SELECT * FROM students WHERE id = p_id;
    ELSEIF p_search IS NOT NULL AND p_search != '' THEN
        SELECT s.* 
        FROM students s
        INNER JOIN people p ON s.person_id = p.id
        WHERE s.code LIKE CONCAT('%', p_search, '%')
           OR p.names LIKE CONCAT('%', p_search, '%')
           OR p.father_last_name LIKE CONCAT('%', p_search, '%')
           OR p.mother_last_name LIKE CONCAT('%', p_search, '%')
        ORDER BY p.father_last_name, p.mother_last_name, p.names;
    ELSE
        SELECT s.* 
        FROM students s
        INNER JOIN people p ON s.person_id = p.id
        ORDER BY p.father_last_name, p.mother_last_name, p.names;
    END IF;
END

DROP PROCEDURE IF EXISTS sp_sel_grades;
CREATE PROCEDURE sp_sel_grades(
    IN p_id INT,
    IN p_search VARCHAR(500)
)
BEGIN
    IF p_id IS NOT NULL THEN
        SELECT * FROM grades WHERE id = p_id;
    ELSEIF p_search IS NOT NULL AND p_search != '' THEN
        SELECT * FROM grades 
        WHERE name LIKE CONCAT('%', p_search, '%')
        ORDER BY number, name;
    ELSE
        SELECT * FROM grades ORDER BY number, name;
    END IF;
END

DROP PROCEDURE IF EXISTS sp_sel_enrollments;
CREATE PROCEDURE sp_sel_enrollments(
    IN p_id INT,
    IN p_search VARCHAR(500)
)
BEGIN
    IF p_id IS NOT NULL THEN
        SELECT * FROM enrollments WHERE id = p_id;
    ELSEIF p_search IS NOT NULL AND p_search != '' THEN
        SELECT e.* 
        FROM enrollments e
        INNER JOIN schools s ON e.school_id = s.id
        INNER JOIN students st ON e.student_id = st.id
        INNER JOIN people p ON st.person_id = p.id
        INNER JOIN grades g ON e.grade_id = g.id
        WHERE s.name LIKE CONCAT('%', p_search, '%')
           OR p.names LIKE CONCAT('%', p_search, '%')
           OR p.father_last_name LIKE CONCAT('%', p_search, '%')
           OR g.name LIKE CONCAT('%', p_search, '%')
        ORDER BY e.create_at DESC;
    ELSE
        SELECT * FROM enrollments ORDER BY create_at DESC;
    END IF;
END

DROP PROCEDURE IF EXISTS sp_sel_documents;
CREATE PROCEDURE sp_sel_documents(
    IN p_id INT,
    IN p_search VARCHAR(500)
)
BEGIN
    IF p_id IS NOT NULL THEN
        SELECT * FROM documents WHERE id = p_id;
    ELSEIF p_search IS NOT NULL AND p_search != '' THEN
        SELECT d.* 
        FROM documents d
        INNER JOIN students s ON d.student_id = s.id
        INNER JOIN people p ON s.person_id = p.id
        INNER JOIN enrollments e ON d.enrollment_id = e.id
        INNER JOIN schools sc ON e.school_id = sc.id
        WHERE p.names LIKE CONCAT('%', p_search, '%')
           OR p.father_last_name LIKE CONCAT('%', p_search, '%')
           OR sc.name LIKE CONCAT('%', p_search, '%')
        ORDER BY d.create_at DESC;
    ELSE
        SELECT * FROM documents ORDER BY create_at DESC;
    END IF;
END

DROP PROCEDURE IF EXISTS sp_sel_grades_in_schools;
CREATE PROCEDURE sp_sel_grades_in_schools(
    IN p_id INT,
    IN p_search VARCHAR(500)
)
BEGIN
    IF p_id IS NOT NULL THEN
        SELECT gis.* 
        FROM grades_in_schools gis
        WHERE gis.id = p_id;
    ELSEIF p_search IS NOT NULL AND p_search != '' THEN
        SELECT gis.*,
               g.name as grade_name,
               g.number as grade_number,
               s.name as school_name
        FROM grades_in_schools gis
        INNER JOIN grades g ON gis.grade_id = g.id
        INNER JOIN schools s ON gis.school_id = s.id
        WHERE g.name LIKE CONCAT('%', p_search, '%')
           OR s.name LIKE CONCAT('%', p_search, '%')
           OR CAST(g.number AS CHAR) LIKE CONCAT('%', p_search, '%')
        ORDER BY s.name, g.number;
    ELSE
        SELECT gis.*,
               g.name as grade_name,
               g.number as grade_number,
               s.name as school_name
        FROM grades_in_schools gis
        INNER JOIN grades g ON gis.grade_id = g.id
        INNER JOIN schools s ON gis.school_id = s.id
        ORDER BY s.name, g.number;
    END IF;
END

-- PROCEDIMIENTOS ALMACENADOS DE INSERCION - ESCRITURA

drop procedure if exists sp_ins_schools;
create procedure sp_ins_schools(
in p_name varchar(500),
in p_address varchar(500),
in p_phone varchar(250),
in p_logo varchar(5000)
)
BEGIN

	INSERT INTO schools (name, address, phone, logo)
	VALUES (p_name, p_address, p_phone, p_logo);
	SELECT * FROM schools WHERE id = LAST_INSERT_ID();
END

DROP PROCEDURE IF EXISTS sp_ins_people;
CREATE PROCEDURE sp_ins_people(
    IN p_code VARCHAR(25),
    IN p_father_last_name VARCHAR(50),
    IN p_mother_last_name VARCHAR(50),
    IN p_names VARCHAR(50),
    IN p_gender BOOLEAN,
    IN p_birth_date DATE
)
BEGIN
    INSERT INTO people (code, father_last_name, mother_last_name, names, gender, birth_date)
    VALUES (p_code, p_father_last_name, p_mother_last_name, p_names, p_gender, p_birth_date);
    SELECT * FROM people WHERE id = LAST_INSERT_ID();
END

DROP PROCEDURE IF EXISTS sp_ins_parents;
CREATE PROCEDURE sp_ins_parents(
    IN p_person_id INT,
    IN p_parent_id INT,
    IN p_relation VARCHAR(50)
)
BEGIN
    INSERT INTO parents (person_id, parent_id, relation)
    VALUES (p_person_id, p_parent_id, p_relation);
    SELECT * FROM parents WHERE id = LAST_INSERT_ID();
END

DROP PROCEDURE IF EXISTS sp_ins_students;
CREATE PROCEDURE sp_ins_students(
    IN p_code VARCHAR(25),
    IN p_password VARCHAR(500),
    IN p_person_id INT
)
BEGIN
    INSERT INTO students (code, password, person_id)
    VALUES (p_code, p_password, p_person_id);
    SELECT * FROM students WHERE id = LAST_INSERT_ID();
END

DROP PROCEDURE IF EXISTS sp_ins_grades;
CREATE PROCEDURE sp_ins_grades(
    IN p_name VARCHAR(100),
    IN p_number INT
)
BEGIN
    INSERT INTO grades (name, number)
    VALUES (p_name, p_number);
    SELECT * FROM grades WHERE id = LAST_INSERT_ID();
END

DROP PROCEDURE IF EXISTS sp_ins_enrollments;
CREATE PROCEDURE sp_ins_enrollments(
    IN p_school_id INT,
    IN p_student_id INT,
    IN p_grade_id INT
)
BEGIN
    INSERT INTO enrollments (school_id, student_id, grade_id)
    VALUES (p_school_id, p_student_id, p_grade_id);
    SELECT * FROM enrollments WHERE id = LAST_INSERT_ID();
END

DROP PROCEDURE IF EXISTS sp_ins_documents;
CREATE PROCEDURE sp_ins_documents(
    IN p_enrollment_id INT,
    IN p_student_id INT,
    IN p_file_path VARCHAR(5000)
)
BEGIN
    INSERT INTO documents (enrollment_id, student_id, file_path)
    VALUES (p_enrollment_id, p_student_id, p_file_path);
    SELECT * FROM documents WHERE id = LAST_INSERT_ID();
END

DROP PROCEDURE IF EXISTS sp_ins_grades_in_schools;
CREATE PROCEDURE sp_ins_grades_in_schools(
    IN p_grade_id INT,
    IN p_school_id INT,
    IN p_vacancies INT
)
BEGIN
    INSERT INTO grades_in_schools (grade_id, school_id, vacancies)
    VALUES (p_grade_id, p_school_id, p_vacancies);
    SELECT * FROM grades_in_schools WHERE id = LAST_INSERT_ID();
END

-- PROCEDIMIENTOS ALMACENADOS DE ACTUALIZACIÓN - UPDATE

DROP PROCEDURE IF EXISTS sp_upd_schools;
CREATE PROCEDURE sp_upd_schools(
    IN p_id INT,
    IN p_name VARCHAR(500),
    IN p_address VARCHAR(500),
    IN p_phone VARCHAR(250),
    IN p_logo VARCHAR(5000),
    IN p_status BOOLEAN
)
BEGIN
    UPDATE schools 
    SET name = p_name, 
        address = p_address, 
        phone = p_phone, 
        logo = p_logo,
        status = p_status
    WHERE id = p_id;
    SELECT * FROM schools WHERE id = p_id;
END

DROP PROCEDURE IF EXISTS sp_upd_people;
CREATE PROCEDURE sp_upd_people(
    IN p_id INT,
    IN p_code VARCHAR(25),
    IN p_father_last_name VARCHAR(50),
    IN p_mother_last_name VARCHAR(50),
    IN p_names VARCHAR(50),
    IN p_gender BOOLEAN,
    IN p_birth_date DATE
)
BEGIN
    UPDATE people 
    SET code = p_code,
        father_last_name = p_father_last_name,
        mother_last_name = p_mother_last_name,
        names = p_names,
        gender = p_gender,
        birth_date = p_birth_date
    WHERE id = p_id;
    SELECT * FROM people WHERE id = p_id;
END

DROP PROCEDURE IF EXISTS sp_upd_parents;
CREATE PROCEDURE sp_upd_parents(
    IN p_id INT,
    IN p_person_id INT,
    IN p_parent_id INT,
    IN p_relation VARCHAR(50)
)
BEGIN
    UPDATE parents 
    SET person_id = p_person_id,
        parent_id = p_parent_id,
        relation = p_relation
    WHERE id = p_id;
    SELECT * FROM parents WHERE id = p_id;
END

DROP PROCEDURE IF EXISTS sp_upd_students;
CREATE PROCEDURE sp_upd_students(
    IN p_id INT,
    IN p_code VARCHAR(25),
    IN p_password VARCHAR(500),
    IN p_person_id INT
)
BEGIN
    UPDATE students 
    SET code = p_code,
        password = p_password,
        person_id = p_person_id
    WHERE id = p_id;
    SELECT * FROM students WHERE id = p_id;
END

DROP PROCEDURE IF EXISTS sp_upd_grades;
CREATE PROCEDURE sp_upd_grades(
    IN p_id INT,
    IN p_name VARCHAR(100),
    IN p_number INT
)
BEGIN
    UPDATE grades 
    SET name = p_name,
        number = p_number
    WHERE id = p_id;
    SELECT * FROM grades WHERE id = p_id;
END

DROP PROCEDURE IF EXISTS sp_upd_enrollments;
CREATE PROCEDURE sp_upd_enrollments(
    IN p_id INT,
    IN p_school_id INT,
    IN p_student_id INT,
    IN p_grade_id INT
)
BEGIN
    UPDATE enrollments 
    SET school_id = p_school_id,
        student_id = p_student_id,
        grade_id = p_grade_id
    WHERE id = p_id;
    SELECT * FROM enrollments WHERE id = p_id;
END

DROP PROCEDURE IF EXISTS sp_upd_documents;
CREATE PROCEDURE sp_upd_documents(
    IN p_id INT,
    IN p_enrollment_id INT,
    IN p_student_id INT,
    IN p_file_path VARCHAR(5000)
)
BEGIN
    UPDATE documents 
    SET enrollment_id = p_enrollment_id,
        student_id = p_student_id,
        file_path = p_file_path
    WHERE id = p_id;
    SELECT * FROM documents WHERE id = p_id;
END

DROP PROCEDURE IF EXISTS sp_upd_grades_in_schools;
CREATE PROCEDURE sp_upd_grades_in_schools(
    IN p_id INT,
    IN p_grade_id INT,
    IN p_school_id INT,
    IN p_vacancies INT
)
BEGIN
    UPDATE grades_in_schools 
    SET grade_id = p_grade_id,
        school_id = p_school_id,
        vacancies = p_vacancies
    WHERE id = p_id;
    SELECT * FROM grades_in_schools WHERE id = p_id;
END