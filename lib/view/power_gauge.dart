import 'package:energy2/controller/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WattageGauge extends ConsumerStatefulWidget {
  const WattageGauge({Key? key}) : super(key: key);

  @override
  WattageGaugeState createState() => WattageGaugeState();
}

class WattageGaugeState extends ConsumerState<WattageGauge> {
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
        title: const GaugeTitle(
            text: 'Power',
            textStyle:
            TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 5000, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 1000,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 1000,
                endValue: 2500,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 2500,
                endValue: 5000,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10)
          ], pointers: <GaugePointer>[
            NeedlePointer(value: ref.watch(dataProvider).getWattage)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Text(ref.watch(dataProvider).getWattage.toString(),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]);
  }
}
