
import 'package:energy2/view/info_page.dart';
import 'package:energy2/view/power_page.dart';
import 'package:energy2/view/settings_page.dart';
import 'package:energy2/controller/settings_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Logger log = Logger('Energy2');

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  Logger.root.level = Level.INFO;

  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String title = 'Realtime power consumption';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {

  static final List<Widget> _pages = <Widget>[
    const PowerPage(),
    const EnergySettings(),
    const InfoPage(),
  ];

  int _selectedIndex = 0;

  @override
  void initState()  {
    super.initState();
  }

  @override
  void dispose() {
    log.info('Application closing...');
    ref.read(settingsProvider.notifier).close();
    log.info('Closing socket');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log.fine('Building main...');
    if (kIsWeb) {
      return const Text('Web not supported with socket connections');
    }

    if (ref.watch(settingsProvider).getUrl.isEmpty) {
      log.info('redirecting to settings page because Gateway address is empty');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EnergySettings()));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title, style: const TextStyle(fontSize: 18))),
      ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.power),
              label: 'Power',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Info',
            ),
          ],
        ),
      body: _pages.elementAt(_selectedIndex),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
