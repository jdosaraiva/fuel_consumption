import 'package:flutter/material.dart';
import 'package:fuel_consumption/dao/reabastecimento_dao.dart';
import 'package:fuel_consumption/models/reabastecimento.dart';
import 'package:fuel_consumption/models/registro_abastecimento.dart';
import 'package:intl/intl.dart';

class ReabastecimentoList extends StatefulWidget {
  const ReabastecimentoList({Key? key}) : super(key: key);

  @override
  _ReabastecimentoListState createState() => _ReabastecimentoListState();
}

class _ReabastecimentoListState extends State<ReabastecimentoList> {
  final _dao = ReabastecimentoDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Reabastecimentos'),
      ),
      body: FutureBuilder<List<Reabastecimento>>(
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('Erro ao carregar a lista'));
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                final reabastecimentos = snapshot.data!;
                return ListView.builder(
                  itemCount: reabastecimentos.length,
                  itemBuilder: (context, index) {
                    final reabastecimento = reabastecimentos[index];
                    final dataFormatada = DateFormat('dd/MM/yyyy')
                        .format(reabastecimento.dataReabastecimento);
                    return ListTile(
                      title: Text('$dataFormatada - ${reabastecimento.kilometragem} Km'),
                      subtitle: Text('${reabastecimento.combustivel.info.descricao} - ${reabastecimento.quantidade} litros'),
                    );
                  },
                );
              } else {
                return Center(child: Text('Lista vazia'));
              }
          }
        },
      ),
    );
  }
}
