# Gestor de tareas local

Aplicación Flutter que administra tareas con persistencia en una base de datos
**SQLite local**, sin servidor, sin API REST y sin conexión a internet.

## Tecnología de persistencia

Se eligió **Drift** junto con **drift_flutter** en lugar de `sqflite`.

| Criterio | sqflite | Drift + drift_flutter |
|---|---|---|
| Android / iOS | Sí | Sí |
| Escritorio (Windows, Linux, macOS) | Requiere paquetes adicionales | Incluido |
| Web | No soportado | Sí, mediante WebAssembly |
| Consultas | Cadenas SQL sin verificación | Tipadas y verificadas al compilar |
| Reactividad | Consulta manual tras cada escritura | `Stream` que se reemite solo |

La razón determinante fue la web: `sqflite` no la soporta, y el requisito de
multiplataforma exige una sola base de código. `driftDatabase()` resuelve la
ruta de almacenamiento de cada plataforma, por lo que **no existe ninguna
condicional por plataforma en `lib/`**.

## Esquema de la base de datos

Tabla `tareas`:

| Columna | Tipo SQLite | Notas |
|---|---|---|
| `id` | INTEGER PRIMARY KEY AUTOINCREMENT | Identificador único, no reutilizado |
| `titulo` | TEXT NOT NULL | Entre 1 y 200 caracteres |
| `completada` | INTEGER NOT NULL | 0 = pendiente, 1 = completada |
| `creada_en` | INTEGER NOT NULL | Marca de tiempo, para ordenar |

SQLite no tiene tipo booleano: Drift almacena `completada` como INTEGER y lo
expone como `bool` en Dart.

## Organización del código

```
lib/
├── main.dart                  Arranque, tema e inyección de la base de datos
├── data/
│   ├── database.dart          Tabla, AppDatabase y operaciones CRUD
│   └── database.g.dart        Generado por build_runner (no editar)
├── theme/
│   └── app_theme.dart         Paleta Mauve Minimal y estilos de la app
└── screens/
    └── tareas_page.dart       Interfaz: lista reactiva y diálogos
web/
├── sqlite3.wasm               Motor SQLite para el navegador
└── drift_worker.dart.js       Worker de Drift (release drift-2.35.4)
test/
├── database_test.dart         Pruebas de la capa de persistencia
└── widget_test.dart           Pruebas de interfaz
```

La interfaz nunca consulta la base dentro de `build()`: el `Stream` se crea una
sola vez en `initState()` y se consume con `StreamBuilder`. La base se cierra en
`dispose()`.

## Ejecución

```bash
flutter pub get
dart run build_runner build
flutter test

flutter run -d windows
flutter run -d chrome --web-port=8080
```

> En web es necesario fijar el puerto. El navegador aísla el almacenamiento por
> origen, y el puerto forma parte del origen: sin `--web-port` cada ejecución
> usaría un almacén distinto y parecería que los datos se perdieron.

### Recursos de WebAssembly

`web/sqlite3.wasm` y `web/drift_worker.dart.js` provienen de la release
[drift-2.35.4](https://github.com/simolus3/drift/releases/tag/drift-2.35.4),
la misma versión de `drift` registrada en `pubspec.lock`. Deben actualizarse
junto con el paquete.

## Identidad visual

La interfaz usa una paleta propia, **Mauve Minimal**: neutros cálidos con
malvas y rosas empolvados, definida en `lib/theme/app_theme.dart`.

| Uso | Color |
|---|---|
| Acento principal | `#7E5E85` |
| Rosa empolvado | `#C9A9B4` |
| Fondo | `#FAF7F9` |
| Superficie | `#FFFFFF` |
| Borde | `#E9E1E6` |
| Texto principal | `#2E2930` |
| Texto secundario | `#786E7C` |
| Error | `#A8536B` |

Decisiones de diseño: superficies planas y separadores de 0.5 px en lugar de
tarjetas elevadas; marca circular propia en vez del `Checkbox` cuadrado de
Material, con tachado y atenuación al completar; contador de progreso en el
encabezado. El tema está centralizado en un solo archivo, de modo que la capa
visual no toca la lógica de persistencia.

## Plataformas verificadas

| Entorno | Plataforma | Estado |
|---|---|---|
| Escritorio | Windows 11 | Verificado: P1–P5 |
| Web | Chrome 158 (`localhost:8080`) | Verificado: P6 y CRUD completo |
| Móvil | Android | Previsto, no verificado (ver nota) |

**Nota sobre Android:** no se verificó en ejecución por no disponer de
dispositivo físico ni de un emulador configurado a tiempo en el equipo de
desarrollo. El soporte está contemplado en el diseño: la carpeta `android/`
conserva la configuración generada por Flutter, `drift_flutter` registra el
plugin nativo de SQLite, y no hay código específico de plataforma en `lib/`.

## Resultados de las pruebas manuales

| ID | Acción | Resultado |
|---|---|---|
| P1 | Agregar tres tareas, cerrar y reabrir | Permanecen las tres |
| P2 | Marcar completada y reiniciar | Se conserva el estado |
| P3 | Cambiar el título y reiniciar | Aparece el nuevo título |
| P4 | Eliminar una tarea y reiniciar | No reaparece |
| P5 | Agregar con título vacío | Rechazado, no se registra |
| P6 | Web: recargar y cerrar/abrir pestaña | Los datos permanecen |

En web, la consola informa la implementación de almacenamiento elegida por el
navegador: `WasmStorageImplementation.sharedIndexedDb`.

## Pruebas automatizadas

```bash
flutter test
```

**14 pruebas, todas en verde.**

- `database_test.dart` cubre la validación de títulos (vacío, solo espacios,
  recorte de espacios, renombrado inválido), el ciclo completo de alta,
  consulta, edición, cambio de estado y eliminación, el caso de un `id`
  inexistente, y que el `Stream` se reemite tras cada escritura.
- `widget_test.dart` cubre el arranque de la pantalla, el rechazo de un título
  vacío desde la interfaz y el alta visible en la lista.

Ambas usan `NativeDatabase.memory()`: el mismo motor SQLite que en producción,
sobre una base temporal en memoria, de modo que cada prueba arranca limpia.