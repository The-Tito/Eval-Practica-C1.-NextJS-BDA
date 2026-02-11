export const dynamic = "force-dynamic";
import { getAttendanceByGroup } from "@/app/actions/reports";
import Link from "next/link";

export default async function Reporte1Page() {
  const { data, asistenciaGlobal } = await getAttendanceByGroup();

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
          Reporte 1: Asistencia por Grupo
        </h1>
        <p className="text-gray-600 mt-2">
          Insight: Análisis detallado del porcentaje de asistencia por periodo
          académico (term). Este reporte permite identificar grupos con
          ausentismo crítico para intervención inmediata.
        </p>
      </header>

      {/* KPI Destacado */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div className="bg-green-50 p-6 rounded-lg border border-green-200">
          <h3 className="text-sm font-semibold text-green-700 uppercase tracking-wider">
            Promedio de Asistencia Global
          </h3>
          <p className="text-4xl font-bold text-green-900 mt-1">
            {asistenciaGlobal.toFixed(1)}%
          </p>
        </div>
      </div>

      {/* Tabla de Reporte */}
      <div className="bg-white shadow-lg rounded-xl overflow-hidden border border-gray-200">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                ID Grupo
              </th>
              <th className="px-6 py-4 text-center text-xs font-bold text-gray-500 uppercase tracking-wider">
                Periodo (Term)
              </th>
              <th className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                Total Registros
              </th>
              <th className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                % Asistencia Promedio
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {data.map((row, index) => (
              <tr key={index} className="hover:bg-blue-50 transition-colors">
                <td className="px-6 py-4 whitespace-nowrap font-semibold text-blue-700">
                  #{row.group_id}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-center text-gray-700">
                  {row.term}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-gray-600">
                  {row.total_registros} clases
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right">
                  <span
                    className={`px-3 py-1 rounded-full text-sm font-bold ${
                      Number(row.asistencia_promedio) < 80
                        ? "bg-red-100 text-red-700"
                        : "bg-green-100 text-green-700"
                    }`}
                  >
                    {Number(row.asistencia_promedio).toFixed(2)}%
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
