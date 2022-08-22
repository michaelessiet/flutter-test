import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:velocity_x/velocity_x.dart';

class PullToRefreshWidget extends StatefulWidget {
  const PullToRefreshWidget({Key? key}) : super(key: key);

  @override
  State<PullToRefreshWidget> createState() => _PullToRefreshWidgetState();
}

class _PullToRefreshWidgetState extends State<PullToRefreshWidget>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  Control animationControl = Control.stop;
  double positionOffset = -20;
  double searchRadius = 50;
  double refreshRadius = 50;
  Color searchColor = Colors.blue[200]!;
  Color refreshColor = Colors.blue[200]!;
  bool searchVisible = false;
  late FocusNode searchFocusNode;

  GlobalKey circlekey = GlobalKey();
  GlobalKey searchCircleKey = GlobalKey();

  List<ListTile> liststuff = List.generate(Random().nextInt(20), (index) {
    return ListTile(
      leading: 'item $index'.text.make(),
    );
  });

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    searchFocusNode.dispose();
  }

  void handleSwipeGesture(PointerMoveEvent event) {
    if (event.position.dx > 200) {
      if (_scrollController.offset < -20) {
        setState(() {
          searchRadius = 70;
          searchColor = Colors.blue[600]!;
          refreshColor = Colors.blue[200]!;
          refreshRadius = 50;
          animationControl = Control.play;
        });
      }
    } else {
      if (_scrollController.offset < -20) {
        setState(() {
          refreshRadius = 70;
          refreshColor = Colors.blue[600]!;
          searchColor = Colors.blue[200]!;
          searchRadius = 50;
          animationControl = Control.playReverse;
        });
      }
    }
  }

  void handleGestureOver(PointerUpEvent event) {
    if (searchRadius == 70) {
      setState(() {
        searchVisible = true;
        searchRadius = 50;
      });
      searchFocusNode.requestFocus();
    } else {
      setState(() {
        searchVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: VxScrollVertical(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        child: ZStack([
          Listener(
            onPointerMove: (event) => handleSwipeGesture(event),
            onPointerUp: (event) => handleGestureOver(event),
            child: VxBox(
                child: HStack([
              const Icon(Icons.inbox, size: 46, color: Colors.blue),
              'Inbox'.text.xl4.semiBold.make()
            ])).alignTopLeft.p12.height(4000).make(),
          ),
          Positioned(
            top: -100,
            child: HStack(
              [
                VxCircle(
                  key: circlekey,
                  backgroundColor: refreshColor,
                  radius: refreshRadius,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
                VxBox().width(40).make(),
                VxCircle(
                  key: searchCircleKey,
                  backgroundColor: searchColor,
                  radius: searchRadius,
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )
              ],
              alignment: MainAxisAlignment.center,
            ).w(MediaQuery.of(context).size.width),
          ),
          CustomAnimationBuilder(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutCirc,
              tween: AlignmentTween(
                  begin: Alignment.centerLeft, end: Alignment.centerRight),
              control: animationControl,
              builder: ((context, AlignmentGeometry value, child) {
                return Container(
                        alignment: value,
                        width: 131,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.blue,
                          size: 40,
                        ))
                    .centered()
                    .w(MediaQuery.of(context).size.width)
                    .positioned(top: -30);
              })),
          Visibility(
                  visible: searchVisible,
                  maintainAnimation: true,
                  maintainSize: true,
                  maintainState: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoSearchTextField(
                        focusNode: searchFocusNode,
                        backgroundColor: Colors.white,
                      ).p12(),
                      'Recents'.text.medium.make().px20(),
                      VxBox()
                          .height(50)
                          .width(double.infinity)
                          .color(Colors.white)
                          .make()
                          .cornerRadius(6)
                          .p16(),
                      VxBox()
                          .height(50)
                          .width(double.infinity)
                          .color(Colors.white)
                          .make()
                          .cornerRadius(6)
                          .p16(),
                    ],
                  )
                      .h32(context)
                      .backgroundColor(Colors.grey[300])
                      .cornerRadius(16))
              .p12(),
        ]),
      ),
    );
  }
}
