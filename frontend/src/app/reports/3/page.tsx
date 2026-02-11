import { getCoursePerformance } from "@/app/actions/reports";
import Link from "next/link";

export const dynamic = "force-dynamic";

export default async function Reporte3Page() {
  const { data, promedioGeneral } = await getCoursePerformance();

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
          Reporte 3: Rendimiento Académico
        </h1>
        <p className="text-gray-600 mt-2">
          Insight: Evaluación del rendimiento por curso. Detecta asignaturas con
          altos índices de reprobación ("ALTA REPROBACIÓN") para revisar
          contenidos o metodologías.
        </p>
      </header>

      {/* KPI Destacado */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-indigo-50 p-6 rounded-lg border border-indigo-200">
          <h3 className="text-sm font-semibold text-indigo-700 uppercase tracking-wider">
            Promedio General Global
          </h3>
          <p className="text-4xl font-bold text-indigo-900 mt-1">
            {promedioGeneral.toFixed(2)}
          </p>
        </div>
      </div>

      {/* Tabla de Reporte */}
      <div className="bg-white shadow-lg rounded-xl overflow-hidden border border-gray-200">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                Curso
              </th>
              <th className="px-6 py-4 text-center text-xs font-bold text-gray-500 uppercase tracking-wider">
                Periodo
              </th>
              <th className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                Promedio
              </th>
              <th className="px-6 py-4 text-center text-xs font-bold text-gray-500 uppercase tracking-wider">
                Aprobados
              </th>
              <th className="px-6 py-4 text-center text-xs font-bold text-gray-500 uppercase tracking-wider">
                Reprobados
              </th>
              <th className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                Estatus
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.map((row, index) => (
              <tr key={index} className="hover:bg-indigo-50 transition-colors">
                <td className="px-6 py-4 whitespace-nowrap font-medium text-gray-900">
                  {row.curso}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-center text-gray-600">
                  {row.periodo}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-gray-700 font-bold">
                  {Number(row.promedio_general).toFixed(2)}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-center text-green-600 font-medium">
                  {row.aprobados}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-center text-red-500 font-medium">
                  {row.reprobados}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right">
                  <span
                    className={`px-3 py-1 rounded-full text-xs font-bold ${
                      row.estatus_alerta === "ALTA REPROBACIÓN"
                        ? "bg-red-100 text-red-800 border border-red-200"
                        : "bg-green-100 text-green-800 border border-green-200"
                    }`}
                  >
                    {row.estatus_alerta}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
