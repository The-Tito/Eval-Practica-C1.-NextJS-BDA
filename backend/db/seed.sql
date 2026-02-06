-- ============================================
-- SEED.SQL - Datos de Prueba para Paginación y Reportes
-- ============================================

-- 1. Profesores (Suficientes para probar paginación en Reporte 2)
INSERT INTO teachers (nombre, email) VALUES
('Juan Perez', 'juan.perez@universidad.edu'),
('Maria Lopez', 'maria.lopez@universidad.edu'),
('Carlos Ruiz', 'carlos.ruiz@universidad.edu'),
('Ana Garcia', 'ana.garcia@universidad.edu'),
('Luis Torres', 'luis.torres@universidad.edu'),
('Sofia Castro', 'sofia.castro@universidad.edu'), -- Registro 6 (Ya detona pág 2)
('Roberto Gomez', 'roberto.gomez@universidad.edu'),
('Elena Mendez', 'elena.mendez@universidad.edu'),
('Ricardo Salinas', 'ricardo.salinas@universidad.edu');

-- 2. Cursos
INSERT INTO courses (code, nombre, credits) VALUES
('CS101', 'Programación Web', 10.0),
('DB202', 'Bases de Datos Avanzadas', 8.0),
('MAT303', 'Cálculo Diferencial', 5.0),
('AI404', 'Inteligencia Artificial', 10.0);

-- 3. Grupos (Distribución de carga para Reporte 2)
INSERT INTO groups (course_id, teacher_id, term) VALUES
(1, 1, '2024-1'), (2, 1, '2024-1'), -- Juan tiene 2 grupos
(2, 2, '2024-1'), (3, 2, '2024-1'), -- Maria tiene 2 grupos
(3, 3, '2024-1'), (1, 4, '2024-1'), 
(2, 5, '2024-1'), (4, 6, '2024-1'), 
(1, 7, '2024-1'), (2, 8, '2024-1');

-- 4. Estudiantes (Mínimo 8 para probar paginación en Reporte 4)
INSERT INTO students (nombre, email, program, enrollment_year) VALUES
('Abigail Ramirez', 'abigail@mail.com', 'Sistemas', NOW()),
('Bernardo Silva', 'bernardo@mail.com', 'Sistemas', NOW()),
('Cristian Castro', 'cristian@mail.com', 'Mecánica', NOW()),
('Daniela Ortiz', 'daniela@mail.com', 'Industrial', NOW()),
('Esteban Quito', 'esteban@mail.com', 'Sistemas', NOW()),
('Fernanda Lugo', 'fernanda@mail.com', 'Sistemas', NOW()), -- Registro 6
('Gerardo Nuñez', 'gerardo@mail.com', 'Industrial', NOW()),
('Humberto Vélez', 'humberto@mail.com', 'Sistemas', NOW());

-- 5. Inscripciones (Enrollment)
-- Inscribimos a todos en varios grupos para generar volumen de datos
INSERT INTO enrollment (student_id, group_id) 
SELECT s.id, g.id FROM students s, groups g WHERE g.id <= 5;

-- 6. Calificaciones (Para generar Alumnos en Riesgo - Reporte 4)
-- Algunos con buenas notas y otros con notas bajas (< 7.0)
INSERT INTO grades (enrollment_id, partial1, partial2, final)
SELECT 
    id, 
    (RANDOM() * 5 + 5), -- Nota entre 5 y 10
    (RANDOM() * 5 + 5), 
    CASE WHEN id % 2 = 0 THEN 5.5 ELSE 9.0 END -- Alternamos reprobados y excelentes
FROM enrollment;

-- 7. Asistencia (Para generar Alumnos en Riesgo por Inasistencia)
-- Vamos a insertar asistencias masivas
-- Simulamos que los alumnos con ID par faltaron mucho (Riesgo)
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT id, student_id FROM enrollment LOOP
        -- Día 1
        INSERT INTO attendance (enrollment_id, date, present) 
        VALUES (r.id, '2024-02-01', 'Presente');
        
        -- Día 2 (Si el student_id es par, ponemos Ausente para crear riesgo)
        INSERT INTO attendance (enrollment_id, date, present) 
        VALUES (r.id, '2024-02-02', CASE WHEN r.student_id % 2 = 0 THEN 'Ausente' ELSE 'Presente' END);
        
        -- Día 3
        INSERT INTO attendance (enrollment_id, date, present) 
        VALUES (r.id, '2024-02-03', CASE WHEN r.student_id % 2 = 0 THEN 'Ausente' ELSE 'Presente' END);
    END LOOP;
END $$;