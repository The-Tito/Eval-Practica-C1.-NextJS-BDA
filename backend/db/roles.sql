-- =============================================================================
-- db/roles.sql - Configuración de Seguridad
-- =============================================================================

-- Crear el usuario para la aplicación 
-- Nota: En un entorno real, la contraseña vendría de una variable de entorno.
CREATE USER app_user WITH PASSWORD 'app_user123';

-- Permiso para conectar a la base de datos actual
GRANT CONNECT ON DATABASE postgres TO app_user;

-- Permiso para usar el esquema public 
GRANT USAGE ON SCHEMA public TO app_user;

-- Revocar todos los permisos por defecto para asegurar privilegios mínimos
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM app_user;

-- Otorgar SELECT únicamente sobre las VIEWS 
GRANT SELECT ON view_ventas_por_categoria TO app_user;
GRANT SELECT ON view_usuarios_gasto_mayor_1500 TO app_user;
GRANT SELECT ON view_top_productos_vendidos_mayor_5 TO app_user;
GRANT SELECT ON view_gasto_total_por_usuario_cte TO app_user;
GRANT SELECT ON view_ranking_productos_por_categoria TO app_user;

