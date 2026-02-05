-- ============================================
-- INDEXES.SQL - Optimización de Consultas
-- ============================================

-- 1. Índice para búsqueda de alumnos por nombre y email (vw_students_at_risk)
-- Optimiza la búsqueda de texto en el dashboard.
CREATE INDEX idx_students_search ON students (nombre, email);

-- 2. Índice en la FK de inscripciones para acelerar JOINs
-- Para reportes que unen estudiantes, grupos y calificaciones.
CREATE INDEX idx_enrollment_group_id ON enrollment (group_id);

-- 3. Índice para filtros por periodo académico (term)
-- Optimiza vw_course_performance y vw_teacher_load.
CREATE INDEX idx_groups_term ON groups (term);