-- ============================================
-- SEED FINAL: Luis Antonio - Lab Reportes
-- ============================================

-- Limpieza total con reinicio de IDs
TRUNCATE orden_detalles, ordenes, productos, usuarios, categorias RESTART IDENTITY CASCADE;

-- 1. CATEGORÍAS
INSERT INTO categorias (nombre, descripcion) VALUES
    ('Electrónica', 'Gadgets y computadoras de alta gama'),
    ('Ropa', 'Moda urbana y deportiva'),
    ('Hogar', 'Muebles y artículos de oficina'),
    ('Libros', 'Literatura técnica y ciencia ficción');

-- 2. USUARIOS (Añadimos más para probar paginación en Reporte 4)
INSERT INTO usuarios (email, nombre, password_hash) VALUES
    ('ada@tech.com', 'Ada Lovelace', 'hash_1'),
    ('alan@turing.com', 'Alan Turing', 'hash_2'),
    ('grace@hopper.com', 'Grace Hopper', 'hash_3'),
    ('linus@linux.org', 'Linus Torvalds', 'hash_4'),
    ('margaret@nasa.gov', 'Margaret Hamilton', 'hash_5'),
    ('donald@knuth.edu', 'Donald Knuth', 'hash_6'),
    ('steve@woz.com', 'Steve Wozniak', 'hash_7'),
    ('bill@gates.com', 'Bill Gates', 'hash_8'),
    ('jeff@bezos.com', 'Jeff Bezos', 'hash_9');

-- 3. PRODUCTOS
INSERT INTO productos (codigo, nombre, precio, stock, categoria_id) VALUES
    ('E-001', 'MacBook Pro M3', 2500.00, 10, 1),
    ('E-002', 'Monitor Studio Display', 1600.00, 5, 1),
    ('E-003', 'iPhone 15 Pro', 1100.00, 15, 1),
    ('R-001', 'Chaqueta de Cuero', 300.00, 10, 2),
    ('R-002', 'Tenis Edición Especial', 180.00, 25, 2),
    ('H-001', 'Escritorio Elevable', 450.00, 8, 3),
    ('L-001', 'Clean Code', 50.00, 100, 4),
    ('L-002', 'The Art of Computer Programming', 200.00, 10, 4);

-- 4. ÓRDENES Y DETALLES (Configuradas para Reporte 1, 4 y Paginación)

-- Usuarios con más de 1500 (Para que aparezcan en los reportes)
INSERT INTO ordenes (usuario_id, total, status) VALUES 
(1, 4100.00, 'entregado'), -- Ada
(2, 2700.00, 'pagado'),    -- Alan
(5, 2500.00, 'entregado'), -- Margaret
(7, 1600.00, 'pagado'),    -- Steve
(8, 1600.00, 'pagado'),    -- Bill
(9, 1600.00, 'pagado');    -- Jeff

-- Detalles para esas órdenes (Usando producto 1 y 2 para el ranking)
INSERT INTO orden_detalles (orden_id, producto_id, cantidad, precio_unitario) VALUES 
(1, 1, 1, 2500.00), (1, 2, 1, 1600.00),
(2, 2, 1, 1600.00), (2, 3, 1, 1100.00),
(3, 1, 1, 2500.00),
(4, 2, 1, 1600.00),
(5, 2, 1, 1600.00),
(6, 2, 1, 1600.00);

-- Ventas masivas de "Clean Code" (Producto ID 7) para Reporte 3 (> 5 ventas)
INSERT INTO ordenes (usuario_id, total, status) VALUES 
(3, 50.00, 'pagado'), (3, 50.00, 'pagado'), (4, 50.00, 'pagado'), 
(4, 50.00, 'pagado'), (6, 50.00, 'pagado'), (6, 50.00, 'pagado'), (6, 50.00, 'pagado');

INSERT INTO orden_detalles (orden_id, producto_id, cantidad, precio_unitario) VALUES 
(7, 7, 1, 50.00), (8, 7, 1, 50.00), (9, 7, 1, 50.00), 
(10, 7, 1, 50.00), (11, 7, 1, 50.00), (12, 7, 1, 50.00), (13, 7, 1, 50.00);

-- Finalización