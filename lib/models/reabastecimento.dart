import 'package:fuel_consumption/models/registro_abastecimento.dart';
import 'package:intl/intl.dart'; // importando a biblioteca intl para formatação de data

class Reabastecimento {
  int? id;
  late DateTime dataReabastecimento;
  late int kilometragem;
  late double quantidade;
  late Combustivel combustivel;
  double? valor; // o campo valor é do tipo double e pode ser nulo
  double? media;

  Reabastecimento({
    this.id,
    required this.dataReabastecimento,
    required this.kilometragem,
    required this.quantidade,
    required this.combustivel,
    this.valor // o campo valor agora é opcional
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_reabastecimento': dataReabastecimento.toIso8601String(),
      'kilometragem': kilometragem,
      'quantidade': quantidade,
      'combustivel': combustivel.toValue(),
      'valor': valor,
    };
  }

  Reabastecimento.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    dataReabastecimento = DateTime.parse(map['data_reabastecimento']);
    kilometragem = map['kilometragem'];
    quantidade = map['quantidade'].toDouble();
    combustivel = CombustivelExtension.fromString(map['combustivel']);
    valor = map['valor']?.toDouble();
  }

  @override
  String toString() {
    return 'Reabastecimento(id: $id, '
        'dataReabastecimento: ${DateFormat.yMd().format(dataReabastecimento)}, '
        'kilometragem: $kilometragem, '
        'quantidade: $quantidade, '
        'combustivel: ${combustivel.toValue()}, '
        'valor: $valor)';
  }
}
