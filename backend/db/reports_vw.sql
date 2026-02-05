-- ============================================
-- Minimo 5 Views
-- ============================================



-- ============================================
-- VIEW_1 - asistencia promedio por grupo (term).
-- ============================================
-- Qué devuelve: El promedio de asistencia por grupo
-- Grain (qué representa una fila): Un grupo
-- Métricas: SUM y COUNT
-- Por qué usa GROUP BY/HAVING: GROUP BY para poder agrupar por grupo
-- Campos calculados: pormedio de asistencia
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
LEFT JOIN attendance a ON e.id = a.enrolled_id
GROUP BY g.id, g.term;

-- ============================================
-- VIEW_2 - Carga de trabajo
-- ============================================
-- Qué devuelve: Carga de trabajo por docente y periodo.
-- Grain (qué representa una fila): Docente + periodo.
-- Métricas: Total de grupos y total de alumnos atendidos.
-- Por qué usa HAVING: Para filtrar docentes que tienen una carga significativa (más de 0 alumnos).
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
LEFT JOIN grades gr ON e.id = gr.enrolled_id
GROUP BY t.id, t.nombre, t.email, g.term
HAVING COUNT(e.id) > 0;




-- ============================================
-- VIEW_3 - Rendimiento academico
-- ============================================
-- Qué devuelve: Rendimiento académico por curso y periodo.
-- Grain (qué representa una fila): 1 fila por curso + periodo (term).
-- Métricas: Promedio general y conteo de aprobados/reprobados.
-- Campos calculados: Estatus de alerta basado en el % de reprobación.
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
JOIN grades gr ON e.id = gr.enrolled_id
GROUP BY c.nombre, g.term;


-- ============================================
-- VIEW_4 - Alumnos con metricas debajo del estandar
-- ============================================
-- Qué devuelve: Listado de alumnos con métricas por debajo del estándar.
-- Grain (qué representa una fila): Un Estudiante.
-- Métricas: SUM y COUNT
-- CTE: Calcula primero el desempeño antes de filtrar el riesgo.
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
    LEFT JOIN grades gr ON e.id = gr.enrolled_id
    LEFT JOIN attendance a ON e.id = a.enrolled_id
    GROUP BY s.id, s.nombre, s.email
)
SELECT * FROM student_performance
WHERE promedio_final < 7 OR porcentaje_asistencia < 80;



-- ============================================
-- VIEW_5 - Top alumnos por carrera y periodo
-- ============================================
-- Qué devuelve: El top de alumnos por carrera y periodo.
-- Grain (qué representa una fila): Estudiante por periodo.
-- Métricas: SUM y COUNT
-- Window Function: RANK() particionado por programa.
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
JOIN grades gr ON e.id = gr.enrolled_id
GROUP BY s.id, s.nombre, s.program, g.term;