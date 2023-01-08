import 'package:flutter/cupertino.dart';

@immutable
class GatewayData {

  const GatewayData({required this.voltage, required this.wattage});

  double get getVoltage => voltage;
  double get getWattage => wattage;

  final double voltage;
  final double wattage;
}