"use server";
import sql from "@/lib/db";
import { z } from "zod";

export async function getAttendanceByGroup() {
  try {
    const data = await sql`
        SELECT
            group_id,
            term,
            total_registros,
            asistencia_promedio_porcentaje AS asistencia_promedio,
            FROM vw_attendance_by_group
        `;
    return data;
  } catch (error) {
    console.error("Error al obtener el reporte 1:", error);
    throw new Error("Error interno al cargar los datos.");
  }
}

const TeacherLoadSchema = z.object({
  teacher: z.string().max(50).optional().default(""),
  page: z.coerce.number().min(1).default(1),
});
export async function getTeacherLoad(params: {
  teacher?: string;
  page?: number;
}) {
  const { teacher, page } = TeacherLoadSchema.parse(params);
  const limit = 5;
  const offset = (page - 1) * limit;

  try {
    const data = await sql`
      SELECT 
      docente,
      periodo,
      total_grupos,
      alumnos_totales,
      promedio_de_grupos,
       FROM w_teacher_load
      WHERE docente ILIKE ${"%" + teacher + "%"}
      ORDER BY promedio_de_grupos DESC
      LIMIT ${limit}
      OFFSET ${offset}
    `;
    return data;
  } catch (error) {
    console.error("Error al obtener el reporte 2:", error);
    throw new Error("Error interno al cargar los datos.");
  }
}

export async function getCoursePerformance() {
  try {
    const data = await sql`
        SELECT
            curso,
            periodo,
            promedio_general,
            aprobados,
            reporbados,
            estatus_alerta
            FROM vw_course_performance
        `;
    return data;
  } catch (error) {
    console.error("Error al obtener el reporte 3:", error);
    throw new Error("Error interno al cargar los datos.");
  }
}

const StudentsLoadSchema = z.object({
  student: z.string().max(50).optional().default(""),
  page: z.coerce.number().min(1).default(1),
});
export async function getStudentsPerformance(params: {
  student?: string;
  page?: number;
}) {
  const { student, page } = StudentsLoadSchema.parse(params);
  const limit = 5;
  const offset = (page - 1) * limit;

  try {
    const data = await sql`
      SELECT 
      nombre,
      email,
      promedio_final,
      procentaje_asistencia,
       FROM vw_students_at_risk
      WHERE nombre ILIKE ${"%" + student + "%"}
      ORDER BY promedio_final DESC
      LIMIT ${limit}
      OFFSET ${offset}
    `;
    return data;
  } catch (error) {
    console.error("Error al obtener el reporte 4:", error);
    throw new Error("Error interno al cargar los datos.");
  }
}

export async function getRankingStudents() {
  try {
    const data = await sql`
      SELECT * FROM vw_rank_students
      ORDER BY alumno ASC, posicion_ranking ASC
    `;
    return data;
  } catch (error) {
    console.error("Error en Reporte 5:", error);
    return [];
  }
}
