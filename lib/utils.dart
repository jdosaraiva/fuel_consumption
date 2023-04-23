import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:fuel_consumption/models/registro_abastecimento.dart';
import 'package:intl/intl.dart';

Future<List<RegistroAbastecimento>> carregarDados() async {
  final csvString = await rootBundle.loadString('assets/data/dados.csv');
  final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);

  return csvTable.skip(1).map((row) {
    DateTime data = parseDataReabastecimento(row);

    final dataReabastecimento = data;
    final kilometragem = row[1];
    final quantidade = double.parse(row[2].replaceAll(',', '.'));
    final combustivel = Combustivel.values.firstWhere((c) => c.toString().split('.').last == row[3]);
    final valor = row[4].isNotEmpty ? double.parse(row[4].replaceAll(',', '.')) : null;

    return RegistroAbastecimento(
      dataReabastecimento: dataReabastecimento,
      kilometragem: kilometragem,
      quantidade: quantidade,
      combustivel: combustivel,
      valor: valor,
    );
  }).toList().reversed.toList();
}

DateTime parseDataReabastecimento(List<dynamic> row) {
  final String dataString = row[0];
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final DateTime data = formatter.parse(dataString);
  return data;
}

void main() {
  final listaRegistros = carregarDados();
  print(listaRegistros);
}
