import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationcontroller;
  late AnimationController _bganimationcontroller;
  late AnimationController _playbuttoncontroller;
  int selectedTimeID = 2;
  List<int> number_list = [5, 10, 15, 30, 60];
  late IntTween animatednumber;
  bool isTimerStarted = false;

  @override
  void initState() {
    super.initState();
    _animationcontroller = AnimationController(vsync: this);
    _bganimationcontroller = AnimationController(vsync: this);
    _playbuttoncontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _animationcontroller.addListener(() {
      if (!_animationcontroller.isAnimating) {
        _bganimationcontroller.animateBack(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn);
      }
      if (_animationcontroller.isDismissed) {
        _playbuttoncontroller.reverse();
        isTimerStarted = false;
        setState(() {
          selectedTimeID = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationcontroller.dispose();
  }

  void handlePlayPressed() {
    _playbuttoncontroller.value == 0
        ? _playbuttoncontroller.forward()
        : _playbuttoncontroller.reverse();

    if (_animationcontroller.isAnimating) {
      _animationcontroller.stop();

      _bganimationcontroller.animateBack(0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);

      // _animationcontroller.value = 1;

      setState(() {
        selectedTimeID = 0;
      });
    } else {
      _animationcontroller.value = 1;
      _bganimationcontroller.value = 0;

      _animationcontroller.animateBack(0,
          duration: Duration(seconds: number_list[selectedTimeID]));

      _bganimationcontroller.animateTo(1,
          duration: Duration(seconds: number_list[selectedTimeID]));

      setState(() {
        selectedTimeID = selectedTimeID;
      });
    }
    setState(() {
      isTimerStarted = !isTimerStarted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZStack([
      VxBox().color(Colors.blueGrey[700]!).make(),
      AnimatedBuilder(
          animation: _bganimationcontroller,
          builder: ((context, child) {
            return VxBox()
                .red900
                .height(_bganimationcontroller.value *
                    MediaQuery.of(context).size.height)
                .alignBottomCenter
                .make();
          })),
      Column(
        children: [
          VxSwiper.builder(
            viewportFraction: 0.45,
            height: MediaQuery.of(context).size.height / 1.3,
            onPageChanged: (index) {
              setState(() {
                selectedTimeID = index;
              });
            },
            enableInfiniteScroll: false,
            initialPage: 2,
            itemCount: isTimerStarted ? 1 : 5,
            itemBuilder: (context, index) {
              return Center(
                  child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isTimerStarted
                    ? 9
                    : index == selectedTimeID
                        ? 9
                        : 5,
                curve: Curves.easeInOutSine,
                child: AnimatedBuilder(
                    animation: _animationcontroller,
                    builder: (context, _) {
                      return (isTimerStarted
                              ? (_animationcontroller.value *
                                      number_list[selectedTimeID])
                                  .ceil()
                              : number_list[index])
                          .toString()
                          .text
                          .white
                          .semiBold
                          .make()
                          .opacity(
                              value: isTimerStarted
                                  ? 1
                                  : index == selectedTimeID
                                      ? 1
                                      : .3);
                    }),
              ));
            },
          ),
          FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.red[500],
            foregroundColor: isTimerStarted
                ? const Color.fromARGB(255, 120, 0, 0)
                : Colors.white,
            onPressed: () => handlePlayPressed(),
            child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _playbuttoncontroller),
          )
        ],
      ),
    ]);
  }
}
