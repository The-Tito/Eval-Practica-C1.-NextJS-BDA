import { getStudentsPerformance } from "@/app/actions/reports";
import Link from "next/link";

export const dynamic = "force-dynamic";

export default async function Reporte4Page(props: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  const searchParams = await props.searchParams;
  const student = (searchParams.student as string) || "";
  const page = Number(searchParams.page) || 1;

  const data = await getStudentsPerformance({ student, page });

  return (
    <div className="max-w-6xl mx-auto p-6">
      <Link
        href="/"
        className="text-blue-600 hover:text-blue-800 font-medium mb-4 inline-block transition-colors"
      >
        ← Volver al Dashboard
      </Link>

      <header className="mb-8">
        <h1 className="text-3xl font-bold text-gray-800">
          Reporte 4: Alumnos en Riesgo
        </h1>
        <p className="text-gray-600 mt-2">
          Insight: Listado de alumnos en situación de riesgo académico (Promedio
          &lt; 7.0 o Asistencia &lt; 80%). Herramienta clave para tutoría y
          retención.
        </p>
      </header>

      {/* Formulario de Búsqueda */}
      <form action="/reports/4" method="GET" className="mb-6 flex gap-2">
        <input
          type="text"
          name="student"
          placeholder="Buscar alumno por nombre..."
          defaultValue={student}
          className="border border-gray-300 p-2 rounded-lg w-full md:w-64 text-black bg-white focus:ring-2 focus:ring-red-500 outline-none"
        />
        <input type="hidden" name="page" value="1" />
        <button
          type="submit"
          className="bg-purple-600 text-white px-6 py-2 rounded-lg hover:bg-purple-700 transition-colors font-medium"
        >
          Buscar
        </button>
      </form>

      {/* KPI Destacado */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-red-50 p-6 rounded-lg border border-red-200">
          <h3 className="text-sm font-semibold text-red-700 uppercase tracking-wider">
            Alumnos en Riesgo (Pág. {page})
          </h3>
          <p className="text-4xl font-bold text-red-900 mt-1">{data.length}</p>
        </div>
      </div>

      {/* Tabla de Reporte */}
      <div className="bg-white shadow-lg rounded-xl overflow-hidden border border-gray-200">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                Estudiante
              </th>
              <th className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                Email
              </th>
              <th className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                Promedio Final
              </th>
              <th className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                % Asistencia
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.length > 0 ? (
              data.map((row, index) => (
                <tr key={index} className="hover:bg-red-50 transition-colors">
                  <td className="px-6 py-4 whitespace-nowrap font-medium text-gray-900">
                    {row.nombre}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-600">
                    {row.email}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-right">
                    <span
                      className={`font-bold ${
                        Number(row.promedio_final) < 7
                          ? "text-red-600"
                          : "text-green-600"
                      }`}
                    >
                      {Number(row.promedio_final).toFixed(2)}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-right">
                    <span
                      className={`px-3 py-1 rounded-full text-sm font-bold ${
                        Number(row.porcentaje_asistencia) < 80
                          ? "bg-red-100 text-red-700"
                          : "bg-green-100 text-green-700"
                      }`}
                    >
                      {Number(row.porcentaje_asistencia).toFixed(1)}%
                    </span>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td
                  colSpan={4}
                  className="px-6 py-10 text-center text-gray-400 italic"
                >
                  No se encontraron alumnos con el nombre "{student}"
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Paginación */}
      <div className="mt-6 flex justify-between items-center bg-white p-4 rounded-lg border border-gray-200 shadow-sm">
        <Link
          href={`/reports/4?page=${page > 1 ? page - 1 : 1}&student=${student}`}
          className={`px-4 py-2 rounded-md border text-sm font-medium transition-colors ${
            page <= 1
              ? "bg-gray-50 text-gray-400 pointer-events-none"
              : "hover:bg-gray-100 text-gray-700"
          }`}
        >
          Anterior
        </Link>
        <span className="text-sm font-semibold text-gray-700">
          Página {page}
        </span>
        <Link
          href={`/reports/4?page=${page + 1}&student=${student}`}
          className={`px-4 py-2 rounded-md border text-sm font-medium transition-colors ${
            data.length < 5
              ? "bg-gray-50 text-gray-400 pointer-events-none"
              : "hover:bg-gray-100 text-gray-700"
          }`}
        >
          Siguiente
        </Link>
      </div>
    </div>
  );
}
