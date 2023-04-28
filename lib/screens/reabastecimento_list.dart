import 'package:flutter/material.dart';
import 'package:fuel_consumption/dao/reabastecimento_dao.dart';
import 'package:fuel_consumption/models/reabastecimento.dart';
import 'package:fuel_consumption/models/registro_abastecimento.dart';
import 'package:intl/intl.dart';

class ReabastecimentoList extends StatefulWidget {
  const ReabastecimentoList({Key? key}) : super(key: key);

  @override
  ReabastecimentoListState createState() => ReabastecimentoListState();
}

class ReabastecimentoListState extends State<ReabastecimentoList> {
  final _dao = ReabastecimentoDao();
  bool selected = false;
  int _selectedIndex = -1;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Reabastecimentos'),
      ),
      body: FutureBuilder<List<Reabastecimento>>(
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Erro ao carregar a lista'));
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
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
                    return GestureDetector(
                      onTap: () {
                        _onItemSelected(index);
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Excluir registro'),
                              content: const Text(
                                  'Tem certeza que deseja excluir este registro?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Não'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Sim'),
                                  onPressed: () async {
                                    try {
                                      await _dao.delete(reabastecimento.id!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Registro excluído com sucesso')));
                                      setState(() {});
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Erro ao excluir registro')));
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        color: _selectedIndex == index ? Colors.lightBlueAccent : null,
                        child: ListTile(
                          selected: selected,
                          title: Text(
                              '$dataFormatada - ${reabastecimento.kilometragem} Km'),
                          subtitle: Text(
                              '${reabastecimento.combustivel.info.descricao} - ${reabastecimento.quantidade} litros'),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Lista vazia'));
              }
          }
        },
      ),
    );
  }
}
