import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:widgettest/store/store.dart';
import 'package:widgettest/widgets/pulltorefreshorsearch_widget.dart';
import 'package:widgettest/widgets/timer_widget.dart';

void main() {
  runApp(VxState(store: MyStore(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Widget Test App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // VxState.watch(context, on: [Increment]);

    // MyStore store = VxState.store;

    return const Scaffold(
      body:  TimerWidget() 
    );
  }
}
