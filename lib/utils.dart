import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:fuel_consumption/dao/reabastecimento_dao.dart';
import 'package:fuel_consumption/models/registro_abastecimento.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

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

Future<double> calculaConsumo() async {
  double consumo = 13.0;
  ReabastecimentoDao dao = ReabastecimentoDao();
  var reabastecimentos = await dao.findUltimosDois();
  if (reabastecimentos.length == 2) {
    var diferenca = reabastecimentos[0].kilometragem - reabastecimentos[1].kilometragem;
    consumo = (diferenca / reabastecimentos[0].quantidade);
  }
  loggerNoStack.i('#main $reabastecimentos');
  return consumo;
}


DateTime parseDataReabastecimento(List<dynamic> row) {
  final String dataString = row[0];
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final DateTime data = formatter.parse(dataString);
  return data;
}

void main() {
  final listaRegistros = carregarDados();
  loggerNoStack.i('#main $listaRegistros');
}


var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

