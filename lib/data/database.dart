import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Tabla de tareas.
///
/// Drift traduce esta clase a una sentencia CREATE TABLE. El nombre de la
/// tabla en SQLite sera `tareas` (Drift convierte el nombre de la clase a
/// snake_case automaticamente).
class Tareas extends Table {
  /// Identificador unico. `autoIncrement()` lo declara como
  /// INTEGER PRIMARY KEY AUTOINCREMENT: SQLite asigna el valor y garantiza
  /// que no se repita, incluso despues de eliminar filas.
  IntColumn get id => integer().autoIncrement()();

  /// Titulo de la tarea. Se restringe la longitud en el propio esquema para
  /// que la validacion no dependa unicamente de la interfaz.
  TextColumn get titulo => text().withLength(min: 1, max: 200)();

  /// Estado de la tarea. SQLite no tiene tipo booleano: Drift lo almacena
  /// como INTEGER (0 = pendiente, 1 = completada) y lo expone como bool.
  BoolColumn get completada => boolean().withDefault(const Constant(false))();

  /// Momento de creacion, para poder ordenar la lista de forma estable.
  DateTimeColumn get creadaEn => dateTime().withDefault(currentDateAndTime)();
}

/// Base de datos de la aplicacion.
@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_abrirConexion());

  /// Constructor alterno que recibe un ejecutor ya construido.
  /// Se usa en las pruebas para trabajar contra una base en memoria.
  AppDatabase.conEjecutor(super.ejecutor);

  @override
  int get schemaVersion => 1;

  /// Observa la lista completa de tareas.
  ///
  /// Devuelve un Stream: Drift vuelve a emitir la lista cada vez que la tabla
  /// cambia, sin que la interfaz tenga que volver a consultar manualmente.
  /// Las pendientes aparecen primero y, dentro de cada grupo, las mas
  /// recientes arriba.
  Stream<List<Tarea>> observarTareas() {
    return (select(tareas)
          ..orderBy([
            (t) => OrderingTerm(expression: t.completada),
            (t) => OrderingTerm(
                  expression: t.creadaEn,
                  mode: OrderingMode.desc,
                ),
          ]))
        .watch();
  }

  /// Inserta una tarea nueva y devuelve el id asignado por SQLite.
  ///
  /// Lanza [ArgumentError] si el titulo esta vacio o solo tiene espacios.
  Future<int> agregarTarea(String titulo) {
    final limpio = titulo.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El titulo no puede estar vacio');
    }
    return into(tareas).insert(TareasCompanion.insert(titulo: limpio));
  }

    /// Cambia el titulo de una tarea existente.
  ///
  /// Devuelve true si se modifico alguna fila. Un false significa que el id
  /// ya no existe en la base, por ejemplo si la tarea se elimino desde otra
  /// ventana mientras el dialogo estaba abierto.
  Future<bool> actualizarTitulo(int id, String titulo) async {
    final limpio = titulo.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El titulo no puede estar vacio');
    }

    final filasAfectadas = await (update(tareas)..where((t) => t.id.equals(id)))
        .write(TareasCompanion(titulo: Value(limpio)));

    return filasAfectadas > 0;
  }

  /// Marca una tarea como completada o pendiente.
  Future<bool> cambiarEstado(int id, bool completada) async {
    final filasAfectadas = await (update(tareas)..where((t) => t.id.equals(id)))
        .write(TareasCompanion(completada: Value(completada)));

    return filasAfectadas > 0;
  }

  /// Elimina una tarea por su identificador.
  Future<bool> eliminarTarea(int id) async {
    final filasAfectadas =
        await (delete(tareas)..where((t) => t.id.equals(id))).go();

    return filasAfectadas > 0;
  }

  /// Abre la base persistente en la ubicacion adecuada de cada plataforma.
  ///
  /// `driftDatabase` resuelve por si solo la ruta en Android, iOS, Windows,
  /// Linux y macOS, y en web usa WebAssembly. Por eso el resto del codigo
  /// no necesita ninguna condicional por plataforma.
  static QueryExecutor _abrirConexion() {
    return driftDatabase(
      name: 'gestor_tareas',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }
}