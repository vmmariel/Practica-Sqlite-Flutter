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

  /// Monta la aplicacion con la base en memoria.
  ///
  /// Se pide no cerrar la base al desmontar porque de eso se encarga
  /// el tearDown; cerrarla dos veces deja trabajo asincrono pendiente.
  Future<void> montarApp(WidgetTester tester) async {
    await tester.pumpWidget(
      GestorTareasApp(database: db, cerrarBaseAlDesmontar: false),
    );
    await tester.pumpAndSettle();
  }

  /// Desmonta el arbol y da margen a Drift para cancelar su suscripcion.
  Future<void> desmontarApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('La pantalla inicial se muestra sin errores', (tester) async {
    await montarApp(tester);

    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Agregar tarea'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Todavia no hay tareas guardadas'), findsOneWidget);

    await desmontarApp(tester);
  });

  testWidgets('No registra una tarea con titulo vacio', (tester) async {
    await montarApp(tester);

    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Escribe un titulo para la tarea'), findsOneWidget);
    
    expect(find.text('Todavia no hay tareas guardadas'), findsOneWidget);

    await desmontarApp(tester);
  });

  testWidgets('Agrega una tarea y la muestra en la lista', (tester) async {
    await montarApp(tester);

    await tester.enterText(find.byType(TextField), 'Comprar pan');
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();

    expect(find.text('Comprar pan'), findsOneWidget);
    expect(find.text('Todavia no hay tareas guardadas'), findsNothing);

    

    await desmontarApp(tester);
  });
}