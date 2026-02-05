-- ============================================
-- db/migrate.sql - Consolidación de Estructura
-- ============================================
-- Este archivo aplica los scripts necesarios para establecer la bd

-- 1. CREACIÓN DE VISTAS 
-- Aquí se incluyen las 5 vistas diseñadas 
\i /scripts/reports_vw.sql

-- OPTIMIZACIÓN 
-- Aplicamos los índices para mejorar el rendimiento de los reportes
\i /scripts/indexes.sql

-- SEGURIDAD 
-- Configuramos el usuario limitado para la app Next.js
\i /scripts/roles.sql
