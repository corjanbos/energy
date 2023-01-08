import 'package:dio/dio.dart';
import 'package:energy2/controller/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/gateway_settings.dart';

class EnergySettings extends ConsumerStatefulWidget {
  const EnergySettings({Key? key}) : super(key: key);

  @override
  createState() => _EnergySettingsState();
}

class _EnergySettingsState extends ConsumerState<EnergySettings> {

  final TextEditingController controller = TextEditingController();
  late Future<GatewaySettings> gatewaySetting;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.text = ref.read(settingsProvider).getUrl;
    Future<Response> response = Dio().get('http://${controller.text}:82/warmtelink/api/read');
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            const Expanded(
                flex: 1,
                child: Text('Gateway info', style: TextStyle(fontWeight: FontWeight.bold),)
            ),
            Expanded(flex: 3, child:
              FutureBuilder<Response>(
              future: response,
              builder: (
                  BuildContext context,
                  AsyncSnapshot<Response> snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Connection error, please check ip address below', style: TextStyle(fontSize: 12, color: Colors.red)));
                  } else if (snapshot.hasData) {
                    Map<String, dynamic> jsonData = snapshot.data!.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Address: ${jsonData['mac_address'] ?? ''}', style: const TextStyle(fontSize: 14)),
                        Text('Model: ${jsonData['gateway_model'] ?? ''}', style: const TextStyle(fontSize: 14)),
                        Text('Update available: ${jsonData['firmware_update_available'] == 'false' ? 'No' : 'Yes'}', style: const TextStyle(fontSize: 14)),

                      ],
                    );
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),),
            const Expanded(
                flex: 1,
                child: Text('Gateway ip address', style: TextStyle(fontWeight: FontWeight.bold))
            ),
            Expanded(
              flex: 3, child: SizedBox(width: 300, child: TextField(autofocus: false, controller: controller, enabled: true, scribbleEnabled: true,decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Please enter gateway ip address',
                      ), inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))]),
                    )
                  ),
            Expanded(flex: 4, child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(onPressed: () {
                ref.read(settingsProvider.notifier).setUrl(controller.text.trim());
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));
              }, child: const Text(' Save '),),
            ))),
            const Expanded(flex: 4, child: SizedBox()),

          ],
      ),
    );
  }
}
