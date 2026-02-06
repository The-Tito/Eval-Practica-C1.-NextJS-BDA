-- ============================================
-- Minimo 5 Views
-- ============================================

-- ============================================
-- VIEW_1 - asistencia promedio por grupo (term).
-- ============================================
-- Qué devuelve: El promedio de asistencia por grupo y periodo.
-- Grain (qué representa una fila): Un Grupo + Periodo.
-- Métricas: COUNT (registros totales), SUM (asistencias exitosas).
-- Por qué usa GROUP BY: Para consolidar los registros de asistencia de todos los alumnos de un mismo grupo.
-- Campos calculados: asistencia_promedio_porcentaje (Porcentaje relativo de presencia).
-- VERIFY: 
-- SELECT * FROM vw_attendance_by_group WHERE asistencia_promedio_porcentaje < 70;
-- SELECT COUNT(*) FROM vw_attendance_by_group;
-- ============================================

CREATE OR REPLACE VIEW vw_attendance_by_group AS
SELECT 
    g.id AS group_id,
    g.term AS term,
    COUNT(a.id) AS total_registros,
    SUM(CASE WHEN a.present IN ('Presente', 'Justificado') THEN 1 ELSE 0 END) AS asistencias_totales,
    ROUND(
        CAST(SUM(CASE WHEN a.present IN ('Presente', 'Justificado') THEN 1 ELSE 0 END) AS NUMERIC) / 
        NULLIF(COUNT(a.id), 0) * 100, 2
    ) AS asistencia_promedio_porcentaje
FROM groups g
LEFT JOIN enrollment e ON g.id = e.group_id
LEFT JOIN attendance a ON e.id = a.enrollment_id
GROUP BY g.id, g.term;

-- ============================================
-- VIEW_2 - Carga de trabajo docente
-- ============================================
-- Qué devuelve: Resumen de carga académica y desempeño de grupos por docente.
-- Grain (qué representa una fila): Un Docente por Periodo.
-- Métricas: COUNT DISTINCT (grupos únicos), COUNT (alumnos totales), AVG (promedio de notas).
-- Por qué usa HAVING: Para excluir docentes que no tienen alumnos asignados en el periodo (limpieza de datos).
-- VERIFY:
-- SELECT * FROM vw_teacher_load ORDER BY total_grupos DESC LIMIT 1;
-- SELECT docente, alumnos_totales FROM vw_teacher_load WHERE periodo = '2024-1';
-- ============================================

CREATE OR REPLACE VIEW vw_teacher_load AS
SELECT 
    t.nombre AS docente,
    t.email,
    g.term AS periodo,
    COUNT(DISTINCT g.id) AS total_grupos,
    COUNT(e.id) AS alumnos_totales,
    ROUND(AVG(gr.final), 2) AS promedio_de_sus_grupos
FROM teachers t
JOIN groups g ON t.id = g.teacher_id
LEFT JOIN enrollment e ON g.id = e.group_id
LEFT JOIN grades gr ON e.id = gr.enrollment_id
GROUP BY t.id, t.nombre, t.email, g.term
HAVING COUNT(e.id) > 0;

-- ============================================
-- VIEW_3 - Rendimiento académico por curso
-- ============================================
-- Qué devuelve: Estadísticas de aprobación y promedio por asignatura.
-- Grain (qué representa una fila): Un Curso por Periodo.
-- Métricas: AVG (promedio general), COUNT CASE (aprobados vs reprobados).
-- Campos calculados: estatus_alerta (Marca cursos donde la reprobación supera el 30%).
-- VERIFY:
-- SELECT * FROM vw_course_performance WHERE estatus_alerta = 'ALTA REPROBACIÓN';
-- SELECT curso, promedio_general FROM vw_course_performance ORDER BY promedio_general ASC;
-- ============================================

CREATE OR REPLACE VIEW vw_course_performance AS
SELECT 
    c.nombre AS curso,
    g.term AS periodo,
    ROUND(AVG((gr.partial1 + gr.partial2 + gr.final) / 3), 2) AS promedio_general,
    COUNT(CASE WHEN gr.final >= 6 THEN 1 END) AS aprobados,
    COUNT(CASE WHEN gr.final < 6 THEN 1 END) AS reprobados,
    CASE 
        WHEN COUNT(CASE WHEN gr.final < 6 THEN 1 END) > (COUNT(gr.id) * 0.3) THEN 'ALTA REPROBACIÓN'
        ELSE 'NORMAL'
    END AS estatus_alerta
FROM courses c
JOIN groups g ON c.id = g.course_id
JOIN enrollment e ON g.id = e.group_id
JOIN grades gr ON e.id = gr.enrollment_id
GROUP BY c.nombre, g.term;

-- ============================================
-- VIEW_4 - Alumnos en riesgo (CTE)
-- ============================================
-- Qué devuelve: Alumnos con bajo rendimiento académico o inasistencias críticas.
-- Grain (qué representa una fila): Un Estudiante.
-- Métricas: AVG (nota final), Porcentaje de asistencia (Cálculo relacional).
-- CTE: Se utiliza "student_performance" para modularizar el cálculo de promedios antes del filtro final.
-- VERIFY:
-- SELECT COUNT(*) FROM vw_students_at_risk;
-- SELECT nombre, promedio_final FROM vw_students_at_risk WHERE porcentaje_asistencia < 50;
-- ============================================

CREATE OR REPLACE VIEW vw_students_at_risk AS
WITH student_performance AS (
    SELECT 
        s.id,
        s.nombre,
        s.email,
        AVG(gr.final) AS promedio_final,
        (CAST(SUM(CASE WHEN a.present = 'Presente' THEN 1 ELSE 0 END) AS NUMERIC) / 
         NULLIF(COUNT(a.id), 0)) * 100 AS porcentaje_asistencia
    FROM students s
    JOIN enrollment e ON s.id = e.student_id
    LEFT JOIN grades gr ON e.id = gr.enrollment_id
    LEFT JOIN attendance a ON e.id = a.enrollment_id
    GROUP BY s.id, s.nombre, s.email
)
SELECT * FROM student_performance
WHERE promedio_final < 7 OR porcentaje_asistencia < 80;

-- ============================================
-- VIEW_5 - Ranking de alumnos (Window Function)
-- ============================================
-- Qué devuelve: Posición jerárquica de alumnos basada en su promedio por carrera.
-- Grain (qué representa una fila): Un Estudiante por Carrera y Periodo.
-- Métricas: AVG (promedio para el ranking).
-- Window Function: RANK() para asignar lugares sin saltar números en empates, particionado por programa escolar.
-- VERIFY:
-- SELECT * FROM vw_rank_students WHERE posicion_ranking = 1;
-- SELECT alumno, carrera, promedio FROM vw_rank_students WHERE posicion_ranking <= 3 ORDER BY carrera, posicion_ranking;
-- ============================================

CREATE OR REPLACE VIEW vw_rank_students AS
SELECT 
    s.nombre AS alumno,
    s.program AS carrera,
    g.term AS periodo,
    ROUND(AVG(gr.final), 2) AS promedio,
    RANK() OVER (
        PARTITION BY s.program, g.term 
        ORDER BY AVG(gr.final) DESC
    ) AS posicion_ranking
FROM students s
JOIN enrollment e ON s.id = e.student_id
JOIN groups g ON e.group_id = g.id
JOIN grades gr ON e.id = gr.enrollment_id
GROUP BY s.id, s.nombre, s.program, g.term;