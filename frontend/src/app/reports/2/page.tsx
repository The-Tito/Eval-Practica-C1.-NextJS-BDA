import { getTeacherLoad } from "@/app/actions/reports";
import Link from "next/link";

export const dynamic = "force-dynamic";

export default async function Reporte2Page(props: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  //  Extraer y normalizar parámetros de búsqueda (URL)
  const searchParams = await props.searchParams;
  const teacher = (searchParams.teacher as string) || "";
  const page = Number(searchParams.page) || 1;

  // Llamar al Server Action con los parámetros
  const { totalAlumnos, data } = await getTeacherLoad({ teacher, page });

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
          Reporte 2: Carga de Trabajo Docente
        </h1>
        <p className="text-gray-600 mt-2">
          Insight: Análisis de la carga académica por docente. Identifica la
          distribución de grupos y el alcance total de estudiantes por profesor
          para equilibrar asignaciones.
        </p>
      </header>

      {/* Formulario de Búsqueda */}
      <form action="/reports/2" method="GET" className="mb-6 flex gap-2">
        <input
          type="text"
          name="teacher"
          placeholder="Buscar docente..."
          defaultValue={teacher}
          className="border border-gray-300 p-2 rounded-lg w-full md:w-64 text-black bg-white focus:ring-2 focus:ring-purple-500 outline-none"
        />
        {/* Reiniciamos a la página 1 en cada búsqueda nueva */}
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
        <div className="bg-purple-50 p-6 rounded-lg border border-purple-200 shadow-sm">
          <h3 className="text-sm font-semibold text-purple-700 uppercase tracking-wider">
            Alumnos Atendidos (Pág. {page})
          </h3>
          <p className="text-4xl font-bold text-purple-900 mt-1">
            {totalAlumnos}
          </p>
        </div>
      </div>

      {/* Tabla de Reporte */}
      <div className="bg-white shadow-lg rounded-xl overflow-hidden border border-gray-200">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                Docente
              </th>
              <th className="px-6 py-4 text-center text-xs font-bold text-gray-500 uppercase tracking-wider">
                Periodo
              </th>
              <th className="px-6 py-4 text-center text-xs font-bold text-gray-500 uppercase tracking-wider">
                Grupos
              </th>
              <th className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                Alumnos
              </th>
              <th className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                Promedio Grupal
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.length > 0 ? (
              data.map((row, index) => (
                <tr
                  key={index}
                  className="hover:bg-purple-50 transition-colors"
                >
                  <td className="px-6 py-4 whitespace-nowrap font-medium text-gray-900">
                    {row.docente}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-center text-gray-600">
                    {row.periodo}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-center text-gray-600 font-medium">
                    {row.total_grupos}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-right text-purple-700 font-semibold">
                    {row.alumnos_totales}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-right text-gray-600">
                    {Number(row.promedio_de_grupos).toFixed(2)}
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td
                  colSpan={5}
                  className="px-6 py-10 text-center text-gray-400 italic"
                >
                  No se encontraron resultados para "{teacher}"
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Paginación */}
      <div className="mt-6 flex justify-between items-center bg-white p-4 rounded-lg border border-gray-200 shadow-sm">
        <Link
          href={`/reports/2?page=${page > 1 ? page - 1 : 1}&teacher=${teacher}`}
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
          href={`/reports/2?page=${page + 1}&teacher=${teacher}`}
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
