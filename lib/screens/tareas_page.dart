import 'package:flutter/material.dart';

import '../data/database.dart';

/// Pantalla principal: alta y consulta de tareas.
///
/// Edicion, cambio de estado y eliminacion se implementan en la siguiente
/// etapa; por ahora conservan el aviso de pendiente.
class TareasPage extends StatefulWidget {
  const TareasPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController _tituloController = TextEditingController();

  /// El Stream se crea una sola vez en initState y NO dentro de build().
  /// Crearlo en build() abriria una consulta nueva en cada redibujado,
  /// que es justo lo que prohibe el requisito F8.
  late final Stream<List<Tarea>> _tareas;

  String? _errorTitulo;

  @override
  void initState() {
    super.initState();
    _tareas = widget.database.observarTareas();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      setState(() => _errorTitulo = 'Escribe un titulo para la tarea');
      return;
    }

    setState(() => _errorTitulo = null);

    try {
      await widget.database.agregarTarea(titulo);
      _tituloController.clear();
    } catch (e) {
      // Un fallo de almacenamiento no debe tirar la aplicacion (F8).
      if (!mounted) return;
      _avisar('No se pudo guardar la tarea: $e');
    }
  }

  void _alternarCompletada(Tarea tarea, bool completada) {
    _avisar('Pendiente: implementar actualizacion de estado');
  }

  void _editarTarea(Tarea tarea) {
    _avisar('Pendiente: implementar edicion de titulo');
  }

  void _eliminarTarea(Tarea tarea) {
    _avisar('Pendiente: implementar eliminacion');
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _agregarTarea(),
              decoration: InputDecoration(
                labelText: 'Nueva tarea',
                border: const OutlineInputBorder(),
                errorText: _errorTitulo,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(child: _buildLista()),
          ],
        ),
      ),
    );
  }

  Widget _buildLista() {
    return StreamBuilder<List<Tarea>>(
      stream: _tareas,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error al leer la base de datos:\n${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tareas = snapshot.data!;

        if (tareas.isEmpty) {
          return const Center(child: Text('Todavia no hay tareas guardadas'));
        }

        return ListView.builder(
          itemCount: tareas.length,
          itemBuilder: (context, index) {
            final tarea = tareas[index];
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: tarea.completada,
                  onChanged: (valor) {
                    if (valor != null) {
                      _alternarCompletada(tarea, valor);
                    }
                  },
                ),
                title: Text(tarea.titulo),
                subtitle: Text('ID: ${tarea.id}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Editar',
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editarTarea(tarea),
                    ),
                    IconButton(
                      tooltip: 'Eliminar',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _eliminarTarea(tarea),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}