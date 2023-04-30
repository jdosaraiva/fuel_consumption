import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartPage extends StatefulWidget {
  const LineChartPage({super.key, required this.title});

  final String title;

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  final List<ChartData> _dataSource = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dataSource.add(ChartData('04/01/2023', 13.8));
    _dataSource.add(ChartData('12/01/2023', 12.7));
    _dataSource.add(ChartData('24/01/2023', 13.7));
    _dataSource.add(ChartData('03/02/2023', 10.9));
    _dataSource.add(ChartData('11/02/2023', 13));
    _dataSource.add(ChartData('20/02/2023', 13));
    _dataSource.add(ChartData('03/03/2023', 15));
    _dataSource.add(ChartData('14/03/2023', 14.4));
    _dataSource.add(ChartData('24/03/2023', 8.4));
    _dataSource.add(ChartData('07/04/2023', 13.9));
    _dataSource.add(ChartData('18/04/2023', 12.8));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        //Initialize chart
          child: SfCartesianChart(
            // Chart title text
              title: ChartTitle(
                  text: 'Gráfico do Consumo em km/l'
              ),
              // Initialize category axis
              primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Data do Reabastecimento'),
                  labelRotation: -60),
              primaryYAxis: CategoryAxis(
                  minimum: 6.0,
                  title: AxisTitle(text: 'km/l')
              ),
              legend: Legend(
                isVisible: true,
              ),
              series: <ChartSeries>[
                // Initialize line series
                LineSeries<ChartData, String>(
                    name: 'Consumo',
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    dataSource: _dataSource,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y),
              ])),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double? y;
}
