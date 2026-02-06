-- ============================================
-- SEED.SQL - Datos de Prueba
-- ============================================

-- 1. Insertar Profesores (Para probar paginación en vw_teacher_load)
INSERT INTO teachers (nombre, email) VALUES
('Juan Perez', 'juan.perez@universidad.edu'),
('Maria Lopez', 'maria.lopez@universidad.edu'),
('Carlos Ruiz', 'carlos.ruiz@universidad.edu'),
('Ana Garcia', 'ana.garcia@universidad.edu'),
('Luis Torres', 'luis.torres@universidad.edu'),
('Sofia Castro', 'sofia.castro@universidad.edu');

-- 2. Insertar Cursos
INSERT INTO courses (code, nombre, credits) VALUES
('CS101', 'Programación Web', 10.0),
('DB202', 'Bases de Datos Avanzadas', 8.0),
('MAT303', 'Cálculo Diferencial', 5.0);

-- 3. Insertar Grupos (Diferentes periodos para probar filtros)
INSERT INTO groups (course_id, teacher_id, term) VALUES
(1, 1, 202401), -- Web con Juan (2024-1)
(2, 2, 202401), -- BDA con Maria (2024-1)
(3, 3, 202401), -- Cálculo con Carlos (2024-1)
(1, 4, 202402); -- Web con Ana (2024-2)

-- 4. Insertar Estudiantes (Suficientes para probar paginación y búsqueda)
INSERT INTO students (nombre, email, program, enrollment_year) VALUES
('Alumno Excelente', 'excelente@mail.com', 'Sistemas', CURRENT_TIMESTAMP),
('Alumno Riesgo Academico', 'riesgo.acad@mail.com', 'Sistemas', CURRENT_TIMESTAMP),
('Alumno Riesgo Asistencia', 'riesgo.asist@mail.com', 'Mecánica', CURRENT_TIMESTAMP),
('Juan Manuel', 'jmanuel@mail.com', 'Industrial', CURRENT_TIMESTAMP),
('Beatriz Soto', 'bsoto@mail.com', 'Sistemas', CURRENT_TIMESTAMP),
('Pedro Picapiedra', 'pedro@mail.com', 'Sistemas', CURRENT_TIMESTAMP),
('Luis Antonio', 'luis@mail.com', 'Industrial', CURRENT_TIMESTAMP);

-- 5. Inscripciones (Enrollment)
INSERT INTO enrollment (student_id, group_id) VALUES
(1, 1), (1, 2), -- Excelente en 2 grupos
(2, 1), (2, 2), -- Riesgo Acad en 2 grupos
(3, 1), (3, 2), -- Riesgo Asist en 2 grupos
(4, 1), (5, 1), (6, 1), (7, 1); -- Otros en grupo 1

-- 6. Calificaciones (Para vw_course_performance y vw_rank_students)
INSERT INTO grades (enrollment_id, partial1, partial2, final) VALUES
(1, 10, 10, 10), -- Alumno 1: Excelente
(2, 10, 9, 9.5), -- Alumno 1 en otro grupo
(3, 5, 4, 4.5),  -- Alumno 2: Reprobado (Riesgo)
(4, 5, 5, 5.0),  -- Alumno 2: Reprobado
(5, 8, 8, 8.0),  -- Alumno 3: Aprobado pero checaremos su asistencia
(6, 9, 9, 9.0);

-- 7. Asistencia (Para vw_attendance_by_group y vw_students_at_risk)
-- Simulando 4 días de clase
INSERT INTO attendance (enrollment_id, date, present) VALUES
-- Alumno 1 (Excelente): 100%
(1, '2024-02-01', 'Presente'), (1, '2024-02-02', 'Presente'),
-- Alumno 3 (Riesgo Asistencia): 25% (Debe salir en vw_students_at_risk)
(5, '2024-02-01', 'Presente'), (5, '2024-02-02', 'Ausente'), 
(5, '2024-02-03', 'Ausente'), (5, '2024-02-04', 'Ausente');