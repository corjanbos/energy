import 'package:riverpod/riverpod.dart';
import '../model/gateway_data.dart';


final dataProvider =
    StateNotifierProvider<GateWayDataNotifier, GatewayData>((ref) {
  return GateWayDataNotifier();
});

class GateWayDataNotifier extends StateNotifier<GatewayData> {
  GateWayDataNotifier() : super(const GatewayData(voltage: 0.0, wattage: 0.0));

  setData({required double voltage, required double wattage}) {
    state = GatewayData(voltage: voltage, wattage: wattage);
  }

  void clear() {
    state = const GatewayData(voltage: 0.0, wattage: 0.0);
  }
}
