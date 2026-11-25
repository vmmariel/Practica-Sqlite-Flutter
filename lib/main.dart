
import 'package:flutter/material.dart';

import 'data/database.dart';
import 'screens/tareas_page.dart';

void main() {
  // Necesario porque drift_flutter consulta rutas de la plataforma
  // antes de que se dibuje el primer widget.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GestorTareasApp(database: AppDatabase()),
  );
}

/// Punto de entrada de la aplicación.
///
/// Es un StatefulWidget para poder cerrar la base de datos
/// cuando se desmonta la aplicación.
class GestorTareasApp extends StatefulWidget {
  const GestorTareasApp({
    super.key,
    required this.database,
    this.cerrarBaseAlDesmontar = true,
  });

  /// Base de datos que se utilizará en la aplicación.
  final AppDatabase database;

  /// Permite controlar si se cierra la base de datos al desmontar.
  /// Es útil para las pruebas con bases de datos en memoria.
  final bool cerrarBaseAlDesmontar;

  @override
  State<GestorTareasApp> createState() => _GestorTareasAppState();
}

class _GestorTareasAppState extends State<GestorTareasApp> {
  @override
  void dispose() {
    if (widget.cerrarBaseAlDesmontar) {
      widget.database.close();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: TareasPage(database: widget.database),
    );
  }
}
