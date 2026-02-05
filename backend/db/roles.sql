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
GRANT SELECT ON vw_attendance_by_group TO app_user;
GRANT SELECT ON vw_teacher_load TO app_user;
GRANT SELECT ON vw_course_performance TO app_user;
GRANT SELECT ON vw_students_at_risk TO app_user;
GRANT SELECT ON vw_rank_students TO app_user;

