-- ============================================
-- SCHEMA.SQL - Definición de Estructura
-- ============================================
-- Nombre: Selvas De leon luis Antonio 
-- Fecha: 31.01.2026
-- ============================================


-- Tabla students ● students(id, name, email, program, enrollment_year)
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    program VARCHAR(255) NOT NULL,
    enrollment_year TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla teachers ● teachers(id, name, email)
CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla courses ● courses(id, code, name, credits)
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    code VARCHAR(255) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    credits DECIMAL(10, 2) NOT NULL CHECK (credits >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla groups ● groups(id, course_id, teacher_id, term)
CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL REFERENCES courses(id) ON DELETE RESTRICT,
    teacher_id INTEGER NOT NULL REFERENCES teachers(id) ON DELETE RESTRICT,
    term INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla enrollment ● enrollments(id, student_id, group_id, enrolled_at)
CREATE TABLE enrollment (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE RESTRICT,
    group_id INTEGER NOT NULL REFERENCES groups(id) ON DELETE RESTRICT,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla grades ● grades(id, enrollment_id, partial1, partial2, final)
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES enrollment(id) ON DELETE RESTRICT,
    partial1 DECIMAL(10, 2) NOT NULL CHECK (partial1 >= 0),
    partial2 DECIMAL(10, 2) NOT NULL CHECK (partial2 >= 0),
    final DECIMAL(10, 2) NOT NULL CHECK (final >= 0)
);

-- Tabla attendance ● attendance(id, enrollment_id, date, present)
CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES enrollment(id) ON DELETE RESTRICT,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    present VARCHAR(20) NOT NULL DEFAULT 'Ausente' 
        CHECK (present IN ('Presente', 'Ausente', 'Justificado', 'Retardo'))
);

