import 'dart:ffi';

import 'package:flutter/material.dart';

class PulseButton extends StatefulWidget {
  final double temperatura;

  const PulseButton(this.temperatura, {Key? key}) : super(key: key);

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    animation = Tween(begin: 5.0, end: 80.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.temperatura > 33 && animationController.isDismissed) {
      animationController.repeat(reverse: true);
    } else if (widget.temperatura < 33) {
      animationController.reverse();
    }

    if (widget.temperatura > 66 &&
        animationController.duration?.inMilliseconds == 600) {
      animationController.stop();
      animationController.duration = const Duration(milliseconds: 200);
      animationController.repeat(reverse: true);
    } else if (widget.temperatura > 33 &&
        widget.temperatura < 66 &&
        animationController.duration?.inMilliseconds == 200) {
      animationController.stop();
      animationController.duration = const Duration(milliseconds: 600);
      animationController.repeat(reverse: true);
    }

    // final color = widget.temperatura > 37.0 ? Colors.blue : Colors.red;

    var color = Colors.white;

    if (widget.temperatura < 33) {
      color = Colors.blue;
    } else if (widget.temperatura > 33 && widget.temperatura < 66) {
      color = Colors.green;
    } else if (widget.temperatura > 66) {
      color = Colors.red;
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color),
              boxShadow: [
                BoxShadow(
                  color: color,
                  blurRadius: animation.value > 0 ? 20 : 0,
                  spreadRadius: animation.value / 2,
                )
              ]),
          child: Center(
              child: Text(widget.temperatura.toStringAsPrecision(2),
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(color: color))),
        );
      },
    );
  }
}
