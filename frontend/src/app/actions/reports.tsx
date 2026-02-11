"use server";
import sql from "@/lib/db";
import { adapter } from "next/dist/server/web/adapter";
import { z } from "zod";
import { da } from "zod/locales";

export async function getAttendanceByGroup() {
  try {
    const data = await sql`
        SELECT
            group_id,
            term,
            total_registros,
            asistencia_promedio_porcentaje AS asistencia_promedio
            FROM vw_attendance_by_group
        `;

    const asistenciaGlobal =
      data.length > 0
        ? data.reduce(
            (acc, curr) => acc + Number(curr.asistencia_promedio),
            0,
          ) / data.length
        : 0;

    return { data, asistenciaGlobal };
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
      promedio_de_sus_grupos AS promedio_de_grupos
       FROM vw_teacher_load
      WHERE docente ILIKE ${"%" + teacher + "%"}
      ORDER BY promedio_de_grupos DESC
      LIMIT ${limit}
      OFFSET ${offset}
    `;
    const totalAlumnos = data.reduce(
      (acc, curr) => acc + Number(curr.alumnos_totales),
      0,
    );
    return { totalAlumnos, data };
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
            aprobados,
            reprobados,
            estatus_alerta
            FROM vw_course_performance
        `;
    const promedioGeneral =
      data.length > 0
        ? data.reduce((acc, curr) => acc + Number(curr.promedio_general), 0) /
          data.length
        : 0;
    return { promedioGeneral, data };
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
      promedio_final,
      porcentaje_asistencia
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

export async function getRankingStudents(params?: { program?: string }) {
  const program = params?.program || "";
  try {
    const data = await sql`
      SELECT * FROM vw_rank_students
      WHERE carrera ILIKE ${"%" + program + "%"}
      ORDER BY carrera ASC, periodo DESC, posicion_ranking ASC
    `;
    // KPI: Mejor alumno (Rank 1)
    const topStudent = data.length > 0 ? (data[0].alumno as string) : "N/A";

    return { data, topStudent };
  } catch (error) {
    console.error("Error en Reporte 5:", error);
    return { data: [], topStudent: "N/A" };
  }
}

export async function getPrograms() {
  try {
    const data = await sql`
      SELECT DISTINCT carrera FROM vw_rank_students ORDER BY carrera ASC
    `;
    return data.map((row) => row.carrera as string);
  } catch (error) {
    console.error("Error al obtener carreras:", error);
    return [];
  }
}
