-- DATOS DE PRUEBA PARA INICIAR LA BASE DE DATOS
-- PERSONAS
insert into people (code, father_last_name, mother_last_name, names, gender, birth_date)
values
("60283417", "PEREZ", "CERRON", "DAYANA CELESTE", false, "2007-05-20"),
('45821547', 'Gómez', 'Ramírez', 'Carlos Alberto', true, '2008-03-12'),
('65254157', 'Fernández', 'Torres', 'Lucía María', false, '2007-07-25'),
('09811515', 'Sánchez', 'Pérez', 'Jorge Luis', true, '1980-11-04'),
('10021215', 'Torres', 'Ramos', 'María Elena', false, '1982-01-19'),
('21481516', 'Ramírez', 'López', 'Ana Sofía', false, '2010-09-30');
-- COLEGIOS
INSERT INTO schools (name, address, phone) VALUES
('Colegio San Martín', 'Av. Los Álamos 345, Lima', '987654321'),
('Instituto Tecnológico del Sur', 'Jr. Lima 123, Arequipa', '956123478'),
('Colegio Nacional José Olaya', 'Calle Las Rosas 78, Trujillo', '945321678'),
('Escuela Santa Rosa', 'Av. Grau 890, Cusco', '965874123'),
('Centro Educativo América', 'Jr. Bolívar 452, Piura', '912345678');
--PARIENTES
INSERT INTO parents (person_id, parent_id, relation) VALUES
(1, 3, 'Padre'),
(1, 4, 'Madre'),
(2, 3, 'Padre'),
(2, 4, 'Madre'),
(5, 3, 'Padre');
-- ESTUDIANTES
INSERT INTO students (code, password, person_id) VALUES
('E2411512', '12345', 1),
('E2458122', '12345', 2),
('E2151552', '12345', 5),
('E2115155', 'abcde', 1),
('E2155152', 'qwert', 2);
-- GRADOS
INSERT INTO grades (name, number) VALUES
('Primer Grado', 1),
('Segundo Grado', 2),
('Tercer Grado', 3),
('Cuarto Grado', 4),
('Quinto Grado', 5);
-- MATRICULAS
INSERT INTO enrollments (school_id, student_id, grade_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 1),
(5, 5, 2);
-- DOCUMENTOS
INSERT INTO documents (enrollment_id, student_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
-- GRADOS EN ESCUELAS
insert into grades_in_schools(grade_id, school_id, vacancies)
values
(1,1, 50),
(2,1, 25),
(3,1,10),
(1,3,10),
(2,5,35);