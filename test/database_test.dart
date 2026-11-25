import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/database.dart';

/// Pruebas de la capa de persistencia.
///
/// Se usa NativeDatabase.memory(): es el mismo motor SQLite que en
/// produccion, pero sobre una base temporal en memoria. Asi cada prueba
/// arranca limpia y no deja archivos en el disco.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.conEjecutor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Validacion de titulos', () {
    test('rechaza un titulo vacio', () {
      expect(() => db.agregarTarea(''), throwsArgumentError);
    });

    test('rechaza un titulo formado solo por espacios', () {
      expect(() => db.agregarTarea('     '), throwsArgumentError);
    });

    test('recorta los espacios al guardar', () async {
      await db.agregarTarea('   Comprar pan   ');

      final tareas = await db.observarTareas().first;
      expect(tareas.single.titulo, 'Comprar pan');
    });

    test('rechaza renombrar una tarea a un titulo vacio', () async {
      final id = await db.agregarTarea('Titulo valido');

      await expectLater(
        db.actualizarTitulo(id, '  '),
        throwsArgumentError,
      );
    });
  });

  group('Operaciones de almacenamiento', () {
    test('guarda una tarea y la devuelve en la consulta', () async {
      final id = await db.agregarTarea('Estudiar SQLite');

      final tareas = await db.observarTareas().first;
      expect(tareas, hasLength(1));
      expect(tareas.single.id, id);
      expect(tareas.single.titulo, 'Estudiar SQLite');
      expect(tareas.single.completada, isFalse);
    });

    test('cambia el estado y lo conserva', () async {
      final id = await db.agregarTarea('Revisar pendientes');

      expect(await db.cambiarEstado(id, true), isTrue);

      final tareas = await db.observarTareas().first;
      expect(tareas.single.completada, isTrue);
    });

    test('actualiza el titulo de una tarea existente', () async {
      final id = await db.agregarTarea('Titulo original');

      expect(await db.actualizarTitulo(id, 'Titulo corregido'), isTrue);

      final tareas = await db.observarTareas().first;
      expect(tareas.single.titulo, 'Titulo corregido');
    });

    test('elimina una tarea por su id y no vuelve a aparecer', () async {
      final id = await db.agregarTarea('Tarea temporal');

      expect(await db.eliminarTarea(id), isTrue);
      expect(await db.observarTareas().first, isEmpty);
    });

    test('informa cuando el id no existe', () async {
      expect(await db.eliminarTarea(9999), isFalse);
      expect(await db.cambiarEstado(9999, true), isFalse);
      expect(await db.actualizarTitulo(9999, 'Nada'), isFalse);
    });

    test('asigna identificadores distintos a cada tarea', () async {
      final primera = await db.agregarTarea('Primera');
      final segunda = await db.agregarTarea('Segunda');

      expect(primera, isNot(equals(segunda)));
    });

    test('el Stream se reemite despues de cada escritura', () async {
      final emisiones = <int>[];
      final suscripcion =
          db.observarTareas().listen((lista) => emisiones.add(lista.length));

      await pumpEventQueue();
      await db.agregarTarea('Primera');
      await pumpEventQueue();
      await db.agregarTarea('Segunda');
      await pumpEventQueue();

      await suscripcion.cancel();

      // Lista vacia, luego con una tarea, luego con dos.
      expect(emisiones, [0, 1, 2]);
    });
  });
}