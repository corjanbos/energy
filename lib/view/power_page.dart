import 'package:energy2/view/power_gauge.dart';
import 'package:energy2/view/voltage_gauge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PowerPage extends ConsumerStatefulWidget {
  const PowerPage({Key? key}) : super(key: key);

  @override
  createState() => _PowerPage();
}

class _PowerPage extends ConsumerState<PowerPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return       OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait ?
          Column(
              children: const [
                Expanded(
                    flex: 1,
                    child: VoltageGauge()
                ),
                Expanded(
                    flex:1,
                    child: WattageGauge()
                )
              ]) :
          Row(
              children: const [
                Expanded(
                    flex: 1,
                    child: VoltageGauge()
                ),
                Expanded(
                    flex:1,
                    child: WattageGauge()
                )
              ]);
        }
    );
  }
}
