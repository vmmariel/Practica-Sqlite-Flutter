import 'package:flutter/material.dart';

import '../data/database.dart';

import '../theme/app_theme.dart';

/// Pantalla principal: alta, consulta, edicion, cambio de estado
/// y eliminacion de tareas.
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

  // ---------------------------------------------------------------------
  // Operaciones
  // ---------------------------------------------------------------------

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
      if (!mounted) return;
      _avisar('No se pudo guardar la tarea: $e');
    }
  }

  Future<void> _alternarCompletada(Tarea tarea, bool completada) async {
    try {
      await widget.database.cambiarEstado(tarea.id, completada);
    } catch (e) {
      if (!mounted) return;
      _avisar('No se pudo actualizar el estado: $e');
    }
  }

  Future<void> _editarTarea(Tarea tarea) async {
    final nuevoTitulo = await _pedirNuevoTitulo(tarea);

    // El usuario cancelo, o no cambio nada.
    if (nuevoTitulo == null || nuevoTitulo == tarea.titulo) return;

    try {
      final actualizada =
          await widget.database.actualizarTitulo(tarea.id, nuevoTitulo);

      if (!actualizada && mounted) {
        _avisar('La tarea ya no existe');
      }
    } catch (e) {
      if (!mounted) return;
      _avisar('No se pudo actualizar la tarea: $e');
    }
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    final confirmado = await _confirmarEliminacion(tarea);
    if (confirmado != true) return;

    try {
      final eliminada = await widget.database.eliminarTarea(tarea.id);

      if (!mounted) return;
      _avisar(eliminada ? 'Tarea eliminada' : 'La tarea ya no existe');
    } catch (e) {
      if (!mounted) return;
      _avisar('No se pudo eliminar la tarea: $e');
    }
  }

  // ---------------------------------------------------------------------
  // Dialogos
  // ---------------------------------------------------------------------

    /// Pide un titulo nuevo. Devuelve null si el usuario cancela.
  ///
  /// El dialogo es un widget aparte para que sea el propio dialogo quien
  /// cree y libere su TextEditingController. Liberarlo desde aqui provocaba
  /// que el campo se redibujara con un controlador ya destruido mientras
  /// corria la animacion de cierre.
  Future<String?> _pedirNuevoTitulo(Tarea tarea) {
    return showDialog<String>(
      context: context,
      builder: (_) => _DialogoEditarTarea(tituloInicial: tarea.titulo),
    );
  }

  Future<bool?> _confirmarEliminacion(Tarea tarea) {
    return showDialog<bool>(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text('Eliminar tarea'),
          content: Text(
            'Se eliminara "${tarea.titulo}".\n'
            'Esta accion no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(contextoDialogo).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(contextoDialogo).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  // ---------------------------------------------------------------------
  // Interfaz
  // ---------------------------------------------------------------------

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _agregarTarea(),
              decoration: InputDecoration(
                hintText: 'Nueva tarea',
                errorText: _errorTitulo,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _agregarTarea,
              child: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 28),
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
        final completadas = tareas.where((t) => t.completada).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  'Mis tareas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textoPrincipal,
                  ),
                ),
                if (tareas.isNotEmpty)
                  Text(
                    '$completadas de ${tareas.length} completadas',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textoSecundario,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tareas.isEmpty
                  ? const Center(
                      child: Text(
                        'Todavia no hay tareas guardadas',
                        style: TextStyle(color: AppTheme.textoSecundario),
                      ),
                    )
                  : ListView.separated(
                      itemCount: tareas.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: AppTheme.borde,
                      ),
                      itemBuilder: (context, index) =>
                          _buildFila(tareas[index]),
                    ),
            ),
          ],
        );
      },
    );
  }

  /// Fila de una tarea: marca circular, titulo y acciones.
  ///
  /// Se usan separadores finos en lugar de tarjetas elevadas para
  /// mantener la pantalla plana y sin ruido visual.
  Widget _buildFila(Tarea tarea) {
    final completada = tarea.completada;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Marca circular en lugar del Checkbox cuadrado de Material.
          InkWell(
            onTap: () => _alternarCompletada(tarea, !completada),
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completada ? AppTheme.malva : Colors.transparent,
                  border: Border.all(
                    color: completada
                        ? AppTheme.malva
                        : AppTheme.rosaEmpolvado,
                    width: 1.5,
                  ),
                ),
                child: completada
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              tarea.titulo,
              style: TextStyle(
                fontSize: 15,
                height: 1.3,
                color: completada
                    ? AppTheme.textoSecundario
                    : AppTheme.textoPrincipal,
                decoration: completada
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: AppTheme.textoSecundario,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Editar',
            iconSize: 19,
            color: AppTheme.textoSecundario,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _editarTarea(tarea),
          ),
          IconButton(
            tooltip: 'Eliminar',
            iconSize: 19,
            color: AppTheme.textoSecundario,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _eliminarTarea(tarea),
          ),
        ],
      ),
    );
  }
}

/// Dialogo para editar el titulo de una tarea.
///
/// Es un StatefulWidget propio porque posee un TextEditingController:
/// asi el controlador se libera en su dispose(), cuando el dialogo
/// realmente desaparece del arbol de widgets.
class _DialogoEditarTarea extends StatefulWidget {
  const _DialogoEditarTarea({required this.tituloInicial});

  final String tituloInicial;

  @override
  State<_DialogoEditarTarea> createState() => _DialogoEditarTareaState();
}

class _DialogoEditarTareaState extends State<_DialogoEditarTarea> {
  late final TextEditingController _controlador;
  final GlobalKey<FormState> _claveFormulario = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController(text: widget.tituloInicial);
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_claveFormulario.currentState!.validate()) {
      Navigator.of(context).pop(_controlador.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar tarea'),
      content: Form(
        key: _claveFormulario,
        child: TextFormField(
          controller: _controlador,
          autofocus: true,
          maxLength: 200,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _guardar(),
          decoration: const InputDecoration(
            labelText: 'Titulo',
            border: OutlineInputBorder(),
          ),
          validator: (valor) {
            if (valor == null || valor.trim().isEmpty) {
              return 'El titulo no puede estar vacio';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}