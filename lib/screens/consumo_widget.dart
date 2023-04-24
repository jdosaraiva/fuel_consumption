import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuel_consumption/utils.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ConsumoCombustivelWidget extends StatefulWidget {
  ConsumoCombustivelWidget({Key? key}) : super(key: key);

  @override
  _ConsumoCombustivelWidgetState createState() =>
      _ConsumoCombustivelWidgetState();
}

class _ConsumoCombustivelWidgetState extends State<ConsumoCombustivelWidget> {
  final format = NumberFormat('0.0');
  double _consumo = 11.0;

  final _consumoStreamController = StreamController<double>();

  Stream<double> get consumoStream => _consumoStreamController.stream;

  @override
  void initState() {
    super.initState();
    atualizaConsumo();
  }

  @override
  void dispose() {
    _consumoStreamController.close();
    super.dispose();
  }

  void atualizaConsumo() async {
    double novoConsumo = await calculaConsumo();
    setState(() {
      _consumo = novoConsumo;
    });
    _consumoStreamController.add(novoConsumo);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: StreamBuilder<double>(
              stream: consumoStream,
              initialData: _consumo,
              builder: (context, snapshot) {
                return SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0.0,
                      maximum: 25.0,
                      pointers: <GaugePointer>[
                        NeedlePointer(value: snapshot.data ?? _consumo),
                      ],
                      ranges: [
                        GaugeRange(
                          startValue: 0,
                          endValue: 10.4,
                          color: Colors.red,
                          startWidth: 10,
                          endWidth: 10,
                        ),
                        GaugeRange(
                          startValue: 10.4,
                          endValue: 15.6,
                          color: Colors.green,
                          startWidth: 10,
                          endWidth: 10,
                        ),
                        GaugeRange(
                          startValue: 15.6,
                          endValue: 25,
                          color: Colors.tealAccent,
                          startWidth: 10,
                          endWidth: 10,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          angle: 90,
                          positionFactor: 0.5,
                          widget: Container(
                            child: Text(
                              '${format.format(snapshot.data ?? _consumo)} km/l',
                              style: const TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  title: const GaugeTitle(
                    text: "Consumo Atual",
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
