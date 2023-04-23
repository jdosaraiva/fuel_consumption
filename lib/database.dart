import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:fuel_consumption/models/reabastecimento.dart';
import 'package:fuel_consumption/models/registro_abastecimento.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  print('olá');

  String createTableQuery = "CREATE TABLE IF NOT EXISTS reabastecimento ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "data_reabastecimento DATE NOT NULL,"
      "kilometragem INTEGER NOT NULL,"
      "quantidade DECIMAL(5, 2) NOT NULL,"
      "combustivel VARCHAR(10) NOT NULL,"
      "valor DECIMAL(8, 2)"
      ")";


  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'abastecimento_db.db'),
    onCreate: (db, version) {
      return db.execute(
        createTableQuery,
      );
    },
    version: 1,
  );

  Future<void> insertReabastecimento(Reabastecimento reabastecimento) async {
    final db = await database;
    await db.insert(
      'reabastecimento',
      reabastecimento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Reabastecimento>> getReabastecimentos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reabastecimento');
    return List.generate(maps.length, (i) {
      return Reabastecimento.fromMap(maps[i]);
    });
  }

  Reabastecimento reabastecimento = Reabastecimento(
      id: null, // como o campo id é autoincremento, podemos passar null aqui
      dataReabastecimento: DateTime.now(),
      kilometragem: 10000,
      quantidade: 50.0,
      combustivel: Combustivel.gasolina,
      valor: 200.0
  );

  await insertReabastecimento(reabastecimento);

  List<Reabastecimento> reabastecimentos = await getReabastecimentos();
  Reabastecimento ultimoReabastecimento = reabastecimentos.last;
  print(ultimoReabastecimento);

}
