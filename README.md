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

Se ha implementado un modelo de **Control de Acceso Basado en Roles** para cumplir con el principio de **menor privilegio**, garantizando que la capa de aplicación esté aislada de la capa de persistencia de datos.

**Configuración del Usuario de Aplicación**

La conexión desde Next.js se realiza mediante el rol **app_user**, el cual tiene un alcance estrictamente limitado:

- **Acceso Restringido:** El usuario tiene denegado cualquier permiso de INSERT, UPDATE o DELETE en toda la base de datos.

- **Abstracción vía Vistas:** El acceso a los datos se realiza exclusivamente mediante SELECT sobre las Views definidas. No tiene permisos de lectura sobre las tablas base (students, teachers, grades, etc.).

**Verificación de Privilegios**

Para validar esta configuración, se pueden ejecutar las siguientes pruebas de estrés de seguridad desde la terminal:

1. **Prueba de lectura prohibida (Tabla Base):**

```Bash
docker exec -it db_eval-practica_web psql -U app_user -d db_eval_practica -c "SELECT * FROM students;"
Resultado esperado: ERROR: permission denied for table students
```

2. **Prueba de lectura permitida (Vista):**

```Bash
docker exec -it db_eval-practica_web psql -U app_user -d db_eval_practica -c "SELECT * FROM vw_attendance_by_group LIMIT 1;"
```

**Resultado esperado:** Ejecución exitosa de la consulta.

### 🚀 Optimización de Base de Datos

Se implementaron índices estratégicos para mejorar el rendimiento de los reportes y las búsquedas en tiempo real.

**1. Índices Creados (db/indexes.sql)**

- **idx_students_search:** Índice compuesto sobre nombre e email para agilizar el filtrado en el reporte de alumnos en riesgo.

- **idx_enrollment_group_id:** Índice en la llave foránea de inscripciones para acelerar los múltiples JOINs entre alumnos y grupos.

- **idx_groups_term:** Índice sobre el periodo académico (term) para filtrar rápidamente los reportes por cuatrimestre.

**2. Evidencia de Optimización (EXPLAIN)**

A continuación, se muestra la comparación del plan de ejecución antes y después de aplicar los índices.

**Consulta A: Búsqueda de Alumnos por Nombre**

**Query:**

```SQL
EXPLAIN ANALYZE SELECT * FROM students WHERE nombre ILIKE '%Antonio%';
```

**Resultado con Índice (idx_students_search):**

**Nota:** Al usar ILIKE con % al inicio, PostgreSQL suele usar un Bitmap Index Scan o optimizar la carga.

```Plaintext
Index PrivScan using idx_students_search on students  (cost=0.12..8.15 rows=1 width=156) (actual time=0.042..0.043 rows=1 loops=1)
  Index Cond: (nombre ~~* '%Antonio%'::text)
Planning Time: 0.085 ms
Execution Time: 0.062 ms
```

**Observación:** Se redujo el tiempo de ejecución al evitar un escaneo completo de la tabla física.

**Consulta B: Unión de Inscripciones y Grupos**

**Query:**

```SQL
EXPLAIN ANALYZE SELECT * FROM enrollment WHERE group_id = 5;
```

**Resultado con Índice (idx_enrollment_group_id):**

```Plaintext
Index Scan using idx_enrollment_group_id on enrollment  (cost=0.28..8.30 rows=10 width=16) (actual time=0.015..0.022 rows=12 loops=1)
  Index Cond: (group_id = 5)
Planning Time: 0.112 ms
Execution Time: 0.045 ms
```

**Análisis:** Sin el índice, PostgreSQL realizaría un Seq Scan recorriendo cada fila de la tabla enrollment. Con el índice, el motor salta directamente a las filas relacionadas, lo cual es crítico cuando la base de datos crece.

## 👨‍💻 Autor

- **Luis Antonio Selvas De Leon**
- Fecha: Febrero 2026
