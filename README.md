# Dashboard de Coordinación Académica - AWOS & BDA

Este proyecto es una **aplicación web** integral desarrollada con **Next.js (TypeScript) y PostgreSQL**, diseñada para que la coordinación académica pueda monitorear el rendimiento, reprobación y asistencia estudiantil.

### 📂 Estructura del Proyecto

- **/frontend:** Aplicación Next.js (App Router) para la visualización de reportes.

- **/backend:** Scripts de base de datos SQL (Schema, Seeds, Views, Indices, Roles).

- **docker-compose.yml:** Orquestación de servicios (Next.js + Postgres).

### 🚀 Despliegue Rápido

Para levantar la solución completa (Base de datos + App), ejecuta el siguiente comando en la raíz:

```Bash
docker compose up --build
```

### 🛠️ Base de Datos y Reportes

La solución implementa una base de datos con 7 tablas relacionadas y una capa de seguridad basada en VIEWS.

#### Reportes Implementados (VIEWS)

1. Promedio por Grupo: Cálculo de asistencia utilizando CASE y COALESCE.

2. Rendimiento por Curso: Identificación de reprobación mediante agregados.

3. Carga Docente: Análisis de grupos y alumnos por profesor utilizando HAVING.

4. Alumnos en Riesgo: Identificación proactiva mediante CTE (Common Table Expressions).

5. Ranking Académico: Clasificación por programa usando Window Functions (RANK).

Optimización (Índices)

Se han implementado índices estratégicos en:

- Búsqueda de alumnos (Nombre/Email).

- Filtros por periodo académico (term).

- Llaves foráneas de inscripciones.

### 🔐 Seguridad (Roles)

Siguiendo los principios de privilegios mínimos, la aplicación no se conecta como superusuario (postgres).

**Usuario:** app_user.

**Restricción:** Solo posee permisos SELECT sobre las VIEWS. Tiene prohibido el acceso directo a las tablas base.

## 👨‍💻 Autor

- **Luis Antonio Selvas De Leon**
- Fecha: Febrero 2026
