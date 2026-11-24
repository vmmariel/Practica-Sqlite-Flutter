// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TareasTable extends Tareas with TableInfo<$TareasTable, Tarea> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TareasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completadaMeta = const VerificationMeta(
    'completada',
  );
  @override
  late final GeneratedColumn<bool> completada = GeneratedColumn<bool>(
    'completada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _creadaEnMeta = const VerificationMeta(
    'creadaEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadaEn = GeneratedColumn<DateTime>(
    'creada_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, titulo, completada, creadaEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tareas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tarea> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('completada')) {
      context.handle(
        _completadaMeta,
        completada.isAcceptableOrUnknown(data['completada']!, _completadaMeta),
      );
    }
    if (data.containsKey('creada_en')) {
      context.handle(
        _creadaEnMeta,
        creadaEn.isAcceptableOrUnknown(data['creada_en']!, _creadaEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tarea map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tarea(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      completada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completada'],
      )!,
      creadaEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creada_en'],
      )!,
    );
  }

  @override
  $TareasTable createAlias(String alias) {
    return $TareasTable(attachedDatabase, alias);
  }
}

class Tarea extends DataClass implements Insertable<Tarea> {
  /// Identificador unico. `autoIncrement()` lo declara como
  /// INTEGER PRIMARY KEY AUTOINCREMENT: SQLite asigna el valor y garantiza
  /// que no se repita, incluso despues de eliminar filas.
  final int id;

  /// Titulo de la tarea. Se restringe la longitud en el propio esquema para
  /// que la validacion no dependa unicamente de la interfaz.
  final String titulo;

  /// Estado de la tarea. SQLite no tiene tipo booleano: Drift lo almacena
  /// como INTEGER (0 = pendiente, 1 = completada) y lo expone como bool.
  final bool completada;

  /// Momento de creacion, para poder ordenar la lista de forma estable.
  final DateTime creadaEn;
  const Tarea({
    required this.id,
    required this.titulo,
    required this.completada,
    required this.creadaEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titulo'] = Variable<String>(titulo);
    map['completada'] = Variable<bool>(completada);
    map['creada_en'] = Variable<DateTime>(creadaEn);
    return map;
  }

  TareasCompanion toCompanion(bool nullToAbsent) {
    return TareasCompanion(
      id: Value(id),
      titulo: Value(titulo),
      completada: Value(completada),
      creadaEn: Value(creadaEn),
    );
  }

  factory Tarea.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tarea(
      id: serializer.fromJson<int>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      completada: serializer.fromJson<bool>(json['completada']),
      creadaEn: serializer.fromJson<DateTime>(json['creadaEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titulo': serializer.toJson<String>(titulo),
      'completada': serializer.toJson<bool>(completada),
      'creadaEn': serializer.toJson<DateTime>(creadaEn),
    };
  }

  Tarea copyWith({
    int? id,
    String? titulo,
    bool? completada,
    DateTime? creadaEn,
  }) => Tarea(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    completada: completada ?? this.completada,
    creadaEn: creadaEn ?? this.creadaEn,
  );
  Tarea copyWithCompanion(TareasCompanion data) {
    return Tarea(
      id: data.id.present ? data.id.value : this.id,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      completada: data.completada.present
          ? data.completada.value
          : this.completada,
      creadaEn: data.creadaEn.present ? data.creadaEn.value : this.creadaEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tarea(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('completada: $completada, ')
          ..write('creadaEn: $creadaEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, titulo, completada, creadaEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tarea &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.completada == this.completada &&
          other.creadaEn == this.creadaEn);
}

class TareasCompanion extends UpdateCompanion<Tarea> {
  final Value<int> id;
  final Value<String> titulo;
  final Value<bool> completada;
  final Value<DateTime> creadaEn;
  const TareasCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.completada = const Value.absent(),
    this.creadaEn = const Value.absent(),
  });
  TareasCompanion.insert({
    this.id = const Value.absent(),
    required String titulo,
    this.completada = const Value.absent(),
    this.creadaEn = const Value.absent(),
  }) : titulo = Value(titulo);
  static Insertable<Tarea> custom({
    Expression<int>? id,
    Expression<String>? titulo,
    Expression<bool>? completada,
    Expression<DateTime>? creadaEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (completada != null) 'completada': completada,
      if (creadaEn != null) 'creada_en': creadaEn,
    });
  }

  TareasCompanion copyWith({
    Value<int>? id,
    Value<String>? titulo,
    Value<bool>? completada,
    Value<DateTime>? creadaEn,
  }) {
    return TareasCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      completada: completada ?? this.completada,
      creadaEn: creadaEn ?? this.creadaEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (completada.present) {
      map['completada'] = Variable<bool>(completada.value);
    }
    if (creadaEn.present) {
      map['creada_en'] = Variable<DateTime>(creadaEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TareasCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('completada: $completada, ')
          ..write('creadaEn: $creadaEn')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TareasTable tareas = $TareasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tareas];
}

typedef $$TareasTableCreateCompanionBuilder = TareasCompanion Function({
  Value<int> id,
  required String titulo,
  Value<bool> completada,
  Value<DateTime> creadaEn,
});
typedef $$TareasTableUpdateCompanionBuilder = TareasCompanion Function({
  Value<int> id,
  Value<String> titulo,
  Value<bool> completada,
  Value<DateTime> creadaEn,
});

class $$TareasTableFilterComposer
    extends Composer<_$AppDatabase, $TareasTable> {
  $$TareasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TareasTableOrderingComposer
    extends Composer<_$AppDatabase, $TareasTable> {
  $$TareasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TareasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TareasTable> {
  $$TareasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadaEn =>
      $composableBuilder(column: $table.creadaEn, builder: (column) => column);
}

class $$TareasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TareasTable,
          Tarea,
          $$TareasTableFilterComposer,
          $$TareasTableOrderingComposer,
          $$TareasTableAnnotationComposer,
          $$TareasTableCreateCompanionBuilder,
          $$TareasTableUpdateCompanionBuilder,
          (Tarea, BaseReferences<_$AppDatabase, $TareasTable, Tarea>),
          Tarea,
          PrefetchHooks Function()
        > {
  $$TareasTableTableManager(_$AppDatabase db, $TareasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TareasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TareasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TareasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<bool> completada = const Value.absent(),
                Value<DateTime> creadaEn = const Value.absent(),
              }) => TareasCompanion(
                id: id,
                titulo: titulo,
                completada: completada,
                creadaEn: creadaEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titulo,
                Value<bool> completada = const Value.absent(),
                Value<DateTime> creadaEn = const Value.absent(),
              }) => TareasCompanion.insert(
                id: id,
                titulo: titulo,
                completada: completada,
                creadaEn: creadaEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TareasTable, Tarea>(table),
                  BaseReferences<_$AppDatabase, $TareasTable, Tarea>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TareasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TareasTable,
      Tarea,
      $$TareasTableFilterComposer,
      $$TareasTableOrderingComposer,
      $$TareasTableAnnotationComposer,
      $$TareasTableCreateCompanionBuilder,
      $$TareasTableUpdateCompanionBuilder,
      (Tarea, BaseReferences<_$AppDatabase, $TareasTable, Tarea>),
      Tarea,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TareasTableTableManager get tareas =>
      $$TareasTableTableManager(_db, _db.tareas);
}
