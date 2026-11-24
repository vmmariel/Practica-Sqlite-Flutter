/// Modelo inicial de tarea. No contiene código de SQLite.
/// Investiga cómo representar estos campos en una tabla persistente.
class Tarea {
  final int id;
  final String titulo;
  final bool completada;

  const Tarea({
    required this.id,
    required this.titulo,
    required this.completada,
  });
}
