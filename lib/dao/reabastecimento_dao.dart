import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fuel_consumption/models/reabastecimento.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ReabastecimentoDao {
  static const String tableSql = '''
    CREATE TABLE IF NOT EXISTS reabastecimento (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data_reabastecimento TEXT NOT NULL,
      kilometragem INTEGER NOT NULL,
      quantidade REAL NOT NULL,
      combustivel TEXT NOT NULL,
      valor REAL
    )
  ''';

  static const String _tableName = 'reabastecimento';

  Future<void> excluiDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), "reabastecimento.db");
    await deleteDatabase(path);
  }

  Future<Database> get _database async {
    return openDatabase(
      join(await getDatabasesPath(), 'reabastecimento.db'),
      onCreate: (db, version) {
        db.execute(tableSql);
      },
      version: 2,
    );
  }

  Future<void> onDatabaseCreated(Database db, int version) async {
    //...

    await db.insert(
      'reabastecimentos',
      {
        'data_reabastecimento': DateTime.now().millisecondsSinceEpoch,
        'kilometragem': 1000,
        'combustivel': 'Gasolina',
        'quantidade': 40,
      },
    );
    await db.insert(
      'reabastecimentos',
      {
        'data_reabastecimento': DateTime.now().millisecondsSinceEpoch,
        'kilometragem': 1500,
        'combustivel': 'Etanol',
        'quantidade': 30,
      },
    );
  }

  Future<int> insert(Reabastecimento reabastecimento) async {
    final Database db = await _database;
    return await db.insert(
      _tableName,
      reabastecimento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Reabastecimento>> findAll() async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Reabastecimento.fromMap(maps[i]);
    });
  }
}