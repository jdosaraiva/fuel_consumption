import 'package:flutter/material.dart';
import 'package:fuel_consumption/screens/consumo_widget.dart';
import 'package:fuel_consumption/screens/line_chart_page.dart';

class GraficosConsumoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: const ConsumoCombustivelWidget(),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: const LineChartPage(title: 'Consumo de Combustível'),
            ),
          ),
        ],
      ),
    );
  }

}