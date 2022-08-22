import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ParallaxNFT extends StatefulWidget {
  const ParallaxNFT({Key? key}) : super(key: key);

  @override
  State<ParallaxNFT> createState() => _ParallaxNFTState();
}

class _ParallaxNFTState extends State<ParallaxNFT>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  double xAngle = 0;
  double yAngle = 0;
  double zAngle = 0;
  final streamsub = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    streamsub.add(accelerometerEvents.listen((event) {
      setState(() {
        xAngle = event.x;
        yAngle = double.parse(event.y.toString());
        zAngle = double.parse(event.z.toString());
      });
      if (xAngle.sign == -1) {
        _controller2.animateTo((xAngle * -1 / 10),
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOut);
      } else {
        _controller2.animateTo((xAngle / 10),
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOut);
      }
      if (zAngle.sign == -1) {
        _controller.animateTo((zAngle * -1 / 20),
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut);
      } else {
        _controller.animateTo((zAngle / 20),
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut);
      }
    }));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    for (final sub in streamsub) {
      sub.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return AnimatedBuilder(
              animation: _controller2,
              builder: (context, _) {
                return Transform(
                  origin: const Offset(150, 0),
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .001)
                    ..rotateX(zAngle.sign == -1
                        ? _controller.value
                        : -_controller.value)
                    ..rotateY(xAngle.sign == -1
                        ? _controller2.value
                        : -_controller2.value),
                  child: VxBox().rounded.shadow3xl.red100.width(300).height(300).make(),
                );
              });
        },
      ),
    );
  }
}
