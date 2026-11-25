import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/database.dart';
import 'package:gestor_tareas_local/main.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.conEjecutor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('La pantalla inicial se muestra sin errores', (tester) async {
    await tester.pumpWidget(
      GestorTareasApp(
        database: db,
        cerrarBaseAlDesmontar: false,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Agregar tarea'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Todavia no hay tareas guardadas'), findsOneWidget);

    // Desmontar el widget y cancelar la suscripción de Drift.
    await tester.pumpWidget(const SizedBox.shrink());

    // Dar tiempo al temporizador de limpieza de Drift.
    await tester.pump(const Duration(milliseconds: 1));
  });
}