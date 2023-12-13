import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  final appGroupId = "group.namtn.home_widget";
  final iOSWidgetName = "HomeWidgetIOS";

  @override
  void initState() {
    HomeWidget.setAppGroupId(appGroupId);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_handleAction);
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then((value) => _handleAction);
  }

  void _handleAction(Uri? uri) {
    if (uri?.host == "home_widget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MyHomePage2(),
        ),
      );
    }
  }

  Future _sendAndUpdate() async {
    try {
      return Future.wait([
        HomeWidget.renderFlutterWidget(
          const Icon(
            Icons.flutter_dash,
            size: 200,
          ),
          logicalSize: const Size(200, 200),
          key: 'widgetImage',
        ),
        HomeWidget.updateWidget(
          iOSName: iOSWidgetName,
        ),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: _sendAndUpdate,
        child: const Text('Button'),
      ),
    ));
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key});

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Home Widget'),
      ),
      body: const Center(
        child: Text(
          'Home Widget Screen 2',
        ),
      ),
    );
  }
}
