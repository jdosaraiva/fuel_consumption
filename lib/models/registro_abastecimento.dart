import 'package:intl/intl.dart'; // importando a biblioteca intl para formatação de data

enum Combustivel {
  gasolina,
  etanol,
  gnv,
  outro
}

class CombustivelInfo {
  final String descricao;

  const CombustivelInfo(this.descricao);
}

extension CombustivelExtension on Combustivel {
  CombustivelInfo get info {
    switch (this) {
      case Combustivel.gasolina:
        return const CombustivelInfo("Gasolina");
      case Combustivel.etanol:
        return const CombustivelInfo("Etanol");
      case Combustivel.gnv:
        return const CombustivelInfo("GNV");
      case Combustivel.outro:
        return const CombustivelInfo("Outro");
    }
  }

  String toValue() {
    return toString().split('.').last;
  }

  static Combustivel fromString(String value) {
    return Combustivel.values.firstWhere(
            (e) => e.toString().split('.').last == value,
        orElse: () => Combustivel.outro
    );
  }
}

class RegistroAbastecimento {
  DateTime dataReabastecimento;
  int kilometragem;
  double quantidade;
  Combustivel combustivel;
  double? valor; // o campo valor é do tipo double e pode ser nulo

  RegistroAbastecimento({
    required this.dataReabastecimento,
    required this.kilometragem,
    required this.quantidade,
    required this.combustivel,
    this.valor // o campo valor agora é opcional
  });

  String get dataFormatada {
    // formatando a data no formato "dd/MM/yyyy"
    return DateFormat('dd/MM/yyyy').format(dataReabastecimento);
  }
}


void main() {
  Combustivel combustivel = Combustivel.gasolina;
  print(combustivel.info.descricao); // imprime "Gasolina"
}