import 'package:energy2/controller/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class VoltageGauge extends ConsumerStatefulWidget {
  const VoltageGauge({Key? key}) : super(key: key);

  @override
  VoltageGaugeState createState() => VoltageGaugeState();
}

class VoltageGaugeState extends ConsumerState<VoltageGauge> {

  @override
  Widget build(BuildContext context) {

    return SfRadialGauge(
        title: const GaugeTitle(
            text: 'Voltage',
            textStyle:
            TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 300, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 100,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 100,
                endValue: 200,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 200,
                endValue: 300,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10)
          ], pointers: <GaugePointer>[
            NeedlePointer(value: ref.watch(dataProvider).getVoltage)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Text(ref.watch(dataProvider).getVoltage.toString(),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]);
  }
}
