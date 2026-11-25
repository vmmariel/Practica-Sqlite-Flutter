# Gestor de tareas local

Aplicación Flutter que administra tareas con persistencia en una base de datos
SQLite local, sin servidor ni conexión a internet.

## Tecnología de persistencia

Se eligió **Drift** sobre `drift_flutter` en lugar de `sqflite`.

| Criterio | sqflite | Drift + drift_flutter |
|---|---|---|
| Android / iOS | Sí | Sí |
| Escritorio | Requiere paquetes adicionales | Incluido |
| Web | No soportado | Sí, mediante WebAssembly |
| Consultas | Cadenas SQL sin verificación | Tipadas y verificadas al compilar |
| Reactividad | Consulta manual tras cada escritura | `Stream` que se reemite solo |

La razón determinante fue la web: `sqflite` no la soporta, y el requisito F7 exige
una sola base de código para todos los entornos.

## Esquema

Tabla `tareas`:

| Columna | Tipo SQLite | Notas |
|---|---|---|
| `id` | INTEGER PRIMARY KEY AUTOINCREMENT | Identificador único |
| `titulo` | TEXT NOT NULL | Entre 1 y 200 caracteres |
| `completada` | INTEGER NOT NULL | 0 = pendiente, 1 = completada |
| `creada_en` | INTEGER NOT NULL | Marca de tiempo para ordenar |

SQLite no tiene tipo booleano; Drift representa `completada` como INTEGER
y lo expone como `bool` en Dart.

## Ejecución

```bash
flutter pub get
dart run build_runner build
flutter run -d <dispositivo>
```

## Estado

En desarrollo. Ver el historial de commits.