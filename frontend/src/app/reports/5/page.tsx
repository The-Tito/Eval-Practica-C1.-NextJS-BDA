import { getRankingStudents, getPrograms } from "@/app/actions/reports";
import Link from "next/link";

export const dynamic = "force-dynamic";

export default async function Reporte5Page(props: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  const searchParams = await props.searchParams;
  const program = (searchParams.program as string) || "";

  const [{ data, topStudent }, programs] = await Promise.all([
    getRankingStudents({ program }),
    getPrograms(),
  ]);

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
          Reporte 5: Ranking de Alumnos
        </h1>
        <p className="text-gray-600 mt-2">
          Insight: Cuadro de honor por carrera y periodo. Muestra a los
          estudiantes destacados para reconocimiento académico (Becas de
          Excelencia).
        </p>
      </header>

      {/* Filtro por Carrera (Tabs) */}
      <div className="mb-8 border-b border-gray-200">
        <nav
          className="-mb-px flex space-x-8 overflow-x-auto"
          aria-label="Tabs"
        >
          <Link
            href="/reports/5"
            className={`whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm ${
              program === ""
                ? "border-yellow-500 text-yellow-600"
                : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
            }`}
          >
            Todas
          </Link>
          {programs.map((p) => (
            <Link
              key={p}
              href={`/reports/5?program=${encodeURIComponent(p)}`}
              className={`whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm ${
                program === p
                  ? "border-yellow-500 text-yellow-600"
                  : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
              }`}
            >
              {p}
            </Link>
          ))}
        </nav>
      </div>

      {/* KPI Destacado */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-yellow-50 p-6 rounded-lg border border-yellow-200">
          <h3 className="text-sm font-semibold text-yellow-700 uppercase tracking-wider">
            Alumno Destacado
          </h3>
          <p className="text-3xl font-bold text-yellow-900 mt-1 truncate">
            {topStudent}
          </p>
        </div>
      </div>

      {/* Tabla de Reporte */}
      <div className="bg-white shadow-lg rounded-xl overflow-hidden border border-gray-200">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-4 text-center text-xs font-bold text-gray-500 uppercase tracking-wider">
                Rank
              </th>
              <th className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                Alumno
              </th>
              <th className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                Carrera
              </th>
              <th className="px-6 py-4 text-center text-xs font-bold text-gray-500 uppercase tracking-wider">
                Periodo
              </th>
              <th className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                Promedio
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.map((row, index) => (
              <tr key={index} className="hover:bg-yellow-50 transition-colors">
                <td className="px-6 py-4 whitespace-nowrap text-center">
                  <span
                    className={`inline-flex items-center justify-center w-8 h-8 rounded-full font-bold ${
                      row.posicion_ranking === 1
                        ? "bg-yellow-100 text-yellow-800 border border-yellow-300"
                        : "bg-gray-100 text-gray-600"
                    }`}
                  >
                    {row.posicion_ranking}
                  </span>
                </td>
                <td className="px-6 py-4 whitespace-nowrap font-medium text-gray-900">
                  {row.alumno}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-gray-600">
                  {row.carrera}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-center text-gray-600">
                  {row.periodo}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-gray-800 font-bold">
                  {Number(row.promedio).toFixed(2)}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
