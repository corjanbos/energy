import 'package:flutter/cupertino.dart';

@immutable
class AppSettings {

  const AppSettings({required this.url});

  String get getUrl => url;

  final String url;
}