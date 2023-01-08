import 'dart:io';

import 'package:energy2/controller/data_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../model/app_settings.dart';
import '../main.dart';

Socket? socket;

final settingsProvider =
    StateNotifierProvider.autoDispose<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier(ref);
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  StateNotifierProviderRef<AppSettingsNotifier, AppSettings> ref;

  AppSettingsNotifier(this.ref) : super(const AppSettings(url: '')) {
    log.info('AppSettingsNotifier');
    try {
      String? gatewayIp = sharedPreferences.getString('gatewayserver');
      if (gatewayIp != null && gatewayIp.isNotEmpty) {
        log.info('Retrieved locally saved server ip: $gatewayIp');
        state = AppSettings(url: gatewayIp);
        setUrl(gatewayIp);
      }
    } on Exception {
      log.shout('AppSettingsNotifier exception!');
      state = const AppSettings(url: '');
    }
  }

  setUrl(String value) async {
    if (socket != null) {
      socket!.destroy();
    }

    log.info('Connecting to $value...');
    try {
      socket = await Socket.connect(value, 23);
      log.info(('Connected'));
      sharedPreferences.setString('gatewayserver', value);
      socket!.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      state = AppSettings(url: value);
    } on Exception {
      log.severe('Could not connect to $value');
      ref.read(dataProvider.notifier).clear();
      state =  AppSettings(url: value);
    }
  }

  void dataHandler(data) {
    String dataChunk = String.fromCharCodes(data).trim();
    int index = dataChunk.indexOf('1-0:32.7.0(') + 11;
    log.fine('Voltage string read ${dataChunk.substring(index, index + 5)}');
    double volt = double.parse(dataChunk.substring(index, index + 5));

    index = dataChunk.indexOf('1-0:21.7.0(') + 11;
    String wattageString =
    dataChunk.substring(index, index + 6).replaceFirst('.', '');
    log.fine('Wattage string read $wattageString');
    double watt = double.parse(wattageString);
    ref.read(dataProvider.notifier).setData(voltage: volt, wattage: watt);
  }

  void errorHandler(error, StackTrace trace) {
    log.warning('Socket error: $error');
  }

  void doneHandler() {
    log.info('Socket closed.');
  }

  getUrl() {
    state.getUrl;
  }

  close() {
    if (socket != null) {
      socket!.destroy();
    }
  }
}
