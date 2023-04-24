import 'package:flutter/material.dart';
import 'package:fuel_consumption/models/registro_abastecimento.dart';
import 'package:intl/intl.dart';

class ListViewWidget extends StatelessWidget {
  final List<RegistroAbastecimento> dados;
  final int? selectedItem;
  final Function(int) onItemSelected;

  const ListViewWidget({
    Key? key,
    required this.dados,
    required this.selectedItem,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dados.length,
      itemBuilder: (BuildContext context, int index) {
        final RegistroAbastecimento registro = dados[index];

        return ListTile(
          title: Text('${DateFormat('dd/MM/yyyy').format(registro.dataReabastecimento)} - ${registro.combustivel.info.descricao}'),
          subtitle: Text('${NumberFormat.decimalPattern('pt_BR').format(registro.quantidade)} l - ${NumberFormat('#,###').format(registro.kilometragem).toString().replaceAll(',', '.')} km'),
          trailing: Text('R\$ ${registro.valor?.toStringAsFixed(2) ?? ""}'),
          selected: index == selectedItem,
          onTap: () {
            onItemSelected(index);
          },
        );
      },
    );
  }
}
