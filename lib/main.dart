import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Socket socket;

  double voltage = 0.0;
  double wattage = 0.0;

  void dataHandler(data){
    String dataChunk = String.fromCharCodes(data).trim();
    print(dataChunk);
    int index = dataChunk.indexOf('1-0:32.7.0(') + 11;
    print('Voltage string read ${dataChunk.substring(index, index+5)}');
    double volt = double.parse(dataChunk.substring(index, index+5));

    index = dataChunk.indexOf('1-0:21.7.0(') + 11;
    String wattageString = dataChunk.substring(index, index+6).replaceFirst('.', '');
    print('Wattage string read $wattageString');
    double watt = double.parse(wattageString);
    setState(() {
      voltage = volt;
      wattage = watt;
    });
  }

  void errorHandler(error, StackTrace trace){
    print(error);
  }

  void doneHandler(){
    print("Done Handler!");
    socket.destroy();
    exit(0);
  }

  void connect() {
    if (kIsWeb) {
      return;
    }
    try {
      print('Connecting...');
      Socket.connect("192.168.178.242", 23)
          .then((Socket sock) {
        socket = sock;
        socket.listen(dataHandler,
            onError: errorHandler,
            onDone: doneHandler,
            cancelOnError: false);
      })
          .catchError((AsyncError e) {
        print("Unable to connect: $e");
        exit(1);
      });

    } on Exception catch (e) {
      print('Connection error ${e.toString()}');
    }
  }

  @override
  void initState()  {
    connect();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 if (kIsWeb) {
   return Text('Web not supported with socket connections');
 }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
        Expanded(
          flex: 1,
          child: SfRadialGauge(
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
                  NeedlePointer(value: voltage)
                ], annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Container(
                          child: Text(voltage.toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))),
                      angle: 90,
                      positionFactor: 0.5)
                ])
              ]),
        ),
            Expanded(
              flex:1,
              child: SfRadialGauge(
                  title: const GaugeTitle(
                      text: 'Wattage',
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
                      NeedlePointer(value: wattage)
                    ], annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                              child: Text(wattage.toString(),
                                  style: const TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.bold))),
                          angle: 90,
                          positionFactor: 0.5)
                    ])
                  ]),
            )
        ])
      )
    );
  }
}
