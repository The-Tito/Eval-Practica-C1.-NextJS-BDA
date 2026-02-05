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
    g.term AS grupo,
    COUNT(a.id) AS total_dias,
    COALESCE(SUM(CASE WHEN present = 'Presente' OR 'Justificado' THEN 1 ELSE 0 ), 0) AS asistencias_totales,
    ROUND(
        COALESCE(SUM(CASE WHEN present = 'Presente' OR 'Justificado' THEN 1 ELSE 0 ) / NULLIF(COUNT(DISTINCT a.id), 0), 0), 2
        ) AS asistencia_promedio
FROM groups g
LEFT JOIN enrollment e ON g.id = e.group_id
LEFT JOIN attendance a ON e.id = a.enrolled_id
GROUP BY g,term, g.id;


-- ============================================
-- VIEW_2 - Usuario con un gasto mayor a 1500, usuario premium
-- ============================================
-- Qué devuelve: Resumen de usuarios con gastos mayores a 1500
-- Grain (qué representa una fila): Un usuario
-- Métricas: SUM y COUNT
-- Por qué usa GROUP BY/HAVING: GROUP BY, por nombre de usuario para poder obtener sus gastos sobre ese mismo usuario
-- Campos calculados: Gasto promedio sobre ordenes
-- 1–2 queries VERIFY para validar resultados
-- ============================================

CREATE OR REPLACE VIEW vw_teacher_load AS
SELECT 
    u.nombre AS usuario,
    COUNT(o.id) AS total_ordenes,
    COALESCE(SUM(o.total), 0) AS gasto_total,
    CASE 
        WHEN SUM(o.total) >  1500 THEN 'Premium'
        ELSE 'Regular'
    END AS categoria_cliente,
    ROUND(
        COALESCE(SUM(o.total) / NULLIF(COUNT(DISTINCT o.id), 0), 0), 2
    ) AS gasto_promedio
FROM usuarios u 
LEFT JOIN ordenes o ON u.id = o.usuario_id
GROUP BY u.id, u.nombre
HAVING COALESCE(SUM(o.total), 0) > 1500
ORDER BY COALESCE(SUM(o.total), 0) DESC;


-- VERIFY: Validar que el total y numero de ordenes coincida con el reporte
-- SELECT * FROM ordenes;
-- SELECT SUM(o.total) FROM ordenes o WHERE o.usuario_id = 1;



-- ============================================
-- VIEW_3 - Promedios y reprobados
-- ============================================
-- Qué devuelve: Resumen de promedios y numero de reprobados por grado y curso
-- Grain (qué representa una fila): Un curso
-- Métricas: SUM y COUNT
-- Por qué usa GROUP BY/HAVING: GROUP BY, agrupado por course.
-- Campos calculados: Promedio por grupo
-- ============================================

CREATE OR REPLACE VIEW vw_course_performance: AS
SELECT 
    p.nombre AS producto,
    COUNT(od.producto_id) AS cantidad_ventas,
    COALESCE(SUM(od.subtotal), 0) AS total_ventas,
    ROUND(AVG(od.precio_unitario), 2) AS precio_promedio_venta
FROM productos p
INNER JOIN orden_detalles od ON p.id = od.producto_id
GROUP BY p.nombre, p.id
HAVING COUNT(od.id) > 5;

-- VERIFY: Validar que el producto si se vendio esa cantidad de veces y el total
-- SELECT od.producto_id, od.subtotal FROM orden_detalles;
-- SELECT SUM(od.subtotal) FROM orden_detalles od WHERE od.producto_id = 1;



-- ============================================
-- VIEW_4 - Gasto total por usuario (CTE) 
-- ============================================
-- Qué devuelve: Resumen del gasto total del usuario
-- Grain (qué representa una fila): Un usuario
-- Métricas: SUM y COUNT
-- Por qué usa GROUP BY/HAVING: GROUP BY, por el id de orden para tener la informacion de la orden en especifico
-- Campos calculados: ticket promedio
-- 1–2 queries VERIFY para validar resultados
-- ============================================


CREATE OR REPLACE VIEW view_gasto_total_por_usuario_cte AS
WITH VentasTotales AS (
SELECT 
    o.usuario_id,
    COUNT(o.id) AS cantidad_ordenes,
    ROUND(AVG(o.total), 2) AS gasto_promedio,
    SUM(o.total) AS total_acumulado
FROM ordenes o
GROUP BY o.usuario_id
)
SELECT 
    u.nombre AS cliente,
    vt.total_acumulado,
    vt.cantidad_ordenes
FROM usuarios u 
JOIN VentasTotales vt ON u.id = vt.usuario_id;

-- VERIFY: Validar que la suma de la vista coincida con la suma de la tabla original 
-- SELECT SUM(total) FROM ordenes;
-- SELECT * FROM ordenes;



-- ============================================
-- VIEW_5 - Ranking de productos por categoria
-- ============================================
-- Qué devuelve: Los productos más vendidos dentro de cada categoría con su ranking.
-- Grain (qué representa una fila): Un producto por categoria
-- Métricas: SUM y COUNT
-- Por qué usa GROUP BY/HAVING: GROUP BY, para agruparlo sobre el nombre de la categoria
-- Campos calculados: porcentaje de contribucion
-- Por qué usa Window Function: Para clasificar productos dentro de grupos (categorías)
--                              sin colapsar las filas en un solo grupo general.
-- 1–2 queries VERIFY para validar resultados
-- ============================================

CREATE OR REPLACE VIEW view_ranking_productos_por_categoria AS
SELECT 
    c.nombre AS categoria,
    p.nombre AS producto,
    SUM(od.subtotal) AS ingresos_producto,
    -- Window Function: Clasifica productos por ingresos dentro de cada categoría 
    DENSE_RANK() OVER(
        PARTITION BY c.id 
        ORDER BY SUM(od.subtotal) DESC
    ) AS ranking_en_categoria,
    ROUND(
        (SUM(od.subtotal) * 100.0) / SUM(SUM(od.subtotal)) OVER(PARTITION BY c.id), 
        2
    ) AS porcentaje_contribucion_categoria
FROM categorias c
JOIN productos p ON c.id = p.categoria_id
JOIN orden_detalles od ON p.id = od.producto_id
GROUP BY c.id, c.nombre, p.id, p.nombre;

-- VERIFY: Comprobar que el ranking 1 sea efectivamente el de mayor ingreso en la categoría
-- SELECT * FROM orden_detalles;
-- SELECT * FROM view_ranking_productos_por_categoria WHERE ranking_en_categoria = 1;