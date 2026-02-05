-- ============================================
-- INDEX 1: Optimización de Relación Categoría-Producto
-- Tabla: productos
-- Columna: categoria_id
-- Justificación: Acelera los JOINs y el GROUP BY de las vistas 1 y 5, 
--                reduciendo el tiempo de búsqueda de productos por categoría.
-- ============================================

CREATE INDEX idx_productos_categoria_id ON productos(categoria_id);

-- VERIFICACIÓN DE USO:
-- EXPLAIN ANALYZE 
-- SELECT * FROM productos WHERE categoria_id = 1;



-- ============================================
-- INDEX 2: Optimización de Relación Ordenes-Usuarios
-- Tabla: ordenes
-- Columna: usuario_id
-- Justificación: Acelera las consultas de las vistas 2 y 4, 
--                reduciendo el tiempo de búsqueda de ordenes por usuario.
-- ============================================

CREATE INDEX idx_ordenes_usuario_id ON ordenes(usuario_id);

-- VERIFICACIÓN DE USO:
-- EXPLAIN ANALYZE 
-- SELECT * FROM ordenes WHERE usuario_id = 1;



-- ============================================
-- INDEX 3: Optimización de Relación Orden_detalles-Productos
-- Tabla: orden_detalles
-- Columna: producto_id
-- Justificación: Acelera las consultas de las vistas 1, 3 y 5, 
--                reduciendo el tiempo de búsqueda de orden_detalles por producto.
-- ============================================

CREATE INDEX idx_ordenes_detalles_producto_id ON orden_detalles(producto_id);  

-- VERIFICACIÓN DE USO:
-- EXPLAIN ANALYZE 
-- SELECT * FROM orden_detalles WHERE producto_id = 1;