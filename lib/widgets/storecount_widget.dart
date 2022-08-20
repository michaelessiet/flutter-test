import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:widgettest/store/store.dart';

class StoreCountWidget extends StatefulWidget {
  const StoreCountWidget({Key? key}) : super(key: key);

  @override
  State<StoreCountWidget> createState() => _StoreCountWidgetState();
}

class _StoreCountWidgetState extends State<StoreCountWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have pushed the button this many times:'),
          VxBuilder<MyStore>(
              builder: ((context, store, status) => '${store.count}'
                  .text
                  .color(Vx.randomColor)
                  .xl4
                  .bold
                  .make()),
              mutations: const {Increment}),
          FloatingActionButton(
            onPressed: () => Increment(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
