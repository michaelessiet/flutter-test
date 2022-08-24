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
  double xAngle = 0;
  double prevXAngle = 0;
  double yAngle = 0;
  double prevYAngle = 0;
  double zAngle = 0;
  double prevZAngle = 0;
  final double squareSize = 350;
  final streamsub = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();

    streamsub.add(accelerometerEvents.listen((event) {
      setState(() {
        prevXAngle = xAngle;
        xAngle = event.x;
        prevYAngle = yAngle;
        yAngle = double.parse(event.y.toString());
        prevZAngle = zAngle;
        zAngle = double.parse(event.z.toString());
      });
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (final sub in streamsub) {
      sub.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: TweenAnimationBuilder(
            tween: Tween(begin: prevXAngle, end: xAngle),
            duration: const Duration(milliseconds: 400),
            builder: (context, double xValue, _) {
              return TweenAnimationBuilder(
                  tween: Tween(begin: prevZAngle, end: zAngle),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, double zValue, _) {
                    return [
                      Transform(
                          origin: Offset(squareSize/2, squareSize/2),
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.003)
                            ..rotateX(-zValue / 10)
                            ..rotateY(xValue / 10),
                          child: VxBox().rounded.width(300).height(300).make()),
                      Transform(
                          origin: const Offset(150, 150),
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002)
                            ..rotateX(-zValue / 10)
                            ..rotateY(xValue / 10),
                          child: VxBox()
                              .rounded
                              .withShadow([
                                BoxShadow(
                                    color: const Color.fromARGB(106, 244, 117, 54),
                                    blurRadius: 50,
                                    spreadRadius: 5,
                                    offset: Offset(xValue * 8, zValue * 8)),
                                const BoxShadow(
                                  color: Color.fromARGB(116, 0, 0, 0),
                                  blurRadius: 20,
                                )
                              ])
                              .red400
                              .width(squareSize)
                              .height(squareSize)
                              .make())
                    ].zStack();
                  });
            }),
      )
    ]);
  }
}
