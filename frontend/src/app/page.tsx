import Link from "next/link";

export default function Home() {
  const reportes = [
    {
      id: 1,
      nombre: "Asistencias por grupo",
      desc: "Promedio de asistencia por grupo y grado.",
    },
    {
      id: 2,
      nombre: "Carga por docente",
      desc: "Listado de informacion de carga por cada docente.",
    },
    {
      id: 3,
      nombre: "Rendimiento en cursos",
      desc: "Resumen del rendimiento obtenido por cada curso",
    },
    {
      id: 4,
      nombre: "Rendimiento por estudiante",
      desc: "Rendimiento obtenido por estudiante",
    },
    {
      id: 5,
      nombre: "Ranking de estudiantes",
      desc: "Ranking de estudiantes apartir de sus calificaciones",
    },
  ];

  return (
    <main className="p-10 bg-gray-50 min-h-screen">
      <h1 className="text-4xl font-extrabold mb-8 text-center text-gray-800">
        Dashboard de Reportes
      </h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {reportes.map((rep) => (
          <Link key={rep.id} href={`/reports/${rep.id}`}>
            <div className="p-6 bg-white rounded-xl shadow hover:shadow-lg transition-all border border-gray-100 cursor-pointer group">
              <h2 className="text-xl font-bold text-blue-600 group-hover:text-blue-800">
                Reporte {rep.id}
              </h2>
              <h3 className="text-lg font-semibold mt-1">{rep.nombre}</h3>
              <p className="text-gray-500 mt-2 text-sm">{rep.desc}</p>
            </div>
          </Link>
        ))}
      </div>
    </main>
  );
}
