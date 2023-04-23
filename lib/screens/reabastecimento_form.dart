import 'package:flutter/material.dart';
import 'package:fuel_consumption/dao/reabastecimento_dao.dart';
import 'package:fuel_consumption/models/reabastecimento.dart';
import 'package:fuel_consumption/models/registro_abastecimento.dart';
import 'package:intl/intl.dart';

class AdicionarReabastecimentoForm extends StatefulWidget {
  const AdicionarReabastecimentoForm({Key? key}) : super(key: key);

  @override
  _AdicionarReabastecimentoFormState createState() =>
      _AdicionarReabastecimentoFormState();
}

class _AdicionarReabastecimentoFormState
    extends State<AdicionarReabastecimentoForm> {
  final _formKey = GlobalKey<FormState>();
  final _dao = ReabastecimentoDao();

  DateTime _selectedDate = DateTime.now();
  double? _quantidade;
  int? _kilometragem;
  double? _valor;
  Combustivel? _selectedCombustivel;

  void exibirMensagem(String mensagem) {
    final snackBar = SnackBar(content: Text(mensagem));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final reabastecimento = Reabastecimento(
        dataReabastecimento: _selectedDate,
        quantidade: _quantidade!,
        kilometragem: _kilometragem!,
        combustivel: _selectedCombustivel!,
        valor: _valor!,
      );
      final resultado = await _dao.insert(reabastecimento);
      // Navigator.pop(context); // Fecha o formulário
      if (resultado != null) {
        exibirMensagem('Registro incluído com sucesso');
        _formKey.currentState!.reset();
      } else {
        exibirMensagem('Houve um erro ao incluir o registro');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Reabastecimento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Data do reabastecimento',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2015, 1),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Quantidade de litros',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma quantidade válida';
                    }
                    try {
                      _quantidade = double.parse(value);
                      return null;
                    } catch (e) {
                      return 'Por favor, insira uma quantidade válida';
                    }
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  decoration: InputDecoration(
                    labelText: 'Kilometragem',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma kilometragem válida';
                    }
                    try {
                      _kilometragem = int.parse(value);
                      return null;
                    } catch (e) {
                      return 'Por favor, insira uma kilometragem válida';
                    }
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<Combustivel>(
                  value: _selectedCombustivel,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCombustivel = newValue!;
                    });
                  },
                  items: Combustivel.values.map((combustivel) {
                    return DropdownMenuItem<Combustivel>(
                      value: combustivel,
                      child: Text(combustivel.info.descricao),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Combustível',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  decoration: InputDecoration(
                    labelText: 'Valor',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um valor válido';
                    }
                    try {
                      _valor = double.parse(value);
                      return null;
                    } catch (e) {
                      return 'Por favor, insira um valor válido';
                    }
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Adicionar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
