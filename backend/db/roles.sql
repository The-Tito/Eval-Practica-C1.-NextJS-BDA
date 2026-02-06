CREATE USER app_user WITH PASSWORD 'app_user123';

-- CAMBIO AQUÍ: Usa el nombre de tu DB del .env
GRANT CONNECT ON DATABASE db_eval_practica TO app_user; 

GRANT USAGE ON SCHEMA public TO app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM app_user;

-- Otorgar permisos a las vistas
GRANT SELECT ON vw_attendance_by_group TO app_user;
GRANT SELECT ON vw_teacher_load TO app_user;
GRANT SELECT ON vw_course_performance TO app_user;
GRANT SELECT ON vw_students_at_risk TO app_user;
GRANT SELECT ON vw_rank_students TO app_user;